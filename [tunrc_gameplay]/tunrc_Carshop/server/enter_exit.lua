local carshopPosition = Vector3 { x = -1639.2, y = 1202.87, z = 7.25 } 

addEvent("tunrc_Carshop.enter", true)
addEventHandler("tunrc_Carshop.enter", resourceRoot, function ()
	if client:getData("tunrc_Core.state") or not client:getData("serverId") then
		triggerClientEvent(client, "tunrc_Carshop.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	client:setData("tunrc_Core.state", "carshop")
	client.position = Vector3(1230.2, -1788.7, 130.156)
	client.dimension = (tonumber(client:getData("serverId")) or (math.random(1000, 9999) + 5000)) + 10000
	client.frozen = true
	triggerClientEvent(client, "tunrc_Carshop.enter", resourceRoot, true)
	client:setData("activeMap", false)	
end)

addEvent("tunrc_Carshop.exit", true)
addEventHandler("tunrc_Carshop.exit", resourceRoot, function (selectedCarId)
	if client:getData("tunrc_Core.state") ~= "carshop" then
		triggerClientEvent(client, "tunrc_Carshop.exit", resourceRoot, false)
		return
	end
	client:setData("tunrc_Core.state", false)

	client.position = carshopPosition
	client.rotation = Vector3(0, 0, -90)
	client.frozen = false
	client.dimension = 0

	triggerClientEvent(client, "tunrc_Carshop.exit", resourceRoot, true)	
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		-- Сбросить state всех игроков при перезапуске ресурса
		if player:getData("tunrc_Core.state") == "carshop" then
			player:setData("tunrc_Core.state", false)
			player.dimension = 0
		end
	end
end)