isAuthInProgress = false
local UI = exports.tunrc_UI
local HIDE_CHAT = false
local screenWidth, screenHeight = exports.tunrc_UI:getScreenSize()

local BACKGROUND_COLOR = {13, 15, 17}
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
	dxDrawRectangle(0, 0, realSceenWidth, realScreenHeight, tocolor(BACKGROUND_COLOR[1], BACKGROUND_COLOR[2], BACKGROUND_COLOR[3], 255 * animationProgress))
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
		backgroundTexture = DxTexture("assets/background.png")
		stickTexture = DxTexture("assets/st.png")
	else
		if isElement(backgroundTexture) and isElement(stickTexture) then
			destroyElement(backgroundTexture)
			destroyElement(stickTexture)
		end
		removeEventHandler("onClientRender", root, draw)
	end
	showCursor(visible)
end

local function createLoginPanel()
	local logoTexture = exports.tunrc_Assets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoWidth = LOGO_WIDTH
	local logoHeight = textureHeight * LOGO_WIDTH / textureWidth

	local panelWidth = 750
	local panelHeight = 200
	local panel = UI:createDpPanel({
		x = (screenWidth - panelWidth) / 2,
		y = (screenHeight - panelHeight + logoHeight) / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(panel)

	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 25,
		width = logoWidth,
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(panel, logoImage)

	local startGameButton = UI:createDpButton({
		x = panelWidth / 1.4, y = 40,
		width = panelWidth / 4,
		height = 55,
		type = "default_dark",
		locale = "login_panel_start_game_button"
	})
	UI:addChild(panel, startGameButton)

	local registerButton = UI:createDpButton({
		x = panelWidth / 1.4, y = 110,
		width = panelWidth / 4,
		height = 55,
		type = "primary",
		locale = "login_panel_register_button_toggle"
	})
	UI:addChild(panel, registerButton)

	local usernameInput = UI:createDpInput({
		x = 50,
		y = 40,
		width = 450,
		height = 50,
		type = "dark",
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	local passwordInput = UI:createDpInput({
		x = 50,
		y = 110,
		width = 450,
		height = 50,
		type = "dark",
		placeholder = "Пароль",
		masked = true,
		locale = "login_panel_password_label"
	})
	UI:addChild(panel, passwordInput)

	UI:setVisible(panel, false)
	loginPanel.registerButton = registerButton
	loginPanel.startGameButton = startGameButton
	loginPanel.password = passwordInput
	loginPanel.username = usernameInput
	loginPanel.panel = panel
end

local function createRegisterPanel()
	local panelWidth = 550
	local panelHeight = 385

	local logoTexture = exports.tunrc_Assets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoScale = 1
	local logoWidth = LOGO_WIDTH * logoScale
	local logoHeight = textureHeight * LOGO_WIDTH / textureWidth * logoScale

	local totalPanelHeight = panelHeight - logoHeight + 25

	local panel = UI:createDpPanel({
		x = (screenWidth - panelWidth) / 2,
		y = screenHeight / 2 - totalPanelHeight / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(panel)

	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 25,
		width = logoWidth,
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(panel, logoImage)

	local languageLabelWidth = 118
	local languageLabel = UI:createDpLabel({
		x = 50,
		y = 40,
		width = languageLabelWidth,
		wordBreak = false,
		clip = true,
		height = 50,
		alignX = "left",
		alignY = "top",
		locale = "login_panel_language"
	})
	UI:addChild(panel, languageLabel)

	-- Кнопки языков
	local langX = 50 + languageLabelWidth + 7
	for i, languageButton in ipairs(languageButtonsList) do
		local button = UI:createDpImageButton({
			x = langX, y = 40,
			width = 27, height = 27,
			texture = exports.tunrc_Assets:createTexture("buttons/" .. tostring(languageButton.name) .. ".png")
		})
		UI:addChild(panel, button)
		languageButton.button = button
		langX = langX + 27 + 5
	end

	local y = 100
	local usernameInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		type = "dark",
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	y = y + 70
	local passwordInput = UI:createDpInput({
		x = 50,
		y = y,
		width = 450,
		height = 50,
		type = "dark",
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
		type = "dark",
		masked = true,
		locale = "login_panel_password_confirm_label"
	})
	UI:addChild(panel, passwordConfirmInput)

	local backButton = UI:createDpButton({
		x = 0,
		y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "default_dark",
		text = "Назад",
		locale = "login_panel_back"
	})
	UI:addChild(panel, backButton)

	local registerButton = UI:createDpButton({
		x = panelWidth / 2,
		y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		text = "Зарегистрироваться",
		locale = "login_panel_register_button"
	})
	UI:addChild(panel, registerButton)

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
	end
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function(widget)
	-- Переключение языка
	for i, languageButton in ipairs(languageButtonsList) do
		if languageButton.button and languageButton.button == widget then
			exports.tunrc_Sounds:playSound("ui_change.wav")
			exports.tunrc_Lang:setLanguage(languageButton.language)
		end
	end
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
