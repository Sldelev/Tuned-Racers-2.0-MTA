-- Кастомизация колёса автомобиля, синхронизация

local vehicleWheels = {}
local vehicleCalipers = {}
local vehicleTires = {}

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

local calipersModels = {1028,1029}

local tiresModels = {1057,1058}

-- Дата, изменение которой вызывает обновление колёс
local dataNames = {
	-- диски
	["WheelsWidthF"] 	= true,
	["WheelsWidthR"] 	= true,
	["WheelsAngleF"] 	= true,
	["WheelsAngleR"] 	= true,
	["Wheels"] 			= true,
	["WheelsF"] 		= true,
	["WheelsR"] 		= true,
	["WheelsSizeF"] 	= true,
	["WheelsSizeR"] 	= true,
	["WheelsColorR"] 	= true,
    ["WheelsSpecularR"] = true,
    ["WheelsChromeR"] 	= true,
	["WheelsColorF"] 	= true,
	["WheelsSpecularF"] = true,
	["WheelsChromeF"] 	= true,
	["WheelsCastor"] 	= true,
	-- болты
	["BoltsColorR"] 	= true,
	["BoltsColorF"] 	= true,
	-- суппорта
	["WheelsCaliperF"] 	= true,
	["WheelsCaliperR"] 	= true,
	["CalipersColorF"] 	= true,
	["CalipersColorR"] 	= true,
	["CalipersRotationF"] 	= true,
	["CalipersRotationR"] 	= true,
	-- Резина
	["WheelsTiresF"] 	= true,
	["WheelsTiresR"] 	= true,
}

local wheelCalipersXOffset = {
	[1025] = 0,
	[1073] = 0,
	[1074] = -0.02,
	[1075] = -0.015,
	[1076] = -0.015,
	[1077] = -0.02
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
	-- получение данных колёс из таблицы
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
		if isElement(wheel.shaderNoPt) then
			destroyElement(wheel.shaderNoPt)
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
	-- суппорта
	local calipers = vehicleCalipers[vehicle]
	for name, caliper in pairs(calipers) do	
		vehicle:setComponentVisible(name, true)
		if isElement(caliper.object) then
			destroyElement(caliper.object)
		end
		-- Обновить развал и толщину
		if isElement(caliper.shader) then
			destroyElement(caliper.shader)
		end
		if isElement(caliper.shaderNoPaint) then
			destroyElement(caliper.shaderNoPaint)
		end
		calipers[name] = nil
	end
	vehicleCalipers[vehicle] = nil
	-- суппорта
	local tires = vehicleTires[vehicle]
	for name, tire in pairs(tires) do	
		vehicle:setComponentVisible(name, true)
		if isElement(tire.object) then
			destroyElement(tire.object)
		end
		-- Обновить развал и толщину
		if isElement(tire.shader) then
			destroyElement(tire.shader)
		end
		tire[name] = nil
	end
	vehicleTires[vehicle] = nil
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
			totalSize = WHEELS_SIZE_MAX - WHEELS_SIZE_MIN
			sizeMulF = vehicle:getData("WheelsSizeF") or 0.5
			sizeMulR = vehicle:getData("WheelsSizeR") or 0.5
			wheelSizeF = WHEELS_SIZE_MIN + totalSize * sizeMulF
			wheelSizeR = WHEELS_SIZE_MIN + totalSize * sizeMulR

			wheelCamber = 10
			wheelWidth = 0.15
			wheelsCastor = vehicle:getData("WheelsCastor") or 0
			
			local wheelColor = {255, 255, 255}
			local boltColor = {255, 255, 255}
			local chrome = 0.25
			
			if frontWheels[name] then
				wheelWidth = vehicle:getData("WheelsWidthF") or 0
				wheelCamber = vehicle:getData("WheelsAngleF") or 0
				wheelColor = vehicle:getData("WheelsColorF")
				boltColor = vehicle:getData("BoltsColorF")
				specularColor = vehicle:getData("WheelsSpecularF")
				chrome = vehicle:getData("WheelsChromeF")
			else
				wheelWidth = vehicle:getData("WheelsWidthR") or 0
				wheelCamber = vehicle:getData("WheelsAngleR") or 0
				wheelColor = vehicle:getData("WheelsColorR")
				boltColor = vehicle:getData("BoltsColorR")
				specularColor = vehicle:getData("WheelsSpecularR")
				chrome = vehicle:getData("WheelsChromeR")
			end
			if not wheelColor then
				wheelColor = {255, 255, 255}
			end
			if not boltColor then
				boltColor = {255, 255, 255}
			end
			if not specularColor then
				specularColor = wheelColor
			end
			if not chrome then
				chrome = 0.25 * 100
			end
			wheel.custom = true
			-- Обновить размер
			if isElement(wheel.object) then
				wheel.object.alpha = 255
				wheel.object.model = wheelsModels[wheelId]
				if frontWheels[name] then
					wheel.object.scale = wheelSizeF * wheelsScale
				else
					wheel.object.scale = wheelSizeR * wheelsScale
				end
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
				wheel.shaderBrakeDisk:setValue("CastorCoeff", wheelsCastor)
				wheel.shaderBrakeDisk:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				wheel.shaderBrakeDisk:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
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
				-- цвет блика на колесе
				for i = 1, 3 do
					specularColor[i] = specularColor[i] / 225
				end
				specularColor[4] = 1
				
				-- сила хрома диска
				chrome = chrome
				wheel.shaderColor:setValue("sColor", wheelColor)
				wheel.shaderColor:setValue("ColorNormals", specularColor)
				wheel.shaderColor:setValue("ChromePower", chrome)
			end
			
			-- Для шейдера покраски только центра диска
			if isElement(wheel.shaderNoPt) then
				wheel.shaderNoPt:setValue("CastorCoeff", wheelsCastor)
				wheel.shaderNoPt:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				wheel.shaderNoPt:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
				-- цвет блика на колесе
				for i = 1, 3 do
					specularColor[i] = specularColor[i] / 225
				end
				specularColor[4] = 1
				
				-- сила хрома диска
				chrome = chrome
				wheel.shaderNoPt:setValue("ColorNormals", specularColor)
				wheel.shaderNoPt:setValue("ChromePower", chrome)
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
			wheel.object.model = 3045
		end
		-- Скрыть/отобразить стандартное колесо
		setVehicleComponentVisible(vehicle, name, not wheel.custom)
	end	
	
	local calipers = vehicleCalipers[vehicle]
	for name, caliper in pairs(calipers) do
		local wheelId = vehicle:getData("WheelsF")
		if rearWheels[name] then
			wheelId = vehicle:getData("WheelsR")
		end
		
		if frontWheels[name] then
			wheelCaliperId = vehicle:getData("WheelsCaliperF")
		elseif rearWheels[name] then
			wheelCaliperId = vehicle:getData("WheelsCaliperR")
		end
			
		if type(wheelCaliperId) == "number" and wheelCaliperId > 0 and type(wheelId) == "number" and wheelId > 0 then
			local caliperColor = {255, 255, 255}
			if frontWheels[name] then
				wheelWidth = vehicle:getData("WheelsWidthF") or 0
				wheelCamber = vehicle:getData("WheelsAngleF") or 0
				caliperRot = vehicle:getData("CalipersRotationF") or 0
				caliperColor = vehicle:getData("CalipersColorF")
			else
				wheelWidth = vehicle:getData("WheelsWidthR") or 0
				wheelCamber = vehicle:getData("WheelsAngleR") or 0
				caliperRot = vehicle:getData("CalipersRotationR") or 0
				caliperColor = vehicle:getData("CalipersColorR")
			end
			if not caliperColor then
				caliperColor = {255, 255, 255}
			end
			caliper.custom = true
			if isElement(caliper.object) then			
				caliper.object.alpha = 255
				caliper.object.model = calipersModels[wheelCaliperId]
				if frontWheels[name] then
					caliper.object.scale = wheelSizeF * wheelsScale
				else
					caliper.object.scale = wheelSizeR * wheelsScale
				end
			end
			
			if isElement(caliper.shader) then
				caliper.shader:setValue("CastorCoeff", wheelsCastor)
				caliper.shader:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				caliper.shader:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
				-- Цвет колеса
				for i = 1, 3 do
					caliperColor[i] = caliperColor[i] / 255
				end
				caliperColor[4] = 1
				caliper.shader:setValue("sColor", caliperColor)
				caliper.shader:setValue("ColorNormals", {caliperColor[1] * 0.80,caliperColor[2] * 0.80,caliperColor[3] * 0.80,1})
			end
			
			if isElement(caliper.shaderNoPaint) then
				caliper.shaderNoPaint:setValue("CastorCoeff", wheelsCastor)
				caliper.shaderNoPaint:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				caliper.shaderNoPaint:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
			end
			
			if name == WHEEL_RF_DUMMY or name == WHEEL_RB_DUMMY then
				caliper.shader:setValue("sRotationX", caliperRot)
				caliper.shaderNoPaint:setValue("sRotationX", caliperRot)
			else
				caliper.shader:setValue("sRotationX", -caliperRot + 180)
				caliper.shaderNoPaint:setValue("sRotationX", -caliperRot + 180)
			end
			
			calipers[name] = caliper
		else
			caliper.custom = false
			caliper.object.alpha = 0
			caliper.object.model = 3047
		end
	end
	
	-- Резина
	local tires = vehicleTires[vehicle]
	for name, tire in pairs(tires) do
		local wheelId = vehicle:getData("WheelsF")
		if rearWheels[name] then
			wheelId = vehicle:getData("WheelsR")
		end
		
		if frontWheels[name] then
			wheelTireId = vehicle:getData("WheelsTiresF")
		elseif rearWheels[name] then
			wheelTireId = vehicle:getData("WheelsTiresR")
		end
		
		if not wheelTireId then
			wheelTireId = 1
		end
			
		if type(wheelTireId) == "number" and wheelTireId > 0 and type(wheelId) == "number" and wheelId > 0 then
			if frontWheels[name] then
				wheelWidth = vehicle:getData("WheelsWidthF") or 0
				wheelCamber = vehicle:getData("WheelsAngleF") or 0
			else
				wheelWidth = vehicle:getData("WheelsWidthR") or 0
				wheelCamber = vehicle:getData("WheelsAngleR") or 0
			end
			tire.custom = true
			if isElement(tire.object) then			
				tire.object.alpha = 255
				tire.object.model = tiresModels[wheelTireId]
				if frontWheels[name] then
					tire.object.scale = wheelSizeF * wheelsScale
				else
					tire.object.scale = wheelSizeR * wheelsScale
				end
			end
			
			if isElement(tire.shader) then
				tire.shader:setValue("CastorCoeff", wheelsCastor)
				tire.shader:setValue("sCamber", -wheelCamber * WHEELS_CAMBER_MAX)
				tire.shader:setValue("sWidth", WHEELS_WIDTH_MIN + wheelWidth * (WHEELS_WIDTH_MAX - WHEELS_WIDTH_MIN))
			end
			
			tires[name] = tire
		else
			tire.custom = false
			tire.object.alpha = 0
			tire.object.model = 3049
		end
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
	local calipers = {}
	local tires = {}
	for i, name in ipairs(wheelsNames) do
		local wheel = {}
		local caliper = {}
		local tire = {}
		local wx,wy,wz = getVehicleComponentPosition(vehicle, name)
		-- Создать объект колеса
		wheel.object = createObject(3045, wx,wy,wz)
		wheel.object.alpha = 0
		wheel.object:setCollisionsEnabled(false)
		-- создать объект суппорта
		caliper.object = createObject(3047, wx,wy,wz)
		caliper.object.alpha = 0
		caliper.object:setCollisionsEnabled(false)
		-- создать объект резины
		tire.object = createObject(3049, wx,wy,wz)
		tire.object.alpha = 0
		tire.object:setCollisionsEnabled(false)
		
		if wheel.object.dimension ~= vehicle.dimension then
			wheel.object.dimension = vehicle.dimension
			caliper.object.dimension = vehicle.dimension
			tire.object.dimension = vehicle.dimension
		end
		-- Отобразить стандартные колёса по умолчанию
		vehicle:setComponentVisible(name, true)
		-- Сохранить начальную позицию колёс
		local x, y, z = vehicle:getComponentPosition(name)
		attachElements(wheel.object, vehicle, x, y, z)
		wheel.position = {x, y, z}
		attachElements(caliper.object, vehicle, x, y, z)
		caliper.position = {x, y, z}
		attachElements(tire.object, vehicle, x, y, z)
		tire.position = {x, y, z}
		-- Шейдер
		-- Шейдер
		wheel.shader = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shader:setValue("sNormalTexture", NormalTexture)
		wheel.shader:setValue("ColorNormals", {0.2,0.2,0.2,1})
		wheel.shader:setValue("sColor", {0.25,0.25,0.25,1})
		-- Шейдер для резины
		tire.shader = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		tire.shader:setValue("sNormalTexture", NormalTexture)
		tire.shader:setValue("ColorNormals", {0.2,0.2,0.2,1})
		tire.shader:setValue("sColor", {0.25,0.25,0.25,1})
		-- Шейдер для суппорта
		caliper.shader = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		caliper.shader:setValue("sNormalTexture", RimNormal)
		
		caliper.shaderNoPaint = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		caliper.shaderNoPaint:setValue("ColorNormals", {0.2,0.2,0.2,1})
		caliper.shaderNoPaint:setValue("sColor", {0.6,0.6,0.6,1})
		-- Шейдер для тормозного диска
		wheel.shaderBrakeDisk = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shaderBrakeDisk:setValue("sNormalTexture", BrakeNormal)
		wheel.shaderBrakeDisk:setValue("normalFactor", 1)
		wheel.shaderBrakeDisk:setValue("ChromePower", 0.1)
		wheel.shaderBrakeDisk:setValue("ColorNormals", {0.7,0.7,0.7,1})
		wheel.shaderBrakeDisk:setValue("sColor", {0.6,0.6,0.6,1})
		-- Шейдер включая покраску только диска
		wheel.shaderColor = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shaderColor:setValue("sReflectionTexture", shaderReflectionTexture)
		wheel.shaderColor:setValue("sNormalTexture", RimNormal)
		wheel.shaderColor:setValue("sSpecularTexture", RimSpecular)
		wheel.shaderColor:setValue("normalFactor", 1.25)
		-- Шейдер включая покраску только центра диска
		wheel.shaderNoPt = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shaderNoPt:setValue("sReflectionTexture", shaderReflectionTexture)
		wheel.shaderNoPt:setValue("sNormalTexture", RimNormal)
		wheel.shaderNoPt:setValue("sSpecularTexture", RimSpecular)
		wheel.shaderNoPt:setValue("normalFactor", 1.25)
		wheel.shaderNoPt:setValue("sColor", {0.6,0.6,0.6,1})
		-- Шейдер включая покраску только болтов
		wheel.shaderColorBolts = DxShader("assets/shaders/wheel.fx", 0, 50, false, "object")
		wheel.shaderColorBolts:setValue("sReflectionTexture", shaderReflectionTexture)
		wheel.shaderColorBolts:setValue("sNormalTexture", RimNormal)
		wheel.shaderColorBolts:setValue("sSpecularTexture", RimSpecular)
		wheel.shaderColorBolts:setValue("normalFactor", 1.25)
		
		-- Наложение определённого шейдера на модель/текстуру
		wheel.shader:applyToWorldTexture("*", wheel.object)
		tire.shader:applyToWorldTexture("*_tire", tire.object)
		caliper.shaderNoPaint:applyToWorldTexture("*_logo", caliper.object)
		caliper.shaderNoPaint:applyToWorldTexture("*_caliper_bolts", caliper.object)
		caliper.shader:applyToWorldTexture("*_caliperColor", caliper.object)
		wheel.shaderBrakeDisk:applyToWorldTexture("brake", wheel.object)
		wheel.shaderColor:applyToWorldTexture("*_whdiff", wheel.object)
		wheel.shaderNoPt:applyToWorldTexture("*_npt", wheel.object)
		wheel.shaderColorBolts:applyToWorldTexture("bolts_color1", wheel.object)
		wheels[name] = wheel
		calipers[name] = caliper
		tires[name] = tire
	end
	vehicleWheels[vehicle] = wheels
	vehicleCalipers[vehicle] = calipers
	vehicleTires[vehicle] = tires
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
	HeatTexture = dxCreateTexture("assets/brake_heat.png")
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
					wheelRotation = vehicle:getComponentRotation(name)
					rx, ry, rz = vehicle:getComponentRotation(name)
					if forceSteering[vehicle] then
						if frontWheels[name] then
							if name == WHEEL_RF_DUMMY then
								rz = forceSteeringAngle[vehicle]
							elseif name == WHEEL_LF_DUMMY then
								rz = forceSteeringAngle[vehicle] - 180
							end
						end
					end
					position = vehicleMatrix:transformPosition(wheel.position[1], wheel.position[2], wheel.position[3])
					steering = 0
					castorRot = 0
					currentSteering = 0
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
					currentSteering = steering
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
					-- Для шейдера покраски центра дискоа
					wheel.shaderNoPt:setValue("sRotationX", rx)
					wheel.shaderNoPt:setValue("sRotationZ", currentSteering)
					wheel.shaderNoPt:setValue("Castor", castorRot)
					-- Для шейдера покраски болтов
					wheel.shaderColorBolts:setValue("sRotationX", rx)
					wheel.shaderColorBolts:setValue("sRotationZ", currentSteering)
					wheel.shaderColorBolts:setValue("Castor", castorRot)
				end
				vehicle:setComponentVisible(name, not wheel.custom)
			end
		end
	for vehicle, calipers in pairs(vehicleCalipers) do
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
		for name, caliper in pairs(calipers) do
			if caliper.custom then
			
					local wheelId = vehicle:getData("WheelsF")
					if rearWheels[name] then
						wheelId = vehicle:getData("WheelsR")
					end
					
					wheelRotation = vehicle:getComponentRotation(name)
					rx, ry, rz = vehicle:getComponentRotation(name)
					if forceSteering[vehicle] then
						if frontWheels[name] then
							if name == WHEEL_RF_DUMMY then
								rz = forceSteeringAngle[vehicle]
							elseif name == WHEEL_LF_DUMMY then
								rz = forceSteeringAngle[vehicle] - 180
							end
						end
					end
					position = vehicleMatrix:transformPosition(caliper.position[1], caliper.position[2], caliper.position[3])
					steering = 0
					castorRot = 0
					currentSteering = 0
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
					currentSteering = steering
					if isLocalVehicle then
						localVehicleSteering[name] = localVehicleSteering[name] + (steering - localVehicleSteering[name]) * steeringSmoothing
						currentSteering = localVehicleSteering[name]
					end
				caliper.object.alpha = vehicle.alpha
				if name == WHEEL_RF_DUMMY or name == WHEEL_RB_DUMMY then
					if caliper.object.scale < 0.75 then
						setElementAttachedOffsets(caliper.object,
							caliper.position[1] + wheelCalipersXOffset[wheelsModels[wheelId]],
							caliper.position[2],
							caliper.position[3] - 0.015
						)
					else
						setElementAttachedOffsets(caliper.object,
							caliper.position[1],
							caliper.position[2],
							caliper.position[3] + (caliper.object.scale * 0.055)
						)
					end
				else
					if caliper.object.scale < 0.75 then
						setElementAttachedOffsets(caliper.object,
							caliper.position[1] - wheelCalipersXOffset[wheelsModels[wheelId]],
							caliper.position[2],
							caliper.position[3] - 0.015
						)
					else
						setElementAttachedOffsets(caliper.object,
							caliper.position[1],
							caliper.position[2],
							caliper.position[3] + (caliper.object.scale * 0.055)
						)
					end
				end
				if caliper.object.dimension ~= vehicle.dimension then
					caliper.object.dimension = vehicle.dimension
				end
				caliper.shader:setValue("sRotationZ", currentSteering)
				caliper.shader:setValue("Castor", castorRot)
				caliper.shaderNoPaint:setValue("sRotationZ", currentSteering)
				caliper.shaderNoPaint:setValue("Castor", castorRot)
			end
		end
	end
	for vehicle, tires in pairs(vehicleTires) do
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
		for name, tire in pairs(tires) do
			if tire.custom then
					wheelRotation = vehicle:getComponentRotation(name)
					rx, ry, rz = vehicle:getComponentRotation(name)
					if forceSteering[vehicle] then
						if frontWheels[name] then
							if name == WHEEL_RF_DUMMY then
								rz = forceSteeringAngle[vehicle]
							elseif name == WHEEL_LF_DUMMY then
								rz = forceSteeringAngle[vehicle] - 180
							end
						end
					end
					position = vehicleMatrix:transformPosition(tire.position[1], tire.position[2], tire.position[3])
					steering = 0
					castorRot = 0
					currentSteering = 0
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
					currentSteering = steering
					if isLocalVehicle then
						localVehicleSteering[name] = localVehicleSteering[name] + (steering - localVehicleSteering[name]) * steeringSmoothing
						currentSteering = localVehicleSteering[name]
					end
				tire.object.alpha = vehicle.alpha
				if tire.object.scale < 0.75 then
					setElementAttachedOffsets(tire.object,
						tire.position[1],
						tire.position[2],
						tire.position[3] - 0.015
					)
				else
					setElementAttachedOffsets(tire.object,
						tire.position[1],
						tire.position[2],
						tire.position[3] + (tire.object.scale * 0.055)
					)
				end
				if tire.object.dimension ~= vehicle.dimension then
					tire.object.dimension = vehicle.dimension
				end
				tire.shader:setValue("sRotationX", rx)
				tire.shader:setValue("sRotationZ", currentSteering)
				tire.shader:setValue("Castor", castorRot)
			end
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
	
	for vehicle, calipers in pairs(vehicleCalipers) do
		local wheelsAngleF = vehicle:getData("WheelsAngleF") or 0
		local wheelsAngleR = vehicle:getData("WheelsAngleR") or 0
		for name, caliper in pairs(calipers) do
			local wheelCamber = 0
			if frontWheels[name] then
				wheelCamber = wheelsAngleF
			else
				wheelCamber = wheelsAngleR
			end
			if caliper.custom then
				local x, y, z = vehicle:getComponentPosition(name)
				caliper.position = {x, y, z + wheelCamber / 800}
			end
		end
	end
	
	for vehicle, tires in pairs(vehicleTires) do
		local wheelsAngleF = vehicle:getData("WheelsAngleF") or 0
		local wheelsAngleR = vehicle:getData("WheelsAngleR") or 0
		for name, tire in pairs(tires) do
			local wheelCamber = 0
			if frontWheels[name] then
				wheelCamber = wheelsAngleF
			else
				wheelCamber = wheelsAngleR
			end
			if tire.custom then
				local x, y, z = vehicle:getComponentPosition(name)
				tire.position = {x, y, z + wheelCamber / 800}
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
	for vehicle, calipers in pairs(vehicleCalipers) do
		for name, caliper in pairs(calipers) do
			vehicle:setComponentVisible(name, not caliper.custom)
		end
	end
	for vehicle, tires in pairs(vehicleTires) do
		for name, tire in pairs(tires) do
			vehicle:setComponentVisible(name, not tire.custom)
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