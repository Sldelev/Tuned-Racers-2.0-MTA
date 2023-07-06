local MIN_TURNMASS_DEFAULT = 0
local MAX_TURNMASS_DEFAULT = 50000

local overrideTurnMass = {
}

local overrideDefaultTurnMass = {
tunerc_elegy = {30000},
tunerc_bravura = {30000},
tunerc_sentinel = {45000},
tunerc_burrito = {45000},
tunerc_club = {50000}
}

function updateVehicleTurnMass(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("veh_turnmass")
	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
	if type(value) ~= "number" then
		if vehicleName and overrideDefaultTurnMass[vehicleName] then
			value = overrideDefaultTurnMass[vehicleName]
		else
			value = 40000
		end
	else
		local minTurnMass = MIN_TURNMASS_DEFAULT
		local maxTurnMass = MAX_TURNMASS_DEFAULT
		if vehicleName and overrideTurnMass[vehicleName] then
			minTurnMass = overrideMass[vehicleName][1]
			maxTurnMass = overrideMass[vehicleName][2]
		end
		value = minTurnMass + value
	end
	setVehicleHandling(vehicle, "turnMass", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "veh_turnmass" then
		updateVehicleTurnMass(source)
	end
end)