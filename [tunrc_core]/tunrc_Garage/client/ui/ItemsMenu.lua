ItemsMenu = TuningMenu:subclass "ItemsMenu"

function ItemsMenu:init(items, position, rotation, forceItem)
	check("ItemsMenu:new", {
		{items, "table"},
		{position, "userdata"},
		{rotation, "number"},
	})
	self.items = items
	self.selectedItem = 1
	self.super:init(position, rotation, Vector2(0.25, 0.25))
	self.x = 50
	self.carNametext = ""

	self.itemRenderTarget = dxCreateRenderTarget(self.resolution.x, 70, false)
	self.activeItemColor = Garage.themePrimaryColor

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
	if not self.itemRenderTarget then
		return
	end
	local itemWidth = self.resolution.x
	local itemHeight = self.resolution.y
	local itemOffset = math.cos(getTickCount() / 200) * 3
	if self.items[self.selectedItem] == "garage_menu_go_city" then
		dxDrawImage ( self.x, y, itemWidth + itemOffset, itemHeight + itemOffset, Assets.textures.garage_menu_go_city, 0, 0, 0, tocolor(self.activeItemColor[1], self.activeItemColor[2], self.activeItemColor[3], 255 * fadeProgress) )
	elseif self.items[self.selectedItem] == "garage_menu_customize" then
		dxDrawImage ( self.x, y, itemWidth + itemOffset, itemHeight + itemOffset, Assets.textures.garage_menu_customize, 0, 0, 0, tocolor(self.activeItemColor[1], self.activeItemColor[2], self.activeItemColor[3], 255 * fadeProgress) )
	elseif self.items[self.selectedItem] == "garage_menu_sell" then
		dxDrawImage ( self.x, y, itemWidth + itemOffset, itemHeight + itemOffset, Assets.textures.garage_menu_sell, 0, 0, 0, tocolor(self.activeItemColor[1], self.activeItemColor[2], self.activeItemColor[3], 255 * fadeProgress) )
	end
	dxDrawText(exports.tunrc_Lang:getString(self.items[self.selectedItem]), self.x * 6 + itemOffset, y * 2, itemWidth + 5, itemHeight + 5, tocolor(255, 255, 255, 255 * fadeProgress), 1, Assets.fonts.menu, "center", "center")
end

function ItemsMenu:draw(fadeProgress)
	if not self.itemRenderTarget then
		return
	end
	y = 300
	-- Кнопки
	local itemWidth = self.resolution.x
	local itemHeight = self.resolution.y
	for i, item in ipairs(self.items) do
		if i == self.selectedItem then
			self:drawSelectedItem(fadeProgress)
		else
			if item == "garage_menu_go_city" then
				dxDrawImage ( self.x, y, itemWidth, itemHeight, Assets.textures.garage_menu_go_city, 0, 0, 0, tocolor(50,50,50, 255 * fadeProgress) )
			elseif item == "garage_menu_customize" then
				dxDrawImage ( self.x, y, itemWidth, itemHeight, Assets.textures.garage_menu_customize, 0, 0, 0, tocolor(50,50,50, 255 * fadeProgress) )
			elseif item == "garage_menu_sell" then
				dxDrawImage ( self.x, y, itemWidth, itemHeight, Assets.textures.garage_menu_sell, 0, 0, 0, tocolor(50,50,50, 255 * fadeProgress) )
			end
			dxDrawText(exports.tunrc_Lang:getString(item), self.x * 6, y * 2, itemWidth + 5, itemHeight + 5, tocolor(50, 50, 50, 255 * fadeProgress), 1, Assets.fonts.menu, "center", "center")
		end
		y = y + itemHeight + 10
	end
	
	dxDrawText(self.carNametext, self.x * 6 + 2, y / 1.2 + 2, itemWidth + 5, itemHeight + 5, tocolor(50, 50, 50, 255 * fadeProgress), 1, Assets.fonts.menu, "center", "center")
	dxDrawText(self.carNametext, self.x * 6, y / 1.2, itemWidth + 5, itemHeight + 5, tocolor(255, 255, 255, 255 * fadeProgress), 1, Assets.fonts.menu, "center", "center")

end

function ItemsMenu:destroy()
	self.super:destroy()
	if isElement(self.itemRenderTarget) then
		destroyElement(self.itemRenderTarget)
	end
end

function ItemsMenu:update(deltaTime)
	self.carNametext = exports.tunrc_Shared:getVehicleReadableName(GarageCar.getVehicleModel())
end