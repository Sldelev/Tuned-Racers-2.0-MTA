MusicPanel = {}
local width = 550
local height = 600
local musicpanel

local musicCount 

local title, artist

local EqualizeSticks = {
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
	{"1"},
}

local offset = 1
local showCount = 9

local TracksList = {
	{ "Bregma feat. Jahmed - Dolemite",  "1" },
	{ "Burgos feat. Bearded Legend - Psychopatic Lunatic",  "2" },
	{ "Maru Nara - Thundawind",  "3" },
	{ "Shakewell - Leglock",  "4" },
	{ "Makaveligodd - Glacier pack",  "5" },
	{ "Curtis Damage - Zoom",  "6" },
	{ "TrippyThaKid feat. ZCR - Hotbox Johnny",  "7" },
	{ "Shakewell - 5 ways",  "8" },
	{ "Maru Nara feat. Akimato - Misfits",  "9" },
	{ "Freddie Dredd - WATCH YA TONE",  "10" },
	{ "Freddie Dredd - Wrath",  "11" },
	{ "Freddie Dredd - Devil's Work",  "12" },
	{ "Freddie Dredd - Busy",  "13" },
	{ "Freddie Dredd - Gettin buck",  "14" },
}

function MusicPanel.create()
    if musicpanel then
        return false
    end
	
	-- Assets
	
	ArrowTexture = exports.tunrc_Assets:createTexture("arrow.png")
	
	-- ОСНОВНАЯ ПАНЕЛЬ
	
	musicpanel = UI:createTrcRoundedRectangle {
		x       = (screenWidth - width) / 2,
        y       = (screenHeight - height) / 2,
        width   = width,
        height  = height - 50,
		radius = 20,
		color = tocolor(245, 245, 245),
		darkToggle = true,
		darkColor = tocolor(20, 20, 20)
	}
	UI:addChild(musicpanel)
	UI:setVisible(musicpanel, false)
	
	-- Кнопка закрытия панели
	Closebutton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(musicpanel) - 30,
        y       = 15,
        width   = 15,
        height  = 15,
		radius = 6,
		color = tocolor(225, 0, 0),
		hover = true,
		hoverColor = tocolor(205, 0, 0)
	}
	UI:addChild(musicpanel, Closebutton)
	
	local TrackPanel = UI:createTrcRoundedRectangle {
		x       = 25,
        y       = 50,
        width   = 250,
        height  = 250,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40),
		shadow = true
	}
	UI:addChild(musicpanel, TrackPanel)
	
	TrackEqualBack = UI:createTrcRoundedRectangle {
		x       = 12.5,
        y       = UI:getHeight(TrackPanel) - 130,
        width   = 225,
        height  = 4,
		radius = 0,
		color = tocolor(150, 150, 150),
	}
	UI:addChild(TrackPanel, TrackEqualBack)
	
	TrackEqual = UI:createTrcRoundedRectangle {
		x       = 0,
        y       = 0,
        width   = 0,
        height  = 4,
		radius = 0,
		color = tocolor(130, 130, 200)
	}
	UI:addChild(TrackEqualBack, TrackEqual)
	
	for i, s in ipairs(EqualizeSticks) do
		s.TrackEqualVisual = UI:createTrcRoundedRectangle {
			x       = 3 + (i * 7),
			y       = -10,
			width   = 2,
			height  = 10,
			radius = 0,
			color = tocolor(130, 130, 200)
		}
		UI:addChild(TrackEqual, s.TrackEqualVisual)
	end
	
	
	StopButton = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(TrackPanel) / 2 - 20,
        y       = UI:getHeight(TrackPanel) - 110,
        width   = 40,
        height  = 40,
		radius = 20,
		color = tocolor(215, 215, 215),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true,
		circle = true
	}
	UI:addChild(TrackPanel, StopButton)
	
	NextButton = UI:createTrcRoundedRectangle {
		x       = 60,
        y       = 0,
        width   = 40,
        height  = 40,
		radius = 20,
		color = tocolor(215, 215, 215),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true
	}
	UI:addChild(StopButton, NextButton)
	
	NextButtonImage = UI:createImage {
		x = 8,
		y = 8,
		width = 24,
		height = 24,
		rotation = 180,
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		texture = ArrowTexture
	}
	UI:addChild(NextButton, NextButtonImage)
	
	PrevButton = UI:createTrcRoundedRectangle {
		x       = -60,
        y       = 0,
        width   = 40,
        height  = 40,
		radius = 20,
		color = tocolor(215, 215, 215),
		hover = true,
		hoverColor = tocolor(225, 225, 225),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true
	}
	UI:addChild(StopButton, PrevButton)
	
	PrevButtonImage = UI:createImage {
		x = 8,
		y = 8,
		width = 24,
		height = 24,
		color = tocolor(0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		texture = ArrowTexture
	}
	UI:addChild(PrevButton, PrevButtonImage)
	
	ArtistLabel = UI:createDpLabel {
		x = UI:getWidth(TrackPanel) / 2,
		y = UI:getHeight(TrackPanel) - 50,
		width = 0,
		height = 0,
		text = "Artist",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "light"
	}
	UI:addChild(TrackPanel, ArtistLabel)
	
	TitleLabel = UI:createDpLabel {
		x = 0,
		y = 25,
		width = 0,
		height = 0,
		text = "Artist",
		alignX = "center",
		alignY = "center",
		color = tocolor (20, 20, 20),
		darkToggle = true,
		darkColor = tocolor(205, 205, 205),
		fontType = "lightSmall"
	}
	UI:addChild(ArtistLabel, TitleLabel)
	
	local TrackListPanel = UI:createTrcRoundedRectangle {
		x       = UI:getWidth(TrackPanel) + 25,
        y       = 0,
        width   = 225,
        height  = 475,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40),
		shadow = true
	}
	UI:addChild(TrackPanel, TrackListPanel)
	
	TrackList = UI:createDpList {
        x      = 0, 
        y      = 14.5,
        width  = 225, 
        height = 45 * 10,
		color = tocolor(235,235,235),
		hoverColor = tocolor(205,205,205),
		darkToggle = true,
		darkColor = tocolor(40,40,40),
		hoverDarkColor = tocolor(20,20,20),
		localeEnable = true,
        items  = {},
        columns = {
            { size = 1, offset = 0, align = "center"  },
        }
    }
    UI:addChild(TrackListPanel, TrackList)
	list = TrackList
	
	local MusicSettingsPanel = UI:createTrcRoundedRectangle {
		x       = 0,
        y       = UI:getHeight(TrackPanel) + 25,
        width   = 250,
        height  = 200,
		radius = 15,
		color = tocolor(235, 235, 235),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40),
		shadow = true
	}
	UI:addChild(TrackPanel, MusicSettingsPanel)
	
	MusicVolumePanel = UI:createTrcRoundedRectangle {
		x       = 0,
        y       = 15,
        width   = 250,
        height  = 45,
		radius = 0,
		darkToggle = true,
		hover = true,
		color = tocolor(235,235,235),
		darkColor = tocolor(40,40,40),
		hoverDarkColor = tocolor(20,20,20),
		hoverColor = tocolor(205,205,205)
	}
	UI:addChild(MusicSettingsPanel, MusicVolumePanel)
	
	local MusicVolumeLabel = UI:createDpLabel {
		x = 10,
		y = UI:getHeight(MusicVolumePanel) / 2,
		width = 0,
		height = 0,
		locale = "world_music_panel_volume",
		alignX = "left",
		alignY = "center",
		color = tocolor (20, 20, 20),
		darkToggle = true,
		darkColor = tocolor(205, 205, 205),
		fontType = "lightSmall"
	}
	UI:addChild(MusicVolumePanel, MusicVolumeLabel)
	
	MusicVolumeValue = UI:createDpLabel {
		x = UI:getWidth(MusicVolumePanel) - 35,
		y = UI:getHeight(MusicVolumePanel) / 2,
		width = 0,
		height = 0,
		text = "100",
		alignX = "left",
		alignY = "center",
		color = tocolor (20, 20, 20),
		darkToggle = true,
		darkColor = tocolor(205, 205, 205),
		fontType = "lightSmall"
	}
	UI:addChild(MusicVolumePanel, MusicVolumeValue)
end
addEventHandler( "onClientResourceStart", getRootElement( ), MusicPanel.create)

function MusicPanel.refresh()
	local musicCount = getWorldMusicCount()
	
	local musicvolume = exports.tunrc_Config:getProperty("sounds.world_music_volume")
	UI:setText(MusicVolumeValue, musicvolume)

	local CurrentTrack = getCurrentMusic()
	if CurrentTrack == nil then
			UI:setText(ArtistLabel, "---")
			UI:setText(TitleLabel, "---")
		return
	end
	
	local metaTags = CurrentTrack:getMetaTags()
	if metaTags.title and metaTags.artist then
		title, artist = metaTags.title, metaTags.artist
	end	
	UI:setText(ArtistLabel, artist)
	UI:setText(TitleLabel, title)
	
	local fullLenght = getSoundLength(CurrentTrack)
	local currentLenght = getSoundPosition(CurrentTrack)

	local progress = currentLenght / fullLenght
	
	local endLenght = UI:getWidth(TrackEqualBack)
	UI:setWidth(TrackEqual, endLenght * progress)

	local soundEqualize = CurrentTrack:getFFTData ( 4096, 31 )
	
	if (soundEqualize) and type(soundEqualize) == "table" then
		for i, s in ipairs(EqualizeSticks) do
			UI:setHeight(s.TrackEqualVisual, -math.sqrt(soundEqualize[i]) * 60)
		end
	end
end
function MusicPanel.refreshTrackList()
	local items = {}
	for i = offset, math.min(#TracksList, offset + showCount) do
		local name = TracksList[i][1]
		table.insert(items, {name})
	end
	UI:setItems(list, items)
end

function setVisible(visible)
    visible = not not visible
    if UI:getVisible(musicpanel) == visible then
        return
    end
    if not musicpanel then
        return false
    end
    if visible then
        if not localPlayer:getData("username") or localPlayer:getData("tunrc_Core.state") then
            return false
        end
        if localPlayer:getData("activeUI") then
            return false
        end
        localPlayer:setData("activeUI", "MusicPanel")
		exports.tunrc_Sounds:playSound("ui_swipe.wav")
		addEventHandler("onClientRender", root, MusicPanel.refresh)
    else
        localPlayer:setData("activeUI", false)
		removeEventHandler("onClientRender", root, MusicPanel.refresh)
    end

	exports.tunrc_UI:fadeScreen(visible)
	exports.tunrc_HUD:setRadarVisible(not visible)
	exports.tunrc_Chat:setVisible((exports.tunrc_Config:getProperty("ui.draw_chat")))
	exports.tunrc_HUD:setSpeedometerVisible(exports.tunrc_Config:getProperty("ui.draw_speedo"))

	MusicPanel.refreshTrackList()
    UI:setVisible(musicpanel, visible)
	showCursor(visible)
end

function isVisible()
    return UI:getVisible(musicpanel)
end

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
	local isMusicEnable = exports.tunrc_Config:getProperty("game.world_music")
	local playChange = false
	local playBack = false
	local playSelect = false
	local playError = false

    if widget == Closebutton then
		playBack = true
		setVisible(false)
		exports.tunrc_overallpanel:setVisible(true)
	elseif widget == StopButton then
		playChange = true
		exports.tunrc_Config:setProperty("game.world_music", not isMusicEnable)
	elseif widget == NextButton or widget == NextButtonImage then
		playSelect = true
		playNextTrack()
	elseif widget == PrevButton or widget == PrevButtonImage then
		playSelect = true
		playPrevTrack()
	elseif widget == MusicVolumePanel then
		if exports.tunrc_Config:getProperty("sounds.world_music_volume") == 200 then
			exports.tunrc_Config:setProperty("sounds.world_music_volume", 0)
		else
			exports.tunrc_Config:setProperty("sounds.world_music_volume", exports.tunrc_Config:getProperty("sounds.world_music_volume") + 5)
		end
		playChange = true
	end
	
	if widget == list then
		playSelect = true
		exports.tunrc_Config:setProperty("game.world_music", true)
		local items = exports.tunrc_UI:getItems(list)
		local selectedItem = exports.tunrc_UI:getActiveItem(list)
		for i, track in ipairs(TracksList) do
			if items[selectedItem][1] == track[1] then
				playTrack(track[2])
			end
		end
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
	
	if playError then
        exports.tunrc_Sounds:playSound("error.wav")
    end
end)

bindKey("backspace", "down", function ()
	setVisible(false)
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
        MusicPanel.refreshTrackList()
    elseif button == "mouse_wheel_down" then
		offset = offset + 1
		if offset + showCount > #TracksList then
			offset = #TracksList - showCount
		end
		MusicPanel.refreshTrackList()
    end
end)