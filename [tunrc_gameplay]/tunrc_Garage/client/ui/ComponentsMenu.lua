local ITEM_WIDTH = 1.2
local ITEM_HEIGHT = 0.24
local screenSize = Vector2(guiGetScreenSize())

MenuItem = TuningMenu:subclass "MenuItem"

function MenuItem:init(position, rotation, items)
	self.super:init(position, rotation, Vector2(ITEM_WIDTH, ITEM_HEIGHT))
	
	self.alpha = 255
	
	self.price = 0
	self.name = ""
	self.level = 0
	
	self.x = screenSize.x / 2
	self.y = screenSize.y - 75
	self.width = 150
	self.height = 150
	
	offset = 20
	
	self.items = items
	self.activeItem = 1
	
	hachi_icon = dxCreateTexture( "assets/images/icons/components_icons/hachi_icon.png", "dxt5", false, "clamp" )
	tebino_icon = dxCreateTexture( "assets/images/icons/components_icons/tebino_icon.png", "dxt5", false, "clamp" )
	nagasa_icon = dxCreateTexture( "assets/images/icons/components_icons/nagasa_icon.png", "dxt5", false, "clamp" )
	kaoki_icon = dxCreateTexture( "assets/images/icons/components_icons/kaoki_icon.png", "dxt5", false, "clamp" )
	trc_icon = dxCreateTexture( "assets/images/icons/components_icons/trc_icon.png", "dxt5", false, "clamp")
	zerino_icon = dxCreateTexture( "assets/images/icons/components_icons/zerino_icon.png", "dxt5", false, "clamp")
	
end

function MenuItem:draw(fadeProgress)
	self.super:draw(fadeProgress)
	local textAlpha = self.alpha
	local priceColor = tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], self.alpha)
	local levelColor = tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], self.alpha)
	if self.price > localPlayer:getData("money") then
		available = false
		textAlpha = textAlpha * 0.25
		priceColor = tocolor(255, 255, 255, textAlpha)
	end
	
	x =  (self.x - (self.width / 2)) + -self.activeItem * 175
	-- отрисовка компонентов
	for i, item in pairs(self.items) do
		if i == self.activeItem then
			alpha = 255
		else
			alpha = 50
		end
		
		dxDrawRoundedRectangle(
			x + (i * 175),
			screenSize.y - (self.height + 25),
			self.width,
			self.height,
			15,
			alpha*fadeProgress,
			false,
			false,
			true
		)
		-- отрисовка иконки компонента
		if string.find(item.name, "Hachi") then
			dxDrawImage(
				(x + 100 - self.width / 2) + (i * 175),
				screenSize.y - (self.height),
				100,
				50,
				hachi_icon,
				0,
				0,
				0,
				tocolor(255,255,255,alpha*fadeProgress)
			)
		elseif	string.find(item.name, "Tebino") then
			dxDrawImage(
				(x + 100 - self.width / 2) + (i * 175),
				screenSize.y - (self.height),
				100,
				50,
				tebino_icon,
				0,
				0,
				0,
				tocolor(255,255,255,alpha*fadeProgress)
			)
		elseif	string.find(item.name, "Nagasa") then
			dxDrawImage(
				(x + 100 - self.width / 2) + (i * 175),
				screenSize.y - (self.height),
				100,
				50,
				nagasa_icon,
				0,
				0,
				0,
				tocolor(255,255,255,alpha*fadeProgress)
			)
		elseif	string.find(item.name, "Kaoki") then
			dxDrawImage(
				(x + 100 - self.width / 2) + (i * 175),
				screenSize.y - (self.height),
				100,
				50,
				kaoki_icon,
				0,
				0,
				0,
				tocolor(255,255,255,alpha*fadeProgress)
			)
		elseif string.find(item.name, "Сток") or string.find(item.name, "Default") then
			dxDrawImage(
				(x + 100 - self.width / 2) + (i * 175),
				screenSize.y - (self.height),
				100,
				50,
				trc_icon,
				0,
				0,
				0,
				tocolor(255,255,255,alpha*fadeProgress)
			)
		elseif string.find(item.name, "Zerino") then
			dxDrawImage(
				(x + 100 - self.width / 2) + (i * 175),
				screenSize.y - (self.height),
				100,
				50,
				zerino_icon,
				0,
				0,
				0,
				tocolor(255,255,255,alpha*fadeProgress)
			)
		end
		
		TrcDrawText(
			tostring(item.name),
			x + (i * 175),
			self.y + 30,
			(x + self.width) + (i * 175),
			self.y,
			alpha * fadeProgress,
			self.font,
			"center",
			"center",
			0.5,
			false,
			true
		)
		
		--[[dxDrawText(tostring(item.name), 10, y, self.resolution.x * 0.6, self.resolution.y, textColor, 1, Assets.fonts.componentItem, "left", "center")]]
		
		if item.price >= 0 then
			local priceText = ""
			if item.price > 0 then
				priceText = "$" .. tostring(item.price)
			else
				priceText = exports.tunrc_Lang:getString("price_free")
			end
			TrcDrawText(
				priceText,
				x + (i * 175),
				self.y - 15,
				(x + self.width + 40) + (i * 175),
				self.y,
				alpha * fadeProgress,
				self.font,
				"center",
				"center",
				0.5,
				false,
				true
			)
		end
		
		if item.level > 0 then
			--dxDrawText("★" .. tostring(item.level), self.resolution.x + 75, y, self.resolution.x, self.resolution.y, textColor, 1, Assets.fonts.componentItemInfo, "center", "center")
			TrcDrawText(
				"★" .. tostring(item.level),
				x + (i * 175),
				self.y - 15,
				(x + self.width - 40) + (i * 175),
				self.y,
				alpha * fadeProgress,
				self.font,
				"center",
				"center",
				0.5,
				false,
				true
			)
		end
	end
end

function MenuItem:update(dt)	
end

function MenuItem:selectNextItem()
	self.activeItem = self.activeItem + 1
	if self.activeItem > #self.items then
		self.activeItem = 1
	end
	return true
end

function MenuItem:selectPreviousItem()
	self.activeItem = self.activeItem - 1
	if self.activeItem < 1 then
		self.activeItem = #self.items
	end
	return true
end

function MenuItem:setActiveItem(vehActiveItem)
	self.activeItem = vehActiveItem
end
