-- Вход/выход в гараж

local ENABLE_GARAGE_CMD = true		-- Команда /garage для входа в гараж
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в гараж

addEvent("tunrc_Garage.enter", true)
addEventHandler("tunrc_Garage.enter", resourceRoot, function (success, vehiclesList, enteredVehicleId)
	isEnterExitInProcess = false

	if success then
		Garage.start(vehiclesList, enteredVehicleId)
	else
		localPlayer:setData("tunrc_Core.state", false)
		local errorType = vehiclesList
		fadeCamera(true, 0.5)
		if errorType then
			local errorText = exports.tunrc_Lang:getString(errorType)
			if errorText then
				exports.tunrc_Chat:message("global", errorText, 255, 0, 0)
			end
		end
	end
end)

addEvent("tunrc_Garage.exit", true)
addEventHandler("tunrc_Garage.exit", resourceRoot, function (success)
	isEnterExitInProcess = false
	Garage.stop()
	setTimer(function ()
		fadeCamera(true, 0.5)
		if localPlayer:getData("tutorialActive") then
			localPlayer:setData("tutorialActive", false)
			exports.tunrc_TutorialMessage:showMessage(
				exports.tunrc_Lang:getString("tutorial_city_title"),
				exports.tunrc_Lang:getString("tutorial_city_text"),
				"F1", "F9", "M", exports.tunrc_Lang:getString("tutorial_city_race"))
		end
	end, 500, 1)
	exports.tunrc_HUD:setSpeedometerVisible(exports.tunrc_Config:getProperty("ui.draw_speedo"))
end)

local function enterExitGarage(enter, selectedCarId)
	if isEnterExitInProcess then
		return false
	end
	isEnterExitInProcess = true
	fadeCamera(false, 0.5)
	Timer(function ()
		if enter then
			triggerServerEvent("tunrc_Garage.enter", resourceRoot)
		else
			triggerServerEvent("tunrc_Garage.exit", resourceRoot, selectedCarId)
		end
	end, 500, 1)
	return true
end

-- Функции для экспорта
function enterGarage()
	enterExitGarage(true)
	setWeather ( 15 )
end

function exitGarage(selectedCarId)
	MusicPlayer.fadeOut()
	enterExitGarage(false, selectedCarId)
	setRadioChannel(0)
	setTime( 8, 0 )
	setWeather (7)
end

if ENABLE_GARAGE_CMD then
	addCommandHandler("garage", function ()
		enterExitGarage(not Garage.isActive())
	end)
end
