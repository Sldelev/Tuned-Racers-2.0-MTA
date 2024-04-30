SellCarScreen = Screen:subclass "SellCarScreen"
local screenSize = Vector2(guiGetScreenSize())

function SellCarScreen:init(callback)
	self.super:init()
	self.fadeSpeed = 4
	self.canSell = true
	self.text = exports.tunrc_Lang:getString("garage_sell_text")
	self.x = screenSize.x / 2
	self.y = 75
	self.width = 400
	self.height = 100

	if GarageCar.getCarsCount() <= 1 then
		self.canSell = false
		self.text = exports.tunrc_Lang:getString("garage_sell_last_car")
	end

	local mileage = GarageCar.getMileage()

	self.price = getVehicleSellPrice(GarageCar.getName(), GarageCar.getMileage())
	self.colorHex = exports.tunrc_Utils:RGBToHex(exports.tunrc_UI:getThemeColor())
	
	self.helpPanel = HelpPanel({
		{ keys = {"Enter"}, 				locale = "garage_sell_confirm"},
		{ keys = {"Backspace"}, 				locale = "garage_menu_back"},
	})
end

function SellCarScreen:show()
	self.super:show()
end

function SellCarScreen:hide()
	self.super:hide()
end

function SellCarScreen:draw()
	self.super:draw()
	self.helpPanel:draw(self.fadeProgress)
	
	local text = ""
	dxDrawRoundedRectangle(
		self.x - self.width / 2,
		self.y - self.height / 2 + 25,
		self.width,
		self.height,
		15,
		255*self.fadeProgress,
		false,
		false,
		true,
		false
	)
	if self.canSell then
		text = self.text
		if localPlayer:getData("isPremium") then
			pricetext = "$" .. tostring(self.price / 1.25)
		else
			pricetext = "$" .. tostring(self.price)
		end
	else
		text = self.text
	end
	-- main text
	TrcDrawText(
		text,
		0,
		75,
		screenSize.x,
		self.y,
		255*self.fadeProgress,
		Assets.fonts.componentName
	)
	
	-- price text
	TrcDrawText(
		exports.tunrc_Lang:getString("garage_sell_price") .. pricetext,
		0,
		175,
		screenSize.x,
		self.y,
		255*self.fadeProgress,
		Assets.fonts.componentNameInfo
	)
end

function SellCarScreen:update(deltaTime)
	self.super:update(deltaTime)
end

function SellCarScreen:onKey(key)
	self.super:onKey(key)
	if key == "enter" then
		if not self.canSell then
			return
		end
		GarageCar.sell()
		self.screenManager:showScreen(MainScreen(3))
	elseif key == "backspace" then
		self.screenManager:showScreen(MainScreen(3))
	end
end
