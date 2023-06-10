local distanceCounter = 0
local previousPosition = Vector3()
if localPlayer.vehicle then
	previousPosition = localPlayer.position
end
local metersMul = 1

setTimer(function ()
	if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
		distanceCounter = 0
		return
	end
	local passedDistance = (localPlayer.position - previousPosition):getLength()
	previousPosition = localPlayer.position
	if passedDistance > 100 then
		return
	end
	distanceCounter = distanceCounter + math.floor(passedDistance * metersMul)
	local currentMileage = localPlayer.vehicle:getData("mileage")
	if not currentMileage then
		currentMileage = 0
	end
	if distanceCounter >= 1000 then
		localPlayer.vehicle:setData("mileage", currentMileage + 1)
		distanceCounter = distanceCounter - 1000
	end
end, 1000, 0)

addEventHandler("onClientPlayerVehicleEnter", root, function ()
	if source ~= localPlayer then
		return
	end
	previousPosition = localPlayer.position
end)
