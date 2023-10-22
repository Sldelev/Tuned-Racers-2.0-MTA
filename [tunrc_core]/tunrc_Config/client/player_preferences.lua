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
	PropsStorage.setDefault("ui.draw_points", true)
	PropsStorage.setDefault("ui.radar_rotate", true)
	PropsStorage.setDefault("ui.dark_mode", false)
	PropsStorage.setDefault("chat.timestamp", false)
	PropsStorage.setDefault("chat.joinquit_messages", true)
	PropsStorage.setDefault("chat.block_offensive_words", true)
	-- Параметры графики
	PropsStorage.setDefault("graphics.reflections_water", false)
	PropsStorage.setDefault("graphics.improved_car_lights", false)
	PropsStorage.setDefault("graphics.ssao", false)
	PropsStorage.setDefault("graphics.fxaa", false)
	PropsStorage.setDefault("graphics.wetroad", false)
	PropsStorage.setDefault("graphics.improved_sky", false)
	--неймтеги
	PropsStorage.setDefault("graphics.nametags", true)
	PropsStorage.setDefault("graphics.self_nametags", false)
	-- всякая хуйня
	PropsStorage.setDefault("graphics.tyres_smoke", true)
	PropsStorage.setDefault("graphics.smooth_steering", true)
	-- текстуры
	PropsStorage.setDefault("graphics.flame", true)
	PropsStorage.setDefault("graphics.hdroad", false)
	-- Параметры игры
	PropsStorage.setDefault("game.background_music", true)
	PropsStorage.setDefault("game.world_music", true)
	PropsStorage.setDefault("game.coll", false)
	PropsStorage.setDefault("game.fps_limit", 100)
	PropsStorage.save()
end)

function setProperty(key, value)
	return PropsStorage.set(key, value)
end

function getProperty(key)
	return PropsStorage.get(key)
end
