local function vehicleAction(name, value)
	return function()
		exports.tunrc_Vehicles:toggleVehicleParam(name, value)
	end
end

local function getActionString(name, value)
	return function(vehicle)
		if name == "lock" then
			if vehicle:getData("locked") then
				return exports.tunrc_Lang:getString("context_menu_vehicle_unlock")
			else
				return exports.tunrc_Lang:getString("context_menu_vehicle_lock")
			end
		end
	end
end

local myVehicleMenu = {
	{ getText = getActionString("lock"), 		click = vehicleAction("lock")},	
}

local vehicleMenu = {
	title = "Автомобиль",
	items = {}
}

function vehicleMenu:init(vehicle)
	if not isElement(vehicle) then
		return
	end
	if not vehicle.controller then
		return false
	end

	if vehicle.controller == localPlayer then
		self.items = myVehicleMenu
		self.title = exports.tunrc_Lang:getString("context_menu_title_car")
	else
		local player = vehicle.controller
		self.items = remotePlayerMenu
		self.title = string.format("%s %s", 
			exports.tunrc_Lang:getString("context_menu_title_player"),
			tostring(exports.tunrc_Utils:removeHexFromString(player.name)))
	end
end

registerContextMenu("vehicle", vehicleMenu)