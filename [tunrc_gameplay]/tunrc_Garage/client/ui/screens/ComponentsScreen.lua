-- Экран переключения между компонентами
ComponentsScreen = Screen:subclass "ComponentsScreen"
local screenSize = Vector2(guiGetScreenSize())


function ComponentsScreen:init(componentName)
	self.super:init()
local numberplateInfo = exports.tunrc_Shared:getTuningPrices("numberplate")
local componentsList = {
	{name="Bodykits", 	camera="frontBump",  	locale="garage_tuning_component_bodykits"},
	{name="Doors", 	camera="frontBump", 		locale="garage_tuning_component_doors"},
	{name="BodyRollcage"      ,camera="frontBump", 	locale="garage_tuning_component_body_rollcage"},
	{name="FrontBump", 	camera="frontBump",  	locale="garage_tuning_component_front_bump"},
	{name="Numberplate",camera="frontBump", 	locale="garage_tuning_component_numberplate", price = numberplateInfo[1], level = numberplateInfo[2]},
	{name="Filters", 	camera="frontBump", 		locale="garage_tuning_component_filters"},
	{name="Intercooler"      ,camera="frontBump", 	locale="garage_tuning_component_intercooler"},
	{name="Lips"      ,camera="frontBump", 	locale="garage_tuning_component_Lips"},
	{name="Canards"      ,camera="frontBump", 	locale="garage_tuning_component_Canards"},
	{name="FrontLights",camera="frontBump", 	locale="garage_tuning_component_front_lights"},
	{name="FaraR"      ,camera="frontBump", 	locale="garage_tuning_component_FaraR"},
	{name="FaraL"      ,camera="frontBump", 	locale="garage_tuning_component_FaraL"},	
	{name="AddLights",camera="frontBump", 	locale="garage_tuning_component_addlights"},
	{name="SideLights"      ,camera="frontBump", 	locale="garage_tuning_component_sidelights"},
	{name="Fpanels", 	camera="frontBump", 		locale="garage_tuning_component_fpanel"},
	{name="Fbadge", 	camera="frontBump",  	locale="garage_tuning_component_fbadge"},
	{name="FrontFends", camera="frontBump", 	locale="garage_tuning_component_front_fends"},
	{name="FrontFendsDops", 	camera="frontBump", 		locale="garage_tuning_component_front_fends_dops"},
	{name="Bonnets", 	camera="frontBump", 		locale="garage_tuning_component_bonnet"},
	{name="Hcatcha", camera="frontBump", 	locale="garage_tuning_component_front_hcatcha"},
	{name="Mirrors", camera="frontBump", 	locale="garage_tuning_component_mirrors"},
	{name="Rollingshells", 	camera="frontBump",  	locale="garage_tuning_component_rollingshell"},
	{name="Grills", 	camera="frontBump",  	locale="garage_tuning_component_grills"},
	{name="Turbos", 	camera="frontBump",  	locale="garage_tuning_component_turbos"},
	{name="Frontnumber", 	camera="frontBump",  	locale="garage_tuning_component_frontnumber"},
	{name="Skirts", camera="skirts", 		locale="garage_tuning_component_side_skirts"},
	{name="AddSkirts", camera="skirts", 		locale="garage_tuning_component_side_addskirts"},
	{name="Roof", 	camera="rearBump", 		locale="garage_tuning_component_roof"},
	{name="RoofS", 	camera="rearBump", 		locale="garage_tuning_component_roofs"},
	{name="RearFends", 	camera="rearBump", 	locale="garage_tuning_component_rear_fends"},
	{name="Boots", 	camera="rearBump", 		locale="garage_tuning_component_boots"},
	{name="RearGls"      ,camera="rearBump", 	locale="garage_tuning_component_reargls"},
	{name="Rpanels", 	camera="rearBump", 		locale="garage_tuning_component_rpanel"},
	{name="Rbadge", 	camera="rearBump", 		locale="garage_tuning_component_rbadge"},
	{name="Splrs", 	camera="rearBump", 		locale="garage_tuning_component_spoilers"},
	{name="RearLights", camera="rearBump", 	locale="garage_tuning_component_rear_lights"},
	{name="RearLightR", camera="rearBump", 	locale="garage_tuning_component_rear_light_r"},
	{name="RearLightL", camera="rearBump", 	locale="garage_tuning_component_rear_light_l"},
	{name="RearBump", 	camera="rearBump", 		locale="garage_tuning_component_rear_bump"},
	{name="Rearnumber", 	camera="rearBump", 		locale="garage_tuning_component_rearnumber"},
	{name="Canardsr", 	camera="rearBump", 		locale="garage_tuning_component_canardsr"},
	{name="Diffusors", 	camera="rearBump", 		locale="garage_tuning_component_diffusors"},
	{name="Exh", 	camera="rearBump", 		locale="garage_tuning_component_exhaust"},
	{name="Eng", 	camera="frontBump", 		locale="garage_tuning_component_engine"},
	{name="Dops"       ,camera="frontBump", 	locale="garage_tuning_component_Dops"},			
	{name="Seats"      ,camera="frontBump", 	locale="garage_tuning_component_Seats"},
	{name="Stwheel"      ,camera="stwheel", 	locale="garage_tuning_component_Steer"},
	{name="Dials"      ,camera="frontBump", 	locale="garage_tuning_component_dials"},
	{name="HandBrakes"      ,camera="frontBump", 	locale="garage_tuning_component_handbrake"},
	{name="GearShifts"      ,camera="frontBump", 	locale="garage_tuning_component_gearshift"},
	{name="DoorCards"      ,camera="frontBump", 	locale="garage_tuning_component_doorcards"},
	{name="Interior"      ,camera="frontBump", 	locale="garage_tuning_component_interior"},
	{name="Karkas"      ,camera="frontBump", 	locale="garage_tuning_component_Karkas"},
	{name="Acces"      ,camera="frontBump", 	locale="garage_tuning_component_Acces"},
}

-- componentName - название компонента, который нужно отобразить при переходе на экран
	local vehicle = GarageCar.getVehicle()
	
	local toRemove = {}
	for i, component in ipairs(componentsList) do
		local count = GarageCar.getComponentsCount(component.name)
		if component.name == "Numberplate" then
			count = 1
		end
		
		if count <= 0 then
			table.insert(toRemove, i)
		end
		
	end
	for i = #toRemove, 1, -1 do
		table.remove(componentsList, toRemove[i])
	end
	
	self.componentsSelection = ComponentSelection(componentsList)
	
	if (getVehicleType(vehicle) == "Automobile") then
		self.componentsSelection:addComponent("WheelsF", "wheelLF", "garage_tuning_component_wheels_front")
		self.componentsSelection:addComponent("WheelsCaliperF", "wheelLF", "garage_tuning_component_calipers_front")
		self.componentsSelection:addComponent("WheelsTiresF", "wheelLF", "garage_tuning_component_tires_front")
		self.componentsSelection:addComponent("WheelsR", "wheelLB", "garage_tuning_component_wheels_rear")
		self.componentsSelection:addComponent("WheelsCaliperR", "wheelLB", "garage_tuning_component_calipers_rear")
		self.componentsSelection:addComponent("WheelsTiresR", "wheelLB", "garage_tuning_component_tires_rear")
	end

	-- Если возвращаемся, показать компонент, с которого возвращаемся
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
end

function ComponentsScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function ComponentsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function ComponentsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(TuningScreen(1))
		GarageCar.save()
	elseif key == "enter" then
		if not self.componentsSelection:canBuy() then
			return
		end
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()
		if componentName == "Numberplate" then
			self.screenManager:showScreen(NumberplateScreen())
		else
			self.screenManager:showScreen(ComponentScreen(componentName))
		end
	end
end
