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
	PropsStorage.setDefault("ui.draw_chat", true)
	PropsStorage.setDefault("ui.radar_rotate", true)
	PropsStorage.setDefault("ui.dark_mode", false)
	PropsStorage.setDefault("ui.show_fps", false)
	PropsStorage.setDefault("chat.timestamp", false)
	PropsStorage.setDefault("chat.joinquit_messages", true)
	PropsStorage.setDefault("chat.block_offensive_words", true)
	-- Параметры графики
	PropsStorage.setDefault("graphics.ssao", false)
	PropsStorage.setDefault("graphics.ssao_quality", 0)
	PropsStorage.setDefault("graphics.fxaa", false)
	PropsStorage.setDefault("graphics.wetroad", false)
	PropsStorage.setDefault("graphics.improved_sky", false)
	PropsStorage.setDefault("graphics.rain_drops", false)
	PropsStorage.setDefault("graphics.improved_car_lights", false)
	PropsStorage.setDefault("graphics.wraps_quality", 0)
	PropsStorage.setDefault("graphics.textures_quality", 0)
	--неймтеги
	PropsStorage.setDefault("graphics.nametags", true)
	PropsStorage.setDefault("graphics.self_nametags", false)
	-- всякая хуйня
	PropsStorage.setDefault("graphics.tyres_smoke", true)
	PropsStorage.setDefault("graphics.smooth_steering", true)
	-- Параметры звуков
	PropsStorage.setDefault("game.background_music", true)	
	PropsStorage.setDefault("sounds.background_music_volume", 100)
	PropsStorage.setDefault("game.world_music", true)
	PropsStorage.setDefault("sounds.world_music_volume", 100)
	PropsStorage.setDefault("sounds.car_sounds_enable", true)
	PropsStorage.setDefault("sounds.car_sounds_volume", 100)
	-- Параметры игры
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
