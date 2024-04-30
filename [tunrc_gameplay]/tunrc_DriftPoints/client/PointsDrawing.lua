PointsDrawing = {}
local screenSize = Vector2(guiGetScreenSize())

local FONT_SIZE = 32
local MULTIPLIER_FONT_SIZE = 16
local font
local font2
local textHeight
local state = "hide"

local themeColor = {212, 0, 40}

local pointsCount = 0
local currentMultiplier = 0
local targetAlpha = 0
local alpha = 0
local hidingTextScale = 1
local hidingTextAlpha = 255
local showingProgress = 0
local SHOWING_SPEED = 8
local HIDING_SPEED = 8

PROPERTY_SHOW_POINTS = "ui.draw_points"
local isEnabled = true

-- Тряска
local isShaking = false
local shakingAmount = 0
local SHAKE_POWER = 0

-- Столкновение
local isCollision = false

local multiplierAlpha = 0
-- Направление
local targetPointsAngle = 0
local currentPointsAngle = 0

local bonusText = ""
local bonusAnimation = 1
local bonusOffset = 60
local bonusAnimationSpeed = 1.5

function PointsDrawing.show()
	local isEnabled = exports.tunrc_Config:getProperty(PROPERTY_SHOW_POINTS)
	if not isEnabled then
		return false
	end
	if state == "hide" or state == "hiding" then
		state = "showing"
		targetAlpha = 255
		alpha = 0
		isCollision = false
		showingProgress = 0
		currentMultiplier = 0
		pointsCount = 0
		targetPointsAngle = 0
		currentPointsAngle = 0

		themeColor = {exports.tunrc_UI:getThemeColor()}
		return true
	end
end

function PointsDrawing.collision()
	if isCollision then
		return
	end
	targetPointsAngle = 0
	isCollision = true
end

function PointsDrawing.hide()
	if state == "show" then
		state = "hiding"
		targetAlpha = 0
		alpha = 255
		hidingTextScale = 1
		hidingTextAlpha = 255
		targetPointsAngle = 0
		bonusText = ""
		--isCollision = false
	end
end

local function dxDrawTextShadow(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, textRotation, alpha)
	if not alpha then
		alpha = 255
	end
	dxDrawText(text, x1 + 1, y1 + 1, x2 + 1, y2 + 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, false, false, false, false, false, textRotation)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, false, false, false, false, false, textRotation)
end

local function getDriftAngle()
	local vehicle = localPlayer.vehicle
	
	if not vehicle then
	return 0
	end
	
	if vehicle.velocity.length < 0.12 then
	return 0
end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
		if math.abs(angle) > 150 then
		return 0
	end
	if angle < 0 then
		angle = angle + -angle * 2
	end
	return angle
end

function PointsDrawing.draw()
	local textWidth = dxGetTextWidth(pointsCount, 1, font)
	local textX = screenSize.x / 2 - textWidth / 2
	local textY = 80	
	if state == "showing" or state == "hiding" then
	    local mulX = textX + textWidth + 5
		local mulY = textY
		exports.tunrc_Garage:dxDrawRoundedRectangle(textX - 5, textY, textWidth + 10, textHeight, 15, alpha, true, false, true, false)
		exports.tunrc_Garage:TrcDrawText(pointsCount, textX, textY, textX + textWidth, textY + textHeight, alpha, font, "center", "center", 1, false, false)
	elseif state == "show" then
	    local mulX = textX + textWidth + 5
		local mulY = textY
		exports.tunrc_Garage:dxDrawRoundedRectangle(textX - 5, textY, textWidth + 10, textHeight, 15, alpha, true, false, true, false)
		exports.tunrc_Garage:TrcDrawText(pointsCount, textX, textY, textX + textWidth, textY + textHeight, 255, font, "center", "center", 1, false, false)
		
		local mulText = "x" .. tostring(currentMultiplier)
		local mulTextWidth = dxGetTextWidth(mulText, 0.5, font2)
		local mulX = textX + textWidth + 20
		local mulY = textY
			
		exports.tunrc_Garage:dxDrawRoundedRectangle(mulX - 10, mulY, mulTextWidth + 20, textHeight, 10, 255, true, false, true, false)
		exports.tunrc_Garage:TrcDrawText(mulText, mulX, mulY, mulX + mulTextWidth, mulY + textHeight / 2, 255, font, "center", "center", 0.5, false, false)		
		exports.tunrc_Garage:TrcDrawText(string.format('%.f',getDriftAngle()), mulX, mulY + (textHeight / 2), mulX + mulTextWidth, mulY + textHeight, 255, font, "center", "center", 0.5, false, false)

		if bonusAnimation < 1 then
			local bonusAlpha = (1 - bonusAnimation) * 255
			local dy = -bonusOffset * bonusAnimation
			exports.tunrc_Garage:TrcDrawText(bonusText, textX, textY + dy, textX + textWidth, textY + textHeight + dy, bonusAlpha, font2, "center", "center", 1, false, false)
		end
	end
	if state == "hiding" and not isCollision then
	local mulX = textX + textWidth + 5
		local mulY = textY
		exports.tunrc_Garage:TrcDrawText(pointsCount, textX, textY, textX + textWidth, textY + textHeight, hidingTextAlpha, font, "center", "center", 1, false, false)
	end
end

function PointsDrawing.update(deltaTime)
	deltaTime = deltaTime / 1000

	if state == "showing" then
		alpha = alpha + (targetAlpha - alpha) * SHOWING_SPEED * deltaTime
		showingProgress = showingProgress + deltaTime * 2
		if showingProgress > 1 then
			showingProgress = 1
		end
		if alpha > 250 then
			alpha = 255
			state = "show"
		end
	elseif state == "hiding" then
		alpha = alpha + (targetAlpha - alpha) * HIDING_SPEED * deltaTime
		hidingTextScale = hidingTextScale + deltaTime * 1
		hidingTextAlpha = hidingTextAlpha - deltaTime * 700
		if hidingTextAlpha < 0 then
			hidingTextAlpha = 0
		end
		if alpha < 5 then
			alpha = 0
			state = "hide"
		end
		
	elseif state == "show" then
		multiplierAlpha = multiplierAlpha - deltaTime * 5
		if multiplierAlpha < 0 then
			multiplierAlpha = 0
		end		
	end

	currentPointsAngle = currentPointsAngle + (targetPointsAngle - currentPointsAngle) * deltaTime * 3
	bonusAnimation = bonusAnimation + deltaTime * bonusAnimationSpeed
	if bonusAnimation > 1 then
		bonusAnimation = 1
	end
end

function PointsDrawing.updateMultiplier(multiplier)
	if multiplier then
		currentMultiplier = multiplier
		multiplierAlpha = 1
	end
end

function PointsDrawing.setShaking(shaking)
	isShaking = shaking
end

function PointsDrawing.updatePointsCount(count, angle)
	pointsCount = tostring(count)
	if angle then
		targetPointsAngle = angle * 0.15
	end
end

function PointsDrawing.drawBonus(amount)
	bonusAnimation = 0
	bonusText = "+" .. tostring(amount)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	font = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", FONT_SIZE, true)
	font2 = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", MULTIPLIER_FONT_SIZE, true)
	textHeight = dxGetFontHeight(1, font)
end)

addEventHandler("onClientRender", root, PointsDrawing.draw)
addEventHandler("onClientPreRender", root, PointsDrawing.update)