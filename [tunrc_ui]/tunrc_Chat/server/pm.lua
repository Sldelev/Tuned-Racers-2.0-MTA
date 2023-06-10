addEvent("tunrc_Chat.pm", true)
addEventHandler("tunrc_Chat.pm", root, function(targetPlayer, message)
	triggerClientEvent(targetPlayer, "tunrc_Chat.pm", root, client, message)
	exports.tunrc_Logger:log("pm", string.format(
		"%s -> %s: %s", 
		client.name, 
		targetPlayer.name, 
		message))
end)