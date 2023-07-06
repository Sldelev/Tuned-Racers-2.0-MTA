CarNamePanel = TuningMenu:subclass "CarNamePanel"


function CarNamePanel:init(position, rotation, bars)
	self.super:init(position, rotation, Vector2(5.5, 0.5))
	self.headerHeight = 70
	self.text = "Vehicle Name"

	self.labelHeight = 0

	self.barHeight = 20
	self.barOffset = 20

	self.bars = {
		{text = labelText, value = 0},
	}
	self.activeBar = 1
	self.price = 0
end

function CarNamePanel:getValue()
	return self.bars[self.activeBar].value
end

function CarNamePanel:setValue(value)
	if type(value) ~= "number" then
		return false
	end
	value = math.min(1, math.max(0, value))
	self.bars[self.activeBar].value = value
end

function CarNamePanel:draw(fadeProgress)
	dxDrawText(self.text, 3, 3, self.resolution.x, self.resolution.y, tocolor(10, 10, 10), 0.5, Assets.fonts.carNameText, "center", "center")
	dxDrawText(self.text, 0, 0, self.resolution.x, self.resolution.y, tocolor(255, 255, 255), 0.5, Assets.fonts.carNameText, "center", "center")
end


function CarNamePanel:update(deltaTime)
	self.super:update(deltaTime)
end
