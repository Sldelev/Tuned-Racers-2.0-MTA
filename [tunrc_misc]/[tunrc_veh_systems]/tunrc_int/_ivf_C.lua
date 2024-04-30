ryg = 0

local function getDriftAngle()
	if localPlayer.vehicle.velocity.length < 0.12 then
		return 0
	end

	local direction = localPlayer.vehicle.matrix.forward
	local velocity = localPlayer.vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
	return angle
end

function updateSteeringWheelRotation()
	if not localPlayer.vehicle then return end
		local driftangle = -getDriftAngle()
		if driftangle >= 85 then
			driftangle = 85
		elseif driftangle <= -85 then
			driftangle = -85
		end	
	
		local stwhid = localPlayer.vehicle:getData("Stwheel")
		local dialsid = localPlayer.vehicle:getData("Dials")
		local wrx,wry, wrz = getVehicleComponentRotation(localPlayer.vehicle, "Stwheel" .. tostring(stwhid))
			setVehicleComponentRotation(localPlayer.vehicle, "Stwheel" .. tostring(stwhid), wrx, driftangle, wrz, "parent")
		local rpm = exports.tunrc_carsounds:getVehicleRPM(localPlayer.vehicle)
			setVehicleComponentRotation(localPlayer.vehicle, "RPM", 0, rpm/45, 0)
			setVehicleComponentRotation(localPlayer.vehicle, "DialsRPM" .. tostring(dialsid), 0, rpm/50, 0, "root")
		local spd = getElementSpeed(localPlayer.vehicle, "mph")
			setVehicleComponentRotation(localPlayer.vehicle, "Speedo", 0, spd * 1.4, 0)	
		local oil = getElementData(getPedOccupiedVehicle ( localPlayer ), "fuel" ) or 0
			setVehicleComponentRotation(localPlayer.vehicle, "petrolok", 0, oil * 2, 0)
end
addEventHandler("onClientRender", root, updateSteeringWheelRotation)

function getElementSpeed(element, unit)
	if (unit == nil) then
		unit = 0
	end
	if (isElement(element)) then
		local x, y, z = getElementVelocity(element)

		if (unit == "mph" or unit == 1 or unit == '1') then
			return math.floor((x^2 + y^2 + z^2) ^ 0.35 * 100)
		else
			return math.floor((x^2 + y^2 + z^2) ^ 0.35 * 100 * 1.609344)
		end
	else
		return false
	end
end