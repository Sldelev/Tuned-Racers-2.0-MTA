local function onPlayerConnect(player)
	if exports.tunrc_Config:getProperty("chat.joinquit_messages") then
		local messageColor = "#8282c8"
		local playerName = exports.tunrc_Utils:removeHexFromString(player:getData("username"))
		exports.tunrc_Chat:message(
			"global",
			messageColor .. string.format(exports.tunrc_Lang:getString("chat_message_player_join"), playerName),
			255, 255, 255
		)
	end
end

local function onPlayerQuit(reason)
	if exports.tunrc_Config:getProperty("chat.joinquit_messages") then
		local messageColor = "#8282c8"
		local playerName = exports.tunrc_Utils:removeHexFromString(source:getData("username"))
		reason = exports.tunrc_Lang:getString("quit_reason_" .. string.lower(tostring(reason)))
		exports.tunrc_Chat:message(
			"global",
			messageColor .. string.format(exports.tunrc_Lang:getString("chat_message_player_quit"), playerName, reason),
			255, 255, 255
		)
	end
end

addEvent("tunrc_Greetings.onLogin", true)
addEventHandler("tunrc_Greetings.onLogin", resourceRoot, onPlayerConnect)
addEventHandler("onClientPlayerQuit", getRootElement(), onPlayerQuit)
