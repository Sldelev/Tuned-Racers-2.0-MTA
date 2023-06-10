TeleportTab = {}
local panel
local list
local offset = 1
local showCount = 6

local teleports = {
    { "Los Santos",  "city_ls" },
    { "San Fierro",  "city_sf" },
    { "Las Venturas",  "city_lv" },
	{ "Red Ring",  "rr" },
	{ "Saint Petersburg",  "spb" },
	{ "Akina Mountain",  "akina" },
	{ "Akagi Mountain",  "akagi" },
	{ "Usui Mountain",  "usui" },
	{ "TsubakiLine Mountain",  "tsu" },
	{ "Ebisu Minami",  "minami" },
	{ "Ebisu West",  "west" },
	{ "Ebisu Higashi",  "higashi" },
	{ "Meihan Course C",  "meihan" },
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
end

function TeleportTab.refresh()
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
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == list then
        local items = exports.tunrc_UI:getItems(list)
        local selectedItem = exports.tunrc_UI:getActiveItem(list)
        for i, teleport in ipairs(teleports) do
            if items[selectedItem][1] == teleport[1] then
                exports.tunrc_Teleports:teleportToMap(teleport[2])
			end
		end
        Panel.setVisible(false)
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
        offset = offset + 1
        if offset + showCount > #teleports then
            offset = #teleports - showCount
        end
        TeleportTab.refresh()
    end
end)