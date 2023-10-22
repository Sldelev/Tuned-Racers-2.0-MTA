local CONFIG_PROPERTY_NAME = "graphics.improved_sky"

addEventHandler( "onClientResourceStart", resourceRoot, function()
	if exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME) == true then
		startDynamicSky()
	else
		stopDynamicSky()
	end
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		if value then
			startDynamicSky()
		else
			stopDynamicSky()
		end
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, stopDynamicSky)