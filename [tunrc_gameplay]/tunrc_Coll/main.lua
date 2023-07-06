local CONFIG_PROPERTY_NAME = "game.coll"

local playerVehicle = getPedOccupiedVehicle(localPlayer) -- Get the players vehicle

function collisions()
	isEnabled = exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME)
	if isEnabled then
		for i, vehicle1 in ipairs(getElementsByType("vehicle")) do
			for j, vehicle2 in ipairs(getElementsByType("vehicle")) do
				vehicle1:setCollidableWith(vehicle2, false)
			end
		end
			setCameraClip (true,false)
			outputDebugString("You are now a Ghost")
	else
		for i, vehicle1 in ipairs(getElementsByType("vehicle")) do
			for j, vehicle2 in ipairs(getElementsByType("vehicle")) do
				vehicle1:setCollidableWith(vehicle2, true)
			end
		end
			setCameraClip (true,true)
			outputDebugString("You are not a Ghost")
	end
end

function setEnabled(enable)
	isEnabled = not not enable
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	collisions()
end)

addEventHandler("onClientElementStreamIn", root, function()
	if isEnabled == false then
		return
	end
	if source.type == "vehicle" then
		collisions()
	end
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
    if key == CONFIG_PROPERTY_NAME then
		setEnabled(value)
		collisions()
	end
end)