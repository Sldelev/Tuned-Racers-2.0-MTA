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

	host = "46.174.50.7",
	port = 3306,
	dbName = "u32162_tunedrc",

	-- Auth
	username = "u32162_tunedrcadmin",
	password = "N6g2T4c2G7",

	options = {
		autoreconnect = 1
	}
}
