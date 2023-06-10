addEvent("tunrc_Admin.showMessage", true)
addEventHandler("tunrc_Admin.showMessage", resourceRoot, function (message, admin, player, duration)
	if message == "mute" then
		local messageText = string.format(
			exports.tunrc_Lang:getString("chat_admin_mute"), 
			exports.tunrc_Utils:removeHexFromString(player.name), 
			exports.tunrc_Utils:removeHexFromString(admin.name), 
			tostring(duration))
		exports.tunrc_Chat:message("global", messageText, 255, 0, 0)
	elseif message == "ban" then
		local messageText = string.format(
			exports.tunrc_Lang:getString("chat_admin_ban"), 
			exports.tunrc_Utils:removeHexFromString(player.name), 
			exports.tunrc_Utils:removeHexFromString(admin.name))
		exports.tunrc_Chat:message("global", messageText, 255, 0, 0)
	elseif message == "unmute" then
		local messageText = string.format(
			exports.tunrc_Lang:getString("chat_admin_unmute"), 
			exports.tunrc_Utils:removeHexFromString(player.name), 
			exports.tunrc_Utils:removeHexFromString(admin.name))
		exports.tunrc_Chat:message("global", messageText, 0, 255, 0)		
	end
end)