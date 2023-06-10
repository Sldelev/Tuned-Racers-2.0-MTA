local MIN_BRAKEDIST_DEFAULT = 0.06
local MAX_BRAKEDIST_DEFAULT = 0.7

local overrideBrakedist = {
}

function updateVehicleBrakedist(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("Brakedist")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).brakeBias
	else
		local minBrakedist = MIN_BRAKEDIST_DEFAULT
		local maxBrakedist = MAX_BRAKEDIST_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideBrakedist[vehicleName] then
			minBrakedist = overrideBrakedist[vehicleName][1]
			maxBrakedist = overrideBrakedist[vehicleName][2]
		end
		value = minBrakedist + value * (maxBrakedist - minBrakedist)
	end
	setVehicleHandling(vehicle, "brakeBias", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Brakedist" then
		updateVehicleBrakedist(source)
	end
end)