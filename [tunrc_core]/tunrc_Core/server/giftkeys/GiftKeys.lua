GiftKeys = {}

local GIFT_KEYS_TABLE_NAME = "gift_keys"
local GIFT_KEY_LENGTH = 6
local GIFT_KEY_SECRET = "wBbNvabPTK2j4ESk"

local keysCounter = 0

function GiftKeys.setup()
	DatabaseTable.create(GIFT_KEYS_TABLE_NAME, {
		{ name="key", 		type="varchar", size=8, options="UNIQUE NOT NULL"},
		-- Вещи, которые даёт ключ
		{ name="money", 	type="bigint", options="UNSIGNED DEFAULT 0"},
		{ name="xp", 		type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="car", 		type="MEDIUMTEXT" },
		{ name="count", 		type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="user_name", 		type="varchar", size=50},
		-- Дополнительные данные в JSON
		{ name="data", 		type="MEDIUMTEXT" },		
	})
end

function GiftKeys.add(options)
	if type(options) ~= "table" then
		outputDebugString("ERROR: GiftKeys.add: Options must be table")
		return false
	end

	-- Проверка типов полей
	if type(options.money) ~= "number" then options.money = nil end
	if type(options.xp) ~= "number" then options.xp = nil end
	if type(options.car) ~= "string" then options.car = nil end
	if type(options.count) ~= "number" then options.count = nil end
	-- Проверка значений полей
	if options.money and options.money < 0 then options.money = nil end
	if options.xp and options.xp < 0 then options.xp = nil end
	if options.count and options.count < 0 then options.count = nil end
	-- Если такая машина не существует
	if not exports.tunrc_Shared:getVehicleModelFromName(options.car) then options.car = nil end

	-- Генерация нового ключа
	local success = DatabaseTable.insert(GIFT_KEYS_TABLE_NAME, { 
		key = options.key, 
		money = options.money,
		xp = options.xp,
		car = options.car,
		count = options.count
	}, function (result)
		if result then
			triggerEvent("tunrc_Core.giftKeyAdded", resourceRoot, key)
		end
	end)
	return not not success
end

function GiftKeys.getKeys(where)
	if type(where) ~= "table" then
		where = {}
	end
	return DatabaseTable.select(GIFT_KEYS_TABLE_NAME, {}, where)
end

function GiftKeys.isKeyValid(key)
end

local function giveKeyGiftsToPlayer(player, options)
	if not isElement(player) then
		outputDebugString("giveKeyGiftsToPlayer: Bad player")
		return false
	end
	if type(options) ~= "table" then
		outputDebugString("giveKeyGiftsToPlayer: Bad options")
		return false
	end
	-- Проверка наличия полей
	if type(options.money) ~= "number" then options.money = nil end
	if type(options.xp) ~= "number" then options.xp = nil end
	if type(options.car) ~= "string" then options.car = nil end
	-- Проверка значений
	if options.money then options.money = math.max(0, options.money) end
	if options.xp then options.xp = math.max(0, options.xp) end
	local model
	if options.car then
		model = exports.tunrc_Shared:getVehicleModelFromName(options.car)
		if not model then
			options.car = nil
		end
	end
	-- Выдача денег
	if options.money then
		givePlayerMoney(player, options.money)
	end
	-- Выдача опыта
	if options.xp then
		givePlayerXP(player, options.xp)
	end
	-- Выдача автомобиля
	if model then
		addPlayerVehicle(player, model)
	end

	Users.saveAccount(player)
	return true
end

function GiftKeys.activate(key, player, username)
	if count == 0 then
		GiftKeys.remove(key.key)
		return false
	end
	if not isElement(player) then
		outputDebugString("ERROR: Failed to activate gift key '" .. tostring(key) .. "' for player '" .. tostring(player) .. "'")
		triggerClientEvent(player, "tunrc_Core.keyActivation", resourceRoot, false)
		return false
	end
	
	if DatabaseTable.select(GIFT_KEYS_TABLE_NAME, {"user_name"}, { key = key.key }) == player:getData("username") then
		outputDebugString("ERROR: Failed to activate gift key '" .. tostring(key) .. "' for player '" .. tostring(player) .. "' key already used")
		return false
	end

	return not not DatabaseTable.select(GIFT_KEYS_TABLE_NAME, {}, { key = key }, function (result)
		if type(result) ~= "table" or #result == 0 then
			triggerClientEvent(player, "tunrc_Core.keyActivation", resourceRoot, false)
		else
			local key = result[1]
			if giveKeyGiftsToPlayer(player, key) then
				exports.tunrc_Logger:log("giftkeys", "Key activated: " .. tostring(key.key) .. " for " .. tostring(player.name))
				triggerClientEvent(player, "tunrc_Core.keyActivation", resourceRoot, true, key)
				DatabaseTable.update(GIFT_KEYS_TABLE_NAME, {user_name = player:getData("username")}, {key = key.key})
			else
				triggerClientEvent(player, "tunrc_Core.keyActivation", resourceRoot, false)
			end
		end
	end)
end

function GiftKeys.remove(key)
	local success = DatabaseTable.delete(GIFT_KEYS_TABLE_NAME, { key = key }, function (result)
		if result then
			outputDebugString("Key removed: " .. tostring(key))
			triggerEvent("tunrc_Core.giftKeyRemoved", resourceRoot, key)
		end
	end)
	return success
end

addEvent("tunrc_Core.requireKeyActivation", true)
addEventHandler("tunrc_Core.requireKeyActivation", root, function (key)
	GiftKeys.activate(key, client)
end)