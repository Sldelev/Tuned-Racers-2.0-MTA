Panel = {}
local screenWidth, screenHeight = UI:getScreenSize()
local width = 600
local height = 380
local panel
-- Табы
TABS_HEIGHT = 50
local tabsNames = {"account","achievements", "teleport", "settings", "garage"}
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

	-- никнейм
	local usernameLabel = UI:createDpLabel {
		x = 0,
		y = -60,
		width = width / 3, height = 50,
		text = "---",
		type = "primary",
		fontType = "defaultLarger"
	}
	UI:addChild(panel, usernameLabel)
	UIDataBinder.bind(usernameLabel, "username", function (value)
		return string.upper(tostring(value))
	end)
	-- группа игрока
	local usernameLabelText = UI:createDpLabel {
		x = 0 , y = -25,
		width = width / 3, height = 50,
		text = "Admin",
		color = tocolor(205, 205, 205, 255),
		fontType = "defaultSmall",
		locale = "main_panel_account_player"
	}
	UI:addChild(panel, usernameLabelText)
	UIDataBinder.bind(usernameLabelText, "group", function (value)
		if not value then
			return exports.tunrc_Lang:getString("groups_player")
		else
			return exports.tunrc_Lang:getString("groups_" .. tostring(value))
		end
	end)
	-- деньги
	local moneyLabel = UI:createDpLabel {
	x = width - width / 3 ,
	y = -60,
	width = width / 3, height = 50,
	text = "$0",
	type = "primary",
	fontType = "defaultLarger",
	alignX = "right"
	}
	UI:addChild(panel, moneyLabel)
	UIDataBinder.bind(moneyLabel, "money", function (value)
	 return "$" .. tostring(value)
	 end)
	 
	 -- Подпись
	local moneyLabelText = UI:createDpLabel {
	 	x = width - width / 3 ,
		y = -25,
	 	width = width / 3, height = 50,
		text = "Money",
	 	color = tocolor(205, 205, 205, 255),
	 	fontType = "defaultSmall",
	 	alignX = "right",
	 	locale = "main_panel_account_money"
	 }
	 UI:addChild(panel, moneyLabelText)

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
        type       = "light",
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

tabsHandlers.achievements = function ()
    UIDataBinder.refresh()
    AchievementsTab.refresh()
end

tabsHandlers.account = function ()
    UIDataBinder.refresh()
    AccountTab.refresh()
end
