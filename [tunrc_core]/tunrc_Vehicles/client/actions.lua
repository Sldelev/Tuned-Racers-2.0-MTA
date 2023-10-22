function toggleVehicleParam(action, value)
	if not localPlayer.vehicle then
		return false
	end
	if localPlayer.vehicle.controller ~= localPlayer then
		return false
	end
	triggerServerEvent("tunrc_Vehicles.vehicleAction", resourceRoot, action, value)
end