-- Экран переключения между конфигурациями компонентов
ConfigurationsScreen = Screen:subclass "ConfigurationsScreen"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationsScreen:init(componentName)
	self.super:init()

	--slocal suspensionRake, suspensionRake = unpack(exports.tunrc_Shared:getTuningPrices("rake"))
	local suspensionPrice, suspensionLevel = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	local upgradesLevel = exports.tunrc_Shared:getTuningPrices("upgrades_level")
	self.componentsSelection = ComponentSelection({
		{name="Upgrades",   camera="upgrades",   locale="garage_tuning_config_upgrades",   price = 0, level = upgradesLevel},
		{name="Suspension", camera="suspension", locale="garage_tuning_config_suspension", price = suspensionPrice, level = suspensionLevel},
		{name="Bias", camera="bias", locale="garage_tuning_config_bias", price = 0, level = 0},
		--{name="Boost", camera="boost", locale="garage_tuning_config_boost", price = 20, level = 0},
		--{name="LoadBias", camera="loadbias", locale="garage_tuning_config_loadbias", price = 0, level = 0},
		--{name="RearTires", camera="reartires", locale="garage_tuning_config_reartires", price = 0, level = 0},
		--{name="FrontTires", camera="fronttires", locale="garage_tuning_config_fronttires", price = 0, level = 0},
		--{name="Brakepower", camera="brakepower", locale="garage_tuning_config_brakepower", price = 0, level = 0},
		{name="Steer", camera="bias", locale="garage_tuning_config_steer", price = 0, level = 0},
		--{name="Brakedist", camera="brakedist", locale="garage_tuning_config_brakedist", price = 0, level = 0}
	})

	local vehicle = GarageCar.getVehicle()

	-- Если на машине установлены передние или задние диски
	local hasWheels = false
	if vehicle:getData("WheelsR") and vehicle:getData("WheelsR") > 0 then
		self.componentsSelection:addComponent("RearWheels", "wheelsOffsetRear", "garage_tuning_config_rear_wheels", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_advanced")))
		hasWheels = true
	end
	if vehicle:getData("WheelsF") and vehicle:getData("WheelsF") > 0 then
		self.componentsSelection:addComponent("FrontWheels", "wheelsOffsetFront", "garage_tuning_config_front_wheels", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_advanced")))
		hasWheels = true
	end
	if hasWheels then
		self.componentsSelection:addComponent("WheelsSize", "wheelsSize", "garage_tuning_config_wheels_size", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_size")))
	end

	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end

	self.configurationScreens = {
		FrontWheels = WheelsScreen,
		RearWheels = WheelsScreen,
		Upgrades = UpgradesScreen
	}
end

function ConfigurationsScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function ConfigurationsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function ConfigurationsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		-- Перейти к следующему компоненту
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		-- Перейти к предыдущему компоненту
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		-- Вернуться на предыдущий экран
		self.screenManager:showScreen(TuningScreen(4))
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		if not self.componentsSelection:canBuy() then
			return
		end
		local componentName = self.componentsSelection:getSelectedComponentName()
		if not componentName then
			return
		end
		-- Отобразить экран настройки конфигурации
		self.componentsSelection:stop()

		local screenClass = ConfigurationScreen
		if self.configurationScreens[componentName] then
			screenClass = self.configurationScreens[componentName]
		end
		self.screenManager:showScreen(screenClass(componentName))
	end
end