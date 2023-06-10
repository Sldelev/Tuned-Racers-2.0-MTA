local MIN_FRONTTIRES_DEFAULT = 0.49
local MAX_FRONTTIRES_DEFAULT = 0.51

local overrideFrontTires = {
}

function updateVehicleFrontTires(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("FrontTires")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).tractionMultiplier
	else
		local minFrontTires = MIN_FRONTTIRES_DEFAULT
		local maxFrontTires = MAX_FRONTTIRES_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideFrontTires[vehicleName] then
			minFrontTires = overrideBias[vehicleName][1]
			maxFrontTires = overrideBias[vehicleName][2]
		end
		value = minFrontTires + value * (maxFrontTires - minFrontTires)
	end
	setVehicleHandling(vehicle, "tractionMultiplier", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "FrontTires" then
		updateVehicleBias(source)
	end
end)