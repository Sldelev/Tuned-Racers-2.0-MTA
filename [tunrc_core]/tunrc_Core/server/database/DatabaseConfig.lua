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

	host = "185.189.255.97",
	port = 3306,
	dbName = "gs78500",

	-- Auth
	username = "gs78500",
	password = "ejdio99j",

	options = {
		autoreconnect = 1
	}
}
