local CONFIG_PROPERTY_NAME = "graphics.improved_sky"

addEventHandler( "onClientResourceStart", resourceRoot, function()
	triggerEvent("switchDynamicSky", resourceRoot, exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME) or true or false)
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