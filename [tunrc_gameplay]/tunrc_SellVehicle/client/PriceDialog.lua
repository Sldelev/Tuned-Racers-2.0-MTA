PriceDialog = {}

local UI = exports.tunrc_UI

local PANEL_SIZE = Vector2(380, 215)
local TEXT_OFFSET = 15
local BUTTON_HEIGHT = 50

local MAX_PRICE = 100000

local screenSize = Vector2(UI:getScreenSize())
local isVisible = false
local ui = {}

local targetPlayer
local targetPlayerName
local minPrice

local function hideOnVehicleExit()
    PriceDialog.hide()
end

function PriceDialog.show(player)
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    if not isElement(player) then
        return false
    end
    if not localPlayer.vehicle or localPlayer.vehicle:getData("owner_id") ~= localPlayer:getData("_id") then
        return false
    end
    isVisible = true

    targetPlayer = player
    targetPlayerName = exports.tunrc_Utils:removeHexFromString(targetPlayer.name)
    minPrice = exports.tunrc_Shared:getVehiclePrices(
        exports.tunrc_Shared:getVehicleNameFromModel(localPlayer.vehicle.model))[1]

    UI:setText(ui.salePriceInput, "")
    UI:setText(ui.title, exports.tunrc_Lang:getString("sell_vehicle_sell_title"):format(targetPlayerName))
    UI:setText(ui.text, exports.tunrc_Lang:getString("sell_vehicle_sell_text"):format(
        exports.tunrc_Shared:getVehicleReadableName(localPlayer.vehicle.model), exports.tunrc_Lang:numberFormat(minPrice), exports.tunrc_Lang:numberFormat(MAX_PRICE)))

    UI:setVisible(ui.panel, true)
    showCursor(true)

    addEventHandler("onClientPlayerVehicleExit", localPlayer, hideOnVehicleExit)

    localPlayer:setData("activeUI", "sellVehicleEnterPrice")
    UI:fadeScreen(true)
end

function PriceDialog.hide()
    if not isVisible then
        return false
    end
    isVisible = false

    targetPlayer = nil
    targetPlayerName = nil
    minPrice = nil

    removeEventHandler("onClientPlayerVehicleExit", localPlayer, hideOnVehicleExit)

    UI:setVisible(ui.panel, false)
    showCursor(false)

    localPlayer:setData("activeUI", false)
    UI:fadeScreen(false)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    ui.panel = UI:createDpPanel {
        x       = (screenSize.x  - PANEL_SIZE.x)  / 2,
        y       = (screenSize.y - PANEL_SIZE.y) / 2,
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

    -- Кнопка продажи
    ui.sellButton = UI:createDpButton({
        x      = PANEL_SIZE.x / 2,
        y      = PANEL_SIZE.y - BUTTON_HEIGHT,
        width  = PANEL_SIZE.x / 2,
        height = BUTTON_HEIGHT,
        locale = "sell_vehicle_sell_button",
        type   = "primary"
    })
    UI:addChild(ui.panel, ui.sellButton)

    -- Заголовок
    local y = 0
    ui.title = UI:createDpLabel {
        x        = TEXT_OFFSET,
        y        = y,
        width    = PANEL_SIZE.x - TEXT_OFFSET * 2,
        height   = BUTTON_HEIGHT,
        clip     = true,
        alignX   = "center",
        alignY   = "center",
        type     = "primary",
        fontType = "defaultSmall",
    }
    UI:addChild(ui.panel, ui.title)
    y = y + 50

    -- Пояснение
    ui.text = UI:createDpLabel {
        x        = TEXT_OFFSET,
        y        = y,
        width    = PANEL_SIZE.x - TEXT_OFFSET * 2,
        height   = 55,
        clip     = true,
        type     = "dark",
        fontType = "defaultSmall"
    }
    UI:addChild(ui.panel, ui.text)
    y = y + 55

    -- Поле ввода цены
    ui.salePriceInput = UI:createDpInput({
        x      = 10,
        y      = y,
        width  = PANEL_SIZE.x - 20,
        height = BUTTON_HEIGHT,
        type   = "light",
        locale = "sell_vehicle_sell_price_hint"
    })
    UI:addChild(ui.panel, ui.salePriceInput)
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == ui.sellButton then
        if not isElement(targetPlayer) or targetPlayer:getData("tunrc_Core.state") then
            exports.tunrc_UI:showMessageBox(
                exports.tunrc_Lang:getString("sell_vehicle_sell_title"):format(targetPlayerName),
                exports.tunrc_Lang:getString("sell_vehicle_cant_accept"):format(targetPlayerName)
            )
            PriceDialog.hide()
            exports.tunrc_Sounds:playSound("error.wav")
            return
        end

        local priceText = UI:getText(ui.salePriceInput)
        if #priceText == 0 then
            exports.tunrc_Sounds:playSound("error.wav")
        else
            local price = tonumber(priceText:match("%d+"))
            if price then
                if minPrice > price then
                    exports.tunrc_Sounds:playSound("error.wav")
                    return
                end
                -- Проверка количества денег у покупающего игрока
                if targetPlayer:getData("money") < price then
                    exports.tunrc_UI:showMessageBox(
                        exports.tunrc_Lang:getString("sell_vehicle_sell_title"):format(targetPlayerName),
                        exports.tunrc_Lang:getString("sell_vehicle_not_enough_money"):format(targetPlayerName)
                    )
                    PriceDialog.hide()
                    exports.tunrc_Sounds:playSound("error.wav")
                    return
                end

                exports.tunrc_UI:showMessageBox(
                    exports.tunrc_Lang:getString("sell_vehicle_sell_title"):format(targetPlayerName),
                    exports.tunrc_Lang:getString("sell_vehicle_notified")
                )

                offerActive = true
                triggerServerEvent("sellvehicle.sendOffer", resourceRoot, targetPlayer, price)
                PriceDialog.hide()
                exports.tunrc_Sounds:playSound("ui_select.wav")
            end
        end
    elseif widget == ui.cancelButton then
        PriceDialog.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
    end
end)

addEventHandler("tunrc_UI.inputChange", resourceRoot, function (widget)
	if widget == ui.salePriceInput then
        local priceText = UI:getText(ui.salePriceInput)
        if #priceText > 0 then
            if tonumber(priceText) then
                UI:setText(ui.salePriceInput, priceText)
            elseif not tonumber(priceText:sub(-1)) or priceText:find("0%d+")
                or tonumber(priceText:match("%d+")) > MAX_PRICE then
                UI:setText(ui.salePriceInput, utf8.sub(priceText, 1, -2))
                exports.tunrc_Sounds:playSound("error.wav")
            end
        else
            exports.tunrc_Sounds:playSound("error.wav")
        end
	end
end)

bindKey("backspace", "down", function ()
    if isVisible then
        PriceDialog.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
    end
end)
