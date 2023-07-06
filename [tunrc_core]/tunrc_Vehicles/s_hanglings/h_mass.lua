local MIN_MASS_DEFAULT = 0
local MAX_MASS_DEFAULT = 50000

local overrideMass = {
}

local overrideDefaultMass = {
}

function updateVehicleMass(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("veh_mass")
	if type(value) ~= "number" then
		if vehicleName and overrideDefaultMass[vehicleName] then
			value = overrideDefaultMass[vehicleName]
		else
			value = 16000
		end
	else
		local minMass = MIN_MASS_DEFAULT
		local maxMass = MAX_MASS_DEFAULT
		local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideMass[vehicleName] then
			minMass = overrideMass[vehicleName][1]
			maxMass = overrideMass[vehicleName][2]
		end
		value = minMass + value
	end
	setVehicleHandling(vehicle, "mass", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "veh_mass" then
		updateVehicleMass(source)
	end
end)