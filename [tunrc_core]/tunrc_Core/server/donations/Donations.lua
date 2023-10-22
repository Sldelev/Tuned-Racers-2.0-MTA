Donations = {}

local DONATIONS_TABLE_NAME = "donations"
-- Интервал обновления в секундах
local DONATIONS_UPDATE_INTERVAL = 10

function Donations.setup()
	DatabaseTable.create(DONATIONS_TABLE_NAME, {
		{ name="user_id", type=DatabaseTable.ID_COLUMN_TYPE, options="NOT NULL" },
		-- Вещи, которые даёт ключ
		{ name="money",   type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="donatmoney",   type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="xp", 	  type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="car", type="int",	 options="UNSIGNED DEFAULT 0" },
		{ name="premium", type="int",	 options="UNSIGNED DEFAULT 0" }
	}, "FOREIGN KEY (user_id)\n\tREFERENCES users("..DatabaseTable.ID_COLUMN_NAME..")\n\tON DELETE CASCADE")

	setTimer(Donations.update, DONATIONS_UPDATE_INTERVAL * 1000, 0)
	Donations.update()
end

function giveUserMoney(username, amount)
	if type(username) ~= "string" or type(amount) ~= "number" then
		return
	end
	return Users.getByUsername(username, {"_id"}, function(result)
		if not result or not result[1] or not result[1]._id then
			outputDebugString("Donate: Invalid username " .. username)
			return
		end
		DatabaseTable.insert(DONATIONS_TABLE_NAME, { user_id = result[1]._id, money = amount }, function (result)
			outputDebugString(("Donate: $%d to '%s'"):format(amount, username))
		end)
	end)
end

function giveUserDonatMoney(username, amount)
	if type(username) ~= "string" or type(amount) ~= "number" then
		return
	end
	return Users.getByUsername(username, {"_id"}, function(result)
		if not result or not result[1] or not result[1]._id then
			outputDebugString("Donate: Invalid username " .. username)
			return
		end
		DatabaseTable.insert(DONATIONS_TABLE_NAME, { user_id = result[1]._id, donatmoney = amount }, function (result)
			outputDebugString(("Donate: ¤%d to '%s'"):format(amount, username))
		end)
	end)
end

function giveUserCar(username, modelId)
	if type(username) ~= "string" or type(modelId) ~= "number" then
		return
	end
	return Users.getByUsername(username, {"_id"}, function(result)
		if not result or not result[1] or not result[1]._id then
			outputDebugString("Donate: Invalid username " .. username)
			return
		end
		DatabaseTable.insert(DONATIONS_TABLE_NAME, { user_id = result[1]._id, car = modelId }, function (result)
			outputDebugString(("Donate: Car %d to '%s'"):format(modelId, username))
		end)
	end)
end

function giveUserPremium(username, duration)
	if type(username) ~= "string" or type(duration) ~= "number" then
		return
	end
	return Users.getByUsername(username, {"_id"}, function(result)
		if not result or not result[1] or not result[1]._id then
			outputDebugString("Donate: Invalid username " .. username)
			return 
		end
		DatabaseTable.insert(DONATIONS_TABLE_NAME, { user_id = result[1]._id, premium = duration }, function (result)
			outputDebugString("Premium for '" .. tostring(username) .. "'" .. duration)
		end)
	end)
end

local function giveDonationToPlayer(player, donation)
	if not isElement(player) or not donation then
		exports.tunrc_Logger:log("donations", "Failed to process donation for " .. tostring(player.name))
		return false
	end
	DatabaseTable.delete(DONATIONS_TABLE_NAME, { _id = donation._id }, function (result)
		local money = donation.money
		if type(money) ~= "number" then
			money = 0
		end
		local donatmoney = donation.donatmoney
		if type(donatmoney) ~= "number" then
			donatmoney = 0
		end
		local xp = donation.xp
		if type(xp) ~= "number" then
			xp = 0
		end
		if xp < 0 then
			xp = 0
		end
		if money < 0 then
			money = 0
		end
		
		if donatmoney < 0 then
			donatmoney = 0
		end

		if money > 0 then
			givePlayerMoney(player, money)
		end
		if donatmoney > 0 then
			givePlayerDonatMoney(player, donatmoney)
		end
		if xp > 0 then
			givePlayerXP(player, xp)
		end
		if donation.car > 0 then
			addPlayerVehicle(player, donation.car)
		end

		local premiumDuration = donation.premium
		if premiumDuration and type(premiumDuration) == "number" then
			local currentPremium = player:getData("premium_expires")
			if type(currentPremium) ~= "number" then
				currentPremium = 0
			end
			local timestamp = getRealTime(false).timestamp
			local premiumExpireDate = 0
			if currentPremium > timestamp then
				premiumExpireDate = 0
				outputDebugString("End player premium")
			end
			if currentPremium < timestamp then
				premiumExpireDate = timestamp + premiumDuration
				outputDebugString("Started player premium")
			else
				premiumExpireDate = currentPremium + premiumDuration
				outputDebugString("Added player premium")
			end
			player:setData("premium_expires", premiumExpireDate)
		end
		triggerClientEvent(player, "tunrc_Core.donation", player)
		exports.tunrc_Logger:log("donations", string.format("Given donation %s to player %s (%s)",
			tostring(donation._id),
			tostring(player.name),
			tostring(player:getData("username"))))
	end)
end

function Donations.update()
	DatabaseTable.select(DONATIONS_TABLE_NAME, {}, {}, function (result)
		if not result or #result == 0 then
			return
		end

		for i, player in ipairs(getElementsByType("player")) do
			local playerId = player:getData("_id")
			if playerId then
				for _, donation in ipairs(result) do
					if donation.user_id == playerId then
						giveDonationToPlayer(player, donation)
					end
				end
			end
		end
	end)
end
