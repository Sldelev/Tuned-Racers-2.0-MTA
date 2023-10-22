Image = {}

function Image.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget.texture = properties.texture
	widget.rotation = properties.rotation
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
		if self.texture then
			Drawing.image(self.x, self.y, self.width, self.height, self.texture, self.rotation)
		end
	end
	return widget
end