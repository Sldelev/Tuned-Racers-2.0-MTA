SearchScreen = {}
local screenSize = Vector2()
local UI = exports.tunrc_UI
local ui = {}

local panelWidth = 400
local panelHeight = 250

local BUTTON_HEIGHT = 50
local counterTimer
local secoundsCount = 0

local foundGame = false
local acceptedGame = false

local searchMapName

local function onGameFound()
	foundGame = true
	acceptedGame = false

	UI:setText(ui.mainLabel, exports.tunrc_Lang:getString("race_search_race_fount"))
	--UI:setText(ui.infoLabel, exports.tunrc_Lang:getString("race_search_press_accept"))
end
addEvent("tunrc_RaceLobby.raceFound", true)
addEventHandler("tunrc_RaceLobby.raceFound", resourceRoot, onGameFound)

local function updateTime()
	secoundsCount = secoundsCount + 1
	if foundGame then
		return
	end
	local minutesCount = math.floor(secoundsCount / 60)
	local time = secoundsCount % 60
	if time < 10 then
		time = "0" .. tostring(time)
	end
	if minutesCount < 10 then
		minutesCount = "0" .. tostring(minutesCount)
	end
	time = tostring(minutesCount) .. ":" .. time

	UI:setText(ui.acceptButton, exports.tunrc_Lang:getString("race_search_searching") .. " " .. time)
	UI:setType(ui.acceptButton, "default_dark")

	triggerServerEvent("tunrc_RaceLobby.countPlayers", resourceRoot, searchMapName)
end

local function updateCounter(count)
	UI:setText(ui.infoLabel, exports.tunrc_Lang:getString("race_search_players_in_search")  .. " " .. tostring(count))	
end

function SearchScreen.startSearch(mapName, count)
	if not localPlayer.vehicle then
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("race_error_title"), 
			exports.tunrc_Lang:getString("race_error_no_vehicle"))
		return false
	end
	local vehicleOwner = localPlayer.vehicle:getData("owner_id")
	local playerId = localPlayer:getData("_id")
	if not vehicleOwner or not playerId or vehicleOwner ~= playerId then
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("race_error_title"), 
			exports.tunrc_Lang:getString("race_error_not_owner"))
		return false
	end	
	SearchScreen.setVisible(true)
	triggerServerEvent("tunrc_RaceLobby.startSearch", resourceRoot, mapName)
	searchMapName = mapName
	updateCounter(count)
end

function SearchScreen.cancelSearch()
	SearchScreen.setVisible(false)
	triggerServerEvent("tunrc_RaceLobby.cancelSearch", resourceRoot)
end

function SearchScreen.setVisible(visible)
	local isVisible = UI:getVisible(ui.panel)
	if not not isVisible == not not visible then
		return false
	end 	

	UI:setVisible(ui.panel, visible)
	showCursor(visible)

	exports.tunrc_HUD:setVisible(not visible)
	exports.tunrc_HUD:setSpeedometerVisible(exports.tunrc_Config:getProperty("ui.draw_speedo"))
	exports.tunrc_UI:fadeScreen(visible)	

	foundGame = false
	acceptedGame = false

	if isTimer(counterTimer) then
		killTimer(counterTimer)
		counterTimer = nil
	end
	if visible then
		counterTimer = setTimer(updateTime, 1000, 0)
		secoundsCount = -1
		updateTime()

		UI:setText(ui.mainLabel, exports.tunrc_Lang:getString("race_search_searching_label"))	

		localPlayer:setData("activeUI", "SearchScreen")
		addEventHandler("tunrc_RaceLobby.countPlayers", resourceRoot, updateCounter)
	else
		localPlayer:setData("activeUI", false)
		removeEventHandler("tunrc_RaceLobby.countPlayers", resourceRoot, updateCounter)
	end
end

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
		locale = "race_search_cancel"
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
		locale = "race_search_accept"
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

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == ui.cancelButton then
		SearchScreen.cancelSearch()
	elseif widget == ui.acceptButton then
		if foundGame and not acceptedGame then
			acceptedGame = true
			triggerServerEvent("tunrc_RaceLobby.acceptRace", resourceRoot)

			UI:setType(ui.acceptButton, "default_dark")
			UI:setText(ui.acceptButton, exports.tunrc_Lang:getString("race_search_waiting_button"))	

			UI:setText(ui.mainLabel, exports.tunrc_Lang:getString("race_search_waiting_label"))
			UI:setText(ui.infoLabel, string.format(
				exports.tunrc_Lang:getString("race_search_players_ready_count"),
				"0", "0"
			))			

			FinishScreen.clearPlayers()
		end
	end
end)

addEvent("tunrc_RaceLobby.raceCancelled", true)
addEventHandler("tunrc_RaceLobby.raceCancelled", resourceRoot, function (player)
	if foundGame then
		SearchScreen.setVisible(false)
		SearchScreen.startSearch()
		if player ~= client then
			exports.tunrc_UI:showMessageBox(
				exports.tunrc_Lang:getString("race_search_reject_error_title"),
				exports.tunrc_Lang:getString("race_search_reject_error_body")
			)
		end
	end
end)

addEvent("tunrc_RaceLobby.updateReadyCount", true)
addEventHandler("tunrc_RaceLobby.updateReadyCount", resourceRoot, function (count, total)
	if not count or not total then
		return
	end
	if not foundGame or not acceptedGame then
		return
	end
	UI:setText(ui.infoLabel, string.format(
		exports.tunrc_Lang:getString("race_search_players_ready_count"),
		tostring(count), tostring(total)
	))		
end)

addEvent("tunrc_RaceLobby.raceStart", true)
addEventHandler("tunrc_RaceLobby.raceStart", resourceRoot, function ()
	SearchScreen.setVisible(false)
end)

function setVisible(visible)
	if visible then
		SearchScreen.startSearch()
	else
		SearchScreen.cancelSearch()
	end
end