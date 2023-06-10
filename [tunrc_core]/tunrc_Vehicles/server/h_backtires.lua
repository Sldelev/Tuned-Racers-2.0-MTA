local MIN_REARTIRES_DEFAULT = 0.67
local MAX_REARTIRES_DEFAULT = 0.69

local overrideRearTires = {
}

function updateVehicleRearTires(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("RearTires")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).tractionLoss
	else
		local minRearTires = MIN_REARTIRES_DEFAULT
		local maxRearTires = MAX_REARTIRES_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideRearTires[vehicleName] then
			minRearTires = overrideRearTires[vehicleName][1]
			maxRearTires = overrideRearTires[vehicleName][2]
		end
		value = minRearTires + value * (maxRearTires - minRearTires)
	end
	setVehicleHandling(vehicle, "tractionLoss", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "RearTires" then
		updateVehicleRearTires(source)
	end
end)