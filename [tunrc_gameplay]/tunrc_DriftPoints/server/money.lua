local restMoney = {}
local restXp = {}

addEvent("tunrc_DriftPoints.earnedPoints", true)
addEventHandler("tunrc_DriftPoints.earnedPoints", resourceRoot, function (points)
    local driftMoney = exports.tunrc_Shared:getEconomicsProperty("drift_money") or 0
	local driftXP = exports.tunrc_Shared:getEconomicsProperty("drift_xp") or 0

	local money = points / 100000 * driftMoney
    local xp = points / 100000 * driftXP

    if not restMoney[client] then
        restMoney[client] = 0
    end
    if not restXp[client] then
        restXp[client] = 0
    end

    restMoney[client] = restMoney[client] + (money - math.floor(money))
    restXp[client] = restXp[client] + (xp - math.floor(xp))

    if restMoney[client] >= 1 then
        money = money + 1
        restMoney[client] = restMoney[client] - 1
    end

    if restXp[client] >= 1 then
        xp = xp + 1
        restXp[client] = restXp[client] - 1
    end

    exports.tunrc_Core:givePlayerMoney(client, math.floor(money))
	exports.tunrc_Core:givePlayerXP(client, math.floor(xp))
end)

addEventHandler("onPlayerQuit", root,
    function ()
        if restMoney[source] then
            restMoney[source] = nil
        end
        if restXp[source] then
            restXp[source] = nil
        end
    end
)
