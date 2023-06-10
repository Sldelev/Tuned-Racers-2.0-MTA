UserVehicles = {}
local VEHICLES_TABLE_NAME = "vehicles"

function UserVehicles.setup()
	DatabaseTable.create(VEHICLES_TABLE_NAME, {
		{ name="owner_id", type=DatabaseTable.ID_COLUMN_TYPE, options="NOT NULL" },
		{ name="model", type="smallint", options="UNSIGNED NOT NULL" },
		-- Пробег
		{ name="mileage", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0"},
		-- Тюнинг
		{ name="tuning", type="MEDIUMTEXT" },
		{ name="stickers", type="MEDIUMTEXT" }
	}, "FOREIGN KEY (owner_id)\n\tREFERENCES users("..DatabaseTable.ID_COLUMN_NAME..")\n\tON DELETE CASCADE")
end

-- Добавление автомобиля в аккаунт игрока
function UserVehicles.addVehicle(ownerId, model, callback)
	if 	type(ownerId) ~= "number" or type(model) ~= "number" then
		executeCallback(callback, false)
		outputDebugString("Invalid vehicle model")
		return false
	end
	-- Проверка модели
	if not exports.tunrc_Utils:isValidVehicleModel(model) then
		executeCallback(callback, false)
		outputDebugString("UserVehicles.addVehicle: Invalid vehicle model: " .. tostring(model))
		return false
	end
	-- Обращение к бд
	local success = DatabaseTable.insert(VEHICLES_TABLE_NAME, { owner_id = ownerId, model = model}, callback)
	if not success then
		executeCallback(callback, false)
	end
	exports.tunrc_Logger:log("vehicles",
		string.format("Added vehicle %s to user %s. Success: %s",
			tostring(model),
			tostring(ownerId),
			tostring(success)))
	return not not success
end

-- Удаление автомобиля из аккаунта
function UserVehicles.removeVehicle(vehicleId, callback)
	vehicleId = tonumber(vehicleId)
	if not vehicleId then
		executeCallback(callback, false)
		return false
	end

	-- Вернуть автомобиль в гараж, если он заспавнен в момент удаления
	local vehicle = VehicleSpawn.getSpawnedVehicle(vehicleId)
	if isElement(vehicle) then
		returnVehicleToGarage(vehicle)
	end

	local success = DatabaseTable.delete(VEHICLES_TABLE_NAME, { _id = vehicleId }, callback)
	if not success then
		executeCallback(callback, false)
	end
	exports.tunrc_Logger:log("vehicles",
		string.format("Removed vehicle %s. Success: %s",
			tostring(vehicleId),
			tostring(success)))
	return success
end

-- Информация об автомобиле
function UserVehicles.getVehicle(vehicleId, callback)
	if type(vehicleId) ~= "number" then
		executeCallback(callback, false)
		return false
	end

	return DatabaseTable.select(VEHICLES_TABLE_NAME, {}, {_id = vehicleId}, callback)
end

-- Владелец
function UserVehicles.getVehicleOwner(vehicleId, callback)
	if type(vehicleId) ~= "number" then
		executeCallback(callback, false)
		return false
	end

	return DatabaseTable.select(VEHICLES_TABLE_NAME, { "owner_id" }, {_id = vehicleId}, callback)
end

function UserVehicles.updateVehicle(vehicleId, fields, callback)
	if type(vehicleId) ~= "number" or type(fields) ~= "table" then
		executeCallback(callback, false)
		return false
	end

	local success = DatabaseTable.update(VEHICLES_TABLE_NAME, fields, {_id = vehicleId},
		function (result)
			executeCallback(callback, not not result)
		end)
	if not success then
		executeCallback(callback, false)
	end
	return success
end

-- Список всех автомобилей игрока
function UserVehicles.getVehicles(ownerId, callback)
	if type(ownerId) ~= "number" then
		executeCallback(callback, false)
		return false
	end
	return DatabaseTable.select(VEHICLES_TABLE_NAME, {}, {owner_id = ownerId}, callback)
end

-- Список id автомобилей игрока
function UserVehicles.getVehiclesIds(ownerId, callback)
	if type(ownerId) ~= "number" then
		executeCallback(callback, false)
		return false
	end
	return DatabaseTable.select(VEHICLES_TABLE_NAME, {"_id"}, {owner_id = ownerId}, callback)
end

function UserVehicles.changeOwner(vehicleId, newOwnerId, callback)
    return UserVehicles.updateVehicle(vehicleId, {owner_id = newOwnerId}, callback)
end
