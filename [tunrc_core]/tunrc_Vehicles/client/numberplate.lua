local NUMBERPLATE_TEXTURE_NAME = "numberplate"
local NUMBERPLATE_WIDTH = 512
local NUMBERPLATE_HEIGHT = 128

local mainRenderTarget = dxCreateRenderTarget(NUMBERPLATE_WIDTH, NUMBERPLATE_HEIGHT, true)

local backgroundTexture
local textFont

local table_scale_numbers = {
	ny={
		textOffsetX = 140,
		textOffsetY = 120,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.7,
		textColorR = 65,
		textColorG = 105,
		textColorB = 225
	},
	nj={
		textOffsetX = 140,
		textOffsetY = 120,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 2,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	nc={
		textOffsetX = 140,
		textOffsetY = 120,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 2,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	ny1={
		textOffsetX = 140,
		textOffsetY = 120,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.7,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	ny2={
		textOffsetX = 140,
		textOffsetY = 120,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.7,
		textColorR = 14,
		textColorG = 49,
		textColorB = 70
	},
	virg={
		textOffsetX = 140,
		textOffsetY = 120,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 2,
		textColorR = 26,
		textColorG = 39,
		textColorB = 83
	},
	mont={
		textOffsetX = 140,
		textOffsetY = 130,
		textWidth = 256,
		textSize = 40,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 4.5,
		textBreadth = 1.5,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	haw={
		textOffsetX = 140,
		textOffsetY = 110,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 2,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	maine={
		textOffsetX = 180,
		textOffsetY = 110,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.9,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	alas={
		textOffsetX = 140,
		textOffsetY = 110,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 2.2,
		textColorR = 43,
		textColorG = 45,
		textColorB = 100
	},
	col={
		textOffsetX = 140,
		textOffsetY = 110,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 2,
		textColorR = 16,
		textColorG = 48,
		textColorB = 41
	},
	rho={
		textOffsetX = 140,
		textOffsetY = 110,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.8,
		textColorR = 16,
		textColorG = 20,
		textColorB = 82
	},
	tex={
		textOffsetX = 140,
		textOffsetY = 110,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.8,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	wash={
		textOffsetX = 140,
		textOffsetY = 140,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.9,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	scar={
		textOffsetX = 140,
		textOffsetY = 120,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.9,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	ohio={
		textOffsetX = 140,
		textOffsetY = 140,
		textWidth = 256,
		textSize = 44,
		textHeight = 30,
		textOffsetX1 = 280,
		textOffsetY1 = 55,
		textWidth1 = 78,
		textSize1 = 24,
		textHeight1 = 5,
		textBreadth = 1.7,
		textColorR = 0,
		textColorG = 0,
		textColorB = 0
	},
	jp1={
		textOffsetX = 240,
		textOffsetY = 20,
		textWidth = 100,
		textSize = 18,
		textHeight = 150,
		textOffsetX1 = 10,
		textOffsetY1 = 55,
		textWidth1 = 50,
		textSize1 = 44,
		textHeight1 = 10,
		textBreadth = 2.5,
		textColorR = 17,
		textColorG = 68,
		textColorB = 36
	},
	jp2={
		textOffsetX = 240,
		textOffsetY = 20,
		textWidth = 100,
		textSize = 18,
		textHeight = 150,
		textOffsetX1 = 10,
		textOffsetY1 = 55,
		textWidth1 = 50,
		textSize1 = 44,
		textHeight1 = 10,
		textBreadth = 2.5,
		textColorR = 17,
		textColorG = 68,
		textColorB = 36
	},
	jp3={
		textOffsetX = 240,
		textOffsetY = 20,
		textWidth = 100,
		textSize = 18,
		textHeight = 150,
		textOffsetX1 = 10,
		textOffsetY1 = 55,
		textWidth1 = 50,
		textSize1 = 44,
		textHeight1 = 10,
		textBreadth = 2.5,
		textColorR = 17,
		textColorG = 68,
		textColorB = 36
	}
}

local table_scale_numbers_i = {"ny", "nj", "nc", "ny1", "ny2", "virg", "mont", "haw", "maine", "alas", "col", "rho", "tex", "wash", "scar", "ohio", "jp1", "jp2", "jp3"}

function setData_NumberTable(vehicle)
local i = getCountryNumberTable(vehicle)
	if i + 1 <= #table_scale_numbers_i then
		exports.tunrc_Garage:applyTuning("Country", table_scale_numbers_i[i + 1])
	else
		exports.tunrc_Garage:applyTuning("Country", table_scale_numbers_i[1])
	end
end

function getCountryNumberTable(vehicle)
local i=0
	for i, name in pairs(table_scale_numbers_i) do
		if name == vehicle:getData("Country") then
			return i
		end
	end
end

local i = 0

function drawNumberplate(renderTarget, text, country)
	if not isElement(renderTarget) then
		return
	end
	dxSetRenderTarget(renderTarget, true)
	dxDrawImage(0, 0, NUMBERPLATE_WIDTH, NUMBERPLATE_HEIGHT, backgroundTexture)
	
	--dxDrawText(tostring(text:sub(0, text:len)), table_scale_numbers[country].textOffsetX, 0, table_scale_numbers[country].textOffsetX + table_scale_numbers[country].textWidth, table_scale_numbers[country].textOffsetY + table_scale_numbers[country].textHeight, tocolor(0, 0, 0, 230), 1, textFont, "center", "center") --text:sub(0,text:len()-3)
	if country == "jp1" or country == "jp2" or country == "jp3" then
	dxDrawText(tostring(text), table_scale_numbers[country].textOffsetX, 0, table_scale_numbers[country].textOffsetX + table_scale_numbers[country].textWidth, table_scale_numbers[country].textOffsetY + table_scale_numbers[country].textHeight, tocolor(table_scale_numbers[country].textColorR, table_scale_numbers[country].textColorG, table_scale_numbers[country].textColorB, 255), table_scale_numbers[country].textBreadth, 1, textFont1, "center", "center") --text:sub(0,text:len()-3)
	else
	dxDrawText(tostring(text), table_scale_numbers[country].textOffsetX, 0, table_scale_numbers[country].textOffsetX + table_scale_numbers[country].textWidth, table_scale_numbers[country].textOffsetY + table_scale_numbers[country].textHeight, tocolor(table_scale_numbers[country].textColorR, table_scale_numbers[country].textColorG, table_scale_numbers[country].textColorB, 255), table_scale_numbers[country].textBreadth, 1, textFont, "center", "center") --text:sub(0,text:len()-3)
	end
	dxSetRenderTarget()
end

local function setupVehicleNumberplate(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	local numberplate = vehicle:getData("Numberplate")
	local country = vehicle:getData("Country")
	if not numberplate or not country then
		return
	end
	
	backgroundTexture = dxCreateTexture("assets/numberplates/numberplate_" .. country .. ".png")
	
	textFont = dxCreateFont("assets/numberplate.ttf", table_scale_numbers[country].textSize)
	--Тестовый шрифт (можно заменить на свой)
	textFont1 = dxCreateFont("assets/japanfont.ttf", table_scale_numbers[country].textSize1)
	drawNumberplate(mainRenderTarget, numberplate, country)
	-- Копирование содержимого renderTarget'а в текстуру
	local pixels = dxGetTexturePixels(mainRenderTarget)
	local texture = dxCreateTexture(NUMBERPLATE_WIDTH, NUMBERPLATE_HEIGHT)
	dxSetTexturePixels(texture, pixels)
	-- Применение текстуры к автомобилю
	VehicleShaders.replaceTexture(vehicle, NUMBERPLATE_TEXTURE_NAME, texture)
	destroyElement(texture)
end

-- Обновить номеров всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleNumberplate(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleNumberplate(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupVehicleNumberplate(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Country" then
		setupVehicleNumberplate(source)
	end
	if dataName == "Numberplate" then
		setupVehicleNumberplate(source)
	end
end)
