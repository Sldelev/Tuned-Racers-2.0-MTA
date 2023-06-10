function toggleVehicleParam(action, value)
	if not localPlayer.vehicle then
		return false
	end
	if localPlayer.vehicle.controller ~= localPlayer then
		return false
	end
	triggerServerEvent("tunrc_Vehicles.vehicleAction", resourceRoot, action, value)
end

bindKey("1", "down", function ()
    if not isElement(localPlayer.vehicle) then
        return
    end
    triggerServerEvent("tunrc_Vehicles.vehicleAction", resourceRoot, "lights")
end)