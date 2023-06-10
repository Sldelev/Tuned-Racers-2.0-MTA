local MIN_LOADBIAS_DEFAULT = 0.33
local MAX_LOADBIAS_DEFAULT = 0.45

local overrideLoadBias = {
}

function updateVehicleLoadBias(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("LoadBias")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).tractionBias
	else
		local minLoadBias = MIN_LOADBIAS_DEFAULT
		local maxLoadBias = MAX_LOADBIAS_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideLoadBias[vehicleName] then
			minLoadBias = overrideLoadBias[vehicleName][1]
			maxLoadBias = overrideLoadBias[vehicleName][2]
		end
		value = minLoadBias + value * (maxLoadBias - minLoadBias)
	end
	setVehicleHandling(vehicle, "tractionBias", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "LoadBias" then
		updateVehicleLoadBias(source)
	end
end)