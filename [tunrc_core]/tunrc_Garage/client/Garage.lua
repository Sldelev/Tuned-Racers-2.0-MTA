Garage = {}
Garage.themePrimaryColor = {}
local isActive = false
local pendingBuyCallback

function Garage.start(vehicles, enteredVehicleId)
	if isActive then
		return false
	end
	isActive = true

	Garage.themePrimaryColor = {exports.tunrc_UI:getThemeColor()}
	localPlayer.dimension = 0
	exports.tunrc_Time:forceTime(12, 0)

	exports.tunrc_Chat:setVisible(false)
	exports.tunrc_MainPanel:setVisible(false)
	exports.tunrc_TabPanel:setVisible(false)
	exports.tunrc_WorldMap:setVisible(false)
	exports.tunrc_HUD:setVisible(false)

	Assets.start()
	GarageCar.start(vehicles)
	GarageUI.start()

	GarageCar.showCarById(enteredVehicleId)

	setTimer(function ()
		CameraManager.start()
		fadeCamera(true, 0.5)
		CarTexture.start()
		MusicPlayer.start()
	end, 1000, 1)
end

function Garage.stop()
	if not isActive then
		return false
	end
	isActive = false
	GarageUI.stop()
	CameraManager.stop()
	CarTexture.stop()
	GarageCar.stop()
	Assets.stop()
	MusicPlayer.stop()
	exports.tunrc_Chat:setVisible(true)
	exports.tunrc_HUD:showAll()
	toggleAllControls(true)
end

function Garage.isActive()
	return isActive
end

function Garage.selectCarAndExit()
	exitGarage(GarageCar.getId())
end

function Garage.buy(price, level, callback)
	if type(price) ~= "number" or type(level) ~= "number" or type(callback) ~= "function" then
		outputDebugString("Garage.buy: bad arguments")
		return false
	end
	if pendingBuyCallback then
		callback(false)
		exports.tunrc_Sounds:playSound("error.wav")
		return false
	end
	if price < 0 then
		exports.tunrc_Sounds:playSound("error.wav")
		callback(false)
		return
	end
	if level > localPlayer:getData("level") then
		outputDebugString("Error: Not enough level")
		exports.tunrc_Sounds:playSound("error.wav")
		callback(false)
		return
	end
	if localPlayer:getData("money") < price then
		outputDebugString("Error: Not enough money")
		exports.tunrc_Sounds:playSound("error.wav")
		callback(false)
		return
	end
	pendingBuyCallback = callback
	triggerServerEvent("tunrc_Garage.buy", resourceRoot, price, level)
end

addEvent("tunrc_Garage.buy", true)
addEventHandler("tunrc_Garage.buy", resourceRoot, function (success)
	if type(pendingBuyCallback) ~= "function" then
		exports.tunrc_Sounds:playSound("error.wav")
		return false
	end
	if success then
		exports.tunrc_Sounds:playSound("sell.wav")
	end
	pendingBuyCallback(success)
	pendingBuyCallback = nil
end)
