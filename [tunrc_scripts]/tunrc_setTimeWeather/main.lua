function setTimeWeather()
	setTime( 8, 0 )
	setWeather (15)
end
bindKey( "]", "down", setTimeWeather )