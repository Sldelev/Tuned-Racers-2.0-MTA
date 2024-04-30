MainScreen = Screen:subclass "MainScreen"
local screenSize = Vector2(guiGetScreenSize())

function MainScreen:init(item)
	self.super:init()
	self.mainMenu = ItemsMenu(
		{
			"garage_menu_go_city",
			"garage_menu_customize",
			"garage_menu_sell",
			"garage_menu_carshop"
		},
		GarageCar.getVehiclePos() + Vector3(0, -2, 0.3),
		0
	)

	local position = GarageCar.getVehicle().matrix:transformPosition(-0.2, 3.5, 0)
	position.z = 2534.8
	
	CameraManager.setState("startingCamera", false, 2)

	if type(item) == "number" then
		self.mainMenu.selectedItem = item
	end
end

function MainScreen:hide()
	self.super:hide()
	self.mainMenu:destroy()
end

function MainScreen:draw()
	self.super:draw()
	self.mainMenu:draw(self.fadeProgress)
end

function MainScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.mainMenu:update(deltaTime)
end

function MainScreen:onKey(key)
	self.super:onKey(key)
	self.mainMenu:onKey(key)
	if key == "enter" then
		if self.mainMenu:getItem() == "garage_menu_go_city" then
			exitGarage(GarageCar.getId())
		elseif self.mainMenu:getItem() == "garage_menu_sell" then
			self.screenManager:showScreen(SellCarScreen())
		elseif self.mainMenu:getItem() == "garage_menu_customize" then
			self.screenManager:showScreen(TuningScreen(true))
		elseif self.mainMenu:getItem() == "garage_menu_carshop" then
			enterExitGarage(false, false)
			exports.tunrc_carshop:enterCarshop()
		end
	elseif key == "backspace" then
		self.screenManager:hideScreen()
		exitGarage(GarageCar.getId())
	elseif key == "arrow_l" then
		GarageCar.showPreviousCar()
	elseif key == "arrow_r" then
		GarageCar.showNextCar()
	end
end
