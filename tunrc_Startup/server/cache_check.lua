local cacheCheckEnabled = false

addEvent("tunrc_CacheLock.reportMissingCache", true)
addEventHandler("tunrc_CacheLock.reportMissingCache", resourceRoot, function ()
	if not cacheCheckEnabled then
		return
	else
		outputDebugString("Player joined without cache: " .. tostring(client.name))
		kickPlayer(client, "Download cache here: vk.com/tunrc")
	end
end)

addEvent("tunrc_Chat.command", true)
addEventHandler("tunrc_Chat.command", root, function (tab, command, ...)
	if command ~= "forcecache" then
		return
	end
	if not exports.tunrc_Utils:isPlayerAdmin(client) then
		return 
	end

	cacheCheckEnabled = not cacheCheckEnabled
	exports.tunrc_Chat:message(client, "global", "Cache check: " .. tostring(cacheCheckEnabled))
end)