PasswordPanel = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 300
local panelHeight = 300

local isVisible = false
local ui = {}

function PasswordPanel.show()
    if isVisible then
        return false
    end
	Panel.setVisible(false)
	AccountPanel.hide()
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "passwordChange")
end

function PasswordPanel.hide()
    if not isVisible then
        return false
    end
    isVisible = false
    exports.tunrc_HUD:setVisible(true)
    exports.tunrc_UI:fadeScreen(false)
    showCursor(false)
    UI:setVisible(ui.panel, false)
    localPlayer:setData("activeUI", false)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    ui.panel = UI:createTrcRoundedRectangle {
		x       = (screenWidth - panelWidth) / 2,
        y       = (screenHeight - panelHeight) / 2,
        width   = panelWidth,
        height  = panelHeight - 50,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(ui.panel)
    UI:setVisible(ui.panel, false)

    -- Высота кнопок
    local buttonsHeight = 50
    -- Кнопка отмены
	
	 ui.cancelButtonShadow = UI:createTrcRoundedRectangle {
		x       = 12,
        y       = panelHeight - 108,
        width   = 125,
        height  = 50,
		radius = 15,
		color = tocolor(0, 0, 0, 20)
	}
    UI:addChild(ui.panel, ui.cancelButtonShadow)
	
    ui.cancelButton = UI:createTrcRoundedRectangle {
		x       = 10,
        y       = panelHeight - 110,
        width   = 125,
        height  = 50,
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
		x = 62,
		y = 25,
		width = width,
		height = height,
		text = "Admin",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center",
		locale = "main_panel_new_password_cancel"
	}
	UI:addChild(ui.cancelButton, ui.cancelButtonText)

    -- Кнопка "принять"
	ui.acceptButtonShadow = UI:createTrcRoundedRectangle {
		x       = 167,
        y       = panelHeight - 108,
        width   = 125,
        height  = 50,
		radius = 15,
		color = tocolor(0, 0, 0, 20)
	}
    UI:addChild(ui.panel, ui.acceptButtonShadow)
	
    ui.acceptButton = UI:createTrcRoundedRectangle {
		x       = 165,
        y       = panelHeight - 110,
        width   = 125,
        height  = 50,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30)
	}
    UI:addChild(ui.panel, ui.acceptButton)
	
	ui.acceptButtonText = UI:createDpLabel {
		x = 62,
		y = 25,
		width = width,
		height = height,
		text = "Admin",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center",
		locale = "main_panel_new_password_accept"
	}
	UI:addChild(ui.acceptButton, ui.acceptButtonText)

    -- Ввод нового пароля
    local y = 10
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 0, 
        y        = y,
        width    = panelWidth, 
        height   = 30,
        fontType = "defaultSmall",
        color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
        alignX   = "center",
        locale   = "main_panel_password_change_title"
    })
	-- Поле пароля
    y = y + 40
    ui.newPasswordInput = UI:createDpInput({
        x      = 10,
        y      = y,
        width  = panelWidth - 20,
        height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
        masked = true,
        locale = "main_panel_new_password_placeholder"
    })
    UI:addChild(ui.panel, ui.newPasswordInput)
	-- Поле подтверждения пароля
    y = y + 70
    ui.newPasswordRepeatInput = UI:createDpInput({
        x      = 10,
        y      = y,
        width  = panelWidth - 20,
        height = 50,
        color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
        masked = true,
        locale = "main_panel_new_password_repeat_placeholder"
    })    
    UI:addChild(ui.panel, ui.newPasswordRepeatInput)    
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == ui.acceptButton then
        local newPassword = UI:getText(ui.newPasswordInput)
        if not newPassword or string.len(newPassword) < 1 then
            exports.tunrc_UI:showMessageBox(
                exports.tunrc_Lang:getString("main_panel_password_change_message"), 
                exports.tunrc_Lang:getString("login_panel_err_enter_password")
            )
            exports.tunrc_Sounds:playSound("ui_error.wav")
            return
        end
        if newPassword ~= UI:getText(ui.newPasswordRepeatInput) then
            exports.tunrc_UI:showMessageBox(
                exports.tunrc_Lang:getString("main_panel_password_change_message"), 
                exports.tunrc_Lang:getString("login_panel_err_passwords_do_not_match")
            )
            exports.tunrc_Sounds:playSound("ui_error.wav")
            return
        end 
        local success, errorType = exports.tunrc_Core:changePassword(newPassword)
        if not success then
            local errorText = exports.tunrc_Lang:getString("main_panel_password_change_error")
            if errorType == "password_too_short" then
                errorText = exports.tunrc_Lang:getString("login_panel_err_password_too_short")
            elseif errorType == "password_too_long" then
                errorText = exports.tunrc_Lang:getString("login_panel_err_password_too_long")
            end            
            exports.tunrc_UI:showMessageBox(
                exports.tunrc_Lang:getString("main_panel_password_change_message"),
                errorText
            )
            outputDebugString("Client password change error: " .. tostring(errorType))
            exports.tunrc_Sounds:playSound("ui_error.wav")
            return 
        end
        PasswordPanel.hide()
        exports.tunrc_Sounds:playSound("ui_select.wav")
        Panel.setVisible(true)
    elseif widget == ui.cancelButton then
        PasswordPanel.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
        Panel.setVisible(true)
    end
end)

addEvent("tunrc_Core.passwordChangeResponse", true)
addEventHandler("tunrc_Core.passwordChangeResponse", root, function (success, err)
    if not success then
        exports.tunrc_UI:showMessageBox(
            exports.tunrc_Lang:getString("main_panel_password_change_message"),
            exports.tunrc_Lang:getString("main_panel_password_change_error")
        )        
        exports.tunrc_Sounds:playSound("ui_error.wav")
        return
    end

    exports.tunrc_UI:showMessageBox(
        exports.tunrc_Lang:getString("main_panel_password_change_message"),
        exports.tunrc_Lang:getString("main_panel_password_change_success")
    )

    local username = localPlayer:getData("username")
    if not username then
        return false
    end
    -- Очистка пароля в автозаполнении
    exports.tunrc_LoginPanel:autologinRemember(username, "")
end)