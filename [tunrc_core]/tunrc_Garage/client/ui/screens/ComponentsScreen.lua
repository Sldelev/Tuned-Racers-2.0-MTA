-- Экран переключения между компонентами
ComponentsScreen = Screen:subclass "ComponentsScreen"
local screenSize = Vector2(guiGetScreenSize())


function ComponentsScreen:init(componentName)
	self.super:init()
local numberplateInfo = exports.tunrc_Shared:getTuningPrices("numberplate")
local componentsList = {
	{name="FrontBump", 	camera="frontBump",  	locale="garage_tuning_component_front_bump", animate={component="FrontBump%u", 		offset=Vector3(0, 0.1, 0)}},
	{name="Fbadge", 	camera="frontBump",  	locale="garage_tuning_component_fbadge"},
	{name="Turbos", 	camera="frontBump",  	locale="garage_tuning_component_turbos"},
	{name="Grills", 	camera="frontBump",  	locale="garage_tuning_component_grills"},
	{name="Frontnumber", 	camera="frontBump",  	locale="garage_tuning_component_frontnumber"},
	{name="WheelsF", 	camera="wheelLF", 		locale="garage_tuning_component_wheels_front"},
	{name="WheelsR", 	camera="wheelLB", 		locale="garage_tuning_component_wheels_rear"},
	{name="RearBump", 	camera="rearBump", 		locale="garage_tuning_component_rear_bump",	 animate={component="RearBump%u", 		offset=Vector3(0, -0.1, 0)}},
	{name="Rearnumber", 	camera="rearBump", 		locale="garage_tuning_component_rearnumber",	 animate={component="Rearnumber%u", 		offset=Vector3(0, -0.1, 0)}},
	{name="Bodykits", 	camera="frontBump",  	locale="garage_tuning_component_bodykits"},
	{name="Canardsr", 	camera="rearBump", 		locale="garage_tuning_component_canardsr",	 animate={component="Canardsr%u", 		offset=Vector3(0, -0.1, 0)}},
	{name="Diffusors", 	camera="rearBump", 		locale="garage_tuning_component_diffusors",	 animate={component="Diffusors%u", 		offset=Vector3(0, -0.1, 0)}},
	{name="Exhaust", 	camera="rearBump", 		locale="garage_tuning_component_exhaust",	 animate={component="Exhaust%u", 		offset=Vector3(0, 0.05, 0)}},
	{name="Exh", 	camera="rearBump", 		locale="garage_tuning_component_exhaust",	 animate={component="Exh%u", 		offset=Vector3(0, 0.05, 0)}},
	{name="RearLights", camera="rearBump", 	locale="garage_tuning_component_rear_lights"},
	{name="Spoilers", 	camera="rearBump", 		locale="garage_tuning_component_spoilers"},
	{name="Roof", 	camera="rearBump", 		locale="garage_tuning_component_roof"},
	{name="RoofS", 	camera="rearBump", 		locale="garage_tuning_component_roofs"},
	{name="Boots", 	camera="rearBump", 		locale="garage_tuning_component_boots"},
	{name="Rbadge", 	camera="rearBump", 		locale="garage_tuning_component_rbadge"},
	{name="Rpanels", 	camera="rearBump", 		locale="garage_tuning_component_rpanel"},
	{name="RearFends", 	camera="rearBump", 	locale="garage_tuning_component_rear_fends", animate={component="RearFends%u", 		offset=Vector3(0.05, 0, 0)}},
	{name="Skirts", camera="skirts", 		locale="garage_tuning_component_side_skirts",animate={component="Skirts%u", 	offset=Vector3(0.1, 0, 0)}},
	{name="FrontFends", camera="frontBump", 	locale="garage_tuning_component_front_fends",animate={component="FrontFends%u", 	offset=Vector3(0.05, 0, 0)}},
	{name="FrontFendsDops", 	camera="frontBump", 		locale="garage_tuning_component_front_fends_dops"},
	{name="Fpanels", 	camera="frontBump", 		locale="garage_tuning_component_fpanel"},
	{name="Mirrors", camera="frontBump", 	locale="garage_tuning_component_mirrors"},
	{name="FrontFendsR", camera="frontBump", 	locale="garage_tuning_component_front_fendsr"},
	{name="FrontFendsL", camera="frontFendsL", 	locale="garage_tuning_component_front_fendsl"},
	{name="Bonnets", 	camera="frontBump", 		locale="garage_tuning_component_bonnet",	 animate={component="Bonnets%u", 		offset=Vector3(0, 0, 0.05)}},
	{name="Eng", 	camera="frontBump", 		locale="garage_tuning_component_engine",	 animate={component="Eng%u", 		offset=Vector3(0, 0, 0.1)}},
	{name="FrontLights",camera="frontBump", 	locale="garage_tuning_component_front_lights"},
	{name="SideLights"      ,camera="frontBump", 	locale="garage_tuning_component_sidelights"},
	{name="FaraR"      ,camera="frontBump", 	locale="garage_tuning_component_FaraR"},
	{name="Dops"       ,camera="frontBump", 	locale="garage_tuning_component_Dops"},		
	{name="FaraL"      ,camera="frontBump", 	locale="garage_tuning_component_FaraL"},		
	{name="Lips"      ,camera="frontBump", 	locale="garage_tuning_component_Lips"},
	{name="RearGls"      ,camera="rearBump", 	locale="garage_tuning_component_reargls"},
	{name="Seats"      ,camera="frontBump", 	locale="garage_tuning_component_Seats"},
	{name="Steering"      ,camera="frontBump", 	locale="garage_tuning_component_Steer"},
	{name="Torpeda"      ,camera="frontBump", 	locale="garage_tuning_component_Torpeda"},
	{name="Karkas"      ,camera="frontBump", 	locale="garage_tuning_component_Karkas"},
	{name="Acces"      ,camera="frontBump", 	locale="garage_tuning_component_Acces"},	
	{name="Canards"      ,camera="frontBump", 	locale="garage_tuning_component_Canards"},
	{name="Intercooler"      ,camera="frontBump", 	locale="garage_tuning_component_intercooler"},		
	{name="Numberplate",camera="frontBump", 	locale="garage_tuning_component_numberplate", price = numberplateInfo[1], level = numberplateInfo[2]},
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
		if componentName == "SteeringTexture" then
			self.screenManager:showScreen(SteeringWheelScreen())
		else
			self.screenManager:showScreen(ComponentScreen(componentName))
		end
	end
end
