addEvent("tunrc_Garage.enter", true)
addEventHandler("tunrc_Garage.enter", resourceRoot, function ()
	if client:getData("tunrc_Core.state") then
		triggerClientEvent(client, "tunrc_Garage.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	if not client:getData("_id") then
		triggerClientEvent(client, "tunrc_Garage.enter", resourceRoot, false, "garage_enter_failed")
		return
	end

	-- _id машины, в которой был игрок, когда вошел в гараж (если это его машина)
	local enteredVehicleId
	if client.vehicle then
		enteredVehicleId = client.vehicle:getData("_id")
	end

	-- Выкинуть игрока из машины
	removePedFromVehicle(client)
	exports.tunrc_Core:returnPlayerVehiclesToGarage(client)

	local playerVehicles = exports.tunrc_Core:getPlayerVehicles(client)
	if type(playerVehicles) ~= "table" or #playerVehicles == 0 then
		triggerClientEvent(client, "tunrc_Garage.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	client:setData("tunrc_Core.state", "garage")

	-- Перенос игрока в уникальный dimension
	local garagePosition = Vector3 { x = 1585.5, y = 2252.5, z = 3708 }

	client.dimension = tonumber(client:getData("_id")) + 4000
	client.position = Vector3(garagePosition + Vector3(0, 5, 25))
	client.frozen = true
	client.interior = 0
	client.alpha = 0
	removePedFromVehicle(client)

	local vehicle = createVehicle(547, 5000, 0, -1000)
	vehicle.rotation = Vector3(0, 0, -90)
	vehicle.dimension = client.dimension
	vehicle.interior = client.interior
	client:setData("garageVehicle", vehicle)
	vehicle:setData("localVehicle", true)
	vehicle:setSyncer(client)

	triggerClientEvent(client, "tunrc_Garage.enter", resourceRoot, true, playerVehicles, enteredVehicleId, vehicle)
	client:setData("activeMap", false)
end)

addEvent("tunrc_Garage.exit", true)
addEventHandler("tunrc_Garage.exit", resourceRoot, function (selectedCarId)
	if client:getData("tunrc_Core.state") ~= "garage" then
		triggerClientEvent(client, "tunrc_Garage.exit", resourceRoot, false)
		return
	end
	client:setData("tunrc_Core.state", false)

	-- Координаты дома
	client.position = garage.position
	client.rotation = garage.rotation
	
	client.frozen = false
	client.dimension = 0
	client.interior = 0
	client.alpha = 255
	-- Если игрок выбрал машину в гараже
	if selectedCarId then
		local vehicle = exports.tunrc_Core:spawnVehicle(selectedCarId, client.position, client.rotation)
		if isElement(vehicle) then
			vehicle:setData("locked", true)
			warpPedIntoVehicle(client, vehicle)
		else
			outputDebugString("Garage server: Failed to spawn vehicle")
		end
	end
	triggerClientEvent(client, "tunrc_Garage.exit", resourceRoot, true)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		-- Сбросить state всех игроков при перезапуске ресурса
		if player:getData("tunrc_Core.state") == "garage" then
			player:setData("tunrc_Core.state", false)
			player.dimension = 0
		end
	end
end)
