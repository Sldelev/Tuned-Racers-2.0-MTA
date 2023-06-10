BuyConfirmDialog = {}

local UI = exports.tunrc_UI

local PANEL_SIZE = Vector2(380, 250)
local TEXT_OFFSET = 15
local BUTTON_HEIGHT = 50

local screenSize = Vector2(UI:getScreenSize())
local isVisible = false

local ui = {}
local data = {}

function BuyConfirmDialog.show(seller, vehicleModel, price)
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    if not isElement(seller) or type(vehicleModel) ~= "number" or type(price) ~= "number" then
        return false
    end
    isVisible = true

    data.seller = seller
    data.sellerName = exports.tunrc_Utils:removeHexFromString(seller.name)
    data.vehicleModel = vehicleModel
    data.price = price

    local vehicleName = exports.tunrc_Shared:getVehicleReadableName(vehicleModel)
    UI:setText(ui.title, exports.tunrc_Lang:getString("sell_vehicle_buy_title"):format(vehicleName))
    UI:setText(ui.text, exports.tunrc_Lang:getString("sell_vehicle_buy_text"):format(data.sellerName, vehicleName, exports.tunrc_Lang:numberFormat(price)))

    UI:setVisible(ui.panel, true)
    showCursor(true)

    localPlayer:setData("activeUI", "sellVehicleBuyConfirm")

    Camera.setTarget(seller)

    return true
end

function BuyConfirmDialog.hide()
    if not isVisible then
        return false
    end
    isVisible = false

    data = {}

    UI:setVisible(ui.panel, false)
    showCursor(false)

    localPlayer:setData("activeUI", false)
    UI:fadeScreen(false)

    Camera.setTarget(localPlayer)

    return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    ui.panel = UI:createDpPanel {
        x       = (screenSize.x - PANEL_SIZE.x) / 2,
        y       = 180,
        width   = PANEL_SIZE.x,
        height  = PANEL_SIZE.y,
        type    = "light"
    }
    UI:addChild(ui.panel)
    UI:setVisible(ui.panel, false)

    -- Кнопка отмены
    ui.cancelButton = UI:createDpButton({
        x      = 0,
        y      = PANEL_SIZE.y - BUTTON_HEIGHT,
        width  = PANEL_SIZE.x / 2,
        height = BUTTON_HEIGHT,
        locale = "sell_vehicle_cancel_button",
        type   = "default_dark"
    })
    UI:addChild(ui.panel, ui.cancelButton)

    -- Кнопка покупки
    ui.buyButton = UI:createDpButton({
        x      = PANEL_SIZE.x / 2,
        y      = PANEL_SIZE.y - BUTTON_HEIGHT,
        width  = PANEL_SIZE.x / 2,
        height = BUTTON_HEIGHT,
        locale = "sell_vehicle_buy_button",
        type   = "primary"
    })
    UI:addChild(ui.panel, ui.buyButton)

    -- Заголовок
    ui.title = UI:createDpLabel {
        x        = TEXT_OFFSET,
        y        = 0,
        width    = PANEL_SIZE.x - TEXT_OFFSET * 2,
        height   = BUTTON_HEIGHT,
        alignX   = "center",
        alignY   = "center",
        clip     = true,
        type     = "primary",
        fontType = "defaultSmall",
    }
    UI:addChild(ui.panel, ui.title)

    -- Пояснение
    ui.text = UI:createDpLabel {
        x           = TEXT_OFFSET,
        y           = BUTTON_HEIGHT,
        width       = PANEL_SIZE.x - TEXT_OFFSET * 2,
        height      = PANEL_SIZE.y - BUTTON_HEIGHT * 2,
        alignX      = "center",
        alignY      = "center",
        clip        = true,
        wordBreak   = true,
        type        = "dark",
        fontType    = "defaultSmall"
    }
    UI:addChild(ui.panel, ui.text)
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == ui.buyButton then
        if localPlayer:getData("money") < data.price then
            Offer.setVisible(false)
            BuyConfirmDialog.hide()
            exports.tunrc_Sounds:playSound("error.wav")
            return
        end

        triggerServerEvent("sellvehicle.answerOffer", resourceRoot, data.seller, true, data.price)

        Offer.setVisible(false)
        BuyConfirmDialog.hide()
    elseif widget == ui.cancelButton then
        triggerServerEvent("sellvehicle.answerOffer", resourceRoot, data.seller, false)
        exports.tunrc_Sounds:playSound("ui_back.wav")

        Offer.setVisible(false)
        BuyConfirmDialog.hide()
    end
end)
