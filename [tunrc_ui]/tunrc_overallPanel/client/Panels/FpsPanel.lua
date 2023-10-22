FpsPanel = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 300
local panelHeight = 200

local isVisible = false
local ui = {}

function FpsPanel.show()
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "FpsChange")
end

function FpsPanel.hide()
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

    -- Высота кнопок
    local buttonsHeight = 50
    -- Кнопка отмены
    ui.cancelButton = UI:createDpButton({
        x      = 0,
        y      = panelHeight - buttonsHeight,
        width  = panelWidth / 2,
        height = buttonsHeight,
        locale = "main_panel_new_password_cancel",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.cancelButton)

    -- Кнопка "принять"
    ui.acceptButton = UI:createDpButton({
        x      = panelWidth / 2,
        y      = panelHeight - buttonsHeight,
        width  = panelWidth / 2,
        height = buttonsHeight,
        locale = "main_panel_new_fps_accept",
        type   = "primary"
    })
    UI:addChild(ui.panel, ui.acceptButton)

    -- Ввод нового пароля
    local y = 10
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 0, 
        y        = y,
        width    = panelWidth, 
        height   = 30,
        fontType = "defaultSmall",
        type     = "dark",
        alignX   = "center",
        locale   = "main_panel_fps_change_title"
    })
    y = y + 40
    UI:addChild(ui.panel, UI:createDpLabel {
        x        = 20, 
        y        = y,
        width    = panelWidth, 
        height   = 30,
        color    = tocolor(0, 0, 0, 100),
        fontType = "defaultSmall",
        locale   = "main_panel_fps_label"
    })
    y = y + 30
    ui.newFpsInput = UI:createDpInput({
        x      = 10,
        y      = y,
        width  = panelWidth - 20,
        height = 50,
        type   = "light",
        masked = false,
        locale = "main_panel_fps_placeholder"
    })
    UI:addChild(ui.panel, ui.newFpsInput)  
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == ui.acceptButton then
        local newFps = UI:getText(ui.newFpsInput)
		setFPSLimit(newFps)		
        FpsPanel.hide()
        exports.tunrc_Sounds:playSound("ui_select.wav")
        Panel.setVisible(true)
    elseif widget == ui.cancelButton then
        FpsPanel.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
        Panel.setVisible(true)
    end
end)