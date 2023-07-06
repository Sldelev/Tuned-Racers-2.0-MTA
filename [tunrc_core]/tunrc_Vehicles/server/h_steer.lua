local MIN_STEER_DEFAULT = GetMinSteerValue()
local MAX_STEER_DEFAULT = GetMaxSteerValue()

local overrideSteer = {
}

function updateVehicleSteer(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("Steer")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).steeringLock
	else
		local minSteer = MIN_STEER_DEFAULT
		local maxSteer = MAX_STEER_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideSteer[vehicleName] then
			minSteer = overrideSteer[vehicleName][1]
			maxSteer = overrideSteer[vehicleName][2]
		end
		value = minSteer + value * (maxSteer - minSteer)
	end
	setVehicleHandling(vehicle, "steeringLock", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Steer" then
		updateVehicleSteer(source)
	end
end)