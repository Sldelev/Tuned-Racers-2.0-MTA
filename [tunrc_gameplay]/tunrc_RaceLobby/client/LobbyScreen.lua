LobbyScreen = {}
LobbyScreen.isVisible = false
LobbyScreen.mapName = ""

local screenSize = Vector2(guiGetScreenSize())
local fonts = {}
local UI = exports.tunrc_UI
local ui = {}

local panelWidth = 400
local panelHeight = 250
local BUTTON_HEIGHT = 50

local infoFields = {
    { name = "", locale ="lobby_screen_field_players", value = "0"},
}

addEvent("tunrc_RaceLobby.countPlayers", true)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	screenSize = Vector2(exports.tunrc_UI:getScreenSize())	
	ui.panel = UI:createTrcRoundedRectangle {
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight) / 1.7,
		width = panelWidth,
		height = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(ui.panel)

	-- Кнопка "Отмена"
	
	ui.cancelButton = UI:createTrcRoundedRectangle {
		x       = 15,
        y       = panelHeight - BUTTON_HEIGHT - 15,
        width   = 150,
        height  = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "race_lobby_close_button"
	}
	UI:addChild(ui.panel, ui.cancelButton)

	-- Кнопка "Принять"	
	ui.acceptButton = UI:createTrcRoundedRectangle {
		x = UI:getWidth(ui.panel) - 150 - 15,
        y       = panelHeight - BUTTON_HEIGHT - 15,
        width   = 150,
        height  = BUTTON_HEIGHT,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "race_lobby_play_button"
	}
	UI:addChild(ui.panel, ui.acceptButton)

	local labelOffset = 0.45
	ui.mainLabel = UI:createDpLabel({
		x = 0 , y = 0,
		width = panelWidth, height = panelHeight * labelOffset,
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarge",
		text = "...",
		alignX = "center",
		alignY = "bottom"
	})
	UI:addChild(ui.panel, ui.mainLabel)

	ui.infoLabel = UI:createDpLabel({
		x = 0 , y = panelHeight * labelOffset,
		width = panelWidth, height = panelHeight * labelOffset - BUTTON_HEIGHT,
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultSmall",
		text = "...",
		color = tocolor(0, 0, 0, 100),
		alignX = "center",
		alignY = "top"
	})
	UI:addChild(ui.panel, ui.infoLabel)	

	UI:setVisible(ui.panel, false)
end)

local function onVehicleExit(player)
    if player == localPlayer then
        return
    end
end

local function updateCounter(count)
    infoFields[1].value = tostring(count)
end

function LobbyScreen.toggle(mapName)
    if not LobbyScreen.isVisible then
        LobbyScreen.mapName = mapName
    end
    LobbyScreen.setVisible(not LobbyScreen.isVisible)
end

function LobbyScreen.setVisible(visible)
    visible = not not visible
    if LobbyScreen.isVisible == visible then
        return 
    end
    LobbyScreen.isVisible = visible
    if LobbyScreen.isVisible then
        FinishScreen.clearPlayers()
        local mapInfo = exports.tunrc_RaceManager:getMapInfo(LobbyScreen.mapName) or {}
		local raceName = mapInfo.name
        if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
            exports.tunrc_UI:showMessageBox(
                exports.tunrc_Lang:getString("race_error_title"), 
                exports.tunrc_Lang:getString("race_error_no_vehicle"))
            LobbyScreen.isVisible = false
            return
        end
        localPlayer:setData("activeUI", "lobbyScreen")
		
		UI:setText(ui.mainLabel, exports.tunrc_Lang:getString("lobby_screen_field_title") .. ": " .. exports.tunrc_Lang:getString(raceName))
		
		if localPlayer:getData("tutorialActive") then
			localPlayer:setData("tutorialActive", false)
			exports.tunrc_TutorialMessage:showMessage(
				exports.tunrc_Lang:getString("tutorial_race_title"),
				exports.tunrc_Lang:getString("tutorial_race_text"),
				"F1", "F9", "M", exports.tunrc_Lang:getString("tutorial_city_race"))
		end
		
        UI:setVisible(ui.panel, true)
        triggerServerEvent("tunrc_RaceLobby.countPlayers", resourceRoot, LobbyScreen.mapName)
    else
        localPlayer:setData("activeUI", false)
        UI:setVisible(ui.panel, false)
    end

    exports.tunrc_HUD:setVisible(not LobbyScreen.isVisible)
	exports.tunrc_HUD:setSpeedometerVisible(exports.tunrc_Config:getProperty("ui.draw_speedo"))
    exports.tunrc_UI:fadeScreen(LobbyScreen.isVisible)
    showCursor(LobbyScreen.isVisible)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == ui.cancelButton then
		LobbyScreen.setVisible(false)
	elseif widget == ui.acceptButton then
		local mapName = LobbyScreen.mapName
		LobbyScreen.setVisible(false)
        SearchScreen.startSearch(mapName, infoFields[1].value)
        exports.tunrc_Sounds:playSound("ui_change.wav")
	end
end)