SliderMenu = TuningMenu:subclass "SliderMenu"

local ScreenX,ScreenY = guiGetScreenSize()

local PARAM_CHANGE_SPEED = 1
local SLOW_SPEED_MUL = 0.14

function SliderMenu:init(headerText, position, rotation, bars)
	self.super:init(position, rotation, Vector2(1.4, 0.3 + 0.4 * #bars))
	self.headerHeight = 70
	self.headerText = headerText

	self.labelHeight = 50
	
	self.ScreenX = ScreenX * 0.01
	self.ScreenY = ScreenY / 2

	self.barHeight = 4
	self.barOffset = 20

	self.bars = {}
	for i, bar in pairs(bars) do
		self.bars[i] = {
			text = exports.tunrc_Lang:getString(bar.label),
			value = bar.value or 0,
			factor = bar.factor or 100,
			minValue = bar.minValue or 0,
			maxValue = bar.maxValue or 1
		}
	end

	self.activeBar = 1
	self.price = 0
end

function SliderMenu:getValue()
	return self.bars[self.activeBar].value
end

function SliderMenu:setValue(value)
	if type(value) ~= "number" then
		return false
	end
	local bar = self.bars[self.activeBar]
	value = math.min(bar.maxValue, math.max(bar.minValue, value))
	bar.value = value
end

function SliderMenu:draw(fadeProgress)

	dxDrawRectangle(0, 0, self.resolution.x - self.ScreenX, ScreenY, tocolor(0, 0, 0, 125))

	local priceText = ""
	if self.price > 0 then
		priceText = "$" .. tostring(self.price)
	elseif self.price == 0 then
		priceText = exports.tunrc_Lang:getString("price_free")
	end
	dxDrawText(priceText, self.ScreenX, self.ScreenY, self.resolution.x - 20, self.ScreenY, tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]), 1, Assets.fonts.colorMenuPrice, "right", "center")

	local y = self.headerHeight
	local barWidth = self.resolution.x - self.barOffset * 4
	for i, bar in ipairs(self.bars) do
		local cursorSize = 5
		local r, g, b, a = 255, 255, 255, 255
		if i == self.activeBar then
			cursorSize = 10
			r, g, b = Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]
		else
			a = 200
		end

		-- Подпись
		dxDrawText(bar.text, self.ScreenX, self.ScreenY, self.ScreenX, self.ScreenY - self.labelHeight, tocolor(255, 255, 255, a), 1, Assets.fonts.menuLabel, "left", "center")
		y = y + self.labelHeight

		-- Полоса
		if i == self.activeBar then
			dxDrawRectangle(self.barOffset - 1, self.ScreenY - 1, barWidth + 2, self.barHeight + 2, tocolor(255, 255, 255, 255))
		end
		dxDrawRectangle(self.barOffset, self.ScreenY, barWidth, self.barHeight, tocolor(32, 30, 31))

		-- Ползунок
		local x = (barWidth) * (bar.value / bar.maxValue)
		x = self.barOffset + math.max(0, math.min(x, barWidth + cursorSize)) - cursorSize / 2
		dxDrawCircle(x, self.ScreenY + 2, cursorSize, 0, 360, tocolor(r, g, b), tocolor(r, g, b), 32)

		-- Значение
		dxDrawText(("%.1f"):format(bar.factor * bar.value), self.barOffset + barWidth, self.ScreenY, self.ScreenX, self.ScreenY + 50 + self.barHeight, tocolor(255, 255, 255, a), 1, Assets.fonts.componentItem, "center", "center")

		y = y + self.barHeight * 2
	end

end


function SliderMenu:update(deltaTime)
	self.super:update(deltaTime)
end

function SliderMenu:selectNextBar()
	self.activeBar = self.activeBar + 1
	if self.activeBar > #self.bars then
		self.activeBar = 1
	end
end

function SliderMenu:selectPreviousBar()
	self.activeBar = self.activeBar - 1
	if self.activeBar < 1 then
		self.activeBar = #self.bars
	end
end

function SliderMenu:increase(dt)
	local speedMul = 1
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	local bar = self.bars[self.activeBar]
	bar.value = bar.value + PARAM_CHANGE_SPEED * (bar.maxValue - bar.minValue) * speedMul * dt
	if bar.value > bar.maxValue then
		bar.value = bar.maxValue
	end
end

function SliderMenu:decrease(dt)
	local speedMul = 1
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	local bar = self.bars[self.activeBar]
	bar.value = bar.value - PARAM_CHANGE_SPEED * (bar.maxValue - bar.minValue) * speedMul * dt
	if bar.value < bar.minValue then
		bar.value = bar.minValue
	end
end
