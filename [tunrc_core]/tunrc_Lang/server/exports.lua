function chatMessage(name, player, ...)
	local args = {...}
	local success = pcall(function ()
		triggerClientEvent(player, "tunrc_Lang.chatMessageServer", resourceRoot, name, unpack(args))
	end)
	return success
end