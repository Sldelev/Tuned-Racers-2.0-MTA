Offer = {}

local ACCEPT_KEY = "L"
local CANCEL_KEY = "K"

local ACCEPT_TIME = 15000

local PANEL_SIZE = Vector2(400, 150)
local BORDER_OFFSET = 15
local TIME_BAR_HEIGHT = 5
local BUTTON_HEIGHT = 50

local screenSize = Vector2(guiGetScreenSize())
local visible = false

local panelColor, grayDarkColor, themeColor
local messageFont, buttonFont

local acceptTimer

local data = {}

local function draw()
    if not isVisible then
        return
    end
    if not isElement(data.seller) then
        Offer.setVisible(false)
        return
    end
    local x = screenSize.x - PANEL_SIZE.x - BORDER_OFFSET
    local y = BORDER_OFFSET
    local alpha = 255
    local themeColorHex = exports.tunrc_Utils:RGBToHex(themeColor[1], themeColor[2], themeColor[3])

    -- Сообщение
    local distanceToSeller = (localPlayer.position - data.seller.position):getLength()
    local text = string.format(exports.tunrc_Lang:getString("sell_vehicle_offer_message"),
        themeColorHex .. string.format("%s (%s)", exports.tunrc_Utils:removeHexFromString(tostring(data.seller.name)),
            exports.tunrc_Lang:getString("global_distance"):format(distanceToSeller)) .. "#000000",
        themeColorHex .. exports.tunrc_Shared:getVehicleReadableName(data.vehicle.model) .. "#000000",
        themeColorHex .. "$" .. tostring(exports.tunrc_Lang:numberFormat(data.price)))
    dxDrawRectangle(x, y, PANEL_SIZE, tocolor(panelColor[1], panelColor[2], panelColor[3], alpha))
    dxDrawText(text, x, y, x + PANEL_SIZE.x, y + PANEL_SIZE.y - BUTTON_HEIGHT, tocolor(0, 0, 0, alpha), 1, messageFont, "center", "center", false, true, false, true)

    y = y + PANEL_SIZE.y - BUTTON_HEIGHT - TIME_BAR_HEIGHT
    -- Полоса времени
    local timeLeft = acceptTimer:getDetails()
    dxDrawRectangle(x, y, (PANEL_SIZE.x / ACCEPT_TIME) * timeLeft, TIME_BAR_HEIGHT, tocolor(themeColor[1], themeColor[2], themeColor[3], alpha))

    y = y + TIME_BAR_HEIGHT
    -- Кнопка "Отклонить"
    text = string.format(exports.tunrc_Lang:getString("sell_vehicle_offer_key_decline"), CANCEL_KEY)
    dxDrawRectangle(x, y, PANEL_SIZE.x / 2, BUTTON_HEIGHT, tocolor(grayDarkColor[1], grayDarkColor[2], grayDarkColor[3], alpha))
    dxDrawText(text, x, y, x + PANEL_SIZE.x / 2, y + BUTTON_HEIGHT, tocolor(255, 255, 255, alpha), 1, buttonFont, "center", "center", false, true)

    -- Кнопка "Купить"
    text = string.format(exports.tunrc_Lang:getString("sell_vehicle_offer_key_accept"), ACCEPT_KEY)
    dxDrawRectangle(x + PANEL_SIZE.x / 2, y, PANEL_SIZE.x / 2, BUTTON_HEIGHT, tocolor(themeColor[1], themeColor[2], themeColor[3], alpha))
    dxDrawText(text, x + PANEL_SIZE.x / 2, y, x + PANEL_SIZE.x, y + BUTTON_HEIGHT, tocolor(255, 255, 255, alpha), 1, buttonFont, "center", "center", false, true)
end

local function answerOffer(accepted)
    if not isVisible then
        return false
    end
    if accepted then
        BuyConfirmDialog.show(data.seller, data.vehicle.model, data.price)
    else
        Offer.setVisible(false)
        BuyConfirmDialog.hide()
        triggerServerEvent("sellvehicle.answerOffer", resourceRoot, data.seller, accepted)
    end
    return true
end

local function onKey(key, state)
    if state then
        if key == string.lower(ACCEPT_KEY) then
            answerOffer(true)
        elseif key == string.lower(CANCEL_KEY) then
            answerOffer(false)
        end
    end
end

function Offer.setVisible(visible)
    if visible == isVisible then
        return
    end

    if isTimer(acceptTimer) then
        acceptTimer:destroy()
    end
    acceptTimer = nil

    if visible then
        acceptTimer = Timer(answerOffer, ACCEPT_TIME, 1, false)

    panelColor = {exports.tunrc_UI:getThemeColor(nil, "white")}
        grayDarkColor = {exports.tunrc_UI:getThemeColor(nil, "gray_dark")}
        themeColor = {exports.tunrc_UI:getThemeColor()}

        addEventHandler("onClientRender", root, draw)
        bindKey(ACCEPT_KEY, "down", onKey)
        bindKey(CANCEL_KEY, "down", onKey)
        messageFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 16)
        buttonFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 14)
    else
        removeEventHandler("onClientRender", root, draw)
        unbindKey(ACCEPT_KEY, "down", onKey)
        unbindKey(CANCEL_KEY, "down", onKey)
        if isElement(messageFont) then
            destroyElement(messageFont)
        end
        if isElement(buttonFont) then
            destroyElement(buttonFont)
        end
    end

    isVisible = visible
end

function Offer.show(seller, vehicle, price)
    if isVisible then
        return false
    end
    if not isElement(seller) or not isElement(vehicle) or type(price) ~= "number" then
        return false
    end
    data.seller = seller
    data.vehicle = vehicle
    data.price = price
    exports.tunrc_Sounds:playSound("ui_select.wav")
    Offer.setVisible(true)
end

addEvent("sellvehicle.showOffer", true)
addEventHandler("sellvehicle.showOffer", resourceRoot, function(seller, vehicle, price)
    Offer.show(seller, vehicle, price)
end)

addEvent("sellvehicle.cancelOffer", true)
addEventHandler("sellvehicle.cancelOffer", resourceRoot, function (seller, buyer)
    if localPlayer == seller then
        offerActive = false
    elseif localPlayer == buyer then
        Offer.setVisible(false)
        BuyConfirmDialog.hide()
    end
    exports.tunrc_Sounds:playSound("error.wav")
end)
