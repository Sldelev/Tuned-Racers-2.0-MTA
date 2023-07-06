admin.ui = {}
local screenSize = Vector2(guiGetScreenSize())
local windowSize = Vector2(650, 450)
-- Элементы интерфейса
local ui = {}

-- Кастомные события
addEvent("tunrc_Admin.panelOpened", false)
addEvent("tunrc_Admin.panelClosed", false)

-- Создание вкладки
function admin.ui.addTab(name, label)
	local tab = GuiTab(label, ui.tabPanel)
	tab.id = "tunrc_AdminTab_" .. name
	tab:setData("tabName", name)
	return tab
end

-- Получение вкладки по названию
function admin.ui.getTab(name)
	if type(name) ~= "string" then
		return false
	end
	return Element.getByID("tunrc_AdminTab_" .. name)
end

function admin.isPanelVisible()
	return not not ui.window.visible
end

function admin.getActiveTab()
	return ui.tabPanel.selectedTab:getData("tabName")
end

function admin.getWindow()
	return ui.window
end

function admin.togglePanel()
	local visible = not ui.window.visible
	if localPlayer:getData("aclGroup") ~= "admin" then
		visible = false
	end
	if ui.window.visible == visible then
		return 
	end
	ui.window.visible = visible
	showCursor(visible)
	if visible then
		triggerEvent("tunrc_Admin.panelOpened", resourceRoot)
	else
		triggerEvent("tunrc_Admin.panelClosed", resourceRoot)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.window = GuiWindow(
		(screenSize.x - windowSize.x) / 2, 
		(screenSize.y - windowSize.y) / 2,
		windowSize.x,
		windowSize.y, 
		"TunerRacers", 
		false)
	ui.window.sizable = false
	ui.window.movable = true
	ui.window.visible = false
	ui.tabPanel = GuiTabPanel(0, 0.04, 1, 1, true, ui.window)
end)

-- setTimer(admin.togglePanel, 50, 1)
bindKey("f5", "down", admin.togglePanel)