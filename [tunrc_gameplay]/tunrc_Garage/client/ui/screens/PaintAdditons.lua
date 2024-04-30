PaintAdditons = Screen:subclass "PaintAdditons"

local menuInfos = {}
menuInfos["ChromePower"] = {
	position = Vector3(1, -2, -0.5),
	angle = -15,
	header="garage_tuning_paint_chrome_power",
	label="garage_tuning_paint_chrome_power"
	}
	
menuInfos["WheelsChromeF"] = {
	position = Vector3(1, -2, -0.5),
	angle = -15,
	header="garage_tuning_paint_wheels_chrome_power",
	label="garage_tuning_paint_wheels_chrome_power"
	}
	
menuInfos["WheelsChromeR"] = {
	position = Vector3(1, -2, -0.5),
	angle = -15,
	header="garage_tuning_paint_wheels_chrome_power",
	label="garage_tuning_paint_wheels_chrome_power"
	}

function PaintAdditons:init(dataName)
	self.super:init()
	local menuInfo = menuInfos[dataName]
	if menuInfo.bars then
		self.menu = PaintAddMenu(
			exports.tunrc_Lang:getString(menuInfo.header),
			GarageCar.getVehiclePos() + menuInfo.position,
			menuInfo.angle,
			menuInfo.bars
		)
	else
		self.menu = PaintAddMenu(
			exports.tunrc_Lang:getString(menuInfo.header),
			GarageCar.getVehiclePos() + menuInfo.position,
			menuInfo.angle,
			{
				{
					label = menuInfo.label
				}
			}
		)
	end
	self.dataName = dataName
	if self.dataName == "ChromePower" then
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 1
	end
	if self.dataName == "WheelsChromeF" or self.dataName == "WheelsChromeR" then
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 2
	end
	-- Дата
	local price = unpack(exports.tunrc_Shared:getTuningPrices("body_color"))
	self.menu.price = price
	self.configurationIndex = configurationIndex
	self.menu:setValue(GarageCar.getVehicle():getData(dataName))
end

function PaintAdditons:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function PaintAdditons:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)
	if self.dataName then
		if getKeyState("arrow_r") then
			self.menu:increase(deltaTime)
		elseif getKeyState("arrow_l") then
			self.menu:decrease(deltaTime)
		end
	end
	if self.dataName == "ChromePower" then
		CarTexture.previewChromePower(self.menu:getValue())
	else
		GarageCar.previewTuning(self.dataName, self.menu:getValue())
	end
end

function PaintAdditons:onKey(key)
	self.super:onKey(key)
	
	if key == "backspace" then
		GarageCar.resetTuning()
		if self.dataName == "WheelsChromeF" then
			self.screenManager:showScreen(WheelFColorsSelector(self.dataName))
		elseif self.dataName == "WheelsChromeR" then
			self.screenManager:showScreen(WheelRColorsSelector(self.dataName))
		else
			self.screenManager:showScreen(ColorsScreen(self.dataName))
		end
		self.dataName = nil
	elseif key == "enter" then	
		local name = "body_color"

		local this = self
		local price, level = unpack(exports.tunrc_Shared:getTuningPrices("body_color"))
		Garage.buy(price, level, function(success)
			if success then
				GarageCar.applyTuning(this.dataName, self.menu:getValue())		
				GarageCar.save()
			else
				GarageCar.resetTuning()
				self.dataName = nil
			end
			
			if self.dataName == "WheelsChromeF" then
				self.screenManager:showScreen(WheelFColorsSelector(self.dataName))
			elseif self.dataName == "WheelsChromeR" then
				self.screenManager:showScreen(WheelRColorsSelector(self.dataName))
			else
				self.screenManager:showScreen(ColorsScreen(self.dataName))
			end
		end)
	elseif key == "arrow_u" then
		self.menu:selectPreviousBar()
	elseif key == "arrow_d" then
		self.menu:selectNextBar()
	end
end