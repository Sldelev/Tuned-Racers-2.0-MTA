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
		color = tocolor(0, 0, 0, 20)
	}
	UI:addChild(accountpanel)
	UI:setVisible(accountpanel, false)
	
	accountpanelColor = UI:createTrcRoundedRectangle {
		x       = -5,
        y       = -5,
        width   = width,
        height  = height,
		radius = 20,
		color = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(accountpanel, accountpanelColor)
	
	passwordpanelButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(accountpanel) - 50,
        y       = 15,
        width   = 30,
        height  = 30,
		radius = 5,
		color = tocolor(210, 210, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(accountpanelColor, passwordpanelButton)
	
	passwordpanelbuttonLabel = UI:createDpLabel {
		x = 140,
		y = 10,
		width = 0,
		height = 0,
		text = "Change password",
		color = tocolor (50, 50, 50),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "light",
		alignX = "center"
	}
	UI:addChild(accountpanel, passwordpanelbuttonLabel)
	
	Circle = UI:createCircle {
		x       = 15,
        y       = 15,
		radius = 2
	}
	UI:addChild(passwordpanelButton, Circle)
	
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == passwordpanelButton or widget == passwordpanelbuttonLabel then
		PasswordPanel.show()
	end
end)