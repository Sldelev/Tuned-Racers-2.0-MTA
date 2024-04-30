local screenSize = Vector2(guiGetScreenSize())
local currentMenu = false
local targetElement

local menuScreenPosition = Vector2()

local menuItemHeight = 30
local menuHeaderHeight = 35

local itemTextOffset = 15

local MENU_MIN_WIDTH = 150
local menuWidth = 150
local itemFont
local titleFont

local bgcolor
local menuAlpha = 255
local highlightedItem

addEventHandler("onClientRender", root, function ()
	if not currentMenu then
		return false
	end
	
	if exports.tunrc_Config:getProperty("ui.dark_mode") == true then
		bgcolor = {40,40,40}
	else
		bgcolor = {225,225,225}
	end

	local x, y = menuScreenPosition.x, menuScreenPosition.y
	local mx, my = getCursorPosition()
	if not mx then
		return
	end
	mx = mx * screenSize.x
	my = my * screenSize.y

	exports.tunrc_Garage:dxDrawRoundedRectangle(x, y, menuWidth, menuItemHeight * #currentMenu.items + (menuHeaderHeight * 1.5), 15, 255, true, false, true, false)
	exports.tunrc_Garage:TrcDrawText(currentMenu.title, x + itemTextOffset, y, x + menuWidth, y + menuHeaderHeight, 255, titleFont, "left", "center", 1)
	y = y + menuHeaderHeight
	highlightedItem = nil
	for i, item in ipairs(currentMenu.items) do
		if mx > x and mx < x + menuWidth and my > y and my < y + menuItemHeight then
			menuAlpha = 255
			if item.state then
				highlightedItem = item
			end
		else
			menuAlpha = 50
		end
		dxDrawRectangle(x, y, menuWidth, menuItemHeight, tocolor(bgcolor[1], bgcolor[2], bgcolor[3], menuAlpha), true)
		exports.tunrc_Garage:TrcDrawText(item.text, x + itemTextOffset, y, x + menuWidth, y + menuItemHeight, menuAlpha, itemFont, "left", "center", 1)
		y = y + menuItemHeight
	end

	if getKeyState("mouse1") then		
		if highlightedItem and highlightedItem.enabled ~= false and type(highlightedItem.click) == "function" then
			highlightedItem.click(targetElement)
		end
		hideMenu()
	end
end)

function showMenu(menu, element)
	if type(menu) ~= "table" then
		return false
	end
	if not isElement(element) then
		return false
	end
	currentMenu = menu

	if type(currentMenu.init) == "function" then
		local show = currentMenu.init(currentMenu, element)
		if show == false then
			hideMenu()
			return
		end
	end	

	toggleControl("fire", false)

	local maxWidth = 0
	for i, item in ipairs(currentMenu.items) do
		if type(item.enabled) == "function" then
			item.state = item.enabled(element)
		elseif item.enabled == nil then
			item.state = true
		else
			item.state = not not item.enabled
		end
		if type(item.locale) == "string" then
			item.text = exports.tunrc_Lang:getString(item.locale)
		end
		if type(item.getText) == "function" then
			item.text = item.getText(element)
		end
		local width = dxGetTextWidth(item.text, 1, itemFont)
		if width > maxWidth then
			maxWidth = width
		end
	end
	local titleWidth = dxGetTextWidth(currentMenu.title, 1, titleFont)
	if titleWidth > maxWidth then
		maxWidth = titleWidth
	end

	menuWidth = math.max(MENU_MIN_WIDTH, maxWidth + itemTextOffset * 2)
	local totalHeight = menuItemHeight * #currentMenu.items + menuHeaderHeight
	targetElement = element

	local mx, my = getCursorPosition()
	mx = mx * screenSize.x
	my = my * screenSize.y

	menuScreenPosition = Vector2(math.min(mx, screenSize.x - menuWidth), math.min(my, screenSize.y - totalHeight))
	localPlayer:setData("activeUI", "contextMenu")
end

function isMenuVisible()
	return not not currentMenu
end

function hideMenu()
	localPlayer:setData("activeUI", false)
	setTimer(function() toggleControl("fire", true) end, 200, 1)
	if currentMenu then
		showCursor(false)
	end
	currentMenu = false
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	titleFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 14)
	itemFont = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 12)
end)