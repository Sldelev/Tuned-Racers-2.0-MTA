Sound = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 550
local panelHeight = 450

local isVisible = false
local ui = {}

function Sound.show()
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "SoundSettings")
end

function Sound.hide()
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
	
	-- Музыка в гараже
    y = 30
    ui.musicCheckbox = UI:createDpCheckbox {
        x      = 20,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.musicCheckbox)
    UI:setState(ui.musicCheckbox, exports.tunrc_Config:getProperty("game.background_music"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 50,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_background_music"
    })
	
	x = panelWidth / 1.7
	
	-- Музыка вне гаража
    ui.worldMusicCheckbox = UI:createDpCheckbox {
        x      = x,
        y      = y + 5,
        width  = 20,
        height = 20
    }
    UI:addChild(ui.panel, ui.worldMusicCheckbox)
    UI:setState(ui.worldMusicCheckbox, exports.tunrc_Config:getProperty("game.world_music"))

    UI:addChild(ui.panel, UI:createDpLabel {
        x        = x + 30,
        y        = y,
        width    = panelWidth / 3,
        height   = 30,
        text     = "",
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_background_world_music"
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
        Sound.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
        Panel.setVisible(true)
		Panel.showTab("settings")
    end
	
	if widget == ui.musicCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("game.background_music", UI:getState(widget))
	elseif widget == ui.worldMusicCheckbox then
        playClickSound = true
        exports.tunrc_Config:setProperty("game.world_music", UI:getState(widget))
	end

    if playClickSound then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
end)