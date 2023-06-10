local function onPlayerConnect()
	if exports.tunrc_Config:getProperty("chat.joinquit_messages") then
		local messageColor = exports.tunrc_Utils:RGBToHex(exports.tunrc_UI:getThemeColor())
		local playerName = exports.tunrc_Utils:removeHexFromString(source.name)
		exports.tunrc_Chat:message(
			"global",
			messageColor .. string.format(exports.tunrc_Lang:getString("chat_message_player_join"), playerName),
			255, 255, 255
		)
	end
end

local function onPlayerQuit(reason)
	if exports.tunrc_Config:getProperty("chat.joinquit_messages") then
		local messageColor = exports.tunrc_Utils:RGBToHex(exports.tunrc_UI:getThemeColor())
		local playerName = exports.tunrc_Utils:removeHexFromString(source.name)
		reason = exports.tunrc_Lang:getString("quit_reason_" .. string.lower(tostring(reason)))
		exports.tunrc_Chat:message(
			"global",
			messageColor .. string.format(exports.tunrc_Lang:getString("chat_message_player_quit"), playerName, reason),
			255, 255, 255
		)
	end
end

addEventHandler("onClientPlayerJoin", getRootElement(), onPlayerConnect)
addEventHandler("onClientPlayerQuit", getRootElement(), onPlayerQuit)
