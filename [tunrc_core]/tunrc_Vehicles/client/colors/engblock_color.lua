function setupEngBlockColor(vehicle)
	local color = vehicle:getData("EngBlockColor")
	if type(color) ~= "table" then
		return
	end
	local r, g, b = unpack(color)
	VehicleShaders.replaceColor(vehicle, "engblock_color", r, g, b)
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupEngBlockColor(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupEngBlockColor(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupEngBlockColor(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "EngBlockColor" then
		setupEngBlockColor(source)
	end
end)