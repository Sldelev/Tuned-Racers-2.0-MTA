VehicleTuning = {}

VehicleTuning.defaultTuningTable = {
-- Цвета
	BodyColor 		= {120, 120, 120},	-- Цвет кузова
	WheelsColorR 	= {155, 155, 155},	-- Цвет задних дисков
	WheelsColorF 	= {155, 155, 155},	-- Цвет передних дисков
	BoltsColorR 	= {205, 205, 205},	-- Цвет задних дисков
	BoltsColorF 	= {205, 205, 205},	-- Цвет передних дисков
	BodyTexture 	= false,			-- Текстура кузова
	SmokeColor 	= {220, 220, 220},	-- Цвет дыма
	RollcageColor 	= {220, 220, 220},	-- Цвет каркаса
	EngBlockColor 	= {200, 120, 120},	-- Цвет ГБЦ
	NeonColor 		= false,			-- Цвет неона
	SpoilerColor	= false,			-- Цвет неона
	ChromePower	= 12,			-- сила хрома

	-- Дополнительно
	Numberplate 	= "TRC2023", 	-- Текст номерного знака
	Nitro 			= 0, -- Уровень нитро

	-- Колёса
	WheelsAngleF 	= 0, -- Развал передних колёс
	WheelsAngleR 	= 0, -- Развал задних колёс
	WheelsSizeF		= 0.69, -- Размер 
	WheelsSizeR		= 0.69, -- Размер 
	WheelsWidthF 	= 0, -- Толщина передних колёс
	WheelsWidthR	= 0, -- Толщина задних колёс
	WheelsOffsetF	= 0, -- Вынос передних колёс
	WheelsOffsetR	= 0, -- Вынос задних колёс
	WheelsF 		= 0, -- Передние диски
	WheelsR 		= 0, -- Задние диски
	WheelsCaliperF 		= 1, -- Передние диски
	WheelsCaliperR 		= 1, -- Задние диски
	WheelsCastor  = 5, -- Кастор

	-- Компоненты
	Spoilers 		= 0, -- Спойлер	
	FrontBump		= 0, -- Задний бампер
	RearBump		= 0, -- Передний бампер
	Skirts		= 0, -- Юбки
	Bonnets			= 0, -- Капот
	RearLights		= 0, -- Задние фары
	FrontFends		= 0, -- Передние фендеры
	RearFends		= 0, -- Задние фендеры
	Exhaust			= 0, -- Глушитель
	Acces			= 0, -- Аксессуары
	Lips			= 0,
	Dops			= 0,
	FaraL			= 0,
	FaraR			= 0,
	Extraone			= 0,
	Extratwo			= 0,
	Extrathree			= 0,
	Extrafour			= 0,
	Extrafive			= 0,
	Seats			= 0,
	Steer			= 0,
	Torpeda			= 0,
	Karkas			= 0,
	Acces			= 0,
	Canards			= 0,
	Diffusors			= 0,
	Intercooler			= 0,
	Eng			= 0,
	Exh			= 0,
	Canardsr			= 0,
	Boots			= 0,
	RoofS			= 0,
	Rearnumber			= 0,
	Bodykits			= 0,

	-- Настройки
	Suspension 		= 0.4, -- Высота подвески
	Bias 	= 0.5, -- Bias подвески
	Brakedist		    = 0.5,
	Brakepower		    = 0.5,
	FrontTires		    = 0.5,
	RearTires		    = 0.5,
	LoadBias		    = 0.5,
	Steer		    = 55,
	Boost		    = 250,

	-- Улучшения
	StreetHandling 	= 1, -- Уровень стрит-хандлинга
	DriftHandling  	= 1, -- Уровень дрифт-хандлинга
}

function VehicleTuning.applyToVehicle(vehicle, tuningJSON, stickersJSON, windowsStickersJSON)
	if not isElement(vehicle) then
		return false
	end

	-- Тюнинг
	pcall(function ()
		local tuningTable
		if type(tuningJSON) == "string" then
			tuningTable = fromJSON(tuningJSON)
		end
		if not tuningTable then
			tuningTable = {}
		end
		-- Размер колёс по-умолчанию
		if not tuningTable["WheelsSize"] then
			tuningTable["WheelsSize"] = exports.tunrc_Vehicles:getModelDefaultWheelsSize(vehicle.model)
		end
		-- Выставление полей по-умолчанию
		for k, v in pairs(VehicleTuning.defaultTuningTable) do
			if not tuningTable[k] then
				tuningTable[k] = v
			end
		end
		-- Перенос тюнинга в дату
		for k, v in pairs(tuningTable) do
			vehicle:setData(k, v)
		end
	end)

	-- Наклейки
	pcall(function ()
		if type(stickersJSON) == "string" then
			vehicle:setData("stickers", fromJSON(stickersJSON) or {})
		end
		if type(windowsStickersJSON) == "string" then
			vehicle:setData("windows_stickers", fromJSON(windowsStickersJSON) or {})
		end
	end)
end

function VehicleTuning.updateVehicleTuning(vehicleId, tuning, stickers, windowsStickers)
	if not vehicleId then
		return false
	end
	local update = {}
	if tuning then
		local tuningJSON = toJSON(tuning)
		if tuningJSON then
			update.tuning = tuningJSON
		end		
	end
	if stickers then
		local stickersJSON = toJSON(stickers, true)
		if stickersJSON then
			update.stickers = stickersJSON
		end
	end
	if windowsStickers then
		update.windows_stickers = toJSON(windowsStickers, true) or nil
	end

	return UserVehicles.updateVehicle(vehicleId, update)
end