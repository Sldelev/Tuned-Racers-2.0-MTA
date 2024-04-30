ColorScreen = Screen:subclass "ColorScreen"

local priceSources = {
	BodyColor = "body_color",
	SpecularColor = "body_color",
	WheelsColorF = "wheels_color",
	WheelsColorR = "wheels_color",
	BoltsColorF = "wheels_color",
	BoltsColorR = "wheels_color",
	CalipersColorF = "wheels_color",
	CalipersColorR = "wheels_color",
	SmokeColor = "body_color",
	RollcageColor = "body_color",
	EngBlockColor = "body_color"
}

local colorMenus = {
	["BodyColor"]    = {locale="garage_tuning_paint_body",    position = Vector3(-1, -2, 0.4),   angle = 10},
	["SpecularColor"]    = {locale="garage_tuning_paint_body_specular",    position = Vector3(-1, -2, 0.4),   angle = 10},
	["WheelsColorF"]  = {locale="garage_tuning_paint_wheels",  position = Vector3(-0.5, -2, 0.4), angle = 15},
	["WheelsSpecularF"]  = {locale="garage_tuning_paint_specular_wheels",  position = Vector3(-0.5, -2, 0.4), angle = 15},
	["WheelsColorR"]  = {locale="garage_tuning_paint_wheels",  position = Vector3(-1, -2, 0.4), angle = 15},
	["WheelsSpecularR"]  = {locale="garage_tuning_paint_specular_wheels",  position = Vector3(-1, -2, 0.4), angle = 15},
	["BoltsColorF"]  = {locale="garage_tuning_paint_bolts",  position = Vector3(-0.5, -2, 0.4), angle = 15},
	["BoltsColorR"]  = {locale="garage_tuning_paint_bolts",  position = Vector3(-1, -2, 0.4), angle = 15},
	["CalipersColorF"]  = {locale="garage_tuning_paint_calipers",  position = Vector3(-0.5, -2, 0.4), angle = 15},
	["CalipersColorR"]  = {locale="garage_tuning_paint_calipers",  position = Vector3(-1, -2, 0.4), angle = 15},
	["RollcageColor"] = {locale="garage_tuning_paint_rollcage", position = Vector3(-1, -2, 0.4),   angle = 10},
	["EngBlockColor"] = {locale="garage_tuning_paint_engblock", position = Vector3(-1, -2, 0.4),   angle = 10},
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
	
	self.helpPanel = HelpPanel({
		{ keys = {"F"}, 				locale = "garage_tuning_paint_copy_color"},
		{ keys = {"E"}, 				locale = "garage_tuning_paint_copy_specular_color"},
		{ keys = {"Z"}, 				locale = "garage_sticker_editor_help_toggle"},
	})
	
	self.helpPanelBody = HelpPanel({
		{ keys = {"E"}, 				locale = "garage_tuning_paint_copy_color_body"},
		{ keys = {"Z"}, 				locale = "garage_sticker_editor_help_toggle"},
	})

	self.copyToAllWheels = false
	self.copyBodyToSpec = false
end

function ColorScreen:hide()
	self.super:hide()
	self.colorMenu:destroy()
end

function ColorScreen:draw()
	self.super:draw()
	self.colorMenu:draw(self.fadeProgress)
	if self.componentName == "WheelsColorF" or self.componentName == "WheelsColorR" then
		self.helpPanel:draw(self.fadeProgress)
	end
	if self.componentName == "BodyColor" then
		self.helpPanelBody:draw(self.fadeProgress)
	end
end

function ColorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.colorMenu:update(deltaTime)
	self.helpPanel:update(deltaTime)

	if getKeyState("arrow_r") then
		self.colorMenu:increase(deltaTime)
	elseif getKeyState("arrow_l") then
		self.colorMenu:decrease(deltaTime)
	end
	if self.colorPreviewEnabled then
		if self.componentName == "BodyColor" then
			CarTexture.previewBodyColor(self.colorMenu:getColor())
			if self.copyBodyToSpec then
				CarTexture.previewSpecularColor(self.colorMenu:getColor())
			end
		elseif self.componentName == "SpecularColor" then
			CarTexture.previewSpecularColor(self.colorMenu:getColor())
		else
			GarageCar.previewTuning(self.componentName, {self.colorMenu:getColor()})
			if self.copyToAllWheels == true and self.copyBodyToSpec == false then
				if self.componentName == "WheelsColorF" then
					GarageCar.previewTuning("WheelsColorR", {self.colorMenu:getColor()})
				elseif self.componentName == "WheelsColorR" then
					GarageCar.previewTuning("WheelsColorF", {self.colorMenu:getColor()})
				end
			elseif self.copyToAllWheels == true and self.copyBodyToSpec == true then
				if self.componentName == "WheelsColorF" then	
					GarageCar.previewTuning("WheelsSpecularR", {self.colorMenu:getColor()})
					GarageCar.previewTuning("WheelsColorR", {self.colorMenu:getColor()})
					GarageCar.previewTuning("WheelsSpecularF", {self.colorMenu:getColor()})
				elseif self.componentName == "WheelsColorR" then
					GarageCar.previewTuning("WheelsSpecularR", {self.colorMenu:getColor()})
					GarageCar.previewTuning("WheelsColorF", {self.colorMenu:getColor()})
					GarageCar.previewTuning("WheelsSpecularF", {self.colorMenu:getColor()})
				end
			elseif self.copyToAllWheels == false and self.copyBodyToSpec == true then
				if self.componentName == "WheelsColorF" then
					GarageCar.previewTuning("WheelsSpecularF", {self.colorMenu:getColor()})
				elseif self.componentName == "WheelsColorR" then
					GarageCar.previewTuning("WheelsSpecularR", {self.colorMenu:getColor()})
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
	elseif key == "z" then
		self.helpPanel:toggle()
	elseif key == "f" then
		if string.find(self.componentName, "WheelsColor") then
			self.copyToAllWheels = not self.copyToAllWheels
			GarageCar.resetTuning()
		end
	elseif key == "e" then
		if string.find(self.componentName, "BodyColor") then
			self.copyBodyToSpec = not self.copyBodyToSpec
			GarageCar.resetTuning()
		end
	elseif key == "backspace" then
		self.colorPreviewEnabled = false
		GarageCar.resetTuning()
		CarTexture.reset()
		if self.componentName == "WheelsColorF" or self.componentName == "WheelsSpecularF" or self.componentName == "BoltsColorF" or self.componentName == "CalipersColorF" then
			self.screenManager:showScreen(WheelFColorsSelector(self.componentName))
		elseif self.componentName == "WheelsColorR" or self.componentName == "WheelsSpecularR" or self.componentName == "BoltsColorR" or self.componentName == "CalipersColorR" then
			self.screenManager:showScreen(WheelRColorsSelector(self.componentName))
		else
			self.screenManager:showScreen(ColorsScreen(self.componentName))
		end
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
						GarageCar.applyTuning("WheelsColorF", {this.colorMenu:getColor()})
					end
				end
				if this.copyBodyToSpec then
					if this.componentName == "BodyColor" then
						GarageCar.applyTuning("SpecularColor", {this.colorMenu:getColor()})
					end
				end
			end
			CarTexture.reset()
			if this.componentName == "WheelsColorF" or this.componentName == "WheelsSpecularF" or this.componentName == "BoltsColorF" or this.componentName == "CalipersColorF" then
				this.screenManager:showScreen(WheelFColorsSelector(this.componentName))
			elseif this.componentName == "WheelsColorR" or this.componentName == "WheelsSpecularR" or this.componentName == "BoltsColorR" or this.componentName == "CalipersColorR" then
				this.screenManager:showScreen(WheelRColorsSelector(this.componentName))
			else
				this.screenManager:showScreen(ColorsScreen(self.componentName))
			end
		end)
	end
end
