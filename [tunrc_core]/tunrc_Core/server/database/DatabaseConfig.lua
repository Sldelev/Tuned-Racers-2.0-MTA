--- Файл конфигурации бд
-- @script tunrc_Core.DatabaseConfig
-- @author Wherry

--- Таблица конфигурации подключения к БД.
-- @tfield string dbType тип СУБД
-- @tfield string host хост
-- @tfield number port порт
-- @tfield string username имя пользователя
-- @tfield string password пароль
-- @tfield table options дополнительные параметры подключения
DatabaseConfig = {
	dbType = "mysql",

	host = "195.18.27.241",
	port = 3306,
	dbName = "gs62427",

	-- Auth
	username = "gs62427",
	password = "CEGgAmFunw",

	options = {
		autoreconnect = 1
	}
}
