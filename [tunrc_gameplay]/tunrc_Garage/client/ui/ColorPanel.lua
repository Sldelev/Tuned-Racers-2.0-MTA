ColorPanel = newclass "ColorPanel"
local COLOR_CHANGE_SPEED = 1
local SLOW_SPEED_MUL = 0.14

function ColorPanel:init(headerText)
	self.x = 0
	self.y = 0
	self.resolution = Vector2(330, 450)
	self.showPrice = true

	self.headerHeight = 70
	self.headerText = headerText

	self.labelHeight = 50
	self.labels = {
		hue = exports.tunrc_Lang:getString("garage_tuning_paint_hue"),
		saturation = exports.tunrc_Lang:getString("garage_tuning_paint_saturation"),
		brightness = exports.tunrc_Lang:getString("garage_tuning_paint_brightness"),
		opacity = exports.tunrc_Lang:getString("garage_tuning_paint_opacity"),
		buy = exports.tunrc_Lang:getString("garage_tuning_buy_button")
	}

	self.barHeight = 20
	self.barOffset = 20

	self.bars = {
		{text = self.labels.hue,        value = 0, texture = Assets.textures.colorsHue},
		{text = self.labels.saturation, value = 1, texture = Assets.textures.colorsSaturation},
		{text = self.labels.brightness, value = 1, texture = Assets.textures.colorsBrightness},
		{text = self.labels.opacity,    value = 1, texture = Assets.textures.colorsOpacity}
	}
	self.activeBar = 1
	self.price = 0
end

function ColorPanel:getColor()
	local r, g, b, a = hsvToRgb(self.bars[1].value, self.bars[2].value, self.bars[3].value, self.bars[4].value)
	return r, g, b, a
end

function ColorPanel:setColor(r, g, b, a)
	a = a or 1
	local h, s, v, a = rgbToHsv(r, g, b, a)
	self.bars[1].value = h
	self.bars[2].value = s
	self.bars[3].value = v
	self.bars[4].value = a
end

function ColorPanel:draw(fadeProgress)
	if not fadeProgress then fadeProgress = 1 end
	if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
		textColor = tocolor(255, 255, 255, 255*fadeProgress)
	else
		textColor = tocolor(20, 20, 20, 255*fadeProgress)
	end
	
	dxDrawRoundedRectangle(
		self.x,
		self.y,
		self.resolution.x,
		self.resolution.y - self.headerHeight,
		15,
		255*fadeProgress,
		false,
		false,
		true,
		false
	)
	dxDrawRoundedRectangle(
		self.x,
		self.y + self.headerHeight,
		self.resolution.x,
		self.resolution.y / 2 + self.headerHeight + 20,
		0,
		255*fadeProgress,
		false,
		false,
		true,
		true
	) 	
	dxDrawText(self.headerText, self.x + 20, self.y, self.x + self.resolution.x, self.y + self.headerHeight, textColor, 1, Assets.fonts.colorMenuHeader, "left", "center")

	if self.showPrice then
		local priceText = ""
		if self.price > 0 then
			priceText = "$" .. tostring(self.price)
		else
			priceText = exports.tunrc_Lang:getString("price_free")
		end
		dxDrawText(priceText, self.x, self.y, self.x + self.resolution.x - 20, self.y + self.headerHeight, textColor, 1, Assets.fonts.ColorPanelPrice, "right", "center")
	end

	local y = self.y + self.headerHeight
	local barWidth = self.resolution.x - self.barOffset * 2
	for i, bar in ipairs(self.bars) do
		local a = 255
		local cursorSize = 5
		if i == self.activeBar then
			cursorSize = 10
		else
			a = 200
		end

		local r, g, b = hsvToRgb(self.bars[1].value, 1, 1, 1)

		-- Подпись
		dxDrawText(bar.text, self.x + self.barOffset, y, self.x + self.resolution.x - self.barOffset, y + self.labelHeight, textColor, 1, Assets.fonts.menuLabel, "left", "center")

		-- Значение
		dxDrawText(("%d"):format(bar.value * 255), self.x + self.barOffset, y, self.x + self.resolution.x - self.barOffset, y + self.labelHeight, textColor, 1, Assets.fonts.menuLabel, "right", "center")
		y = y + self.labelHeight

		-- Полоса
		if i == self.activeBar then
			dxDrawRectangle(self.x + self.barOffset - 1, y - 1, barWidth + 2, self.barHeight + 2, textColor)
		end
		dxDrawRectangle(self.x + self.barOffset, y, barWidth, self.barHeight, tocolor(0, 0, 0, 255*fadeProgress))
		if i == 2 then
			dxDrawImage(self.x + self.barOffset, y, barWidth, self.barHeight, bar.texture, 0, 0, 0, tocolor(r, g, b, 255*fadeProgress))
		else
			dxDrawImage(self.x + self.barOffset, y, barWidth, self.barHeight, bar.texture, 0, 0, 0, tocolor(255, 255, 255, 255*fadeProgress))
		end
		-- Ползунок
		local x = (barWidth) * bar.value
		x = self.barOffset + math.max(0, math.min(x, barWidth + cursorSize)) - cursorSize / 2
		dxDrawRectangle(self.x + x, y - cursorSize, cursorSize, self.barHeight + cursorSize * 2, textColor)

		y = y + self.barHeight * 2
	end
end

function ColorPanel:selectNextBar()
	self.activeBar = self.activeBar + 1
	if self.activeBar > #self.bars then
		self.activeBar = 1
	end
end

function ColorPanel:selectPreviousBar()
	self.activeBar = self.activeBar - 1
	if self.activeBar < 1 then
		self.activeBar = #self.bars
	end
end

function ColorPanel:increase(dt)
	local speedMul = COLOR_CHANGE_SPEED
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	self.bars[self.activeBar].value = self.bars[self.activeBar].value + speedMul * dt
	if self.bars[self.activeBar].value > 1 then
		self.bars[self.activeBar].value = 1
	end
end

function ColorPanel:decrease(dt)
	local speedMul = COLOR_CHANGE_SPEED
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	self.bars[self.activeBar].value = self.bars[self.activeBar].value - speedMul * dt
	if self.bars[self.activeBar].value < 0 then
		self.bars[self.activeBar].value = 0
	end
end
