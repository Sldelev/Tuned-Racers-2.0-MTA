local NAMETAG_OFFSET = 1.1
local NAMETAG_WIDTH = 100
local NAMETAG_HEIGHT = 20
local NAMETAG_MAX_DISTANCE = 25
local NAMETAG_SCALE = 3.5

local CONFIG_PROPERTY_NAME = "graphics.nametags"
local CONFIG_PROPERTY_NAME_SELF = "graphics.self_nametags"

local CROWN_SIZE = 70

local nametagFont = "default"
local streamedPlayers = {}
local nametagsVisible = true
local SelfnametagsVisible = false
local crownTexture

local function dxDrawNametagText(text, x1, y1, x2, y2, scale)
	if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
		color = tocolor(245, 245, 245, 255)
		shadowColor = tocolor(20, 20, 20, 150)
	else
		color = tocolor(20, 20, 20, 255)
		shadowColor = tocolor(155, 155, 155, 150)
	end
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, shadowColor, scale, nametagFont, "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, shadowColor, scale, nametagFont, "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, shadowColor, scale, nametagFont, "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, shadowColor, scale, nametagFont, "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, nametagFont, "center", "center")
	return dxGetTextWidth(text, scale, nametagFont)
end

addEventHandler("onClientRender", root, function ()
	nametagsVisible = exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME)
	if nametagsVisible == false then
		return
	end
	local tr, tg, tb = exports.tunrc_UI:getThemeColor()
	local cx, cy, cz = getCameraMatrix()
	for player, info in pairs(streamedPlayers) do
		local px, py, pz = getElementPosition(player)		
		local x, y = getScreenFromWorldPosition(px, py, pz + NAMETAG_OFFSET)
		if x then
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
			if distance < NAMETAG_MAX_DISTANCE then
				local a = 255
				local name = player:getData("username")
				local id = player:getData("serverId")
				local scale = 1 / distance * NAMETAG_SCALE
				local width = NAMETAG_WIDTH * scale
				local height = NAMETAG_HEIGHT * scale
				local nx, ny = x - width / 2, y - height / 2
				local r, g, b = tr, tg, tb
				if not name or not id then
					return
				end
				
				local textWidth = dxDrawNametagText(id .. " | " .. name, nx, ny, nx + width, ny + height, scale)
				if info.premium then
					local cx = nx + width / 2 - textWidth / 2 - CROWN_SIZE * scale * 1.4
					local crownSize = CROWN_SIZE * scale
					dxDrawImage(cx, ny -  CROWN_SIZE / 2 * scale, crownSize, crownSize, crownTexture, 0, 0, 0, tocolor(255, 216, 0, 255))
				end
			end
		end
	end
end)

local function showPlayer(player)
	if not isElement(player) then
		return false
	end
	setPlayerNametagShowing(player, false)
	
	SelfnametagsVisible = exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME_SELF)

	if SelfnametagsVisible == false and player == localPlayer then
		return
	end
	streamedPlayers[player] = {
		name = exports.tunrc_Utils:removeHexFromString(player.name),
		premium = not not player:getData("isPremium")
	}
	return true
end

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "player" then
		showPlayer(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if source.type == "player" then
		streamedPlayers[source] = nil
	end
end)

addEventHandler("onClientPlayerQuit", root, function ()
	streamedPlayers[source] = nil
end)

addEventHandler("onClientPlayerJoin", root, function ()
	if isElementStreamedIn(source) then
		showPlayer(source)
	end
	setPlayerNametagShowing(source, false)
end)

addEventHandler("onClientPlayerSpawn", root, function ()
	if isElementStreamedIn(source) then
		showPlayer(source)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		if isElementStreamedIn(player) then
			showPlayer(player)
		end
		setPlayerNametagShowing(player, false)
	end

	-- local ped = createPed(0, Vector3{ x = 1739.240, y = -1440.502, z = 13.366 })
	-- streamedPlayers[ped] = {name = "TESTPLAYER123", premium = true}
	-- ped.health = 76

	nametagFont = dxCreateFont("assets/font.ttf", 50)
	crownTexture = exports.tunrc_Assets:createTexture("crown.png")
end)

function setVisible(visible)
	nametagsVisible = not not visible
end

function setSelfVisible(visible)
	SelfnametagsVisible = not not visible
end

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		setVisible(value)
		showPlayer(player)
	elseif key == CONFIG_PROPERTY_NAME_SELF then
		setSelfVisible(value)
	end
end)