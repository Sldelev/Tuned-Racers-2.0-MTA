TuningConfig = {}

local tuningConfig = {}

-- Получение цены и уровня для компонента
function TuningConfig.getComponentConfig(model, name, id)
	-- price - цена
	-- level - уровень для покупки
	-- donatPrice - цена в донат-валюте (если false, то нельзя купить за донат-валюту)

	if not model or not name or not id or id <= 0 then
		return {price = 0, level = 1, donatPrice = false}
	end
	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(model)
	local componentsList = exports.tunrc_Shared:getVehicleComponentTable(name)

	if not componentsList then
		componentsList = {}
	end
	if name == "WheelsR" or name == "WheelsF" then
		componentsList = exports.tunrc_Shared:getTuningPrices("wheels")
	end
	if name == "Exhaust" then
		componentsList = exports.tunrc_Shared:getTuningPrices("exhausts")
	end
	if name == "Spoilers" then
		componentsList = {}
		if GarageCar.hasDefaultSpoilers() then
			componentsList = exports.tunrc_Shared:getTuningPrices("spoilers")
		end
	end

	if not componentsList[id] then
		return {price = 0, level = 1, donatPrice = false}
	else
		return {
			price = componentsList[id][1],
			level = componentsList[id][2],
			donatPrice = componentsList[id][3]
		}
	end
end

function TuningConfig.getComponentsCount(model, name)
	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(model)
	local componentsList = exports.tunrc_Shared:getVehicleComponentTable(name)

	if not componentsList then
		componentsList = {}
	end
	if name == "WheelsR" or name == "WheelsF" then
		componentsList = exports.tunrc_Shared:getTuningPrices("wheels")
	end
	if name == "Exhaust" then
		componentsList = exports.tunrc_Shared:getTuningPrices("exhausts")
	end
	if name == "Spoilers" then
		componentsList = {}
		if GarageCar.hasDefaultSpoilers() then
			componentsList = exports.tunrc_Shared:getTuningPrices("spoilers")
		end
	end

	return #componentsList
end
