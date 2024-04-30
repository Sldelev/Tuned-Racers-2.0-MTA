ComponentNameText = newclass "ComponentNameText"
local screenSize = Vector2(guiGetScreenSize())

function ComponentNameText:init()
	self.x = screenSize.x / 2
	self.y = screenSize.y - 75
	self.width = 150
	self.height = 150
	self.imagesize = 64
	
	self.text = ""
	self.font = Assets.fonts.componentName
	self.infoFont = Assets.fonts.componentNameInfo
	self.fontHeight = dxGetFontHeight(1, self.font)
	-- Анимация текста
	self.animationProgress = 0
	self.animationTarget = 0
	self.animationSpeed = 2

	self.infoText = ""

	-- Минимальный масштаб текста
	self.scaleAnimationStart = 0.5
	-- Скорость масштабирования текста
	self.scaleAnimationSpeed = 2

	-- Цвет текста
	self.color = {255, 255, 255}
	self.infoColorHex = exports.tunrc_Utils:RGBToHex(unpack(Garage.themePrimaryColor))
end

function ComponentNameText:changeText(text, price, level, name)
	if type(text) ~= "string" then
		return
	end
	self.animationTarget = 0
	self.animationProgress = 0
	self.text = text
	self.name = name
	self:setInfo(price, level)
end

function ComponentNameText:setInfo(price, level)
	if (not price and not level) or (level <= 1 and price == 0) then
		self.infoText = ""
		return
	end
	if (not price or price == 0) and level then
		self.infoText = "Доступно с уровня " .. tostring(level)
		return
	end
	if (not level or level <= 1) and price then
		self.infoText = "$" .. tostring(price)
	end

	self.infoText = "$" .. tostring(price) .. " Доступно с уровня " .. tostring(level)
end

function ComponentNameText:update(deltaTime)
	self.animationProgress = self.animationProgress + (self.animationTarget - self.animationProgress) * deltaTime * 2
	if self.animationTarget == 0 and self.animationProgress < 0.05 then
		self.animationTarget = 1
	end
end

function ComponentNameText:draw(fadeProgress)
	local length = dxGetTextWidth(self.text, 1, self.font)
end