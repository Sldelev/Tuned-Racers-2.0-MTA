PaintAddMenu = TuningMenu:subclass "PaintAddMenu"

local ScreenX,ScreenY = guiGetScreenSize()

local PARAM_CHANGE_SPEED = 1
local SLOW_SPEED_MUL = 0.14

function PaintAddMenu:init(headerText, position, rotation, bars)
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

function PaintAddMenu:getValue()
	return self.bars[self.activeBar].value
end

function PaintAddMenu:setValue(value)
	if type(value) ~= "number" then
		return false
	end
	local bar = self.bars[self.activeBar]
	value = math.min(bar.maxValue, math.max(bar.minValue, value))
	bar.value = value
end

function PaintAddMenu:draw(fadeProgress)

	local priceText = ""
	if self.price > 0 then
		priceText = "$" .. tostring(self.price)
	elseif self.price == 0 then
		priceText = exports.tunrc_Lang:getString("price_free")
	end

	local y = self.headerHeight
	local barWidth = self.resolution.x - self.barOffset * 4
	for i, bar in ipairs(self.bars) do
		local cursorSize = 5
		
		dxDrawRoundedRectangle(
			self.ScreenX - 10,
			15 - self.headerHeight + 10 + (i * 100),
			self.resolution.x - 10,
			self.labelHeight + self.headerHeight,
			15,
			255*fadeProgress,
			false,
			false,
			true,
			false
		)

		TrcDrawText(
			priceText,
			self.ScreenX,
			15 + (i * 100),
			self.resolution.x - 20,
			15 + (i * 100),
			255*fadeProgress,
			Assets.fonts.colorMenuPrice,
			"right",
			"center"
		)

		-- Подпись
		TrcDrawText(
			bar.text,
			self.ScreenX,
			15 + (i * 100),
			self.ScreenX,
			15 - self.labelHeight + (i * 100),
			255*fadeProgress,
			Assets.fonts.menuLabel,
			"left",
			"center"
		)
		y = y + self.labelHeight

		-- Полоса
		if i == self.activeBar then
			dxDrawRoundedRectangle(
				self.barOffset - 1,
				15 - 1 + (i * 100),
				barWidth + 2,
				self.barHeight + 2,
				1,
				255*fadeProgress,
				false,
				false,
				true,
				true
			)
		end
		dxDrawRoundedRectangle(
			self.barOffset,
			15 + (i * 100),
			barWidth,
			self.barHeight,
			1,
			255*fadeProgress,
			false,
			false,
			true,
			false
		)

		-- Ползунок
		local x = (barWidth) * (bar.value / bar.maxValue)
		x = self.barOffset + math.max(0, math.min(x, barWidth + cursorSize)) - cursorSize / 2
		dxDrawCircle(x, 15 + 2 + (i * 100), cursorSize, 0, 360, tocolor(130, 130, 200, 255*fadeProgress), tocolor(130, 130, 200, 255*fadeProgress), 32)

		-- Значение
		TrcDrawText(
			("%.1f"):format(bar.factor * bar.value),
			self.barOffset + barWidth,
			15 + (i * 100),
			self.ScreenX,
			15 + 50 + self.barHeight + (i * 100),
			255*fadeProgress,
			Assets.fonts.componentItem
		)

		y = y + self.barHeight * 2
	end

end


function PaintAddMenu:update(deltaTime)
	self.super:update(deltaTime)
end

function PaintAddMenu:selectNextBar()
	self.activeBar = self.activeBar + 1
	if self.activeBar > #self.bars then
		self.activeBar = 1
	end
end

function PaintAddMenu:selectPreviousBar()
	self.activeBar = self.activeBar - 1
	if self.activeBar < 1 then
		self.activeBar = #self.bars
	end
end

function PaintAddMenu:increase(dt)
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

function PaintAddMenu:decrease(dt)
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