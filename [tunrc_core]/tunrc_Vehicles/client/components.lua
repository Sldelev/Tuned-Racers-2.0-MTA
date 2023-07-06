--- Синхронизация тюнинга автомобилей
-- @script tunrc_Vehicles.components

-- Компоненты, которые нужно обновлять из даты
local componentsFromData = {
	["FrontBump"] 	= true, 	-- Задний бампер
	["RearBump"]	= true, 	-- Передний бампер
	["Skirts"]	    = true, 	-- Юбки
	["Bonnets"]		= true, 	-- Капот
	["RearLights"] 	= true, 	-- Задние фары
	["FrontLights"] = true, 	-- Передние фары
	["FrontFends"]	= true, 	-- Передние фендеры
	["RearFends"]	= true, 	-- Задние фендеры
	["Acces"]		= true, 	-- Аксессуары
	["Lips"]		= true, 	-- Губы
	["Dops"]		= true, 	-- доп детали
	["FaraL"]		= true, 	-- фара слева
	["FaraR"]		= true, 	-- фара справа
    ["Seats"]	= true, 	-- сидения
	["Steering"]	= true, 	-- срули
	["Torpeda"]	= true, 	-- торпеда
	["Karkas"]	= true, 	-- защитная балка чтобы по голове не дало
    ["Acces"]	= true, 	-- акссесуары
	["Canards"]	= true, 	-- канарды
	["Diffusors"]	= true, 	-- диффузоры
	["Intercooler"]	= true,		-- интеркулеры
	["Eng"]	= true, 	-- двигателя
	["Exh"]	= true,  	-- выхлопы
	["Rbadge"]	= true,  	-- задние шильдики
	["Fbadge"]	= true,  	-- передние шильдики
	["Canardsr"]	= true,  	-- канарды сзади
	["Boots"]	= true,  	-- багажники
	["RoofS"]	= true,  	-- спойлера на крыше
	["Rearnumber"]	= true,  	-- номер сзади
	["Frontnumber"]	= true,  	-- номер сзади
	["Bodykits"]	= true,  	-- бодикиты
	["FrontFendsR"]	= true,  	-- бодикиты
	["FrontFendsL"]	= true,  	-- бодикиты
	["Roof"]	= true,  	-- бодикиты
	["Grills"]	= true,  	-- решётки
	["Mirrors"]	= true,  	-- зеркала
	["SideLights"]	= true,  	-- поворотники
	["Turbos"]	= true,  	-- турбина
	["RearGls"]	= true,  	-- заднее стекло
	["FrontFendsDops"]	= true,  	-- накладки на фендера
	["Fpanels"]	= true,  	-- передние панели
	["Rpanels"]	= true,  	-- задние панели
	["AddLights"]	= true,  	-- доп фары
	["AddSkirts"]	= true,  	-- накладки на юбки
	["Rollingshells"]	= true,  	-- подкапотки
}

-- Апгрейды, которые нужно обновлять из даты
local upgradesFromData = {
	["Spoilers"] = {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164}
}

local function updateVehicleTuningComponent(vehicle, componentName, forceId)
	if not isElement(vehicle) then return false end
	if type(componentName) ~= "string" or (not forceId and not componentsFromData[componentName]) then
		return false
	end

	-- Скрыть все варианты компонента
	local i = 0
	while i <= 100 do
		local name = componentName .. tostring(i)
		vehicle:setComponentVisible(name, false)
		vehicle:setComponentVisible(componentName .. "Glass" .. tostring(i), false)
		vehicle:setComponentVisible(componentName .. "Misc" .. tostring(i), false)
		vehicle:setComponentVisible(componentName .. "Second" .. tostring(i), false)
		if i > 0 and not vehicle:getComponentPosition(name) then
			break
		end
		i = i + 1
	end
	-- Отобразить компонент по значению из даты (или по переданному в качестве аргрумента)
	local id = 0
	if type(forceId) == "number" then
		id = forceId
	else
		id = vehicle:getData(componentName)
		if not id then
			id = 0
		end
	end
	vehicle:setComponentVisible(componentName .. tostring(id), true)
	vehicle:setComponentVisible(componentName .. "Glass" .. tostring(id), true)
	vehicle:setComponentVisible(componentName .. "Misc" .. tostring(id), true)
	vehicle:setComponentVisible(componentName .. "Second" .. tostring(id), true)

	if not isElement(vehicle) then return false end
	if type(componentName) ~= "string" or not componentsFromData[componentName] then
		return false
	end
end

local function updateVehicleTuningUpgrade(vehicle, upgradeName)
	if not isElement(vehicle) then return false end
	if type(upgradeName) ~= "string" or not upgradesFromData[upgradeName] then
		return false
	end

	if upgradeName == "Spoilers" then
		updateVehicleTuningComponent(vehicle, upgradeName, -1)
	end

	for i, id in ipairs(upgradesFromData[upgradeName]) do
		vehicle:removeUpgrade(id)
	end

	local index = tonumber(vehicle:getData(upgradeName))
	if not index then
		return false
	end
	if upgradeName == "Spoilers" then
		if index > #upgradesFromData[upgradeName] then
			return updateVehicleTuningComponent(vehicle, upgradeName, index - #upgradesFromData[upgradeName])
		elseif index == 0 then
			return updateVehicleTuningComponent(vehicle, upgradeName, 0)
		else
			updateVehicleTuningComponent(vehicle, upgradeName, -1)
		end
	end
	local id = upgradesFromData[upgradeName][index]
	if id then
		return vehicle:addUpgrade(id)
	end
end

-- Полностью обновить тюнинг на автомобиле
local function updateVehicleTuning(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return false
	end
	for name in pairs(componentsFromData) do
		updateVehicleTuningComponent(vehicle, name)
	end
	for name in pairs(upgradesFromData) do
		updateVehicleTuningUpgrade(vehicle, name)
	end
	return true
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" or not isElementStreamedIn(source) then
		return
	end
	if componentsFromData[name] then
		updateVehicleTuningComponent(source, name)
	end
	if upgradesFromData[name] then
		updateVehicleTuningUpgrade(source, name)
	end
end)

-- Обновить тюнинг всех автомобилей при запуске
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
		updateVehicleTuning(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateVehicleTuning(source)
	end
end)

-- Список названий компонентов
function getComponentsNames()
	local l = {}
	for name in pairs(componentsFromData) do
		table.insert(l, name)
	end
	for name in pairs(upgradesFromData) do
		table.insert(l, name)
	end
	table.insert(l, "WheelsF")
	table.insert(l, "WheelsR")
	table.insert(l, "Exhaust")
	return l
end
