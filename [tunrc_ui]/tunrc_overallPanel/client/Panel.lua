Panel = {}
local screenWidth, screenHeight = UI:getScreenSize()
local width = 1300
local height = 800
local panel

function Panel.create()
    if panel then
        return false
    end
	
	-- Создание основных ассетов
	
	local car_sell_icon = DxTexture("assets/textures/icons/car_sell.png")
	local gift_panel_icon = DxTexture("assets/textures/icons/gift_panel.png")
	local settings_icon = DxTexture("assets/textures/icons/settings_icon.png")
	local help_icon = DxTexture("assets/textures/icons/help_icon.png")
	local user_icon = DxTexture("assets/textures/icons/user_icon.png")
	local crownTexture = exports.tunrc_Assets:createTexture("crown.png")
	
	local garage_button_img = DxTexture("assets/textures/garage_button_img.png")
	local teleports_button_img = DxTexture("assets/textures/teleports_button_img.png")
	
	-- ОСНОВНАЯ ПАНЕЛЬ
	
	panel = UI:createTrcRoundedRectangle {
		x       = (screenWidth - width) / 2,
        y       = (screenHeight - height) / 2,
        width   = width,
        height  = height - 50,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(panel)
	UI:setVisible(panel, false)
	
	-- ПАНЕЛЬ СБОКУ
	
	menuPanel = UI:createTrcRoundedRectangle {
		x       = 20,
        y       = 35,
        width   = width * 0.19,
        height  = (height / 1.10) - 50,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40),
		shadow = true
	}
	UI:addChild(panel, menuPanel)
	
	-- ЭЛЕМЕНТЫ ПАНЕЛИ СБОКУ
	
	local serverNameLabel = UI:createDpLabel {
		x = UI:getWidth(menuPanel) / 2,
		y = 40,
		width = 0,
		height = 0,
		text = "TunedRacers",
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "default",
		alignX = "center",
		alignY = "top"
	}
	UI:addChild(menuPanel, serverNameLabel)
	
	local usernameLabel = UI:createDpLabel {
		x = 100,
		y = 150	,
		width = width,
		height = height,
		text = "---",
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "light"
	}
	UI:addChild(panel, usernameLabel)
	UIDataBinder.bind(usernameLabel, "username", function (value)
		return string.upper(tostring(value))
	end)
	
	local usernameLabelText = UI:createDpLabel {
		x = 100,
		y = 170,
		width = width,
		height = height,
		text = "Admin",
		color = tocolor(148, 150, 255),
		darkToggle = true,
		darkColor = tocolor(130, 130, 200),
		fontType = "lightSmall",
		locale = "overallpanel_account_player"
	}
	UI:addChild(panel, usernameLabelText)
	UIDataBinder.bind(usernameLabelText, "group", function (value)
		if not value then
			return exports.tunrc_Lang:getString("groups_player")
		else
			return exports.tunrc_Lang:getString("groups_" .. tostring(value))
		end
	end)
	
	local UserImage = UI:createImage {
	x = -50,
	y = 8,
	width = 32,
	height = 32,
	color = tocolor(0, 0, 0),
	darkToggle = true,
	darkColor = tocolor(255, 255, 255),
	texture = user_icon,	
	}
	UI:addChild(usernameLabel, UserImage)
	
	local Usercrown = UI:createImage {
	x = 8,
	y = -10,
	width = 16,
	height = 16,
	color = tocolor(255, 216, 0),
	texture = crownTexture,
	premium = true
	}
	UI:addChild(UserImage, Usercrown)
	
	-- Кнопка панели игрока
	UserPanel = UI:createTrcRoundedRectangle {
		x       = 215,
        y       = 155,
        width   = 30,
        height  = 30,
		radius = 5,
		color = tocolor(215, 215, 215),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		circle = true
	}
	UI:addChild(panel, UserPanel)
	
	-- Элементы кнопки гифт-панели
	local UserPanelButtonsY = 250
	local giftPanelLabel = UI:createDpLabel {
		x = 100,
		y = UserPanelButtonsY,
		width = width,
		height = height,
		text = "Gifts",
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "lightSmall",
		locale = "overallpanel_gift_panel_label"
	}
	UI:addChild(panel, giftPanelLabel)
	
	local giftPanelImage = UI:createImage {
	x = -50,
	y = 5,
	width = 16,
	height = 16,
	color = tocolor(0, 0, 0),
	darkToggle = true,
	darkColor = tocolor(255, 255, 255),
	texture = gift_panel_icon,	
	}
	UI:addChild(giftPanelLabel, giftPanelImage)
	
	giftPanelButton = UI:createTrcRoundedRectangle {
		x       = 220,
        y       = UserPanelButtonsY,
        width   = 20,
        height  = 20,
		radius = 2,
		color = tocolor(215, 215, 215),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		circle = true
	}
	UI:addChild(panel, giftPanelButton)
	
	-- Элементы кнопки продажи авто
	local sellVehicleLabel = UI:createDpLabel {
		x = 100,
		y = UserPanelButtonsY + 50,
		width = width,
		height = height,
		text = "Sell Vehicle",
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "lightSmall",
		locale = "overallpanel_sell_vehicle_label"
	}
	UI:addChild(panel, sellVehicleLabel)
	
	local sellVehicleImage = UI:createImage {
	x = -50,
	y = 5,
	width = 16,
	height = 16,
	color = tocolor(0, 0, 0),
	darkToggle = true,
	darkColor = tocolor(255, 255, 255),
	texture = car_sell_icon,	
	}
	UI:addChild(sellVehicleLabel, sellVehicleImage)
	
	sellVehicleButton = UI:createTrcRoundedRectangle {
		x       = 220,
        y       = UserPanelButtonsY + 50,
        width   = 20,
        height  = 20,
		radius = 2,
		color = tocolor(215, 215, 215),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		circle = true
	}
	UI:addChild(panel, sellVehicleButton)
	
	-- ЭЛЕМЕНТЫ ОСНОВНОЙ ПАНЕЛИ
	
	-- Кнопка закрытия панели
	Closebutton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(panel) - 30,
        y       = 15,
        width   = 15,
        height  = 15,
		radius = 6,
		color = tocolor(225, 0, 0),
		hover = true,
		hoverColor = tocolor(205, 0, 0)
	}
	UI:addChild(panel, Closebutton)
	
	-- Надпись приветствия
	local helloLabel = UI:createDpLabel {
		x = UI:getWidth(menuPanel) + 75,
		y = 70,
		width = width,
		height = height,
		text = "TunedRacers",
		color = tocolor (50, 50, 50, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "UIdefaultVerySmall"
	}
	UI:addChild(panel, helloLabel)
	UIDataBinder.bind(helloLabel, "username_mta", function (value)
		return exports.tunrc_Lang:getString("overallpanel_welcome_back")
	end)
	
	-- Надпись ниже приветствия
	local featuresLabel = UI:createDpLabel {
		x = UI:getWidth(menuPanel) + 75,
		y = 95,
		width = width,
		height = height,
		locale = "overallpanel_dashboard_label",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarge"
	}
	UI:addChild(panel, featuresLabel)
	
	-- Кнопка смены темы
	ChangeThemebutton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(panel) - 100,
        y       = UI:getY(helloLabel) + 10,
        width   = 30,
        height  = 30,
		radius = 15,
		color = tocolor(15, 15, 15),
		hover = true,
		hoverColor = tocolor(30, 30, 30),
		darkToggle = true,
		darkColor = tocolor(235, 235, 235),
		hoverDarkColor = tocolor(215, 215, 215)
	}
	UI:addChild(panel, ChangeThemebutton)
	
	-- Кнопка смены языка
	ChangeLanguageLabel = UI:createDpLabel {
		x = -75,
		y = -2.5,
		width = 30,
		height = 30,
		text = "EN",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarge"
	}
	UI:addChild(ChangeThemebutton, ChangeLanguageLabel)
	UIDataBinder.bind(ChangeLanguageLabel, "language_button_text", function (value)
		if exports.tunrc_Lang:getLanguage() == "english" then
			return "EN"
		else
			return "RU"
		end
	end)
	
	-- Панель телепортов
	
	featuresTeleportsPanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(menuPanel) + 75,
        y       = 195,
        width   = width * 0.19,
        height  = height * 0.3,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(22, 22, 22),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(panel, featuresTeleportsPanel)
	
	-- "Картинка" на панели телепортов	
	TeleportsImage = UI:createImage {
		x = 27,
		y = 20,
		width = width * 0.15,
		height = height * 0.18,
		texture = teleports_button_img,	
	}
	UI:addChild(featuresTeleportsPanel, TeleportsImage)
	
	-- Текст панели телепортов
	TeleportsButtonText = UI:createDpLabel {
		x = UI:getWidth(featuresTeleportsPanel) / 2,
		y = UI:getHeight(featuresTeleportsPanel) * 0.8 - 15,
		width = 0,
		height = 0,
		text = "Teleports",
		locale = "overallpanel_teleports_text",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		fontType = "lightLarge"
	}
	UI:addChild(featuresTeleportsPanel, TeleportsButtonText)
	
	-- Текст панели телепортов
	TeleportsButtonPlayersText = UI:createDpLabel {
		x = 0,
		y = 25,
		width = 0,
		height = 0,
		text = "Players on maps:0",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		alignX = "center",
		fontType = "lightSmall"
	}
	UI:addChild(TeleportsButtonText, TeleportsButtonPlayersText)
	
	-- Панель музыки
	MusicPlayerPanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(featuresTeleportsPanel) + 100,
        y       = 0,
        width   = width * 0.19,
        height  = height * 0.1,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(22, 22, 22)
	}
	UI:addChild(featuresTeleportsPanel, MusicPlayerPanel)
	
	-- Текст панели музыки
	local MusicPlayerText = UI:createDpLabel {
		x = 20,
		y = UI:getHeight(MusicPlayerPanel) / 3,
		width = 0,
		height = 0,
		text = "Music",
		locale = "overallpanel_music_text",
		alignY = "center",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "left",
		fontType = "lightSmall"
	}
	UI:addChild(MusicPlayerPanel, MusicPlayerText)
	
	-- Количество музыки
	MusicPlayerCountText = UI:createDpLabel {
		x = 20,
		y = UI:getHeight(MusicPlayerPanel) / 1.5,
		width = 0,
		height = 0,
		text = "Available tracks:",
		alignY = "center",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		alignX = "left",
		fontType = "lightVerySmall"
	}
	UI:addChild(MusicPlayerPanel, MusicPlayerCountText)
	
	-- Кнопка музыки
	MusicButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(MusicPlayerPanel) - 60,
        y       = UI:getHeight(MusicPlayerPanel) / 4,
        width   = 40,
        height  = 40,
		radius = 15,
		color = tocolor(215, 215, 215),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		circle = true,
		shadow = true
	}
	UI:addChild(MusicPlayerPanel, MusicButton)
	
	-- Кнопка настроек
	SettingsButton = UI:createTrcRoundedRectangle {
		x       = UI:getX(MusicPlayerPanel) + 323,
        y       = 338,
        width   = width * 0.07,
        height  = height * 0.12,
		radius = 15,
		color = tocolor(235, 235, 235),
		hover = true,
		hoverColor = tocolor(202, 202, 202),
		darkToggle = true,
		darkColor = tocolor(22, 22, 22),
		hoverDarkColor = tocolor(42, 42, 42)
	}
	UI:addChild(panel, SettingsButton)
	
	SettingsButtonImage = UI:createImage {
	x = UI:getWidth(SettingsButton) / 2 - 25,
	y = 10,
	width = 50,
	height = 50,
	texture = settings_icon,
	color = tocolor(20, 20, 20),
	darkToggle = true,
	darkColor = tocolor(235, 235, 235)
	}
	UI:addChild(SettingsButton, SettingsButtonImage)
	
	-- Текст настроек
	local SettingsButtonText = UI:createDpLabel {
		x = 45,
		y = UI:getHeight(SettingsButton) - 20,
		width = 0,
		height = 0,
		text = "Settings",
		locale = "overallpanel_settings_label",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		alignX = "center",
		fontType = "lightVerySmall"
	}
	UI:addChild(SettingsButton, SettingsButtonText)
	
	-- Кнопка помощь
	HelpButton = UI:createTrcRoundedRectangle {
		x       = UI:getX(MusicPlayerPanel) + 478,
        y       = 338,
        width   = width * 0.07,
        height  = height * 0.12,
		radius = 15,
		color = tocolor(235, 235, 235),
		hover = true,
		hoverColor = tocolor(202, 202, 202),
		darkToggle = true,
		darkColor = tocolor(22, 22, 22),
		hoverDarkColor = tocolor(42, 42, 42)
	}
	UI:addChild(panel, HelpButton)
	
	HelpButtonImage = UI:createImage {
	x = UI:getWidth(HelpButton) / 2 - 25,
	y = 10,
	width = 50,
	height = 50,
	texture = help_icon,
	color = tocolor(20, 20, 20),
	darkToggle = true,
	darkColor = tocolor(235, 235, 235)
	}
	UI:addChild(HelpButton, HelpButtonImage)
	
	-- Текст помощь
	local HelpButtonText = UI:createDpLabel {
		x = 45,
		y = UI:getHeight(HelpButton) - 20,
		width = 0,
		height = 0,
		text = "Help",
		locale = "overallpanel_help_label",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		alignX = "center",
		fontType = "lightVerySmall"
	}
	UI:addChild(HelpButton, HelpButtonText)
	
	-- Панель Гаража
	GaragePanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(MusicPlayerPanel) + 100,
        y       = 0,
        width   = width * 0.19,
        height  = height * 0.3,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(22, 22, 22),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(MusicPlayerPanel, GaragePanel)
	
	-- "Картинка" на панели гаража
	GarageImage = UI:createImage {
	x = 27,
	y = 20,
	width   = width * 0.15,
    height  = height * 0.18,
	texture = garage_button_img,	
	}
	UI:addChild(GaragePanel, GarageImage)
	
	-- Текст панели гаража
	GarageButtonText = UI:createDpLabel {
		x = UI:getWidth(GaragePanel) / 2,
		y = UI:getHeight(GaragePanel) * 0.8 - 15,
		width = 0,
		height = 0,
		text = "Teleports",
		locale = "overallpanel_garage_label",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		fontType = "lightLarge"
	}
	UI:addChild(GaragePanel, GarageButtonText)
	
	-- Текст панели гаража
	GarageButtonCarsText = UI:createDpLabel {
		x = 0,
		y = 25,
		width = 0,
		height = 0,
		text = "Cars in garage:0",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		alignX = "center",
		fontType = "lightSmall"
	}
	UI:addChild(GarageButtonText, GarageButtonCarsText)
	UIDataBinder.bind(GarageButtonCarsText, "garage_cars_count", function (value)
		if not value then
			value = 0
		end
		return exports.tunrc_Lang:getString("garage_cars_count") .. ": " .. tostring(value)
	end)
	
	-- Панель достижений игрока
	local AchievmentsFeaturesPanel = UI:createTrcRoundedRectangle {
		x       = 0,
        y       = UI:getHeight(featuresTeleportsPanel) + 35,
        width   = width * 0.19,
        height  = height * 0.3,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(22, 22, 22),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		hoverDarkColor = tocolor(30, 30, 30)
	}
	UI:addChild(featuresTeleportsPanel, AchievmentsFeaturesPanel)
	
	-- Текст панели достижений
	AchievmentsFeaturesText = UI:createDpLabel {
		x = UI:getWidth(AchievmentsFeaturesPanel) / 2,
		y = UI:getHeight(AchievmentsFeaturesPanel) * 0.8 - 15,
		width = 0,
		height = 0,
		text = "Achiv",
		locale = "overallpanel_achievments_label",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		fontType = "lightLarge"
	}
	UI:addChild(AchievmentsFeaturesPanel, AchievmentsFeaturesText)
	
	-- Текст панели достижений нижний
	AchievmentsFeaturesButtomText = UI:createDpLabel {
		x = 0,
		y = 25,
		width = 0,
		height = 0,
		text = "Coming soon...",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		alignX = "center",
		fontType = "lightSmall"
	}
	UI:addChild(AchievmentsFeaturesText, AchievmentsFeaturesButtomText)
	
	-- фон кружка с опытом
	xpInfoCircleBack = UI:createNonCircle {
		x       = UI:getWidth(AchievmentsFeaturesPanel) + 220,
        y       = 120,
		radius = (UI:getWidth(AchievmentsFeaturesPanel) / 2) - 10,
		startangle = 0,
		endangle = 360,
		color = tocolor (235,235,235),
		darkToggle = true,
		darkColor = tocolor(30, 30, 30),
	}
	UI:addChild(AchievmentsFeaturesPanel, xpInfoCircleBack)
	
	-- полоска кружка с опытом
	xpInfoCircle = UI:createNonCircle {
		x       = 0,
        y       = 0,
		radius = (UI:getWidth(AchievmentsFeaturesPanel) / 2) - 2,
		startangle = 0,
		endangle = 360,
		color = tocolor(130, 130, 200)
	}
	UI:addChild(xpInfoCircleBack, xpInfoCircle)
	
	-- Тень "Крышки" кружка с опытом
	local xpInfoCircleTopShadow = UI:createNonCircle {
		x       = 0,
        y       = 0,
		radius = (UI:getWidth(AchievmentsFeaturesPanel) / 2) - 20,
		startangle = 0,
		endangle = 360,
		color = tocolor(20, 20, 20, 20)
	}
	UI:addChild(xpInfoCircle, xpInfoCircleTopShadow)
	
	--"Крышка" кружка с опытом
	local xpInfoCircleTop = UI:createNonCircle {
		x       = 0,
        y       = 0,
		radius = (UI:getWidth(AchievmentsFeaturesPanel) / 2) - 25,
		startangle = 0,
		endangle = 360,
		color = tocolor (245,245,245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20),
	}
	UI:addChild(xpInfoCircle, xpInfoCircleTop)
	
	-- нынешний уровень игрока
	local xpInfoLevel = UI:createDpLabel {
		x = 0,
		y = -50,
		width = 0,
		height = 0,
		text = "1",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center",
		fontType = "lightBigBoy"
	}
	UI:addChild(xpInfoCircleTop, xpInfoLevel)
	UIDataBinder.bind(xpInfoLevel, "level", function (value)
	 return tostring(value)
	end)
	
	-- Инфо сколько опыта сейчас/осталось
	xpInfoCurrentNext = UI:createDpLabel {
		x = 0,
		y = 15,
		width = 0,
		height = 0,
		text = "1",
		color = tocolor(50, 50, 50, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "light",
		alignX = "center",
		alignY = "center",
		locale = "overallpanel_account_level"
	}
	UI:addChild(xpInfoCircleTop, xpInfoCurrentNext)
	
	-- Надпись "Уровень"
	xpInfoLabel	= UI:createDpLabel {
		x = 0,
		y = 60,
		width = 0,
		height = 0,
		text = "1",
		alignX = "center",
		color = tocolor(50, 50, 50, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "light",
		locale = "overallpanel_account_level"
	}
	UI:addChild(xpInfoCircleTop, xpInfoLabel)
	
	-- Панель количества денег игрока
	local MoneyPanel = UI:createTrcRoundedRectangle {
		x       = UI:getX(xpInfoCircleBack) + 225,
        y       = 0,
        width   = width * 0.19,
        height  = height * 0.3,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(22, 22, 22)
	}
	UI:addChild(AchievmentsFeaturesPanel, MoneyPanel)
	
	-- Надпись "Валюта"
	local DonatMoneyLabel = UI:createDpLabel {
		x = UI:getWidth(MoneyPanel) / 2,
		y = 20,
		width = 0,
		height = 0,
		text = "Money",
		locale = "overallpanel_money_label",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "light"
	}
	UI:addChild(MoneyPanel, DonatMoneyLabel)
	
	-- Количество донат-валюты игрока
	local DonatMoneyLabel = UI:createDpLabel {
		x = UI:getWidth(MoneyPanel) / 2,
		y = UI:getHeight(MoneyPanel) / 3,
		width = 0,
		height = 0,
		text = "1",
		alignX = "center",
		alignY = "center",
		color = tocolor (40, 40, 40),
		darkToggle = true,
		darkColor = tocolor(155, 155, 155),
		fontType = "lightLarger"
	}
	UI:addChild(MoneyPanel, DonatMoneyLabel)
	UIDataBinder.bind(DonatMoneyLabel, "donatmoney", function (value)
	 return "¤ " .. tostring(value)
	end)
	
	-- Количество денег игрока
	local MoneyLabel = UI:createDpLabel {
		x = UI:getWidth(MoneyPanel) / 2,
		y = UI:getHeight(MoneyPanel) / 2,
		width = 0,
		height = 0,
		text = "1",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "lightBigBoy"
	}
	UI:addChild(MoneyPanel, MoneyLabel)
	UIDataBinder.bind(MoneyLabel, "money", function (value)
	 return "$ " .. tostring(value)
	end)
	
	-- Подпись ко всему заработку дрифтом
	local MoneyTextEarnedLabel = UI:createDpLabel {
		x = UI:getWidth(MoneyPanel) / 2,
		y = UI:getHeight(MoneyPanel) / 1.3,
		width = 0,
		height = 0,
		text = "1",
		locale = "overallpanel_all_earned_label",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "lightSmall"
	}
	UI:addChild(MoneyPanel, MoneyTextEarnedLabel)
	
	-- Весь заработок дрифтом
	local MoneyEarnedLabel = UI:createDpLabel {
		x = UI:getWidth(MoneyPanel) / 2,
		y = UI:getHeight(MoneyPanel) / 1.1,
		width = 0,
		height = 0,
		text = "1",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "light"
	}
	UI:addChild(MoneyPanel, MoneyEarnedLabel)
	UIDataBinder.bind(MoneyEarnedLabel, "drift_points", function (value)
	 return "$ " .. string.format ("%u", tostring(value) * (500 / 100000))
	end)
end

function Panel.refresh()
	local level = localPlayer:getData("level")
	if not level then
		return
	end
	local xp = localPlayer:getData("xp")
	if not xp then
		return
	end

	local maxLevel = exports.tunrc_Core:getMaxLevel()
	local xp1 = exports.tunrc_Core:getXPFromLevel(level)
	local xp2 = exports.tunrc_Core:getXPFromLevel(level + 1)
	local nextLevelXp = xp2 - xp1
	local currentXp = xp - xp1

	local progress = currentXp / nextLevelXp
	if level >= maxLevel then
		progress = 1
	end
	
	local endAngle = UI:getEndangle(xpInfoCircleBack)
	UI:setEndangle(xpInfoCircle, endAngle * progress)
	
	local mapPlayers = 0
	
	for i,v in ipairs(getElementsByType("player")) do
	    if getElementData(v, "activeMap") then
            mapPlayers = i
	    end
	end
	
	UI:setText(TeleportsButtonPlayersText, ("%s: %s"):format(exports.tunrc_lang:getString("overallpanel_teleports_map_players"), mapPlayers))	
	
	
	if level >= maxLevel then
		UI:setVisible(xpInfoCurrentNext, false)
	else
		UI:setText(xpInfoCurrentNext, ("%s/%s"):format(exports.tunrc_Utils:format_num(currentXp, 0), exports.tunrc_Utils:format_num(nextLevelXp, 0)))
		UI:setVisible(xpInfoCurrentNext, true)
	end
	
	if exports.tunrc_Lang:getLanguage() == "english" then
		UI:setText(MusicPlayerCountText, "Tracks: " .. exports.tunrc_WorldMusic:getWorldMusicCount())
	else
		UI:setText(MusicPlayerCountText, "Композиций: " .. exports.tunrc_WorldMusic:getWorldMusicCount())
	end
	
	UIDataBinder.refresh()
end

function Panel.setVisible(visible)
    visible = not not visible
    if UI:getVisible(panel) == visible then
        return
    end
    if not panel then
        return false
    end
    if visible then
        if not localPlayer:getData("username") or localPlayer:getData("tunrc_Core.state") then
            return false
        end
        if localPlayer:getData("activeUI") then
            return false
        end
        localPlayer:setData("activeUI", "overallPanel")
		localPlayer:setData("activeUIAddition", false)
		exports.tunrc_Sounds:playSound("ui_swipe.wav")
    else
        localPlayer:setData("activeUI", false)
    end

	exports.tunrc_UI:fadeScreen(visible)
	exports.tunrc_HUD:setRadarVisible(not visible)
	exports.tunrc_Chat:setVisible((exports.tunrc_Config:getProperty("ui.draw_chat")))
	exports.tunrc_HUD:setSpeedometerVisible(exports.tunrc_Config:getProperty("ui.draw_speedo"))
	
	
    UI:setVisible(panel, visible)
	showCursor(visible)
	Panel.refresh()
    UIDataBinder.setActive(visible)
end

function Panel.isVisible()
    return UI:getVisible(panel)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	local playChange = false
	local playBack = false
	local playSelect = false
	local playError = false

    if widget == UserPanel then
		if localPlayer:getData("activeUIAddition") ~= "AccountPanel" then
			playClickSound = true
			AccountPanel.show()
			playSelect = true
		else
			playClickSound = true
			AccountPanel.hide()
			playBack = true
		end
	elseif widget == giftPanelButton then
		Panel.setVisible(false)
		exports.tunrc_GiftsPanel:setVisible(true)
		playSelect = true
	elseif widget == sellVehicleButton then
        if localPlayer.vehicle and localPlayer.vehicle:getData("owner_id") == localPlayer:getData("_id") and localPlayer:getData("garage_cars_count") > 1 then
			Panel.setVisible(false)
            exports.tunrc_SellVehicle:start()
			playSelect = true
        else
			playError = true
		end
	elseif widget == featuresTeleportsPanel or widget == TeleportsImage then
		Panel.setVisible(false)
		TeleportsPanel.show()
		playSelect = true
	elseif widget == ChangeThemebutton then
		if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
			exports.tunrc_Config:setProperty("ui.dark_mode", false)
		else
			exports.tunrc_Config:setProperty("ui.dark_mode", true)
		end
		Panel.refresh()
		playChange = true
	elseif widget == ChangeLanguageLabel then
		if exports.tunrc_Lang:getLanguage() == "english" then
			exports.tunrc_Lang:setLanguage("russian")
		else
			exports.tunrc_Lang:setLanguage("english")
		end
		Panel.refresh()
		playChange = true
	elseif widget == GaragePanel or widget == GarageImage then
		exports.tunrc_Garage:enterGarage()
		localPlayer:setData("tunrc_Core.state", "loading_garage", false)
		Panel.setVisible(false)
		playSelect = true
	elseif widget == HelpButton or widget == HelpButtonImage then
		Panel.setVisible(false)
		exports.tunrc_HelpPanel:setVisible(true)
		playSelect = true
	elseif widget == SettingsButton or widget == SettingsButtonImage then
		Panel.setVisible(false)
		SettingsPanel.show()
		playSelect = true
	elseif widget == MusicButton then
		Panel.setVisible(false)
		exports.tunrc_WorldMusic:setVisible(true)
		playSelect = true
	end
	
	
	if widget == Closebutton then
		Panel.setVisible(false)
		playBack = true
	end
	
	if playChange then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
	
	if playBack then
        exports.tunrc_Sounds:playSound("ui_back.wav")
    end
	
	if playSelect then
        exports.tunrc_Sounds:playSound("ui_select.wav")
    end
	
	if playError then
        exports.tunrc_Sounds:playSound("error.wav")
    end
end)