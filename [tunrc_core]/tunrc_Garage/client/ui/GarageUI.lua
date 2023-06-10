GarageUI = {}
local screenWidth, screenHeight = guiGetScreenSize()
local screenSize = Vector2()
local renderTarget
local shadowTexture
local screenManager
local isVisible = true
local helpText = "..."

local HELP_TEXT_BOTTOM_OFFSET = 30

local function drawHelpText()
	local fadeProgress = screenManager.activeScreen.fadeProgress
	dxDrawText(
		exports.tunrc_Utils:removeHexFromString(helpText),
		2, 2,
		screenSize.x + 2,
		screenSize.y - HELP_TEXT_BOTTOM_OFFSET + 2,
		tocolor(0, 0, 0, 150 * fadeProgress),
		1,
		Assets.fonts.helpText,
		"center",
		"bottom", false, false, false, true, true
	)
	dxDrawText(
		helpText,
		0, 0,
		screenSize.x,
		screenSize.y - HELP_TEXT_BOTTOM_OFFSET,
		tocolor(255, 255, 255, 255 * fadeProgress),
		1,
		Assets.fonts.helpText,
		"center",
		"bottom", false, false, false, true, true
	)
end

local function draw()
	if not isVisible then
		return
	end
	if screenManager then
		screenManager:draw()

		if screenManager.activeScreen then
			-- Виньетка
			dxDrawImage(0, 0, screenWidth, screenHeight, shadowTexture, 0, 0, 0, tocolor(0, 0, 0, 200))
			-- Текст помощи
			drawHelpText()

			-- Деньги игрока
			local primaryColor = tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], 255)
			dxDrawText(
				"$#FFFFFF" .. tostring(localPlayer:getData("money")),
				0, 20,
				screenSize.x - 20, screenSize.y,
				primaryColor,
				1,
				Assets.fonts.moneyText,
				"right",
				"top",
				false, false, false, true
			)
		end
	end
end

local function update(deltaTime)
	if not isVisible then
		return
	end
	if screenManager then
		deltaTime = deltaTime / 1000
		screenManager:update(deltaTime)
	end
end

local function onKey(button, isDown)
	if not isDown or --[[CameraManager.isMouseLookEnabled() or]] isMTAWindowActive() then
		return
	end
	if exports.tunrc_TutorialMessage:isMessageVisible() then
		return
	end
	if screenManager then
		screenManager:onKey(button)
		if button == "enter" then
			exports.tunrc_Sounds:playSound("ui_select.wav")
		elseif button == "backspace" then
			exports.tunrc_Sounds:playSound("ui_back.wav")
		elseif string.find(button, "arrow") then
			exports.tunrc_Sounds:playSound("ui_change.wav")
		end
	end
end

function GarageUI.start()
	isVisible = true
	screenSize = Vector2(exports.tunrc_UI:getScreenSize())
	renderTarget = exports.tunrc_UI:getRenderTarget()

	shadowTexture = exports.tunrc_Assets:createTexture("screen_shadow.png")
	GarageUI.resetHelpText()
	-- Создание менеджера экранов
	screenManager = ScreenManager()
	-- Переход на начальный экран
	local screen = MainScreen()
	screenManager:showScreen(screen)
	exports.tunrc_UI:forceRotation(0.5, 0.5)
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientKey", root, onKey)

	if localPlayer:getData("tutorialActive") then
		setTimer(function ()
		exports.tunrc_TutorialMessage:showMessage(
			exports.tunrc_Lang:getString("tutorial_garage_title"),
			exports.tunrc_Lang:getString("tutorial_garage_text"),
			utf8.lower(exports.tunrc_Lang:getString("player_level")))
		end, 1000, 1)
	end
end

function GarageUI.stop()
	screenManager:destroy()
	screenManager = nil

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientKey", root, onKey)
	if isElement(shadowTexture) then
		destroyElement(shadowTexture)
	end
end

function GarageUI.showSaving()

end

function GarageUI.setVisible(visible)
	isVisible = not not visible
end

function GarageUI.setHelpText(text)
	helpText = text
end

function GarageUI.setHelpControls(controls)
	local primaryColor = exports.tunrc_Utils:RGBToHex(unpack(Garage.themePrimaryColor))
	helpText = ""
	for i, control in pairs(controls) do
		helpText = helpText .. ("%s%s#FFFFFF %s"):format(primaryColor, control.control, control.action)
		if i ~= #controls then
			helpText = helpText .. "   "
		end
	end
end

function GarageUI.resetHelpText()
	GarageUI.setHelpControls({
		{control = exports.tunrc_Lang:getString("controls_arrows"), action = exports.tunrc_Lang:getString("garage_help_move_selection")},
		{control = exports.tunrc_Lang:getString("controls_enter"), action = exports.tunrc_Lang:getString("garage_help_select")},
		{control = exports.tunrc_Lang:getString("controls_backspace"), action = exports.tunrc_Lang:getString("garage_help_back")},
		{control = exports.tunrc_Lang:getString("controls_mouse"), action = exports.tunrc_Lang:getString("garage_help_move_camera")},
	})
end