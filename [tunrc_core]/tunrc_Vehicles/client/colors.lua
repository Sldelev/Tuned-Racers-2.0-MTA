--- Синхронизация цветов автомобилей
-- @script dpVehicles.colors

local function updateVehicleBodyColor(vehicle)
	if not isElement(vehicle) then
		return
	end
	-- Красим машину в белый, т. к. цвет определяется текстурой
	vehicle:setColor(255, 255, 255)
end

-- Обновить все цвета автомобиля
local function updateAllVehicleColors(vehicle)
	if not isElement(vehicle) then
		return
	end
	updateVehicleBodyColor(vehicle)
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if name == "BodyColor" then
		updateVehicleBodyColor(source)
	end
end)

-- Обновить цвет всех автомобилей при запуске
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateAllVehicleColors(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateAllVehicleColors(source)
	end
end)

--[[
--- Синхронизация цветов автомобилей
-- @script kaori_Vehicles.colors

local colorTextures = {
	BodyColor = "body",
}

local function updateVehicleComponentColor(vehicle, dataName)
	local color = vehicle:getData(dataName)
	if type(color) ~= "table" then
		return
	end
	local r, g, b = unpack(color)
	VehicleShaders.replaceColor(vehicle, colorTextures[dataName], r, g, b)

	vehicle:setColor(255, 255, 255)
end

-- Обновить все цвета автомобиля
local function updateAllVehicleColors(vehicle)
	if not isElement(vehicle) then
		return
	end
	for dataName, textureName in pairs(colorTextures) do
		updateVehicleComponentColor(vehicle, dataName)
	end
end

addEventHandler("onClientElementDataChange", root, function (dataName, oldVaue, newValue)
	if source.type == "vehicle" and source.streamedIn then
		if colorTextures[dataName] then
			updateVehicleComponentColor(source, dataName)
		end
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
		updateAllVehicleColors(vehicle)
	end
end)

-- Обновить цвет всех автомобилей при запуске
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
		updateAllVehicleColors(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if isElement(source) and source.type == "vehicle" then
		updateAllVehicleColors(source)
	end
end)]]
