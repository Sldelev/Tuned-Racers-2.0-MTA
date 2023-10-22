function setupRollcageColor(vehicle)
	local color = vehicle:getData("RollcageColor")
	if type(color) ~= "table" then
		return
	end
	local r, g, b = unpack(color)
	VehicleShaders.replaceColor(vehicle, "rollcage_color", r, g, b)
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupRollcageColor(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupRollcageColor(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupRollcageColor(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "RollcageColor" then
		setupRollcageColor(source)
	end
end)