local languageChats = {
	UA = "ru",
	RU = "ru",
	EN = "en",
	BY = "ru"
}

addEvent("tunrc_Chat.broadcastMessage", true)
addEventHandler("tunrc_Chat.broadcastMessage", root, function (tabName, rawMessage)
	local sender
	if not client then
		sender = source
	else
		sender = client
	end

	if sender.muted then
		return
	end
	if sender:getData("isMuted") then
		return
	end

	exports.tunrc_Logger:log("chat", string.format("[%s] %s (%s): %s",
		tostring(tabName),
		tostring(sender.name),
		tostring(sender:getData("username")),
		tostring(rawMessage)))

	triggerEvent("tunrc_Chat.message", resourceRoot, sender, tabName, rawMessage)
	if tabName == "global" or tabName == "illegal" then
		triggerClientEvent("tunrc_Chat.broadcastMessage", root, tabName, rawMessage, sender)
	elseif tabName == "web" then
		triggerClientEvent("tunrc_Chat.broadcastMessage", root, tabName, rawMessage, sender)
	elseif tabName == "lang" then
		local lang = sender:getData("langChat")
		if not lang then
			lang = "en"
		end
		for i, player in ipairs(getElementsByType("player")) do
			local playerLang = player:getData("langChat")
			if not playerLang then
				playerLang = "Unknown"
			end
			if playerLang == lang then
				triggerClientEvent(player, "tunrc_Chat.broadcastMessage", root, tabName, rawMessage, sender)
			end
		end
	elseif tabName == "local" then
		for i, player in ipairs(getElementsByType("player")) do
			local distance = (player.position - sender.position):getLength()
			if distance < 100 then
				triggerClientEvent(player, "tunrc_Chat.broadcastMessage", root, tabName, rawMessage, sender, distance)
			end
		end
	end
end)

local function setupPlayerCountry(player)
	if not code then
		return
	end
	local name = "en"
	if languageChats[code] then
		name = languageChats[code]
	end
	player:setData("langChat", name)
	player:setData("country", code)
end

addEventHandler("onPlayerJoin", root, function ()
	setupPlayerCountry(source)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, p in ipairs(getElementsByType("player")) do
		setupPlayerCountry(p)
	end
end)

addEventHandler("onPlayerChat", root, function (message, messageType)
	cancelEvent()
	if exports.tunrc_Core:isPlayerLoggedIn(source) then
		if messageType == 0 then
			triggerClientEvent(source, "tunrc_Chat.message", source, "global", message)
		end
	end
end)

function message(element, tabName, message)
	triggerClientEvent(element, "tunrc_Chat.serverMessage", root, tabName, message)
end
