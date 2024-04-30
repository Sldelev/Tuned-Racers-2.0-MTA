SettingsPanel = {}
local screenWidth, screenHeight = UI:getScreenSize()

local panelWidth  = 600
local panelHeight = 500

local ui = {}

local settingsValue = 0
local list
local list1
local list2
local list3
local offset = 1
local showCount = 9

local SettingsButtons = {
    { "settings_panel_interface",  "settings_panel_interface" },
    { "settings_panel_graphics",  "settings_panel_graphics" },
    { "settings_panel_gameplay",  "settings_panel_gameplay" },
    { "settings_panel_sounds",  "settings_panel_sounds" },
}

local InterfaceButtons = {
    { "settings_panel_interface_all_nicknames",  "graphics.nametags"},
    { "settings_panel_interface_self_nickname",  "graphics.self_nametags"},
    { "settings_panel_interface_driftpoints",  "ui.draw_points"},
    { "settings_panel_interface_speedo",  "ui.draw_speedo"},
	{ "settings_panel_interface_chat",  "ui.draw_chat"},
    { "settings_panel_interface_radar_rotate",  "ui.radar_rotate"},
    { "settings_panel_interface_show_fps",  "ui.show_fps"},
    { "settings_panel_interface_join_message",  "chat.joinquit_messages"},
    { "settings_panel_interface_send_time",  "chat.timestamp"},
    { "settings_panel_interface_blur",  "ui.blur"},
}

local GraphicsButtons = {
    { "settings_panel_graphics_improved_sky",  "graphics.improved_sky"},
    { "settings_panel_graphics_wetroad",  "graphics.wetroad"},
    { "settings_panel_graphics_tyres_smoke",  "graphics.tyres_smoke"},
    { "settings_panel_graphics_ssao",  "graphics.ssao"},
	{ "settings_panel_graphics_ssao_quality",  "graphics.ssao_quality"},
    { "settings_panel_graphics_fxaa",  "graphics.fxaa"},
	{ "settings_panel_graphics_wraps_quality",  "graphics.wraps_quality"},
	{ "settings_panel_graphics_textures_quality",  "graphics.textures_quality"},
	{ "settings_panel_graphics_rain_drops",  "graphics.rain_drops"},
	{ "settings_panel_graphics_improved_lights",  "graphics.improved_car_lights"},
}

local GameplayButtons = {
    { "settings_panel_gameplay_coll",  "game.coll"},
    { "settings_panel_gameplay_smooth_steering",  "graphics.smooth_steering"},
}

local SoundButtons = {
    { "settings_panel_sound_garage_music",  "game.background_music"},
    { "settings_panel_sound_garage_music_volume",  "sounds.background_music_volume"},
    { "settings_panel_sound_car_sounds_volume",  "sounds.car_sounds_volume"},
}

local isVisible = false

function SettingsPanel.show()
    if isVisible then
        return false
    end
	Panel.setVisible(false)
	SettingsPanel.refresh()
    isVisible = true
    exports.tunrc_HUD:setVisible(false)
    exports.tunrc_UI:fadeScreen(true)
    showCursor(true)
    UI:setVisible(ui.panel, true)
    localPlayer:setData("activeUI", "settingsPanel")
	
end

function SettingsPanel.hide()
    if not isVisible then
        return false
    end
    isVisible = false
    exports.tunrc_HUD:setVisible(true)
    exports.tunrc_UI:fadeScreen(false)
    showCursor(false)
    UI:setVisible(ui.panel, false)
    localPlayer:setData("activeUI", false)
	
	UI:setVisible(ui.InterfacePanel, false)
	UI:setVisible(ui.GraphicsPanel, false)
	UI:setVisible(ui.GameplayPanel, false)
	UI:setVisible(ui.SoundsPanel, false)
end

function SettingsPanel.create()
	ui.panel = UI:createTrcRoundedRectangle {
		x       = (screenWidth  - panelWidth)  / 2,
        y       = (screenHeight - panelHeight) / 2,
        width   = panelWidth,
        height  = panelHeight,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
    UI:addChild(ui.panel)
	UI:setVisible(ui.panel, false)
	
	ui.sidePanel = UI:createTrcRoundedRectangle {
		x       = 10,
        y       = 10,
        width   = 200,
        height  = panelHeight - 20,
		radius = 20,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40),
		shadow = true
	}
    UI:addChild(ui.panel, ui.sidePanel)
	
	-- Кнопка отмены
    ui.cancelButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(ui.panel) - 30,
        y       = 10,
        width   = 15,
        height  = 15,
		radius = 6,
		color = tocolor(225, 0, 0),
		hover = true,
		hoverColor = tocolor(205, 0, 0)
	}
    UI:addChild(ui.panel, ui.cancelButton)
	
	ui.settingsButtonsList = UI:createDpList {
        x      = 0, 
        y      = 15,
        width  = 200, 
        height = 45 * 9,
		color = tocolor(235,235,235),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(40,40,40),
		hoverDarkColor = tocolor(20,20,20),
		localeEnable = true,
        items  = SettingsButtons,
        columns = {
            { size = 1, offset = 0, align = "center"  },
        }
    }
    UI:addChild(ui.sidePanel, ui.settingsButtonsList)
	
	local InterfacePanelWidth = panelWidth - UI:getWidth(ui.sidePanel) - UI:getX(ui.sidePanel)
	
	-- Панелька интерфейса
	ui.InterfacePanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(ui.sidePanel),
        y       = 15,
        width   = InterfacePanelWidth,
        height  = 45,
		radius = 0,
		color = tocolor(245, 0, 0, 0)
	}
    UI:addChild(ui.sidePanel, ui.InterfacePanel)
	UI:setVisible(ui.InterfacePanel, false)
	
	ui.InterfaceButtonsList = UI:createDpList {
        x      = 0, 
        y      = 0,
        width  = InterfacePanelWidth, 
        height = 45 * 10,
		color = tocolor(225, 225, 225),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(30,30,30),
		hoverDarkColor = tocolor(40,40,40),
		localeEnable = true,
        items  = {},
        columns = {
            { size = 0.85, offset = 0.05, align = "left"  },
            { size = 0.15, offset = -0.05, align = "right"  },
        }
    }
    UI:addChild(ui.InterfacePanel, ui.InterfaceButtonsList)
	
	-- Панелька графики
	ui.GraphicsPanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(ui.sidePanel),
        y       = 15,
        width   = InterfacePanelWidth,
        height  = 45,
		radius = 0,
		color = tocolor(245, 0, 0, 0)
	}
    UI:addChild(ui.sidePanel, ui.GraphicsPanel)
	UI:setVisible(ui.GraphicsPanel, false)
	
	ui.GraphicsButtonsList = UI:createDpList {
        x      = 0, 
        y      = 0,
        width  = InterfacePanelWidth, 
        height = 45 * 10,
		color = tocolor(225, 225, 225),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(30,30,30),
		hoverDarkColor = tocolor(40,40,40),
		localeEnable = true,
        items  = {},
        columns = {
            { size = 0.85, offset = 0.05, align = "left"  },
            { size = 0.15, offset = -0.05, align = "right"  },
        }
    }
    UI:addChild(ui.GraphicsPanel, ui.GraphicsButtonsList)
	
	-- Панелька геймплея
	ui.GameplayPanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(ui.sidePanel),
        y       = 15,
        width   = InterfacePanelWidth,
        height  = 45,
		radius = 0,
		color = tocolor(245, 0, 0, 0)
	}
    UI:addChild(ui.sidePanel, ui.GameplayPanel)
	UI:setVisible(ui.GameplayPanel, false)
	
	ui.GameplayButtonsList = UI:createDpList {
        x      = 0, 
        y      = 0,
        width  = InterfacePanelWidth, 
        height = 45 * 10,
		color = tocolor(225, 225, 225),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(30,30,30),
		hoverDarkColor = tocolor(40,40,40),
		localeEnable = true,
        items  = GameplayButtons,
        columns = {
            { size = 0.85, offset = 0.05, align = "left"  },
            { size = 0.15, offset = -0.05, align = "right"  },
        }
    }
    UI:addChild(ui.GameplayPanel, ui.GameplayButtonsList)
	
	-- Панелька звуков
	ui.SoundPanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(ui.sidePanel),
        y       = 15,
        width   = InterfacePanelWidth,
        height  = 45,
		radius = 0,
		color = tocolor(245, 0, 0, 0)
	}
    UI:addChild(ui.sidePanel, ui.SoundPanel)
	UI:setVisible(ui.SoundPanel, false)
	
	ui.SoundButtonsList = UI:createDpList {
        x      = 0, 
        y      = 0,
        width  = InterfacePanelWidth, 
        height = 45 * 10,
		color = tocolor(225, 225, 225),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(30,30,30),
		hoverDarkColor = tocolor(40,40,40),
		localeEnable = true,
        items  = SoundButtons,
        columns = {
            { size = 0.85, offset = 0.05, align = "left"  },
            { size = 0.15, offset = -0.05, align = "right"  },
        }
    }
    UI:addChild(ui.SoundPanel, ui.SoundButtonsList)
	
end
addEventHandler("onClientResourceStart", resourceRoot, SettingsPanel.create)

function SettingsPanel.refresh()
	if UI:getVisible(ui.InterfacePanel) == true then
		list = ui.InterfaceButtonsList
		local items = {}
		for i = offset, math.min(#InterfaceButtons, offset + showCount) do
			local name = InterfaceButtons[i][1]
			local state = exports.tunrc_Lang:getString("ui_shared_" .. tostring(exports.tunrc_Config:getProperty(InterfaceButtons[i][2])))
			table.insert(items, {name, state})
		end
		UI:setItems(list, items)
	elseif UI:getVisible(ui.GraphicsPanel) == true then
		list1 = ui.GraphicsButtonsList
		local items = {}
		for i = offset, math.min(#GraphicsButtons, offset + showCount) do
			local name = GraphicsButtons[i][1]
			local state = exports.tunrc_Lang:getString("ui_shared_" .. tostring(exports.tunrc_Config:getProperty(GraphicsButtons[i][2])))
			table.insert(items, {name, state})
		end
		UI:setItems(list1, items)
	elseif UI:getVisible(ui.GameplayPanel) == true then
		list2 = ui.GameplayButtonsList
		local items = {}
		for i = offset, math.min(#GameplayButtons, offset + showCount) do
			local name = GameplayButtons[i][1]
			local state = exports.tunrc_Lang:getString("ui_shared_" .. tostring(exports.tunrc_Config:getProperty(GameplayButtons[i][2])))
			table.insert(items, {name, state})
		end
		UI:setItems(list2, items)
	elseif UI:getVisible(ui.SoundPanel) == true then
		list3 = ui.SoundButtonsList
		local items = {}
		for i = offset, math.min(#SoundButtons, offset + showCount) do
			local name = SoundButtons[i][1]
			if name == SoundButtons[2][1] or name == SoundButtons[3][1] then
				state = exports.tunrc_Config:getProperty(SoundButtons[i][2])
			else
				state = exports.tunrc_Lang:getString("ui_shared_" .. tostring(exports.tunrc_Config:getProperty(SoundButtons[i][2])))
			end
			table.insert(items, {name, state})
		end
		UI:setItems(list3, items)
	end
	UIDataBinder.refresh()
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	local playChange = false
	local playBack = false
	local playSelect = false

    if widget == ui.cancelButton then
		SettingsPanel.hide()
		exports.tunrc_overallPanel:setVisible(true)
		playBack = true
	end
	
	if widget == ui.settingsButtonsList then
		local items = exports.tunrc_UI:getItems(ui.settingsButtonsList)
		local selectedItem = exports.tunrc_UI:getActiveItem(ui.settingsButtonsList)
		for i, button in ipairs(SettingsButtons) do
			if items[selectedItem][1] == button[1] then
				if button[1] == "settings_panel_interface" then
					UI:setVisible(ui.SoundPanel, false)
					UI:setVisible(ui.GameplayPanel, false)
					UI:setVisible(ui.GraphicsPanel, false)
					UI:setVisible(ui.InterfacePanel, true)
				elseif button[1] == "settings_panel_graphics" then
					UI:setVisible(ui.SoundPanel, false)
					UI:setVisible(ui.GameplayPanel, false)
					UI:setVisible(ui.InterfacePanel, false)
					UI:setVisible(ui.GraphicsPanel, true)
				elseif button[1] == "settings_panel_gameplay" then
					UI:setVisible(ui.SoundPanel, false)
					UI:setVisible(ui.InterfacePanel, false)
					UI:setVisible(ui.GraphicsPanel, false)
					UI:setVisible(ui.GameplayPanel, true)
				elseif button[1] == "settings_panel_sounds" then
					UI:setVisible(ui.InterfacePanel, false)
					UI:setVisible(ui.GraphicsPanel, false)
					UI:setVisible(ui.GameplayPanel, false)
					UI:setVisible(ui.SoundPanel, true)
				end
				offset = 1
			end
		end
		playSelect = true
	end
	
	if widget == ui.InterfaceButtonsList then
		local items = exports.tunrc_UI:getItems(ui.InterfaceButtonsList)
		local selectedItem = exports.tunrc_UI:getActiveItem(ui.InterfaceButtonsList)
		for i, button in ipairs(InterfaceButtons) do
			if items[selectedItem][1] == button[1] then
				exports.tunrc_Config:setProperty(button[2], not exports.tunrc_Config:getProperty(button[2]))
			end
		end
		playChange = true
	elseif widget == ui.GraphicsButtonsList then
		local items = exports.tunrc_UI:getItems(ui.GraphicsButtonsList)
		local selectedItem = exports.tunrc_UI:getActiveItem(ui.GraphicsButtonsList)
		for i, button in ipairs(GraphicsButtons) do
			if items[selectedItem][1] == button[1] then
				if i == 5 then
					if exports.tunrc_Config:getProperty("graphics.ssao_quality") == 0 then
						exports.tunrc_Config:setProperty("graphics.ssao_quality", 1)
					elseif exports.tunrc_Config:getProperty("graphics.ssao_quality") == 1 then
						exports.tunrc_Config:setProperty("graphics.ssao_quality", 2)
					elseif exports.tunrc_Config:getProperty("graphics.ssao_quality") == 2 then
						exports.tunrc_Config:setProperty("graphics.ssao_quality", 3)
					else
						exports.tunrc_Config:setProperty("graphics.ssao_quality", 0)
					end
				elseif i == 7 then
					if exports.tunrc_Config:getProperty("graphics.wraps_quality") == 0 then
						exports.tunrc_Config:setProperty("graphics.wraps_quality", 1)
					elseif exports.tunrc_Config:getProperty("graphics.wraps_quality") == 1 then
						exports.tunrc_Config:setProperty("graphics.wraps_quality", 2)
					elseif exports.tunrc_Config:getProperty("graphics.wraps_quality") == 2 then
						exports.tunrc_Config:setProperty("graphics.wraps_quality", 3)
					else
						exports.tunrc_Config:setProperty("graphics.wraps_quality", 0)
					end
				elseif i == 8 then
					if exports.tunrc_Config:getProperty("graphics.textures_quality") == 0 then
						exports.tunrc_Config:setProperty("graphics.textures_quality", 1)
					elseif exports.tunrc_Config:getProperty("graphics.textures_quality") == 1 then
						exports.tunrc_Config:setProperty("graphics.textures_quality", 2)
					else
						exports.tunrc_Config:setProperty("graphics.textures_quality", 0)
					end
				else
					exports.tunrc_Config:setProperty(button[2], not exports.tunrc_Config:getProperty(button[2]))
				end
			end
		end
		playChange = true
	elseif widget == ui.GameplayButtonsList then
		local items = exports.tunrc_UI:getItems(ui.GameplayButtonsList)
		local selectedItem = exports.tunrc_UI:getActiveItem(ui.GameplayButtonsList)
		for i, button in ipairs(GameplayButtons) do
			if items[selectedItem][1] == button[1] then
				exports.tunrc_Config:setProperty(button[2], not exports.tunrc_Config:getProperty(button[2]))
			end
		end
		playChange = true
	elseif widget == ui.SoundButtonsList then
		local items = exports.tunrc_UI:getItems(ui.SoundButtonsList)
		local selectedItem = exports.tunrc_UI:getActiveItem(ui.SoundButtonsList)
		for i, button in ipairs(SoundButtons) do
			if items[selectedItem][1] == button[1] then
				if i == 2 then
					if exports.tunrc_Config:getProperty("sounds.background_music_volume") == 200 then
						exports.tunrc_Config:setProperty("sounds.background_music_volume", 0)
					else
						exports.tunrc_Config:setProperty("sounds.background_music_volume", exports.tunrc_Config:getProperty("sounds.background_music_volume") + 5)
					end
				elseif i == 3 then
					if exports.tunrc_Config:getProperty("sounds.car_sounds_volume") == 200 then
						exports.tunrc_Config:setProperty("sounds.car_sounds_volume", 0)
					else
						exports.tunrc_Config:setProperty("sounds.car_sounds_volume", exports.tunrc_Config:getProperty("sounds.car_sounds_volume") + 5)
					end
				else
					exports.tunrc_Config:setProperty(button[2], not exports.tunrc_Config:getProperty(button[2]))
				end
			end
		end
		playChange = true
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
	
	SettingsPanel.refresh()
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
        SettingsPanel.refresh()
    elseif button == "mouse_wheel_down" then
		if UI:getVisible(ui.SoundPanel) == true then
			offset = offset + 1
			if offset + showCount > #SoundButtons then
				offset = #SoundButtons - showCount
			end
		elseif UI:getVisible(ui.InterfacePanel) == true then
			offset = offset + 1
			if offset + showCount > #InterfaceButtons then
				offset = #InterfaceButtons - showCount
			end
		elseif UI:getVisible(ui.GraphicsPanel) == true then
			offset = offset + 1
			if offset + showCount > #GraphicsButtons then
				offset = #GraphicsButtons - showCount
			end
		elseif UI:getVisible(ui.GameplayPanel) == true then
			offset = offset + 1
			if offset + showCount > #GameplayButtons then
				offset = #GameplayButtons - showCount
			end
		end
        SettingsPanel.refresh()
    end
end)