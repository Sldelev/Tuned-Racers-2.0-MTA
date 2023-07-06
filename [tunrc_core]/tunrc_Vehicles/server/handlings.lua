local handlingData = {
	street = "StreetHandling",
	drift = "DriftHandling"
}

local function setupVehicleHandling(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
	local activeHandling = vehicle:getData("activeHandling")
	if not activeHandling then
		activeHandling = "drift"
		vehicle:setData("activeHandling", activeHandling)
	end
	-- Handling forcing
	local forceHandling = vehicle:getData("forceHandling")
	if type(forceHandling) == "string" then
		vehicle:setData("activeHandling", forceHandling)
		activeHandling = forceHandling
	end	

	local handlingLevel = vehicle:getData(handlingData[activeHandling])
	if type(handlingLevel) ~= "number" then
		handlingLevel = 0
	end
	-- Если дрифт-хандлинг не куплен
	if activeHandling == "drift" and handlingLevel == 0 then
		vehicle:setData("activeHandling", "street")
		return
	end
	if activeHandling == "street" then
		handlingLevel = handlingLevel + 1
	else
		handlingLevel = 1
	end
	local handlingsTable = getVehicleHandlingTable(vehicleName, activeHandling, handlingLevel)
	if not handlingsTable then
		return false
	end
	for k, v in pairs(handlingsTable) do
		setVehicleHandling(vehicle, k, v, false)
	end
	-- Напрямую влияет на поведение автомобиля
	updateVehicleMaxVelocity(vehicle) -- Максимальная скорость
	updateVehicleSteer(vehicle) -- Выворот
	updateVehicleMass(vehicle) -- Масса
	updateVehicleTurnMass(vehicle) -- Ходовая Масса
	updateVehicleWheelAcceleration(vehicle) -- Ускорение зависимое от развала задней оси
	-- Имеет меньшее воздействие
	updateVehicleBias(vehicle)
	updateVehicleSuspension(vehicle)
end

addEvent("onVehicleCreated", false)
addEventHandler("onVehicleCreated", root, function () 
	if source.type ~= "vehicle" then
		return
	end
	source:setData("activeHandling", "drift")
	setupVehicleHandling(source)
end)

addEventHandler("onResourceStart", resourceRoot, function ()

	for i, v in ipairs(getElementsByType("vehicle")) do
		v:setData("activeHandling", "drift")
	end
end)

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "activeHandling" then
		setupVehicleHandling(source)
	end
end)

addEvent("switchPlayerHandling", true)
addEventHandler("switchPlayerHandling", resourceRoot, function ()
	if not client.vehicle or client.vehicle.controller ~= client then
		return 
	end
	if client.vehicle:getData("activeHandling") == "street" then
		client.vehicle:setData("activeHandling", "drift", true)
	else
		client.vehicle:setData("activeHandling", "street", true)
	end
end)

function forceVehicleHandling(vehicle, handlingName)
	if not isElement(vehicle) then
		return false
	end
	if type(handlingName) ~= "string" then
		return unforceVehicleHandling(vehicle)
	end
	local handlingLevel = vehicle:getData(handlingData[handlingName])
	if type(handlingLevel) ~= "number" then
		return false
	end
	if handlingName == "drift" and handlingLevel <= 0 then
		return false
	end
	vehicle:setData("activeHandling", handlingName)	
	vehicle:setData("forceHandling", handlingName)
	return true
end

function unforceVehicleHandling(vehicle)
	if not isElement(vehicle) then
		return false
	end
	vehicle:setData("forceHandling", false)
	return true
end