local gameplaySettings = {
	start_vehicle = "tunrc_zr350",
    default_vehicle_color = {150, 150, 150},
	
	start_money = 5000,
	
    default_garage_slots = 999,
    premium_garage_slots = 999,
	

    garage_slots_levels = {0, 1}
}

function getGameplaySetting(name)
	if not name then
		return
	end
	return gameplaySettings[name]
end