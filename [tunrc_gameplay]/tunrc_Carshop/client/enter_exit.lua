local ENABLE_CARSHOP_CMD = true	-- Команда /carshop для входа в автомагазин
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в автомагазин
local openGarageAfterExit = false

addEvent("tunrc_Carshop.enter", true)
addEventHandler("tunrc_Carshop.enter", resourceRoot, function (success)
	isEnterExitInProcess = false
	if success then
		Carshop.start()
	end
	fadeCamera(true)
end)

addEvent("tunrc_Carshop.exit", true)
addEventHandler("tunrc_Carshop.exit", resourceRoot, function (success)
	isEnterExitInProcess = false
	Carshop.stop()
	if openGarageAfterExit then
		openGarageAfterExit = false
		exports.tunrc_Garage:enterGarage()
	else
		fadeCamera(true)
	end
end)

local function enterExitCarshop(enter)
	if enter then
		if localPlayer.vehicle then
			exports.tunrc_Chat:message("global", "Exit your vehicle", 255, 0, 0)
			return false
		end
	end
	if isEnterExitInProcess then
		return false
	end
	isEnterExitInProcess = true
	fadeCamera(false, 1)
	Timer(function ()
		if enter then
			triggerServerEvent("tunrc_Carshop.enter", resourceRoot)
		else
			triggerServerEvent("tunrc_Carshop.exit", resourceRoot)
		end
	end, 1000, 1)
	return true
end

function enterCarshop()
	enterExitCarshop(true)
end

function exitCarshop(goToGarage)
	enterExitCarshop(false)
	openGarageAfterExit = not not goToGarage
end

if ENABLE_CARSHOP_CMD then
	addCommandHandler("carshop", function ()
		enterExitCarshop(not Carshop.isActive)
	end)
end

--San Fierro Markers

local sf1 = exports.tunrc_Markers:createMarker("showroom", Vector3 { x = -1654, y = 1212, z = 7.25 }, -45)
addEvent("tunrc_Markers.use", false)
addEventHandler("tunrc_Markers.use", sf1, enterCarshop)
local blip = createBlip(0, 0, 0, 55)
blip:attach(sf1)
blip:setData("text", "blip_carshop")

addEvent("tunrc_Carshop.forceEnter", true)
addEventHandler("tunrc_Carshop.forceEnter", root, function ()
	enterCarshop()
end)