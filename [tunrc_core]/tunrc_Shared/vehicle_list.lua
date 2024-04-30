-- Краткие названия для использования в коде вместо ID
local vehiclesTable = {
tunrc_zr350 = 477,
tunrc_warrener_hkr = 549,
bike_test = 522,
tunrc_remus = 562
}

-- Названия в том виде, в котором они будут отображаться
local vehiclesReadableNames = {
	tunrc_zr350 = "Annis ZR-350",
	tunrc_warrener_hkr = "Vulcar Warrener HKR",
	tunrc_remus = "Annis Remus"
}

-- Функции

function getVehicleModelFromName(name)
	if not name then
		return false
	end
	return vehiclesTable[name]
end

function getVehicleNameFromModel(model)
	if type(model) ~= "number" then
		return false
	end
	for name, currentModel in pairs(vehiclesTable) do
		if currentModel == model then
			return name
		end
	end
end

function getVehiclesTable()
	return vehiclesTable
end

function getVehicleReadableName(nameOrId)
	if type(nameOrId) == "string" then
		return vehiclesReadableNames[nameOrId] or ""
	elseif type(nameOrId) == "number" then
		local name = getVehicleNameFromModel(nameOrId)
		if name then
			return vehiclesReadableNames[name] or ""
		end
	end
end
