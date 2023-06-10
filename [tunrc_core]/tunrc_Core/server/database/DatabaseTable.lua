--- Модуль для работы с таблицами в базе данных
-- @module tunrc_Core.DatabaseTable
-- @author Wherry


-- Модуль для работы с таблицами в базе данных
DatabaseTable = {}
--- Название столбца для ID записи
DatabaseTable.ID_COLUMN_NAME = "_id"
--- Тип столбца для ID записи
DatabaseTable.ID_COLUMN_TYPE = "int"

local function retrieveQueryResults(connection, queryString, callback, ...)
	if not isElement(connection) then
		outputDebugString("ERROR: retrieveQueryResults failed: no database connection")
		return false
	end
	if type(queryString) ~= "string" then
		error("queryString must be string")
	end
	-- Если не передали callback
	if type(callback) ~= "function" then
		-- Вернуть результат запроса синхронно
		local handle = connection:query(queryString)
		return handle:poll(-1)
	else -- Если передали callback, вернуть результат асинхронно
		return not not connection:query(function (queryHandle, args)
			local result = queryHandle:poll(0)
			if type(args) ~= "table" then
				args = {}
			end
			executeCallback(callback, result, unpack(args))
		end, {...}, queryString)
	end
end

--- Создание таблицы
-- @tparam string tableName название таблицы
-- @tparam table columns столбцы. См. пример
-- @tparam[opt] string options параметры таблицы
-- @treturn bool удалось ли создать таблицу
-- @usage DatabaseTable.create("users", {
--	{ name="username", type="varchar", size=25, options="UNIQUE NOT NULL" },
--	{ name="password", type="varchar", size=255, options="NOT NULL" },
--	{ name="money", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0" },
--})
function DatabaseTable.create(tableName, columns, options)
	if type(tableName) ~= "string" or type(columns) ~= "table" then
		outputDebugString("ERROR: DatabaseTable.create: bad arguments")
		return false
	end
	if type(options) ~= "string" then
		options = ""
	else
		options = ", " .. options
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.create: no database connection")
		return false
	end
	-- Автоматическое создание поля с id
	table.insert(columns, {name = DatabaseTable.ID_COLUMN_NAME, type = DatabaseTable.ID_COLUMN_TYPE, options = "NOT NULL PRIMARY KEY AUTO_INCREMENT"})
	-- Строка запроса для каждого столбца таблицы
	local columnsQueries = {}
	for i, column in ipairs(columns) do
		local columnQuery = connection:prepareString("`??` ??", column.name,  column.type)
		if column.size and tonumber(column.size) then
			columnQuery = columnQuery .. connection:prepareString("(??)", column.size)
		end
		if not column.options or type(column.options) ~= "string" then
			column.options = ""
		end
		if string.len(column.options) > 0 then
			columnQuery = columnQuery .. " " .. column.options
		end
		table.insert(columnsQueries, columnQuery)
	end
	local queryString = connection:prepareString(
		"CREATE TABLE IF NOT EXISTS `??` (" .. table.concat(columnsQueries, ", ") .. " " .. options .. ");",
		tableName
	)
	return connection:exec(queryString)
end

--- Вставка в таблицу
-- @tparam string tableName название таблицы
-- @tparam table insertValues значения полей {ключ=значение}
-- @tparam[opt] function callback callback
-- @treturn bool результат выполнения функции
-- Если не указан callback, функция выполняется синхронно и результат запроса к БД будет передан в качестве возвращаемого значения.
-- @usage DatabaseTable.insert("users", { name = "User1", password = "12345" })
function DatabaseTable.insert(tableName, insertValues, callback, ...)
	if type(tableName) ~= "string" or type(insertValues) ~= "table" or not next(insertValues) then
		outputDebugString("ERROR: DatabaseTable.insert: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.insert: no database connection")
		return false
	end
	local columnsQueries = {}
	local valuesQueries = {}
	local valuesCount = 0
	for column, value in pairs(insertValues) do
		table.insert(columnsQueries, connection:prepareString("`??`", column))
		table.insert(valuesQueries, connection:prepareString("?", value))
		valuesCount = valuesCount + 1
	end
	if valuesCount == 0 then
		return retrieveQueryResults(connection, connection:prepareString("INSERT INTO `??`;", tableName), callback, ...)
	end
	local columnsQuery = connection:prepareString("(" .. table.concat(columnsQueries, ",") .. ")")
	local valuesQuery = connection:prepareString("(" .. table.concat(valuesQueries, ",") .. ")")
	local queryString = connection:prepareString(
		"INSERT INTO `??` " .. columnsQuery .. " VALUES " .. valuesQuery .. ";",
		tableName
	)
	return retrieveQueryResults(connection, queryString, callback, ...)
end

--- Обновление записей в таблице
-- @tparam string tableName название таблицы
-- @tparam table setFields значения полей, которые нужно изменить {ключ=значение}
-- @tparam[opt] table whereFields поля, по которым будут выбираться строки {ключ=значение}
-- @tparam[opt] function callback callback
-- @treturn bool результат выполнения функции.
-- Если не указан callback, функция выполняется синхронно и результат запроса к БД будет передан в качестве возвращаемого значения.
-- @usage DatabaseTable.update("users", { password = "789" }, { username = "user1" })
function DatabaseTable.update(tableName, setFields, whereFields, callback, ...)
	if type(tableName) ~= "string" or type(setFields) ~= "table" or not next(setFields) or type(whereFields) ~= "table" then
		outputDebugString("ERROR: DatabaseTable.update: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.update: no database connection")
		return false
	end

	local setQueries = {}
	for column, value in pairs(setFields) do
		if value == "NULL" then
			table.insert(setQueries, connection:prepareString("`??`=NULL", column))
		else
			table.insert(setQueries, connection:prepareString("`??`=?", column, value))
		end
	end
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local queryString = connection:prepareString("UPDATE `??` SET " .. table.concat(setQueries, ", "), tableName)
	if #whereQueries > 0 then
		queryString = queryString .. connection:prepareString(" WHERE " .. table.concat(whereQueries, " AND "))
	end
	queryString = queryString .. ";"
	return retrieveQueryResults(connection, queryString, callback, ...)
end

--- Получение записей из таблицы
-- @tparam string tableName название таблицы
-- @tparam[opt] table columns список столбцов, которые нужно получить
-- @tparam[opt] table whereFields поля, по которым будут выбираться строки {ключ=значение}
-- @tparam[opt] function callback callback
-- @treturn bool результат выполнения функции.
-- Если не указан callback, функция выполняется синхронно и результат запроса к БД будет передан в качестве возвращаемого значения.
-- @usage DatabaseTable.select("users", {"username", "password"}, { username = "user3" })
function DatabaseTable.select(tableName, columns, whereFields, callback, ...)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.select: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.select: no database connection")
		return false
	end
	-- WHERE
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local whereQueryString = ""
	if #whereQueries > 0 then
		whereQueryString = " WHERE " .. table.concat(whereQueries, " AND ")
	end

	-- COLUMNS
	-- SELECT *
	if not columns or type(columns) ~= "table" or #columns == 0 then
		return retrieveQueryResults(connection, connection:prepareString("SELECT * FROM `??` " .. whereQueryString ..";", tableName), callback, ...)
	end
	local selectColumns = {}
	for i, name in ipairs(columns) do
		table.insert(selectColumns, connection:prepareString("`??`", name))
	end

	-- SELECT COLUMNS
	local queryString = connection:prepareString(
		"SELECT " .. table.concat(selectColumns, ",") .." FROM `??` " .. whereQueryString ..";",
		tableName
	)
	return retrieveQueryResults(connection, queryString, callback, ...)
end

--- Удаление записей из таблицы
-- @tparam string tableName название таблицы
-- @tparam[opt] table whereFields поля, по которым будут выбираться строки для удаления {ключ=значение}
-- @tparam[opt] function callback callback
-- @treturn bool результат выполнения функции.
-- Если не указан callback, функция выполняется синхронно и результат запроса к БД будет передан в качестве возвращаемого значения.
-- @usage DatabaseTable.delete("users", { username = "user2" })
function DatabaseTable.delete(tableName, whereFields, callback, ...)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.select: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.select: no database connection")
		return false
	end
	-- WHERE
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local whereQueryString = ""
	if #whereQueries > 0 then
		whereQueryString = " WHERE " .. table.concat(whereQueries, " AND ")
	end

	-- SELECT COLUMNS
	local queryString = connection:prepareString(
		"DELETE FROM `??` " .. whereQueryString ..";",
		tableName
	)
	return retrieveQueryResults(connection, queryString, callback, ...)
end

function DatabaseTable.exists(tableName)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.exists: bad arguments")
		return false
	end	
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.exists: no database connection")
		return false
	end	
	local queryString = connection:prepareString([[SELECT count(*) 
		FROM information_schema.TABLES 
		WHERE (TABLE_SCHEMA = ?) AND (TABLE_NAME = ?)
	]], DatabaseConfig.dbName, tableName)

	local result = retrieveQueryResults(connection, queryString)
	-- Eto konechno strannovato, no tak nado
	if type(result) == "table" then
		result = result[1]
		if type(result) == "table" then
			local key = next(result)
			if key then
				result = result[key]
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
	if type(result) ~= "number" then
		return false
	end
	return result > 0
end