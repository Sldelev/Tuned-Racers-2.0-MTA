ColorMenu = TuningMenu:subclass "ColorMenu"
local COLOR_CHANGE_SPEED = 1
local SLOW_SPEED_MUL = 0.14

function ColorMenu:init(headerText, position, rotation)
	self.super:init(position, rotation, Vector2(1.4, 1.4))
	self.headerHeight = 70
	self.headerText = headerText

	self.labelHeight = 50
	self.labels = {
		hue = exports.tunrc_Lang:getString("garage_tuning_paint_hue"),
		saturation = exports.tunrc_Lang:getString("garage_tuning_paint_saturation"),
		brightness = exports.tunrc_Lang:getString("garage_tuning_paint_brightness"),
		buy = exports.tunrc_Lang:getString("garage_tuning_buy_button")
	}

	self.barHeight = 20
	self.barOffset = 20

	self.bars = {
		{text = self.labels.hue,        value = 0, texture = Assets.textures.colorsHue},
		{text = self.labels.saturation, value = 1, texture = Assets.textures.colorsSaturation},
		{text = self.labels.brightness, value = 1, texture = Assets.textures.colorsBrightness},
	}
	self.activeBar = 1
	self.price = 0
end

function ColorMenu:getColor()
	local r, g, b = hsvToRgb(self.bars[1].value, self.bars[2].value, self.bars[3].value, 1)
	return math.floor(r), math.floor(g), math.floor(b)
end

function ColorMenu:setColor(r, g, b)
	local h, s, v = rgbToHsv(r, g, b, 1)
	self.bars[1].value = h
	self.bars[2].value = s
	self.bars[3].value = v
end

function ColorMenu:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxDrawText(self.headerText, self.resolution.x / 2 + 2, screenHeight / 2 + 2, self.resolution.x / 2, self.headerHeight, tocolor(0, 0, 0), 1, Assets.fonts.colorMenuHeader, "center", "center") --shadow
	dxDrawText(self.headerText, self.resolution.x / 2, screenHeight / 2, self.resolution.x / 2, self.headerHeight, tocolor(255, 255, 255), 1, Assets.fonts.colorMenuHeader, "center", "center")

	local priceText = ""
	if self.price > 0 then
		priceText = "$" .. tostring(self.price)
	else
		priceText = exports.tunrc_Lang:getString("price_free")
	end
	dxDrawText(priceText, self.resolution.x / 2 + 2, screenHeight / 2 + 62, self.resolution.x / 2, self.headerHeight, tocolor(0, 0, 0), 1, Assets.fonts.colorMenuPrice, "center", "center") --shadow
	dxDrawText(priceText, self.resolution.x / 2, screenHeight / 2 + 60, self.resolution.x / 2, self.headerHeight, tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]), 1, Assets.fonts.colorMenuPrice, "center", "center")

	local y = self.headerHeight
	local barWidth = self.resolution.x - self.barOffset * 2
	for i, bar in ipairs(self.bars) do
		local a = 255
		local cursorSize = 5
		if i == self.activeBar then
			cursorSize = 10
		else
			a = 200
		end

		local r, g, b = hsvToRgb(self.bars[1].value, 1, 1, 255)

		-- Подпись
		dxDrawText(bar.text, self.barOffset + 1, y + screenHeight / 2 + 1, self.resolution.x - self.barOffset, y + self.labelHeight, tocolor(0, 0, 0, a), 1, Assets.fonts.menuLabel, "left", "center") --shadow
		dxDrawText(bar.text, self.barOffset,  y + screenHeight / 2, self.resolution.x - self.barOffset, y + self.labelHeight, tocolor(255, 255, 255, a), 1, Assets.fonts.menuLabel, "left", "center")

		-- Значение
		dxDrawText(("%d"):format(bar.value * 255), self.barOffset + 2, y + screenHeight / 2 + 2, self.resolution.x - self.barOffset, y + self.labelHeight, tocolor(0, 0, 0, a), 1, Assets.fonts.menuLabel, "right", "center") --shadow
		dxDrawText(("%d"):format(bar.value * 255), self.barOffset, y + screenHeight / 2, self.resolution.x - self.barOffset, y + self.labelHeight, tocolor(255, 255, 255, a), 1, Assets.fonts.menuLabel, "right", "center")
		y = y + self.labelHeight

		-- Полоса
		if i == self.activeBar then
			dxDrawRectangle(self.barOffset - 1, y + screenHeight / 4 - 1, barWidth + 2, self.barHeight + 2, tocolor(255, 255, 255, 255))
		end
		dxDrawRectangle(self.barOffset, y + screenHeight / 4, barWidth, self.barHeight, tocolor(r, g, b, a))
		dxDrawImage(self.barOffset, y + screenHeight / 4, barWidth, self.barHeight, bar.texture, 0, 0, 0, tocolor(255, 255, 255))

		-- Ползунок
		local x = (barWidth + 2) * bar.value
		x = self.barOffset + math.max(0, math.min(x, barWidth - cursorSize + 2)) - 1
		dxDrawRectangle(x, y + screenHeight / 4 - cursorSize, cursorSize, self.barHeight + cursorSize * 2, tocolor(255, 255, 255))

		y = y + self.barHeight * 2
	end

end


function ColorMenu:update(deltaTime)
	self.super:update(deltaTime)
end

function ColorMenu:selectNextBar()
	self.activeBar = self.activeBar + 1
	if self.activeBar > #self.bars then
		self.activeBar = 1
	end
end

function ColorMenu:selectPreviousBar()
	self.activeBar = self.activeBar - 1
	if self.activeBar < 1 then
		self.activeBar = #self.bars
	end
end

function ColorMenu:increase(dt)
	local speedMul = 1
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	self.bars[self.activeBar].value = self.bars[self.activeBar].value + COLOR_CHANGE_SPEED * speedMul * dt
	if self.bars[self.activeBar].value > 1 then
		self.bars[self.activeBar].value = 1
	end
end

function ColorMenu:decrease(dt)
	local speedMul = 1
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	self.bars[self.activeBar].value = self.bars[self.activeBar].value - COLOR_CHANGE_SPEED * speedMul * dt
	if self.bars[self.activeBar].value < 0 then
		self.bars[self.activeBar].value = 0
	end
end