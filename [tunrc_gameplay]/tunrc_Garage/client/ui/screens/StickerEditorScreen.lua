StickerEditorScreen = Screen:subclass "StickerEditorScreen"
local screenWidth, screenHeight = guiGetScreenSize()

local stickerControlKeys = {
	["q"] = {mode = "move", 	panelItem = 1}, 
	["w"] = {mode = "scale",	panelItem = 2}, 
	["e"] = {mode = "rotate", 	panelItem = 3}, 
	["r"] = {mode = "color", 	panelItem = 4}
}
local bodySides = {
	["Left"] = {reverse = true, ox = 1, oy = -1, px = 890, py = 512, rot = -90},
	["Right"] = {reverse = true, ox = -1, oy = 1, px = 110, py = 512, rot = 90},
	["Top"] = {reverse = false, ox = 1, oy = 1, px = 512, py = 512, rot = 0},
	["Front"] = {reverse = false, ox = 1, oy = 1, px = 512, py = 830, rot = 0},
	["Back"] = {reverse = false, ox = -1, oy = -1, px = 512, py = 150, rot = 180},
}
local STICKER_MOVE_SPEED = 150
local STICKER_SCALE_SPEED = 150
local STICKER_ROTATE_SPEED = 90
local SLOW_SPEED_MUL = 0.15
local FAST_SPEED_MUL = 3

function StickerEditorScreen:init(surface, saveCameraPosition)
	self.super:init()
	self.panel = TuningPanel({
		{icon = Assets.textures.stickersMoveIcon, text = exports.tunrc_Lang:getString("garage_sticker_editor_move"), key = "Q"},
		{icon = Assets.textures.stickersScaleIcon, text = exports.tunrc_Lang:getString("garage_sticker_editor_scale"), key = "W"},
		{icon = Assets.textures.stickersRotateIcon, text = exports.tunrc_Lang:getString("garage_sticker_editor_rotate"), key = "E"},
		{icon = Assets.textures.stickersColorIcon, text = exports.tunrc_Lang:getString("garage_sticker_editor_color"), key = "R"},
	})

	self.mode = "move"

	local screenSize = Vector2(exports.tunrc_UI:getScreenSize())
	self.colorPanel = ColorPanel(exports.tunrc_Lang:getString("garage_tuning_sticker_color"))
	self.colorPanel.x = -self.colorPanel.resolution.x
	self.colorPanel.y = screenSize.y / 2 - self.colorPanel.resolution.y / 1.5
	self.colorPanel.showPrice = false
	self.colorPanel.resolution = Vector2(300, 530)
	self.colorPanelX = -self.colorPanel.resolution.x
	self.renderTarget = exports.tunrc_UI:getRenderTarget()
	self.surface = surface

	CarTexture.setSurface(surface)
	CarTexture.unselectSticker()
	self.stickerPreview = StickerPreview()
	self:updateSelectedSticker()

	if not saveCameraPosition then
		CameraManager.setState("freeLookCamera", false, 5)
	end

	self.helpPanel = HelpPanel({
		{ keys = {"A"}, 				locale = "garage_sticker_editor_help_add" },
		{ keys = {"D"}, 				locale = "garage_sticker_editor_help_remove" },
		{ keys = {"C"}, 				locale = "garage_sticker_editor_help_clone"},
		{ keys = {"F"}, 				locale = "garage_sticker_editor_help_copy_style"},
		{ keys = {"G"}, 				locale = "garage_sticker_editor_help_copy_color"},
		{ keys = {"Q", "W", "E", "R"}, 	locale = "garage_sticker_editor_help_change_mode" },
		{ keys = {"ALT", "SHIFT"}, 		locale = "garage_sticker_editor_help_speed"},
		{ keys = {"CTRL"}, 				locale = "garage_sticker_editor_help_scale"},
		{ keys = {"controls_arrows"}, 	locale = "garage_sticker_editor_help_transform" },
		{ keys = {"1"}, 		locale = "garage_sticker_editor_help_mirroring"},
		{ keys = {"2"}, 		locale = "garage_sticker_editor_help_force_rotate"},
		{ keys = {"K", "L"}, 			locale = "garage_sticker_editor_help_next_prev"},		
		{ keys = {"Z"}, 				locale = "garage_sticker_editor_help_toggle"},
		{ keys = {"[", "]"}, 			locale = "garage_sticker_editor_help_change_slot"},
	})

	self:updateSide()
end

function StickerEditorScreen:draw()
	self.super:draw()
	self.panel:draw(self.fadeProgress)
	if CarTexture.getSelectedSticker() then
		dxSetRenderTarget(self.renderTarget)
		self.colorPanel:draw(self.fadeProgress)
		dxSetRenderTarget()
	end

	self.stickerPreview:draw(self.fadeProgress)
	self.helpPanel:draw(self.fadeProgress)
	
	if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
		textColor = tocolor(255, 255, 255, 255 * self.fadeProgress)
	else
		textColor = tocolor(0, 0, 0, 255 * self.fadeProgress)
	end

	dxDrawText(
		exports.tunrc_Lang:getString("garage_tuning_side_" .. string.lower(self.sideName)), 
		0, screenHeight - 100, 
		screenWidth - 15, screenHeight, 
		textColor, 
		1, 
		Assets.fonts.helpText,
		"right",
		"center"
	)

	if not CarTexture.getSelectedSticker() then
		return
	end
	y = 100
	
	dxDrawRoundedRectangle(
		25,
		25,
		225,
		125,
		5,
		255,
		false,
		false
	 )
	
	dxDrawText(
		exports.tunrc_Lang:getString("garage_tuning_sticker_info"), 
		35,
		-screenHeight + y, 
		screenWidth - 15,
		screenHeight, 
		textColor, 
		1, 
		Assets.fonts.helpText,
		"left",
		"center"
	)
	-- Инфо о повороте стикера
	y = y + 50
	dxDrawText(
		(exports.tunrc_Lang:getString("garage_tuning_sticker_info_rotate") .. ": " .. string.format('%.f',CarTexture.getStickerRotation())), 
		35,
		-screenHeight + y, 
		screenWidth - 15,
		screenHeight, 
		textColor, 
		1, 
		Assets.fonts.helpText,
		"left",
		"center"
	)
	-- Инфо о положении стикера x, y
	y = y + 50
	dxDrawText(
		(exports.tunrc_Lang:getString("garage_tuning_sticker_info_position") .. ": x: " .. string.format('%.f',CarTexture.getStickerPositionX()) .. ", y: " .. string.format('%.f',CarTexture.getStickerPositionY())), 
		35,
		-screenHeight + y, 
		screenWidth - 15,
		screenHeight, 
		textColor, 
		1, 
		Assets.fonts.helpText,
		"left",
		"center"
	)
	-- Инфо о размере стикера x, y
	y = y + 50
	dxDrawText(
		(exports.tunrc_Lang:getString("garage_tuning_sticker_info_scale") .. ": x: " .. string.format('%.f',CarTexture.getStickerScaleX()) .. ", y: " .. string.format('%.f',CarTexture.getStickerScaleY())), 
		35,
		-screenHeight + y, 
		screenWidth - 15,
		screenHeight, 
		textColor, 
		1, 
		Assets.fonts.helpText,
		"left",
		"center"
	)
end

function StickerEditorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.panel:update(deltaTime)
	self.helpPanel:update(deltaTime)
	self.colorPanel.x = self.colorPanel.x + (self.colorPanelX - self.colorPanel.x) * deltaTime * 20

	self:updateSide()

	if not isMTAWindowActive() then
		local transformX = 0
		local transformY = 0
		if getKeyState("arrow_r") then
			transformX = 1
		elseif getKeyState("arrow_l") then 
			transformX = -1
		end
		if getKeyState("arrow_u") then 
			transformY = -1
		elseif getKeyState("arrow_d") then 
			transformY = 1
		end

		-- Ускорение/замедление движения наклейки
		if getKeyState("lalt") then
			transformX = transformX * SLOW_SPEED_MUL
			transformY = transformY * SLOW_SPEED_MUL
		elseif getKeyState("lshift") then
			transformX = transformX * FAST_SPEED_MUL
			transformY = transformY * FAST_SPEED_MUL
		end

		if self.mode == "move" then
			if bodySides[self.sideName].reverse then
				transformX, transformY = transformY, transformX
			end
			transformX = transformX * bodySides[self.sideName].ox
			transformY = transformY * bodySides[self.sideName].oy			
			CarTexture.moveSticker(
				transformX * STICKER_MOVE_SPEED * deltaTime, 
				transformY * STICKER_MOVE_SPEED * deltaTime
			)
		elseif self.mode == "scale" then
			if getKeyState("lctrl") then
				CarTexture.resizeSticker(
					transformX * STICKER_SCALE_SPEED * deltaTime, 
					transformY * STICKER_SCALE_SPEED * deltaTime
				)
			else
				CarTexture.resizeSticker(
					transformY * STICKER_SCALE_SPEED * deltaTime, 
					transformY * STICKER_SCALE_SPEED * deltaTime
				)
			end
		elseif self.mode == "rotate" then
			CarTexture.rotateSticker(
				transformX * STICKER_ROTATE_SPEED * deltaTime
			)
		elseif self.mode == "color" then
			if transformX > 0 then
				self.colorPanel:increase(deltaTime)
				local color = tocolor(self.colorPanel:getColor())
				CarTexture.setStickerColor(color)
				self.stickerPreview:setStickerColor(color)
			elseif transformX < 0 then
				self.colorPanel:decrease(deltaTime)
				local color = tocolor(self.colorPanel:getColor())
				CarTexture.setStickerColor(color)
				self.stickerPreview:setStickerColor(color)
			end
		end
	end
end

function StickerEditorScreen:addSticker(id)
	if not CarTexture.canAddSticker() then
		return
	end
	CarTexture.addSticker(id, bodySides[self.sideName].px, bodySides[self.sideName].py, bodySides[self.sideName].rot)
	self:updateSelectedSticker()
	GarageCar.save()
end

function StickerEditorScreen:show()
	self.super:show()

	self:updateSide()
end

function StickerEditorScreen:hide()
	self.super:hide()

	CarTexture.unselectSticker()
	CarTexture.save()
end

function StickerEditorScreen:updateSide()
	self.sideName = "Left"
	local camRotX, camRotY = CameraManager.getRotation()
	if camRotX < 25 or camRotX > 335 then
		self.sideName = "Front"
	elseif camRotX > 25 and camRotX < 120 then
		self.sideName = "Left"
	elseif camRotX > 120 and camRotX < 200 then
		self.sideName = "Back"
	elseif camRotX > 200 and camRotX < 335 then
		self.sideName = "Right"
	end
	if camRotY > 32 and self.sideName == "Front" then
	--	self.sideName = "Top"
	end
end

function StickerEditorScreen:updateSelectedSticker()
	local sticker = CarTexture.getSelectedSticker()

	if sticker then
		self.stickerPreview:showSticker(sticker[5])
		self.stickerPreview:setStickerColor(CarTexture.getStickerColor())
		local x, y = sticker[1], sticker[2]
		local minDistance = 2048
		local minSide = "Left"
		for name, side in pairs(bodySides) do
			local distance = getDistanceBetweenPoints2D(side.px, side.py, x, y)
			if distance < minDistance then
				minDistance = distance
				minSide = name
			end
		end
		--self.sideName = minSide
		--CameraManager.setState("side" .. tostring(self.sideName), false, 4)

		local stickerColor = CarTexture.getStickerColor()
		if stickerColor then
			local r, g, b, a = fromColor(CarTexture.getStickerColor())
			if r then
				self.colorPanel:setColor(r, g, b, a)
			end
		end
	else
		self.stickerPreview:hideSticker()
	end
end

function StickerEditorScreen:onKey(key)
	self.super:onKey(key)

	if key == "backspace" then
		GarageCar.save()
		CarTexture.reset()
		self.screenManager:showScreen(StickersSideScreen())
	elseif key == "z" then
		self.helpPanel:toggle()
	elseif key == "f" then
		CarTexture.copyPreviousStickerStyle()
	elseif key == "1" then
		CarTexture.toggleStickerMirroring()
		exports.tunrc_Sounds:playSound("ui_change.wav")
	elseif key == "enter" then
		CarTexture.unselectSticker()
		self:updateSelectedSticker()
	elseif key == "a" then
		if not CarTexture.canAddSticker() then
			exports.tunrc_Sounds:playSound("error.wav")
			return
		end
		self.screenManager:showScreen(StickerSelectionScreen(self.surface))
		exports.tunrc_Sounds:playSound("ui_select.wav")
	elseif key == "d" or key == "delete" then
		CarTexture.removeSticker()
		self:updateSelectedSticker()
		GarageCar.save()
	elseif key == "k" then
		CarTexture.selectPreviousSticker()
		self:updateSelectedSticker()
	elseif key == "l" then
		CarTexture.selectNextSticker()
		self:updateSelectedSticker()
	elseif key == "c" then
		if not CarTexture.canAddSticker() then
			exports.tunrc_Sounds:playSound("error.wav")
			return
		end		
		CarTexture.cloneSticker()
		self:updateSelectedSticker()
	elseif key == "[" then
		CarTexture.moveStickerSlotDown()
		self:updateSelectedSticker()
	elseif key == "]" then
		CarTexture.moveStickerSlotUp()
		self:updateSelectedSticker()
	elseif key == "g" then
		CarTexture.copyPreviousStickerColor()
	elseif key == "2" then	
		CarTexture.forceRotateSticker()
	else
		for name, v in pairs(stickerControlKeys) do
			if key == name then
				exports.tunrc_Sounds:playSound("ui_change.wav")
				self.panel:setActiveItem(v.panelItem)
				self.mode = v.mode

				if self.mode == "color" then
					self.colorPanelX = 20

					local stickerColor = CarTexture.getStickerColor()
					if stickerColor then
						local r, g, b, a = fromColor(CarTexture.getStickerColor())
						self.colorPanel:setColor(r, g, b, a)
					end
				else
					self.colorPanelX = -self.colorPanel.resolution.x - 20
				end
			end
		end
	end

	if self.mode == "color" then
		if key == "arrow_u" then
			self.colorPanel:selectPreviousBar()
		elseif key == "arrow_d" then
			self.colorPanel:selectNextBar()
		end
	end
end