ComponentPosRotMenu = TuningMenu:subclass "ComponentPosRotMenu"

local PARAM_CHANGE_SPEED = 1
local SLOW_SPEED_MUL = 0.14
local ScreenX,ScreenY = guiGetScreenSize()

function ComponentPosRotMenu:init(headerText, position, rotation)
	self.super:init(position, rotation, Vector2(1.4, 1.1))
	self.headerHeight = 70
	self.headerText = headerText

	self.labelHeight = 50
	
	self.ScreenX = ScreenX * 0.01
	self.ScreenY = ScreenY / 4

	self.barHeight = 4
	self.barOffset = 20

	self.bars = {
		{text = exports.tunrc_Lang:getString("garage_tuning_component_config_pos_x"), value = 0, factor = 1, minValue = -1, maxValue = 5},
		{text = exports.tunrc_Lang:getString("garage_tuning_component_config_pos_y"), value = 0, factor = 1, minValue = -1, maxValue = 5},
		{text = exports.tunrc_Lang:getString("garage_tuning_component_config_pos_z"), value = 0, factor = 1, minValue = -1, maxValue = 5},
		{text = exports.tunrc_Lang:getString("garage_tuning_component_config_rot_x"), value = 0, factor = 1, minValue = 0, maxValue = 360},
		{text = exports.tunrc_Lang:getString("garage_tuning_component_config_rot_y"), value = 0, factor = 1, minValue = 0, maxValue = 360},
		{text = exports.tunrc_Lang:getString("garage_tuning_component_config_rot_z"), value = 0, factor = 1, minValue = 0, maxValue = 360},
	}
	self.activeBar = 1
	self.price = 0
	
end

function ComponentPosRotMenu:getBarValue()
	return self.activeBar, self.bars[self.activeBar].value
end

function ComponentPosRotMenu:draw(fadeProgress)
	dxDrawRoundedRectangle(
		self.ScreenX - 10,
		15 + self.headerHeight - self.labelHeight,
		self.resolution.x - 10,
		self.resolution.y + self.headerHeight + self.labelHeight * 5 + 60,
		15,
		255*fadeProgress,
		false,
		false,
		true,
		false
	)
	
	local y = self.headerHeight
	local barWidth = self.resolution.x - self.barOffset * 4
	for i, bar in ipairs(self.bars) do
		local cursorSize = 5
		
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


function ComponentPosRotMenu:update(deltaTime)
	self.super:update(deltaTime)
end

function ComponentPosRotMenu:selectNextBar()
	self.activeBar = self.activeBar + 1
	if self.activeBar > #self.bars then
		self.activeBar = 1
	end
end

function ComponentPosRotMenu:selectPreviousBar()
	self.activeBar = self.activeBar - 1
	if self.activeBar < 1 then
		self.activeBar = #self.bars
	end
end

function ComponentPosRotMenu:increase(dt)
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

function ComponentPosRotMenu:decrease(dt)
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
