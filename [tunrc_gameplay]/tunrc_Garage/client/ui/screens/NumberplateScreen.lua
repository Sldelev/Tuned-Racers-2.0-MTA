-- Экран смены номерного знака

NumberplateScreen = Screen:subclass "NumberplateScreen"

local MAX_NUMBERPLATE_TEXT_LENGTH = 7

local allowedLetters = "abcdefghijklmnopqrstuvwxyz0123456789"

function NumberplateScreen:init()
	self.super:init()
	local screenSize = Vector2(guiGetScreenSize())
	self.width = 200
	self.height = 75
	self.x = screenSize.x / 2
	self.y = screenSize.y - 130

	self.numberplateText = GarageCar.getVehicle():getData("Numberplate")
	if type(self.numberplateText) ~= "string" then
		self.numberplateText = "unknown"
	end
	CameraManager.setState("previewNumberplate", false, 3)
	guiSetInputMode("no_binds")
	
	self.helpPanel = HelpPanel({
		{ keys = {"Enter"}, 				locale = "garage_numberplate_accept"},
		{ keys = {"Backspace"}, 				locale = "garage_numberplate_back"},
		{ keys = {"Delete"}, 				locale = "garage_numberplate_delete"},
	})
end

function NumberplateScreen:draw()
	self.super:draw()
	self.helpPanel:draw(self.fadeProgress)
	-- Фон
	dxDrawRoundedRectangle(
		self.x - self.width / 2,
		self.y,
		self.width,
		self.height,
		10,
		255*self.fadeProgress,
		false,
		false
	 )
	 
	-- Текст информации о номере
	TrcDrawText(
		exports.tunrc_Lang:getString("garage_numberplate_panel_info"),
		self.x - self.width,
		self.y + 25,
		self.x + self.width,
		self.y,
		255 * self.fadeProgress,
		Assets.fonts.tuningPanelText
	)
	
	TrcDrawText(
		("%s: %s"):format(exports.tunrc_Lang:getString("garage_numberplate_panel_text"), self.numberplateText),
		self.x - self.width,
		self.y + 75,
		self.x + self.width,
		self.y,
		255 * self.fadeProgress,
		Assets.fonts.tuningPanelText
	)
	
end

function NumberplateScreen:show()
	self.super:show()
	guiSetInputEnabled(true)		
end

function NumberplateScreen:hide()
	self.super:hide()
	guiSetInputEnabled(false)
end

function NumberplateScreen:updateText()
	self.numberplateText = string.sub(self.numberplateText, 1, MAX_NUMBERPLATE_TEXT_LENGTH)
	GarageCar.previewTuning("Numberplate", self.numberplateText)
end

function NumberplateScreen:onKey(key)
	self.super:onKey(key)

	if key == "enter" then
		local this = self
		local price, level = unpack(exports.tunrc_Shared:getTuningPrices("numberplate"))
		Garage.buy(price, level, function(success)	
			if success then
				GarageCar.applyTuning("Numberplate", this.numberplateText)
			else
				GarageCar.resetTuning()
			end
			this.screenManager:showScreen(ComponentsScreen("Numberplate"))
		end)
	elseif key == "delete" then
		if string.len(self.numberplateText) > 0 then
			self.numberplateText = string.sub(self.numberplateText, 1, -2)
			self:updateText()
		end
	elseif key == "backspace" then
		GarageCar.resetTuning()
		self.screenManager:showScreen(ComponentsScreen("Numberplate"))
	elseif key == "space" then
		self.numberplateText = self.numberplateText .. " "
		self:updateText()
	else
		if string.find(allowedLetters, key) then
			self.numberplateText = self.numberplateText .. key			
			self:updateText()
		end
	end
end