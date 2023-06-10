Panel = {}
local screenWidth, screenHeight = UI:getScreenSize()
local width = 600
local height = 380
local panel
-- Табы
TABS_HEIGHT = 50
local tabsNames = {"account", "teleport", "settings", "garage"}
local tabsButtons = {}
local tabs = {}
local tabsHandlers = {}
local currentTab

function Panel.create()
    if panel then
        return false
    end
    panel = UI:createDpPanel {
        x       = (screenWidth - width) / 2,
        y       = (screenHeight - height) / 1.4,
        width   = width,
        height  = height,
        type    = "light"
    }
    UI:addChild(panel)

    if screenHeight >= 710 then
        local logoTexture = exports.tunrc_Assets:createTexture("logo.png")
        local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
        local logoWidth = 300
        local logoHeight = textureHeight * 300 / textureWidth
        local logoImage = UI:createImage({
            x       = (width - logoWidth) / 2,
            y       = -logoHeight - 25,
            width   = logoWidth,
            height  = logoHeight,
            texture = logoTexture
        })
        UI:addChild(panel, logoImage)
    end

    -- Табы
    local tabWidth = width / #tabsNames
    for i, name in ipairs(tabsNames) do
        tabsButtons[name] = UI:createDpButton {
            x = (i - 1) * tabWidth,
            y = 0,
            width = tabWidth,
            height = TABS_HEIGHT,
            type = "default_dark",
            fontType = "defaultSmall",
            locale = "main_panel_tab_" .. name
        }
        UI:addChild(panel, tabsButtons[name])
    end
end

function Panel.addTab(name)
    local tab = UI:createDpPanel {
        x          = 0,
        y          = TABS_HEIGHT,
        width      = width,
        height     = height - TABS_HEIGHT,
        type       = "transparent",
        scrollable = true
    }
    UI:addChild(panel, tab)
    UI:setVisible(tab, false)
    tabs[name] = tab
    return tab
end

function Panel.showTab(name)
    if not tabs[name] then
        if tabsHandlers[name] then
            tabsHandlers[name]()
        end
        return
    end
    if currentTab then
        UI:setVisible(tabs[currentTab], false)
        UI:setType(tabsButtons[currentTab], "default_dark")
    end
    currentTab = name
    UI:setVisible(tabs[currentTab], true)
    UI:setType(tabsButtons[currentTab], "primary")
    if tabsHandlers[name] then
        tabsHandlers[name]()
    end
end

function Panel.getCurrentTab()
    return currentTab
end

function Panel.setVisible(visible)
    visible = not not visible
    if UI:getVisible(panel) == visible or exports.tunrc_TabPanel:isVisible() then
        return
    end
    if not panel then
        return false
    end
    if visible then
        if not localPlayer:getData("username") or localPlayer:getData("tunrc_Core.state") then
            return false
        end
        if localPlayer:getData("activeUI") then
            return false
        end
        localPlayer:setData("activeUI", "mainPanel")
    else
        localPlayer:setData("activeUI", false)
    end
    UI:setVisible(panel, visible)
	exports.tunrc_HUD:setVisible(not visible)
	exports.tunrc_HUD:setSpeedometerVisible(exports.tunrc_Config:getProperty("ui.draw_speedo"))
    UIDataBinder.setActive(visible)
    showCursor(visible)
    exports.tunrc_UI:fadeScreen(visible)
    Panel.showTab("account")
end

function Panel.isVisible()
    return UI:getVisible(panel)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    for name, button in pairs(tabsButtons) do
        if widget == button then
            Panel.showTab(name)
            exports.tunrc_Sounds:playSound("ui_select.wav")
            return
        end
    end
end)

tabsHandlers.garage = function ()
    exports.tunrc_Garage:enterGarage()
    localPlayer:setData("tunrc_Core.state", "loading_garage", false)
    Panel.setVisible(false)
end

tabsHandlers.teleport = function ()
    TeleportTab.refresh()
end

tabsHandlers.account = function ()
    UIDataBinder.refresh()
    AccountTab.refresh()
end
