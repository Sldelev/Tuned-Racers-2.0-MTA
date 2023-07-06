-- Выбор автомобиля
GarageCar = {}

addEvent("tunrc_Garage.assetsLoaded", false)

local CAR_POSITION = Vector3 { x = 1585.5, y = 2252.5, z = 3698.5 }
local vehicle
local vehiclesList = {}
local currentVehicle = 1
local currentTuningTable = {}

-- Время, на которое размораживается машина при смене модели
local unfreezeTimer

-- Дата, которая округляется при сохранении
local configurationData = {
	--Настройки визуальные
    "WheelsOffsetF",
    "WheelsOffsetR",
    "WheelsWidthF",
    "WheelsWidthR",
    "WheelsAngleF",
    "WheelsAngleR",
    "WheelsSize",
	"WheelsCastor",
	--Настройки влияющие на автомобиль
    "Bias",
	"Steer",
	"veh_mass",
	"veh_acceleration",
	"veh_turnmass",
	"veh_velocity",
    "Suspension",
}
-- Цвета, которые выставляются белыми по умолчанию и округляются
local colorsData = {
    "BodyColor",
    "WheelsColorR",
    "WheelsColorF",
	"SmokeColor",
    "SpoilerColor"
}
-- Дата, которая копируется как есть
local copyData = {
    "Numberplate",
	"SteeringTexture",
	"Country",
    "StreetHandling",
	"OffroadHandling",
    "DriftHandling"
}

function setData(key, value)
    vehicle:setData(key, value, false)
end

function getData(key)
    vehicle:getData(key, value)
end

local function updateVehicle()
    currentVehicle = math.min(#vehiclesList, math.max(1, currentVehicle))
    if not vehiclesList[currentVehicle] then
        outputDebugString("Could not load vehicle: " .. tostring(currentVehicle))
        return
    end

    vehicle.model = vehiclesList[currentVehicle].model

    vehicle:setColor(255, 255, 255, 255, 255, 255)
    vehicle.position = CAR_POSITION
    vehicle.rotation = Vector3(0, 0, -90)
    vehicle.velocity = Vector3(0, 0, 0)

    currentTuningTable = {}
    if type(vehiclesList[currentVehicle].tuning) == "string" then
        currentTuningTable = fromJSON(vehiclesList[currentVehicle].tuning)
    end
	
	 if isTimer(unfreezeTimer) then killTimer(unfreezeTimer) end
    unfreezeTimer = setTimer(function ()
        if not isElement(vehicle) then
            killTimer(unfreezeTimer)
            return
        end
        if vehicle.position.z - CAR_POSITION.z > 0.5 then
            vehicle.position = CAR_POSITION
        end
        if currentTuningTable.Suspension and tonumber(currentTuningTable.Suspension) > 0.5 then
            vehicle.velocity = Vector3(0, 0, 0.01)
        else
            vehicle.velocity = Vector3(0, 0, -0.01)
        end
    end, 250, 3)

    -- Наклейки
    local stickersJSON = vehiclesList[currentVehicle].stickers
    if stickersJSON then
        local stickers = fromJSON(stickersJSON)
        if type(stickers) ~= "table" then
            stickers = {}
        end
        setData("stickers", stickers)
    else
        setData("stickers", {})
    end

    GarageCar.resetTuning()
    CarTexture.reset()
end

function GarageCar.getId()
    return vehiclesList[currentVehicle]._id
end

function GarageCar.start(vehicles)
    vehiclesList = vehicles
    currentVehicle = 1
    vehicle = Vehicle(vehiclesList[currentVehicle].model, CAR_POSITION, Vector3(0, 0, -90))
    vehicle.velocity = Vector3(0, 0, 0)
    vehicle.dimension = localPlayer.dimension

    updateVehicle()
    setData("LightsState", false)
end

function GarageCar.stop()
    if isElement(vehicle) then
        destroyElement(vehicle)
    end
end

function GarageCar.getVehicle()
    return vehicle
end

function getVehicle()
    return vehicle
end

function GarageCar.getVehiclePos()
    return CAR_POSITION
end

function getVehiclePos()
    return CAR_POSITION
end

function GarageCar.getVehicleModel()
    return vehiclesList[currentVehicle].model
end

function GarageCar.getMileage()
    return vehiclesList[currentVehicle].mileage
end

function GarageCar.getCarsCount()
    return #vehiclesList
end

function GarageCar.showNextCar()
    currentVehicle = currentVehicle + 1
    if currentVehicle > #vehiclesList then
        currentVehicle = 1
    end
    updateVehicle()
end

function GarageCar.showPreviousCar()
    currentVehicle = currentVehicle - 1
    if currentVehicle < 1 then
        currentVehicle = #vehiclesList
    end
    updateVehicle()
end

function GarageCar.showCarById(id)
    for i, vehicle in ipairs(vehiclesList) do
        if vehicle._id == id then
            currentVehicle = i
            updateVehicle()
            return true
        end
    end
    return false
end

function GarageCar.previewTuning(name, value)
    setData(name, value)
end

function GarageCar.previewHandling(name, value)
    setData(name, value)
end

function GarageCar.applyTuning(name, value)
    if not value then
        value = vehicle:getData(name)
    else
        vehicle:setData(name, value, false)
    end
    currentTuningTable[name] = value
end

function applyTuning(name, value)
    if not value then
        value = vehicle:getData(name)
    else
        vehicle:setData(name, value, false)
    end
    currentTuningTable[name] = value
end

function GarageCar.applyHandling(name, value)
    if not value then
        value = vehicle:getData(name)
    else
        GarageCar.previewHandling(name, value)
        vehicle:setData(name, value, false)
    end
    currentTuningTable[name] = value
end

function GarageCar.applyTuningFromData(name)
    currentTuningTable[name] = vehicle:getData(name)
end

function GarageCar.resetTuning()
    -- Сброс компонентов
    local componentNames = exports.tunrc_Vehicles:getComponentsNames()
    --outputDebugString("LOAD WheelsSize = " .. tostring(currentTuningTable.WheelsSize))
    for i, name in ipairs(componentNames) do
        setData(name, currentTuningTable[name])
    end

    for i, name in ipairs(configurationData) do
        local value = currentTuningTable[name]
        if type(value) == "number" then
            setData(name, value)
        else
            setData(name, 0)
        end
    end

    -- Цвета
    if not currentTuningTable.BodyColor then
        currentTuningTable.BodyColor = {205, 205, 205}
    end
    for i, name in ipairs(colorsData) do
        if currentTuningTable[name] then
            setData(name, currentTuningTable[name])
        else
            setData(name, {205, 205, 205})
        end
    end
    --outputDebugString(tostring(vehicle.model) .. " color: " .. table.concat(vehicle:getData("BodyColor"), ", "))

    for i, name in ipairs(copyData) do
        setData(name, currentTuningTable[name])
    end

    -- Высота подвески
    local suspensionHeight = currentTuningTable["Suspension"]
    if not suspensionHeight then
        suspensionHeight = 0.5
    end
    if type(suspensionHeight) == "number" then
        GarageCar.applyHandling("Suspension", suspensionHeight)
    end
	
	-- выворот
	local steeringLock = currentTuningTable["Steer"]
    if not steeringLock then
        steeringLock = 55
    end
	
    if type(steeringLock) == "number" then
        GarageCar.applyHandling("Steer", steeringLock)
    end
	
	-- Пропорция подвески
	local suspensionFrontRearBias = currentTuningTable["Bias"]
    if not suspensionFrontRearBias then
        suspensionFrontRearBias = 0.4
    end
    if type(suspensionFrontRearBias) == "number" then
        GarageCar.applyHandling("Bias", suspensionFrontRearBias)
    end
	
    -- Размер колёс по-умолчанию
    if not currentTuningTable["WheelsSize"] then
        local defaultWheelsSize = exports.tunrc_Vehicles:getModelDefaultWheelsSize(vehicle.model)
        if not defaultWheelsSize then
            defaultWheelsSize = 0.69
        end
        GarageCar.applyTuning("WheelsSize", defaultWheelsSize)
    end

     if not currentTuningTable["Numberplate"] then
        GarageCar.applyTuning("Numberplate", "TRC")
    end
	
	if not currentTuningTable["Country"] then
		GarageCar.applyTuning("Country", "ny")
	end

    if not currentTuningTable["StreetHandling"] then
        GarageCar.applyTuning("StreetHandling", 1)
    end

	if not currentTuningTable["OffroadHandling"] then
        GarageCar.applyTuning("OffroadHandling", 1)
    end

    if not currentTuningTable["DriftHandling"] then
        GarageCar.applyTuning("DriftHandling", 1)
    end
end

function getCountryData()
	return currentTuningTable["Country"]
end

function GarageCar.getTuningTable()
    local componentNames = exports.tunrc_Vehicles:getComponentsNames()
    local tuningTable = {}
    for i, name in ipairs(componentNames) do
        tuningTable[name] = vehicle:getData(name)
    end

    for i, name in ipairs(configurationData) do
        tuningTable[name] = vehicle:getData(name)
        if type(tuningTable[name]) == "number" then
            tuningTable[name] = math.ceil(tuningTable[name] * 1000) / 1000
        end
    end

    for i, name in ipairs(colorsData) do
        tuningTable[name] = vehicle:getData(name)
        if not tuningTable[name] then
            tuningTable[name] = {205, 205, 205}
        else
            for i, color in ipairs(tuningTable[name]) do
                tuningTable[name][i] = math.floor(color)
            end
        end
    end

    for i, name in ipairs(copyData) do
        tuningTable[name] = vehicle:getData(name)
    end

    return tuningTable
end

function GarageCar.save()
    CarTexture.save()
    local tuningTable = GarageCar.getTuningTable()
    vehiclesList[currentVehicle].tuning = toJSON(tuningTable)
    vehiclesList[currentVehicle].stickers = toJSON(vehicle:getData("stickers"))

    --outputDebugString("SAVE WheelsSize = " .. tostring(tuningTable.WheelsSize))
    triggerServerEvent("tunrc_Garage.saveCar", resourceRoot,
        currentVehicle,
        tuningTable,
        vehicle:getData("stickers")
    )
end

function GarageCar.hasComponent(name, id)
    if not name then
        return false
    end
    if  name == "Spoilers" or
        name == "Numberplate" or
		name == "SteeringTexture" or
		name == "Country" or
        name == "WheelsF" or
        name == "WheelsR"
    then
        return true
    end
    if name == "Exhaust" then
        return not not vehicle:getComponentPosition("RearBumpExhaust0")
    end
    if not id then
        id = 1
    end
    return not not vehicle:getComponentPosition(name .. tostring(id))
end

function GarageCar.hasDefaultSpoilers()
    local carNames = {
        nissan_r32 = true
    }
    return not carNames[GarageCar.getName()]
end

function GarageCar.hasCustomSpoiler(id)
    return not not vehicle:getComponentPosition("Spoilers" .. tostring(id))
end

function GarageCar.isComponentRemovable(name)
  if not name then
      return false
  end
  local removableComponents = {
     "FrontBump", "Fpanels", "RearBump", "SideSkirts", "Bonnets", "Spoilers",
    "RightLight", "LeftLight", "RearLights", "Lips", "PSeats", "Extraone", "Extratwo", "Extrathree", "Extrafour", "Extrafive", "Intercooler", "FrontFends", "FrontFendsDops", "FrontFendsR", "FrontFendsL","FrontLights", "FaraR", "FaraL", "RearFends",
    "Frontnumber", "Rearnumber", "Grills", "Boots", "Mirrors", "SideLights", "Diffusors", "LeftFend", "Acces", "Roof", "Rbadge", "Dops", "Fbadge", "Skirts", "RightFend"
  }
  for _, value in ipairs(removableComponents) do
      if name == value then
          return true
      end
  end

  return false
end

function GarageCar.getComponentsCount(name)
    if not name then
        return 0
    end
    if  name == "Spoilers" or
        name == "Numberplate" or
		name == "SteeringTexture" or
        name == "WheelsF" or
        name == "WheelsR"
    then
        return 1
    end
    local count = 0
    for i = 1, 50 do
        if not vehicle:getComponentPosition(name .. tostring(i)) then
            return count
        end
        count = count + 1
    end
    return count
end

function GarageCar.getName()
    return exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
end

function GarageCar.sell()
    if #vehiclesList == 1 then
        return false
    end
    return triggerServerEvent("tunrc_Garage.sellVehicle", resourceRoot, vehiclesList[currentVehicle]._id)
end

addEvent("tunrc_Garage.updateVehiclesList", true)
addEventHandler("tunrc_Garage.updateVehiclesList", resourceRoot, function (vehicles)
    if type(vehicles) ~= "table" then
        return
    end
    vehiclesList = vehicles
    updateVehicle()
end)
