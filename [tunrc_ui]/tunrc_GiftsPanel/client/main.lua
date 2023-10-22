local UI = exports.tunrc_UI
local screenSize = Vector2(UI:getScreenSize())
local ui = {}
local panelWidth = 400
local panelHeight = 250
local BUTTON_HEIGHT = 50
local vehicle

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

	-- Кнопка "Отмена"
	ui.cancelButtonShadow = UI:createTrcRoundedRectangle {
		x       = 18,
        y       = panelHeight - BUTTON_HEIGHT - 12,
        width   = 155,
        height  = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(0, 0, 0, 20)
	}
	UI:addChild(ui.panel, ui.cancelButtonShadow)
	
	ui.cancelButton = UI:createTrcRoundedRectangle {
		x       = 15,
        y       = panelHeight - BUTTON_HEIGHT - 15,
        width   = 155,
        height  = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(ui.panel, ui.cancelButton)
	
	ui.cancelButtonText = UI:createDpLabel {
		x = 78,
		y = 25,
		width = width,
		height = height,
		text = "Admin",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center",
		locale = "gift_key_panel_back"
	}
	UI:addChild(ui.cancelButton, ui.cancelButtonText)
	
	-- Кнопка "Активировать"
	ui.activateButtonShadow = UI:createTrcRoundedRectangle {
		x       = panelWidth - 167,
        y       = panelHeight - BUTTON_HEIGHT - 12,
        width   = 155,
        height  = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(0, 0, 0, 20)
	}
	UI:addChild(ui.panel, ui.activateButtonShadow)
	
	ui.activateButton = UI:createTrcRoundedRectangle {
		x       = panelWidth - 170,
        y       = panelHeight - BUTTON_HEIGHT - 15,
        width   = 155,
        height  = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(ui.panel, ui.activateButton)
	
	ui.activateButtonText = UI:createDpLabel {
		x = 78,
		y = 25,
		width = width,
		height = height,
		text = "Admin",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center",
		locale = "gift_key_panel_activate"
	}
	UI:addChild(ui.activateButton, ui.activateButtonText)

	local labelOffset = 0.45
	ui.mainLabel = UI:createDpLabel({
		x = 0 , y = -25,
		width = panelWidth,
		height = panelHeight * labelOffset,
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarge",
		locale = "gift_key_main_label",
		alignX = "center",
		alignY = "center"
	})
	UI:addChild(ui.panel, ui.mainLabel)

	ui.keyInput = UI:createDpInput({
		x = 50,
		y = panelHeight * 0.3,
		width = panelWidth - 100,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "gift_key_input_placeholder",
		forceRegister = "upper",
		regexp = "[a-zA-Z0-9]",
	})
	UI:addChild(ui.panel, ui.keyInput)

	UI:setVisible(ui.panel, false)

	if localPlayer:getData("activeUI") == "giftsPanel" then
		localPlayer:setData("activeUI", false)
		setVisible(false)
	end
end)

function setVisible(visible)
	UI = exports.tunrc_UI
	local isVisible = UI:getVisible(ui.panel)
	if not not isVisible == not not visible then
		return false
	end 
	if visible then
		if localPlayer:getData("activeUI") then
			return false
		end
		localPlayer:setData("activeUI", "giftsPanel")
	else
		localPlayer:setData("activeUI", false)
	end

	UI:setVisible(ui.panel, visible)
	showCursor(visible)

	exports.tunrc_HUD:setVisible(not visible)
	exports.tunrc_UI:fadeScreen(visible)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == ui.activateButton then
		if localPlayer:getData("last_code_use_time") > getRealTime(false).timestamp then
		setVisible(false)
		UI:showMessageBox(
			exports.tunrc_Lang:getString("gift_key_message_title"), 
			exports.tunrc_Lang:getString("gift_key_message_use_wait"))
		end
		triggerServerEvent("tunrc_Core.requireKeyActivation", resourceRoot, UI:getText(ui.keyInput))
	elseif widget == ui.cancelButton then
		setVisible(false)
		exports.tunrc_overallPanel:setVisible(true)
	end
end)

addEvent("tunrc_Core.keyActivation", true)
addEventHandler("tunrc_Core.keyActivation", root, function (success, info)
	if success then
		UI:showMessageBox(
			exports.tunrc_Lang:getString("gift_key_message_title"), 
			exports.tunrc_Lang:getString("gift_key_message_success"))
		setVisible(false)
	else
		UI:showMessageBox(
			exports.tunrc_Lang:getString("gift_key_message_title"), 
			exports.tunrc_Lang:getString("gift_key_message_fail"))
	end
end)

addEvent("tunrc_Core.donation", true)
addEventHandler("tunrc_Core.donation", root, function (amount)
	if localPlayer:getData("activeUI") then
		return
	end
	UI:showMessageBox(
		exports.tunrc_Lang:getString("donation_tunrc_message_title"), 
		string.format(exports.tunrc_Lang:getString("donation_tunrc_message_text"), "$" .. tostring(amount)))
end)