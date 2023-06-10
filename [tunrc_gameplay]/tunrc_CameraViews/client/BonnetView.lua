BonnetView = {}
local isActive = false

local cameraHeight = 0.7
local cameraOffset = Vector3(0, 0, 0)
local lookAtOffset = Vector3(0, 6, 0.7)

local targetRotation = 0
local currentRotation = 0
local rotationMul = 0.2

local currentCameraPosition = Vector3(cameraOffset) + Vector3(0, 0, cameraHeight)
local currentLookOffset = Vector3(lookAtOffset)
local currentCameraRoll = 0
local currentCameraFOV = 75
local currentCameraZ = 0
local currentCameraRotation = 0 

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

	local targetCameraRotation = 0 
	currentCameraRotation = 210

	local len = #cameraOffset
	local targetCameraPosition = Vector3(0, 0.4, cameraHeight)
	local targetLookOffset = lookAtOffset + Vector3(0, 0, 0)

	local targetCameraRoll = 0
	currentCameraRoll = 0

	local targetCameraFOV = 70
	currentCameraFOV = currentCameraFOV + (targetCameraFOV - currentCameraFOV) * deltaTime * 3	


	local disableHotkeys = localPlayer:getData("activeUI") and localPlayer:getData("activeUI") ~= "raceUI"
	local bothDown = false			

	currentCameraPosition = currentCameraPosition + (targetCameraPosition - currentCameraPosition) * deltaTime * 5
	currentLookOffset = currentLookOffset + (targetLookOffset - currentLookOffset) * deltaTime * 4

	setCameraMatrix(
		vehicle.matrix:transformPosition(currentCameraPosition), 
		vehicle.matrix:transformPosition(currentLookOffset), 
		currentCameraRoll, 
		currentCameraFOV
	)
end

function BonnetView.start()
	if isActive then
		return false
	end
	isActive = true
	currentCameraZ = localPlayer.vehicle.position.z
	addEventHandler("onClientPreRender", root, update)
end

function BonnetView.stop()
	if not isActive then
		return false
	end
	isActive = false	
	removeEventHandler("onClientPreRender", root, update)
end