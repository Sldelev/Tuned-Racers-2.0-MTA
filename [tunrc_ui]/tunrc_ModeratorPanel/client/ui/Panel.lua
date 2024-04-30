Panel = {}
local UI = exports.tunrc_UI
local screenWidth, screenHeight = UI:getScreenSize()
local ui = {}

local panelWidth = 500
local panelHeight = 365

local isVisible = false

local playersList = {}
local playersListOffset = 0
local playersShowCount = 7
local selectedPlayer

function Panel.show()
	if isVisible or localPlayer:getData("activeUI") then
		return false
	end
	isVisible = true

	UI:setVisible(ui.panel, true)
	showCursor(true)

	UI:setText(ui.playerSearchInput, "")
	Panel.filterPlayersList()

	Panel.hidePlayerInfo()
	localPlayer:setData("activeUI", "moderatorPanel")
	exports.tunrc_UI:fadeScreen(true)
end

function Panel.filterPlayersList()
	local searchText = utf8.lower(UI:getText(ui.playerSearchInput))
	playersList = {}
	for i, player in ipairs(getElementsByType("player")) do
		if string.find(utf8.lower(player.name), searchText, 1, true) then
			table.insert(playersList, player)
		end
	end
	Panel.redrawPlayersList()
end

function Panel.redrawPlayersList()
	local showPlayers = {}
	local indexStart = math.max(1, playersListOffset + 1)
	local indexEnd = math.min(#playersList, playersListOffset + playersShowCount)
	for i = indexStart, indexEnd do
		local item = { 
			[1] = exports.tunrc_Utils:removeHexFromString(playersList[i]:getData("username")),
			player = playersList[i]
		}
		table.insert(showPlayers, item)
	end
	UI:setItems(ui.playersList, showPlayers)
end

function Panel.hide()
	if not isVisible then
		return false
	end
	isVisible = false

	UI:setVisible(ui.panel, false)
	showCursor(false)
	localPlayer:setData("activeUI", false)
	exports.tunrc_UI:fadeScreen(false)
end

function Panel.showPlayerInfo(player)
	if not isElement(player) then
		Panel.filterPlayersList()
		return false
	end
	UI:setVisible(ui.playerPanel, true)

	UI:setText(ui.nicknameLabel, tostring(player:getData("username")))

	UI:setText(ui.moneyLabel, 			exports.tunrc_Lang:getString("player_money") .. ": $" .. tostring(player:getData("money")))
	UI:setText(ui.levelLabel, 			exports.tunrc_Lang:getString("player_level") .. ": " .. tostring(player:getData("level")))
	UI:setText(ui.carsCountLabel,  	    exports.tunrc_Lang:getString("garage_cars_count") ..": " .. tostring(player:getData("garage_cars_count")))

	local state = player:getData("tunrc_Core.state")
	if not state then
		state = "city"
	end
	UI:setText(ui.locationLabel, 		"Location: " .. tostring(state))

	if player:getData("isMuted") then
		UI:setText(ui.muteButtonLabel, exports.tunrc_Lang:getString("moderatorpanel_unmute"))
	else
		UI:setText(ui.muteButtonLabel, exports.tunrc_Lang:getString("moderatorpanel_mute"))
	end

	selectedPlayer = player
end

function Panel.hidePlayerInfo()
	UI:setVisible(ui.playerPanel, false)

	selectedPlayer = nil
end

addEventHandler("onClientResourceStart", resourceRoot, function ()	
	ui.panel = UI:createTrcRoundedRectangle {
		x = (screenWidth - panelWidth) / 2,
		y = (screenHeight - panelHeight) / 2,
		width = panelWidth,
		height = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(ui.panel)
	UI:setVisible(ui.panel, false)

	-- Список игроков
	local playerSearchInputHeight = 50
	local playerListWidth = 200
	ui.playerSearchInput = UI:createDpInput({
		x = 0,
		y = 0,
		width = playerListWidth,
		height = 50,
		color = tocolor(200, 205, 210),
		textHolderColor = tocolor(0, 0, 0),
		textDarkHolderColor = tocolor(255,255,255),
        hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		locale = "Search..."
	})
	UI:addChild(ui.panel, ui.playerSearchInput)
	
	ui.playersList = UI:createDpList {
		x = 0, y = playerSearchInputHeight,
		width = playerListWidth, height = panelHeight,
		items = {},
		color = tocolor(245,245,245),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20),
		hoverDarkColor = tocolor(40,40,40),
		columns = {
			{size = 1, offset = 0.06, align = "left"}
		}
	}
	UI:addChild(ui.panel, ui.playersList)

	-- Панель с информацией об игроке
	local playerPanelWidth = panelWidth - playerListWidth
	local playerPanelHeight = panelHeight

	local notSelectedLabel = UI:createDpLabel {
		x = playerListWidth, y = 0,
		width = playerPanelWidth, height = playerPanelHeight,
		locale = "Player not selected",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarge",
		alignX = "center",
		alignY = "center"
	}	
	UI:addChild(ui.panel, notSelectedLabel)

	ui.playerPanel  = UI:createTrcRoundedRectangle {
		x = playerListWidth,
		y = 0,
		width = playerPanelWidth,
		height = playerPanelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(ui.panel, ui.playerPanel)

	ui.nicknameLabel = UI:createDpLabel {
		x = 20, y = 15,
		width = playerPanelWidth / 3, playerPanelHeight = 50,
		text = "...",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultLarger"
	}	
	UI:addChild(ui.playerPanel, ui.nicknameLabel)

	-- Деньги
	ui.moneyLabel = UI:createDpLabel {
		x = 20, y = 60,
		width = playerPanelWidth, height = 50,
		text = "",
		fontType = "defaultSmall",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
	}
	UI:addChild(ui.playerPanel, ui.moneyLabel)

	ui.levelLabel = UI:createDpLabel {
		x = 20, y = 90,
		width = playerPanelWidth, height = 50,
		text = "",
		fontType = "defaultSmall",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
	}
	UI:addChild(ui.playerPanel, ui.levelLabel)	

	ui.carsCountLabel = UI:createDpLabel {
		x = 20, y = 120,
		width = playerPanelWidth, height = 50,
		text = "",
		fontType = "defaultSmall",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
	}
	UI:addChild(ui.playerPanel, ui.carsCountLabel)

	ui.locationLabel = UI:createDpLabel {
		x = 20, y = 150,
		width = playerPanelWidth, height = 50,
		text = "Местоположение: -",
		fontType = "defaultSmall",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
	}
	UI:addChild(ui.playerPanel, ui.locationLabel)			

	-- 
	local buttonsHeight = 45
	
	ui.muteButton = UI:createTrcRoundedRectangle {
		x = 5,
		y = playerPanelHeight - buttonsHeight - 15,
		width = playerPanelWidth / 3 - 10,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true
	}
	UI:addChild(ui.playerPanel, ui.muteButton)
	
	ui.muteButtonLabel = UI:createDpLabel {
		x = UI:getWidth(ui.muteButton) / 2,
		y = UI:getHeight(ui.muteButton) / 2,
		width = 0,
		height = 0,
		text = "Местоположение: -",
		fontType = "defaultSmall",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		alignX = "center",
		alignY = "center"
	}
	UI:addChild(ui.muteButton, ui.muteButtonLabel)
	
	ui.kickButton = UI:createTrcRoundedRectangle {
		x = playerPanelWidth / 3 + 2.5,
		y = playerPanelHeight - buttonsHeight - 15,
		width = playerPanelWidth / 3 - 10,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "moderatorpanel_kick"
	}
	UI:addChild(ui.playerPanel, ui.kickButton)
	
	ui.banButton = UI:createTrcRoundedRectangle {
		x = playerPanelWidth / 3 * 2,
		y = playerPanelHeight - buttonsHeight - 15,
		width = playerPanelWidth / 3 - 10,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "moderatorpanel_ban"
	}
	UI:addChild(ui.playerPanel, ui.banButton)
	
	ui.TpToPlButton = UI:createTrcRoundedRectangle {
		x = playerPanelWidth / 3 * 2,
		y = playerPanelHeight - buttonsHeight * 2 - 25,
		width = playerPanelWidth / 3 - 10,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "moderatorpanel_teleport_to_player"
	}
	UI:addChild(ui.playerPanel, ui.TpToPlButton)
	
	ui.TpPlToMeButton = UI:createTrcRoundedRectangle {
		x = playerPanelWidth / 3 + 2.5,
		y = playerPanelHeight - buttonsHeight * 2 - 25,
		width = playerPanelWidth / 3 - 10,
		height = buttonsHeight,
		radius = 15,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		locale = "moderatorpanel_teleport_player_to_me"
	}
	UI:addChild(ui.playerPanel, ui.TpPlToMeButton)		
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == ui.playersList then
		local items = exports.tunrc_UI:getItems(ui.playersList)
		local selectedItem = exports.tunrc_UI:getActiveItem(ui.playersList)
		Panel.showPlayerInfo(items[selectedItem].player)
	elseif widget == ui.muteButton then
		Panel.hide()
		if selectedPlayer:getData("isMuted") then
			triggerServerEvent("tunrc_Admin.executeCommand", resourceRoot, "unmute", selectedPlayer)
		else
			MutePanel.show(selectedPlayer)
		end
	elseif widget == ui.banButton then
		Panel.hide()
		BanPanel.show(selectedPlayer)
	elseif widget == ui.kickButton then		
		triggerServerEvent("tunrc_Admin.executeCommand", resourceRoot, "kick", selectedPlayer)
		Panel.hidePlayerInfo()
	elseif widget == ui.TpToPlButton then		
		local pos = selectedPlayer:getPosition()
		if localPlayer.vehicle then
			localPlayer.vehicle:setPosition(pos)
		else
			localPlayer:setPosition(pos)
		end
		Panel.hidePlayerInfo()
	elseif widget == ui.TpPlToMeButton then		
		local pos = localPlayer:getPosition()
		if selectedPlayer.vehicle then
			selectedPlayer.vehicle:setPosition(pos)
		else
			selectedPlayer:setPosition(pos)
		end
		Panel.hidePlayerInfo()
	end
end)

addEvent("tunrc_UI.inputChange", false)
addEventHandler("tunrc_UI.inputChange", resourceRoot, function (widget)
	if widget == ui.playerSearchInput then
		Panel.filterPlayersList()
	end
end)

addEventHandler("onClientKey", root, function (button, down)
	if not down or not isVisible then
		return
	end
	if button == "mouse_wheel_up" then
		playersListOffset = playersListOffset - 1
		if playersListOffset < 0 then
			playersListOffset = 0
		end
		Panel.redrawPlayersList()
	elseif button == "mouse_wheel_down" then
		playersListOffset = playersListOffset + 1

		local count = math.min(#playersList, playersShowCount)
		if playersListOffset > #playersList - count then
			playersListOffset = #playersList - count
		end
		Panel.redrawPlayersList()
	end
end)

bindKey("F4", "down", function ()
	if not localPlayer:getData("group") then
		Panel.hide()
		return
	end
	if not isVisible then
		Panel.show()
	else
		Panel.hide()
	end
end)