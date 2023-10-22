local CONFIG_PROPERTY_NAME = "graphics.fxaa"

addEventHandler( "onClientResourceStart", resourceRoot, function()
	if tonumber(dxGetStatus().VideoCardPSVersion) < 3 then 
			outputChatBox('fxaa: Shader Model 3 not supported',255,0,0) 
			return 
	end
	if exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME) == true then
		enableFxaa()
	else
		disableFxaa()
	end
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		if value then
			enableFxaa()
		else
			disableFxaa()
		end
	end
end)
