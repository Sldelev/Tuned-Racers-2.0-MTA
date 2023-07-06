--- Синхронизация текстуры стекла (наклеек)
-- @script tunrc_Vehicles.glass_stickers

local GLASS_VINYLS_ENABLED = "graphics.enable_glass_vynils"

local surfaces = {
	windows = {
		textureNames = {
			"windows"
		},
		textureSize = 512
	}
}

GLASS_TEXTURE_NAME = "windows"
local STICKER_SIZE = 512

-- Расстояние, на котором загружаются стикеры
local LOAD_DISTANCE = 100
local UPDATE_INTERVAL = 100

local streamedVehicles = {}
local renderedVehicles = {}

local dxStatus = dxGetStatus()

if dxStatus.VideoCardRAM <= 1024 then
	currentMultiplier = 2
elseif dxStatus.VideoCardRAM >= 1500 then
	currentMultiplier = 3
end

local DEFAULT_TEXTURE_SIZE = 1024

local TEXTURE_SIZE = DEFAULT_TEXTURE_SIZE * currentMultiplier
local _TEX_MULT = TEXTURE_SIZE / DEFAULT_TEXTURE_SIZE

local mainRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
local vehicleRenderTarget
local stickersTextures = {}
local selectionTexture

-- Пул renderTarget'ов для ускорения отрисовки
local RT_POOL_SIZE = 5
local RT_POOL_SIZE_LARGE = 5
local renderTargetPool = {}
local usedRenderTargets = {}

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
		for i, sticker in ipairs(stickers) do
			drawSticker(sticker, selected == i)
		end
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

local function setupGlassTexture(vehicle)
	if renderedVehicles[vehicle] then
		return
	end
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	if isElementLocal(vehicle) or vehicle:getData("localVehicle") then
		return
	end
	local stickers = vehicle:getData("stickers")

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

	renderedVehicles[vehicle] = true
end
	
local function updateVehicle(vehicle)
	local x, y, z = getElementPosition(vehicle)
	local distance = getDistanceBetweenPoints3D(x, y, z, cameraX, cameraY, cameraZ)
	if distance <= LOAD_DISTANCE then
		setupGlassTexture(vehicle)
	end
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	selectionTexture = dxCreateTexture("assets/selection.png")
	local dxStatus = dxGetStatus()
	outputDebugString("GlassStickers: VRAM = " .. tostring(dxStatus.VideoMemoryFreeForMTA) .. "/" .. tostring(dxStatus.VideoCardRAM))
	if dxStatus.VideoMemoryFreeForMTA >= 150 then
		local poolSize = RT_POOL_SIZE
		if dxStatus.VideoMemoryFreeForMTA > 500 then
			poolSize = RT_POOL_SIZE_LARGE
			outputDebugString("GlassStickers: Using additional render targrts")
		end
		outputDebugString("GlassStickers: RT_POOL_SIZE = " .. tostring(poolSize))
		for i = 1, poolSize do
			local renderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
			if isElement(renderTarget) then
				table.insert(renderTargetPool, renderTarget)
			else
				break
			end
		end
	else
		outputDebugString("Warning: Not enough VRAM to use render target pool (" .. tostring(tostring(dxStatus.VideoMemoryFreeForMTA)) .. ")")
		outputDebugString("GlassStickers: Using textures only")
		renderTargetPool = {}
	end

	for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
		streamedVehicles[vehicle] = true
	end

	setTimer(function ()
		for vehicle in pairs(streamedVehicles) do
			updateVehicle(vehicle)
		end
	end, UPDATE_INTERVAL, 0)
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
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if isElement(vehicleRenderTarget) then
		return
	end
	if dataName == "stickers" then
		setupGlassTexture(source)
	end
end)

addEvent("tunrc_Vehicles.shadersDestroyed", false)
addEventHandler("tunrc_Vehicles.shadersDestroyed", root, function ()
	freeVehicleRenderTarget(source)
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type ~= "vehicle" then return end
	streamedVehicles[source] = true
end)

addEventHandler("onClientElementStreamOut", root, function()
	if source.type ~= "vehicle" then return end
	streamedVehicles[source] = nil
	renderedVehicles[source] = nil
end)

addEventHandler("onClientElementDestroy", root, function ()
	if source.type ~= "vehicle" then return end
	streamedVehicles[source] = nil
	renderedVehicles[source] = nil
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    cameraX, cameraY, cameraZ = getCameraMatrix()
end)

addCommandHandler("Cclear", function ()
	for i, sticker in pairs(stickersTextures) do
		if isElement(stickersTextures[i].texture) then
			destroyElement(stickersTextures[i].texture)
		end
		stickersTextures[i] = nil
	end
	outputConsole("Sticker cache cleared")
end)
