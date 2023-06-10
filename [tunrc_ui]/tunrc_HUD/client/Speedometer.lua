Speedometer = {}
Speedometer.visible = false
local DRAW_POST_GUI = false
local SPEED_SECTORS_COUNT = 134

local screenWidth, screenHeight = guiGetScreenSize()
local originalSize = 400
local width, height = Utils.screenScale(250), Utils.screenScale(250)
local screenOffset = Utils.screenScale(20)

local fallbackTo2d = false

local textureShader
local renderTarget
local maskShader

local circleTextures = {}
local imageIndexPrev = 0

local font
local mileageFont
local circleTargetColor = {213, 0, 40}

local assetsTextures = {}
local targetRPM = 0
local rpm = 0

local function getVehicleSpeed()
	if not localPlayer.vehicle then
		return 0
	end
	return localPlayer.vehicle.velocity:getLength() * 180
end

local function getVehicleSpeedString()
	local speed = getVehicleSpeed()
	return string.format("%03d", speed)
end

local function getVehicleMileageString()
	local mileage = localPlayer.vehicle:getData("mileage")
	if not mileage then
		return ""
	end
	return tostring(mileage) .. " km"
end

local function drawSpeedometer(x, y, width, height)
	if localPlayer:getData("tunrc_HUD.hideSpeedometer") then
		return
	end
	-- фон
	dxDrawCircle(x + 200, y + 200, 190, 0, 360, tocolor(10, 10, 10, 150), tocolor(10, 10, 10, 150), 32)
	dxDrawCircle(x + 250, y + 100, 11, 0, 360, tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255), 32)
	-- Круг скорости
	dxDrawImage(x, y, width, height, assetsTextures.circle, 0, 0, 0, tocolor(255, 255, 255, 200))
	-- Подсветка
	if ( getVehicleOverrideLights ( localPlayer.vehicle ) == 2 ) then
		dxDrawImage(x, y, width, height, assetsTextures.light_number, 0, 0, 0, tocolor(255, 255, 255, 200))
	end
	local speed = getVehicleSpeed()
	-- "Тряска" оборотов	
	local randomRPM = math.min(600, speed * 2)
	-- Подсчёт оборотов двигателя
	targetRPM = exports.tunrc_carsounds:getVehicleRPM(localPlayer.vehicle)
	-- Плавное изменение оборотов
	rpmDrag = targetRPM - 50
	--какая-то моргающая хуйня
	if targetRPM >= 7951 and rpmDrag <= 8001 then
		dxDrawCircle(x + 250, y + 100, 10, 0, 360, tocolor(140, 0, 0, 255), tocolor(140, 0, 0, 255), 32)
			if ( getVehicleOverrideLights ( localPlayer.vehicle ) == 2 ) then
				dxDrawImage(x, y, width, height, assetsTextures.light_limit, 0, 0, 0, tocolor(255, 255, 255, 220))
			end
	end
	-- Плавное изменение оборотов
	rpm = rpm + (targetRPM - rpm) * 0.1
	local angle = math.max(-270, -rpm / 8000 * 210)
	local imageIndex = math.min(math.floor(-angle / 90) + 1, 3)
	angle = angle + 90 * (imageIndex - 1)
	if imageIndexPrev ~= imageIndex then
		maskShader:setValue("sPicTexture", circleTextures[imageIndex])
		imageIndexPrev = imageIndex
	end
	maskShader:setValue("gUVRotAngle", math.rad(angle))
	circleColor = tocolor(0 + (targetRPM / 40) - 15, 0, 0)
	dxDrawImage(x, y, width, height, maskShader, 0, 0, 0, circleColor)

	-- Скорость	
	local gear = exports.tunrc_carsounds:getVehicleGear(localPlayer.vehicle)
	if gear <= 0 then
		gear = "R"
	end
	if speed == 0 then
		gear = "N"
	end
	dxDrawText(gear, x, y, x + width, y + height - 115, tocolor(255, 255, 255, 255), 0.5, font, "center", "center")
	local mileageOffset = 140
	dxDrawText(getVehicleMileageString(), x, y + mileageOffset, x + width, y + height + mileageOffset, tocolor(255, 255, 255, 255), 1, mileageFont, "center", "center")
	dxDrawText(getVehicleSpeedString(), x, y, x + width, y + height - 90, tocolor(255, 255, 255, 255), 1, font, "center", "bottom")
end

addEventHandler("onClientRender", root, function ()
	if not Speedometer.visible then
		return
	end
	if not localPlayer.vehicle then
		return
	end
	if localPlayer.vehicle.controller ~= localPlayer then
		return
	end
	if fallbackTo2d then
		drawSpeedometer(screenWidth - width - screenOffset, screenHeight - height - screenOffset, width, height)
	else
		-- Отрисовка спидометра в renderTarget
		dxSetRenderTarget(renderTarget, true)
		drawSpeedometer(0, 0, originalSize, originalSize)
		dxSetRenderTarget()

		textureShader:setValue("sPicTexture", renderTarget)

		dxDrawImage(
			screenWidth - width - screenOffset,
			screenHeight - height - screenOffset,
			width,
			height,
			textureShader,
			0, 0, 0,
			tocolor(255, 255, 255, 200),
			DRAW_POST_GUI
		)
	end
end)

function Speedometer.start()
	if renderTarget then
		return false
	end
	font = dxCreateFont("assets/fonts/speed.ttf", 90, false)
	mileageFont = dxCreateFont("assets/fonts/speed.ttf", 22, false)
	renderTarget = dxCreateRenderTarget(originalSize, originalSize, true)
	textureShader = exports.tunrc_Assets:createShader("texture3d.fx")
	maskShader = exports.tunrc_Assets:createShader("mask3d.fx")
	local maskTexture = dxCreateTexture("assets/textures/speedometer/mask.png")
	for i = 1, 3 do
		circleTextures[i] = dxCreateTexture("assets/textures/speedometer/circle"..tostring(i)..".png")
	end
	maskShader:setValue("sMaskTexture", maskTexture)
	maskShader:setValue("gUVRotCenter", 0.5, 0.5)
	if not (renderTarget and textureShader) then
		fallbackTo2d = true
		outputDebugString("Speedometer: Fallback to 2d")
		return
	end

	assetsTextures = {}
	assetsTextures.circle = dxCreateTexture("assets/textures/speedometer/circle.png")
	assetsTextures.light_number = dxCreateTexture("assets/textures/speedometer/light_numb.png")
	assetsTextures.light_limit = dxCreateTexture("assets/textures/speedometer/lights_limiter.png")
end

function Speedometer.setRotation(x, y, z)
	if not x or not y then
		return false
	end
	if not z then
		z = 0
	end
	if not textureShader then
		return false
	end
	dxSetShaderTransform(textureShader, x, y, z)
end

function Speedometer.setVisible(visible)
	Speedometer.visible = not not visible
	if visible then
		circleTargetColor = {exports.tunrc_UI:getThemeColor()}
	end
end

addEvent("tunrc_UI.updateTheme", false)
addEventHandler("tunrc_UI.updateTheme", root, function ()
	circleTargetColor = {exports.tunrc_UI:getThemeColor()}
end)
