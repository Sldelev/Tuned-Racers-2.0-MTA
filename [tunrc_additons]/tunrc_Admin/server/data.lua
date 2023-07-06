addEvent("tunrc_Admin.requirePlayerVehiclesList", true)
addEventHandler("tunrc_Admin.requirePlayerVehiclesList", resourceRoot, function (player)
	if not isElement(player) then
		return
	end
	if not isPlayerAdmin(client) then
		return
	end
	local vehiclesList = exports.tunrc_Core:getPlayerVehicles(player)
	triggerClientEvent(client, "tunrc_Admin.requirePlayerVehiclesList", resourceRoot, vehiclesList)
end)

addEvent("tunrc_Admin.requireGiftKeysList", true)
addEventHandler("tunrc_Admin.requireGiftKeysList", resourceRoot, function ()
	if not isPlayerAdmin(client) then
		return
	end
	local keysList = exports.tunrc_Core:getGiftKeys()
	triggerClientEvent(client, "tunrc_Admin.requireGiftKeysList", resourceRoot, keysList)
end)

addEvent("tunrc_Admin.createGiftKeys", true)
addEventHandler("tunrc_Admin.createGiftKeys", resourceRoot, function (options)
	if not isPlayerAdmin(client) then
		return
	end
	if type(options) ~= "table" then
		return 
	end

	local keysList = {}
	exports.tunrc_Core:createGiftKey(options)
	triggerClientEvent(client, "tunrc_Admin.updatedKeys", resourceRoot)
end)

addEvent("tunrc_Admin.removeGiftKeys", true)
addEventHandler("tunrc_Admin.removeGiftKeys", resourceRoot, function (keys)
	if type(keys) ~= "table" then
		return
	end
	if not exports.tunrc_Utils:isPlayerAdmin(client) then
		return
	end	
	for i, key in ipairs(keys) do
		exports.tunrc_Core:removeGiftKey(key)
	end
	triggerClientEvent(client, "tunrc_Admin.updatedKeys", resourceRoot)
end)

addEventHandler("onPlayerLogin", root, function ()
	if exports.tunrc_Utils:isPlayerAdmin(source) then
		source:setData("aclGroup", "admin")
	else
		source:setData("aclGroup", "user")
	end
end)

addEventHandler("onPlayerLogout", root, function ()
	source:setData("aclGroup", "guest")
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, p in ipairs(getElementsByType("player")) do
		if exports.tunrc_Utils:isPlayerAdmin(p) then
			p:setData("aclGroup", "admin")
		end
	end
end)