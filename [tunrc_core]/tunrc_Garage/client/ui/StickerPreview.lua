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
	dxDrawRectangle(self.x, self.y - self.stickerCountHeight - self.headerHeight - 5, self.width, self.stickerCountHeight, tocolor(32, 30, 31, 255 * fadeProgress))
	dxDrawText(("%d/%d"):format(stickerCount, maxStickerCount),
		self.x,
		self.y - self.stickerCountHeight - self.headerHeight - 5,
		self.x + self.width,
		self.y - self.headerHeight - 5,
		tocolor(255, 255, 255, 255 * fadeProgress),
		1,
		Assets.fonts.tuningPanelText,
		"center", "center"
	)
	local themeColor = {exports.tunrc_UI:getThemeColor()}
	-- sticker limit bar
	if stickerCount > 0 then
		dxDrawRectangle(self.x, self.y - self.headerHeight - 10, self.width * (stickerCount / maxStickerCount), 5, tocolor(themeColor[1], themeColor[2], themeColor[3], 255 * fadeProgress), false, true)
		-- next
		dxDrawRectangle(self.x, self.y - self.headerHeight, self.width, self.headerHeight, tocolor(32, 30, 31, 255 * fadeProgress))
		dxDrawText(
			string.format(exports.tunrc_Lang:getString("garage_tuning_sticker_next"), "L"),
			self.x,
			self.y - self.headerHeight,
			self.x + self.width,
			self.y,
			tocolor(255, 255, 255, 255 * fadeProgress),
			1,
			Assets.fonts.stickerPreviewHelp,
			"center", "center"
		)
		dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(42, 40, 41, 255 * fadeProgress))
		dxDrawRectangle(self.x, self.y + self.height, self.width, self.headerHeight, tocolor(32, 30, 31, 255 * fadeProgress))
		dxDrawText(
			string.format(exports.tunrc_Lang:getString("garage_tuning_sticker_prev"), "K"),
			self.x,
			self.y + self.height,
			self.x + self.width,
			self.y + self.height + self.headerHeight,
			tocolor(255, 255, 255, 255 * fadeProgress),
			1,
			Assets.fonts.stickerPreviewHelp,
			"center", "center"
		)

		local y = self.y + self.height + self.headerHeight
		local c = 255
		local isMirroringEnabled = exports.tunrc_Lang:getString("garage_tuning_sticker_mirroring_" .. (CarTexture.getMirroringMode() or "disabled"))
		dxDrawText(
			string.format(exports.tunrc_Lang:getString("garage_tuning_sticker_mirrormode")),
			self.x,
			y,
			self.x + self.width,
			y + self.labelHeight,
			tocolor(c, c, c, 255 * fadeProgress),
			1,
			Assets.fonts.stickerPreviewHelp,
			"left", "center"
		)
		
		dxDrawText(
			isMirroringEnabled,
			self.x,
			y + 50,
			self.x + self.width,
			y + self.labelHeight,
			tocolor(c, c, c, 255 * fadeProgress),
			1,
			Assets.fonts.stickerPreviewHelp,
			"left", "center"
		)

		-- sticker
		local x = self.x + self.width * (1 - self.stickerScale) / 2
		local y = self.y + self.height * (1 - self.stickerScale) / 2
		if self.texture then
			dxDrawImage(x, y, self.width * self.stickerScale, self.height * self.stickerScale, self.texture, 0, 0, 0, bitReplace(self.stickerColor, math.floor(255 * fadeProgress), 24, 8))
		end

		-- sticker index
		local stickerIndex = CarTexture.getSelectedStickerIndex()
		dxDrawText(tostring(stickerIndex),
			self.x,
			self.y + self.height - 25,
			self.x + self.width,
			self.y + self.height,
			tocolor(255, 255, 255, 255 * fadeProgress),
			1,
			Assets.fonts.stickerPreviewHelp,
			"center", "center"
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
