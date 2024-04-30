MessageBox = {}
local UI = exports.tunrc_UI
local screenWidth, screenHeight = guiGetScreenSize()
local isActive = false
local headerText = ""
local messageText = ""
local width, height = 300, 200
local headerHeight = 40
local ui = {}

function MessageBox.start()
	ui.panel = UI:createTrcRoundedRectangle {
		x = (screenWidth - width) / 2,
		y = (screenHeight - height) / 2,
		width = width,
		height = height,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(ui.panel)
	UI:setVisible(ui.panel, false)
	
	ui.headerLabel = UI:createDpLabel {
		x = 0 , y = 10,
		width = width,
		height = 10,
		text = "",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultSmall",
		alignX = "center"
	}
	UI:addChild(ui.panel, ui.headerLabel)
	
	ui.messageLabel = UI:createDpLabel {
		x = 0,
		y = 60,
		width = width,
		height = 10,
		text = "",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultSmall",
		alignX = "center",
		alignY = "center",
		clip = false,
		wordBreak = true
	}
	UI:addChild(ui.headerLabel, ui.messageLabel)
	
	local buttonsHeight = 50
	local buttonsWidth = width / 2 - 20
	-- Кнопка "Отмена"	
	ui.cancelButton = UI:createTrcRoundedRectangle {
		x = UI:getWidth(ui.panel) / 2 - buttonsWidth / 2,
		y = height - buttonsHeight - 10,
		width = buttonsWidth,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "moderatorpanel_close"
	}
	UI:addChild(ui.panel, ui.cancelButton)
end
addEventHandler("onClientResourceStart", resourceRoot, MessageBox.start)

function MessageBox.show(header, text, buttons)
	if type(header) ~= "string" or type(text) ~= "string" then
		return false
	end
	if isActive then
		-- TODO: Добавить окно в очередь окон
		return false
	end
	isActive = true
	UI:setText(ui.headerLabel, header)
	UI:setText(ui.messageLabel, text)
	UI:setVisible(ui.panel, true)
	showCursor(true)
	exports.tunrc_UI:fadeScreen(true)
end

function MessageBox.hide()
	if not isActive then
		return false
	end
	isActive = false
	-- TODO: Показать следующее окно из очереди
	UI:setVisible(ui.panel, false)
	showCursor(false)
	exports.tunrc_UI:fadeScreen(false)
end

function MessageBox.isActive()
	return isActive
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == ui.cancelButton then
		MessageBox.hide()
	end
end)