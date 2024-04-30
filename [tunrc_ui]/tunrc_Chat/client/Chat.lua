Chat = {}

local PROPERTY_SHOW_CHAT = "ui.draw_chat"

local MAX_CHAT_HISTORY = 500
local MAX_CHAT_LINES = 10
local MAX_VISIBLE_TABS = 6
local MAX_TAB_WIDTH = 72
local MAX_LINE_LENGTH = 80
local TAB_PADDING = 10
local UI = exports.tunrc_UI

local MESSAGES_RT_SIZE = Vector2(650, 600)

local forceVisible = false
local isVisible = true
local chatTabs = {}
local activeTabName
local highlightedTabName
local screenSize = Vector2(guiGetScreenSize())
local chatHistoryCurrent
local chatRenderTarget

function Chat.removeTab(name)
	if type(name) ~= "string" then
		outputDebugString("Chat.removeTab: Expected string, got " .. tostring(type(name)))
		return false
	end
	local tab, index = Chat.getTabFromName(name)
	if not tab then
		outputDebugString("Chat.removeTab: No such tab: " .. tostring(name))
		return false
	end
	if tab.unremovable then
		outputDebugString("Chat.removeTab: Tab '" .. tostring(name) .. "' is unremovable")
		return false
	end
	table.remove(chatTabs, index)
	if name == activeTabName then
		if #chatTabs > 0 then
			activeTabName = chatTabs[1].name
		else
			activeTabName = nil
		end
	end

	Chat.redrawMessages()
end

function Chat.getTabFromName(name)
	if type(name) ~= "string" then
		return false
	end
	for i, tab in ipairs(chatTabs) do
		if tab.name == name then
			return tab, i
		end
	end
end

function Chat.setTabTitle(name, title)
	if type(name) ~= "string" or type(title) ~= "string" then
		return false
	end
	local tab = Chat.getTabFromName(name)
	if not tab then
		return false
	end
	tab.title = title
	return true
end

function Chat.createTab(name, title, unremovable)
	if Chat.getTabFromName(name) then
		outputDebugString("Chat: tab '" .. tostring(name) .. "' already exists")
		return false
	end
	local tab = {
		name = name,
		title = exports.tunrc_Utils:removeHexFromString(title),
		unremovable = not not unremovable,
		messages = {}
	}
	if not activeTabName then
		activeTabName = name
	end
	table.insert(chatTabs, tab)
	outputDebugString("Chat.createTab: '" .. tostring(name) .. "' Unremovable: " .. tostring(tab.unremovable))

	Chat.redrawMessages()
end

function Chat.message(tabName, text, r, g, b, colorCoded)
	if type(tabName) ~= "string" or type(text) ~= "string" then
		return false
	end
	local tab = Chat.getTabFromName(tabName)
	if not tab then
		return false
	end

	local color
	if r and g and b then
		color = tocolor(r, g, b)
	end
	if colorCoded == nil then
		colorCoded = true
	else
		colorCoded = not not colorCoded
	end

	-- удаление переносов строк
	text = utf8.gsub(text, "\n", " ")

	-- перенос строки
	local rest
	local textWithoutColors = utf8.gsub(text, "#%x%x%x%x%x%x", "")
	if utf8.len(textWithoutColors) > MAX_LINE_LENGTH then
		local colorsLength = #text - #textWithoutColors
		local foundSpace = false
		local spaceStart = MAX_LINE_LENGTH + colorsLength
		local spaceEnd = spaceStart - 20

		for i = spaceStart, spaceEnd, -1 do
			local c = utf8.sub(text, i, i)
			if c == ' ' then
				foundSpace = true
				rest = utf8.sub(text, i + 1, -1)
				text = utf8.sub(text, 1, i - 1)
				break
			end
		end
		-- если пробела нет, текст переносится принудительно
		if not foundSpace then
			rest = utf8.sub(text, MAX_LINE_LENGTH + colorsLength + 1, -1)
			text = utf8.sub(text, 1, MAX_LINE_LENGTH + colorsLength)
		end
		-- перенос цвета на следующую строку
		local match = pregMatch(text, "(#[0-9A-F]{6})")
		if match then
			rest = match[#match] .. rest
		end
		textWithoutColors = utf8.gsub(text, "#%x%x%x%x%x%x", "")
	end

	-- сообщение
	local message = {
		text = text,
		textWithoutColors = textWithoutColors,
		timestamp = getRealTime().timestamp,
		color = color,
		colorCoded = colorCoded
	}

	-- удалить самое старое сообщение при достижении лимита истории
	if #tab.messages >= MAX_CHAT_HISTORY then
		table.remove(tab.messages, 1)
	end
	-- добавление сообщения
	table.insert(tab.messages, message)

	-- отправить перенесённую часть сообщения
	if rest and utf8.len(rest) > 0 then
		Chat.message(tabName, rest, r, g, b, colorCoded)
	end

	Chat.redrawMessages()
end

function Chat.setActiveTab(name)
	if type(name) ~= "string" then
		return
	end
	if name == activeTabName then
		return false
	end
	if Chat.getTabFromName(name) then
		activeTabName = name
		chatHistoryCurrent = nil
		Chat.redrawMessages()
		return true
	end
end

local function drawMessages()
	local tab = Chat.getTabFromName(activeTabName)
	if not tab then
		return
	end
	local messages = tab.messages
	local messageCount = #messages

	local j = MAX_CHAT_LINES - 1

	local endIndex
	if chatHistoryCurrent then
		endIndex = chatHistoryCurrent
	else
		endIndex = messageCount
	end
	local firstIndex = math.max(1, endIndex - MAX_CHAT_LINES + 1)

	for i = endIndex, firstIndex, -1 do
		local message = messages[i]
		local text = message.text
		local textWithoutColors = message.textWithoutColors

		if exports.tunrc_Config:getProperty("chat.timestamp") then
			local time = getRealTime(message.timestamp, true)
			local timeString = ("[%02d:%02d:%02d] "):format(time.hour, time.minute, time.second)
			text = timeString .. text
			textWithoutColors = timeString .. textWithoutColors
		end

		dxDrawText(textWithoutColors, 1, 1 + j * 20, 0, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, false, false, false, true)
		dxDrawText(text, 0, j * 20, 0, 0, message.color, 1.0, "default-bold", "left", "top", false, false, false, message.colorCoded, true)
		j = j - 1
	end
end

-- Создание табов чата

addEventHandler("onClientResourceStart", resourceRoot, function ()
		TabPanel = UI:createTrcRoundedRectangle {
			x       = 28,
			y       = 13,
			width   = 60,
			height  = 30,
			radius = 10,
			color = tocolor(220, 220, 220),
			hover = true,
			hoverColor = tocolor(130, 130, 200),
			darkToggle = true,
			darkColor = tocolor(50, 50, 50),
			hoverDarkColor = tocolor(30, 30, 30),
			shadow = true
			}
		UI:addChild(TabPanel)
		
		local TabTitle = UI:createDpLabel {
		x = 30,
		y = 2,
		width = 0,
		height = 0,
		text = "TunedRacers",
		alignX = "center",
		color = tocolor (50, 50, 50, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "lightSmall"
	}
	UI:addChild(TabPanel, TabTitle)
	UIDataBinder.bind(TabTitle, "activeTab", function (value)
		if Chat.getActiveTab() == "global" then
			return exports.tunrc_Lang:getString("chat_tab_all")
		elseif Chat.getActiveTab() == "local" then
			return	exports.tunrc_Lang:getString("chat_tab_local")
		elseif Chat.getActiveTab() == "illegal" then
			return	exports.tunrc_Lang:getString("chat_tab_illegal")
		end
	end)

end)

function drawInput()
	if not Input.isActive() then
		return
	end
	local text = exports.tunrc_Lang:getString("chat_input_message") .. ": " .. Input.getText()
	local right = 32 + dxGetTextWidth(utf8.sub(text, 1, 96), 1, "default-bold")
	dxDrawText(text, 33, 57 + MAX_CHAT_LINES * 20, right + 1, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, true, false, false, true)
	dxDrawText(text, 32, 56 + MAX_CHAT_LINES * 20, right, 0, 0xFFFFFFFF, 1.0, "default-bold", "left", "top", false, true, false, false, true)
end

function Chat.redrawMessages()
	if isElement(chatRenderTarget) then
		dxSetRenderTarget(chatRenderTarget, true)
		dxSetBlendMode("modulate_add")

		drawMessages()

		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
end

function Chat.historyUp()
	if not isVisible then
		return false
	end

	local tab = Chat.getTabFromName(activeTabName)
	if #tab.messages == 0 then
		return false
	end

	if chatHistoryCurrent == nil then
		chatHistoryCurrent = math.max(1, #tab.messages - MAX_CHAT_LINES / 2)
	elseif chatHistoryCurrent == 1 then
		return false
	else
		chatHistoryCurrent = math.max(1, chatHistoryCurrent - MAX_CHAT_LINES / 2)
	end
	Chat.redrawMessages()
	return true
end

function Chat.historyDown()
	if not isVisible then
		return false
	end

	local tab = Chat.getTabFromName(activeTabName)
	if #tab.messages == 0 then
		return false
	end

	if type(chatHistoryCurrent) == "number" then
		chatHistoryCurrent = math.min(#tab.messages, chatHistoryCurrent + MAX_CHAT_LINES / 2)
		if chatHistoryCurrent == #tab.messages then
			chatHistoryCurrent = nil
		end
	else
		return false
	end
	Chat.redrawMessages()
	return true
end

function Chat.getActiveTab()
	return activeTabName
end

function Chat.clearTab(name)
	local tab = Chat.getTabFromName(name)
	if not tab then
		return
	end
	tab.messages = {}
	Chat.redrawMessages()
	return false
end

function drawchat ()
	if not isVisible then
		return
	end
	dxDrawImage(32, 56, MESSAGES_RT_SIZE, chatRenderTarget)
	drawInput()
	UIDataBinder.refresh()
end
addEventHandler("onClientRender", root, drawchat)

function Chat.setVisible(visible)
	visible = not not visible

	if visible == isVisible then
		return false
	end

	if not visible then
		Input.close()
	end

	isVisible = visible
	
	UI:setVisible(TabPanel, visible)
end

function Chat.isVisible()
	return isVisible
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	showChat(false)
	chatRenderTarget = DxRenderTarget(MESSAGES_RT_SIZE, true)
	Chat.setVisible(exports.tunrc_Config:getProperty(PROPERTY_SHOW_CHAT))
end)

addEventHandler("onClientRestore", root, function (didClearRenderTargets)
	Chat.redrawMessages()
end)

bindKey("pgup", "down", Chat.historyUp)
bindKey("pgdn", "down", Chat.historyDown)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == TabPanel then
	
		if Chat.getActiveTab() == "global" then
			return Chat.setActiveTab("local")
		elseif Chat.getActiveTab() == "local" then
			return	Chat.setActiveTab("illegal")
		elseif Chat.getActiveTab() == "illegal" then
			return	Chat.setActiveTab("global")
		end
		
	end
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
    if key == PROPERTY_SHOW_CHAT then
		Chat.setVisible(value)
	end
end)
