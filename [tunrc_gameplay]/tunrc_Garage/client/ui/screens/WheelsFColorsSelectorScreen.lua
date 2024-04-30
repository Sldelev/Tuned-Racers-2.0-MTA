-- Экран переключения между компонентами
WheelFColorsSelector = Screen:subclass "WheelFColorsSelector"
local screenSize = Vector2(guiGetScreenSize())


function WheelFColorsSelector:init(componentName)
	self.super:init()
self.componentsSelection = ComponentSelection({
	{name="WheelsColorF", 	camera="wheelLF",  	locale="garage_tuning_paint_wheels_front"},
	{name="BoltsColorF", 	camera="wheelLF", 		locale="garage_tuning_paint_bolts_front"},
	{name="WheelsSpecularF"      ,camera="wheelLF", 	locale="garage_tuning_paint_specular_wheels_front"},
	{name="WheelsChromeF", 	camera="wheelLF",  	locale="garage_tuning_paint_chrome_wheels_front"},
	{name="CalipersColorF",camera="wheelLF", 	locale="garage_tuning_paint_calipers_front"},
})

	-- Если возвращаемся, показать компонент, с которого возвращаемся
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
	
	self.ColorScreen = {
		WheelsChromeF = PaintAdditons
	}
end

function WheelFColorsSelector:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function WheelFColorsSelector:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function WheelFColorsSelector:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(ColorsScreen("WheelsF"))
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
