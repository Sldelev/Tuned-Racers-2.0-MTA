-- Экран покупки компонента

ComponentScreen = Screen:subclass "ComponentScreen"

-- Расположение 3D меню для разных компонентов
local menuInfos = {}
menuInfos["Bodykits"]  = {position =  Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_bodykits"}
menuInfos["Doors"]    = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_doors"}
menuInfos["BodyRollcage"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_body_rollcage"}
menuInfos["FrontBump"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_bumper"}
menuInfos["Rollingshells"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_rollingshell"}
menuInfos["Turbos"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_turbos"}
menuInfos["Grills"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_grills"}
menuInfos["Frontnumber"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_frontnumber"}
menuInfos["Fbadge"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_fbadge"}
menuInfos["Canards"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_canards"}
menuInfos["Lips"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_lips"}
menuInfos["RearGls"]  = {position =  Vector3(1.5, -2, 0.4),   angle = 185, item_locale="garage_tuning_item_reargls"}
menuInfos["Splrs"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_spoiler"}
menuInfos["Boots"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_boot"}
menuInfos["Rbadge"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_rbadge"}
menuInfos["Roof"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_roof"}
menuInfos["RoofS"]   = {position = Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_roofs"}
menuInfos["RearBump"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_r_bumper"}
menuInfos["Rearnumber"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_rearnumber"}
menuInfos["Canardsr"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_canardsr"}
menuInfos["Exh"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_exhaust"}
menuInfos["Diffusors"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_diffusors"}
menuInfos["WheelsF"]    = {position = Vector3(0.5, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_wheel"}
menuInfos["WheelsCaliperF"]    = {position = Vector3(0.5, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_caliper"}
menuInfos["WheelsTiresF"]    = {position = Vector3(0.5, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_tire"}
menuInfos["WheelsR"]    = {position = Vector3(-1, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_wheel"}
menuInfos["WheelsCaliperR"]    = {position = Vector3(-1, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_caliper"}
menuInfos["WheelsTiresR"]    = {position = Vector3(-1, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_tire"}
menuInfos["Skirts"] = {position = Vector3(-0.5, -2, 0.4), angle = 170, item_locale="garage_tuning_item_skirt"}
menuInfos["AddSkirts"] = {position = Vector3(-0.5, -2, 0.4), angle = 170, item_locale="garage_tuning_item_addskirt"}
menuInfos["RearFends"]  = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_rfender"}
menuInfos["Rpanels"]  = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_rpanel"}
menuInfos["FrontFends"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fender"}
menuInfos["FrontFendsDops"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fender_dop"}
menuInfos["Fpanels"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fpanel"}
menuInfos["Mirrors"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_mirrors"}
menuInfos["Dials"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_dial"}
menuInfos["HandBrakes"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_handbrake"}
menuInfos["GearShifts"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_gearshift"}
menuInfos["DoorCards"] = {position = Vector3(0, 2, 0.4),   angle = 0,  item_locale="garage_tuning_item_doorcards"}
menuInfos["Bonnets"]    = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_bonnet"}
menuInfos["Hcatcha"]    = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_hcatcha"}
menuInfos["Eng"]    = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_engine"}
menuInfos["Filters"]    = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_filter"}
menuInfos["Exhaust"]    = {position = Vector3(1.5, -2, 0.4),   angle = 190,item_locale="garage_tuning_item_exhaust"}
menuInfos["RearLights"] = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_lights"}
menuInfos["RearLightR"] = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_light_r"}
menuInfos["RearLightL"] = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_light_r"}
menuInfos["FrontLights"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_lights"}
menuInfos["AddLights"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_addlights"}
menuInfos["SideLights"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_sidelights"}
menuInfos["FaraR"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_fara"}
menuInfos["FaraL"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_fara"}
menuInfos["Dops"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_dops"}
menuInfos["Seats"] = {position = Vector3(1.5, -2, 0.4),  angle = 20, item_locale="garage_tuning_item_seats"}
menuInfos["Stwheel"] = {position = Vector3(1.5, 2, 0.4),  angle = 190, item_locale="garage_tuning_item_steer"}
menuInfos["Interior"] = {position = Vector3(1.5, -2, 0.4),  angle = 20, item_locale="garage_tuning_item_interior"}
menuInfos["Karkas"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_karkas"}
menuInfos["Acces"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_acces"}
menuInfos["Intercooler"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_intercooler"}

function ComponentScreen:init(name)
    self.super:init()
    self.vehicle = GarageCar.getVehicle()
    -- Название компонента, который будет выбираться
    self.componentName = name

    local menuInfo = menuInfos[name]
    items = {}
    local vehicleModel = self.vehicle.model
    local vehicleComponents = getVehicleComponents(self.vehicle)
    local componentsCount = TuningConfig.getComponentsCount(vehicleModel, self.componentName)
	
	if not GarageCar.hasComponent(self.componentName, 0) then
		table.insert(items, {name = exports.tunrc_Lang:getString("garage_tuning_stock_text"), price = 0, level = 0})
	end
    for i = 1, componentsCount + 1 do
		if name == "WheelsF" or name == "WheelsR" or name == "WheelsCaliperF" or name == "WheelsCaliperR"  or name == "WheelsTiresF" or name == "WheelsTiresR" then
			if i == 1 then
				itemName = exports.tunrc_Lang:getString("garage_tuning_stock_text")
			else
				itemName = exports.tunrc_Lang:getString(menuInfo.item_locale .. "_" .. tostring(i - 1))
			end
		elseif i == 1 then
			itemName = exports.tunrc_Lang:getString("garage_tuning_stock_text")
		else
			itemName = exports.tunrc_Lang:getString(vehicleModel .. "_" .. menuInfo.item_locale .. "_" .. tostring(i - 1))
		end
        local componentConfig = TuningConfig.getComponentConfig(vehicleModel, self.componentName, 1)
		local addComponentConfig = TuningConfig.getComponentConfig(vehicleModel, self.componentName, i - 1)
        if GarageCar.hasComponent(self.componentName, i - 1) then
                -- Обновить цену
                priceItem = componentConfig.price + (i * 75)
				if name == "WheelsF" or name == "WheelsR" or name == "WheelsCaliperF" or name == "WheelsCaliperR" or name == "WheelsTiresF" or name == "WheelsTiresR" then
					priceItem = addComponentConfig.price
				end
					if type(priceItem) ~= "number" then
						priceItem = 0
					end
				-- Уровень
                local level = componentConfig.level + (i * 1)
					if type(level) ~= "number" then
						level = 1
					end
					if i == 1 then
						level = 1
					end
                local name = itemName
                table.insert(items, {name = name, price = priceItem, level = level})
            end
        end
	
    if GarageCar.isComponentRemovable(name) then
      table.insert(items, {name = exports.tunrc_Lang:getString("garage_tuning_remove_text"), price = 0, level = 0})
    end
    -- 3D меню
    self.menu = MenuItem(
        GarageCar.getVehiclePos() + menuInfo.position,
        menuInfo.angle,
        items
    )
    CameraManager.setState("preview" .. name, false, 3)

    self:onItemChanged()
end

function ComponentScreen:show()
    self.super:show()
    if self.componentName == "RightLight" or self.componentName == "LeftLight"or self.componentName == "LeftLight" or self.componentName == "FrontLights" or self.componentName == "RearLights" or self.componentName == "RearBump" or self.componentName == "Rnomers" or self.componentName == "AddLights" then
        GarageCar.getVehicle():setData("LightsState", true, false)
    end
end

function ComponentScreen:hide()
    self.super:hide()
    self.menu:destroy()
    GarageCar.getVehicle():setData("LightsState", false, false)
end

function ComponentScreen:draw()
    self.super:draw()
    self.menu:draw(self.fadeProgress)
end

function ComponentScreen:update(deltaTime)
    self.super:update(deltaTime)
    self.menu:update(deltaTime)
end

function ComponentScreen:onItemChanged()
    GarageCar.resetTuning()
    local componentId = self.menu.activeItem - 1
    if self.componentName == "WheelsF" or self.componentName == "WheelsR" then
        local letter = "F"
        if self.componentName == "WheelsR" then
            letter = "R"
        end
        GarageCar.previewTuning(self.componentName, componentId)
    else
        GarageCar.previewTuning(self.componentName, componentId)
    end
end

function ComponentScreen:onKey(key)
    self.super:onKey(key)
    if key == "backspace" then
        GarageCar.resetTuning()
        self.screenManager:showScreen(ComponentsScreen(self.componentName))
    elseif key == "arrow_l" then
		self.menu:selectPreviousItem()
        self:onItemChanged()
    elseif key == "arrow_r" then
        self.menu:selectNextItem()
        self:onItemChanged()
    elseif key == "enter" then
        local item = self.menu.items[self.menu.activeItem]
        local this = self
        local componentId = this.menu.activeItem - 1
        Garage.buy(item.price, item.level, function(success)
            if success then
                GarageCar.applyTuning(this.componentName, componentId)
                this.screenManager:showScreen(ComponentsScreen(this.componentName))

                if this.componentName == "WheelsF" or this.componentName == "WheelsR" then
                    local letter = "F"
                    if this.componentName == "WheelsR" then
                        letter = "R"
                    end
                end
            end
        end)
    end
end
