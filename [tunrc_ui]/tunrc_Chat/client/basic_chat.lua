-- Расстояние, на котором видны локальные сообщения
local MAX_MESSAGE_DISTANCE = 100
-- Цвет сообщений при наибольшем расстоянии; 0 - черный, 1 - белый
local MIN_BRIGHTNESS = 0.4

local langTitles = {
	ru = "chat_tab_russian"
}

local function getLang()
	local lang = localPlayer:getData("langChat")
	if not lang or string.upper(lang) == "O1" then
		lang = "en"
	end
	return lang
end

local function setupLangTabTitle()
	local lang = getLang()
	local title = string.upper(lang)
	if langTitles[lang] then
		title = exports.tunrc_Lang:getString(langTitles[lang])
	end
	Chat.setTabTitle("lang", title)
end

local function setupGlobalTabTitle()
	Chat.setTabTitle("global", exports.tunrc_Lang:getString("chat_tab_global"))
end

local function setupLocalTabTitle()
	Chat.setTabTitle("local", exports.tunrc_Lang:getString("chat_tab_local"))
end

local function setupGlobalTabTitle()
	Chat.setTabTitle("illegal", exports.tunrc_Lang:getString("chat_tab_illegal"))
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Chat.createTab("global", "Global", true)
	setupGlobalTabTitle()

	Chat.createTab("local", "Local", true)
	setupLocalTabTitle()
	
	Chat.createTab("illegal", "Illegal", true)
	setupGlobalTabTitle()

	if getLang() ~= "en" then
		Chat.createTab("lang", "Lang", true)
		setupLangTabTitle()
	end

	-- Chat.createTab("web", "Web", true)
end)

addEvent("tunrc_Chat.message", true)
addEventHandler("tunrc_Chat.message", root, function (tabName, message)
	if tabName == "global" or tabName == "lang" or tabName == "local" or tabName == "web" or tabName == "illegal" then
		if localPlayer:getData("isMuted") then
			Chat.message(tabName, "#FF0000" .. exports.tunrc_Lang:getString("chat_message_muted"))
			return
		end
		if AntiFlood.isMuted() then
			AntiFlood.onMessage()
			Chat.message(tabName, "#FF0000" .. exports.tunrc_Lang:getString("chat_message_dont_flood"))
			return
		end
		triggerServerEvent("tunrc_Chat.broadcastMessage", root, tabName, message)
		AntiFlood.onMessage()
	end
end)

local function getColorFromDistance(distance, r, g, b)
	local multiplier = MIN_BRIGHTNESS + math.min(1 - distance / MAX_MESSAGE_DISTANCE, 1) * (1 - MIN_BRIGHTNESS)
	if not r or not g or not b then
		r, g, b = 255, 255, 255
	end
	r = math.floor(multiplier * r)
	g = math.floor(multiplier * g)
	b = math.floor(multiplier * b)
	return exports.tunrc_Utils:RGBToHex(r, g, b)
end

addEvent("tunrc_Chat.broadcastMessage", true)
addEventHandler("tunrc_Chat.broadcastMessage", root, function (tabName, message, sender, distance)
	-- filter offensive words if enabled
	if exports.tunrc_Config:getProperty("chat.block_offensive_words") then
		message = WordsFilter.filter(message)
	end

	local playerGroup = sender:getData("group")
	if not playerGroup then
		-- remove colors
		message = utf8.gsub(message, "#%x%x%x%x%x%x", "")
	end

	if tabName == "local" then
		message = sender.name .. tostring(getColorFromDistance(distance)) .. ": " .. tostring(message)
	elseif tabName == "global" or tabName == "illegal" then
		message = ("%s: #FFFFFF%s"):format(tostring(sender.name), tostring(message))
		if playerGroup then
			-- add tag to message
			message = ("#75FF00%s#FFFFFF %s"):format(exports.tunrc_Lang:getString("chat_adminsay_" .. tostring(playerGroup)), tostring(message))
		elseif sender:getData("isPremium") then
			message = ("#FFAA00%s#FFFFFF %s"):format(exports.tunrc_Lang:getString("chat_premiumsay"), tostring(message))
		end
	else
		message = ("%s: #FFFFFF%s"):format(tostring(sender.name), tostring(message))
	end

	Chat.message(tabName, message)
end)

addEventHandler("onClientElementDataChange", localPlayer, function(dataName)
	if dataName == "langChat" then
		Chat.clearTab("lang")
		setupLangTabTitle()
	end
end)

addEventHandler("tunrc_Lang.languageChanged", root, function ()
	setupLangTabTitle()
	setupGlobalTabTitle()
	setupLocalTabTitle()
end)

addEvent("tunrc_Chat.serverMessage", true)
addEventHandler("tunrc_Chat.serverMessage", resourceRoot, function (tabName, message)
	Chat.message(tabName, message)
end)
