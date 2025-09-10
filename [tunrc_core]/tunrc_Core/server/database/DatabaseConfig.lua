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

	host = Сюда пишешь айпи своей бд,
	port = Сюда порт,
	dbName = Тут название бд,

	-- Auth
	username = Логин от бд,
	password = Пароль от бд,

	options = {
		autoreconnect = 1
	}
}
