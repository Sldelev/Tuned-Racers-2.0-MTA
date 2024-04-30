addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Создать панель
	Panel.create()
	Panel.setVisible(false)
	AccountPanel.hide()
	TeleportsPanel.hide()
	PasswordPanel.hide()
end)

function isVisible()
	return Panel.isVisible()
end

bindKey("F1", "down", function ()
	Panel.setVisible(not Panel.isVisible())
	AccountPanel.hide()
	TeleportsPanel.hide()
	PasswordPanel.hide()
	SettingsPanel.hide()
end)

bindKey("backspace", "down", function ()
	Panel.setVisible(false)
end)

function setVisible(visible)
	Panel.setVisible(visible)
end
