Gameplay = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 550
local panelHeight = 450

local isVisible = false
local ui = {}

function Gameplay.show()
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "GameplaySettings")
end

function Gameplay.hide()
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
	
	-- Коллизия
    y = 30
    ui.collisionCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.collisionCheckbox)
    UI:setState(ui.collisionCheckbox, exports.tunrc_Config:getProperty("game.coll"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_collision"
    })
	
	-- Альтернативная модель гаража
    y = y + 30
    ui.altGarageCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.altGarageCheckbox)
    UI:setState(ui.altGarageCheckbox, exports.tunrc_Config:getProperty("game.alt_garage"))
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_alt_garage"
    })
	
	x = panelWidth / 1.7
	-- Подруливание
    ui.smoothSteering = UI:createDpCheckbox {
		x      = x,
        y      = 35,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.smoothSteering)
    UI:setState(ui.smoothSteering, exports.tunrc_Config:getProperty("graphics.smooth_steering"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = 35 - 5,
        width    = panelWidth / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_smooth_steering"
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
        Gameplay.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
        Panel.setVisible(true)
		Panel.showTab("settings")
    end
	
	if widget == ui.collisionCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("game.coll", UI:getState(widget))
	elseif widget == ui.altGarageCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("game.alt_garage", UI:getState(widget))
	elseif widget == ui.smoothSteering then
        playClickSound = true
        exports.tunrc_Config:setProperty("graphics.smooth_steering", UI:getState(widget))
	end

    if playClickSound then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
end)