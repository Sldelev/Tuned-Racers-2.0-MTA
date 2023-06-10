LobbyScreen = {}
LobbyScreen.isVisible = false
LobbyScreen.mapName = ""

local screenSize = Vector2(guiGetScreenSize())
local fonts = {}

local themeColor = {255, 255, 255}
local themeColorHEX = ""

local titleText = ""
local titleWidth = 0
local titleHeight = 0

local buttonText = ""
local buttonWidth = 220
local buttonHeight = 60

local buttonEnabled = false
local buttonMessage = ""

local infoFields = {
    { name = "", locale ="lobby_screen_field_players", value = "0"},
}

addEvent("tunrc_RaceLobby.countPlayers", true)

local function draw()
    local mx, my = getCursorPosition()
    if not mx then
        mx, my = 0, 0
    end
    mx, my = mx * screenSize.x, my * screenSize.y

    local x = math.max(screenSize.x * 0.2, screenSize.x / 2 - titleWidth * 0.75)
    local y = screenSize.y * 0.2
    dxDrawText(
        titleText,
        x,
        y,
        x,
        y,
        tocolor(255, 255, 255),
        1,
        fonts.title,
        "left",
        "top",
        false,
        false,
        true,
        true)

    y = y + titleHeight * 1.1

    dxDrawText(
        exports.tunrc_Lang:getString("race_lobby_text"),
        x,
        y,
        x,
        y,
        tocolor(255, 255, 255),
        1,
        fonts.info,
        "left",
        "top",
        false,
        false,
        true,
        true)

    y = y + 90   

    for i, field in ipairs(infoFields) do
        dxDrawText(
            field.name .. ": " .. themeColorHEX .. field.value,
            x,
            y,
            x,
            y,
            tocolor(255, 255, 255),
            1,
            fonts.info,
            "left",
            "top",
            false,
            false,
            true,
            true)

        y = y + 50
    end
    y = y + 20
    local buttonAlpha = 200
    local buttonColor = tocolor(255, 255, 255)
    if buttonEnabled then
        if mx >= x and my >=y and mx <= x + buttonWidth and my <= y + buttonHeight then
            buttonAlpha = 255

            if getKeyState("mouse1") then
                local mapName = LobbyScreen.mapName
                LobbyScreen.setVisible(false)
                SearchScreen.startSearch(mapName, infoFields[1].value)
                exports.tunrc_Sounds:playSound("ui_change.wav")
            end
        end
        buttonColor = tocolor(themeColor[1], themeColor[2], themeColor[3], buttonAlpha)
    else
        buttonColor = tocolor(40, 42, 41)
        dxDrawText(
            buttonMessage,
            x,
            y + buttonHeight,
            x + buttonWidth,
            y + buttonHeight * 1.8,
            tocolor(255, 255, 255),
            1,
            fonts.buttonMessage,
            "left",
            "bottom",
            false,
            false,
            true,
            true)
    end
    dxDrawRectangle(x, y, buttonWidth, buttonHeight, buttonColor, true)
    dxDrawText(
        buttonText,
        x,
        y,
        x + buttonWidth,
        y + buttonHeight,
        tocolor(255, 255, 255, buttonAlpha),
        1,
        fonts.button,
        "center",
        "center",
        false,
        false,
        true,
        true)
end

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
    outputDebugString("Toggle: " .. mapName)
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
        local mapGamemode = mapInfo.gamemode
        if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
            exports.tunrc_UI:showMessageBox(
                exports.tunrc_Lang:getString("race_error_title"), 
                exports.tunrc_Lang:getString("race_error_no_vehicle"))
            LobbyScreen.isVisible = false
            return
        end
        localPlayer:setData("activeUI", "lobbyScreen")
        addEventHandler("onClientRender", root, draw)
        addEventHandler("onClientVehicleExit", localPlayer.vehicle, onVehicleExit)
        addEventHandler("tunrc_RaceLobby.countPlayers", resourceRoot, updateCounter)
        fonts.title = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 52)
        fonts.info = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 21)
        fonts.button = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 22)
        fonts.buttonMessage = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 16)

        themeColor = {exports.tunrc_UI:getThemeColor()}
        themeColorHEX = exports.tunrc_Utils:RGBToHex(exports.tunrc_UI:getThemeColor())

        titleText =
            exports.tunrc_Lang:getString("lobby_screen_field_title") ..
            ": " .. themeColorHEX ..
            exports.tunrc_Lang:getString("race_type_" .. mapGamemode)

        titleWidth = dxGetTextWidth(titleText, 1, fonts.title, true)
        titleHeight = dxGetFontHeight(1, fonts.title)

        buttonText = exports.tunrc_Lang:getString("lobby_screen_enter_button")

        for i, field in ipairs(infoFields) do
            field.name = exports.tunrc_Lang:getString(field.locale)
        end

        bindKey("backspace", "down", LobbyScreen.toggle)

        buttonMessage = ""
        buttonEnabled = true

        if mapGamemode == "drift" then
            local handlingLevel = localPlayer.vehicle:getData("DriftHandling") 
            if not handlingLevel or handlingLevel < 1 then
                buttonMessage = exports.tunrc_Lang:getString("handling_switching_message_no_upgrade")
                buttonEnabled = false
            end
        end

        infoFields[1].value = "0"

        triggerServerEvent("tunrc_RaceLobby.countPlayers", resourceRoot, LobbyScreen.mapName)
    else
        localPlayer:setData("activeUI", false)
        for font in pairs(fonts) do
            if isElement(font) then
                destroyElement(font)
            end
        end
        removeEventHandler("onClientRender", root, draw)
        removeEventHandler("onClientVehicleExit", localPlayer.vehicle, onVehicleExit)
        removeEventHandler("tunrc_RaceLobby.countPlayers", resourceRoot, updateCounter)
        LobbyScreen.mapName = nil
        unbindKey("backspace", "down", LobbyScreen.toggle)
    end

    exports.tunrc_HUD:setVisible(not LobbyScreen.isVisible)
	exports.tunrc_HUD:setSpeedometerVisible(exports.tunrc_Config:getProperty("ui.draw_speedo"))
    exports.tunrc_UI:fadeScreen(LobbyScreen.isVisible)
    showCursor(LobbyScreen.isVisible)
end