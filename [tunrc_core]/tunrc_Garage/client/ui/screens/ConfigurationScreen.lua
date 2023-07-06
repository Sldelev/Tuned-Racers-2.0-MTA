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
menuInfos["veh_velocity"] = {
	position = Vector3(1, -2, 0.4),
	angle = 20,
	header="garage_tuning_config_veh_velocity", 
	label="garage_tuning_config_veh_velocity_label"
}
menuInfos["veh_mass"] = {
	position = Vector3(1, -2, 0.4),
	angle = 20,
	header="garage_tuning_config_veh_mass", 
	label="garage_tuning_config_veh_mass_label"
}
menuInfos["veh_turnmass"] = {
	position = Vector3(1, -2, 0.4),
	angle = 20,
	header="garage_tuning_config_veh_turnmass", 
	label="garage_tuning_config_veh_turnmass_label"
}
menuInfos["WheelsSize"] = {position = Vector3(0.5, -2, 0.4), angle = -90, header="garage_tuning_config_wheels_size", label="garage_tuning_config_wheels_size_label"}
menuInfos["WheelsCastor"] = {
	position = Vector3(0.5, -2, 0.4),
	angle = -90,
	header = "garage_tuning_config_wheels_castor",
	label = "garage_tuning_config_wheels_castor_label"
}

function ConfigurationScreen:init(dataName)
	self.super:init()

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
	elseif self.dataName == "WheelsSize" then
		price = unpack(exports.tunrc_Shared:getTuningPrices("wheels_size"))
	elseif self.dataName == "Bias" then
	    self.applyForce = true
	    self.dataType = "handling"
	    price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "Steer" then
	    self.applyForce = true
	    self.dataType = "handling"
	    price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "WheelsCastor" then
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 15
		price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "veh_velocity" then
		self.applyForce = true
		self.dataType = "handling"
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 300
		price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "veh_mass" then
		self.applyForce = true
		self.dataType = "handling"
		local bar = self.menu.bars[1]
		bar.factor = 1
		bar.minValue = 0
		bar.maxValue = 50000
		price = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	elseif self.dataName == "veh_turnmass" then
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
	if self.dataName then
		if getKeyState("arrow_r") then
			self.menu:increase(deltaTime)
		elseif getKeyState("arrow_l") then
			self.menu:decrease(deltaTime)
		end

		if self.dataType == "handling" then
			GarageCar.previewHandling(self.dataName, self.menu:getValue())
		else
			local value = self.menu:getValue()
			GarageCar.previewTuning(self.dataName, value)
			if self.dataName == "WheelsCastor" then
				exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), true, 40)
			end
		end
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
		self.dataName = nil
		exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), false)
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
	elseif key == "enter" then	
		local name = "suspension"
		if self.dataName == "WheelsSize" then
			name = "wheels_size"
	    elseif self.dataName == "Angle" then
			name = "angle"
		elseif self.dataName == "Bias" then
			name = "bias"
		end

		local this = self
		local price, level = unpack(exports.tunrc_Shared:getTuningPrices(name))
		exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), false)
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
	end
end