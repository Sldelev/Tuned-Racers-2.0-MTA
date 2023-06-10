local activeOffers = {}

local offerCancelTimers = {}

function getPlayerCooldownLeft(player)
    local timestamp = getRealTime(false).timestamp
    local lastSellTime = player:getData("last_sell_time") or timestamp
    local leftTime = math.max(SELL_COOLDOWN - (timestamp - lastSellTime), 0)

    return leftTime
end

function isPlayerAllowedToSell(player)
    local leftTime = getPlayerCooldownLeft(player)
    local allow = true
    if leftTime > 0 then
        allow = false
    end

    return allow
end

addEvent("sellvehicle.checkPermission", true)
addEventHandler("sellvehicle.checkPermission", resourceRoot, function ()
    local leftTime = getPlayerCooldownLeft(client)
    local allow = true
    if leftTime > 0 then
        allow = false
    end
    triggerClientEvent(client, "sellvehicle.onPermissionResult", resourceRoot, allow, leftTime)
end)

local function cancelOfferFrom(seller)
    if activeOffers[seller] then
        triggerClientEvent(seller, "sellvehicle.cancelOffer", resourceRoot, seller, activeOffers[seller])
        triggerClientEvent(activeOffers[seller], "sellvehicle.cancelOffer", resourceRoot, seller, activeOffers[seller])
        activeOffers[seller] = nil
        if isTimer(offerCancelTimers[seller]) then
            offerCancelTimers[seller]:destroy()
        end
        offerCancelTimers[seller] = nil
    end
end

local function cancelOfferFor(player)
    for seller, buyer in pairs(activeOffers) do
        if player == buyer then
            cancelOfferFrom(seller)
            break
        end
    end
end

local function startOffer(seller, buyer, vehicle, price)
    if not activeOffers[seller] then
        activeOffers[seller] = buyer
        offerCancelTimers[seller] = Timer(cancelOfferFrom, OFFER_CANCEL_TIME, 1, seller)
        triggerClientEvent(buyer, "sellvehicle.showOffer", resourceRoot, seller, vehicle, price)
    end
end



addEvent("sellvehicle.sendOffer", true)
addEventHandler("sellvehicle.sendOffer", resourceRoot, function (targetPlayer, price)
    if not isElement(targetPlayer) or targetPlayer:getData("tunrc_Core.state") then
        return
    end
    if not isPlayerAllowedToSell(client) then
        return
    end
    if type(price) ~= "number" or price < 0 then
        return
    end

    cancelOfferFrom(client)
    if not activeOffers[targetPlayer] then
      local vehicle = exports.tunrc_Core:getPlayerSpawnedVehicles(client)[1]
      if vehicle then
          startOffer(client, targetPlayer, vehicle, price)
      end
    end
end)

addEvent("sellvehicle.answerOffer", true)
addEventHandler("sellvehicle.answerOffer", resourceRoot, function (seller, accepted, price)
    local buyer = activeOffers[seller]
    if buyer and buyer == client then
        if isTimer(offerCancelTimers[seller]) then
            offerCancelTimers[seller]:destroy()
        end
        offerCancelTimers[seller] = nil

        local vehicle = exports.tunrc_Core:getPlayerSpawnedVehicles(seller)[1]
        if vehicle then
            local vehicleModel = vehicle.model

            if accepted then
                exports.tunrc_Core:givePlayerMoney(buyer, -price)
                exports.tunrc_Core:givePlayerMoney(seller, price)
                local vehicleId = vehicle:getData("_id")
                local vehicleInfo = exports.tunrc_Core:getVehicleById(tonumber(vehicleId))[1]
                local vehicleName = exports.tunrc_Shared:getVehicleReadableName(vehicleInfo.model)
                local logMessage = string.format("Player %s (%s) sold %s (ID: %d) to %s (%s) for $%d",
                    seller.name, seller:getData("username"), vehicleName, vehicleId,
                    buyer.name, buyer:getData("username"), price)
                exports.tunrc_Logger:log("vehicles", logMessage)
                exports.tunrc_Core:returnVehicleToGarage(vehicle)
                exports.tunrc_Core:changeVehicleOwner(seller, buyer, vehicleId)
                local time = getRealTime(false)
                seller:setData("last_sell_time", time.timestamp)
                exports.tunrc_Core:updateUserAccount(seller:getData("username"), {last_sell_time = time.timestamp})
            end
            triggerClientEvent({ seller, buyer }, "sellvehicle.answerOffer", resourceRoot, seller, buyer, accepted, vehicleModel, price)

            activeOffers[seller] = nil
        end
    end
end)

addEvent("sellvehicle.cancelOffer", true)
addEventHandler("sellvehicle.cancelOffer", resourceRoot, function ()
    cancelOfferFrom(client)
end)



addEventHandler("onElementDataChange", root, function (dataName, oldValue)
    if dataName == "tunrc_Core.state" then
        if source:getData("tunrc_Core.state") then
            cancelOfferFrom(source)
            cancelOfferFor(source)
        end
    end
end)

addEventHandler("onPlayerQuit", root, function ()
    cancelOfferFrom(source)
    cancelOfferFor(source)
end)
