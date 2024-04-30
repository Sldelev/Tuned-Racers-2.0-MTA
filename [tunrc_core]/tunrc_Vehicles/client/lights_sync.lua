local vehiclesComponentsOpen = {
  [477] = {"FaraR0", "FaraL0", "FaraRMisc0", "FaraLMisc0"}, --zr350
}

local LIGHTS_STATE_DATA = "LightsState"
local LIGHTS_COLOR_DATA = "LightsColor"
-- Угол поворота открытых/закрытых фар
local ANGLE_OPENED = 60
local ANGLE_CLOSED = 0
local overrideAngleOpened = {
	tunrc_zr350 = 40,
}
-- Скорость открывания/закрывания фар
local LIGHTS_ROTATION_SPEED = 100
-- Автомобили, которые должны быть анимированы
-- (анимируются, автомобили, находящиеся рядом с игроком)
local animateVehicles = {}

-- Обновляет состояние компонента фар автомобиля, запускает анимацию
local function updateVehicleLightsState(vehicle)
    if not isElement(vehicle) then
        return
    end
    local state = not not vehicle:getData(LIGHTS_STATE_DATA)
    -- Угол в зависимости от состояния
    local angle = ANGLE_CLOSED
    if state then
        angle = ANGLE_OPENED
        local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
        if vehicleName and overrideAngleOpened[vehicleName] then
            angle = overrideAngleOpened[vehicleName]
        end
    end
    local stateId = 1
    if state then
        stateId = 2
    end
	local model = vehicle.model
    local components = vehicle:getComponents()
    local hasComponent = components[tostring(unpack(vehiclesComponentsOpen[model]))]

    -- Если автомобиль находится рядом, запустить анимацию фар
    if hasComponent and isElementStreamedIn(vehicle) then
        -- Направление
        local direction = 1
        if not state then
            direction = -1
        end

        -- Выключить свет до начала анимации
        if stateId == 1 then
            setVehicleOverrideLights(vehicle, stateId)
        else
			for i, light in pairs(vehiclesComponentsOpen[model]) do
				local rotation = vehicle:getComponentRotation(tostring(light))
				if rotation.x > 300 then
					vehicle:setComponentRotation(tostring(light), ANGLE_CLOSED, 0, 0)
				end
			end
        end
        animateVehicles[vehicle] = {targetAngle = angle, direction = direction, stateId = stateId}
    else
        if hasComponent then
			for i, light in pairs(vehiclesComponentsOpen[model]) do
				-- Если автомобиль далеко, сразу же открыть/закрыть фары
				vehicle:setComponentRotation(tostring(light), angle, 0, 0)
			end
        end
        setVehicleOverrideLights(vehicle, stateId)
    end

    -- Set headlights color
    --[[local color = vehicle:getData("LightsColor")
    if color then
        vehicle:setHeadLightColor(unpack(color))
    end]]
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for vehicle, animation in pairs(animateVehicles) do
		local model = vehicle.model
        if not isElement(vehicle) then
            animateVehicles[vehicle] = nil
        else
			for i, light in pairs(vehiclesComponentsOpen[model]) do
				local rotation = vehicle:getComponentRotation(tostring(light))
				rotation = rotation.x + animation.direction * LIGHTS_ROTATION_SPEED * deltaTime
				if animation.direction > 0 and rotation >= animation.targetAngle then
					rotation = animation.targetAngle
					animateVehicles[vehicle] = nil
					setVehicleOverrideLights(vehicle, animation.stateId)
				elseif animation.direction < 0 and rotation <= animation.targetAngle then
					rotation = animation.targetAngle
					animateVehicles[vehicle] = nil
					setVehicleOverrideLights(vehicle, animation.stateId)
				end
				vehicle:setComponentRotation(tostring(light), rotation, 0, 0)
			end
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
    if source.type ~= "vehicle" then
        return
    end
    if name == LIGHTS_STATE_DATA or name == LIGHTS_COLOR_DATA then
        updateVehicleLightsState(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        updateVehicleLightsState(vehicle)
    end
end)

addEventHandler("onClientElementStreamedIn", root, function ()
    if source.type ~= "vehicle" then
        return
    end
    updateVehicleLightsState(source)
end)