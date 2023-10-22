Circle = {}

function Circle.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget.radius = properties.radius

	function widget:draw()
		Drawing.circle(self.x, self.y, self.radius)
	end
	return widget
end