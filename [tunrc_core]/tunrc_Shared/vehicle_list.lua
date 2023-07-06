-- Краткие названия для использования в коде вместо ID
local vehiclesTable = {
tunerc_elegy = 562,
tunerc_jester = 559,
tunerc_alpha = 602,
tunerc_euros = 587,
tunerc_club = 589,
tunerc_bravura = 401,
tunerc_buffalo = 402,
tunerc_sentinel = 405,
tunerc_banshee = 429,
tunerc_zr350 = 477,
tunerc_blazer = 471,
tunerc_burrito = 482
}

-- Названия в том виде, в котором они будут отображаться
local vehiclesReadableNames = {
	tunerc_elegy = "Annis Elegy",
	tunerc_jester = "Dinka Jester",
	tunerc_alpha = "Albany Alpha",
	tunerc_euros = "Annis Euros",
	tunerc_club = "BF Club",
	tunerc_bravura = "BF Bravura",
	tunerc_buffalo = "Bravado Buffalo W.I.P",
	tunerc_sentinel = "Übermacht Sentinel W.I.P",
	tunerc_banshee = "Bravado Banshee",
	tunerc_zr350 = "Annis ZR-350 W.I.P",
	tunerc_blazer = "Nagasaki Blazer W.I.P",
	tunerc_burrito = "Declasse Burrito W.I.P"
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
