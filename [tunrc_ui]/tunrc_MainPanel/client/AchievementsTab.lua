AchievementsTab = {}
local panel
local list
local offset = 1
local showCount = 6
local filter = 0

GameplayAchiev = {
    { "all_dp",  "drift_points", 10000000 },
	{ "max_dp_session",  "max_drift_points_session", 5000000},
	{ "all_play_time",  "playtime", 1000 },
}

function AchievementsTab.create()
    panel = Panel.addTab("achievements")
    local width = UI:getWidth(panel)
    local height = UI:getHeight(panel)
	
    local AchievementsList = UI:createDpList {
        x      = 0, 
        y      = height / 2 - 45 * 3.5,
        width  = width, 
        height = 45 * 7,
        items  = {},
		hovertext = " ",
        columns = {
            { size = 0.40, offset = 0.04, align = "left"  },
            { size = 0.24, offset = 0.15, alpha = 0.3, align = "right" },
			{ size = 0.01, offset = 0.16, align = "left"  },
			{ size = 0.15, offset = 0.17, align = "left"  },
        }
    }
    UI:addChild(panel, AchievementsList)
    list = AchievementsList
end

function AchievementsTab.refresh()
local items = {}
	for i = offset, math.min(#GameplayAchiev, offset + showCount) do
		local name = GameplayAchiev[i][1]
		local count = localPlayer:getData(GameplayAchiev[i][2])
		local maxcount = GameplayAchiev[i][3]
		if i == 3 then
			count = math.floor(localPlayer:getData("playtime") / 60 * 10) / 10
		end
		if count < maxcount then
			table.insert(items, {exports.tunrc_Lang:getString("main_panel_achiev_" .. name), count,"/", maxcount})
		else
			table.insert(items, {exports.tunrc_Lang:getString("main_panel_achiev_" .. name), count," "," "})
		end
	end
UI:setItems(list, items)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
end)

addEventHandler("onClientKey", root, function (button, down)
end)