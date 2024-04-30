BuyWindow = {}
local screenSize = Vector2(guiGetScreenSize())
local UI = exports.tunrc_UI
local window = {}

-- Список полей с информацией о дома
local infoLabels = {
	{"rooms", 	"houses_info_rooms_count", "0"},
	{"tv", 		"houses_info_tv", "-"},
	{"radio", 	"houses_info_radio", "-"},
	{"console", "houses_info_console", "-"},
	{"price", 	"houses_info_price", "..."},
}
local currentMarker = nil

function BuyWindow.show(marker)
	if localPlayer:getData("activeUI") then
		return
	end
	if not marker:getData("house_price") then
		return
	end
	local houseData = marker:getData("house_data") or {}

	showCursor(true)
	-- TODO: Информация о количестве комнат
	UI:setText(window.labels.rooms, tostring(houseData.rooms_count or 3))
	UI:setText(window.labels.price, exports.tunrc_Utils:format_num(marker:getData("house_price"), 0, "$"))
	-- TODO: Заполнить поля с информацией о доме
	UI:setText(window.labels.tv, exports.tunrc_Lang:getString("houses_info_no"))
	UI:setText(window.labels.radio, exports.tunrc_Lang:getString("houses_info_no"))
	UI:setText(window.labels.console, exports.tunrc_Lang:getString("houses_info_no"))

	-- Отобразить окно покупки
	UI:fadeScreen(true)
	UI:setVisible(window.panel, true)
	localPlayer:setData("activeUI", "houseBuyWindow")

	-- Маркер дома, для которого отображается окно покупки
	currentMarker = marker
end

function BuyWindow.hide()
	if localPlayer:getData("activeUI") ~= "houseBuyWindow" then
		return
	end
	currentMarker = nil
	showCursor(false)
	UI:fadeScreen(false)
	UI:setVisible(window.panel, false)
	localPlayer:setData("activeUI", false)
end

-- Создание окна
addEventHandler("onClientResourceStart", resourceRoot, function ()
	local panelWidth = 400
	local panelHeight = 410
	window.panel = UI:createDpPanel({
		x = (screenSize.x - panelWidth) / 2,
		y = (screenSize.y - panelHeight) / 2,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(window.panel)

	-- Картинки
	local texture = dxCreateTexture("assets/textures/icon.png")
	local w, h = dxGetMaterialSize(texture)
	w = w * 0.7
	h = h * 0.7
	local image1 = UI:createImage({
		x = panelWidth / 2 - w / 2,
		y = 0,
		width = w,
		height = h,
		texture = texture
	})
	UI:addChild(window.panel, image1)

	-- local image2 = UI:createImage({
	-- 	x = panelWidth / 2,
	-- 	y = 0,
	-- 	width = panelWidth / 2,
	-- 	height = panelWidth / 2,
	-- 	texture = dxCreateTexture("assets/textures/houses/1-2.png")
	-- })
	-- UI:addChild(window.panel, image2)	

	-- Информация о доме
	local y = panelWidth / 2
	window.labels = {}
	for i, labelInfo in ipairs(infoLabels) do
		local text = UI:createDpLabel({
			x = 10, y = y,
			width = panelWidth - 20,
			height = 30,
			locale = labelInfo[2],
			type = "default",
			alignX = "left",
			alignY = "center"
 		})
		UI:addChild(window.panel, text)

		local label = UI:createDpLabel({
			x = 10, y = y,
			width = panelWidth - 20,
			height = 30,
			text = labelInfo[3],
			type = "primary",
			fontType = "defaultBold",
			alignX = "right",
			alignY = "center"
 		})
		UI:addChild(window.panel, label)		
		window.labels[labelInfo[1]] = label
		y = y + 30
	end

	-- Кнопки
	window.cancelButton = UI:createDpButton({
		x = 0, y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "default_dark",
		locale = "houses_buy_cancel"
	})
	UI:addChild(window.panel, window.cancelButton)	
	window.buyButton = UI:createDpButton({
		x = panelWidth / 2, y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		locale = "houses_buy_confirm"
	})
	UI:addChild(window.panel, window.buyButton)	

	UI:setVisible(window.panel, false)
end)

addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == window.buyButton then
		-- Проверка маркера дома
		if not isElement(currentMarker) then
			outputDebugString("BuyWindow: no marker")
			exports.tunrc_UI:showMessageBox(
				exports.tunrc_Lang:getString("houses_message_title"), 
				exports.tunrc_Lang:getString("houses_message_cant_buy")
			)
			BuyWindow.hide()
			return
		end
		-- Проверка значений
		local money = exports.tunrc_Utils:getElementDataDefault(localPlayer, "money", 0)
		local price = currentMarker:getData("house_price")
		if type(price) ~= "number" then
			outputDebugString("BuyWindow: house_price is not 'number'")
			exports.tunrc_UI:showMessageBox(
				exports.tunrc_Lang:getString("houses_message_title"), 
				exports.tunrc_Lang:getString("houses_message_cant_buy")
			)
			BuyWindow.hide()		
			return
		end
		-- У игрока недостаточно денег
		if money < price then
			outputDebugString("BuyWindow: not enough money")
			exports.tunrc_UI:showMessageBox(
				exports.tunrc_Lang:getString("houses_message_title"), 
				exports.tunrc_Lang:getString("houses_message_no_money")
			)
			BuyWindow.hide()		
			return
		end

		-- Купить дом
		local houseMarker = currentMarker
		BuyWindow.hide()
		-- Окно подтверждения
		local confirmText = string.format(
			exports.tunrc_Lang:getString("houses_message_buy_confirm"),
			exports.tunrc_Utils:format_num(price, 0, "$")
		)
		ConfirmWindow.show(confirmText, function()
			-- Купить дом
			triggerServerEvent("tunrc_Houses.buy", houseMarker)
		end)
	elseif widget == window.cancelButton then
		-- Скрыть меню покупки дома
		BuyWindow.hide()
	end
end)


if localPlayer:getData("activeUI") == "houseBuyWindow" then
	localPlayer:setData("activeUI", false)
end