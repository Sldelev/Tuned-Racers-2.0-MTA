HelpPanel = {}
local UI = exports.tunrc_UI
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 800
local panelHeight = 500

local ui = {}

local textvalue = 0
local list
local offset = 1
local showCount = 6

local HelpButtons = {
    { "help_panel_main",  "tutorial_panel_text_one" },
    { "help_panel_money",  "tutorial_panel_text_two" },
    { "help_panel_carshop",  "tutorial_panel_text_three" },
    { "help_panel_commands",  "tutorial_panel_text_four" },
    { "help_panel_car_sell",  "tutorial_panel_text_five" },
    { "help_panel_car_control",  "tutorial_panel_text_six" },	
}

function HelpPanel.create()
	ui.panel = UI:createTrcRoundedRectangle {
		x       = (screenWidth  - panelWidth)  / 2,
        y       = (screenHeight - panelHeight) / 2,
        width   = panelWidth,
        height  = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
    UI:addChild(ui.panel)
	UI:setVisible(ui.panel, false)
	
	ui.sidePanel = UI:createTrcRoundedRectangle {
		x       = 10,
        y       = 10,
        width   = 200,
        height  = panelHeight - 20,
		radius = 20,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40)
	}
    UI:addChild(ui.panel, ui.sidePanel)

	y = 60
	ui.mainLabel = UI:createDpLabel{
		x = UI:getWidth(ui.panel) / 1.62,
		y = 10,
		width = 0,
		height = 0,
		text = "Main",
		fontType = "defaultLarge",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center"
	}
	UI:addChild(ui.panel, ui.mainLabel)
	
	ui.textOneLabel = UI:createDpLabel{
		x = UI:getWidth(ui.sidePanel) + 25,
		y = y,
		width = panelWidth - 250,
		height = 50,
		locale = "tutorial_panel_text_one",
		fontType = "defaultSmall",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		wordBreak = true
	}
	UI:addChild(ui.panel, ui.textOneLabel)
	
	ui.helpButtonsList = UI:createDpList {
        x      = 0, 
        y      = 20,
        width  = 200, 
        height = 45 * 7,
		color = tocolor(235,235,235),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40),
		hoverDarkColor = tocolor(20,20,20),
        items  = HelpButtons,
		localeEnable = true,
        columns = {
            { size = 1, offset = 0, align = "center"  },
        }
    }
    UI:addChild(ui.sidePanel, ui.helpButtonsList)
	
	-- Кнопка отмены
    ui.cancelButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(ui.panel) - 30,
        y       = 15,
        width   = 15,
        height  = 15,
		radius = 6,
		color = tocolor(225, 0, 0),
		hover = true,
		hoverColor = tocolor(205, 0, 0)
	}
    UI:addChild(ui.panel, ui.cancelButton)
	
end
addEventHandler("onClientResourceStart", resourceRoot, HelpPanel.create)

function setVisible(visible)
	local isVisible = UI:getVisible(ui.panel)
	if not not isVisible == not not visible then
		return false
	end 
	if visible then
		if localPlayer:getData("activeUI") then
			return false
		end
		localPlayer:setData("activeUI", "TutorialPanel")
	else
		localPlayer:setData("activeUI", false)
	end

	UI:setVisible(ui.panel, visible)
	showCursor(visible)

	exports.tunrc_HUD:setVisible(not visible)
	exports.tunrc_UI:fadeScreen(visible)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	local playBack = false
	local playSelect = false

    if widget == ui.cancelButton then
		setVisible(false)
		exports.tunrc_overallPanel:setVisible(true)
		playBack = true
	end
	if widget == ui.helpButtonsList then
		local items = exports.tunrc_UI:getItems(ui.helpButtonsList)
		local selectedItem = exports.tunrc_UI:getActiveItem(ui.helpButtonsList)
		for i, button in ipairs(HelpButtons) do
			if items[selectedItem][1] == button[1] then
				UI:setText(ui.textOneLabel, exports.tunrc_Lang:getString(button[2]))
				UI:setText(ui.mainLabel, exports.tunrc_Lang:getString(button[1]))
			end
		end
		playSelect = true
	end
	UIDataBinder.refresh()
	
	if playBack then
        exports.tunrc_Sounds:playSound("ui_back.wav")
    end
	
	if playSelect then
        exports.tunrc_Sounds:playSound("ui_select.wav")
    end
end)