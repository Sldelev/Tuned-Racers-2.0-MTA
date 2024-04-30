-- Экран переключения между компонентами
WheelRColorsSelector = Screen:subclass "WheelRColorsSelector"
local screenSize = Vector2(guiGetScreenSize())


function WheelRColorsSelector:init(componentName)
	self.super:init()
self.componentsSelection = ComponentSelection({
	{name="WheelsColorR", 	camera="wheelLB",  	locale="garage_tuning_paint_wheels_rear"},
	{name="BoltsColorR", 	camera="wheelLB", 		locale="garage_tuning_paint_bolts_rear"},
	{name="WheelsSpecularR"      ,camera="wheelLB", 	locale="garage_tuning_paint_specular_wheels_rear"},
	{name="WheelsChromeR", 	camera="wheelLB",  	locale="garage_tuning_paint_chrome_wheels_rear"},
	{name="CalipersColorR",camera="wheelLB", 	locale="garage_tuning_paint_calipers_rear"},
})

	-- Если возвращаемся, показать компонент, с которого возвращаемся
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
	
	self.ColorScreen = {
		WheelsChromeR = PaintAdditons
	}
end

function WheelRColorsSelector:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function WheelRColorsSelector:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function WheelRColorsSelector:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(ColorsScreen("WheelsR"))
		GarageCar.save()
	elseif key == "enter" then
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
	end
end
