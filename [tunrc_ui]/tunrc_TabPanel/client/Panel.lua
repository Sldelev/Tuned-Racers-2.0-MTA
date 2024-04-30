Panel = {}
local screenWidth, screenHeight
local renderTarget
local headerColor = tocolor(29, 29, 29, 175)

local panelWidth = 350
local panelHeight
local headerHeight = 50
local itemHeight = 40

local itemsCount = 10

local headerFont
local itemFont
local logoTexture
local logoWidth, logoHeight

local columns = {
	{ name = "tab_panel_column_id", 		size = 0.1, 	data = "id"},
	{ name = "tab_panel_column_nickname", 	size = 0.8, 	data = "name"},
}
local playersList = {}
local playersOnlineCount = 0
local playersOnlineString = "Players online"
local scrollOffset = 0

local function draw()
	if renderTarget then
		dxSetRenderTarget(renderTarget)
	end
	local w, h = 500, 50
	local y = screenHeight / 2 - panelHeight / 2
	local panelX = screenWidth / 2 - panelWidth / 2
	local themeColor = {exports.tunrc_UI:getThemeColor()}
	y = y + 200
	exports.tunrc_Garage:dxDrawRoundedRectangle(panelX, y, panelWidth, headerHeight * 2 + itemsCount * itemHeight, 15, 255, true, false, true, false)
	local x = panelX
	for i, column in ipairs(columns) do
		local width = panelWidth * column.size
		exports.tunrc_Garage:TrcDrawText(exports.tunrc_Lang:getString(column.name), x, y, x + width, y + headerHeight, 255, headerFont, "center", "center", 1)
		x = x + width
	end
	y = y + headerHeight
	local itemY = y
	for i = scrollOffset + 1, math.min(itemsCount + scrollOffset, #playersList) do
		local item = playersList[i]
		x = panelX
		if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
			lineColor = tocolor(205, 205, 205, 255)
		else
			lineColor = tocolor(60, 60, 60, 255)
		end
		dxDrawRectangle(x, y, panelWidth, 2, lineColor,true)
		if item.isGroup then
			exports.tunrc_Garage:dxDrawRoundedRectangle(panelX, y, panelWidth, itemHeight, 0, 255, true, false, true, true)
			exports.tunrc_Garage:TrcDrawText(item.text, x, y, x + panelWidth, y + headerHeight * 0.8, 255, itemFont, "center", "center", 1)
		else
			for j, column in ipairs(columns) do
				local text = item[column.data]
				local width = panelWidth * column.size
				exports.tunrc_Garage:TrcDrawText(tostring(text), x, y, x + width, y + headerHeight * 0.8, 255, itemFont, "center", "center", 1)
				x = x + width
			end
		end
		y = y + itemHeight
	end
	x = panelX
	y = itemY + itemsCount * itemHeight
	exports.tunrc_Garage:TrcDrawText(playersOnlineString .. ": " .. tostring(playersOnlineCount), x, y, x + panelWidth, y + headerHeight, 255, headerFont, "center", "center", 1)
	if renderTarget then
		dxSetRenderTarget()
	end
end

local function mouseDown()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset + 1
	if scrollOffset > #playersList - itemsCount then
		scrollOffset = #playersList - itemsCount + 1
	end
end

local function mouseUp()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset - 1
	if scrollOffset < 0 then
		scrollOffset = 0
	end
end

function Panel.start()
	renderTarget = exports.tunrc_UI:getRenderTarget()
	screenWidth, screenHeight = exports.tunrc_UI:getScreenSize()
	addEventHandler("onClientRender", root, draw)
	headerFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 18)
	itemFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 14)
	logoTexture = exports.tunrc_Assets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	logoWidth = 415
	logoHeight = textureHeight * 415 / textureWidth
	panelHeight = logoHeight + 10 + headerHeight * 2 + itemsCount * itemHeight

	playersList = {}

	local function addPlayerToList(player, isLocalPlayer)
		if type(player) == "table" then
			table.insert(playersList, player)
			return
		end
		table.insert(playersList, {
			isLocalPlayer = isLocalPlayer,
			id = player:getData("serverId") or 0,
			name = exports.tunrc_Utils:removeHexFromString(player:getData("username")),
			money = "$" .. tostring(player:getData("money") or 0),
			level = player:getData("level") or "-"
		})
	end

	local players = getElementsByType("player")
	table.sort(players, function (player1, player2)
		local id1 = player1:getData("serverId") or 999
		local id2 = player2:getData("serverId") or 999
		return id1 < id2
	end)
	playersOnlineCount = #players

	local function getPlayersWithData(dataName)
		local t = {}
		for i = #players, 1, -1 do
			if players[i]:getData(dataName) then
				table.insert(t, table.remove(players, i))
			end
		end
		return t
	end

	addPlayerToList(localPlayer, true)
	local moderators = getPlayersWithData("group")
	if #moderators > 0 then
		addPlayerToList({ text = exports.tunrc_Lang:getString("tab_panel_group_moderators"), color = headerColor, isGroup = true} )
		for i, p in ipairs(moderators) do
			addPlayerToList(p)
		end
	end
	local premiums = getPlayersWithData("premium")
	if #premiums > 0 then
		addPlayerToList({ text = exports.tunrc_Lang:getString("tab_panel_group_premium"), color = headerColor, isGroup = true} )
		for i, p in ipairs(premiums) do
			addPlayerToList(p)
		end
	end

	if #players > 0 then
		addPlayerToList({ text = exports.tunrc_Lang:getString("tab_panel_group_players"), color = headerColor, isGroup = true} )
		for i, player in ipairs(players) do
			if player ~= localPlayer then
				addPlayerToList(player)
			end
		end
	end

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
	localPlayer:setData("activeUI", "tabPanel")

	playersOnlineString = exports.tunrc_Lang:getString("tab_panel_players_online")
	if not playersOnlineString then
		playersOnlineString = "Players online"
	end
end

function Panel.stop()
	removeEventHandler("onClientRender", root, draw)
	destroyElement(headerFont)
	destroyElement(itemFont)
	destroyElement(logoTexture)

	unbindKey("mouse_wheel_up", "down", mouseUp)
	unbindKey("mouse_wheel_down", "down", mouseDown)

	localPlayer:setData("activeUI", false)
end
