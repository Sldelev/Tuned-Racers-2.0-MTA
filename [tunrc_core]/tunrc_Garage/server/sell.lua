local DEBUG = true

local _outputDebugString = outputDebugString
local function outputDebugString(...)
	if not DEBUG then
		return
	end
	_outputDebugString(...)
end

addEvent("tunrc_Garage.sellVehicle", true)
addEventHandler("tunrc_Garage.sellVehicle", resourceRoot, function (vehicleId)
	local vehicleInfo = exports.tunrc_Core:getVehicleById(vehicleId)
	if type(vehicleInfo) ~= "table" then
		outputDebugString("Sell error: No vehicle info")
		return
	end
	if type(vehicleInfo[1]) ~= "table" then
		outputDebugString("Sell error: No vehicle info 2")
		return
	end
	vehicleInfo = vehicleInfo[1]

	local userId = client:getData("_id")
	if not userId then
		outputDebugString("Sell error: No user id")
		return
	end
	if userId ~= vehicleInfo.owner_id then
		outputDebugString("Sell error: Vehicle not owned")
		return
	end
	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicleInfo.model)
	if not vehicleName then
		outputDebugString("Sell error: No vehicle name")
		return
	end
	local price = getVehicleSellPrice(vehicleName, vehicleInfo.mileage)
	if not price then
		outputDebugString("Sell error: No vehicle price")
		return
	end
	if not exports.tunrc_Core:givePlayerMoney(client, price) then
		outputDebugString("Sell error: Failed to give player money")
		return
	end
	exports.tunrc_Core:removePlayerVehicle(client, vehicleId)
	local playerVehicles = exports.tunrc_Core:getPlayerVehicles(client)
	triggerClientEvent(client, "tunrc_Garage.updateVehiclesList", resourceRoot, playerVehicles)
end)
