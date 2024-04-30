ColorsScreen = Screen:subclass "ColorsScreen"

function ColorsScreen:init(componentName)
	self.super:init()
	local bodyColorPrice, bodyColorLevel = unpack(exports.tunrc_Shared:getTuningPrices("body_color"))
	self.componentsSelection = ComponentSelection({
		{name="BodyColor",       camera="bodyColor",       locale="garage_tuning_paint_body", price = bodyColorPrice, level = bodyColorLevel},
		{name="SpecularColor",       camera="bodyColor",       locale="garage_tuning_paint_body_specular", price = bodyColorPrice, level = bodyColorLevel},
		{name="ChromePower",       camera="bodyColor",       locale="garage_tuning_paint_body_chrome_power", price = bodyColorPrice, level = bodyColorLevel},
		{name="EngBlockColor",       camera="bodyColor",       locale="garage_tuning_engblock_color", price = bodyColorPrice, level = bodyColorLevel},
		{name="RollcageColor",       camera="bodyColor",       locale="garage_tuning_rollcage_color", price = bodyColorPrice, level = bodyColorLevel},
		{name="SmokeColor",       camera="bodyColor",       locale="garage_tuning_smoke_color", price = bodyColorPrice, level = bodyColorLevel},
	})
	local vehicle = GarageCar.getVehicle()
	-- Если на машине установлены передние диски
	if vehicle:getData("WheelsF") and vehicle:getData("WheelsF") > 0 then
		self.componentsSelection:addComponent("WheelsF", "wheelLF", "garage_tuning_component_wheels_front", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_color")))
	end
	-- Если на машине установлены задние диски
	if vehicle:getData("WheelsR") and vehicle:getData("WheelsR") > 0 then
		self.componentsSelection:addComponent("WheelsR", "wheelLB", "garage_tuning_component_wheels_rear", nil, unpack(exports.tunrc_Shared:getTuningPrices("wheels_color")))
	end
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
	
	self.ColorScreen = {
		ChromePower = PaintAdditons,
		WheelsF = WheelFColorsSelector,
		WheelsR = WheelRColorsSelector
	}
end

function ColorsScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function ColorsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function ColorsScreen:onKey(key)
	self.super:onKey(key)

	if key == "enter" then
		if not self.componentsSelection:canBuy() then
			return
		end
		
		local componentName = self.componentsSelection:getSelectedComponentName()
		self.componentsSelection:stop()
		
		local screenClass = ColorScreen
		if self.ColorScreen[componentName] then
			screenClass = self.ColorScreen[componentName]
		end
		
		self.screenManager:showScreen(screenClass(componentName))
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(TuningScreen(2))
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	end
end
