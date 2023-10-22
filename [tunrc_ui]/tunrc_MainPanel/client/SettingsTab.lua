SettingsTab = {}
local ui = {}

local colorButtonsList = {
    { name = "red" },
    { name = "purple" },
    { name = "blue" },
	{ name = "green" },
	{ name = "orange" },
	{ name = "light_pink" },
	{ name = "light_brown" },
	{ name = "black" },
}

function SettingsTab.create()
    ui.panel = Panel.addTab("settings")

    local width = UI:getWidth(ui.panel)
    local height = UI:getHeight(ui.panel)
	-- Кнопка настроек интерфейса
	y = 30
	ui.interfaceButton = UI:createDpButton({
        x      = 20,
        y      = y + 5,
        width  = width / 4,
        height = 50,
        locale = "main_panel_settings_inteface_button",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.interfaceButton)
	
	-- Кнопка настроек геймплея
	y = y
	ui.gameplayButton = UI:createDpButton({
        x      = 220,
        y      = y + 5,
        width  = width / 4,
        height = 50,
        locale = "main_panel_settings_gameplay_button",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.gameplayButton)
	
	-- Кнопка настроек графики
	y = y
	ui.graphicsButton = UI:createDpButton({
        x      = 430,
        y      = y + 5,
        width  = width / 4,
        height = 50,
        locale = "main_panel_settings_graphics_button",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.graphicsButton)
	
	-- Кнопка настроек Звуков
	y = y + 60
	ui.soundButton = UI:createDpButton({
        x      = 20,
        y      = y + 5,
        width  = width / 4,
        height = 50,
        locale = "main_panel_settings_sound_button",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.soundButton)
	
    local colorButtonsX = width * 0.65
	GameSelectionY = UI:getHeight(ui.panel)
    -- Подпись к кнопкам выбора цвета
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = colorButtonsX,
        y        = GameSelectionY - 50,
        width    = width / 3,
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        locale   = "main_panel_settings_color"
    })
    local colorButtonX = colorButtonsX
    local circleTexture = exports.tunrc_Assets:createTexture("buttons/circle.png", "argb", false, "clamp")
    -- Кнопки выбора цвета
    for i, colorButton in ipairs(colorButtonsList) do
        local button = UI:createDpImageButton({
            x       = colorButtonX,
            y       = GameSelectionY - 25,
            width   = 20,
            height  = 20,
            color   = tocolor(exports.tunrc_UI:getThemeColor(colorButton.name)),
            texture = circleTexture
        })
        UI:addChild(ui.panel, button)
        colorButton.button = button
        colorButtonX = colorButtonX + 25
    end 

    local x = width * 0.6
	
	-- Кнопка смены пароля
    y = y + 60
    UI:setHeight(ui.panel, y)
    ui.passwordChangeButton = UI:createDpButton {
        x      = x + 250,
        y      = height - 325,
        width  = width / 3,
        height = 50,
        locale = "main_panel_setting_change_password",
        type   = "primary"
    }
    UI:addChild(ui.panel, ui.passwordChangeButton)
	-- Кнопка смены лимита фпс
    ui.fpsChangeButton = UI:createDpButton {
        x      = x + 250,
        y      = height - 275,
        width  = width / 3,
        height = 50,
        locale = "main_panel_setting_change_fps",
        type   = "primary"
    }
    UI:addChild(ui.panel, ui.fpsChangeButton)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function(widget)
    local playClickSound = false
    -- Переключение цвета
    for i, colorButton in ipairs(colorButtonsList) do
        if colorButton.button and colorButton.button == widget then
            playClickSound = true
            UI:setTheme(colorButton.name)
        end
    end
  
    if widget == ui.passwordChangeButton then
        Panel.setVisible(false)
        PasswordPanel.show()
        exports.tunrc_Sounds:playSound("ui_select.wav")
	elseif widget == ui.fpsChangeButton then
        Panel.setVisible(false)
        FpsPanel.show()
        exports.tunrc_Sounds:playSound("ui_select.wav")
	elseif widget == ui.interfaceButton then
        Panel.setVisible(false)
        Interface.show()
        exports.tunrc_Sounds:playSound("ui_select.wav")
	elseif widget == ui.gameplayButton then
        Panel.setVisible(false)
        Gameplay.show()
        exports.tunrc_Sounds:playSound("ui_select.wav")
	elseif widget == ui.graphicsButton then
        Panel.setVisible(false)
        Graphics.show()
        exports.tunrc_Sounds:playSound("ui_select.wav")
	elseif widget == ui.soundButton then
        Panel.setVisible(false)
        Sound.show()
        exports.tunrc_Sounds:playSound("ui_select.wav")
    end

    if playClickSound then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
end)
