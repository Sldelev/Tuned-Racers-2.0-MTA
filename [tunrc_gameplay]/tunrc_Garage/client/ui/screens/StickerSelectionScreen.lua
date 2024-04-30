StickerSelectionScreen = Screen:subclass "StickerSelectionScreen"

function StickerSelectionScreen:init(surface)
	self.super:init()	
	self.stickersGrid = StickersGrid()
	self.surface = surface
end

function StickerSelectionScreen:show()
	self.super:show()	
end

function StickerSelectionScreen:hide()
	self.super:hide()
	self.stickersGrid:destroy()
end

function StickerSelectionScreen:draw()
	self.super:draw()
	self.stickersGrid:draw(self.fadeProgress)
end

function StickerSelectionScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.stickersGrid:update(deltaTime)
end

function StickerSelectionScreen:onKey(key)
	self.super:onKey(key)

	if key == "enter" then
		local sticker = self.stickersGrid:getSelectedSticker()
		if not sticker then
			return
		end
		local surface = self.surface
		Garage.buy(sticker.price, sticker.level, function(success)
			if success then
				local screen = StickerEditorScreen(surface, true)
				self.screenManager:showScreen(screen)
				if sticker and sticker.id then
					screen:addSticker(sticker.id)
				end
			end
		end)
	elseif key == "backspace" then
		self.screenManager:showScreen(StickerEditorScreen(self.surface, true))
	end

	self.stickersGrid:onKey(key)
end