-- Цены на тюнинг
local tuningPrices = {
	-- Покраска кузова
	body_color = {50, 1},
	-- Смена номерного знака
	numberplate = {50, 1},
	-- Смена высоты подвески
	suspension = {20, 1},
	suspensionBias = {20, 1},
	-- Спойлеры
	spoiler_color = {50, 1},
	frontfend_color = {50, 1},
	spoilers = {
	},
	-- Колёса
	wheels_size = {0, 1},
	wheels_advanced = {25, 1},	
	wheels_color = {20, 1},
	wheels = {
		{500, 1}, -- 1
		{500, 1}, -- 2		
		{400, 1}, -- 3
		{200, 1}, -- 4
		{300, 1}, -- 5
		{450, 1}, -- 
		{576, 1}, -- 7
		{400, 1}, -- 8	
		{500, 1}, -- 9
		{800, 1}, -- 10
		{800, 1}, -- 11
		{800, 1}, -- 12
		{800, 1}, -- 13
		{500, 1}, -- 14	
		{300, 1}, -- 15
		{800, 1}, -- 10
		{800, 1}, -- 11
		{800, 1}, -- 12
		{800, 1}, -- 13
		{500, 1},
		{500, 1},
		{800, 1}, -- 10
		{800, 1}, -- 11
		{800, 1}, -- 12
		{800, 1}
	},
	calipers = {
		{150, 1}, -- 1
		{170, 1} -- 2		
	},	
	tires = {
		{100, 1}, -- 1
		{125, 1} -- 2	
	},
	exhausts = {
	},
	-- Улучшения
	upgrades_level = 1,
	upgrade_price_drift = 0,
	upgrade_price_street = 100,
}

function getTuningPrices(name)
	if name then
		if tuningPrices[name] then
			return tuningPrices[name]
		else
			return {0, 1, false}
		end
	end
end