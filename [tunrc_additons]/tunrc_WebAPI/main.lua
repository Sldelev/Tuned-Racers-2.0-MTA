local SHOP_KEY = "86740167D2992433CB"
local SHOP_ID = 206480
local TRADEMC_IP = "79.137.70.179"
local shopItems = {}

local function onReceiveItems(responseData, responseInfo)
    if responseInfo.success == false then
        outputDebugString("WebAPI: Error while fetching items")
        return false
    end

    local data = fromJSON(responseData)
    if not data then
        outputDebugString("WebAPI: No items in store")
        return false
    end

    local categories = data.response.categories
    for _, category in pairs(categories) do
        if category.items then
            for _, item in pairs(category.items) do
                item.category_id = category.id
                shopItems[item.id] = item
            end
        end
    end
end

fetchRemote("https://api.trademc.org/shop.getItems?shop=" .. tostring(SHOP_ID) .. "&version=3", {
    queue = "trademc",
    method = "GET",
}, onReceiveItems)

function processPayment(data)
    if not hostname or hostname ~= TRADEMC_IP then
        outputDebugString("WebAPI: Bad request from '" .. tostring(hostname) .. "'")
        return "Bad request"
    end
    if type(data) ~= "table" then
        outputDebugString("WebAPI: Invalid JSON")
        return "Invalid JSON"
    end
    if not data.hash then
        outputDebugString("WebAPI: Bad hash")
        return "Bad hash"
    end
    if data.shop_id ~= SHOP_ID then
        outputDebugString("WebAPI: Invalid shop ID")
        return "Invalid shop ID"
    end

    local items = data.items
    if not items then
        outputDebugString("WebAPI: No items bought")
        return "No items bought"
    end
end

function giveMoney(username, amount)
    if not hostname or hostname ~= TRADEMC_IP then
        outputDebugString("WebAPI: Bad request from '" .. tostring(hostname) .. "'")
        return "Bad request"
    end

    return exports.tunrc_core:giveUserMoney(username, tonumber(amount))
end

function giveVehicle(username, modelId)
    if not hostname or hostname ~= TRADEMC_IP then
        outputDebugString("WebAPI: Bad request from '" .. tostring(hostname) .. "'")
        return "Bad request"
    end

    return exports.tunrc_core:giveUserCar(username, tonumber(modelId))
end

function giveSkin(username, modelId)
    if not hostname or hostname ~= TRADEMC_IP then
        outputDebugString("WebAPI: Bad request from '" .. tostring(hostname) .. "'")
        return "Bad request"
    end

    return exports.tunrc_core:giveUserSkin(username, tonumber(modelId))
end
