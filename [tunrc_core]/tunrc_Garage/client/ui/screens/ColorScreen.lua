ColorScreen = Screen:subclass "ColorScreen"

local priceSources = {
	BodyColor = "body_color",
	WheelsColorF = "wheels_color",
	WheelsColorR = "wheels_color",
	SmokeColor = "body_color",
	SpoilerColor = "spoiler_color"
}

local colorMenus = {
		["BodyColor"]    = {locale="garage_tuning_paint_body",    position = Vector3(-1, -2, 0.4),   angle = 10},
	["WheelsColorF"]  = {locale="garage_tuning_paint_wheels",  position = Vector3(-0.5, -2, 0.4), angle = 15},
	["WheelsColorR"]  = {locale="garage_tuning_paint_wheels",  position = Vector3(-1, -2, 0.4), angle = 15},
	["SpoilerColor"] = {locale="garage_tuning_paint_spoiler", position = Vector3(-1, -2, 0.4),   angle = 185},
	["SmokeColor"]    = {locale="garage_tuning_smoke_color",    position = Vector3(-1, -2, 0.4),   angle = 10},

}

function ColorScreen:init(componentName)
	self.super:init()
	self.componentName = componentName
	local menuInfo = colorMenus[componentName]
	self.colorMenu = ColorMenu(exports.tunrc_Lang:getString(menuInfo.locale), GarageCar.getVehiclePos() + menuInfo.position, menuInfo.angle)
	local color = GarageCar.getVehicle():getData(componentName)
	if color then
		self.colorMenu:setColor(unpack(color))
	end

	-- Price
	local priceInfo = {0, 1}
	if priceSources[componentName] then
		priceInfo = exports.tunrc_Shared:getTuningPrices(priceSources[componentName])
	end
	self.colorMenu.price = priceInfo[1]
	self.requiredLevel = priceInfo[2]

	self.colorPreviewEnabled = true

	CameraManager.setState("selecting" .. componentName, false, 3)

	self.copyToAllWheels = false
end

function ColorScreen:hide()
	self.super:hide()
	self.colorMenu:destroy()
end

function ColorScreen:draw()
	self.super:draw()
	self.colorMenu:draw(self.fadeProgress)
end

function ColorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.colorMenu:update(deltaTime)

	if getKeyState("arrow_r") then
		self.colorMenu:increase(deltaTime)
	elseif getKeyState("arrow_l") then
		self.colorMenu:decrease(deltaTime)
	end
	if self.colorPreviewEnabled then
		if self.componentName == "BodyColor" then
			CarTexture.previewBodyColor(self.colorMenu:getColor())
		else
		GarageCar.previewTuning(self.componentName, {self.colorMenu:getColor()})
		if self.copyToAllWheels then
			if self.componentName == "WheelsColorF" then
				GarageCar.previewTuning("WheelsColorR", {self.colorMenu:getColor()})
			elseif self.componentName == "WheelsColorR" then
				GarageCar.previewTuning("WheelsColorR", {self.colorMenu:getColor()})
			end
		end
		end
	end
end

function ColorScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_u" then
		self.colorMenu:selectPreviousBar()
	elseif key == "arrow_d" then
		self.colorMenu:selectNextBar()
	elseif key == "f" then
		if string.find(self.componentName, "WheelsColor") then
			self.copyToAllWheels = not self.copyToAllWheels
			GarageCar.resetTuning()
		end
	elseif key == "backspace" then
		self.colorPreviewEnabled = false
		GarageCar.resetTuning()
		CarTexture.reset()
		self.screenManager:showScreen(ColorsScreen(self.componentName))
	elseif key == "enter" then
		self.colorPreviewEnabled = false
		local this = self
		Garage.buy(self.colorMenu.price, self.requiredLevel, function(success)
			if success then
				GarageCar.applyTuning(this.componentName, {this.colorMenu:getColor()})

				if this.copyToAllWheels then
					if this.componentName == "WheelsColorF" then
						GarageCar.applyTuning("WheelsColorR", {this.colorMenu:getColor()})
					elseif this.componentName == "WheelsColorR" then
						GarageCar.applyTuning("WheelsColorR", {this.colorMenu:getColor()})
					end
				end
			end
			CarTexture.reset()
			this.screenManager:showScreen(ColorsScreen(self.componentName))
		end)
	end
end
