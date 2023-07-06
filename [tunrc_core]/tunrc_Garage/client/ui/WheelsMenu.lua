WheelsMenu = TuningMenu:subclass "WheelsMenu"

local PARAM_CHANGE_SPEED = 1
local SLOW_SPEED_MUL = 0.14
local ScreenX,ScreenY = guiGetScreenSize()

function WheelsMenu:init(headerText, position, rotation)
	self.super:init(position, rotation, Vector2(1.4, 1.1))
	self.headerHeight = 70
	self.headerText = headerText

	self.labelHeight = 50
	
	self.ScreenX = ScreenX * 0.01
	self.ScreenY = ScreenY / 4

	self.barHeight = 4
	self.barOffset = 20

	self.bars = {
		{text = exports.tunrc_Lang:getString("garage_tuning_config_wheels_offset"), value = 0},
		{text = exports.tunrc_Lang:getString("garage_tuning_config_wheels_angle"), value = 0},
		{text = exports.tunrc_Lang:getString("garage_tuning_config_wheels_width"), value = 0},
	}
	self.activeBar = 1
	self.price = 0
end

function WheelsMenu:getBarValue()
	return self.activeBar, self.bars[self.activeBar].value
end

function WheelsMenu:draw(fadeProgress)
	dxDrawRectangle(0, 0, self.resolution.x - self.ScreenX, ScreenY, tocolor(0, 0, 0, 125))

	local priceText = ""
	if self.price > 0 then
		priceText = "$" .. tostring(self.price)
	elseif self.price == 0 then
		priceText = exports.tunrc_Lang:getString("price_free")
	end
	dxDrawText(priceText, self.ScreenX, self.ScreenY, self.resolution.x - 20, self.ScreenY + 150, tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]), 1, Assets.fonts.colorMenuPrice, "right", "center")

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
		dxDrawText(bar.text, self.ScreenX, self.ScreenY + (i * 100), self.ScreenX, self.ScreenY - self.labelHeight + (i * 100), tocolor(255, 255, 255, a), 1, Assets.fonts.menuLabel, "left", "center")
		y = y + self.labelHeight

		-- Полоса
		if i == self.activeBar then
			dxDrawRectangle(self.barOffset - 1, self.ScreenY - 1 + (i * 100), barWidth + 2, self.barHeight + 2, tocolor(255, 255, 255, 255))
		end
		dxDrawRectangle(self.barOffset, self.ScreenY + (i * 100), barWidth, self.barHeight, tocolor(32, 30, 31))

		-- Ползунок
		local x = (barWidth) * bar.value
		x = self.barOffset + math.max(0, math.min(x, barWidth + cursorSize)) - cursorSize / 2
		dxDrawCircle(x, self.ScreenY + 2 + (i * 100), cursorSize, 0, 360, tocolor(r, g, b), tocolor(r, g, b), 32)

		-- Значение
		dxDrawText(("%.1f"):format(100 * bar.value), self.barOffset + barWidth, self.ScreenY + (i * 100), self.ScreenX, self.ScreenY + 50 + self.barHeight + (i * 100), tocolor(255, 255, 255, a), 1, Assets.fonts.componentItem, "center", "center")

		y = y + self.barHeight * 2
	end
end


function WheelsMenu:update(deltaTime)
	self.super:update(deltaTime)
end

function WheelsMenu:selectNextBar()
	self.activeBar = self.activeBar + 1
	if self.activeBar > #self.bars then
		self.activeBar = 1
	end
end

function WheelsMenu:selectPreviousBar()
	self.activeBar = self.activeBar - 1
	if self.activeBar < 1 then
		self.activeBar = #self.bars
	end
end

function WheelsMenu:increase(dt)
	local speedMul = 1
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	self.bars[self.activeBar].value = self.bars[self.activeBar].value + PARAM_CHANGE_SPEED * speedMul * dt
	if self.bars[self.activeBar].value > 1 then
		self.bars[self.activeBar].value = 1
	end
end

function WheelsMenu:decrease(dt)
	local speedMul = 1
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end
	self.bars[self.activeBar].value = self.bars[self.activeBar].value - PARAM_CHANGE_SPEED * speedMul * dt
	if self.bars[self.activeBar].value < 0 then
		self.bars[self.activeBar].value = 0
	end
end
