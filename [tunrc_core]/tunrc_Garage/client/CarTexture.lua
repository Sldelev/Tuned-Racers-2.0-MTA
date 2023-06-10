CarTexture = {}
local renderTarget
local bodyRenderTarget
local vehicle
local editorStickers = {}
local bodyColor = {0, 0, 0}
local DEFAULT_STICKER_SIZE = 512
local selectedSticker = false
local previousSticker = false
local stickerMirroringEnabled = false
local MAX_STICKER_COUNT = 3000

function CarTexture.start()
	vehicle = GarageCar.getVehicle()
	if not isElement(vehicle) then
		return false
	end
	renderTarget = exports.tunrc_Vehicles:createVehicleRenderTarget(vehicle)
	bodyRenderTarget = exports.tunrc_Vehicles:createVehicleBodyRenderTarget(vehicle)
	if not isElement(renderTarget) then
		return
	end
	if not isElement(bodyRenderTarget) then
		return
	end
	
	editorStickers = {}
	CarTexture.reset()
	CarTexture.redraw()

	addEventHandler("onClientRestore", root, CarTexture.handleRestore)
	stickerMirroringEnabled = false
end

function CarTexture.stop()
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
	if isElement(bodyRenderTarget) then
		destroyElement(bodyRenderTarget)
	end

	removeEventHandler("onClientRestore", root, CarTexture.handleRestore)
end

function CarTexture.previewBodyColor(r, g, b)
	bodyColor = {r, g, b}
	CarTexture.redraw()
end

function CarTexture.getMaxStickerCount()
	return MAX_STICKER_COUNT
end

function CarTexture.getStickerCount()
	return #editorStickers
end

function getStickerCount()
	return #editorStickers
end

function CarTexture.save()
	if editorStickers then
		vehicle:setData("stickers", editorStickers, false)
	end
end

function CarTexture.reset()
	if not isElement(vehicle) then
		return
	end
	bodyColor = vehicle:getData("BodyColor")
	editorStickers = {}
	editorStickers = vehicle:getData("stickers")
	if not editorStickers then
		editorStickers = {}
	end
	CarTexture.redraw()
end

function CarTexture.moveSticker(x, y)
	if not selectedSticker then
		return
	end
	if not x then return end
	if not y then return end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[1] = sticker[1] + x
	sticker[2] = sticker[2] + y
	CarTexture.redraw()
end

function CarTexture.getStickerPosition()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[1], sticker[2]
end

function CarTexture.getStickerPositionX()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[1]
end

function CarTexture.getStickerPositionY()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[2]
end

function CarTexture.resizeSticker(x, y)
	if not selectedSticker then
		return
	end
	if not x then return end
	if not y then return end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[3] = sticker[3] + x
	sticker[4] = sticker[4] + y
	CarTexture.redraw()
end

function CarTexture.getStickerScale()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[3], sticker[4]
end

function CarTexture.getStickerScaleX()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[3]
end

function CarTexture.getStickerScaleY()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[4]
end

function CarTexture.getSelectedSticker()
	if not selectedSticker then
		return false
	end
	return editorStickers[selectedSticker]
end

function CarTexture.getSelectedStickerIndex()
	if not selectedSticker then
		return false
	end
	return selectedSticker
end

function CarTexture.copyPreviousStickerStyle()
	if not selectedSticker then
		return false
	end
	if not previousSticker then
		return false
	end
	local prevSticker = editorStickers[previousSticker]
	local currentSticker = editorStickers[selectedSticker]
	if not prevSticker or not currentSticker then
		return false
	end
	--currentSticker[1] = prevSticker[1]
	--currentSticker[2] = prevSticker[2]
	currentSticker[3] = prevSticker[3]
	currentSticker[4] = prevSticker[4]
	currentSticker[6] = prevSticker[6]
	currentSticker[7] = prevSticker[7]
	return true
end

function CarTexture.setStickerColor(color)
	if not selectedSticker then
		return
	end
	if type(color) ~= "number" then color = tocolor(255, 255, 255) end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[7] = color
	CarTexture.redraw()
end

function CarTexture.getStickerColor()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[7]
end

function CarTexture.copyPreviousStickerColor()
	if not selectedSticker then
		return false
	end
	if not previousSticker then
		return false
	end
	local prevSticker = editorStickers[previousSticker]
	local currentSticker = editorStickers[selectedSticker]
	if not prevSticker or not currentSticker then
		return false
	end
	currentSticker[7] = prevSticker[7]
	return true
end


function CarTexture.rotateSticker(r)
	if not selectedSticker then
		return
	end
	if not r then return end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[6] = (sticker[6] + r) % 360
	CarTexture.redraw()
end

function CarTexture.forceRotateSticker()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[6] = (sticker[6] + 90)
	CarTexture.redraw()
end

function CarTexture.getStickerRotation()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return sticker[6]
end

function CarTexture.canAddSticker()
	return #editorStickers < MAX_STICKER_COUNT
end

function CarTexture.addSticker(id, x, y, rotation)
	if not CarTexture.canAddSticker() then
		return false
	end
	if type(id) ~= "number" then
		return false
	end
	if not x then x = 0 end
	if not y then y = 0 end
	if not rotation then rotation = 0 end
	local width, height = DEFAULT_STICKER_SIZE, DEFAULT_STICKER_SIZE
	local color = tocolor(255, 255, 255)
	-- Скопировать параметры с предыдущего стикера
	local sticker = {x, y, width, height, id, rotation, color, stickerMirroringEnabled, false, false}
	table.insert(editorStickers, sticker)
	selectedSticker = #editorStickers
	CarTexture.redraw()
end

function CarTexture.cloneSticker()
	if not selectedSticker then
		return
	end
	if not CarTexture.canAddSticker() then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	local clonedSticker = {unpack(sticker)}
	table.insert(editorStickers, clonedSticker)
	selectedSticker = #editorStickers

	CarTexture.redraw()
end

function CarTexture.removeSticker()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	table.remove(editorStickers, selectedSticker)
	selectedSticker = math.max(1, math.min(#editorStickers, selectedSticker))
	CarTexture.redraw()
end

local function changeStickerSlot(direction)
	--editorStickers[selectedSticker]

	if not selectedSticker then
		return
	end

	if not editorStickers[selectedSticker] then
		return false
	end
	
	local stickersCount = #editorStickers
	local slot = selectedSticker + direction

	if slot > stickersCount then
		slot = 1
	elseif 1 > slot then
		slot = stickersCount
	end

	local item = table.remove(editorStickers, selectedSticker)
	table.insert(editorStickers, slot, item)

	selectedSticker = slot

	CarTexture.redraw()
end

function CarTexture.moveStickerSlotUp()
	changeStickerSlot(1)
end

function CarTexture.moveStickerSlotDown()
	changeStickerSlot(-1)
end

function CarTexture.redraw()
	local bodyTexture = false
	exports.tunrc_Vehicles:redrawBodyRenderTarget(bodyRenderTarget, bodyColor, bodyTexture, editorStickers, selectedSticker)
	exports.tunrc_Vehicles:redrawGlassRenderTarget(renderTarget, editorStickers, selectedSticker)
end

function CarTexture.moveStickerLayer(offset)
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	if not offset then
		offset = 0
	end

	local newStickerIndex = selectedSticker + offset
	if newStickerIndex > #editorStickers or newStickerIndex < 1 then
		return false
	end

	table.insert(editorStickers, newStickerIndex, table.remove(editorStickers, selectedSticker))
	selectedSticker = newStickerIndex

	CarTexture.redraw()

	return true
end

function CarTexture.selectPreviousSticker()
	if not selectedSticker then
		selectedSticker = 1
	end
	if not selectedSticker or not editorStickers or #editorStickers == 0 then
		return false
	end
	selectedSticker = selectedSticker - 1
	if selectedSticker < 1 then
		selectedSticker = #editorStickers
	end
	CarTexture.redraw()
	return true
end

function CarTexture.toggleStickerMirroring()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	-- Disable mirroring
	if sticker[10] then
		sticker[8] = false -- mirror
		sticker[9] = false -- mirror text
		sticker[10] = false -- mirror fix
	-- Enable mirroring
	elseif not sticker[8] then
		sticker[8] = true -- mirror
		sticker[9] = false -- mirror text
		sticker[10] = false -- mirror fix
	-- Enable text mirroring
	elseif sticker[8] and not sticker[9] then
		sticker[8] = true -- mirror
		sticker[9] = true -- mirror text
		sticker[10] = false -- mirror fix
	-- Enable fixed mirroring
	elseif sticker[8] and sticker[9] then
		sticker[8] = false -- mirror
		sticker[9] = false -- mirror text
		sticker[10] = true -- mirror fix
	end
	CarTexture.redraw()
end

function CarTexture.getMirroringMode()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	local mode = false
	if sticker[8] then
		if sticker[9] then
			mode = "text"
		else
			mode = "old"
		end
	elseif sticker[10] then
		mode = "normal"
	end

	return mode
end

function CarTexture.selectNextSticker()
	if not editorStickers  or #editorStickers == 0 then
		return false
	end
	if not selectedSticker then
		selectedSticker = 1
	else
		selectedSticker = (selectedSticker % #editorStickers) + 1
	end
	CarTexture.redraw()
	return true
end

function CarTexture.unselectSticker()
	if selectedSticker then
		previousSticker = selectedSticker
		selectedSticker = false
	end
	CarTexture.redraw()
end

function CarTexture.handleRestore(didClearRenderTargets)
	if didClearRenderTargets then
		CarTexture.redraw()
	end
end
