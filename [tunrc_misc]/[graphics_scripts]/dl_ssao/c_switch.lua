local CONFIG_PROPERTY_NAME = "graphics.ssao"

addEventHandler( "onClientResourceStart", resourceRoot, function()
	if exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME) == true then
		enableAO()
	else
		disableAO()
	end	
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		if value then
			enableAO()
		else
			disableAO()
		end
	end
end)
