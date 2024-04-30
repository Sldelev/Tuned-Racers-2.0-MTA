-- Экран переключения между конфигурациями компонентов
ConfigurationsScreen = Screen:subclass "ConfigurationsScreen"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationsScreen:init(componentName)
	self.super:init()

	--slocal suspensionRake, suspensionRake = unpack(exports.tunrc_Shared:getTuningPrices("rake"))
	local suspensionPrice, suspensionLevel = unpack(exports.tunrc_Shared:getTuningPrices("suspension"))
	local upgradesLevel = exports.tunrc_Shared:getTuningPrices("upgrades_level")
	self.componentsSelection = ComponentSelection({
		--{name="Upgrades",   camera="upgrades",   locale="garage_tuning_config_upgrades",   price = 0, level = upgradesLevel},
		{name="Suspension", camera="suspension", locale="garage_tuning_config_suspension", price = suspensionPrice, level = suspensionLevel},
		{name="Bias", camera="bias", locale="garage_tuning_config_bias", price = suspensionPrice, level = suspensionLevel},
		{name="Steer", camera="bias", locale="garage_tuning_config_steer", price = suspensionPrice, level = suspensionLevel},
		{name="veh_mass", camera="bias", locale="garage_tuning_config_veh_mass", price = suspensionPrice, level = suspensionLevel},
		{name="Exhausts", camera="bias", locale="garage_tuning_component_config_pos_rot_exhausts", price = suspensionPrice, level = suspensionLevel},
	})

	local vehicle = GarageCar.getVehicle()

	-- Если на машине установлены передние или задние диски
	local hasWheels = false
	if vehicle:getData("WheelsR") and vehicle:getData("WheelsR") > 0 then
		self.componentsSelection:addComponent("RearWheels", "wheelsOffsetRear", "garage_tuning_config_rear_wheels", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_advanced")))
		self.componentsSelection:addComponent("CalipersRotationR", "wheelLB", "garage_tuning_config_rear_calipers_rotation", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_advanced")))
		hasWheels = true
	end
	if vehicle:getData("WheelsF") and vehicle:getData("WheelsF") > 0 then
		self.componentsSelection:addComponent("FrontWheels", "wheelsOffsetFront", "garage_tuning_config_front_wheels", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_advanced")))
		self.componentsSelection:addComponent("CalipersRotationF", "wheelLF", "garage_tuning_config_front_calipers_rotation", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_advanced")))
		self.componentsSelection:addComponent("WheelsCastor", "wheelLF", "garage_tuning_config_wheels_castor")
		hasWheels = true
	end

	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end

	self.configurationScreens = {
		FrontWheels = WheelsScreen,
		RearWheels = WheelsScreen,
		Exhausts = ComponentPosRotScreen
	}
	
	exports.tunrc_WheelsManager:setForceSteering(GarageCar.getVehicle(), false)
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