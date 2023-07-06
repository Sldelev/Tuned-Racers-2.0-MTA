CarshopMenu = {}
local renderTarget
local screenSize = {guiGetScreenSize()}
local MENU_OFFSET = Vector3(0, 0, 1.6)
local position = Vector3()
local size = Vector2(1.5, 0.55)
local rotation = 240
local resolution = size * 250

local headerHeight = 70
local barOffset = 20
local barHeight = 20
local labelHeight = 50

local barsList = {
	{locale = "carshop_label_speed", value = 0.7, param = "speed"},
	{locale = "carshop_label_acceleration", value = 0.4, param = "acceleration"},
	{locale = "carshop_label_control", value = 0.85, param = "control"}
}

local headerFont
local labelFont
local hasDriftHandling = false

local themeColor = {0, 0, 0}
local themeColorHex = "#FFFFFF"

local function draw()
	dxDrawRectangle(1920 - screenSize[1], 25, resolution.x, resolution.y, tocolor(0, 0, 0, 25))

-- Цена
	local priceText = ""
	if Carshop.currentVehicleInfo.price > 0 then
			priceTextPremium = "$" .. tostring(Carshop.currentVehicleInfo.price / 1.25)
			priceText = "$" .. tostring(Carshop.currentVehicleInfo.price)
	else
		priceText = exports.tunrc_Lang:getString("price_free")
	end
	if localPlayer:getData("isPremium") then
		dxDrawText(priceTextPremium, 1920 - screenSize[1], 50, 1920 - screenSize[1] + resolution.x - 20, headerHeight + 30, tocolor(themeColor[1], themeColor[2], themeColor[3]), 1, labelFont, "right", "center")
		dxDrawRectangle(1920 - screenSize[1] + 300, 40, 60, 10, tocolor(200, 0, 0, 200), true)
		dxDrawText(priceText, 1920 - screenSize[1], 50, 1920 - screenSize[1] + resolution.x - 20, headerHeight - 30, tocolor(themeColor[1], themeColor[2], themeColor[3]), 1, labelFont, "right", "center")
	else
		dxDrawText(priceText, 1920 - screenSize[1], 50, 1920 - screenSize[1] + resolution.x - 20, headerHeight, tocolor(themeColor[1], themeColor[2], themeColor[3]), 1, labelFont, "right", "center")
	end
	
	local priceWidth = dxGetTextWidth(priceText, 1, labelFont)

	local headerText = Carshop.currentVehicleInfo.name
	local hearderWidth = dxGetTextWidth(headerText, 1, headerFont)
	local hearderScale = math.min(1, (resolution.x - 60 - priceWidth) / hearderWidth)
	dxDrawText(headerText, (1920 - screenSize[1]) + 20, 50, (1920 - screenSize[1]) + resolution.x - 20 - priceWidth, headerHeight, tocolor(255, 255, 255), hearderScale, headerFont, "left", "center", true)

	local buyButtonActive = true
	local buyButtonText = exports.tunrc_Lang:getString("carshop_buy_button")
	if Carshop.currentVehicleInfo.level > localPlayer:getData("level") then
		buyButtonActive = false
		--"Требуется уровень " .. 
		buyButtonText = string.format(exports.tunrc_Lang:getString("carshop_required_level"), tostring(Carshop.currentVehicleInfo.level))
	elseif Carshop.currentVehicleInfo.price > localPlayer:getData("money") then
		buyButtonActive = false
		buyButtonText = exports.tunrc_Lang:getString("carshop_no_money")
	end
	if not hasMoreGarageSlots() then
		buyButtonActive = false
		buyButtonText = exports.tunrc_Lang:getString("carshop_no_slots")
	end
	if Carshop.currentVehicleInfo.premium and not localPlayer:getData("isPremium") then
		buyButtonActive = false
		buyButtonText = exports.tunrc_Lang:getString("carshop_need_premium")
	end
	if not buyButtonActive then
		dxDrawRectangle(1920 - screenSize[1], resolution.y - headerHeight + 25, resolution.x, headerHeight, tocolor(32, 30, 31))	
		dxDrawText(buyButtonText, 1920 - screenSize[1], resolution.y - headerHeight + 50, 1920 - screenSize[1] + resolution.x, resolution.y, tocolor(255, 255, 255, 150), 1, headerFont, "center", "center")		
	else
		dxDrawRectangle(1920 - screenSize[1], resolution.y - headerHeight + 25, resolution.x, headerHeight, tocolor(themeColor[1], themeColor[2], themeColor[3]))	
		dxDrawText(buyButtonText, 1920 - screenSize[1], resolution.y - headerHeight + 50, 1920 - screenSize[1] + resolution.x, resolution.y, tocolor(255, 255, 255), 1, headerFont, "center", "center")	
	end

	--[[local y = headerHeight
	local barWidth = resolution.x - barOffset * 2
	for i, bar in ipairs(barsList) do
		-- Подпись
		dxDrawText(bar.text, 0, y, resolution.x, y + labelHeight, tocolor(255, 255, 255), 1, labelFont, "center", "center")
		y = y + labelHeight
		dxDrawRectangle(barOffset, y, barWidth, barHeight, tocolor(65, 65, 65))
		dxDrawRectangle(barOffset, y, barWidth * bar.value, barHeight, tocolor(themeColor[1], themeColor[2], themeColor[3]))

		bar.value = bar.value + (Carshop.currentVehicleInfo.specs[bar.param] - bar.value) * 0.2
		y = y + barHeight * 2
	end
	local labelText = exports.tunrc_Lang:getString("carshop_drift_label")
	local valueText = ""
	if Carshop.hasDriftHandling then
		valueText = exports.tunrc_Lang:getString("carshop_drift_label_yes")
	else
		valueText = exports.tunrc_Lang:getString("carshop_drift_label_no")
	end
	dxDrawText(labelText .. ": " .. themeColorHex .. valueText, 0, y, resolution.x, y + labelHeight, tocolor(255, 255, 255), 1, labelFont, "center", "center", false, false, false, true)
	]]
end

function CarshopMenu.start(basePosition)
	position = MENU_OFFSET + basePosition

	renderTarget = dxCreateRenderTarget(resolution.x, resolution.y, false)
	headerFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 20)
	labelFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 18)

	themeColor = {exports.tunrc_UI:getThemeColor()}
	themeColorHex = tostring(exports.tunrc_Utils:RGBToHex(unpack(themeColor)))

	for i, bar in ipairs(barsList) do
		bar.text = exports.tunrc_Lang:getString(bar.locale)
	end

	addEventHandler("onClientRender", root, draw)
end

function CarshopMenu.stop()
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
	if isElement(headerFont) then
		destroyElement(headerFont)
	end
	if isElement(labelFont) then
		destroyElement(labelFont)
	end	
	removeEventHandler("onClientRender", root, draw)
end