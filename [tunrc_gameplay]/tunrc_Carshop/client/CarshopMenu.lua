CarshopMenu = {}
-- Новые переменные для перехода на UI
local UI = exports.tunrc_UI
local width = 400
local height = 100
local screenWidth, screenHeight = UI:getScreenSize()

function CarshopMenu.create()
	panel = UI:createTrcRoundedRectangle {
		x       = 50,
        y       = screenHeight - (screenHeight - 50),
        width   = width,
        height  = height,
		radius = 20,
		color = tocolor(0, 0, 0, 100)
		}
    UI:addChild(panel)
	UI:setVisible(panel, false)
	
	panelColor = UI:createTrcRoundedRectangle {
		x       = -2,
        y       = -4,
        width   = width,
        height  = height,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
		}
    UI:addChild(panel, panelColor)
	-- название автомобиля
	carNameLabel = UI:createDpLabel {
		x = 10,
		y = 5,
		width = 0,
		height = 0,
		text = "CarName",
		color = tocolor (50, 50, 50),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarger"
	}
	UI:addChild(panel, carNameLabel)
	UIDataBinder.bind(carNameLabel, "carNameLabe", function ()
		return tostring(Carshop.currentVehicleInfo.name)
	end)
	-- цена
	priceLabel = UI:createDpLabel {
		x = UI:getWidth(carNameLabel) + (width - 100) ,
		y = 5,
		width = 0,
		height = 0,
		text = "CarPrice",
		color = tocolor (50, 50, 50, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "defaultLarge"
	}
	UI:addChild(carNameLabel, priceLabel)
	UIDataBinder.bind(priceLabel, "priceLabe", function ()
		if not Carshop.currentVehicleInfo.price then
			return " "
		end
		if localPlayer:getData("isPremium") then
			return "$" .. tostring(Carshop.currentVehicleInfo.price / 1.25)
		else
			return "$" .. tostring(Carshop.currentVehicleInfo.price)
		end
	end)
	
	-- цена донат
	donatpriceLabel = UI:createDpLabel {
		x = 0,
		y = 30,
		width = 0,
		height = 0,
		text = "CarDonatPrice",
		color = tocolor (50, 50, 50, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "default"
	}
	UI:addChild(priceLabel, donatpriceLabel)
	UIDataBinder.bind(donatpriceLabel, "donatpriceLabe", function ()
		if not Carshop.currentVehicleInfo.donatprice then
			return " "
		end
		return "¤" .. tostring(Carshop.currentVehicleInfo.donatprice)
	end)
	
	buyButtonShadow = UI:createTrcRoundedRectangle {
		x       = 12,
        y       = height - 43,
        width   = width / 3,
        height  = height / 3,
		radius = 15,
		color = tocolor(50, 50, 132, 20),
		darkToggle = true,
		darkColor = tocolor(0, 0, 0, 20)
	}
	UI:addChild(panel, buyButtonShadow)
	
	-- кнопка покупки
	buyButton = UI:createTrcRoundedRectangle {
		x       = 10,
        y       = height - 45,
        width   = width / 3,
        height  = height / 3,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(panel, buyButton)
	
	-- Текст панели гаража
	buyButtonText = UI:createDpLabel {
		x = UI:getWidth(buyButton) / 2,
		y = UI:getHeight(buyButton) / 2,
		width = 0,
		height = 0,
		text = "Buy button",
		locale = "carshop_buy_button",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center",
		fontType = "light"
	}
	UI:addChild(buyButton, buyButtonText)	
	UIDataBinder.bind(buyButtonText, "carshop_buy_button", function ()
		if not Carshop.currentVehicleInfo.price then
			return " "
		end
		if Carshop.currentVehicleInfo.premium and not localPlayer:getData("isPremium") then
			return exports.tunrc_Lang:getString("carshop_need_premium")
		end
		if Carshop.currentVehicleInfo.price > localPlayer:getData("money") then
			return exports.tunrc_Lang:getString("carshop_no_money")
		end
		if Carshop.currentVehicleInfo.level > localPlayer:getData("level") then
			return string.format(exports.tunrc_Lang:getString("carshop_required_level"), tostring(Carshop.currentVehicleInfo.level))
		end
		return exports.tunrc_Lang:getString("carshop_buy_button")
	end)
	
	buyDonatButtonShadow = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(buyButtonShadow) + 25,
        y       = height - 43,
        width   = width / 3,
        height  = height / 3,
		radius = 15,
		color = tocolor(50, 50, 132, 20),
		darkToggle = true,
		darkColor = tocolor(0, 0, 0, 20)
	}
	UI:addChild(panel, buyDonatButtonShadow)
	
	-- кнопка покупки
	buyDonatButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(buyButton) + 25,
        y       = height - 45,
        width   = width / 3,
        height  = height / 3,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(panel, buyDonatButton)
	
	-- Текст панели гаража
	buyDonatButtonText = UI:createDpLabel {
		x = UI:getWidth(buyDonatButton) / 2,
		y = UI:getHeight(buyDonatButton) / 2,
		width = 0,
		height = 0,
		text = "Buy Donat button",
		locale = "carshop_buy_donat_button",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center",
		fontType = "light"
	}
	UI:addChild(buyDonatButton, buyDonatButtonText)	
	UIDataBinder.bind(buyDonatButtonText, "carshopdonat", function ()
		if not Carshop.currentVehicleInfo.donatprice then
			return " "
		end
		if Carshop.currentVehicleInfo.premium and not localPlayer:getData("isPremium") then
			return exports.tunrc_Lang:getString("carshop_need_premium")
		end
		if Carshop.currentVehicleInfo.donatprice > localPlayer:getData("donatmoney") then
			return exports.tunrc_Lang:getString("carshop_no_donat_money")
		end
		if Carshop.currentVehicleInfo.level > localPlayer:getData("level") then
			return string.format(exports.tunrc_Lang:getString("carshop_required_level"), tostring(Carshop.currentVehicleInfo.level))
		end
		return exports.tunrc_Lang:getString("carshop_buy_button_donat")
	end)
	
end
addEventHandler( "onClientResourceStart", getRootElement( ), CarshopMenu.create)

function CarshopMenu.start(basePosition)	
	UI:setVisible(panel, true)
	showCursor ( true )
	UIDataBinder.refresh()
end

function CarshopMenu.stop()
	showCursor ( false )
	UI:setVisible(panel, false)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == buyButton then
		Carshop.buy()
	end
	if widget == buyDonatButton then
		Carshop.donatbuy()
	end
end)