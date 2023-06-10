AccountTab = {}
local panel
local ui = {}

function AccountTab.create()
	panel = Panel.addTab("account")
	local width = UI:getWidth(panel)
	local height = UI:getHeight(panel)
	
	local buttonPanel = UI:createDpPanel {
        x       = width + 15,
        y       = 0,
        width   = width / 3,
        height  = height,
        type    = "light"
    }
	UI:addChild(panel, buttonPanel)
	
	local usernameLabel = UI:createDpLabel {
		x = 20, y = 15,
		width = width / 3, height = 50,
		text = "---",
		type = "primary",
		fontType = "defaultLarger"
	}
	UI:addChild(panel, usernameLabel)
	UIDataBinder.bind(usernameLabel, "username", function (value)
		return string.upper(tostring(value))
	end)
	-- Подпись
	local usernameLabelText = UI:createDpLabel {
		x = 20 , y = 55,
		width = width / 3, height = 50,
		text = "Admin",
		color = tocolor(0, 0, 0, 100),
		fontType = "defaultSmall",
		locale = "main_panel_account_player"
	}
	UI:addChild(panel, usernameLabelText)
	UIDataBinder.bind(usernameLabelText, "group", function (value)
		if not value then
			return exports.tunrc_Lang:getString("groups_player")
		else
			return exports.tunrc_Lang:getString("groups_" .. tostring(value))
		end
	end)

	local moneyLabel = UI:createDpLabel {
	x = width - width / 3 - 20 , y = 15,
	width = width / 3, height = 50,
	text = "$0",
	type = "primary",
	fontType = "defaultLarger",
	alignX = "right"
	}
	UI:addChild(panel, moneyLabel)
	UIDataBinder.bind(moneyLabel, "money", function (value)
	 return "$" .. tostring(value)
	 end)
	-- Подпись
	local moneyLabelText = UI:createDpLabel {
	 	x = width - width / 3 - 20 , y = 55,
	 	width = width / 3, height = 50,
		text = "Money",
	 	color = tocolor(0, 0, 0, 100),
	 	fontType = "defaultSmall",
	 	alignX = "right",
	 	locale = "main_panel_account_money"
	 }
	 UI:addChild(panel, moneyLabelText)

	---------------- Статистика -------------------
	-- Количество автомобилей в гараже
	local carsCountLabel = UI:createDpLabel {
		x = 20, y = 100,
		width = width / 3, height = 50,
		text = "Количество авто: 5",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, carsCountLabel)
	UIDataBinder.bind(carsCountLabel, "garage_cars_count", function (value)
		if not value then
			value = 0
		end
		return exports.tunrc_Lang:getString("main_panel_account_cars_count") .. ": " .. tostring(value)
	end)
	
	-- ФПС ИГРОКА
	local fpsPlayer = UI:createDpLabel {
		x = width / 2, y = 210,
		width = width / 3, height = 50,
		text = "ФПС : 60",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, fpsPlayer)
	UIDataBinder.bind(fpsPlayer, "fps_player", function (value)
		if not value then
			return ""
		end
		
		return exports.tunrc_Lang:getString("main_panel_account_fps") .. ": " .. roundedFPS
	end)

	-- Время, проведенное на сервере
	local playtimeLabel = UI:createDpLabel {
		x = 20, y = 140,
		width = width / 3, height = 50,
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, playtimeLabel)
	UIDataBinder.bind(playtimeLabel, "playtime", function (value)
		value = tonumber(value)
		if not value then
			value = 0
		end
		value = math.floor(value / 60 * 10) / 10
		return exports.tunrc_Lang:getString("main_panel_account_playtime") .. ": " .. tostring(value)
	end)	

	-- Наличие у игрока дома (TODO)
	local premiumLabel = UI:createDpLabel {
		x = width / 2, y = 140,
		width = width / 3, height = 50,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, premiumLabel)
	UIDataBinder.bind(premiumLabel, "premium_expires", function (value)
		if not localPlayer:getData("isPremium") then
			return ""
		end
		if not value or type(value) ~= "number" then
			return ""
		end
		local time = getRealTime(value)
		local month = tostring(time.month + 1)
		if time.month < 10 then
			month = "0" .. tostring(time.month + 1)
		end
		local day = tostring(time.monthday)
		if time.monthday < 10 then
			day = "0" .. tostring(time.monthday)
		end
		return exports.tunrc_Lang:getString("main_panel_account_premium") .. ": " .. tostring(1900 + time.year) .. "-" .. month .. "-" .. day
	end)

	-- Дата регистрации
	local registerDateLabel = UI:createDpLabel {
		x = width / 1.65, y = 100,
		width = width / 3, height = 50,
		text = "Дата регистрации: 1.01.2016",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, registerDateLabel)
	UIDataBinder.bind(registerDateLabel, "register_time", function (value)
		if type(value) ~= "string" then
			return ""
		end
		local timeString = tostring(value:sub(1, string.find(value, " ")))
		return exports.tunrc_Lang:getString("main_panel_account_regtime") .. ": " .. timeString
	end)
	
	-----------------Кнопки сбоку------------------------
	by = height - 235
	-- Sell car button
	local sellVehicleButton = UI:createDpButton {
		x = 0,
		y = by,
		width = width / 3,
		height = 50,
		type = "primary",
		locale = "main_panel_account_sell_vehicle"
	}
	UI:addChild(buttonPanel, sellVehicleButton)
	-- Кнопка донат
	local donateButton = UI:createDpButton {
		x = 0,
		y = by - 50,
		width = width / 3,
		height = 50,
		locale = "main_panel_account_donat",
		type = "primary"
	}
	UI:addChild(buttonPanel, donateButton)
	-- Кнопка помощь
	local helpButton = UI:createDpButton {
		x = 0,
		y = by - 100,
		width = width / 3,
		height = 50,
		locale = "main_panel_account_help",
		type = "primary"
	}
	UI:addChild(buttonPanel, helpButton)

	ui = {
		donateButton = donateButton,
		helpButton = helpButton,
		sellVehicleButton = sellVehicleButton
	}
end

function AccountTab.refresh()
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == ui.sellVehicleButton then
        Panel.setVisible(false)
        if localPlayer.vehicle and localPlayer.vehicle:getData("owner_id") == localPlayer:getData("_id")
            and localPlayer:getData("garage_cars_count") > 1 then
            exports.tunrc_SellVehicle:start()
        end
	elseif widget == ui.donateButton then
		Panel.setVisible(false)
		exports.tunrc_GiftsPanel:setVisible(true)
	elseif widget == ui.helpButton then
		Panel.setVisible(false)
		exports.tunrc_HelpPanel:setVisible(not isVisible())	
	end
end)
