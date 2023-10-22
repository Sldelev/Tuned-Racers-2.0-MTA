Panel = {}
local screenWidth, screenHeight = UI:getScreenSize()
local width = 600
local height = 380
local panel
-- Табы
TABS_HEIGHT = 50
local tabsNames = {"teleport", "achievements", "settings", "garage"}
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
	 
	 -- Подпись валюты
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
	 
	 -- донат-валюта
	local moneyLabel = UI:createDpLabel {
	x = width - width / 3 ,
	y = -120,
	width = width / 3, height = 50,
	text = "$0",
	type = "primary",
	fontType = "defaultLarger",
	alignX = "right"
	}
	UI:addChild(panel, moneyLabel)
	UIDataBinder.bind(moneyLabel, "donatmoney", function (value)
	 return "¤" .. tostring(value)
	 end)
	 
	 -- Подпись донат-валюты
	local donatMoneyLabelText = UI:createDpLabel {
	 	x = width - width / 3 ,
		y = -85,
	 	width = width / 3, height = 50,
		text = "DonatMoney",
	 	color = tocolor(205, 205, 205, 255),
	 	fontType = "defaultSmall",
	 	alignX = "right",
	 	locale = "main_panel_account_donatmoney"
	 }
	 UI:addChild(panel, donatMoneyLabelText)
	 
	 -- текст "уровень"
	local levelLabel = UI:createDpLabel {
		x = 0, y = -85,
		width = width / 3, height = 50,
		text = "Уровень",
		color = tocolor(205, 205, 205, 255),
		fontType = "defaultSmall",
		alignX = "left",
		locale = "main_panel_account_level"
	}
	UI:addChild(panel, levelLabel)
	 -- фон прогресса
	local levelProgressBg = UI:createRectangle {
		x = (-UI:getWidth(levelLabel) - 10), y = -75,
		width = (UI:getWidth(levelLabel)),
		height = 10,
		color = tocolor(205, 205, 205),
	}
	UI:addChild(panel, levelProgressBg)
	-- полоска прогресса уровня
	local levelProgress = UI:createRectangle {
		x = 0, y = 0,
		width = (width/2) * 0.65,
		height = 10,
		color = tocolor(40, 40, 40),
	}
	UI:addChild(levelProgressBg, levelProgress)	
	-- нынешний уровень игрока
	local levelLabelCurrent = UI:createDpLabel {
		x = 0, y = -120,
		width = width / 3, height = 50,
		text = "1",
		type = "primary",
		fontType = "defaultLarger",
		alignX = "left",
		alignY = "center"
	}
	UI:addChild(panel, levelLabelCurrent)
	UIDataBinder.bind(levelLabelCurrent, "level", function (value)
	 return "☆" .. tostring(value)
	end)
	-- значения опыта игрока
	local xpLabel = UI:createDpLabel {
		x = (UI:getWidth(levelProgressBg) - 50) / 2, y = -15,
		width = 50, height = 10,
		text = "0/0",
		type = "primary",
		fontType = "defaultSmall",
		alignX = "center",
		alignY = "center"
	}
	UI:addChild(levelProgressBg, xpLabel)
	
	-----------------Кнопки сбоку------------------------
	-- Sell car button
	local x = -width * 0.6
	local sellVehicleButton = UI:createDpButton {
		x      = x + 150,
        y      = height - 325,
        width  = width / 3,
		height = 50,
		type = "primary",
		locale = "main_panel_account_sell_vehicle"
	}
	UI:addChild(panel, sellVehicleButton)
	-- Кнопка донат
	local donateButton = UI:createDpButton {
		x      = x + 150,
        y      = height - 275,
        width  = width / 3,
		height = 50,
		locale = "main_panel_account_donat",
		type = "primary"
	}
	UI:addChild(panel, donateButton)
	-- Кнопка помощь
	local helpButton = UI:createDpButton {
		x      = x + 150,
        y      = height - 225,
        width  = width / 3,
		height = 50,
		locale = "main_panel_account_help",
		type = "primary"
	}
	UI:addChild(panel, helpButton)


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
	
	ui = {
		levelProgressBg = levelProgressBg,
		levelProgress = levelProgress,

		levelLabelCurrent = levelLabelCurrent,
		levelLabel = levelLabel,
		xpLabel = xpLabel,
		
		donateButton = donateButton,
		helpButton = helpButton,
		sellVehicleButton = sellVehicleButton
	}
end

function Panel.refresh()
	local level = localPlayer:getData("level")
	if not level then
		return
	end
	local xp = localPlayer:getData("xp")
	if not xp then
		return
	end

	local maxLevel = exports.tunrc_Core:getMaxLevel()
	local xp1 = exports.tunrc_Core:getXPFromLevel(level)
	local xp2 = exports.tunrc_Core:getXPFromLevel(level + 1)
	local nextLevelXp = xp2 - xp1
	local currentXp = xp - xp1

	local progress = currentXp / nextLevelXp
	if level >= maxLevel then
		progress = 1
	end
	local width = UI:getWidth(ui.levelProgressBg)
	UI:setWidth(ui.levelProgress, width * progress)

	if level >= maxLevel then
		UI:setVisible(ui.xpLabel, false)
	else
		UI:setText(ui.xpLabel, ("%s/%s XP"):format(exports.tunrc_Utils:format_num(currentXp, 0), exports.tunrc_Utils:format_num(nextLevelXp, 0)))
		UI:setVisible(ui.xpLabel, true)
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
	Panel.refresh()
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
	
	if widget == ui.sellVehicleButton then
        Panel.setVisible(false)
        if localPlayer.vehicle and localPlayer.vehicle:getData("owner_id") == localPlayer:getData("_id")
            and localPlayer:getData("garage_cars_count") > 1 then
            exports.tunrc_SellVehicle:start()
        end
	elseif widget == ui.donateButton then
		Panel.setVisible(false)
		exports.tunrc_GiftsPanel:setVisible(true)
	elseif widget == ui.helpButton then
		Panel.setVisible(false)
		exports.tunrc_HelpPanel:setVisible(not isVisible())	
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
