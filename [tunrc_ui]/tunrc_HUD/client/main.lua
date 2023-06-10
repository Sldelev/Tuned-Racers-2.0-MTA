local defaultRotationX = 5
local defaultRotationY = -15

local rotationX = 15
local rotationY = -20

local camera = getCamera()

PROPERTY_SHOW_SPEEDO = "ui.draw_speedo"

addEventHandler("onClientResourceStart", resourceRoot, function ()
	setPlayerHudComponentVisible("all", false)
	Speedometer.start()
	Radar.start()
	
	Speedometer.setVisible(exports.tunrc_Config:getProperty(PROPERTY_SHOW_SPEEDO))
	Radar.setVisible(true)
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
    if key == PROPERTY_SHOW_SPEEDO then
		Speedometer.setVisible(value)
	end
end)