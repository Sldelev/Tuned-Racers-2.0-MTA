local MIN_BIAS_DEFAULT = 0.25
local MAX_BIAS_DEFAULT = 0.65

local overrideBias = {
mustang15 = {0.15, 0.5}
}

function updateVehicleBias(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("Bias")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).suspensionFrontRearBias
	else
		local minBias = MIN_BIAS_DEFAULT
		local maxBias = MAX_BIAS_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideBias[vehicleName] then
			minBias = overrideBias[vehicleName][1]
			maxBias = overrideBias[vehicleName][2]
		end
		value = minBias + value * (maxBias - minBias)
	end
	setVehicleHandling(vehicle, "suspensionFrontRearBias", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Bias" then
		updateVehicleBias(source)
	end
end)