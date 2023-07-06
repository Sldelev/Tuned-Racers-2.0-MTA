TeleportTab = {}
local panel
local list
local offset = 1
local showCount = 6
local filter = 0

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
	{ "Irohasaka",  "iro" },
	{ "Myogi",  "myogi" },
	{ "Nagao",  "nagao" },
	{ "Nanohanadai",  "nano" },
	{ "Tsukuba",  "tsukuba" },
}

local teleports3 = {
	{ "Long Drift LS",  "d1" },
	{ "Long Drift LV 1",  "d2" },
	{ "Long Drift LV 2",  "d3" },
	{ "Long Drift Atron 1",  "d4" },
}

function TeleportTab.create()
    panel = Panel.addTab("teleport")
    local width = UI:getWidth(panel)
    local height = UI:getHeight(panel)

    local teleportsList = UI:createDpList {
        x      = 0, 
        y      = height / 2 - 45 * 3.5,
        width  = width, 
        height = 45 * 7,
        items  = {},
        columns = {
            { size = 0.60, offset = 0.07, align = "left"  },
            { size = 0.24, alpha  = 0.20, align = "right" },
            { size = 0.15, offset = 0.03, align = "left"  },
        }
    }
    UI:addChild(panel, teleportsList)
    list = teleportsList
	
	y = 325
	CityButton = UI:createDpButton {
        x      = width + 10,
        y      = height - y,
        width  = width / 3,
        height = 50,
        locale = "main_panel_teleport_city",
        type   = "primary"
    }
    UI:addChild(panel, CityButton)
	
	y = y - 50
	TracksButton = UI:createDpButton {
        x      = width + 10,
        y      = height - y,
        width  = width / 3,
        height = 50,
        locale = "main_panel_teleport_tracks",
        type   = "primary"
    }
    UI:addChild(panel, TracksButton)
	
	y = y - 50
	MountButton = UI:createDpButton {
        x      = width + 10,
        y      = height - y,
        width  = width / 3,
        height = 50,
        locale = "main_panel_teleport_mount",
        type   = "primary"
    }
    UI:addChild(panel, MountButton)
	
	y = y - 50
	RaceButton = UI:createDpButton {
        x      = width + 10,
        y      = height - y,
        width  = width / 3,
        height = 50,
        locale = "main_panel_teleport_race",
        type   = "primary"
    }
    UI:addChild(panel, RaceButton)
end

function TeleportTab.refresh()
	if filter == 0 then
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
			table.insert(items, {name, exports.tunrc_Lang:getString("main_panel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	elseif filter == 1 then
		local items = {}
		for i = offset, math.min(#teleports1, offset + showCount) do
			local name = teleports1[i][1]
			local count = 0
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports1[i][2] then
						count = count + 1
					end
				end
			table.insert(items, {name, exports.tunrc_Lang:getString("main_panel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	elseif filter == 2 then
		local items = {}
		for i = offset, math.min(#teleports2, offset + showCount) do
			local name = teleports2[i][1]
			local count = 0
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports2[i][2] then
						count = count + 1
					end
				end
			table.insert(items, {name, exports.tunrc_Lang:getString("main_panel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	elseif filter == 3 then
		local items = {}
		for i = offset, math.min(#teleports3, offset + showCount) do
			local name = teleports3[i][1]
			local count = 0
				for j, player in ipairs(getElementsByType("player")) do
					if string.lower(tostring(player:getData("activeMap"))) == teleports3[i][2] then
						count = count + 1
					end
				end
			table.insert(items, {name, exports.tunrc_Lang:getString("main_panel_teleport_players") .. ":", count})
		end
		UI:setItems(list, items)
	end
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	if widget == CityButton then
		filter = 0
		offset = 1
		TeleportTab.refresh()
	elseif widget == TracksButton then
		filter = 1
		offset = 1
		TeleportTab.refresh()
	elseif widget == MountButton then
		filter = 2
		offset = 1
		TeleportTab.refresh()
	elseif widget == RaceButton then
		filter = 3
		offset = 1
		TeleportTab.refresh()
	end
	
	if widget == list then
		if filter == 0 then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
			Panel.setVisible(false)
		elseif filter == 1 then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports1) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
			Panel.setVisible(false)
		elseif filter == 2 then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports2) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
			Panel.setVisible(false)
		elseif filter == 3 then
			local items = exports.tunrc_UI:getItems(list)
			local selectedItem = exports.tunrc_UI:getActiveItem(list)
			for i, teleport in ipairs(teleports3) do
				if items[selectedItem][1] == teleport[1] then
					exports.tunrc_Teleports:teleportToMap(teleport[2])
				end
			end
			Panel.setVisible(false)
		end
	end
end)

addEventHandler("onClientKey", root, function (button, down)
    if not down then
        return
    end
    if not Panel.isVisible() or Panel.getCurrentTab() ~= "teleport" then
        return
    end
    if button == "mouse_wheel_up" then
        offset = offset - 1
        if offset < 1 then
            offset = 1
        end
        TeleportTab.refresh()
    elseif button == "mouse_wheel_down" then
		if filter == 0 then
			offset = offset + 1
			if offset + showCount > #teleports then
				offset = #teleports - showCount
			end
		elseif filter == 1 then
			offset = offset + 1
			if offset + showCount > #teleports1 then
				offset = #teleports1 - showCount
			end
		elseif filter == 2 then
			offset = offset + 1
			if offset + showCount > #teleports2 then
				offset = #teleports2 - showCount
			end
		elseif filter == 3 then
			offset = offset + 1
			if offset + showCount > #teleports3 then
				offset = #teleports3 - showCount
			end
		end
        TeleportTab.refresh()
    end
end)