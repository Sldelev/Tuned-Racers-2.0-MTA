-- Экран покупки компонента

ComponentScreen = Screen:subclass "ComponentScreen"

-- Расположение 3D меню для разных компонентов
local menuInfos = {}
menuInfos["Bodykits"]  = {position =  Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_bodykits"}
menuInfos["FrontBump"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_bumper"}
menuInfos["Rollingshells"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_rollingshell"}
menuInfos["Turbos"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_turbos"}
menuInfos["Grills"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_grills"}
menuInfos["Frontnumber"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_frontnumber"}
menuInfos["Fbadge"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_fbadge"}
menuInfos["Canards"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_canards"}
menuInfos["Lips"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_lips"}
menuInfos["RearGls"]  = {position =  Vector3(1.5, -2, 0.4),   angle = 185, item_locale="garage_tuning_item_reargls"}
menuInfos["Spoilers"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_spoiler"}
menuInfos["Boots"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_boot"}
menuInfos["Rbadge"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_rbadge"}
menuInfos["Roof"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_roof"}
menuInfos["RoofS"]   = {position = Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_roofs"}
menuInfos["RearBump"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_bumper"}
menuInfos["Rearnumber"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_rearnumber"}
menuInfos["Canardsr"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_canardsr"}
menuInfos["Exh"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_exhaust"}
menuInfos["Diffusors"]   = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_diffusors"}
menuInfos["WheelsF"]    = {position = Vector3(0.5, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_wheel"}
menuInfos["WheelsR"]    = {position = Vector3(-1, -1.5, 0.4),   angle = -50, item_locale="garage_tuning_item_wheel"}
menuInfos["Skirts"] = {position = Vector3(-0.5, -2, 0.4), angle = 170, item_locale="garage_tuning_item_skirt"}
menuInfos["AddSkirts"] = {position = Vector3(-0.5, -2, 0.4), angle = 170, item_locale="garage_tuning_item_addskirt"}
menuInfos["RearFends"]  = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_fender"}
menuInfos["Rpanels"]  = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_rpanel"}
menuInfos["FrontFends"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fender"}
menuInfos["FrontFendsDops"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fender_dop"}
menuInfos["Fpanels"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fpanel"}
menuInfos["Mirrors"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_mirrors"}
menuInfos["FrontFendsR"] = {position = Vector3(0, -2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fender"}
menuInfos["FrontFendsL"] = {position = Vector3(0, 2, 0.4),   angle = 0,  item_locale="garage_tuning_item_fender"}
menuInfos["Bonnets"]    = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_bonnet"}
menuInfos["Eng"]    = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_engine"}
menuInfos["Exhaust"]    = {position = Vector3(1.5, -2, 0.4),   angle = 190,item_locale="garage_tuning_item_exhaust"}
menuInfos["RearLights"] = {position =  Vector3(1.5, -2, 0.4),   angle = 185,item_locale="garage_tuning_item_lights"}
menuInfos["FrontLights"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_lights"}
menuInfos["AddLights"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_addlights"}
menuInfos["SideLights"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_sidelights"}
menuInfos["FaraR"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_farar"}
menuInfos["FaraL"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_faral"}
menuInfos["Dops"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_dops"}
menuInfos["Seats"] = {position = Vector3(1.5, -2, 0.4),  angle = 20, item_locale="garage_tuning_item_seats"}
menuInfos["Steering"] = {position = Vector3(-1.5, 2, 0.4),  angle = 20, item_locale="garage_tuning_item_steer"}
menuInfos["Torpeda"] = {position = Vector3(1.5, -2, 0.4),  angle = 20, item_locale="garage_tuning_item_torpeda"}
menuInfos["Karkas"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_karkas"}
menuInfos["Acces"] = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_acces"}
menuInfos["Intercooler"]  = {position = Vector3(0, -2, 0.4),   angle = 0, item_locale="garage_tuning_item_intercooler"}

local function hasSpoiler(id)
    if id == 0 then
        return true
    end
    if not GarageCar.hasDefaultSpoilers() and GarageCar.hasCustomSpoiler(id) then
        return true
    end
    local defaultSpoilersCount = #exports.tunrc_Shared:getTuningPrices("spoilers")
    if id <= defaultSpoilersCount and GarageCar.hasDefaultSpoilers() then
        return true
    elseif GarageCar.hasCustomSpoiler(id - defaultSpoilersCount) then
        return true
    end
    return false
end

function ComponentScreen:init(name)
    self.super:init()
    self.vehicle = GarageCar.getVehicle()
    -- Название компонента, который будет выбираться
    self.componentName = name

    local menuInfo = menuInfos[name]
    local items = {}
    local itemName = exports.tunrc_Lang:getString(menuInfo.item_locale)
    local vehicleModel = self.vehicle.model
    local vehicleComponents = getVehicleComponents(self.vehicle)
    local componentsCount = TuningConfig.getComponentsCount(vehicleModel, self.componentName)
    for i = 1, componentsCount + 1 do
        if name ~= "Spoilers" or (name == "Spoilers" and hasSpoiler(i - 1)) then
            if i == 1 then
              table.insert(items, {
                name = exports.tunrc_Lang:getString("garage_tuning_stock_text"),
                price = 0,
                level = 0
              })
            else
              local componentConfig = TuningConfig.getComponentConfig(vehicleModel, self.componentName, i - 1)
              if GarageCar.hasComponent(self.componentName, i - 1) then
                  -- Обновить цену
                  local price = componentConfig.price
                  if type(price) ~= "number" then
                      price = 0
                  end
                  local level = componentConfig.level
                  if type(level) ~= "number" then
                      level = 1
                  end
                  local name = itemName .. " " .. tostring(i - 1)
                  table.insert(items, {name = name, price = price, level = level})
              end
            end
        end
    end

    if GarageCar.isComponentRemovable(name) then
      table.insert(items, {name = exports.tunrc_Lang:getString("garage_tuning_remove_text"), price = 0, level = 0})
    end
    -- 3D меню
    self.menu = ComponentsMenu(
        GarageCar.getVehiclePos() + menuInfo.position,
        menuInfo.angle,
        items
    )
    local data = self.vehicle:getData(name)
    if data then
        self.menu:setActiveItem(data + 1)
    end
    CameraManager.setState("preview" .. name, false, 3)

    --self:onItemChanged()
end

function ComponentScreen:show()
    self.super:show()
    if self.componentName == "RightLight" or self.componentName == "LeftLight" or self.componentName == "FrontLights" or self.componentName == "RearLights" or self.componentName == "RearBump" or self.componentName == "Rnomers" or self.componentName == "AddLights" then
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
        if componentId == 0 then
            -- Сбросить развал и т д
            GarageCar.previewTuning("WheelsOffset" .. letter, 0)
            GarageCar.previewTuning("WheelsAngle" .. letter, 0)
            GarageCar.previewTuning("WheelsWidth" .. letter, 0)
        end
        -- Сбросить цвет
        GarageCar.previewTuning("WheelsColor" .. letter, {255, 255, 255})

        GarageCar.previewTuning(self.componentName, componentId)
    elseif self.componentName == "Spoilers" then
        local bodyColor = GarageCar.getVehicle():getData("BodyColor")
        if bodyColor then
            GarageCar.previewTuning("SpoilerColor", bodyColor)
        end
        if not GarageCar.hasDefaultSpoilers() and componentId > 0 then
            local defaultSpoilers = exports.tunrc_Shared:getTuningPrices("spoilers")
            GarageCar.previewTuning(self.componentName, componentId + #defaultSpoilers)
        else
            GarageCar.previewTuning(self.componentName, componentId)
        end
    else
        GarageCar.previewTuning(self.componentName, componentId)
    end
end

function ComponentScreen:onKey(key)
    self.super:onKey(key)
    if key == "backspace" then
        GarageCar.resetTuning()
        self.screenManager:showScreen(ComponentsScreen(self.componentName))
    elseif key == "arrow_u" then
        self.menu:showPrevious()
        self:onItemChanged()
    elseif key == "arrow_d" then
        self.menu:showNext()
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
                    if componentId == 0 then
                        -- Сбросить развал и т д
                        GarageCar.applyTuning("WheelsOffset" .. letter, 0)
                        GarageCar.applyTuning("WheelsAngle" .. letter, 0)
                        GarageCar.applyTuning("WheelsWidth" .. letter, 0)
                    end
                    -- Сбросить цвет
                    GarageCar.applyTuning("WheelsColor" .. letter, {255, 255, 255})
                elseif this.componentName == "Spoilers" then
                    if not GarageCar.hasDefaultSpoilers() then
                        local defaultSpoilers = exports.tunrc_Shared:getTuningPrices("spoilers")
                        if componentId > 0 then
                            GarageCar.applyTuning(this.componentName, componentId + #defaultSpoilers)
                        end
                    else
                        GarageCar.applyTuning(this.componentName, componentId)
                    end
                end
            end
        end)
    end
end
