ItemsMenu = TuningMenu:subclass "ItemsMenu"

function ItemsMenu:init(items, position, rotation, forceItem)
	check("ItemsMenu:new", {
		{items, "table"},
		{position, "userdata"},
		{rotation, "number"},
	})
	self.items = items
	self.selectedItem = 1
	self.super:init(position, rotation, Vector2(1.4, 0.5 + 0.3 * #self.items + 0.15))
	self.x = 50

	self.itemRenderTarget = dxCreateRenderTarget(self.resolution.x, 70, false)

	if type(forceItem) == "number" then
		self.selectedItem = forceItem
	end

end

function ItemsMenu:onKey(key)
	local prev = self.selectedItem
	if key == "arrow_u" and self.selectedItem > 1 then
		self.selectedItem = self.selectedItem - 1
	elseif key == "arrow_u" and self.selectedItem == 1 then
		self.selectedItem = 3
	elseif key == "arrow_d" and self.selectedItem < 3 then
		self.selectedItem = self.selectedItem + 1
	elseif key == "arrow_d" and self.selectedItem == 3 then
		self.selectedItem = 1
	end
end

function ItemsMenu:getItem()
	return self.items[self.selectedItem]
end

function ItemsMenu:drawSelectedItem(fadeProgress)
	local itemWidth = self.resolution.x
	local itemHeight = 70
	dxDrawRoundedRectangle(self.x, y, itemWidth + 5, itemHeight + 5, tocolor(10, 10, 10, 150 * fadeProgress), 10)
	dxDrawText(exports.tunrc_Lang:getString(self.items[self.selectedItem]), self.x * 2, y * 2, itemWidth + 5, itemHeight + 5, tocolor(255, 255, 255, 255 * fadeProgress), 1, Assets.fonts.menu, "center", "center")
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

function ItemsMenu:draw(fadeProgress)
	y = 300
	-- Кнопки
	local itemWidth = self.resolution.x
	local itemHeight = 70
	for i, item in ipairs(self.items) do
		if i == self.selectedItem then
			self:drawSelectedItem(fadeProgress)
		else
			dxDrawRoundedRectangle(self.x, y, itemWidth, itemHeight, tocolor(10, 10, 10, 150 * fadeProgress), 10)
			dxDrawText(exports.tunrc_Lang:getString(item), self.x * 2, y, itemWidth, y + itemHeight, tocolor(100, 100, 100, 255 * fadeProgress), 1, Assets.fonts.menu, "center", "center")
		end
		y = y + itemHeight + 10
	end

end

function ItemsMenu:destroy()
	self.super:destroy()
	if isElement(self.itemRenderTarget) then
		destroyElement(self.itemRenderTarget)
	end
end

function ItemsMenu:update(deltaTime)

end