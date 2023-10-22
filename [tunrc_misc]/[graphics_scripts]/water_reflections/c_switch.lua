local CONFIG_PROPERTY_NAME = "graphics.reflections_water"

addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()		
		triggerEvent("switchWaterShine", resourceRoot, exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME))
	end
)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		if value then
			enableWaterShine()
		else
			disableWaterShine()
		end
	end
end)