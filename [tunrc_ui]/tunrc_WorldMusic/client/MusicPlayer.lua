MusicPlayer = {}
local TRACKS_COUNT = 14

local currentTrack = 1
local sound
local soundVolume = 0
local soundVolumeSpeed = 5

local screenSize = Vector2(guiGetScreenSize())

local TRACK_INFO_SHOW_TIME = 4000
local TRACK_INFO_RIGHT_OFFSET = 300
local TRACK_INFO_BOTTOM_OFFSET = 200
local TRACK_INFO_HEIGHT = 80

local trackInfo = false
local trackInfoTimer
local trackInfoAnimAlpha = 0.0
local trackInfoAnimTarget = 0.0
local trackInfoAnimState

function getWorldMusicCount()
	return TRACKS_COUNT
end

local function hideTrackInfo(animate)
    if isTimer(trackInfoTimer) then
        trackInfoTimer:destroy()
    end
    if animate then
        trackInfoAnimState = "fadeout"
        trackInfoAnimAlpha = 1.0
    else
        trackInfo = false
        trackInfoAnimState = nil
        trackInfoAnimAlpha = 0.0
    end
    trackInfoAnimTarget = 0
end

local function showTrackInfo(animate)
    trackInfo = true
    if isTimer(trackInfoTimer) then
        trackInfoTimer:destroy()
    end
    trackInfoTimer = Timer(function ()
        hideTrackInfo(true)
    end, TRACK_INFO_SHOW_TIME, 1)
    trackInfoAnimTarget = 1.0
    if animate then
        trackInfoAnimState = "fadein"
        trackInfoAnimAlpha = 0.0
    else
        trackInfoAnimState = nil
        trackInfoAnimAlpha = 1.0
    end
end

function playNextTrack()
    if not exports.tunrc_Config:getProperty("game.world_music") then
        return
    end
    currentTrack = (currentTrack % TRACKS_COUNT) + 1
    if isElement(sound) then
        destroyElement(sound)
    end
    sound = playSound("music/" .. tostring(currentTrack) .. ".ogg", false)
    sound:setEffectEnabled("reverb", false)
	sound:setPlaybackPosition(0)
    showTrackInfo(true)
end

function playPrevTrack()
    if not exports.tunrc_Config:getProperty("game.world_music") then
        return
    end
    currentTrack = (currentTrack % TRACKS_COUNT) - 1
    if isElement(sound) then
        destroyElement(sound)
    end
    sound = playSound("music/" .. tostring(currentTrack) .. ".ogg", false)
    sound:setEffectEnabled("reverb", false)
	sound:setPlaybackPosition(0)
    showTrackInfo(true)
end

function playTrack(tracknumber)
    if not exports.tunrc_Config:getProperty("game.world_music") then
        return
    end
    currentTrack = tracknumber
    if isElement(sound) then
        destroyElement(sound)
    end
    sound = playSound("music/" .. tostring(currentTrack) .. ".ogg", false)
    sound:setEffectEnabled("reverb", false)
	sound:setPlaybackPosition(0)
    showTrackInfo(true)
end

local function update(dt)
    dt = dt / 1000

    if not isElement(sound) then
        return
    end
	MUSIC_VOLUME = exports.tunrc_Config:getProperty("sounds.world_music_volume") / 100
    sound.volume = sound.volume + (MUSIC_VOLUME - sound.volume) * dt * soundVolumeSpeed

    if trackInfoAnimState == "fadein" then
        trackInfoAnimAlpha = math.min(trackInfoAnimAlpha + (trackInfoAnimTarget - trackInfoAnimAlpha) * 5 * dt, trackInfoAnimTarget)
        if trackInfoAnimAlpha == trackInfoAnimTarget then
            trackInfoAnimState = nil
        end
    elseif trackInfoAnimState == "fadeout" then
        trackInfoAnimAlpha = math.max(trackInfoAnimAlpha + (trackInfoAnimTarget - trackInfoAnimAlpha) * 5 * dt, trackInfoAnimTarget)
        if trackInfoAnimAlpha == trackInfoAnimTarget then
            trackInfo = false
            trackInfoAnimState = nil
        end
    end
end

local function draw()
	if isVisible() then
		return
	end
    if isElement(sound) and trackInfo then
        local metaTags = sound:getMetaTags()
        local title, artist = "Unknown", "Unknown artist"
        if metaTags.title and metaTags.artist then
            title, artist = metaTags.title, metaTags.artist
        end
        local titleWidth = dxGetTextWidth(title, 1, "default")
        local artistWidth = dxGetTextWidth(artist, 1, "default")
        local width = math.max(titleWidth, artistWidth, 200) + 20

        local infoBgPosition = Vector2(screenSize.x - width, screenSize.y - 800)
        local infoBgSize = Vector2(width, TRACK_INFO_HEIGHT)
		exports.tunrc_Garage:dxDrawRoundedRectangle(infoBgPosition.x,infoBgPosition.y, infoBgSize.x, infoBgSize.y, 15, 255*trackInfoAnimAlpha, false, false, false, false)
        local infoTitlePosition = infoBgPosition + Vector2(10, 10)
		exports.tunrc_Garage:TrcDrawText(title, infoTitlePosition.x, infoTitlePosition.y, infoBgPosition.x + infoBgSize.x, infoBgPosition.y + infoBgSize.y, 255 * trackInfoAnimAlpha, font, "left", "top", 1, true, true)
        local infoArtistPosition = infoBgPosition + Vector2(10, 10)
		exports.tunrc_Garage:TrcDrawText(artist, infoArtistPosition.x, infoArtistPosition.y + 30, infoBgPosition.x + infoBgSize.x, infoBgPosition.y + infoBgSize.y, 200 * trackInfoAnimAlpha, font_under, "left", "top", 1, true)
    end
end

function MusicPlayer.start()

	if isElement(sound) then
        return
    end
	
	if not exports.tunrc_Config:getProperty("game.world_music") then
		return
	end

    addEventHandler("onClientSoundStopped", resourceRoot, playNextTrack)
    addEventHandler("onClientPreRender", root, update)
    addEventHandler("onClientRender", root, draw)

    currentTrack = math.random(1, TRACKS_COUNT)
    playNextTrack()

    bindKey("=", "down", playNextTrack)
	bindKey("-", "down", playPrevTrack)

    if isElement(sound) then
        sound.volume = 0
        sound:setPlaybackPosition(0)
    end
end

function MusicPlayer.fadeOut()
    soundVolume = 0
end

function MusicPlayer.stop()
	
	if not isElement(sound) then
        return
    end

    removeEventHandler("onClientSoundStopped", resourceRoot, playNextTrack)
    removeEventHandler("onClientPreRender", root, update)
    removeEventHandler("onClientRender", root, draw)

    hideTrackInfo()
    unbindKey("=", "down", playNextTrack)
	unbindKey("-", "down", playPrevTrack)

    if isElement(sound) then
        destroyElement(sound)
        sound = nil
    end
end

function MusicPlayer.checker()

	vehicle = getPedOccupiedVehicle(localPlayer)

	if not exports.tunrc_Config:getProperty("game.world_music") then
        MusicPlayer.stop()
    else
		MusicPlayer.start()
	end
	
	if not vehicle then
	    MusicPlayer.stop()
    else
		MusicPlayer.start()
	end
end
addEventHandler("onClientRender", root, MusicPlayer.checker)

function MusicPlayer.AssetsStart()
	font = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 16, true)
	font_under = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 10, true)
end
addEventHandler("onClientResourceStart", resourceRoot, MusicPlayer.AssetsStart)

function getCurrentMusic()
	return sound
end