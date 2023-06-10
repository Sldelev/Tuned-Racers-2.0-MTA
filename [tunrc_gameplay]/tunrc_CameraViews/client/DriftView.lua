DriftView = {}
local isActive = false

local cameraHeight = 1
local cameraOffset = Vector3(0, -5.5 , 0)
local lookAtOffset = Vector3(0, 0, 0.45)

local targetRotation = 0
local currentRotation = 0

local currentCameraPosition = Vector3(cameraOffset) + Vector3(0, 0, cameraHeight)
local currentLookOffset = Vector3(lookAtOffset)
local currentCameraRoll = 0
local currentCameraFOV = 60
local currentCameraZ = 0
local currentCameraRotation = 0

local function getDriftAngle()
	local vehicle = localPlayer.vehicle

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x


	local angle = math.atan2(det, dot)
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

local function CameraHeightSpeedLimit()
	local speed = getVehicleSpeed()
	if speed > 80 then
		speed = 80
	end
	return speed
end

function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	while difference < -180 do
		difference = difference + 360
	end
	while difference > 180 do
		difference = difference - 360
	end
	return difference
end

local _getKeyState = getKeyState
local function getKeyState(...)
	return _getKeyState(...) and not isMTAWindowActive()
end

local function update(deltaTime)
	if localPlayer:getData("activeUI") == "photoMode" then
		return
	end	
	deltaTime = deltaTime / 1000

	local vehicle = localPlayer.vehicle
	if not vehicle then
		return
	end

	local driftAngle = -getDriftAngle()
	local speed = getVehicleSpeedString()
	local targetCameraRotation = math.sin(driftAngle) * 1.15 + math.pi
	local smoothcam = math.abs(targetCameraRotation - currentCameraRotation )
	if smoothcam < 0.25 then
		currentCameraRotation = currentCameraRotation + (targetCameraRotation - currentCameraRotation) * deltaTime * 5
	elseif smoothcam > 0.25 then
	currentCameraRotation = currentCameraRotation + (targetCameraRotation - currentCameraRotation) * deltaTime * 10
	elseif smoothcam == 0 then 
	currentCameraRotation = 0
	end
	

	local len = #cameraOffset
	local targetCameraPosition = Vector3(math.sin(currentCameraRotation) * len, math.cos(currentCameraRotation) * len, cameraHeight + (CameraHeightSpeedLimit() * 0.015))
	local targetLookOffset = lookAtOffset + Vector3(0, 0, 0)

	local targetCameraRoll = 0
	currentCameraRoll = 0

	local targetCameraFOV = 75 -- + math.sin(speed) * deltaTime * 2
	currentCameraFOV = targetCameraFOV

	local disableHotkeys = localPlayer:getData("activeUI") and localPlayer:getData("activeUI") ~= "raceUI"
	local bothDown = false

	currentCameraPosition = currentCameraPosition + (targetCameraPosition - currentCameraPosition) * deltaTime * 5
	currentLookOffset = currentLookOffset

	setCameraMatrix(
		vehicle.matrix:transformPosition(currentCameraPosition), 
		vehicle.matrix:transformPosition(currentLookOffset), 
		0, 
		currentCameraFOV
	)
end

function DriftView.start()
	if isActive then
		return false
	end
	isActive = true
	currentCameraZ = localPlayer.vehicle.position.z
	addEventHandler("onClientPreRender", root, update)
end

function DriftView.stop()
	if not isActive then
		return false
	end
	isActive = false	
	removeEventHandler("onClientPreRender", root, update)
end