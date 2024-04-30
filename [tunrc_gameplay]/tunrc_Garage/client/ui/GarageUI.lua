GarageUI = {}
local screenWidth, screenHeight = guiGetScreenSize()
local screenSize = Vector2()
local renderTarget
local shadowTexture
local screenManager
local isVisible = true
local helpText = "..."
local width = 140
local height = 90

local HELP_TEXT_BOTTOM_OFFSET = 30

local function draw()
	if not isVisible then
		return
	end
	if screenManager then
		screenManager:draw()

		if screenManager.activeScreen then

			dxDrawRoundedRectangle(
				screenSize.x - width - 20,
				10,
				width,
				height,
				15,
				255,
				false,
				false,
				true,
				false
			)

			-- Деньги игрока
			TrcDrawText(
				"$" .. tostring(localPlayer:getData("money")),
				0,
				20,
				screenWidth - 30,
				screenHeight,
				255,
				Assets.fonts.moneyText,
				"right",
				"top"
			)
			
			TrcDrawText(
				"☆" .. tostring(localPlayer:getData("level")),
				0,
				60,
				screenWidth - 30,
				screenHeight,
				255,
				Assets.fonts.levelText,
				"right",
				"top"
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