StickerPreview = newclass "StickerPreview"

function StickerPreview:init()
	local screenSize = Vector2(exports.tunrc_UI:getScreenSize())
	self.renderTarget = exports.tunrc_UI:getRenderTarget()
	self.width = 160
	self.height = 160
	self.headerHeight = 35
	self.stickerCountHeight = 45
	self.labelHeight = 30
	self.x = screenSize.x  - self.width - 20
	self.y = screenSize.y / 2 - self.height / 2

	self.texture = false
	self.stickerColor = tocolor(255, 255, 255)
	self.stickerScale = 0.7
end

function StickerPreview:draw(fadeProgress)
	dxSetRenderTarget(self.renderTarget)
	dxSetBlendMode("modulate_add")
	local stickerCount = CarTexture.getStickerCount()
	local maxStickerCount = CarTexture.getMaxStickerCount()	
	local StickerBarColor = tocolor(130, 130, 200, 255*fadeProgress)
	
	if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
		SidePanelsColor = tocolor(30, 30, 30, 255*fadeProgress)
		CenterPanelColor = tocolor(40, 40, 40, 255*fadeProgress)
	else
		SidePanelsColor = tocolor(235, 235, 235, 255*fadeProgress)
		CenterPanelColor = tocolor(225, 225, 225, 255*fadeProgress)
	end
	
	dxDrawRoundedRectangle(
		self.x,
		self.y - self.stickerCountHeight - self.headerHeight - 5,
		self.width,
		self.stickerCountHeight + self.width + self.headerHeight + self.labelHeight + 75,
		10,
		255*fadeProgress,
		false,
		false
	 )
	 
	TrcDrawText(
		("%d/%d"):format(stickerCount, maxStickerCount),
		self.x,
		self.y - self.stickerCountHeight - self.headerHeight - 5,
		self.x + self.width,
		self.y - self.headerHeight - 5,
		255 * fadeProgress,
		Assets.fonts.tuningPanelText
	)
	local themeColor = {exports.tunrc_UI:getThemeColor()}
	-- sticker limit bar
	if stickerCount > 0 then
		dxDrawRectangle(self.x, self.y - self.headerHeight - 10, self.width * (stickerCount / maxStickerCount), 5, StickerBarColor, false, true)
		
		-- next
		dxDrawRectangle(self.x, self.y - self.headerHeight, self.width, self.headerHeight, SidePanelsColor)
		TrcDrawText(
			string.format(exports.tunrc_Lang:getString("garage_tuning_sticker_next"), "L"),
			self.x,
			self.y - self.headerHeight,
			self.x + self.width,
			self.y,
			255 * fadeProgress,
			Assets.fonts.stickerPreviewHelp
		)
		dxDrawRectangle(self.x, self.y, self.width, self.height, CenterPanelColor)
		dxDrawRectangle(self.x, self.y + self.height, self.width, self.headerHeight, SidePanelsColor)
		TrcDrawText(
			string.format(exports.tunrc_Lang:getString("garage_tuning_sticker_prev"), "K"),
			self.x,
			self.y + self.height,
			self.x + self.width,
			self.y + self.height + self.headerHeight,
			255 * fadeProgress,
			Assets.fonts.stickerPreviewHelp
		)

		local y = self.y + self.height + self.headerHeight
		local c = 255
		local isMirroringEnabled = exports.tunrc_Lang:getString("garage_tuning_sticker_mirroring_" .. (CarTexture.getMirroringMode() or "disabled"))
		TrcDrawText(
			string.format(exports.tunrc_Lang:getString("garage_tuning_sticker_mirrormode")),
			self.x,
			y,
			self.x + self.width,
			y + self.labelHeight,
			255 * fadeProgress,
			Assets.fonts.stickerPreviewHelp
		)
		
		TrcDrawText(
			isMirroringEnabled,
			self.x,
			y + 50,
			self.x + self.width,
			y + self.labelHeight,
			255 * fadeProgress,
			Assets.fonts.stickerPreviewHelp
		)

		-- sticker
		local x = self.x + self.width * (1 - self.stickerScale) / 2
		local y = self.y + self.height * (1 - self.stickerScale) / 2
		if self.texture then
			dxDrawImage(x + 2, y + 2, self.width * self.stickerScale, self.height * self.stickerScale, self.texture, 0, 0, 0, tocolor(0,0,0,50))
			dxDrawImage(x, y, self.width * self.stickerScale, self.height * self.stickerScale, self.texture, 0, 0, 0, bitReplace(self.stickerColor, math.floor(255 * fadeProgress), 24, 8))
		end

		-- sticker index
		local stickerIndex = CarTexture.getSelectedStickerIndex()
		if not stickerIndex then
			stickerIndex = 0
		end
		TrcDrawText(
			tostring(stickerIndex),
			self.x,
			self.y + self.height - 25,
			self.x + self.width,
			self.y + self.height,
			255 * fadeProgress,
			Assets.fonts.stickerPreviewHelp
		)
	end
	dxSetBlendMode("blend")
	dxSetRenderTarget()
end

function StickerPreview:setStickerColor(color)
	if color then
		self.stickerColor = color
	end
end

function StickerPreview:showSticker(stickerId)
	if stickerId then
		self.texture = Assets.loadSticker(stickerId)
	end
end

function StickerPreview:hideSticker()
	self.texture = false
end
