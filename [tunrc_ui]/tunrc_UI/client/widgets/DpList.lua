--- Список
-- @module tunrc_UI.DpList

DpList = {}

local ITEM_HEIGHT = 45

function DpList.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget.text = exports.tunrc_Utils:defaultValue(properties.text, "")
	widget.hovertext = exports.tunrc_Utils:defaultValue(properties.hovertext, "")
	widget.alignX = exports.tunrc_Utils:defaultValue(properties.alignX, "center")
	widget.alignY = exports.tunrc_Utils:defaultValue(properties.alignY, "center")
	widget.items = exports.tunrc_Utils:defaultValue(properties.items, {})
	widget.columns = exports.tunrc_Utils:defaultValue(properties.columns, {})
	widget.activeItem = 1
	
	widget.darkToggle = properties.darkToggle
	widget.darkColor = properties.darkColor
	widget.hoverColor = properties.hoverColor
	widget.hoverDarkColor = properties.hoverDarkColor

	if not properties.colors then
		properties.colors = {}
	end
	widget.colors = {
		normal = properties.colors.normal or tocolor(0, 0, 0),
		hover = properties.colors.hover or tocolor(150, 150, 150),
		down = properties.colors.down or tocolor(255, 255, 255),
	}
	local textColor = "gray_dark"
	local textColorHover = "white"
	widget.font = Fonts.listItemText

	local backgroundColor1 = Colors.color("white")
	local backgroundColor2 = Colors.color("gray_lighter")

	function widget:draw()
		local y = self.y
		local itemY = 0
		for i, item in ipairs(self.items) do
			local isHover = isPointInRect(self.mouseX, self.mouseY, 0, itemY, self.width, ITEM_HEIGHT)
			-- Фон
			if isHover then
				self.activeItem = i
				if properties.darkToggle == true and exports.tunrc_Config:getProperty("ui.dark_mode") then 
					Drawing.setColor(properties.hoverDarkColor)
				else
					Drawing.setColor(properties.hoverColor)
				end
				Drawing.text(self.x, self.y + 20, self.width, self.height, self.hovertext, align, "center", true, false)
			else
				if properties.darkToggle == true and exports.tunrc_Config:getProperty("ui.dark_mode") then 
					Drawing.setColor(properties.darkColor)
				else
					Drawing.setColor(properties.color)
				end
			end
			Drawing.rectangle(self.x, y, self.width, ITEM_HEIGHT)

			-- Столбцы
			local x = self.x
			for j, column in ipairs(self.columns) do
				local columnText = tostring(item[j])
				local align = column.align or "center"
				local columnWidth = column.size * self.width
				if column.color and not isHover then
					Drawing.setColor(Colors.color(column.color))
				else
					local alpha = 255
					if column.alpha then
						local a = column.alpha
						if isHover then
							a = 1 - a
						end
						alpha = alpha * a
					end
					if properties.darkToggle == true and exports.tunrc_Config:getProperty("ui.dark_mode") then 
						Drawing.setColor(properties.color)
					else
						Drawing.setColor(properties.darkColor)
					end

				end
				local drawX = x
				if column.offset then
					drawX = drawX + self.width * column.offset
				end
				Drawing.text(drawX, y, columnWidth, ITEM_HEIGHT, columnText, align, "center", true, false)
				x = x + columnWidth
			end

			y = y + ITEM_HEIGHT
			itemY = itemY + ITEM_HEIGHT
		end
	end
	return widget
end
