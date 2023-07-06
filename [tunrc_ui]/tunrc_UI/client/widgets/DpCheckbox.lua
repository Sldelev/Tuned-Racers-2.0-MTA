DpCheckbox = {}

function DpCheckbox.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget._type = "Checkbox"
	widget.state = false
	widget.colors = {
		normal = tocolor(0, 0, 0),
		hover = tocolor(150, 150, 150),
	}
	function widget:updateTheme()
		self.colors = {
			normal = Colors.color("primary"),
			hover = Colors.darken("primary", 15),
		}
	end
	local borderSize = 2
	local boxOffset = 5
	widget:updateTheme()

	function widget:draw()
		if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) then
			self.color = self.colors.hover
		else
			self.color = self.colors.normal
		end
		if self.state then
			Drawing.setColor(self.color)
		else
			Drawing.setColor(Colors.color("gray_dark"))
		end
		Drawing.rectangle(self.x, self.y, self.width, self.height)
		--Drawing.setColor(self.textColor)
	end
	return widget
end

addEvent("tunrc_UI.clickInternal", false)
addEventHandler("tunrc_UI.clickInternal", resourceRoot, function ()
	if Render.clickedWidget and Render.clickedWidget._type == "Checkbox" then
 		Render.clickedWidget.state = not Render.clickedWidget.state
 	end
end)