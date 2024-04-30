offerActive = false

function start()
    exports.tunrc_UI:fadeScreen(true)
    triggerServerEvent("sellvehicle.checkPermission", resourceRoot)
end

addEvent("sellvehicle.onPermissionResult", true)
addEventHandler("sellvehicle.onPermissionResult", resourceRoot, function(allow, leftTime)
    if allow then
        PlayerList.show()
    else
        exports.tunrc_Sounds:playSound("error.wav")
        CooldownDialog.show(leftTime)
    end
end)

function isOfferActive()
    return offerActive
end

function cancelOffer()
    if localPlayer.vehicle and localPlayer.vehicle:getData("owner_id") == localPlayer:getData("_id") then
        exports.tunrc_Chat:message("global", exports.tunrc_Lang:getString("sell_vehicle_offer_canceled"):format(
            exports.tunrc_Shared:getVehicleReadableName(localPlayer.vehicle.model)), exports.tunrc_UI:getThemeColor())
    end
    exports.tunrc_UI:hideMessageBox()
    triggerServerEvent("sellvehicle.cancelOffer", resourceRoot)
end

local function showOfferDeclinedMessage(seller, buyer, vehicleModel, price)
    local buyerName = exports.tunrc_Utils:removeHexFromString(buyer.name)
    local themeColor = {exports.tunrc_UI:getThemeColor()}
    exports.tunrc_Chat:message("global", exports.tunrc_Lang:getString("sell_vehicle_declined"):format(buyerName,
        exports.tunrc_Shared:getVehicleReadableName(vehicleModel)), themeColor[1], themeColor[2], themeColor[3])
    exports.tunrc_Sounds:playSound("error.wav")
end

local function showOfferAcceptedMessage(seller, buyer, vehicleModel, price)
    local buyerName = exports.tunrc_Utils:removeHexFromString(buyer.name)
    local themeColor = {exports.tunrc_UI:getThemeColor()}
    exports.tunrc_Chat:message("global", exports.tunrc_Lang:getString("sell_vehicle_success"):format(
        exports.tunrc_Shared:getVehicleReadableName(vehicleModel), buyerName, exports.tunrc_Lang:numberFormat(price)), themeColor[1], themeColor[2], themeColor[3])
    exports.tunrc_Sounds:playSound("sell.wav")
end

addEvent("sellvehicle.answerOffer", true)
addEventHandler("sellvehicle.answerOffer", resourceRoot, function(seller, buyer, accepted, vehicleModel, price)
    if seller == localPlayer then
        offerActive = false
        if accepted then
            showOfferAcceptedMessage(seller, buyer, vehicleModel, price)
        else
            showOfferDeclinedMessage(seller, buyer, vehicleModel, price)
        end
    elseif localPlayer == buyer then
        if accepted then
            exports.tunrc_Garage:enterGarage()
            exports.tunrc_Sounds:playSound("sell.wav")
        else
            exports.tunrc_Sounds:playSound("error.wav")
        end
    end
end)

bindKey("backspace", "down", function ()
    if offerActive then
        cancelOffer()
    end
end)
