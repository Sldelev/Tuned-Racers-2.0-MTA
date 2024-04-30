NotificationBox = {}
local UI = exports.tunrc_UI
local screenWidth, screenHeight = guiGetScreenSize()
local isActive = false
local headerText = ""
local messageText = ""
local width, height = 325, 90
local headerHeight = 40
local offset = 25
local ui = {}

function NotificationBox.start()
	ui.panel = UI:createTrcRoundedRectangle {
		x = screenWidth - width - offset / 2,
		y = height / 2 + offset,
		width = width,
		height = height,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20),
		shadow = true
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
		fontType = "lightNotVerySmall",
		alignX = "center"
	}
	UI:addChild(ui.panel, ui.headerLabel)
	
	ui.messageLabel = UI:createDpLabel {
		x = 0,
		y = -5,
		width = width,
		height = height,
		text = "",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "lightNotVerySmall",
		alignX = "center",
		alignY = "center",
		clip = false,
		wordBreak = true
	}
	UI:addChild(ui.headerLabel, ui.messageLabel)
end
addEventHandler("onClientResourceStart", resourceRoot, MessageBox.start)

function NotificationBox.hide()
	if not isActive then
		return false
	end
	isActive = false
	-- TODO: Показать следующее окно из очереди
	UI:setVisible(ui.panel, false)
	showCursor(false)
end


function NotificationBox.show(header, text)
	if type(header) ~= "string" or type(text) ~= "string" then
		return false
	end
	isActive = true
	UI:setText(ui.headerLabel, header)
	UI:setText(ui.messageLabel, text)
	UI:setVisible(ui.panel, true)
	setTimer ( function()
		NotificationBox.hide()
	end, 4000, 1 )
end

function NotificationBox.isActive()
	return isActive
end