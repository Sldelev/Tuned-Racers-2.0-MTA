local states = {}

function showAll()
	Radar.setVisible(true)
	states.radar = true
end

function setVisible(visible)
	if not visible then
		Radar.setVisible(false)	
	else
		Radar.setVisible(true)	
	end
end

function setRadarVisible(...)
	return Radar.setVisible(...)
end

function setSpeedometerVisible(visible)
	if not localPlayer.vehicle then
		return
	else
		if localPlayer.vehicle.controller ~= localPlayer then
			return
		end
		Speedometer.setVisible(visible)
	end
end