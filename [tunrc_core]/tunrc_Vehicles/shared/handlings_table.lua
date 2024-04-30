local handlingsTable = {}

-- Пример
-- handlingsTable["car_name"] = {
-- 	street = {
-- 		"stock",
-- 		"стрит хандлинг"
-- 	},

-- 	drift = {
-- 		"дрифт хандлинг"
-- 	}
-- }


 handlingsTable["tunrc_zr350"] = {
 	street = {
 		"HERMES 16000 22500 0 0 -0.37 -0.44 75 0.7 0.74 0.5 5 250 9 90 r p 10 0.06 false 54.928 0.8 0.2 0 0.28 -0.007 0.44 0.7 1 0 19000 1000 0 1 3 0",
 		"HERMES 16000 22500 0 0 -0.37 -0.44 75 0.7 0.74 0.5 5 250 9 90 r p 10 0.06 false 54.928 0.8 0.2 0 0.28 -0.007 0.44 0.7 1 0 19000 1000 0 1 3 0"
 	},
	drift = {
		"ELEGY 16000 22500 0 0 -0.37 -0.2 75 0.58 0.74 0.38 5 250 55 10 r p 3 0.06 false 60 0.8 0.2 0 0.28 -0.105 0.348 0.7 1 0 35000 1000 0 1 1 1"
	}
}

 handlingsTable["tunrc_warrener_hkr"] = {
 	street = {
 		"HERMES 16000 25000 0 0 -0.37 -0.44 75 0.7 0.74 0.5 5 250 9 90 r p 10 0.06 false 54.928 0.8 0.2 0 0.28 -0.007 0.44 0.7 1 0 19000 1000 0 1 3 0",
 		"HERMES 16000 25000 0 0 -0.37 -0.44 75 0.7 0.74 0.5 5 250 9 90 r p 10 0.06 false 54.928 0.8 0.2 0 0.28 -0.007 0.44 0.7 1 0 19000 1000 0 1 3 0"
 	},
	drift = {
		"ELEGY 16000 25000 0 0 -0.37 -0.2 75 0.58 0.74 0.38 5 250 55 10 r p 3 0.06 false 60 0.8 0.2 0 0.28 -0.105 0.348 0.7 1 0 35000 1000 0 1 1 1"
	}
}

 handlingsTable["tunrc_remus"] = {
 	street = {
 		"HERMES 16000 25000 0 0 -0.37 -0.44 75 0.7 0.74 0.5 5 250 9 90 r p 10 0.06 false 54.928 0.8 0.2 0 0.28 -0.007 0.44 0.7 1 0 19000 1000 0 1 3 0",
 		"HERMES 16000 25000 0 0 -0.37 -0.44 75 0.7 0.74 0.5 5 250 9 90 r p 10 0.06 false 54.928 0.8 0.2 0 0.28 -0.007 0.44 0.7 1 0 19000 1000 0 1 3 0"
 	},
	drift = {
		"ELEGY 16000 25000 0 0 -0.37 -0.2 75 0.58 0.74 0.38 5 250 55 10 r p 3 0.06 false 60 0.8 0.2 0 0.28 -0.105 0.348 0.7 1 0 35000 1000 0 1 1 1"
	}
}


local handlingProperties = {"identifier", "mass", "turnMass", "dragCoeff", "centerOfMassX", "centerOfMassY", "centerOfMassZ", "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration", "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier", "monetary", "modelFlags", "handlingFlags", "headLight", "tailLight", "animGroup", "identifier", "mass", "turnMass", "dragCoeff", "centerOfMassX", "centerOfMassY", "centerOfMassZ", "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration", "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier", "monetary", "modelFlags", "handlingFlags", "headLight", "tailLight", "animGroup"}

function hasVehicleHandling(vehicleName, handlingName, level)
	if type(vehicleName) ~= "string" then
		return false
	end
	if type(handlingsTable[vehicleName]) ~= "table" then
		return false
	end
	if type(handlingName) == "string" then
		if type(handlingsTable[vehicleName][handlingName]) ~= "table" then
			return false
		end
		if #handlingsTable[vehicleName][handlingName] == 0 then
			return false
		end 		
		if type(level) == "number" then
			if type(handlingsTable[vehicleName][handlingName][level]) ~= "string" then
				return false
			end
		end
	end
	return true
end

function getVehicleHandlingString(vehicleName, handlingName, level)
	if not hasVehicleHandling(vehicleName, handlingName, level) then
		return false
	end
	return handlingsTable[vehicleName][handlingName][level]
end

function getVehicleHandlingTable(vehicleName, handlingName, level)
	local handlingString = getVehicleHandlingString(vehicleName, handlingName, level)
	if type(handlingString) ~= "string" then
		return false
	end
	return importHandling(handlingString)
end

function getAllHandlingTables(handlingName, level)
	local result = {}
	for name, t in pairs(handlingsTable) do
		result[name] = getVehicleHandlingTable(name, handlingName, level)
	end
	return result
end