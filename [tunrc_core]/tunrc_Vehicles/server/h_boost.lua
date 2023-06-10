local MIN_BOOST_DEFAULT = 170
local MAX_BOOST_DEFAULT = 250

local overrideBoost = {
}

function updateVehicleBoost(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("Boost")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).maxVelocity
	else
		local minBoost = MIN_BOOST_DEFAULT
		local maxBoost = MAX_BOOST_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideBoost[vehicleName] then
			minBoost = overrideBoost[vehicleName][1]
			maxBoost = overrideBoost[vehicleName][2]
		end
		value = minBoost + value * (maxBoost - minBoost)
	end
	setVehicleHandling(vehicle, "maxVelocity", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Boost" then
		updateVehicleBoost(source)
	end
end)