addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Отключение размытия при движении
	setBlurLevel(0)
	-- Отключение скрытия объектов
	setOcclusionsEnabled(false)
	-- Отключение фоновых звуков стрельбы
	setWorldSoundEnabled(5, false)
end)
