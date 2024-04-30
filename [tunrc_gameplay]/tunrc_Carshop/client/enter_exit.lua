local ENABLE_CARSHOP_CMD = true	-- Команда /carshop для входа в автомагазин
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в автомагазин
local openGarageAfterExit = true

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
	exports.tunrc_Garage:enterGarage()
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

addEvent("tunrc_Carshop.forceEnter", true)
addEventHandler("tunrc_Carshop.forceEnter", root, function ()
	enterCarshop()
end)