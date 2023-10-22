NonCircle = {}

function NonCircle.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget.radius = properties.radius
	widget.startangle = properties.startangle
	widget.endangle = properties.endangle
	widget.darkToggle = properties.darkToggle
	widget.darkColor = properties.darkColor
	function widget:draw()	
		if exports.tunrc_Config:getProperty("ui.dark_mode") and properties.darkToggle == true then	
			self.color = properties.darkColor
		else
			self.color = properties.color
		end
	
		Drawing.nonCircle(self.x, self.y, self.radius, self.startangle, self.endangle)
	end
	return widget
end