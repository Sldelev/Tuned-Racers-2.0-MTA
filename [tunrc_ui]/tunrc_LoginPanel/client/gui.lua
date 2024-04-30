isAuthInProgress = false
local UI = exports.tunrc_UI
local HIDE_CHAT = false
local screenWidth, screenHeight = exports.tunrc_UI:getScreenSize()

local BACKGROUND_COLOR = {210, 210, 210}
local realSceenWidth, realScreenHeight = guiGetScreenSize()
local backgroundScale = realScreenHeight / 720
local backgroundWidth, backgroundHeight = 1280 * backgroundScale, 720 * backgroundScale
local animationProgress = 0
local ANIMATION_SPEED = 0.01
local loginPanel = {}
local registerPanel = {}

local LOGO_WIDTH = 300

local USERNAME_REGEXP = "^[A-Za-z0-9_]$"
local KEY_REGEXP = "^[A-Za-z0-9_]$"

local languageButtonsList = {
	{ name = "en", language = "english" },
	{ name = "ru", language = "russian" }
}

rx = 0
rx1 = 0

local function draw()
    rx1 = (rx1 - 0.5) % screenWidth
	rx = (rx + 0.5) % screenWidth
	animationProgress = math.min(1, animationProgress + ANIMATION_SPEED)
	if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
			dxDrawRectangle(0, 0, realSceenWidth, realScreenHeight, tocolor(40, 40 ,40 , 255 * animationProgress))
		else
			dxDrawRectangle(0, 0, realSceenWidth, realScreenHeight, tocolor(210, 210 ,210 , 255 * animationProgress))
		end
	dxDrawText("Tuned Racers", 3, screenHeight - 14, 3, screenHeight - 14, tocolor(255, 255, 255, 100 * animationProgress))
	if not root:getData("dbConnected") then
		dxDrawText("The server is currently not available.\nСервер на данный момент недоступен.",
			0,
			0,
			screenWidth,
			screenHeight * 0.5, tocolor(212, 0, 40, 220 * animationProgress), 2, "default", "center", "center"
		)

		local buttonSize = Vector2(200, 40)
		local buttonPos = Vector2(screenWidth - buttonSize.x, screenHeight - buttonSize.y) / 2
		local buttonAlpha = 200
		local buttonColor = tocolor(212, 0, 40, buttonAlpha)
		local mousePos = Vector2(getCursorPosition())
		mousePos.x = mousePos.x * screenWidth
		mousePos.y = mousePos.y * screenHeight
		if 	mousePos.x >= buttonPos.x and mousePos.x <= buttonPos.x + buttonSize.x and
			mousePos.y >= buttonPos.y and mousePos.y <= buttonPos.y + buttonSize.y
		then
			buttonAlpha = 255
			buttonColor = tocolor(222, 10, 50, buttonAlpha)

			if getKeyState("mouse1") then
				triggerServerEvent("tunrc_Core.selfKick", root)
				setVisible(false)
			end
		end
		dxDrawRectangle(buttonPos, buttonSize, buttonColor)
		dxDrawText("Disconnect", buttonPos, buttonPos + buttonSize, tocolor(255, 255, 255, buttonAlpha), 1.7, "default", "center", "center")
	end
end

function gotoLoginPanel(username, password)
	UI:setVisible(loginPanel.panel, true)
	UI:setVisible(registerPanel.panel, false)
	if username and password then
		UI:setText(loginPanel.username, username)
		UI:setText(loginPanel.password, password)
	end
end

function clearRegisterForm()
	UI:setText(registerPanel.username, "")
	UI:setText(registerPanel.password, "")
	UI:setText(registerPanel.passwordConfirm, "")
end

function setVisible(visible)
	visible = not not visible
	if HIDE_CHAT then
		exports.tunrc_Chat:setVisible(not visible)
	end
	exports.tunrc_HUD:setVisible(false)

	UI:setVisible(loginPanel.panel, visible)
	UI:setVisible(registerPanel.panel, false)

	if visible then
		if not root:getData("dbConnected") then
			UI:setVisible(loginPanel.panel, false)
			exports.tunrc_UI:showMessageBox(
				exports.tunrc_Lang:getString("login_panel_server_error"),
				exports.tunrc_Lang:getString("login_panel_server_not_available")
			)
		end

		addEventHandler("onClientRender", root, draw)
		animationProgress = 0
		local fields = Autologin.load()
		if fields then
			UI:setText(loginPanel.username, fields.username)
			UI:setText(loginPanel.password, fields.password)
		end
	else
		if isElement(backgroundTexture) and isElement(stickTexture) then
			destroyElement(stickTexture)
		end
		removeEventHandler("onClientRender", root, draw)
	end
	showCursor(visible)
end

local function createLoginPanel()

	local panelWidth = 550
	local panelHeight = 300
	
	local panel = UI:createTrcRoundedRectangle {
		x       = (screenWidth - panelWidth) / 2,
        y       = (screenHeight - panelHeight) / 2,
        width   = panelWidth,
        height  = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(panel)


	local usernameInput = UI:createDpInput({
		x = 50,
		y = 50,
		width = 450,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	local passwordInput = UI:createDpInput({
		x = 50,
		y = 120,
		width = 450,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		placeholder = "Пароль",
		masked = true,
		locale = "login_panel_password_label"
	})
	UI:addChild(panel, passwordInput)
	
	-- Кнопка смены языка
	local ChangeLanguage = UI:createDpLabel {
		x = 50,
		y = 5,
		width = 30,
		height = 30,
		text = "EN",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarge"
	}
	UI:addChild(panel, ChangeLanguage)
	UIDataBinder.bind(ChangeLanguage, "language_button_text", function (value)
		if exports.tunrc_Lang:getLanguage() == "english" then
			return "EN"
		else
			return "RU"
		end
	end)
	
	-- Кнопка смены темы
	local ChangeTheme = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(usernameInput) + 20,
        y       = 10,
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
	UI:addChild(panel, ChangeTheme)
	
	local startGameButton = UI:createTrcRoundedRectangle {
		x       = 0,
        y       = 100,
        width   = 155,
        height  = 50,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "login_panel_start_game_button"
	}
	UI:addChild(passwordInput, startGameButton)
	
	local registerButton = UI:createTrcRoundedRectangle {
		x       = 295,
        y       = 0,
        width   = 155,
        height  = 50,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "login_panel_register_button_toggle"
	}
	UI:addChild(startGameButton, registerButton)

	UI:setVisible(panel, false)
	loginPanel.registerButton = registerButton
	loginPanel.startGameButton = startGameButton
	loginPanel.changeLanguage = ChangeLanguage
	loginPanel.changeTheme = ChangeTheme
	loginPanel.password = passwordInput
	loginPanel.username = usernameInput
	loginPanel.panel = panel
end

local function createRegisterPanel()
	local panelWidth = 550
	local panelHeight = 350

	local panel = UI:createTrcRoundedRectangle {
		x       = (screenWidth - panelWidth) / 2,
        y       = (screenHeight - panelHeight) / 2,
        width   = panelWidth,
        height  = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(panel)

	local y = 35
	local usernameInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	y = y + 70
	local passwordInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		masked = true,
		locale = "login_panel_password_label"
	})
	UI:addChild(panel, passwordInput)

	y = y + 70
	local passwordConfirmInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		masked = true,
		locale = "login_panel_password_confirm_label"
	})
	UI:addChild(panel, passwordConfirmInput)

	local backButton = UI:createTrcRoundedRectangle {
		x       = 0,
        y       = 100,
        width   = 155,
        height  = 50,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "login_panel_back"
	}
	UI:addChild(passwordConfirmInput, backButton)

	local registerButton = UI:createTrcRoundedRectangle {
		x       = 295,
        y       = 0,
        width   = 155,
        height  = 50,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "login_panel_register_button_toggle"
	}
	UI:addChild(backButton, registerButton)

	UI:setVisible(panel, false)
	registerPanel.panel = panel
	registerPanel.registerButton = registerButton
	registerPanel.backButton = backButton
	registerPanel.password = passwordInput
	registerPanel.passwordConfirm = passwordConfirmInput
	registerPanel.username = usernameInput
	registerPanel.betaKey = betaKeyInput
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	createLoginPanel()
	createRegisterPanel()
	
	if not localPlayer:getData("username") then
		fadeCamera(false, 0)
		setVisible(true)
	end
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function(widget)
	-- Переключение панелей
	if widget == loginPanel.registerButton then
		UI:setVisible(loginPanel.panel, false)
		UI:setVisible(registerPanel.panel, true)
		exports.tunrc_Sounds:playSound("ui_select.wav")
	elseif widget == registerPanel.backButton then
		UI:setVisible(loginPanel.panel, true)
		UI:setVisible(registerPanel.panel, false)
		exports.tunrc_Sounds:playSound("ui_back.wav")
	-- Кнопка входа
	elseif widget == loginPanel.startGameButton and not isAuthInProgress then
		exports.tunrc_Sounds:playSound("ui_select.wav")
		isAuthInProgress = true
		startGameClick(UI:getText(loginPanel.username), UI:getText(loginPanel.password))
	-- Кнопка регистрации
	elseif widget == registerPanel.registerButton and not isAuthInProgress then
		exports.tunrc_Sounds:playSound("ui_select.wav")
		isAuthInProgress = true
		registerClick(
			UI:getText(registerPanel.username),
			UI:getText(registerPanel.password),
			UI:getText(registerPanel.passwordConfirm)
			--UI:getText(registerPanel.betaKey)
		)
	elseif widget == loginPanel.changeTheme then
		if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
			exports.tunrc_Config:setProperty("ui.dark_mode", false)
		else
			exports.tunrc_Config:setProperty("ui.dark_mode", true)
		end
		playChange = true
	elseif widget == loginPanel.changeLanguage then
		if exports.tunrc_Lang:getLanguage() == "english" then
			exports.tunrc_Lang:setLanguage("russian")
		else
			exports.tunrc_Lang:setLanguage("english")
		end
		playChange = true
		UIDataBinder.refresh()
	end
end)

addEvent("tunrc_UI.inputEnter", false)
addEventHandler("tunrc_UI.inputEnter", resourceRoot, function(widget)
	if widget == loginPanel.username or widget == loginPanel.password then
		startGameClick(UI:getText(loginPanel.username), UI:getText(loginPanel.password))
	elseif widget == registerPanel.username or widget == registerPanel.password then
		registerClick(UI:getText(registerPanel.username), UI:getText(registerPanel.password))
	end
end)
