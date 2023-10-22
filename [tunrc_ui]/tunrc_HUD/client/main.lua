local defaultRotationX = 5
local defaultRotationY = -15

local rotationX = 15
local rotationY = -20

local camera = getCamera()

addEventHandler("onClientResourceStart", resourceRoot, function ()
	setPlayerHudComponentVisible("all", false)
	Radar.start()
	Radar.setVisible(true)
	
	Speedometer.start()
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
    if key == PROPERTY_SHOW_SPEEDO then
		Speedometer.setVisible(value)
	end
end)