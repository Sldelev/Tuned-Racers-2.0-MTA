--- Синхронизация текстуры стекла (наклеек)
-- @script tunrc_Vehicles.glass_stickers

local surfaces = {
	windows = {
		textureNames = {
			"windows"
		},
		textureSize = 512
	}
}

-- default values
local DEFAULT_TEXTURE_SIZE = 1024
GLASS_TEXTURE_NAME = "windows"
BODY_TEXTURE_NAME = "body"
local STICKER_SIZE = 512

--calculate texture sizes
local currentMultiplier = exports.tunrc_Config:getProperty("graphics.wraps_quality") + 1
local TEXTURE_SIZE = DEFAULT_TEXTURE_SIZE * currentMultiplier
local _TEX_MULT = TEXTURE_SIZE / DEFAULT_TEXTURE_SIZE

-- render targets
mainRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
mainBodyRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
mainBodyStickersRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)

vehicleRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE)
vehicleBodyRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE)
vehicleBodyStickersRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE)

local dxStatus = dxGetStatus()

local vehicleRenderTarget
local vehicleBodyRenderTarget
local vehicleBodyStickersRenderTarget
local stickersTextures = {}
local selectionTexture

-- Пул renderTarget'ов для ускорения отрисовки
local RT_POOL_SIZE = 5
local RT_POOL_SIZE_LARGE = 5

local renderTargetPool = {}
local renderBodyTargetPool = {}
local renderBodyStickersTargetPool = {}

local usedRenderTargets = {}
local usedBodyRenderTargets = {}
local usedBodyStickersRenderTargets = {}

local function getVehicleRenderTarget(vehicle)
	if not vehicle then
		outputDebugString("getVehicleRenderTarget: No vehicle")
		return false
	end

	if isElement(usedRenderTargets[vehicle]) then
		return usedRenderTargets[vehicle]
	end

	if #renderTargetPool == 0 then
		return mainRenderTarget
	end

	usedRenderTargets[vehicle] = table.remove(renderTargetPool, 1)
	return usedRenderTargets[vehicle]
end

local function getVehicleBodyRenderTarget(vehicle)
	if not vehicle then
		outputDebugString("getVehicleRenderTarget: No vehicle")
		return false
	end

	if isElement(usedBodyRenderTargets[vehicle]) then
		return usedBodyRenderTargets[vehicle]
	end
	
	if #renderBodyTargetPool == 0 then
		--outputDebugString("BodyTexture: renderBodyTargetPool is empty. Using main RT")
		return mainBodyRenderTarget
	end

	usedBodyRenderTargets[vehicle] = table.remove(renderBodyTargetPool, 1)
	return usedBodyRenderTargets[vehicle]
end

local function getVehicleBodyStickersRenderTarget(vehicle)
	if not vehicle then
		outputDebugString("getVehicleRenderTarget: No vehicle")
		return false
	end

	if isElement(usedBodyStickersRenderTargets[vehicle]) then
		return usedBodyStickersRenderTargets[vehicle]
	end
	
	if #renderBodyStickersTargetPool == 0 then
		--outputDebugString("BodyTexture: renderBodyTargetPool is empty. Using main RT")
		return mainBodyStickersRenderTarget
	end

	usedBodyStickersRenderTargets[vehicle] = table.remove(renderBodyTargetPool, 1)
	return usedBodyStickersRenderTargets[vehicle]
end

local function freeVehicleRenderTarget(vehicle)
	if not vehicle then
		return false
	end
	if usedRenderTargets[vehicle] then
		table.insert(renderTargetPool, usedRenderTargets[vehicle])
		usedRenderTargets[vehicle] = nil
		return true
	end
	return false
end

local function freeVehicleBodyRenderTarget(vehicle)
	if not vehicle then
		return false
	end
	if usedBodyRenderTargets[vehicle] then
		table.insert(renderBodyTargetPool, usedBodyRenderTargets[vehicle])
		usedBodyRenderTargets[vehicle] = nil
		--outputDebugString("Free RT")
		return true
	end
	return false
end

local function freeVehicleBodyStickersRenderTarget(vehicle)
	if not vehicle then
		return false
	end
	if usedBodyStickersRenderTargets[vehicle] then
		table.insert(renderBodyStickersTargetPool, usedBodyStickersRenderTargets[vehicle])
		usedBodyStickersRenderTargets[vehicle] = nil
		--outputDebugString("Free RT")
		return true
	end
	return false
end

local function drawSticker(sticker, selected)
	local x, y, width, height, stickerId, rotation, color, mirror, mirrorText, mirrorFixed  = unpack(sticker)
	if  type(x) ~= "number" or
		type(y) ~= "number" or
		type(width) ~= "number" or
		type(height) ~= "number" or
		type(stickerId) ~= "number"
	then
		return
	end
	local texture = stickersTextures[stickerId]
	if not isElement(texture) then
		stickersTextures[stickerId] = exports.tunrc_Stickers:createTexture("stickers/" .. tostring(stickerId) .. ".png", "dxt5")
		texture = stickersTextures[stickerId]
	end
	x = x * _TEX_MULT
	y = y * _TEX_MULT
	width = width * _TEX_MULT
	height = height * _TEX_MULT
	if selected then
		dxDrawImage(x - width / 2, y - height / 2, width, height, selectionTexture, rotation)
	end
	dxDrawImage(x - width / 2, y - height / 2, width, height, texture, rotation, 0, 0, color)
	-- Отраженная наклейка
	if mirror then
		if mirrorText then
			dxDrawImage(TEXTURE_SIZE - x - width / 2 + width, y - height / 2 + height, -width, -height, texture, 180-rotation, 0, 0, color)
		else
			dxDrawImage(TEXTURE_SIZE - x - width / 2, y - height / 2, width, height, texture, 180-rotation, 0, 0, color)
		end
	-- Fixed mirroring
	elseif mirrorFixed then
		dxDrawImage(TEXTURE_SIZE - x - width / 2, y - height / 2 + height, width, -height, texture, 180 - rotation, 0, 0, color)
	end
end

function redrawGlassRenderTarget(renderTarget, stickers, selected)
	if not isElement(renderTarget) then
		return
	end
	if not selected then
		selected = 0
	end
	dxSetRenderTarget(renderTarget, true)
	if type(stickers) == "table" then
		dxSetBlendMode("modulate_add")
			for i, sticker in ipairs(stickers) do
				drawSticker(sticker, selected == i)
			end
		dxSetBlendMode("blend")
	end
	dxSetRenderTarget()
end

function redrawBodyRenderTarget(bodyRenderTarget, bodyColor)
	if not isElement(bodyRenderTarget) then
		return
	end
	dxSetRenderTarget(bodyRenderTarget, true)
	if bodyColor then
		dxDrawRectangle(0, 0, TEXTURE_SIZE, TEXTURE_SIZE, tocolor(bodyColor[1], bodyColor[2], bodyColor[3]))
	end
	dxSetRenderTarget()
end

function redrawBodyStickersRenderTarget(bodyStickersRenderTarget, stickers, selected)
	if not isElement(bodyStickersRenderTarget) then
		return
	end
	if not selected then
		selected = 0
	end
	dxSetRenderTarget(bodyStickersRenderTarget, true)
	if type(stickers) == "table" then
		dxSetBlendMode("modulate_add")
			for i, sticker in ipairs(stickers) do
				drawSticker(sticker, selected == i)
			end
		dxSetBlendMode("blend")
	end
	dxSetRenderTarget()
end

function createVehicleRenderTarget(vehicle)
	if not isElement(vehicle) then
		return
	end
	if isElement(vehicleRenderTarget) then
		destroyElement(vehicleRenderTarget)
	end
	vehicleRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
	for _, textureName in pairs(surfaces.windows.textureNames) do
		VehicleShaders.replaceGlass(vehicle, textureName, vehicleRenderTarget)
	end
	return vehicleRenderTarget
end

function createVehicleBodyRenderTarget(vehicle, SpecularColor, Chrome)
	if not isElement(vehicle) then
		return
	end
	if isElement(vehicleBodyRenderTarget) then
		destroyElement(vehicleBodyRenderTarget)
	end
	vehicleBodyRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE)
	
	local bodyColor = vehicle:getData("BodyColor")
	if not SpecularColor then
		SpecularColor = bodyColor
	end
	if not Chrome then
		Chrome = 0.25
	end
	VehicleShaders.replaceBody(vehicle, BODY_TEXTURE_NAME, vehicleBodyRenderTarget, SpecularColor, Chrome)
	return vehicleBodyRenderTarget
end

function createVehicleBodyStickersRenderTarget(vehicle)
	if not isElement(vehicle) then
		return
	end
	if isElement(vehicleBodyStickersRenderTarget) then
		destroyElement(vehicleBodyStickersRenderTarget)
	end
	vehicleBodyStickersRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
	
	VehicleShaders.replaceBodyStickers(vehicle, BODY_TEXTURE_NAME, vehicleBodyStickersRenderTarget)
	return vehicleBodyStickersRenderTarget
end

local function setupGlassTexture(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	if isElementLocal(vehicle) or vehicle:getData("localVehicle") then
		return
	end
	local stickers = vehicle:getData("windows_stickers")

	local renderTarget = getVehicleRenderTarget(vehicle)
	redrawGlassRenderTarget(renderTarget, stickers)
	local texture
	if renderTarget == mainRenderTarget then
		-- Копирование содержимого renderTarget'а в текстуру
		local pixels = dxGetTexturePixels(mainRenderTarget)
		local texture = dxCreateTexture(TEXTURE_SIZE , TEXTURE_SIZE)
		dxSetTexturePixels(texture, pixels)
		for _, textureName in pairs(surfaces.windows.textureNames) do
			VehicleShaders.replaceGlass(vehicle, textureName, texture)
		end
		destroyElement(texture)
	else
		for _, textureName in pairs(surfaces.windows.textureNames) do
			VehicleShaders.replaceGlass(vehicle, textureName, renderTarget)
		end
	end
end

local function setupVehicleTexture(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	if isElementLocal(vehicle) or vehicle:getData("localVehicle") then
		return
	end
	local bodyColor = vehicle:getData("BodyColor")
	local SpecularColor = vehicle:getData("SpecularColor")
	local Chrome = vehicle:getData("ChromePower")
	local bodyTexture = vehicle:getData("BodyTexture")
	
	-- кузов
	local bodyRenderTarget = getVehicleBodyRenderTarget(vehicle)
	redrawBodyRenderTarget(bodyRenderTarget, bodyColor)
	
	if bodyRenderTarget then
		VehicleShaders.replaceBody(vehicle, BODY_TEXTURE_NAME, bodyRenderTarget, SpecularColor, Chrome)
	end
	
	local texture
	
	if bodyRenderTarget == mainBodyRenderTarget then
		-- Копирование содержимого renderTarget'а в текстуру
		local pixels = dxGetTexturePixels(mainBodyRenderTarget)
		local texture = dxCreateTexture(TEXTURE_SIZE, TEXTURE_SIZE)
		dxSetTexturePixels(texture, pixels)
		VehicleShaders.replaceBody(vehicle, BODY_TEXTURE_NAME, texture, SpecularColor, Chrome)
		destroyElement(texture)
	else
		VehicleShaders.replaceTexture(vehicle, BODY_TEXTURE_NAME, bodyRenderTarget, SpecularColor, Chrome)
	end
end

local function setupVehicleStickersTexture(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	if isElementLocal(vehicle) or vehicle:getData("localVehicle") then
		return
	end
	local stickers = vehicle:getData("stickers")
	
	-- стикеры на кузове
	local bodyStickersRenderTarget = getVehicleBodyStickersRenderTarget(vehicle)
	redrawBodyStickersRenderTarget(bodyStickersRenderTarget, stickers)
	
	local texture
	
	if bodyStickersRenderTarget == mainBodyStickersRenderTarget then
		--outputDebugString("Copy body RenderTarget to texture")
		-- Копирование содержимого renderTarget'а в текстуру
		local pixels = dxGetTexturePixels(mainBodyStickersRenderTarget)
		local texture = dxCreateTexture(TEXTURE_SIZE, TEXTURE_SIZE)
		dxSetTexturePixels(texture, pixels)
		VehicleShaders.replaceBodyStickers(vehicle, BODY_TEXTURE_NAME, texture)
		destroyElement(texture)
	else
		VehicleShaders.replaceBodyStickers(vehicle, BODY_TEXTURE_NAME, bodyStickersRenderTarget)
	end
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	selectionTexture = dxCreateTexture("assets/selection.png")
	local dxStatus = dxGetStatus()
	outputDebugString("Wraps: VRAM = " .. tostring(dxStatus.VideoMemoryFreeForMTA) .. "/" .. tostring(dxStatus.VideoCardRAM))
	if dxStatus.VideoMemoryFreeForMTA <= 150 then
		outputDebugString("Warning: Not enough VRAM to use render target pool (" .. tostring(tostring(dxStatus.VideoMemoryFreeForMTA)) .. ")")
		outputDebugString("Wraps: Using textures only")
		renderTargetPool = {}
		renderBodyTargetPool = {}
	end

	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupGlassTexture(vehicle)
		setupVehicleTexture(vehicle)
		setupVehicleStickersTexture(vehicle)
	end
end)

addCommandHandler("getinfo",
	function ()
		local info = dxGetStatus ()
		for k, v in pairs (info) do
			outputDebugString (k .. " : " .. tostring (v))
		end
	end
)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupGlassTexture(vehicle)
		setupVehicleTexture(vehicle)
		setupVehicleStickersTexture(vehicle)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if isElement(vehicleRenderTarget) then
		return
	end
	
	if isElement(vehicleBodyRenderTarget) then
		return
	end
	
	if isElement(vehicleBodyStickersRenderTarget) then
		return
	end
	
	if dataName == "BodyColor" then
		setupVehicleTexture(source)
	end
	
	if dataName == "stickers" then
		setupVehicleStickersTexture(source)
	end
	
	if dataName == "windows_stickers" then
		setupGlassTexture(source)
	end
	
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupGlassTexture(source)
		setupVehicleTexture(source)
		setupVehicleStickersTexture(source)
	end
end)

addEvent("tunrc_Vehicles.shadersDestroyed", false)
addEventHandler("tunrc_Vehicles.shadersDestroyed", root, function ()
	freeVehicleRenderTarget(source)
	freeVehicleBodyRenderTarget(source)
	freeVehicleBodyStickersRenderTarget(source)
end)

--[[addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
	if key == "graphics.wraps_quality" then
		for i, vehicle in ipairs(getElementsByType("vehicle")) do
			setupGlassTexture(vehicle)
		end
	end
end)]]

addCommandHandler("Cclear", function ()
	for i, sticker in pairs(stickersTextures) do
		if isElement(stickersTextures[i].texture) then
			destroyElement(stickersTextures[i].texture)
		end
		stickersTextures[i] = nil
	end
	outputConsole("Sticker cache cleared")
end)
