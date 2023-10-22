Input = {}
local activeInput
local repeatTimer
local repeatStartTimer
local MASKED_CHAR = "●"
local REPEAT_WAIT = 500
local REPEAT_DELAY = 50

function Input.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	local widget = Rectangle.create(properties)
	widget._type = "Input"
	widget.placeholder = exports.tunrc_Utils:defaultValue(properties.placeholder, "")
	widget.forceRegister = exports.tunrc_Utils:defaultValue(properties.forceRegister, false)
	widget.masked = exports.tunrc_Utils:defaultValue(properties.masked, false)
	widget.font = Fonts.lightSmall
	widget.regexp = exports.tunrc_Utils:defaultValue(properties.regexp, false)
	widget.textHolderColor = properties.textHolderColor
	widget.textDarkHolderColor = properties.textDarkHolderColor
	widget.hover = properties.hover
	widget.hoverColor = properties.hoverColor
	widget.hoverDarkColor = properties.hoverDarkColor
	widget.darkToggle = properties.darkToggle
	widget.darkColor = properties.darkColor
	local textOffsetX = 10
	function widget:draw()
		if exports.tunrc_Config:getProperty("ui.dark_mode") and properties.darkToggle == true then
			if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) and properties.hover == true then
				self.color = properties.hoverDarkColor or tocolor(10,10,10)
			else
				self.textHolderColor = properties.textDarkHolderColor
				self.color = properties.darkColor
			end
		else
			if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) and properties.hover == true then
				self.color = properties.hoverColor or tocolor(105,105,105)
			else
				self.textHolderColor = properties.textHolderColor
				self.color = properties.color
			end
		end
		-- Background
		Drawing.rectangle(self.x, self.y, self.width, self.height, self.color)

		-- Placeholder
		local text = self.placeholder
		Drawing.setColor(self.textHolderColor)
		if utf8.len(self.text) > 0 then
			text = self.text
			if self.masked then
				text = ""
				for i = 1, utf8.len(self.text) do
					text = text .. MASKED_CHAR
				end
			end
		end
		Drawing.text(
			self.x + textOffsetX, 
			self.y, 
			self.width - textOffsetX * 2, 
			self.height, 
			text, 
			"left", 
			"center", 
			true, 
			false
		)
	end	
	return widget
end

addEvent("tunrc_UI.clickInternal", false)
addEventHandler("tunrc_UI.clickInternal", resourceRoot, function ()
	if Render.clickedWidget and Render.clickedWidget._type == "Input" then
 		activeInput = Render.clickedWidget
 	else
 		activeInput = nil
 	end

 	guiSetInputMode("no_binds")
 	guiSetInputEnabled(not not activeInput)
end)

local function handleKey(key, repeatKey)
	if not activeInput then
		return 
	end
	if key == "backspace" then
		activeInput.text = utf8.sub(activeInput.text, 1, -2)
		triggerEvent("tunrc_UI.inputChange", activeInput.resourceRoot, activeInput.id)
	elseif key == "tab" then
		local inputs = {}
		local currentIndex = 0
		local index = 0
		for i, v in ipairs(activeInput.parent.children) do				
			if v._type == "Input" then
				index = index + 1
				table.insert(inputs, v)
				if v == activeInput then
					currentIndex = index
				end
			end	
		end
		if #inputs > 1 then
			currentIndex = currentIndex + 1
			if currentIndex > #inputs then
				currentIndex = 1
			end
			activeInput = inputs[currentIndex]
		end
	elseif key == "enter" then
		triggerEvent("tunrc_UI.inputEnter", activeInput.resourceRoot, activeInput.id)
		activeInput = nil
	else
		return
	end

	if repeatKey and getKeyState(key) then
		repeatTimer = setTimer(handleKey, REPEAT_DELAY, 1, key, true)
	end
end
addEventHandler("onClientKey", root, function (key, state)
	if not activeInput or MessageBox.isActive() then
		return
	end
	if not state then
		if isTimer(repeatStartTimer) then
			killTimer(repeatStartTimer)
		end
		if isTimer(repeatTimer) then
			killTimer(repeatTimer)
		end		
		return
	end
	handleKey(key, false)
	repeatStartTimer = setTimer(handleKey, REPEAT_WAIT, 1, key, true)
end)

addEventHandler("onClientCharacter", root, function (character)
	if activeInput and not MessageBox.isActive() then
		if activeInput.forceRegister then
			if activeInput.forceRegister == "lower" then
				character = utf8.lower(character)
			elseif activeInput.forceRegister == "upper" then
				character = utf8.upper(character)
			end
		end
		if activeInput.regexp then
			if not pregFind(character, activeInput.regexp) then
				return 
			end
		end
		activeInput.text = utf8.insert(activeInput.text, tostring(character))
		triggerEvent("tunrc_UI.inputChange", activeInput.resourceRoot, activeInput.id)
	end
end)