VehicleTuning = {}

VehicleTuning.defaultTuningTable = {
-- Цвета
	BodyColor 		= {220, 220, 220},	-- Цвет кузова
	WheelsColorR 	= {155, 155, 155},	-- Цвет задних дисков
	WheelsColorF 	= {155, 155, 155},	-- Цвет передних дисков
	BodyTexture 	= false,			-- Текстура кузова
	SpoilerColor	= {220, 220, 220},			-- Цвет спойлера
	FrontFendColor = {220, 220, 220},            -- Передний фендер
	FrontBumpColor = {220, 220, 220},            -- Передний фендер
	BonnetColor = {220, 220, 220},            -- Передний фендер
	SideSkirtsColor = {220, 220, 220},            -- Передний фендер
	RearFendColor = {220, 220, 220},            -- Передний фендер
	RearBumpColor = {220, 220, 220},            -- Передний фендер
	ExtraOneColor = {220, 220, 220},            -- Передний фендер
	ExtraTwoColor = {220, 220, 220},            -- Передний фендер
	ExtraThreeColor = {220, 220, 220},            -- Передний фендер
	ExtraFourColor = {220, 220, 220},            -- Передний фендер
	KarkasColor = {220, 220, 220},            -- Передний фендер
	FenderRightColor = {220, 220, 220},            -- Передний фендер
	FenderLeftColor = {220, 220, 220},            -- Передний фендер
	DopsColor = {220, 220, 220},            -- Передний фендер
	LipsColor = {220, 220, 220},            -- Передний фендер
	WheelsColorR 	= {220, 220, 220, 128},	-- Цвет задних дисков
	WheelsColorF 	= {220, 220, 220, 128},	-- Цвет передних дисков
	NeonColor 		= false,			-- Цвет неона
	SpoilerColor	= false,			-- Цвет спойлера

	-- Дополнительно
	Numberplate 	= "SFSC", 	-- Текст номерного знака
	Nitro 			= 0, -- Уровень нитро

	-- Колёса
	WheelsAngleF 	= 0, -- Развал передних колёс
	WheelsAngleR 	= 0, -- Развал задних колёс
	WheelsSize		= 0.69, -- Размер 
	WheelsWidthF 	= 0, -- Толщина передних колёс
	WheelsWidthR	= 0, -- Толщина задних колёс
	WheelsOffsetF	= 0, -- Вынос передних колёс
	WheelsOffsetR	= 0, -- Вынос задних колёс
	WheelsF 		= 0, -- Передние диски
	WheelsR 		= 0, -- Задние диски

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
	StreetHandling 	= 0, -- Уровень стрит-хандлинга
	DriftHandling  	= 1, -- Уровень дрифт-хандлинга
}

function VehicleTuning.applyToVehicle(vehicle, tuningJSON, stickersJSON)
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
		local stickersTable
		if type(stickersJSON) == "string" then
			stickersTable = fromJSON(stickersJSON)
		end
		if not stickersTable then
			stickersTable = {}
		end
		vehicle:setData("stickers", stickersTable)
	end)
end

function VehicleTuning.updateVehicleTuning(vehicleId, tuning, stickers)
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
		local stickersJSON = toJSON(stickers)
		if stickersJSON then
			update.stickers = stickersJSON
		end			
	end

	return UserVehicles.updateVehicle(vehicleId, update)
end