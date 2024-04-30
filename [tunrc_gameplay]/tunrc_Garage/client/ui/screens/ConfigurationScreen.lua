-- Component configuration screen
ConfigurationScreen = Screen:subclass "ConfigurationScreen"
local screenSize = Vector2(guiGetScreenSize())

local menuInfos = {}
menuInfos["Suspension"] = {position = Vector3(1, -2, 0.4), angle = 20, header="garage_tuning_config_suspension", label="garage_tuning_config_suspension_label"}
menuInfos["Bias"] = {position = Vector3(1, -2, 0.4), angle = 20, header="garage_tuning_config_bias", label="garage_tuning_config_bias_label"}
menuInfos["Steer"] = {
	position = Vector3(1, -2, 0.4),
	angle = 20,
	header="garage_tuning_config_steer",
	label="garage_tuning_config_steer_label"
}
menuInfos["veh_mass"] = {
	position = Vector3(1, -2, 0.4),
	angle = 20,
	header="garage_tuning_config_veh_mass", 
	label="garage_tuning_config_veh_mass_label"
}
menuInfos["WheelsCastor"] = {
	position = Vector3(0.5, -2, 0.4),
	angle = -90,
	header = "garage_tuning_config_wheels_castor",
	label = "garage_tuning_config_wheels_castor_label"
}
menuInfos["CalipersRotationF"] = {
	position = Vector3(0.5, -2, 0.4),
	angle = -90,
	header = "garage_tuning_config_wheels_calipers_rotation",
	label = "garage_tuning_config_wheels_calipers_rotation_label"
}
menuInfos["CalipersRotationR"] = {
	position = Vector3(0.5, -2, 0.4),
	angle = -90,
	header = "garage_tuning_config_wheels_calipers_rotation",
	label = "garage_tuning_config_wheels_calipers_rotation_label"
}

function ConfigurationScreen:init(dataName)
	self.super:init()
	
	self.helpPanel = HelpPanel({
		{ keys = {"F"}, 				locale = "garage_tuning_config_copy_size"},
		{ keys = {"Z"}, 				locale = "garage_sticker_editor_help_toggle"},
	})

	local menuInfo = menuInfos[dataName]
	if menuInfo.bars then
		self.menu = SliderMenu(
			exports.tunrc_Lang:getString(menuInfo.header),
			GarageCar.getVehiclePos() + menuInfo.position,
			menuInfo.angle,
			menuInfo.bars
		)
	else
		self.menu = SliderMenu(
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
	self.vehicle = GarageCar.getVehicle()
	self.dataName = dataName
	self.dataType = "tuning"
	local price = -1
	if self.dataName == "Suspension" then
		self.applyForce = true
		self.dataType = "handling"
		price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "Bias" then
	    self.applyForce = true
	    self.dataType = "handling"
	    price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "Steer" then
	    local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = exports.tunrc_Vehicles:GetMinSteerValue()
		bar.maxValue = exports.tunrc_Vehicles:GetMaxSteerValue()
	    self.dataType = "handling"
	    price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "WheelsCastor" then
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 15
		price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "CalipersRotationF" or self.dataName == "CalipersRotationR" then
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 360
		price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "veh_mass" then
		self.applyForce = true
		self.dataType = "handling"
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 50000
		price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	end
	self.menu.price = price
	self.configurationIndex = configurationIndex
	self.menu:setValue(GarageCar.getVehicle():getData(dataName))
	CameraManager.setState("preview" .. tostring(dataName), false, 3)
end

function ConfigurationScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function ConfigurationScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)
	if self.dataName then
		if getKeyState("arrow_r") then
			self.menu:increase(deltaTime)
		elseif getKeyState("arrow_l") then
			self.menu:decrease(deltaTime)
		end

		if self.dataType == "handling" then
			GarageCar.previewHandling(self.dataName, self.menu:getValue())
		else
			GarageCar.previewTuning(self.dataName, self.menu:getValue())
		end
	end
	if self.dataName == "Steer" or self.dataName == "WheelsCastor" then
		exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), true, tonumber(self.vehicle:getData("Steer")))
	else
		exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), true, 0)
	end
	if self.applyForce then
		if getKeyState("arrow_r") then
			self.vehicle.velocity = Vector3(0, 0, 0.005)
		elseif getKeyState("arrow_l") then
			self.vehicle.velocity = Vector3(0, 0, -0.005)
		end
	end
end

function ConfigurationScreen:onKey(key)
	self.super:onKey(key)
	
	if key == "backspace" then
		GarageCar.resetTuning()
		exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), true, 0)
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
		self.dataName = nil
	elseif key == "enter" then	
		local name = "suspension"
		exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), true, 0)
		local this = self
		local price, level = unpack(exports.tunrc_Shared:getTuningPrices(name))
		
		Garage.buy(price, level, function(success)
			if success then
				if this.dataType == "handling" then
					GarageCar.applyHandling(this.dataName)
				else
					GarageCar.applyTuning(this.dataName)
				end
				GarageCar.save()
			else
				GarageCar.resetTuning()
				self.dataName = nil
			end
			self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
		end)
	elseif key == "arrow_u" then
		self.menu:selectPreviousBar()
	elseif key == "arrow_d" then
		self.menu:selectNextBar()
	end
end