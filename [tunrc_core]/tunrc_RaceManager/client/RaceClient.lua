RaceClient = {}
RaceClient.isActive = false
RaceClient.raceElement = nil
RaceClient.gamemode = nil

RaceClient.settings = {}
RaceClient.map = {}

local raceGamemodes = {
	drift = Drift,
	sprint = Sprint
}

local raceDimension = 0

local UPDATE_INTERVAL = 2000
local updateTimer

addEvent("Race.addedToRace", true)
addEvent("Race.stateChanged", true)
addEvent("Race.updateTimeLeft", true)

addEvent("Race.launch", true)
addEvent("Race.start", true)
addEvent("Race.finish", true)
addEvent("Race.playerFinished", true)
addEvent("Race.playerAdded", true)
addEvent("Race.playerRemoved", true)

addEventHandler("Race.addedToRace", root, function (settings, map)
	RaceClient.startRace(source, settings, map)
end)

local function onStateChanged(state)
	-- dunno
end

local function update()
	if not isElement(RaceClient.raceElement) then
		RaceClient.stopRace()
	end
	RaceClient.gamemode:updatePosition()
end

local function updateTimeLeft(time)
	RaceTimer.setTimeLeft(time)
end

local function onElementDestroy()
	if source and source == RaceClient.raceElement then
		RaceClient.stopRace()
	end
end

local function getDriftAngle()
	local vehicle = localPlayer.vehicle
	
	if not vehicle then
	return 0
	end
	
	if vehicle.velocity.length < 0.12 then
	return 0
end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
		if math.abs(angle) > 150 then
		return 0
	end
	if angle < 0 then
		angle = angle + -angle * 2
	end
	return angle
end

local function getVehicleSpeed()
	if not localPlayer.vehicle then
		return 0
	end
	return localPlayer.vehicle.velocity:getLength() * 180
end

local function getVehicleSpeedString()
	local speed = getVehicleSpeed()
	return string.format("%03d", speed)
end

function RaceClient.checkpointHit(checkpointId)
	if not RaceClient.isActive then
		return false
	end
	RaceClient.gamemode:checkpointHit(checkpointId)
	if RaceClient.settings.gamemode == "drift" then
		exports.tunrc_DriftPoints:giveBonusPoints(2500 + (string.format('%.f',getDriftAngle()) * 10) + (getVehicleSpeedString() * 10) )
	end
end

function RaceClient.clientFinished()
	if not RaceClient.isActive then
		return false
	end
	RaceClient.gamemode:clientFinished()
end

function RaceClient.leaveRace()
	if not RaceClient.isActive then
		return false
	end
	triggerServerEvent("Race.clientLeave", resourceRoot)
end

function RaceClient.startRace(raceElement, settings, map)
	if not check("RaceClient.startRace", "raceElement", "element", raceElement) then return false end
	if not check("RaceClient.startRace", "settings", "table", settings) then return false end
	if not check("RaceClient.startRace", "map", "table", map) then return false end
	if RaceClient.isActive then
		return false
	end
	RaceClient.isActive = true
	RaceClient.raceElement = raceElement
	RaceClient.settings = settings
	RaceClient.map = map

	RaceCheckpoints.start(RaceClient.map.checkpoints)

	raceDimension = localPlayer.dimension

	-- Создание объектов карты
	if not RaceClient.map.objects then
		RaceClient.map.objects = {}
	end
	for i, o in ipairs(RaceClient.map.objects) do
		createObject(unpack(o)).dimension = raceDimension
	end
	-- Перенос маппинга в dimension гонки
	if raceDimension ~= 0 then
		for i, object in ipairs(getElementsByType("object")) do
			if object.dimension == 0 then
				object.dimension = raceDimension
			end 
		end
	end

	-- Обработка событий
	addEventHandler("Race.stateChanged", 	RaceClient.raceElement, onStateChanged)
	addEventHandler("Race.updateTimeLeft",	RaceClient.raceElement, updateTimeLeft)
	addEventHandler("onClientElementDestroy", RaceClient.raceElement, RaceClient.stopRace)
	
	function GetRaceGamemode()
		local gamemodeClass = raceGamemodes
		return gamemodeClass
	end
	
	local gamemodeClass = raceGamemodes[RaceClient.settings.gamemode]
	if not gamemodeClass then
		gamemodeClass = RaceGamemode
	end
	RaceClient.gamemode = gamemodeClass()

	addEventHandler("Race.launch", 			RaceClient.raceElement, function (...) RaceClient.gamemode 	:raceLaunched(source, ...) end)
	addEventHandler("Race.start", 			RaceClient.raceElement, function (...) RaceClient.gamemode 	:raceStarted(source, ...) end)
	addEventHandler("Race.finish", 			RaceClient.raceElement, function (...) RaceClient.gamemode 	:raceFinished(source, ...) end)
	addEventHandler("Race.playerFinished", 	RaceClient.raceElement, function (...) RaceClient.gamemode :playerFinished(source, ...) end)
	addEventHandler("Race.playerAdded", 	RaceClient.raceElement, function (...) RaceClient.gamemode 	:playerAdded(source, ...) end)
	addEventHandler("Race.playerRemoved", 	RaceClient.raceElement, function (...) RaceClient.gamemode :playerRemove(source, ...) end)		

	updateTimer = setTimer(update, UPDATE_INTERVAL, 0)

	-- Скрыть интерфейс
	local guiToHide = { "tunrc_Overallpanel", "tunrc_TabPanel", "tunrc_WorldMap" }
	for i, name in ipairs(guiToHide) do
		if exports[name].setVisible then
			exports[name]:setVisible(false)
		end
	end
	exports.tunrc_UI:hideMessageBox()
	localPlayer:setData("activeUI", "raceUI")
	bindKey("F1", "down", QuitPrompt.toggle)
	bindKey("f", "down", QuitPrompt.toggle)

	exports.tunrc_SafeZones:leaveSafeZones()

	triggerServerEvent("Race.clientReady", RaceClient.raceElement)
end

function RaceClient.getPlayers()
	if not RaceClient.isActive then
		return false
	end
	if not isElement(RaceClient.raceElement) then
		return false
	end
	return RaceClient.raceElement:getChildren("player")
end

function RaceClient.stopRace()
	if not RaceClient.isActive then
		return false
	end
	RaceClient.isActive = false

	RaceClient.gamemode:raceStopped()
	
	removeEventHandler("Race.stateChanged", RaceClient.raceElement, onStateChanged)
	removeEventHandler("Race.updateTimeLeft",	RaceClient.raceElement, updateTimeLeft)
	removeEventHandler("onClientElementDestroy", RaceClient.raceElement, RaceClient.stopRace)
	
	RaceClient.stopRace()
	Countdown.stop()
	RaceTimer.stop()
	FinishScreen.stop()
	RaceCheckpoints.stop()

	for i, object in ipairs(resource:getDynamicElementRoot():getChildren("object")) do
		destroyElement(object)
	end
	-- Перенос маппинга обратно в нулевой dimension
	if raceDimension ~= 0 then
		for i, object in ipairs(getElementsByType("object")) do
			if object.dimension == raceDimension then
				object.dimension = 0
			end 
		end
	end

	RaceClient.raceElement = nil
	RaceClient.settings = nil
	RaceClient.map = nil
	raceDimension = 0

	if isTimer(updateTimer) then
		killTimer(updateTimer)
	end
	
	-- Интерфейс
	localPlayer:setData("activeUI", false)

	unbindKey("F1", "down", QuitPrompt.toggle)
	unbindKey("f", "down", QuitPrompt.toggle)
		
	toggleAllControls(true)
end	

if localPlayer:getData("activeUI") == "raceUI" then
	localPlayer:setData("activeUI", false)
end