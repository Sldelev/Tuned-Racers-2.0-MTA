ENGINE_DATA = {
	-- casual vehicles
	["BMW"] = {
		["bmw_m40"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="bmw_m40",
			fuel="petrol",
		},
	},
	["2JZ"] = {
		["2jz"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="2jz",
			fuel="petrol",
		},
	},
		["RB26"] = {
		["rb26"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="rb26",
			fuel="petrol",
		},
	},
	["B58"] = {
		["b58"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="b58",
			fuel="petrol",
		},
	},
	["13B"] = {
		["13b"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="13b",
			fuel="petrol",
		},
	},	
	["Honda"] = {
		["honda_engine"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="honda_engine",
			fuel="petrol",
		},
	},
	["CORVETTE"] = {
		["corvette"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="corvette",
			fuel="petrol",
		},
	},
	["BOXER"] = {
		["boxer"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="boxer",
			fuel="petrol",
		},
	},
	["MX5"] = {
		["mx5"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="mx5",
			fuel="petrol",
		},
	},
	["MV6"] = {
		["mv6"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="mv6",
			fuel="petrol",
		},
	},
	["SR20"] = {
		["sr20"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="sr20",
			fuel="petrol",
		},
	},
	["V8D"] = {
		["v8d"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="v8d",
			fuel="petrol",
		},
	},
	["V8F"] = {
		["v8f"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="v8f",
			fuel="petrol",
		},
	},
	["350Z"] = {
		["vq6"] = {
			idleRPM=600,
			maxRPM=8000,
			soundPack="vq6",
			fuel="petrol",
		},
	}
}

-- soundpack volume boosting
SOUNDPACK_VOLUME = {
	["2jz"] = 0.5,
}

function calculateVehicleEngine(vehicle)
	local model = getElementModel(vehicle)
	local type = getElementData(vehicle, "vehicle:type") 
	
	if ENGINE_DATA[type] then
		local engines = {}
		for name, data in pairs(ENGINE_DATA[type]) do 
			table.insert(engines, {name, data})
		end
		
		table.sort(engines, function(a, b)
			return a[1] < b[1]
		end)
		
		class = math.max(1, #engines)
		
		return engines[class][1] -- name of engine
	end
	
	return false
end 

function addVehicleEngine(vehicle)
	local data = calculateVehicleEngine(vehicle)
	local type = getElementData(vehicle, "vehicle:type")
	local model = getElementModel(vehicle)
	if data then 
		local upgrades = getElementData(vehicle, "vehicle:upgrades") or {engine={turbo=false}}
		local engine = ENGINE_DATA[type][data]
		engine.name = data
		engine.volMult = SOUNDPACK_VOLUME[engine.soundPack] or 1
		engine.turbo = upgrades.engine and upgrades.engine.turbo or false
		engine.turbo_shifts = engine.turbo
		
		setElementData(vehicle, "vehicle:engine", engine)
		setElementData(vehicle, "vehicle:fuel_type", engine.fuel)
		
		-- refresh for players nearby
		local x, y, z = getElementPosition(vehicle)
		local col = createColSphere(x, y, z, 20)
		for k, v in ipairs(getElementsWithinColShape(col, "player")) do 
			triggerClientEvent(v, "onClientRefreshEngineSounds", v)
		end 
		destroyElement(col)
	end
end 

function onResourceStart()
	for k, v in ipairs(getElementsByType("vehicle")) do 
		local type = getElementData(v, "vehicle:type")
		if not type then
			type = getVehicleTypeByModel(getElementModel(v))
			setElementData(v, "vehicle:type", type)
		end 
		
		addVehicleEngine(v)
	end
end 
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

function onVehicleEnter(player, seat, jacked)
	if seat == 0 then 
		local type = getElementData(source, "vehicle:type")
		if not type then
			type = getVehicleTypeByModel(getElementModel(source))
			setElementData(source, "vehicle:type", type)
		end 
		
		addVehicleEngine(source)
	end
end
addEventHandler("onVehicleEnter", root, onVehicleEnter)
