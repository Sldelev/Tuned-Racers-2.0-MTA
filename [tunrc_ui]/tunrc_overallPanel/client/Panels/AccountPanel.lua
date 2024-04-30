AccountPanel = {}
local screenWidth, screenHeight = UI:getScreenSize()
local width = 300
local height = 250
local accountpanel

local isVisible = false

function AccountPanel.show()
    if isVisible and localPlayer:getData("activeUI") ~= "overallPanel" then
        return false
    end
	localPlayer:setData("activeUIAddition", "AccountPanel")
    isVisible = true
    UI:setVisible(accountpanel, true)
end

function AccountPanel.hide()
    if not isVisible then
        return false
    end
	localPlayer:setData("activeUIAddition", false)
    isVisible = false
    UI:setVisible(accountpanel, false)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	if accountpanel then
        return false
    end
	
	-- ОСНОВНАЯ ПАНЕЛЬ	
	accountpanel = UI:createTrcRoundedRectangle {
		x       = (screenWidth - width) * 0.2,
        y       = (screenHeight - height) / 2.5,
        width   = width,
        height  = height,
		radius = 20,
		color = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20),
		shadow = true
	}
	UI:addChild(accountpanel)
	UI:setVisible(accountpanel, false)
	
	passwordpanelButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(accountpanel) - 50,
        y       = 15,
        width   = 30,
        height  = 30,
		radius = 5,
		color = tocolor(205, 205, 205),
		hover = true,
		hoverColor = tocolor(215, 215, 215),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		circle = true
	}
	UI:addChild(accountpanel, passwordpanelButton)
	
	passwordpanelbuttonLabel = UI:createDpLabel {
		x = -100,
		y = 0,
		width = 0,
		height = 0,
		text = "Change password",
		locale = "overallpanel_password_change_title",
		color = tocolor (50, 50, 50),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "light",
		alignX = "center"
	}
	UI:addChild(passwordpanelButton, passwordpanelbuttonLabel)
	
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	local playSelect = false

    if widget == passwordpanelButton or widget == passwordpanelbuttonLabel then
		PasswordPanel.show()
		playSelect = true
	end
	
	if playSelect then
        exports.tunrc_Sounds:playSound("ui_select.wav")
    end
end)