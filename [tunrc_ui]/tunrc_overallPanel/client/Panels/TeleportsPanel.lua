TeleportsPanel = {}
local screenWidth, screenHeight = UI:getScreenSize()
local width = 500
local height = 570
local teleportpanel
local list
local offset = 1
local showCount = 10

local showCountFilters = 4
local filter = "citys"

local filterList = {
    { "teleports_filter_citys",  "citys" },
    { "teleports_filter_tracks",  "tracks" },
    { "teleports_filter_mountains",  "mountains" },
    { "teleports_filter_races",  "races" },
    { "teleports_filter_fun",  "fun" },
}

local teleports = {
    { "Los Santos",  "city_ls" },
    { "San Fierro",  "city_sf" },
    { "Las Venturas",  "city_lv" },
    { "LS: Uptown",  "city_ls1" },
    { "LS: Santa Maria Beach",  "city_ls2" },
    { "LS: East Beach",  "city_ls3" },	
	{ "LV: Uptown",  "city_lv1" },
	{ "LV: Prickle Pine",  "city_lv2" },
	{ "LV: Fort Carson",  "city_lv3" },
	{ "LV: Warehouse parking",  "city_lv_parking_a" },
	{ "LV: WalMart parking",  "city_market" },
    { "SF: Mount Drift Spot",  "city_sf1" },	
    { "SF: Uptown",  "city_sf2" },
	{ "SF: Calton Heights",  "city_sf3" },
	{ "SF: Missionary Hill",  "mount_sf" },
	{ "SF: Whetstone",  "city_sfchill" }, 
}

local teleports1 = {
	{ "Atron",  "atron" },
	{ "Red Ring",  "rr" },
	{ "Saint Petersburg",  "spb" },
	{ "Ebisu Minami",  "minami" },
	{ "Ebisu West",  "west" },
	{ "Ebisu Higashi",  "higashi" },
	{ "Meihan Course C",  "meihan" },
	{ "Bihoku Circuit",  "bihoku" },
	{ "Okutama",  "okutama" },
	{ "PrimRing",  "primring" },
	{ "Yz Circuit",  "yz" },
	{ "Galdori",  "galdori" },
}

local teleports2 = {
	{ "Akina",  "akina" },
	{ "Akagi",  "akagi" },
	{ "Usui",  "usui" },
	{ "Tsubaki Line",  "tsu" },
	{ "Tsuchisaka",  "tsuchi" },
	{ "Happogahara",  "happo" },
	{ "Irohazaka",  "iro" },
	{ "Myogi",  "myogi" },
	{ "Nagao",  "nagao" },
	{ "Nanohanadai",  "nano" },
}

local teleports3 = {
	{ "Long Drift LS",  "d1" },
	{ "Long Drift LV 1",  "d2" },
	{ "Long Drift LV 2",  "d3" },
	{ "Long Drift Atron 1",  "d4" },
}

local teleports4 = {
	{ "TunedRacers showroom",  "trc_shrm" },
}

local isVisible = false

function TeleportsPanel.show()
    if isVisible then
        return false
    end
	Panel.setVisible(false)
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(teleportpanel, true)
	TeleportsPanel.refresh()
    localPlayer:setData("activeUI", "teleportsPanel")
end

function TeleportsPanel.hide()
    if not isVisible then
        return false
    end
    isVisible = false
    exports.tunrc_HUD:setVisible(true)
    exports.tunrc_UI:fadeScreen(false)
    showCursor(false)
    UI:setVisible(teleportpanel, false)
    localPlayer:setData("activeUI", false)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- ОСНОВНАЯ ПАНЕЛЬ
	
	teleportpanel = UI:createTrcRoundedRectangle {
		x       = (screenWidth - width) / 2,
        y       = (screenHeight - height) / 2,
        width   = width,
        height  = height,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(teleportpanel)
	UI:setVisible(teleportpanel, false)
	
	local filterListLabel = UI:createDpLabel {
		x = 10,
		y = 10,
		width = 80,
		height = 0,
		locale = "teleports_filters",
		alignX = "left",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "light"
	}
	UI:addChild(teleportpanel, filterListLabel)
	
	filterListButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(filterListLabel),
        y       = 0,
        width   = 30,
        height  = 30,
		radius = 5,
		color = tocolor(200, 205, 210),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		circle = true,
		fontType = "lightSmall"
	}
    UI:addChild(filterListLabel, filterListButton)
	
	local teleportsList = UI:createDpList {
        x      = 0, 
        y      = UI:getY(filterListButton) + UI:getHeight(filterListButton) + 10,
        width  = width, 
        height = 45 * 11,
		color = tocolor(245,245,245),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20),
		hoverDarkColor = tocolor(40,40,40),
        items  = {},
        columns = {
            { size = 0.60, offset = 0.07, align = "left"  },
            { size = 0.24, alpha  = 0.20, align = "right" },
            { size = 0.15, offset = 0.03, align = "left"  },
        }
    }
    UI:addChild(teleportpanel, teleportsList)
    list = teleportsList
	
	filterListPanel = UI:createTrcRoundedRectangle {
		x       = -220,
        y       = 0,
        width   = 200,
        height  = 265,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20),
		shadow = true
	}
	UI:addChild(teleportpanel, filterListPanel)
	UI:setVisible(filterListPanel, false)
	
	filterListMenu = UI:createDpList {
        x      = 0, 
        y      = 20,
        width  = UI:getWidth(filterListPanel), 
        height = 45 * 5,
		color = tocolor(245,245,245),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20),
		hoverDarkColor = tocolor(40,40,40),
		localeEnable = true,
        items  = filterList,
        columns = {
            { size = 1, offset = 0, align = "center"  },
        }
    }
    UI:addChild(filterListPanel, filterListMenu)
	
	local cancelbuttonHeight = 50
	-- Кнопка отмены
    cancelButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(teleportpanel) - 30,
        y       = 15,
        width   = 15,
        height  = 15,
		radius = 6,
		color = tocolor(225, 0, 0),
		hover = true,
		hoverColor = tocolor(205, 0, 0)
	}
    UI:addChild(teleportpanel, cancelButton)
	
end)

function TeleportsPanel.refresh()
	if filter == "citys" then
		local items = {}
		for i = offset, math.min(#teleports, offset + showCount) do
			local name = teleports[i][1]
			local count = 0
			if i > 3 then
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports[i][2] then
						count = count + 1
					end
				end
			else
				count = "-"
			end
			table.insert(items, {name, exports.tunrc_Lang:getString("overallpanel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	elseif filter == "tracks" then
		local items = {}
		for i = offset, math.min(#teleports1, offset + showCount) do
			local name = teleports1[i][1]
			local count = 0
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports1[i][2] then
						count = count + 1
					end
				end
			table.insert(items, {name, exports.tunrc_Lang:getString("overallpanel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	elseif filter == "mountains" then
		local items = {}
		for i = offset, math.min(#teleports2, offset + showCount) do
			local name = teleports2[i][1]
			local count = 0
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports2[i][2] then
						count = count + 1
					end
				end
			table.insert(items, {name, exports.tunrc_Lang:getString("overallpanel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	elseif filter == "races" then
		local items = {}
		for i = offset, math.min(#teleports3, offset + showCount) do
			local name = teleports3[i][1]
			local count = 0
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports3[i][2] then
						count = count + 1
					end
				end
			table.insert(items, {name, exports.tunrc_Lang:getString("overallpanel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	elseif filter == "fun" then
		local items = {}
		for i = offset, math.min(#teleports4, offset + showCount) do
			local name = teleports4[i][1]
			local count = 0
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports4[i][2] then
						count = count + 1
					end
				end
			table.insert(items, {name, exports.tunrc_Lang:getString("overallpanel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	end
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	local playChange = false
	local playBack = false
	local playSelect = false
	
	if widget == filterListButton then
		UI:setVisible(filterListPanel, not UI:getVisible(filterListPanel))
		playSelect = true
	end
	
	if widget == filterListMenu then
		local items = exports.tunrc_UI:getItems(filterListMenu)
		local selectedItem = exports.tunrc_UI:getActiveItem(filterListMenu)
		for i, button in ipairs(filterList) do
			if items[selectedItem][1] == button[1] then
				filter = button[2]
				offset = 1
				TeleportsPanel.refresh()
			end
		end
		playChange = true
	end
	
	if widget == list then
		if filter == "citys" then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
		elseif filter == "tracks" then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports1) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
		elseif filter == "mountains" then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports2) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
		elseif filter == "races" then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports3) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
		elseif filter == "fun" then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports4) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
		end
		playSelect = true
		TeleportsPanel.hide()
	end
	
	if widget == cancelButton then
        TeleportsPanel.hide()
        exports.tunrc_Sounds:playSound("ui_back.wav")
		setVisible(true)
		playBack = true
    end
	
	if playChange then
        exports.tunrc_Sounds:playSound("ui_change.wav")
    end
	
	if playBack then
        exports.tunrc_Sounds:playSound("ui_back.wav")
    end
	
	if playSelect then
        exports.tunrc_Sounds:playSound("ui_select.wav")
    end
end)

addEventHandler("onClientKey", root, function (button, down)
    if not down then
        return
    end
	if not isVisible then
        return
    end
    if button == "mouse_wheel_up" then
        offset = offset - 1
        if offset < 1 then
            offset = 1
        end
        TeleportsPanel.refresh()
    elseif button == "mouse_wheel_down" then
		if filter == "citys" then
			offset = offset + 1
			if offset + showCount > #teleports then
				offset = #teleports - showCount
			end
		elseif filter == "tracks" then
			offset = offset + 1
			if offset + showCount > #teleports1 then
				offset = #teleports1 - showCount
			end
		elseif filter == "mountains" then
			offset = offset + 1
			if offset + showCount > #teleports2 then
				offset = #teleports2 - showCount
			end
		elseif filter == "races" then
			offset = offset + 1
			if offset + showCount > #teleports3 then
				offset = #teleports3 - showCount
			end
		elseif filter == "fun" then
			offset = offset + 1
			if offset + showCount > #teleports4 then
				offset = #teleports4 - showCount
			end
		end
        TeleportsPanel.refresh()
    end
end)