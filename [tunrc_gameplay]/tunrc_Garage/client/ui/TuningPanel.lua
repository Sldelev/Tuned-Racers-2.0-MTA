TuningPanel = newclass "TuningPanel"

-- Цвета и прозрачность
local BACKGROUND_COLOR = {29, 29, 29}
local TEXT_BACKGROUND_COLOR = {255, 255, 255}
-- Размеры и расположение
local PADDING_X = 12
local PADDING_Y = 8
local ICON_SIZE = 36
local ICON_SPACE = 30
local CIRCLE_SIZE = 24

function TuningPanel:init(items, draw3d)
	self.items = {}
	for i, item in ipairs(items) do
		table.insert(self.items, {icon = item.icon, text = item.text, key = item.key})
	end
	self.draw3d = not not draw3d
	self.screenSize = Vector2(guiGetScreenSize())

	self.activeItem = 1

	-- Подсчёт размеров
	local itemsCount = #self.items
	self.width = PADDING_X * 2 + ICON_SIZE * itemsCount + ICON_SPACE * (itemsCount - 1)
	self.height = PADDING_Y * 2 + ICON_SIZE
	self.x = self.screenSize.x / 2 - self.width / 2 - self.width * 0.2
	self.y = 40
	self.textBoxWidth = 0
	self.textBoxWidthTarget = 0
	--
	self.font = Assets.fonts.tuningPanelText
	self.keyFont = Assets.fonts.tuningPanelKey
	self.activeItemColor = Garage.themePrimaryColor
	self:updateTextBox() 
	self.textBackgroundAlpha = 30
	self.backgroundAlpha = 230
	self.highlightSelection = false	
end

function TuningPanel:getActiveItem()
	return self.activeItem
end

function TuningPanel:setActiveItem(item)
	self.activeItem = item
	self:updateTextBox()
end

function TuningPanel:updateTextBox()
	self.text = self.items[self.activeItem].text
	if type(self.text) == "string" then
		local textWidth = dxGetTextWidth(self.text, 1, self.font)
		self.textBoxWidthTarget = PADDING_X * 2 + textWidth
	else
		self.textBoxWidthTarget = 0
	end
	local width = self.width + self.textBoxWidth
end

function TuningPanel:selectNext()
	self.activeItem = self.activeItem + 1
	if self.activeItem > #self.items then
		self.activeItem = 1
	end
	self:updateTextBox()
end

function TuningPanel:getItem()

end

function TuningPanel:selectPrevious()
	self.activeItem = self.activeItem - 1 
	if self.activeItem < 1 then
		self.activeItem = #self.items
	end
	self:updateTextBox()
end

function TuningPanel:update(dt)
	self.textBoxWidth = self.textBoxWidth + (self.textBoxWidthTarget - self.textBoxWidth) * dt * 15
end

function TuningPanel:draw(fadeProgress)
	-- Основной фон
	dxDrawRoundedRectangle(
		self.x,
		self.y,
		self.width,
		self.height,
		5,
		255*fadeProgress,
		false,
		false,
		true
	 )
	
	-- Отрисовка иконок
	local x, y = self.x + PADDING_X, self.y + PADDING_Y
	for i, item in ipairs(self.items) do
		local color = tocolor(155, 155, 155, 255 * fadeProgress)
		if i == self.activeItem then
			if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
				color = tocolor(255, 255, 255, 255 * fadeProgress)
			else
				color = tocolor(20, 20, 20, 255 * fadeProgress)
			end			
		end

		if item.key then
			local cx = x - PADDING_X - CIRCLE_SIZE / 2
			local cy = y - PADDING_Y - CIRCLE_SIZE / 2
			dxDrawText(
				item.key, 
				cx, 
				cy, 
				cx + CIRCLE_SIZE, 
				cy + CIRCLE_SIZE, 
				tocolor(255, 255, 255, 255 * fadeProgress),
				1, 
				self.keyFont,
				"center",
				"center",
				true,
				false,
				false,
				false,
				true
			)
		end
		dxDrawImage(x, y, ICON_SIZE, ICON_SIZE, item.icon, 0, 0, 0, color)
		x = x + ICON_SIZE + ICON_SPACE
	end

	if self.text then
		-- Отрисовка текста
		dxDrawText(
			self.text, 
			self.x + self.width, 
			self.y, 
			self.x + self.width + self.textBoxWidth, 
			self.y + self.height, 
			tocolor(255, 255, 255, 255 * fadeProgress),
			1, 
			self.font,
			"center",
			"center",
			true,
			false,
			false,
			false,
			true -- Sub pixel positioning	
		)
	end
end