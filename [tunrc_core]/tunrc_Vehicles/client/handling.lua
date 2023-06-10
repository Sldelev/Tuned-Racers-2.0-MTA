local screenSize = Vector2(guiGetScreenSize())
local themeColor = {212, 0, 40}
local font

local SWITCHING_TIME = 0.5

local BAR_WIDTH = 400
local BAR_HEIGHT = 30

local switchingDelay = 0
local isSwitching = false

local drawProgress = true
local text = ""

local function draw()
	local progress = 1 - switchingDelay / SWITCHING_TIME

	local alpha = 1
	if progress < 0.1 then
		alpha = progress / 0.1
	elseif progress > 0.95 then
		alpha = 1 - (progress - 0.95) / 0.05
	end

	local x = (screenSize.x - BAR_WIDTH) / 2
	local y = (screenSize.y - BAR_HEIGHT) * 0.9
	if drawProgress then
		--dxDrawRectangle(x - 15, y - 40, BAR_WIDTH + 30, BAR_HEIGHT + 55, tocolor(40, 42, 41, 255 * alpha))
		dxDrawRectangle(x, y, BAR_WIDTH, BAR_HEIGHT, tocolor(20, 20, 20, 255 * alpha))
		dxDrawRectangle(x, y, BAR_WIDTH * progress, BAR_HEIGHT, tocolor(themeColor[1], themeColor[2], themeColor[3], 255 * alpha))
	end
	dxDrawText(text, x - 1, y - 6, x - 1 + BAR_WIDTH, y - 5, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")
	dxDrawText(text, x + 1, y - 6, x + 0 + BAR_WIDTH, y - 5, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")
	dxDrawText(text, x, y - 6 - 1, x + BAR_WIDTH, y - 5 - 1, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")
	dxDrawText(text, x, y - 6 + 1, x + BAR_WIDTH, y - 5 + 1, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")

	local textColor = {255, 255, 255}
	if not drawProgress then
		textColor = {unpack(themeColor)}
	end
	dxDrawText(text, x, y - 6, x + BAR_WIDTH, y - 5, tocolor(textColor[1], textColor[2], textColor[3], 255 * alpha), 1, font, "center", "bottom")
end

local function update(dt)
	dt = dt / 1000

	switchingDelay = switchingDelay - dt
	if switchingDelay < 0 then
		stopSwitching()
		if drawProgress then
			switchHandlingInstantly()
			exports.tunrc_Sounds:playSound("ui_change.wav")
		end
	end

	if drawProgress and (getPedControlState("accelerate") or getPedControlState("brake_reverse")) then
		stopSwitching()
		switchHandling()
	end
end

function stopSwitching()
	if not isSwitching then
		return
	end
	isSwitching = false

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)
end

function switchHandling()
	if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
		return
	end
	if isSwitching then
		stopSwitching()
		return
	end
	isSwitching = true

	switchingDelay = SWITCHING_TIME
	themeColor = {exports.tunrc_UI:getThemeColor()}
	font = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 22),

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)

	if localPlayer.vehicle:getData("forceHandling") then
		drawProgress = false
		text = exports.tunrc_Lang:getString("handling_switching_message_forced")
	elseif localPlayer.vehicle.velocity:getLength() > 0.001 then
		drawProgress = false
		text = exports.tunrc_Lang:getString("handling_switching_message_moving")
	else
		local activeHandling = localPlayer.vehicle:getData("activeHandling")
		if not activeHandling or activeHandling == "street" then
			text = exports.tunrc_Lang:getString("handling_switching_message_drift")
		else
			text = exports.tunrc_Lang:getString("handling_switching_message_street")
		end
		drawProgress = true
	end

	if drawProgress then
		exports.tunrc_Sounds:playSound("ui_select.wav")
	else
		exports.tunrc_Sounds:playSound("error.wav")
	end
	BAR_WIDTH = dxGetTextWidth(text, 1, font) + 40
end

function switchHandlingInstantly()
	triggerServerEvent("switchPlayerHandling", resourceRoot)
end

bindKey("2", "down", function ()
	if not localPlayer.vehicle then
		return
	end
	switchHandling()
end)