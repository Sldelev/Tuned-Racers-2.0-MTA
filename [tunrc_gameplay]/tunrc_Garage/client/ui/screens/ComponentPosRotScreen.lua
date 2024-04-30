ComponentPosRotScreen = Screen:subclass "ComponentPosRotScreen"

local menuInfos = {}
menuInfos["Exhausts"] = {position = Vector3(1, -2, -0.5), angle = -15, header="garage_tuning_component_config_pos_rot_exhausts"}
menuInfos["NumberplateF"] = {position = Vector3(-1.25, -2, -0.5), angle = -15, header="garage_tuning_component_config_pos_rot_numberplateF"}
menuInfos["NumberplateR"] = {position = Vector3(-1.25, -2, -0.5), angle = -15, header="garage_tuning_component_config_pos_rot_numberplateR"}

function ComponentPosRotScreen:init(componentSide, saveCameraPosition)
	self.disabled = false
	self.componentSide = componentSide
	local menuInfo = menuInfos[componentSide]
	self.menu = ComponentPosRotMenu(
		exports.tunrc_Lang:getString(menuInfo.header),
		GarageCar.getVehiclePos() + menuInfo.position,
		menuInfo.angle
	)

	-- Камера
	if not saveCameraPosition then
		CameraManager.setState("freeLookCamera", false, 5)
	end

	-- Дата
	self.dataNames = {
		"PosX",
		"PosY",
		"PosZ",
		"RotX",
		"RotY",
		"RotZ"
	}
	local c = "Exhausts"
	if componentSide == "NumberplateF" then
		c = "NumberplateF"
	elseif componentSide == "NumberplateR" then
		c = "NumberplateR"
	end
	for i, name in ipairs(self.dataNames) do
		self.dataNames[i] = name .. c
	end

	local vehicle = GarageCar.getVehicle()
	self.menu.bars[1].value = vehicle:getData(self.dataNames[1])
	self.menu.bars[2].value = vehicle:getData(self.dataNames[2])
	self.menu.bars[3].value = vehicle:getData(self.dataNames[3])
	self.menu.bars[4].value = vehicle:getData(self.dataNames[4])
	self.menu.bars[5].value = vehicle:getData(self.dataNames[5])
	self.menu.bars[6].value = vehicle:getData(self.dataNames[6])

	self.super:init()

	local this = self
	setTimer(function ()
		--this:updatePreview()
	end, 50, 0)
end

function ComponentPosRotScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
	--self:updatePreview()
end

function ComponentPosRotScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)

	if self.disabled or isMTAWindowActive() then
		return
	end
	if getKeyState("arrow_r") then
		self.menu:increase(deltaTime)
		self:updatePreview()
	elseif getKeyState("arrow_l") then
		self.menu:decrease(deltaTime)
		self:updatePreview()
	end
end

function ComponentPosRotScreen:updatePreview()
	if self.disabled then
		return
	end
	local bar, value = self.menu:getBarValue()
	local dataName = self.dataNames[bar]
	if string.find(dataName, "WheelsOffset") then
		value = value
	elseif string.find(dataName, "WheelsAngle") then
		value = value
	elseif string.find(dataName, "WheelsWidth") then
		value = value
	elseif string.find(dataName, "WheelsSize") then
		value = value
	end
	GarageCar.previewTuning(dataName, value)
end

function ComponentPosRotScreen:onKey(key)
	self.super:onKey(key)
	if self.disabled then
		return
	end

	if key == "enter" then
		local this = self
		self.disabled = true
		Garage.buy(0, 0, function (success)
			if success then
				for i = 1, 6 do
					GarageCar.applyTuningFromData(this.dataNames[i])
				end
				GarageCar.resetTuning()
				this.screenManager:showScreen(ConfigurationsScreen(this.componentSide))
			end
		end)
	elseif key == "backspace" then
		self.disabled = true
		GarageCar.resetTuning()
		self.screenManager:showScreen(ConfigurationsScreen(self.componentSide))
	elseif key == "arrow_u" then
		self.menu:selectPreviousBar()
	elseif key == "arrow_d" then
		self.menu:selectNextBar()
	end
end