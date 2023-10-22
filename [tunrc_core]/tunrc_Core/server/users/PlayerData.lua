PlayerData = {}
local loadFields = {
	"_id",
	"username",
	"skin",
	"money",
	"donatmoney",
	"lastseen",
	"playtime",
	"register_time",
	"xp",
	"group",
	"premium_expires",
	"last_sell_time",
	"max_drift_points_session",
	"drift_points",
	"last_code_use_time"
}
local saveFields = {
	"skin",
	"money",
	"donatmoney",
	"playtime",
	"xp",
	"premium_expires",
	"max_drift_points_session",
	"drift_points",
	"last_code_use_time"
}
local protectFields = {
	"_id",
	"level",
	"money",
	"donatmoney",
	"xp",
	"group",
	"isMuted",
	"isPremium",
	"premium_expires",
	"last_sell_time",
	"last_code_use_time"
}

local function filterData(dataName, value)
	if dataName == "lastseen" then
		return exports.tunrc_Utils:convertTimestampToSeconds(value)
	end
	return value
end

function PlayerData.set(player, account)
	for i, name in ipairs(loadFields) do
		player:setData(name, filterData(name, account[name]))
	end
	player:setData("level", 1)
	player:setData("isPremium", false)
	local premiumExpireTimestamp = player:getData("premium_expires")
	if not premiumExpireTimestamp then
		premiumExpireTimestamp = 0
	end
	if premiumExpireTimestamp > getRealTime().timestamp then
		player:setData("isPremium", true)
	end
	triggerEvent("_playerDataLoaded", resourceRoot, player)
end

function PlayerData.get(player)
	local fields = {}
	for i, name in ipairs(saveFields) do
		fields[name] = player:getData(name)
	end
	return fields
end

function PlayerData.clear(player)
	for i, name in ipairs(loadFields) do
		player:setData(name, nil)
	end
	player:setData("tunrc_Core.state", nil)
	player:setData("isPremium", nil)
end

-- Защита даты
addEventHandler("onElementDataChange", root, function(dataName, oldValue)
	if not client then
		return
	end
	if source.type == "player" then
		for i, name in ipairs(loadFields) do
			if dataName == name then
				source:setData(dataName, oldValue)
				return
			end
		end
		for i, name in ipairs(protectFields) do
			if dataName == name then
				source:setData(dataName, oldValue)
				return
			end
		end
	end
end)

setTimer(function()
	for i, player in ipairs(getElementsByType("player")) do
		local currentPlaytime = tonumber(player:getData("playtime"))
		if currentPlaytime then
			player:setData("playtime", currentPlaytime + 1)
		end
	end
end, 60000, 0)
