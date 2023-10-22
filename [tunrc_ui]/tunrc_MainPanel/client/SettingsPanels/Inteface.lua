Interface = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 550
local panelHeight = 450

local isVisible = false
local ui = {}

function Interface.show()
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "InterfaceSettings")
end

function Interface.hide()
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
    ui.panel = UI:createDpPanel {
        x       = (screenWidth  - panelWidth)  / 2,
        y       = (screenHeight - panelHeight) / 2,
        width   = panelWidth,
        height  = panelHeight,
        type    = "light"
    }
    UI:addChild(ui.panel)
    UI:setVisible(ui.panel, false)
	
	y = 30
	-- Подпись к смене языка
	UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_language"
    })
	-- Кнопка смены языка
	ui.languageButton = UI:createDpButton({
        x      = 100,
        y      = y - 5,
        width  = panelWidth / 6,
        height = 35,
		text = "",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.languageButton)
	UIDataBinder.bind(ui.languageButton, "languageText", function (value)
		if exports.tunrc_Lang:getLanguage() == "english" then
			return "English"
		else
			return "Русский"
		end
	end)	
	y = y + 30
	-- Отображение ников
    ui.nametagsCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.nametagsCheckbox)
    UI:setState(ui.nametagsCheckbox, exports.tunrc_Config:getProperty("graphics.nametags"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_nametags"
    })
	
	-- Отрисовка очков дрифта
	y = y + 30
    ui.dpointsCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.dpointsCheckbox)
    UI:setState(ui.dpointsCheckbox, exports.tunrc_Config:getProperty("ui.draw_points"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_screen_draw_drift_points"
    })
	
	-- Сообщения о подключениях
    y = y + 30
    ui.joinQuitMessagesCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.joinQuitMessagesCheckbox)
    UI:setState(ui.joinQuitMessagesCheckbox, exports.tunrc_Config:getProperty("chat.joinquit_messages"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_joinquit_messages"
    })
	
	 -- Размытие
	y = y + 30
    ui.blurChechbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.blurChechbox)
    UI:setState(ui.blurChechbox, exports.tunrc_Config:getProperty("ui.blur"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_screen_blur"
    })
	
	x = panelWidth / 1.7
	dy = 35
	-- Отображение своего ника
    ui.SelfnametagsCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = dy,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.SelfnametagsCheckbox)
    UI:setState(ui.SelfnametagsCheckbox, exports.tunrc_Config:getProperty("graphics.self_nametags"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = dy - 5,
        width    = panelWidth / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_selfnametags"
    })
	
	-- Отображение спидометра
	dy = dy + 30
    ui.speedoChechbox = UI:createDpCheckbox {
        x      = x,
        y      = dy,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.speedoChechbox)
    UI:setState(ui.speedoChechbox, exports.tunrc_Config:getProperty("ui.draw_speedo"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = dy - 5,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_screen_draw_speedo"
    })
	
	-- Время в чате
	dy = dy + 30
    ui.chatTimestampCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = dy,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.chatTimestampCheckbox)
    UI:setState(ui.chatTimestampCheckbox, exports.tunrc_Config:getProperty("chat.timestamp"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = dy - 5,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_chat_timestamp"
    })
	
	-- Поворот радара
	dy = dy + 30
    ui.radarRotCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = dy,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.radarRotCheckbox)
    UI:setState(ui.radarRotCheckbox, exports.tunrc_Config:getProperty("ui.radar_rotate"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = dy - 5,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_radar_rotate"
    })
	-- тёмная тема
	dy = dy + 30
    ui.darkModeCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = dy,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.darkModeCheckbox)
    UI:setState(ui.darkModeCheckbox, exports.tunrc_Config:getProperty("ui.dark_mode"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = dy - 5,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_dark_mode"
    })
	
	UI:setHeight(ui.panel, y + 100)
    -- Высота кнопок
    local buttonsHeight = 50
    -- Кнопка отмены
    ui.cancelButton = UI:createDpButton({
        x      = panelWidth / 4,
        y      = y + 40,
        width  = panelWidth / 2,
        height = buttonsHeight,
        locale = "main_panel_new_password_cancel",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.cancelButton)
  
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	local playClickSound = false
	
    if widget == ui.cancelButton then
        Interface.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
        Panel.setVisible(true)
		Panel.showTab("settings")
    end
	
	if widget == ui.joinQuitMessagesCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("chat.joinquit_messages", UI:getState(widget))
    elseif widget == ui.chatTimestampCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("chat.timestamp", UI:getState(widget))
    elseif widget == ui.blurChechbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("ui.blur", UI:getState(widget))
	elseif widget == ui.speedoChechbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("ui.draw_speedo", UI:getState(widget))
	elseif widget == ui.dpointsCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("ui.draw_points", UI:getState(widget))       
    elseif widget == ui.nametagsCheckbox then
        playClickSound = true
		exports.tunrc_Config:setProperty("graphics.nametags", UI:getState(widget))     
	elseif widget == ui.SelfnametagsCheckbox then
        playClickSound = true
		exports.tunrc_Config:setProperty("graphics.self_nametags", UI:getState(widget))
	elseif widget == ui.radarRotCheckbox then
        playClickSound = true
		exports.tunrc_Config:setProperty("ui.radar_rotate", UI:getState(widget))
	elseif widget == ui.darkModeCheckbox then
        playClickSound = true
		exports.tunrc_Config:setProperty("ui.dark_mode", UI:getState(widget))
    elseif widget == ui.languageButton then
        playClickSound = true
		if exports.tunrc_Lang:getLanguage() == "english" then
			exports.tunrc_Lang:setLanguage("russian")
			UIDataBinder.refresh()
		else
			exports.tunrc_Lang:setLanguage("english")
			UIDataBinder.refresh()
		end
    end

    if playClickSound then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
end)