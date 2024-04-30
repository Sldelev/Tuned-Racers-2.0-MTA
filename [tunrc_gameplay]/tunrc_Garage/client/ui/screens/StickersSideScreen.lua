StickersSideScreen = Screen:subclass "StickersSideScreen"

function StickersSideScreen:init(componentName)
	self.super:init()
	self.componentsSelection = ComponentSelection({
		{name="body", camera="frontBump", locale="garage_menu_livery_body"},
		{name="windows", camera="frontBump", locale="garage_menu_livery_glass"},
	})

	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
end

function StickersSideScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function StickersSideScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function StickersSideScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		-- Back
		self.componentsSelection:stop()
		self.screenManager:showScreen(TuningScreen(3))
		GarageCar.save()
	elseif key == "enter" then
		-- Select
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()
		-- Windows
		if componentName == "windows" then
			self.screenManager:showScreen(StickerEditorScreen(componentName))
		-- Body
		elseif componentName == "body" then
			self.screenManager:showScreen(StickerEditorScreen(componentName))
		end
	end
end
