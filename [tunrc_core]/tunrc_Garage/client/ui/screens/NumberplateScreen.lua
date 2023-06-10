-- Экран смены номерного знака

NumberplateScreen = Screen:subclass "NumberplateScreen"

local MAX_NUMBERPLATE_TEXT_LENGTH = 8

local allowedLetters_en = "abcdefghijklmnopqrstuvwxyz0123456789-  "

function NumberplateScreen:init()
	self.super:init()

	self.numberplateText = GarageCar.getVehicle():getData("Numberplate")
	if type(self.numberplateText) ~= "string" then
		self.numberplateText = "unknown"
	end
	CameraManager.setState("previewNumberplate", false, 3)
	guiSetInputMode("no_binds")
	
	self.helpPanel = HelpPanel({
		{ keys = {"Q"}, 	locale = "garage_number_editor_country" },
		{ keys = {"Space"}, 	locale = "garage_number_editor_emptyslot" },
	})
end

function NumberplateScreen:draw()
	self.super:draw()
	self.helpPanel:draw(self.fadeProgress)
end

function NumberplateScreen:show()
	self.super:show()
	guiSetInputEnabled(true)	
end

function NumberplateScreen:hide()
	self.super:hide()
	guiSetInputEnabled(false)
	GarageUI.resetHelpText()
end

function NumberplateScreen:updateText()
	self.numberplateText = string.sub(self.numberplateText, 1, MAX_NUMBERPLATE_TEXT_LENGTH)
	GarageCar.previewTuning("Numberplate", self.numberplateText)
end

local rules = {
	["ny"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["nj"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["nc"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["ny1"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["ny2"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["virg"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["mont"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["haw"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["maine"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["alas"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["col"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["rho"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["tex"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["wash"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["scar"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["jp1"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["jp2"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["jp3"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"},
	["ohio"]={"%S", "%S", "%S", "%S", "%S", "%S", "%S", "%S"}
}
	
local rules_index = {"ny", "nj", "nc", "ny1", "ny2", "virg", "mont", "haw", "maine", "alas", "col", "rho", "tex", "wash", "scar", "ohio", "jp1", "jp2", "jp3"}

function NumberplateScreen:onKey(key)
	self.super:onKey(key)

	local number_length = self.numberplateText:len() + 1

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
	elseif key == "backspace" then
		if string.len(self.numberplateText) > 0 then
			self.numberplateText = string.sub(self.numberplateText, 1, -2)
			self:updateText()
			if number_length > 0 then number_length = number_length - 1 end
		else
			GarageCar.resetTuning()
			self.screenManager:showScreen(ComponentsScreen("Numberplate"))
		end
	--[[elseif key == "space" then
		self.numberplateText = self.numberplateText .. " "
		self:updateText()]]
	elseif key == "q" then
		self.numberplateText = ""
		self:updateText()
		GarageCar.applyTuning("Country", exports.tunrc_Vehicles:setData_NumberTable(GarageCar.getVehicle()))
		number_length = 0
	else
		for _, k in ipairs(rules_index) do
			if (GarageCar.getVehicle():getData("Country") == k) then
				if (number_length <= #rules[k]) and (key:match(rules[k][number_length])) then
					if (allowedLetters_en:find(key)) then
						self.numberplateText = self.numberplateText .. key	
						self:updateText()
						number_length = number_length + 1	
					end
				if key == "space" then
					self.numberplateText = self.numberplateText .. " "	
					self:updateText()
					number_length = number_length + 1
				end
				end
				break
			end
		end
	end
end