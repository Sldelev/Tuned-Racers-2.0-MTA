addEventHandler("onClientResourceStart", resourceRoot, function ()
	if not fileExists(":tunrc_CacheLock/lock.txt") then
		--triggerServerEvent("tunrc_CacheLock.reportMissingCache", resourceRoot)
	end
end)