TrcRoundedRectangle = {}

function TrcRoundedRectangle.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget.radius = properties.radius
	widget.hover = properties.hover
	widget.hoverColor = properties.hoverColor
	widget.darkToggle = properties.darkToggle
	widget.darkColor = properties.darkColor
	widget.hoverDarkColor = properties.hoverDarkColor
	function widget:draw()
		if exports.tunrc_Config:getProperty("ui.dark_mode") and properties.darkToggle == true then
			if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) and properties.hover == true then
				self.color = properties.hoverDarkColor or tocolor(10,10,10)
			else
				self.color = properties.darkColor
			end
		else
			if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) and properties.hover == true then
				self.color = properties.hoverColor or tocolor(105,105,105)
			else
				self.color = properties.color
			end
		end
		Drawing.rectangle(self.x + self.radius, self.y + self.radius, self.width - (self.radius*2), self.height - (self.radius*2))
		Drawing.nonCircle(self.x + self.radius, self.y + self.radius, self.radius, 180, 270)
		Drawing.nonCircle(self.x + self.radius, (self.y + self.height) - self.radius, self.radius, 90, 180)
		Drawing.nonCircle((self.x + self.width) - self.radius, (self.y + self.height) - self.radius, self.radius, 0, 90)
		Drawing.nonCircle((self.x + self.width) - self.radius, self.y + self.radius, self.radius, 270, 360)
		Drawing.rectangle(self.x, self.y + self.radius, self.radius, self.height - (self.radius*2))
		Drawing.rectangle(self.x + self.radius, self.y + self.height-self.radius, self.width-(self.radius*2), self.radius)
		Drawing.rectangle(self.x + self.width - self.radius, self.y + self.radius, self.radius, self.height - (self.radius*2))
		Drawing.rectangle(self.x + self.radius, self.y, self.width - (self.radius*2), self.radius)
	end
	return widget
end