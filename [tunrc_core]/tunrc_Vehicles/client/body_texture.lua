--- Синхронизация текстуры кузова (наклеек)
-- @script dpVehicles.body_texture
BODY_TEXTURE_NAME = "body"

local DEFAULT_TEXTURE_SIZE = 1024

local TEXTURE_SIZE = DEFAULT_TEXTURE_SIZE * currentMultiplier


local _TEX_MULT = TEXTURE_SIZE / DEFAULT_TEXTURE_SIZE
local STICKER_SIZE = 512

local mainRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
local vehicleBodyRenderTarget
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
		--outputDebugString("BodyTexture: renderTargetPool is empty. Using main RT")
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
		--outputDebugString("Free RT")
		return true
	end
	return false
end

local function drawSticker(sticker, selected)
	local x, y, width, height, stickerId, rotation, color, mirror, mirrorText, mirrorFixed = unpack(sticker)
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
		stickersTextures[stickerId] = exports.tunrc_Assets:createTexture("stickers/" .. tostring(stickerId) .. ".png")
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

function redrawBodyRenderTarget(bodyRenderTarget, bodyColor, bodyTexture, stickers, selected)
	if not isElement(bodyRenderTarget) then
		return
	end
	if not selected then
		selected = 0
	end
	dxSetRenderTarget(bodyRenderTarget, true)
	if bodyColor then
		dxDrawRectangle(0, 0, TEXTURE_SIZE, TEXTURE_SIZE, tocolor(bodyColor[1], bodyColor[2], bodyColor[3]))
	end
	if bodyTexture then
		dxDrawImage(0, 0, TEXTURE_SIZE, bodyTextureSize, bodyTexture)
	end
	if type(stickers) == "table" then
		for i, sticker in ipairs(stickers) do
			drawSticker(sticker, selected == i)
		end
	end
	dxSetRenderTarget()
end

function createVehicleBodyRenderTarget(vehicle)
	if not isElement(vehicle) then
		return
	end
	if isElement(vehicleBodyRenderTarget) then
		destroyElement(vehicleBodyRenderTarget)
	end
	vehicleBodyRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE)
	VehicleShaders.replaceTexture(vehicle, BODY_TEXTURE_NAME, vehicleBodyRenderTarget)
	return vehicleBodyRenderTarget
end

local function setupVehicleTexture(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	if isElementLocal(vehicle) or vehicle:getData("localVehicle") then
		return
	end
	local bodyColor = vehicle:getData("BodyColor")
	local bodyTexture = vehicle:getData("BodyTexture")
	local stickers = vehicle:getData("stickers")

	local bodyRenderTarget = getVehicleRenderTarget(vehicle)
	redrawBodyRenderTarget(bodyRenderTarget, bodyColor, bodyTexture, stickers)
	local texture
	if bodyRenderTarget == mainRenderTarget then
		-- Копирование содержимого renderTarget'а в текстуру
		local pixels = dxGetTexturePixels(mainRenderTarget)
		local texture = dxCreateTexture(TEXTURE_SIZE, TEXTURE_SIZE)
		dxSetTexturePixels(texture, pixels)
		VehicleShaders.replaceTexture(vehicle, BODY_TEXTURE_NAME, texture)
		destroyElement(texture)
	else
		VehicleShaders.replaceTexture(vehicle, BODY_TEXTURE_NAME, bodyRenderTarget)
	end
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	selectionTexture = dxCreateTexture("assets/selection.png")
	local dxStatus = dxGetStatus()
	--dxStatus.VideoMemoryFreeForMTA = 100
	outputDebugString("BodyTexture: VRAM = " .. tostring(dxStatus.VideoMemoryFreeForMTA) .. "/" .. tostring(dxStatus.VideoCardRAM))
	if dxStatus.VideoMemoryFreeForMTA >= 150 then
		local poolSize = RT_POOL_SIZE
		if dxStatus.VideoMemoryFreeForMTA > 500 then
			poolSize = RT_POOL_SIZE_LARGE
			outputDebugString("BodyTexture: Using additional render targrts")
		end
		outputDebugString("BodyTexture: RT_POOL_SIZE = " .. tostring(poolSize))
		for i = 1, poolSize do
			local bodyRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE)
			if isElement(bodyRenderTarget) then
				table.insert(renderTargetPool, bodyRenderTarget)
			else
				break
			end
		end
	else
		outputDebugString("Warning: Not enough VRAM to use render target pool (" .. tostring(tostring(dxStatus.VideoMemoryFreeForMTA)) .. ")")
		outputDebugString("BodyTexture: Using textures only")
		renderTargetPool = {}
	end

	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleTexture(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleTexture(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupVehicleTexture(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if isElement(vehicleBodyRenderTarget) then
		return
	end
	if dataName == "BodyColor" or dataName == "stickers" then
		setupVehicleTexture(source)
	end
end)

addEvent("tunrc_Vehicles.shadersDestroyed", false)
addEventHandler("tunrc_Vehicles.shadersDestroyed", root, function ()
	freeVehicleRenderTarget(source)
end)