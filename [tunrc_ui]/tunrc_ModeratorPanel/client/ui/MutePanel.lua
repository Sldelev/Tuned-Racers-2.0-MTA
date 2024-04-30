MutePanel = {}
local UI = exports.tunrc_UI
local screenWidth, screenHeight = UI:getScreenSize()
local ui = {}

local panelWidth = 300
local panelHeight = 300

local isVisible = false
local targetPlayer

local selectedDuration = 1

local durationButtons = {
	{ text = "5 мин", 	duration = 60 * 5 },
	{ text = "30 мин", 	duration = 60 * 30 },
	{ text = "1 час", 	duration = 60 * 60 },
	{ text = "3 часа", 	duration = 60 * 60 * 3 },
	{ text = "24 часа", 	duration = 60 * 60 * 24 },
	{ text = "Другое", 	duration = 0 }
}

local function redrawDurationButtons()
	for i, b in ipairs(durationButtons) do
		if i == selectedDuration then
			UI:setType(b.button, "primary")
			if b.duration == 0 then
				UI:setVisible(ui.timeInput, true)
			else
				UI:setVisible(ui.timeInput, false)
			end
		else
			UI:setType(b.button, "default_dark")
		end
	end
end

function MutePanel.show(player)
	if not isElement(player) then
		return 
	end
	targetPlayer = player
	if isVisible or localPlayer:getData("activeUI") then
		return
	end
	isVisible = true
	UI:setText(ui.infoLabel, "Mute player " .. exports.tunrc_Utils:removeHexFromString(player:getData("username")))
	showCursor(true)
	UI:setVisible(ui.panel, true)

	selectedDuration = 1
	redrawDurationButtons()
	localPlayer:setData("activeUI", "moderatorPanel")
	exports.tunrc_UI:fadeScreen(true)
end

function MutePanel.hide()
	if not isVisible then
		return false
	end
	isVisible = false
	targetPlayer = nil
	showCursor(false)
	UI:setVisible(ui.panel, false)
	localPlayer:setData("activeUI", false)
	exports.tunrc_UI:fadeScreen(false)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = UI:createTrcRoundedRectangle {
		x = (screenWidth - panelWidth) / 2,
		y = (screenHeight - panelHeight) / 2,
		width = panelWidth,
		height = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(ui.panel)
	UI:setVisible(ui.panel, false)

	ui.infoLabel = UI:createDpLabel {
		x = 0 , y = 10,
		width = panelWidth, height = 50,
		text = "",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultSmall",
		alignX = "center"
	}
	UI:addChild(ui.panel, ui.infoLabel)

	-- Выбор времени
	for i, b in ipairs(durationButtons) do
		local y = 50 + math.floor((i - 1) / 3) * 40	
		b.button = UI:createTrcRoundedRectangle {
			x = 15 + ((i - 1) % 3) * (panelWidth - 20) / 3,
			y = y,
			width = (panelWidth - 20) / 3 - 10,
			height = 30,
			radius = 10,
			color = tocolor(200, 205, 210),
			hover = true,
			hoverColor = tocolor(130, 130, 200),
			darkToggle = true,
			darkColor = tocolor(50, 50, 50),
			hoverDarkColor = tocolor(30, 30, 30),
			shadow = true
		}
		UI:addChild(ui.panel, b.button)
		
		b.buttonLabel = UI:createDpLabel {
			x = UI:getWidth(b.button) / 2,
			y = UI:getHeight(b.button) / 2,
			width = 0,
			height = 0,
			text = durationButtons[i].text,
			fontType = "defaultSmall",
			color = tocolor (0, 0, 0),
			darkToggle = true,
			darkColor = tocolor(255, 255, 255),
			alignX = "center",
			alignY = "center"
		}
		UI:addChild(b.button, b.buttonLabel)
	end
	
	local buttonsHeight = 50
	-- Ввод времени
	ui.timeInput = UI:createDpInput({
		x = 10,
		y = panelHeight - buttonsHeight - 125,
		width = panelWidth - 20,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "Время в минутах"
	})
	UI:addChild(ui.panel, ui.timeInput)
	UI:setVisible(ui.timeInput, false)

	-- Ввод причины
	ui.reasonInput = UI:createDpInput({
		x = 10,
		y = panelHeight - buttonsHeight - 75,
		width = panelWidth - 20,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "Введите причину..."
	})
	UI:addChild(ui.panel, ui.reasonInput)
	-- Кнопка "Отмена"	
	ui.cancelButton = UI:createTrcRoundedRectangle {
		x = 10,
		y = panelHeight - buttonsHeight - 10,
		width = panelWidth / 2 - 20,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "moderatorpanel_close"
	}
	UI:addChild(ui.panel, ui.cancelButton)
	
	ui.acceptButton = UI:createTrcRoundedRectangle {
		x = panelWidth / 2 + 10,
		y = panelHeight - buttonsHeight - 10,
		width = panelWidth / 2 - 20,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "moderatorpanel_accept"
	}
	UI:addChild(ui.panel, ui.acceptButton)
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == ui.acceptButton then
		local button = durationButtons[selectedDuration]
		if not button then
			return
		end
		local duration = button.duration
		if not duration then
			return
		end
		if duration == 0 then
			duration = tonumber(UI:getText(ui.timeInput))
			if not duration then
				return
			end
			duration = duration * 60
		end
		local reason = UI:getText(ui.reasonInput)
		triggerServerEvent("tunrc_Admin.executeCommand", resourceRoot, "mute", targetPlayer, duration, reason)
		MutePanel.hide()
	elseif widget == ui.cancelButton then
		MutePanel.hide()
		Panel.show()
	else
		for i, b in ipairs(durationButtons) do
			if widget == b.button then
				selectedDuration = i
				redrawDurationButtons()
			end
		end
	end
end)