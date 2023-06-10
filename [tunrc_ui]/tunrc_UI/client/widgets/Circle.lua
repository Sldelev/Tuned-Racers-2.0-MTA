Circle = {}

function Circle.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)

	function widget:draw()
		Drawing.circle(self.x, self.y, self.width, self.height, self.radius)
	end
	return widget
end