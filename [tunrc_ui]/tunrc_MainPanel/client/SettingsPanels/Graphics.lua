Graphics = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 550
local panelHeight = 450

local isVisible = false
local ui = {}

function Graphics.show()
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "GraphicsSettings")
end

function Graphics.hide()
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
	
	-- Отражения
    y = 30
    local graphicsSectionY = y
    ui.reflectionsCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.reflectionsCheckbox)
    UI:setState(ui.reflectionsCheckbox, exports.tunrc_Config:getProperty("graphics.reflections_cars"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_reflections_cars"
    })

    -- Вода
    y = y + 30
    ui.waterCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.waterCheckbox)
    UI:setState(ui.waterCheckbox, exports.tunrc_Config:getProperty("graphics.reflections_water"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_reflections_water"
    })

    -- Фары
    y = y + 30
    ui.carLightsCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.carLightsCheckbox)
    UI:setState(ui.carLightsCheckbox, exports.tunrc_Config:getProperty("graphics.improved_car_lights"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_improved_car_lights"
    })

    -- Небо
    y = y + 30
    ui.improvedSkyCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.improvedSkyCheckbox)
    UI:setState(ui.improvedSkyCheckbox, exports.tunrc_Config:getProperty("graphics.improved_sky"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_improved_sky"
    })
	-- Лужи на асфальте
	y = y + 30
    ui.wetRoadCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.wetRoadCheckbox)
    UI:setState(ui.wetRoadCheckbox, exports.tunrc_Config:getProperty("graphics.wetroad"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_wetroad"
    })
	
	x = panelWidth / 1.7		
	-- Улучшенные отстрелы
    ui.snowCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = 35,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.snowCheckbox)
    UI:setState(ui.snowCheckbox, exports.tunrc_Config:getProperty("graphics.flame"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = 30,
        width    = panelWidth / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_snow"
    })
	
	-- дым от шин
    ui.smokeCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = 65,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.smokeCheckbox)
    UI:setState(ui.smokeCheckbox, exports.tunrc_Config:getProperty("graphics.tyres_smoke"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = 60,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_tyres_smoke"
    })
	
	-- SSAO
    ui.ssaoCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = 95,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.ssaoCheckbox)
    UI:setState(ui.ssaoCheckbox, exports.tunrc_Config:getProperty("graphics.ssao"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = 90,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_ssao"
    })
	
	-- FXAA
    ui.fxaaCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = 125,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.fxaaCheckbox)
    UI:setState(ui.fxaaCheckbox, exports.tunrc_Config:getProperty("graphics.fxaa"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = 120,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_fxaa"
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
        Graphics.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
        Panel.setVisible(true)
		Panel.showTab("settings")
    end
	
	if widget == ui.improvedSkyCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.improved_sky", UI:getState(widget))
	elseif widget == ui.wetRoadCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.wetroad", UI:getState(widget))
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
	elseif widget == ui.smokeCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.tyres_smoke", UI:getState(widget))        
    elseif widget == ui.snowCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.flame", UI:getState(widget))
	elseif widget == ui.ssaoCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.ssao", UI:getState(widget))  
	elseif widget == ui.fxaaCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.fxaa", UI:getState(widget)) 
	end

    if playClickSound then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
end)