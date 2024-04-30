addEvent("tunrc_Garage.saveCar", true)
addEventHandler("tunrc_Garage.saveCar", resourceRoot, function (garageVehicleIndex, tuning, stickers, windowsStickers)
	if client:getData("tunrc_Core.state") ~= "garage" then
		triggerClientEvent(client, "tunrc_Garage.saveCar", resourceRoot, false)
		return
	end

	local playerVehicles = exports.tunrc_Core:getPlayerVehicles(client)
	if type(playerVehicles) ~= "table" or #playerVehicles == 0 then
		triggerClientEvent(client, "tunrc_Garage.saveCar", resourceRoot, false)
		return
	end
	local vehicleTable = playerVehicles[garageVehicleIndex]
	if not vehicleTable then
		triggerClientEvent(client, "tunrc_Garage.saveCar", resourceRoot, false)
		return
	end
	exports.tunrc_Core:updateVehicleTuning(vehicleTable._id, tuning, stickers, windowsStickers)
end)

addEvent("tunrc_Garage.buy", true)
addEventHandler("tunrc_Garage.buy", resourceRoot, function(price, level)
	if type(level) ~= "number" or type(price) ~= "number" then
		triggerClientEvent(client, "tunrc_Garage.buy", resourceRoot, false)
	end

	if level > client:getData("level") then
		triggerClientEvent(client, "tunrc_Garage.buy", resourceRoot, false)
		return
	end
	local money = client:getData("money")
	if type(money) ~= "number" or money < price then
		triggerClientEvent(client, "tunrc_Garage.buy", resourceRoot, false)
		return 
	end
	client:setData("money", money - price)

	triggerClientEvent(client, "tunrc_Garage.buy", resourceRoot, true)
end)