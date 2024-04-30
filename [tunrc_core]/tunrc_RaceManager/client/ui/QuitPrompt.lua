QuitPrompt = {}
local screenSize = Vector2(guiGetScreenSize())
local BUTTON_HEIGHT = 50
local UI = exports.tunrc_UI
local ui = {}

local panelWidth, panelHeight = 350, 150

function QuitPrompt.isVisible()
	return not not UI:getVisible(ui.panel)
end

function QuitPrompt.toggle()
	if QuitPrompt.isVisible() then
		QuitPrompt.hide()
	else
		QuitPrompt.show()
	end
end

function QuitPrompt.show()
	if QuitPrompt.isVisible() then
		return false
	end 
	showCursor(true)
	exports.tunrc_UI:fadeScreen(true)
	UI:setVisible(ui.panel, true)
	return true
end

function QuitPrompt.hide()
	if not QuitPrompt.isVisible() then
		return false
	end 
	showCursor(false)
	exports.tunrc_UI:fadeScreen(false)
	UI:setVisible(ui.panel, false)
	return true	
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = UI:createTrcRoundedRectangle {
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight) / 1.7,
		width = panelWidth,
		height = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(ui.panel)
	
	ui.cancelButton = UI:createTrcRoundedRectangle {
		x = 10,
		y = panelHeight - BUTTON_HEIGHT - 10,
		width = panelWidth / 3,
		height = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "race_ui_quit_prompt_cancel"
	}
	UI:addChild(ui.panel, ui.cancelButton)
	
	ui.acceptButton = UI:createTrcRoundedRectangle {
		x = UI:getWidth(ui.panel) - (panelWidth / 3) - 20,
		y = 0,
		width = panelWidth / 3,
		height = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "race_ui_quit_prompt_leave"
	}
	UI:addChild(ui.cancelButton, ui.acceptButton)	

	ui.mainLabel = UI:createDpLabel({
		x = 0 , y = 0,
		width = panelWidth, height = panelHeight - BUTTON_HEIGHT,
		type = "light",
		fontType = "defaultSmall",
		text = "",
		locale = "race_ui_quit_prompt_text",
		wordBreak = true,
		alignX = "center",
		alignY = "center"
	})
	UI:addChild(ui.panel, ui.mainLabel)	

	UI:setVisible(ui.panel, false)
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == ui.cancelButton then
		QuitPrompt.hide()
	elseif widget == ui.acceptButton then
		QuitPrompt.hide()
		RaceClient.leaveRace()
	end
end)