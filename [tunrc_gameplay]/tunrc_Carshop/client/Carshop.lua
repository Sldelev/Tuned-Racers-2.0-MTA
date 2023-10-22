Carshop = {}
Carshop.isActive = false
Carshop.currentVehicleInfo = {}
Carshop.hasDriftHandling = false

local CARSHOP_POSITION = Vector3(-1654.23, 1210.75, 20.6)
local VEHICLE_ROTATION = Vector3(0, 0, 182)
local LOCAL_DIMENSION = 454
local CARSHOP_ROTATION = 50
local VEHICLE_OFFSET = Vector3(0, 0, 0)
local STAGE_OFFSET = Vector3(0, 0, -3)

local vehiclesList = {}

local vehicle
local roomObject

-- Вращение подиума
local automoving = false
local automovingAcceleration = 0.6
local automovingSpeed = 7

local rotationSpeed = 0
local rotationPower = 100

local showTimer
local moveTimer

local currentVehicleId = 1

-- UI
local screenSize = Vector2(guiGetScreenSize())
local screenShadowTexture
local themeColor = {0, 0, 0}
local fonts = {}

local cameraScrollValue = 0
local isBuying = false

--[[local function update()
	vehicle.rotation = Vector3(0, 0, 182)
end]]

local function draw()
	-- Тень у краёв экрана
	dxDrawImage(0, 0, screenSize.x, screenSize.y, screenShadowTexture, 0, 0, 0, tocolor(0, 0, 0, 200))

	local primaryColor = tocolor(themeColor[1], themeColor[2], themeColor[3], 255)
	dxDrawText(
		"$#FFFFFF" .. tostring(localPlayer:getData("money")),
		0, 20,
		screenSize.x - 20, screenSize.y,
		primaryColor,
		1,
		fonts.money,
		"right",
		"top",
		false, false, false, true
	)
	dxDrawText(
		"¤#FFFFFF" .. tostring(localPlayer:getData("donatmoney")),
		0, 55,
		screenSize.x - 20, screenSize.y,
		primaryColor,
		1,
		fonts.money,
		"right",
		"top",
		false, false, false, true
	)
end

local function onCursorMove(x, y)
	if isMTAWindowActive() or isCursorShowing() then
		return
	end
end

local function onMouseWheel(key, state, delta)
	local targetCamera = CameraManager.getTargetCamera()

	targetCamera.FOV = 70
	targetCamera.targetPosition = CARSHOP_POSITION
	targetCamera.distance = 3
	targetCamera.rotationVertical = 4
end

local function onKey(key, down)
	if not down or isBuying then
		return false
	end

	if exports.tunrc_TutorialMessage:isMessageVisible() then
		return
	end

	if key == "a" or key == "arrow_l" then
		currentVehicleId = currentVehicleId - 1
		if currentVehicleId < 1 then
			currentVehicleId = #vehiclesList
		end
		Carshop.showVehicle(currentVehicleId)
		exports.tunrc_UI:hideMessageBox()
		exports.tunrc_Sounds:playSound("ui_change.wav")
		UIDataBinder.refresh()
	elseif key == "d" or key == "arrow_r" then
		currentVehicleId = currentVehicleId + 1
		if currentVehicleId > #vehiclesList then
			currentVehicleId = 1
		end
		Carshop.showVehicle(currentVehicleId)
		exports.tunrc_UI:hideMessageBox()
		exports.tunrc_Sounds:playSound("ui_change.wav")
		UIDataBinder.refresh()
	elseif key == "backspace" then
		if localPlayer:getData("tutorialActive") then
			return
		end
		if exports.tunrc_UI:isMessageBoxVisible() then
			exports.tunrc_UI:hideMessageBox()
		else
			exitCarshop()
		end
		exports.tunrc_Sounds:playSound("ui_back.wav")
	end
end

function Carshop.start()
	if Carshop.isActive then
		return false
	end
	Carshop.isActive = true
	isBuying = false

	-- Список автомобилей
	vehiclesList = {}
	local vehicles = exports.tunrc_Shared:getVehiclesTable()
	for name, model in pairs(vehicles) do
		local priceInfo = exports.tunrc_Shared:getVehiclePrices(name)
		if priceInfo then
			local vehicleInfo = {
				model = model,
				name = exports.tunrc_Shared:getVehicleReadableName(name),
				description = exports.tunrc_Shared:getVehicleDescription(name),
				price = priceInfo[1],
				level = priceInfo[2],
				premium = priceInfo[3],
				donatprice = priceInfo[4]
			}
			table.insert(vehiclesList, vehicleInfo)
		end
	end

	table.sort(vehiclesList, function (v1, v2)
		if not v1.premium and v2.premium then
			return true
		else
			return false
		end
	end)

	localPlayer.dimension = LOCAL_DIMENSION

	-- Создать автомобиль
	vehicle = createVehicle(411, CARSHOP_POSITION + VEHICLE_OFFSET , VEHICLE_ROTATION)
	vehicle.alpha = 0
	vehicle.dimension = LOCAL_DIMENSION
	vehicle:setData("Numberplate", "TRC")

	toggleAllControls(false)
	exports.tunrc_HUD:setVisible(false)
	exports.tunrc_Chat:setVisible(false)

	addEventHandler("onClientCursorMove", root, onCursorMove)
	--addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientKey", root, onKey)
	
	bindKey("enter", "down", Carshop.buy)

	-- UI
	screenShadowTexture = exports.tunrc_Assets:createTexture("screen_shadow.png")
	themeColor = {exports.tunrc_UI:getThemeColor()}
	fonts.money = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 24)
	fonts.level = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 14)

	currentVehicleId = 1
	Carshop.showVehicle(currentVehicleId)
	CarshopMenu.start(CARSHOP_POSITION)
	CameraManager.start()

	if localPlayer:getData("tutorialActive") then
		exports.tunrc_TutorialMessage:showMessage(
			exports.tunrc_Lang:getString("tutorial_car_shop_title"),
			exports.tunrc_Lang:getString("tutorial_car_shop_text"),
			"$" .. tostring(localPlayer:getData("money")),
			utf8.lower(exports.tunrc_Lang:getString("controls_arrows")),
			utf8.lower(exports.tunrc_Lang:getString("controls_mouse")),
			"ENTER")
	end
end

function Carshop.stop()
	if not Carshop.isActive then
		return false
	end
	Carshop.isActive = false

	if isElement(vehicle) then
		destroyElement(vehicle)
	end
	for name, font in pairs(fonts) do
		if isElement(font) then
			destroyElement(font)
		end
	end
	fonts = {}

	toggleAllControls(true)
	exports.tunrc_HUD:setVisible(true)
	exports.tunrc_Chat:setVisible(true)

	if isElement(screenShadowTexture) then
		destroyElement(screenShadowTexture)
	end

	removeEventHandler("onClientCursorMove", root, onCursorMove)
	--removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientKey", root, onKey)

	unbindKey("mouse_wheel_up", "down" , onMouseWheel, 1)
	unbindKey("mouse_wheel_down", "down" , onMouseWheel, -1)
	unbindKey("enter", "down", Carshop.buy)

	CarshopMenu.stop()
	CameraManager.stop()
end

function Carshop.getVehicle()
	return vehicle
end

function Carshop.showVehicle(id)
	local vehicleInfo = vehiclesList[id]
	if not vehicleInfo then
		outputDebugString("No info for vehicle: " .. tostring(id))
		return false
	end
	Carshop.currentVehicleInfo = vehicleInfo

	vehicle.model = vehicleInfo.model
	vehicle.alpha = 0
	vehicle.position = CARSHOP_POSITION + VEHICLE_OFFSET

	if isTimer(showTimer) then
		killTimer(showTimer)
	end
	showTimer = setTimer(function ()
		vehicle.alpha = 255
		local color = exports.tunrc_Shared:getGameplaySetting("default_vehicle_color") or {100, 100, 100}
		vehicle:setColor(unpack(color))
	end, 250, 1)

	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(vehicle.model)
	Carshop.hasDriftHandling = exports.tunrc_Vehicles:hasVehicleHandling(vehicleName, "drift", 1)
end

function Carshop.buy()
	if exports.tunrc_TutorialMessage:isMessageVisible() then
		return
	end
	if Carshop.currentVehicleInfo.premium and not localPlayer:getData("isPremium") then
		exports.tunrc_Sounds:playSound("error.wav")
		return
	end
	if not hasMoreGarageSlots() then
		exports.tunrc_Sounds:playSound("error.wav")
		return
	end
	if Carshop.currentVehicleInfo.level > localPlayer:getData("level") then
		exports.tunrc_Sounds:playSound("error.wav")
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("carshop_buy_error_title"),
			string.format(
				exports.tunrc_Lang:getString("carshop_required_level"),
				tostring(Carshop.currentVehicleInfo.level)))
	elseif Carshop.currentVehicleInfo.price > localPlayer:getData("money") then
		exports.tunrc_Sounds:playSound("error.wav")
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("carshop_buy_error_title"),
			exports.tunrc_Lang:getString("carshop_no_money"))
	else
		triggerServerEvent("tunrc_Carshop.buyVehicle", resourceRoot, Carshop.currentVehicleInfo.model)
		isBuying = true
		exports.tunrc_Sounds:playSound("sell.wav")
	end
	exports.tunrc_Sounds:playSound("ui_select.wav")
end

function Carshop.donatbuy()
	if exports.tunrc_TutorialMessage:isMessageVisible() then
		return
	end
	if Carshop.currentVehicleInfo.premium and not localPlayer:getData("isPremium") then
		exports.tunrc_Sounds:playSound("error.wav")
		return
	end
	if not hasMoreGarageSlots() then
		exports.tunrc_Sounds:playSound("error.wav")
		return
	end
	if Carshop.currentVehicleInfo.level > localPlayer:getData("level") then
		exports.tunrc_Sounds:playSound("error.wav")
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("carshop_buy_error_title"),
			string.format(
				exports.tunrc_Lang:getString("carshop_required_level"),
				tostring(Carshop.currentVehicleInfo.level)))
	elseif Carshop.currentVehicleInfo.donatprice > localPlayer:getData("donatmoney") then
		exports.tunrc_Sounds:playSound("error.wav")
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("carshop_buy_error_title"),
			exports.tunrc_Lang:getString("carshop_no_money"))
	else
		triggerServerEvent("tunrc_Carshop.buyDonatVehicle", resourceRoot, Carshop.currentVehicleInfo.model)
		isBuying = true
		exports.tunrc_Sounds:playSound("sell.wav")
	end
	exports.tunrc_Sounds:playSound("ui_select.wav")
end

--[[addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Замена моделей
	local id = 1546
	local txd = engineLoadTXD("assets/shr.txd")
	engineImportTXD(txd,id)
	local dff = engineLoadDFF("assets/shr.dff")
	engineReplaceModel(dff, id)
	local col = engineLoadCOL("assets/shr.col")
	engineReplaceCOL(col, id)

	-- Создание объектов помещения
	local carshop = createObject(1546, 1230, -1788,  1137.5, 0, 0, 0)
	setElementDimension (carshop, -1)
end)]]

function hasMoreGarageSlots()
    local garageSlots = exports.tunrc_Core:getPlayerGarageSlots(localPlayer)
    if not garageSlots then
    	garageSlots = 0 
    end
	if localPlayer:getData("garage_cars_count") >= garageSlots then
		return false
	end
	return true
end

addEvent("tunrc_Carshop.buyVehicle", true)
addEventHandler("tunrc_Carshop.buyVehicle", resourceRoot, function (success)
	isBuying = false
	
	if not success then
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("carshop_buy_error_title"),
			exports.tunrc_Lang:getString("carshop_buy_error_unknown"))
		return
	else
		exitCarshop(true)
	end
end)
