local function getDefaultLanguage()
	local lang = getLocalization().code
	if lang == "ru" then
		return "russian"
	else
		return "english"
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	PropsStorage.init("player_prefs.json")
	-- Настройки по умолчанию
	-- Параметры интерфейса
	PropsStorage.setDefault("ui.language", getDefaultLanguage())
	PropsStorage.setDefault("ui.theme", "red")
	PropsStorage.setDefault("ui.blur", true)
	PropsStorage.setDefault("ui.draw_speedo", true)
	PropsStorage.setDefault("chat.timestamp", false)
	PropsStorage.setDefault("chat.joinquit_messages", true)
	PropsStorage.setDefault("chat.block_offensive_words", true)
	-- Параметры графики
	PropsStorage.setDefault("graphics.reflections_cars", false)
	PropsStorage.setDefault("graphics.reflections_water", false)
	PropsStorage.setDefault("graphics.improved_car_lights", false)
	PropsStorage.setDefault("graphics.enable_glass_vynils", true)
	PropsStorage.setDefault("graphics.nametags", true)
	PropsStorage.setDefault("graphics.self_nametags", false)
	PropsStorage.setDefault("graphics.improved_sky", false)
	PropsStorage.setDefault("graphics.tyres_smoke", true)
	PropsStorage.setDefault("graphics.smooth_steering", true)
	PropsStorage.setDefault("graphics.flame", true)
	PropsStorage.setDefault("graphics.hdroad", false)
	PropsStorage.setDefault("graphics.vynils_resolution", 4)
	-- Параметры игры
	PropsStorage.setDefault("game.background_music", true)
	PropsStorage.save()
end)

function setProperty(key, value)
	return PropsStorage.set(key, value)
end

function getProperty(key)
	return PropsStorage.get(key)
end
