local MIN_VELOCITY_DEFAULT = 0
local MAX_VELOCITY_DEFAULT = 300

local overrideVelocity = {
}

function updateVehicleMaxVelocity(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("veh_velocity")
	if type(value) ~= "number" then
		value = 250
	else
		local minVelocity = MIN_VELOCITY_DEFAULT
		local maxVelocity = MAX_VELOCITY_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideVelocity[vehicleName] then
			minVelocity = overrideVelocity[vehicleName][1]
			maxVelocity = overrideVelocity[vehicleName][2]
		end
		value = minVelocity + value
	end
	setVehicleHandling(vehicle, "maxVelocity", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "veh_velocity" then
		updateVehicleMaxVelocity(source)
	end
end)