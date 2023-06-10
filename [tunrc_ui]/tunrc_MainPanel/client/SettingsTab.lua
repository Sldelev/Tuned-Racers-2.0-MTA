SettingsTab = {}
local ui = {}

local colorButtonsList = {
    { name = "red" },
    { name = "purple" },
    { name = "blue" },
	{ name = "black" },
}
local languageButtonsList = {
    { name = "en", language = "english" },
    { name = "ru", language = "russian" }
}

function SettingsTab.create()
    ui.panel = Panel.addTab("settings")

    local width = UI:getWidth(ui.panel)
    local height = UI:getHeight(ui.panel)

    local y = 10

    -- Раздел настроек игры
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20,
        y        = y,
        width    = width / 2,
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_settings_section_game"
    })

    -- Подпись к кнопкам выбора языка
    y = y + 25
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20,
        y        = y,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_language"
    })

    -- Кнопки выбора языка
    y = y + 20
    local langX = 20
    for i, languageButton in ipairs(languageButtonsList) do
        local button = UI:createDpImageButton({
            x       = langX,
            y       = y + 5,
            width   = 20,
            height  = 20,
            texture = exports.tunrc_Assets:createTexture("buttons/" .. tostring(languageButton.name) .. ".png")
        })
        UI:addChild(ui.panel, button)
        languageButton.button = button
        langX = langX + 25
    end


    local colorButtonsX = width * 0.6
    -- Подпись к кнопкам выбора цвета
    y = y - 20
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = colorButtonsX,
        y        = y,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_color"
    })

    y = y + 20
    local colorButtonX = colorButtonsX
    local circleTexture = exports.tunrc_Assets:createTexture("buttons/circle.png", "argb", false, "clamp")
    -- Кнопки выбора цвета
    for i, colorButton in ipairs(colorButtonsList) do
        local button = UI:createDpImageButton({
            x       = colorButtonX,
            y       = y + 5,
            width   = 20,
            height  = 20,
            color   = tocolor(exports.tunrc_UI:getThemeColor(colorButton.name)),
            texture = circleTexture
        })
        UI:addChild(ui.panel, button)
        colorButton.button = button
        colorButtonX = colorButtonX + 25
    end

    -- Раздел настроек чата
    y = y + 30
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20 ,
        y        = y,
        width    = width / 2,
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_settings_section_chat"
    })

    -- Сообщения о подключениях
    y = y + 30
    local chatSectionY = y
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
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_joinquit_messages"
    })

    -- Время в чате
    local chatTimestampX = width * 0.6
    ui.chatTimestampCheckbox = UI:createDpCheckbox {
        x      = chatTimestampX,
        y      = chatSectionY + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.chatTimestampCheckbox)
    UI:setState(ui.chatTimestampCheckbox, exports.tunrc_Config:getProperty("chat.timestamp"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = chatTimestampX + 30,
        y        = chatSectionY,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_chat_timestamp"
    })

    -- Заголовок раздела графики
    y = y + 30
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20,
        y        = y,
        width    = width / 2,
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_settings_section_graphics"
    })
    -- Отражения
    y = y + 30
    local graphicsSectionY = y
    ui.reflectionsCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.reflectionsCheckbox)
    UI:setState(ui.reflectionsCheckbox, exports.tunrc_Config:getProperty("graphics.reflections_cars"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_reflections_cars"
    })

    -- Вода
    y = y + 30
    ui.waterCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.waterCheckbox)
    UI:setState(ui.waterCheckbox, exports.tunrc_Config:getProperty("graphics.reflections_water"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_reflections_water"
    })

    -- Фары
    y = y + 30
    ui.carLightsCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.carLightsCheckbox)
    UI:setState(ui.carLightsCheckbox, exports.tunrc_Config:getProperty("graphics.improved_car_lights"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_improved_car_lights"
    })

    -- Небо
    y = y + 30
    ui.improvedSkyCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.improvedSkyCheckbox)
    UI:setState(ui.improvedSkyCheckbox, exports.tunrc_Config:getProperty("graphics.improved_sky"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_improved_sky"
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
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_screen_blur"
    })
	
	 -- Отображение спидометра
    y = y + 30
    ui.speedoChechbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.speedoChechbox)
    UI:setState(ui.speedoChechbox, exports.tunrc_Config:getProperty("ui.draw_speedo"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_screen_draw_speedo"
    })
	
    -- Винилы на стёкла
    local x = width * 0.6
    ui.glassVynilsCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = graphicsSectionY + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.glassVynilsCheckbox)
    UI:setState(ui.glassVynilsCheckbox, exports.tunrc_Config:getProperty("graphics.enable_glass_vynils"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = graphicsSectionY,
        width    = width / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_enable_glass_vynils"
    })

    -- Снег
    graphicsSectionY = graphicsSectionY + 30
    ui.snowCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = graphicsSectionY + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.snowCheckbox)
    UI:setState(ui.snowCheckbox, exports.tunrc_Config:getProperty("graphics.flame"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = graphicsSectionY,
        width    = width / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_snow"
    })
	
	-- Отображение ников
    graphicsSectionY = graphicsSectionY + 30
    ui.nametagsCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = graphicsSectionY + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.nametagsCheckbox)
    UI:setState(ui.nametagsCheckbox, exports.tunrc_Config:getProperty("graphics.nametags"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = graphicsSectionY,
        width    = width / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_nametags"
    })
	-- Отображение своего ника
    graphicsSectionY = graphicsSectionY + 30
    ui.SelfnametagsCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = graphicsSectionY + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.SelfnametagsCheckbox)
    UI:setState(ui.SelfnametagsCheckbox, exports.tunrc_Config:getProperty("graphics.self_nametags"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = graphicsSectionY,
        width    = width / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_selfnametags"
    })
    -- Музыка
    graphicsSectionY = graphicsSectionY + 30
    ui.musicCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = graphicsSectionY + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.musicCheckbox)
    UI:setState(ui.musicCheckbox, exports.tunrc_Config:getProperty("game.background_music"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = graphicsSectionY,
        width    = width / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_background_music"
    })

    -- Подруливание
    graphicsSectionY = graphicsSectionY + 30
    ui.smoothSteering = UI:createDpCheckbox {
        x      = x,
        y      = graphicsSectionY + 4,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.smoothSteering)
    UI:setState(ui.smoothSteering, exports.tunrc_Config:getProperty("graphics.smooth_steering"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = graphicsSectionY,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_smooth_steering"
    })        

    -- Отступ снизу
    y = y + 60
    UI:setHeight(ui.panel, y)

    local passwordButtonWidth  = 180
    local passwordButtonHeight = 50
    ui.passwordChangeButton = UI:createDpButton {
        x      = x + 250,
        y      = height - 325,
        width  = width / 3,
        height = 50,
        locale = "main_panel_setting_change_password",
        type   = "primary"
    }
    UI:addChild(ui.panel, ui.passwordChangeButton)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function(widget)
    local playClickSound = false

    -- Переключение языка
    for i, languageButton in ipairs(languageButtonsList) do
        if languageButton.button and languageButton.button == widget then
            playClickSound = true
            exports.tunrc_Lang:setLanguage(languageButton.language)
        end
    end
    -- Переключение цвета
    for i, colorButton in ipairs(colorButtonsList) do
        if colorButton.button and colorButton.button == widget then
            playClickSound = true
            UI:setTheme(colorButton.name)
        end
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
	elseif widget == ui.bodyVynilsChechbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("ui.bodyVynils", UI:getState(widget))
    elseif widget == ui.improvedSkyCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.improved_sky", UI:getState(widget))
    elseif widget == ui.carLightsCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.improved_car_lights", UI:getState(widget))
    elseif widget == ui.waterCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.reflections_water", UI:getState(widget))
	elseif widget == ui.vynilCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.vynils_resolution", UI:getState(widget))
    elseif widget == ui.reflectionsCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.reflections_cars", UI:getState(widget))
    elseif widget == ui.glassVynilsCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.enable_glass_vynils", UI:getState(widget))
    elseif widget == ui.smoothSteering then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.smooth_steering", UI:getState(widget))        
    elseif widget == ui.snowCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.flame", UI:getState(widget))        
    elseif widget == ui.nametagsCheckbox then
        playClickSound = true
		exports.tunrc_Config:setProperty("graphics.nametags", UI:getState(widget))     
	elseif widget == ui.SelfnametagsCheckbox then
        playClickSound = true
		exports.tunrc_Config:setProperty("graphics.self_nametags", UI:getState(widget))  
    elseif widget == ui.musicCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("game.background_music", UI:getState(widget))
    elseif widget == ui.passwordChangeButton then
        Panel.setVisible(false)
        PasswordPanel.show()
        exports.tunrc_Sounds:playSound("ui_select.wav")
    end

    if playClickSound then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
end)
