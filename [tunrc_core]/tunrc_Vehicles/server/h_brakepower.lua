local MIN_BRAKEPOWER_DEFAULT = 3
local MAX_BRAKEPOWER_DEFAULT = 10

local overrideBrakepower = {
}

function updateVehicleBrakepower(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("Brakepower")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).brakeDeceleration
	else
		local minBrakepower = MIN_BRAKEPOWER_DEFAULT
		local maxBrakepower = MAX_BRAKEPOWER_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideBrakepower[vehicleName] then
			minBrakepower = overrideBrakepower[vehicleName][1]
			maxBrakepower = overrideBrakepower[vehicleName][2]
		end
		value = minBrakepower + value * (maxBrakepower - minBrakepower)
	end
	setVehicleHandling(vehicle, "brakeDeceleration", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Brakepower" then
		updateVehicleBrakepower(source)
	end
end)