function setTimeWeather()
	setTime( 8, 0 )
	setWeather (15)
end
bindKey( "]", "down", setTimeWeather )

addEventHandler("onClientRender", root, function()
	if getWeather() == 8 then
		setGrainMultiplier( "rain", 0 )
	end
end
)