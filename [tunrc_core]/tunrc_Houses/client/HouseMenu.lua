HouseMenu = {}
local screenSize = Vector2(guiGetScreenSize())
local UI = exports.tunrc_UI
local window = {}
local kickLocked = false
local KICK_COOLDOWN_TIME = HOUSE_PLAYERS_KICK_COOLDOWN

-- Кнопки для действий с домом
local actions = {
	{"toggleDoor", "houses_menu_close_door"},
	{"kickPlayers", "houses_menu_kick"},
	{"sell", "houses_menu_sell"},
}

function HouseMenu.show()
	-- Если игрок не находится в доме
	if localPlayer:getData("activeMap") ~= "house" then
		return
	end
	-- Игрок не находится в дома (2)
	local currentHouseId = localPlayer:getData("currentHouse")
	if not currentHouseId then
		return
	end	
	-- Открыто другое меню
	if localPlayer:getData("activeUI") then
		return
	end
	-- У игрока нет дома
	local houseId = localPlayer:getData("house_id")
	if not houseId then
		return
	end
	-- Игрок находится не в своём доме
	if currentHouseId ~= houseId then
		return
	end
	localPlayer:setData("activeUI", "houseMenu")

	-- Текст кнопки открытия двери в зависимости от состояния двери
	local marker = Element.getByID("house_enter_marker_" .. houseId)
	if isElement(marker) then
		local str = "houses_menu_open_door"
		if marker:getData("house_open") then
			str = "houses_menu_close_door"
		end
		UI:setText(window.toggleDoor, exports.tunrc_Lang:getString(str))
	end

	-- Отобразить меню дома
	UI:setVisible(window.panel, true)
	UI:fadeScreen(true)
	showCursor(true)
end

function HouseMenu.hide()
	if localPlayer:getData("activeUI") ~= "houseMenu" then
		return
	end
	localPlayer:setData("activeUI", false)

	UI:setVisible(window.panel, false)
	showCursor(false)
	UI:fadeScreen(false)	
end

-- Создание меню дома
addEventHandler("onClientResourceStart", resourceRoot, function ()
	local panelWidth = 350
	local panelHeight = 235	
	local logoTexture = exports.tunrc_Assets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoWidth = panelWidth
	local logoHeight = textureHeight * panelWidth / textureWidth
	window.panel = UI:createDpPanel({
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight + logoHeight) / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(window.panel)

	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 10,
		width = logoWidth,
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(window.panel, logoImage)		

	local y = 0

	for i, button in ipairs(actions) do
		if button[1] then
			window[button[1]] = UI:createDpButton({
				x = 0, y = y,
				width = panelWidth,
				height = 45,
				type = "default_dark",
				locale = button[2]
			})
			UI:addChild(window.panel, window[button[1]])
			y = y + 45
		end
	end

	panelHeight = y + 55
	UI:setHeight(window.panel, panelHeight)
	

	window.closeButton = UI:createDpButton({
		x = 0, y = panelHeight - 55,
		width = panelWidth,
		height = 55,
		type = "primary",
		locale = "houses_menu_close"
	})
	UI:addChild(window.panel, window.closeButton)	

	UI:setVisible(window.panel, false)
end)

bindKey(HOUSE_MENU_BUTTON, "down", function ()
	if localPlayer:getData("activeUI") ~= "houseMenu" then
		HouseMenu.show()
	else
		HouseMenu.hide()
	end	
end)

if localPlayer:getData("activeUI") == "houseMenu" then
	HouseMenu.hide()
end

addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == window.closeButton then
		-- Кнопка "Закрыть"
		HouseMenu.hide()
	elseif widget == window.sell then
		-- Продажа дома
		local houseId = localPlayer:getData("house_id")
		if not houseId then
			return
		end
		local marker = Element.getByID("house_enter_marker_" .. tostring(houseId))	
		if not isElement(marker) then
			outputDebugString("Sell house: no marker")
			return
		end
		local price = marker:getData("house_price")
		if type(price) ~= "number" then
			outputDebugString("Sell house: no price")
			return
		end
		price = math.floor(price * HOUSE_SELL_PRICE_MUL)
		local confirmText = string.format(
			exports.tunrc_Lang:getString("houses_message_sell_confirm"),
			exports.tunrc_Utils:format_num(price, 0, "$")
		)
		HouseMenu.hide()
		ConfirmWindow.show(confirmText, function()
			triggerServerEvent("tunrc_Houses.sell", resourceRoot)
		end)
	elseif widget == window.toggleDoor then
		local houseId = localPlayer:getData("house_id")
		if not houseId then
			HouseMenu.hide()
			return
		end
		local marker = Element.getByID("house_enter_marker_" .. tostring(houseId))	
		if not isElement(marker) then
			HouseMenu.hide()
			return
		end
		-- TODO: Перенести на сервер
		marker:setData("house_open", not marker:getData("house_open"), true)

		-- Обновление текста кнопки
		local str = "houses_menu_open_door"
		if marker:getData("house_open") then
			str = "houses_menu_close_door"
		end
		UI:setText(window.toggleDoor, exports.tunrc_Lang:getString(str))
	elseif widget == window.kickPlayers then
		-- Выгнать всех игроков из дома
		if not kickLocked  then
			triggerServerEvent("tunrc_Houses.kickPlayers", resourceRoot)
			kickLocked  = true

			-- Временно отключить кнопку
			setTimer(function() kickLocked = false end, KICK_COOLDOWN_TIME, 1)
		end
	end
end)
