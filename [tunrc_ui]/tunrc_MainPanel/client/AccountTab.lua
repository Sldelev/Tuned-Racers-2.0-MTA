AccountTab = {}
local panel
local ui = {}

function AccountTab.create()
	panel = Panel.addTab("account")
	local width = UI:getWidth(panel)
	local height = UI:getHeight(panel)

	---------------- Статистика -------------------
	-- Количество автомобилей в гараже
	local carsCountLabel = UI:createDpLabel {
		x = 20, y = 15,
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

	-- Наличие премиума
	local premiumLabel = UI:createDpLabel {
		x = width / 1.65, y = 55,
		width = width / 3, height = 50,
		text = "",
		fontType = "defaultSmall",
		type = "dark",
	}
	UI:addChild(panel, premiumLabel)
	UIDataBinder.bind(premiumLabel, "premium_expires", function (value)
		if not localPlayer:getData("isPremium") then
			return 
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
		x = width / 1.65, y = 15,
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
	-- Sell car button
	local x = width * 0.6
	local sellVehicleButton = UI:createDpButton {
		x      = x + 250,
        y      = height - 325,
        width  = width / 3,
		height = 50,
		type = "primary",
		locale = "main_panel_account_sell_vehicle"
	}
	UI:addChild(panel, sellVehicleButton)
	-- Кнопка донат
	local donateButton = UI:createDpButton {
		x      = x + 250,
        y      = height - 275,
        width  = width / 3,
		height = 50,
		locale = "main_panel_account_donat",
		type = "primary"
	}
	UI:addChild(panel, donateButton)
	-- Кнопка помощь
	local helpButton = UI:createDpButton {
		x      = x + 250,
        y      = height - 225,
        width  = width / 3,
		height = 50,
		locale = "main_panel_account_help",
		type = "primary"
	}
	UI:addChild(panel, helpButton)

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
