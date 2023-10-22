-- Кастомизация колёса автомобиля, синхронизация

local vehicleWheels = {}

local WHEEL_LF_DUMMY = "wheel_lf_dummy"
local WHEEL_RF_DUMMY = "wheel_rf_dummy"
local WHEEL_LB_DUMMY = "wheel_lb_dummy"
local WHEEL_RB_DUMMY = "wheel_rb_dummy"

-- Front/rear wheels
local frontWheels = {
    [WHEEL_LF_DUMMY] = true,
    [WHEEL_RF_DUMMY] = true
}
local rearWheels = {
    [WHEEL_LB_DUMMY] = true,
    [WHEEL_RB_DUMMY] = true
}

-- Все колёса
local wheelsNames = {WHEEL_RF_DUMMY, WHEEL_LF_DUMMY, WHEEL_RB_DUMMY, WHEEL_LB_DUMMY}

-- Модели объектов колёс
local wheelsModels = {1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098,2101,2102,2103,2104,2106,2107,2108,2109,2110,2111,2112,2115,2116,2117,2118,2119,2120,2127,2826,2827,2828,2829,3071,3072,3077,2128,2129,2130,2131,3111}

-- Дата, изменение которой вызывает обновление колёс
local dataNames = {
	["WheelsWidthF"] 	= true,
	["WheelsWidthR"] 	= true,
	["WheelsAngleF"] 	= true,
	["WheelsAngleR"] 	= true,
	["Wheels"] 			= true,
	["WheelsF"] 		= true,
	["WheelsR"] 		= true,
	["WheelsSize"] 		= true,
	["WheelsColorR"] 	= true,
	["WheelsColorF"] 	= true,
	["BoltsColorR"] 	= true,
	["BoltsColorF"] 	= true,
	["WheelsCastor"] 	= true,
}

-- Подруливание
local CONFIG_PROPERTY_NAME = "graphics.smooth_steering"
local steeringHelpEnabled = false
local steeringSmoothing = 0.8

local localVehicleSteering = {}
for i, name in ipairs(wheelsNames) do
    localVehicleSteering[name] = 0
end

local shaderReflectionTexture
local wheelsHiddenOffset = Vector3(0, 0, -1000)

local WHEELS_SIZE_MIN = 0.53
local WHEELS_SIZE_MAX = 0.8

local WHEELS_CAMBER_MAX = 16
local WHEELS_WIDTH_MIN = 0.15
local WHEELS_WIDTH_MAX = 0.80

local overrideWheelsScale = {
}

local forceSteering = {}
local forceSteeringAngle = {}

function setForceSteering(vehicle, force, angle)
    forceSteering[vehicle] = force
    if forceSteering[vehicle] then
        forceSteeringAngle[vehicle] = angle
    else
        forceSteeringAngle[vehicle] = nil
        forceSteering[vehicle] = nil
    end
end

-- Удаление кастомных колёс и шейдера
local function removeVehicleWheels(vehicle)
	if not vehicleWheels[vehicle] then
		return false
	end
	local wheels = vehicleWheels[vehicle]
	for name, wheel in pairs(wheels) do
		-- Получение ID колеса из даты
		-- Отобразить
		vehicle:setComponentVisible(name, true)
		-- Обновить размер
		if isElement(wheel.object) then
			destroyElement(wheel.object)
		end
		-- Обновить развал и толщину
		if isElement(wheel.shader) then
			destroyElement(wheel.shader)
		end
		if isElement(wheel.shaderColor) then
			destroyElement(wheel.shaderColor)
		end
		if isElement(wheel.shaderColorBolts) then
			destroyElement(wheel.shaderColorBolts)
		end
		if isElement(wheel.shaderBrakeDisk) then
			destroyElement(wheel.shaderBrakeDisk)
		end
		wheels[name] = nil
	end
	vehicleWheels[vehicle] = nil
	return true
end

-- Обновление колёс из даты без пересоздания шейдера
local function updateVehicleWheels(vehicle)
	if not vehicleWheels[vehicle] then
		return false
	end
	local wheelsScale = 1
	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
	if vehicleName and overrideWheelsScale[vehicleName] then
		wheelsScale = overrideWheelsScale[vehicleName]
	end
	local wheels = vehicleWheels[vehicle]
	for name, wheel in pairs(wheels) do
		-- Получение ID колеса из даты
		local wheelId = vehicle:getData("WheelsF")
		if rearWheels[name] then
			wheelId = vehicle:getData("WheelsR")
		end

		-- Если кастомные колёса - применить настройки
		if type(wheelId) == "number" and wheelId > 0 then
			-- Получение параметров колеса из даты
			local totalSize = WHEELS_SIZE_MAX - WHEELS_SIZE_MIN
			local sizeMul = vehicle:getData("WheelsSize") or 0.5
			local wheelSize = WHEELS_SIZE_MIN + totalSize * sizeMul

			local wheelCamber = 10
			local wheelWidth = 0.15
			local wheelColor = {255, 255, 255}
			local boltColor = {255, 255, 255}
			local wheelsCastor = vehicle:getData("WheelsCastor") or 0
			if frontWheels[name] then
				wheelWidth = vehicle:getData("WheelsWidthF") or 0
				wheelCamber = vehicle:getData("WheelsAngleF") or 0
				wheelColor = vehicle:getData("WheelsColorF")
				boltColor = vehicle:getData("BoltsColorF")
			else
				wheelWidth = vehicle:getData("WheelsWidthR") or 0
				wheelCamber = vehicle:getData("WheelsAngleR") or 0
				wheelColor = vehicle:getData("WheelsColorR")
				boltColor = vehicle:getData("BoltsColorR")
			end
			if not wheelColor then
				wheelColor = {255, 255, 255}
			end
			if not boltColor then
				boltColor = {255, 255, 255}
			end
			wheel.custom = true
			-- Обновить размер
			if isElement(wheel.object) then
				wheel.object.alpha = 255
				wheel.object.model = wheelsModels[wheelId]
				wheel.object.scale = wheelSize * wheelsScale
			end
			-- Обновить развал и толщину
			-- Для шейдера Резины
			if isElement(wheel.shader) then
				wheel.shader:setValue("CastorCoeff", wheelsCastor)
				wheel.shader:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				wheel.shader:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
			end
			-- Для шейдера Тормозного диска
			if isElement(wheel.shaderBrakeDisk) then
				wheel.shader:setValue("CastorCoeff", wheelsCastor)
				wheel.shader:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				wheel.shader:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
			end
			-- Для шейдера покраски диска
			if isElement(wheel.shaderColor) then
				wheel.shaderColor:setValue("CastorCoeff", wheelsCastor)
				wheel.shaderColor:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				wheel.shaderColor:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
				-- Цвет колеса
				for i = 1, 3 do
					wheelColor[i] = wheelColor[i] / 255
				end
				wheelColor[4] = 1
				wheel.shaderColor:setValue("sColor", wheelColor)
			end
			-- Для шейдера покраски болтов
			if isElement(wheel.shaderColorBolts) then
				wheel.shaderColorBolts:setValue("CastorCoeff", wheelsCastor)
				wheel.shaderColorBolts:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				wheel.shaderColorBolts:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
				-- Цвет колеса
				for i = 1, 3 do
					boltColor[i] = boltColor[i] / 255
				end
				boltColor[4] = 1
				wheel.shaderColorBolts:setValue("sColor", boltColor)
			end
			
			wheels[name] = wheel
		else
			wheel.custom = false
			wheel.object.alpha = 0
			wheel.object.model = 1852
		end
		-- Скрыть/отобразить стандартное колесо
		setVehicleComponentVisible(vehicle, name, not wheel.custom)
	end
	return true
end

-- Создание кастомных колёс на автомобиле
local function setupVehicleWheels(vehicle)
	if not isElement(vehicle) then
		return false
	end
	if not isElementStreamedIn(vehicle) then
		return false
	end
	if vehicleWheels[vehicle] then
		return false
	end
	local wheels = {}
	for i, name in ipairs(wheelsNames) do
		local wheel = {}
		local wx,wy,wz = getVehicleComponentPosition(vehicle, name)
		-- Создать объект колеса
		wheel.object = createObject(3045, wx,wy,wz)
		wheel.object.alpha = 0
		wheel.object:setCollisionsEnabled(false)
		if wheel.object.dimension ~= vehicle.dimension then
			wheel.object.dimension = vehicle.dimension
		end
		-- Отобразить стандартные колёса по умолчанию
		vehicle:setComponentVisible(name, true)
		-- Сохранить начальную позицию колёс
		local x, y, z = vehicle:getComponentPosition(name)
		attachElements(wheel.object, vehicle, x, y, z)
		wheel.position = {x, y, z}
		-- Шейдер
		-- Шейдер для резины
		wheel.shader = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shader:setValue("sNormalTexture", NormalTexture)
		-- Шейдер для тормозного диска
		wheel.shaderBrakeDisk = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shaderBrakeDisk:setValue("sNormalTexture", BrakeNormal)
		wheel.shaderBrakeDisk:setValue("normalFactor", 1)
		wheel.shaderBrakeDisk:setValue("ChromePower", 0.1)
		wheel.shaderBrakeDisk:setValue("ColorNormals", {0.8,0.8,0.8,1})
		-- Шейдер включая покраску только диска
		wheel.shaderColor = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shaderColor:setValue("sReflectionTexture", shaderReflectionTexture)
		wheel.shaderColor:setValue("sNormalTexture", RimNormal)
		wheel.shaderColor:setValue("sSpecularTexture", RimSpecular)
		wheel.shaderColor:setValue("normalFactor", 1.25)
		wheel.shaderColor:setValue("ChromePower", 0.25)
		wheel.shaderColor:setValue("ColorNormals", {0.8,0.8,0.8,1})
		-- Шейдер включая покраску только болтов
		wheel.shaderColorBolts = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shaderColorBolts:setValue("sReflectionTexture", shaderReflectionTexture)
		wheel.shaderColorBolts:setValue("sNormalTexture", RimNormal)
		wheel.shaderColorBolts:setValue("sSpecularTexture", RimSpecular)
		wheel.shaderColorBolts:setValue("normalFactor", 1.25)
		wheel.shaderColorBolts:setValue("ChromePower", 0.25)
		wheel.shaderColorBolts:setValue("ColorNormals", {0.8,0.8,0.8,1})
		
		-- Наложение определённого шейдера на модель/текстуру
		wheel.shader:applyToWorldTexture("*", wheel.object)
		wheel.shaderBrakeDisk:applyToWorldTexture("brake", wheel.object)
		wheel.shaderColor:applyToWorldTexture("*_whdiff", wheel.object)
		wheel.shaderColorBolts:applyToWorldTexture("bolts_color1", wheel.object)
		wheels[name] = wheel
	end
	vehicleWheels[vehicle] = wheels
	updateVehicleWheels(vehicle)
	return true
end

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	setupVehicleWheels(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	removeVehicleWheels(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	removeVehicleWheels(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	shaderReflectionTexture = dxCreateTexture("assets/reflection_cubemap.dds", "dxt5")
	NormalTexture = dxCreateTexture("assets/tyre_n.dds", "dxt5")
	RimNormal = dxCreateTexture("assets/flat_n.dds")
	RimSpecular = dxCreateTexture("assets/carpaint_flakes_s.dds")
	BrakeNormal = dxCreateTexture("assets/brake_n.dds", "dxt5")

	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleWheels(vehicle)
	end

	steeringHelpEnabled = not not exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME)
end)

local function getDriftAngle(vehicle)
	if vehicle.velocity.length < 0.12 then
		return 0
	end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
	if math.abs(angle) > 100 then
		return 0
	end
	return angle
end

local function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

-- Обновление положения колёс
addEventHandler("onClientPreRender", root, function ()
	if getKeyState("space") then
		steeringSmoothing = 0.1
	else
		steeringSmoothing = 0.2
	end

	local spaceDown = getKeyState("space")
	for vehicle, wheels in pairs(vehicleWheels) do
		local driftAngle = getDriftAngle(vehicle)
		if driftAngle > 50 then
			driftAngle = 50
		end
		local driftMul = 1 - math.min(1, math.abs(driftAngle) / 66)
		local steeringMul = 1
		local isLocalVehicle = vehicle == localPlayer.vehicle
		if isLocalVehicle and spaceDown then
			--steeringMul = 0
		end
		local rotationX, rotationY, rotationZ = getElementRotation(vehicle)
		local vehicleMatrix = vehicle.matrix
		local _,_,rrot = getVehicleComponentRotation(vehicle, WHEEL_RF_DUMMY)
        if not rrot then
            rrot = 0
        end
        local isWheelRight = false
        local isWheelLeft = false
        if rrot > 180 then
            isWheelRight = true
        elseif rrot == 0 then
            isWheelRight = false
            isWheelLeft = false
        else
            isWheelLeft = true
        end
		for name, wheel in pairs(wheels) do
			if wheel.custom then
				local wheelRotation = vehicle:getComponentRotation(name)
				local rx, ry, rz = vehicle:getComponentRotation(name)
				-- if forceSteering[vehicle] then
                --     rz = rzforceSteeringAngle[vehicle]
                -- end
                local position = vehicleMatrix:transformPosition(wheel.position[1], wheel.position[2], wheel.position[3])
				local steering = 0
				local castorRot = 0
				local currentSteering = 0
				if name == WHEEL_RF_DUMMY then
                    local angleOffset = wrapAngle(rz + 180) - 180
                    if steeringHelpEnabled then
                        steering = driftAngle * 0.6 + angleOffset * driftMul * steeringMul
                    else
                        steering = angleOffset
                    end
                    if isWheelLeft then
                        castorRot = -(rz) / 34
                        if isLocalVehicle then
                            castorRot = -(localVehicleSteering[name]) / 34
                        end
                    elseif isWheelRight then
                        castorRot = (360 - rz ) / 34
                        if isLocalVehicle then
                            castorRot = -(localVehicleSteering[name]) / 34
                        end
                    end
                elseif name == WHEEL_LF_DUMMY then
                    local angleOffset = rz - 180
                    if steeringHelpEnabled then
                        steering = driftAngle * 0.6 + angleOffset * driftMul * steeringMul + 180
                    else
                        steering = angleOffset + 180
                    end
                    if isWheelLeft then
                        castorRot = (rz - 180) / 34
                        if isLocalVehicle then
                            castorRot = (localVehicleSteering[name] - 180) / 34
                        end
                    elseif isWheelRight then
                        castorRot = -(180 - rz) / 34
                        if isLocalVehicle then
                            castorRot = -(180 - localVehicleSteering[name]) / 34
                        end
                    end
                else
					steering = rz
					castorRot = 0
				end
				local currentSteering = steering
				if isLocalVehicle then
					localVehicleSteering[name] = localVehicleSteering[name] + (steering - localVehicleSteering[name]) * steeringSmoothing
					currentSteering = localVehicleSteering[name]
				end
				wheel.object.alpha = vehicle.alpha
				if wheel.object.scale < 0.75 then
					setElementAttachedOffsets(wheel.object,
						wheel.position[1],
						wheel.position[2],
						wheel.position[3] - 0.015
						)
				else
					setElementAttachedOffsets(wheel.object,
						wheel.position[1],
						wheel.position[2],
						wheel.position[3] + (wheel.object.scale * 0.055)
						)
				end
				--setElementRotation(wheel.object, rotationX, rotationY, rotationZ)
				if wheel.object.dimension ~= vehicle.dimension then
					wheel.object.dimension = vehicle.dimension
				end
				-- Для шейдера резины
				wheel.shader:setValue("sRotationX", rx)
				wheel.shader:setValue("sRotationZ", currentSteering)
				wheel.shader:setValue("Castor", castorRot)
				-- Для шейдера тормозного диска
				wheel.shaderBrakeDisk:setValue("sRotationX", rx)
				wheel.shaderBrakeDisk:setValue("sRotationZ", currentSteering)
				wheel.shaderBrakeDisk:setValue("Castor", castorRot)
				-- Для шейдера покраски дискоа
				wheel.shaderColor:setValue("sRotationX", rx)
				wheel.shaderColor:setValue("sRotationZ", currentSteering)
				wheel.shaderColor:setValue("Castor", castorRot)
				-- Для шейдера покраски болтов
				wheel.shaderColorBolts:setValue("sRotationX", rx)
				wheel.shaderColorBolts:setValue("sRotationZ", currentSteering)
				wheel.shaderColorBolts:setValue("Castor", castorRot)
			end
			vehicle:setComponentVisible(name, not wheel.custom)
		end
	end
end)


-- Обновление позиции колёс
addEventHandler("onClientHUDRender", root, function ()
	for vehicle, wheels in pairs(vehicleWheels) do
		local wheelsAngleF = vehicle:getData("WheelsAngleF") or 0
		local wheelsAngleR = vehicle:getData("WheelsAngleR") or 0
		for name, wheel in pairs(wheels) do
			local wheelCamber = 0
			if frontWheels[name] then
				wheelCamber = wheelsAngleF
			else
				wheelCamber = wheelsAngleR
			end
			if wheel.custom then
				local x, y, z = vehicle:getComponentPosition(name)
				wheel.position = {x, y, z + wheelCamber / 800}
			end
		end
	end
end)

addEventHandler("onClientRender", root, function ()
	for vehicle, wheels in pairs(vehicleWheels) do
		for name, wheel in pairs(wheels) do
			vehicle:setComponentVisible(name, not wheel.custom)
		end
	end
end)

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if dataNames[name] then
		updateVehicleWheels(source)
	end
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		steeringHelpEnabled = not not value
	end
end)