addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Создать панель
	Panel.create()
	-- Создать табы
	TeleportTab.create()
	AchievementsTab.create()
	SettingsTab.create()
	Panel.showTab("teleport")
	Panel.setVisible(false)
end)

function isVisible()
	return Panel.isVisible()
end

bindKey("F3", "down", function ()
	Panel.setVisible(not Panel.isVisible())
	PasswordPanel.hide()
	FpsPanel.hide()
	-- панели настроек
	Interface.hide()
	Gameplay.hide()
	Graphics.hide()
	Sound.hide()
end)

bindKey("backspace", "down", function ()
	Panel.setVisible(false)
end)

function setVisible(visible)
	Panel.setVisible(visible)
end
