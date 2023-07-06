MusicPlayer = {}
local MUStunrc_VOLUME = 0.45
local TRACKS_COUNT = 21

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

local function playNextTrack()
    if not exports.tunrc_Config:getProperty("game.background_music") then
        return
    end
    currentTrack = (currentTrack % TRACKS_COUNT) + 1
    if isElement(sound) then
        destroyElement(sound)
    end
    sound = playSound("assets/music/" .. tostring(currentTrack) .. ".ogg", false)
    sound:setEffectEnabled("reverb", false)
    showTrackInfo(true)
end

local function update(dt)
    dt = dt / 1000

    if not isElement(sound) then
        return
    end

    sound.volume = sound.volume + (soundVolume - sound.volume) * dt * soundVolumeSpeed

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
    if isElement(sound) and trackInfo then
        local metaTags = sound:getMetaTags()
        local title, artist = "Unknown", "Unknown artist"
        if metaTags.title and metaTags.artist then
            title, artist = metaTags.title, metaTags.artist
        end
        local titleWidth = dxGetTextWidth(title, 1, Assets.fonts.menuLabel)
        local artistWidth = dxGetTextWidth(artist, 1, Assets.fonts.menuLabel)
        local width = math.max(titleWidth, artistWidth, 200) + 20

        local infoBgPosition = Vector2(screenSize.x - width, screenSize.y - 200)
        local infoBgSize = Vector2(width, TRACK_INFO_HEIGHT)
        dxDrawRectangle(infoBgPosition, infoBgSize, tocolor(29, 29, 29, 200 * trackInfoAnimAlpha), false, false)
        local infoTitlePosition = infoBgPosition + Vector2(10, 10)
        dxDrawText(title, infoTitlePosition, infoBgPosition + infoBgSize, tocolor(255, 255, 255, 255 * trackInfoAnimAlpha), 1,
                  Assets.fonts.menuLabel, "left", "top", true)
        local infoArtistPosition = infoBgPosition + Vector2(10, 10)
        dxDrawText(artist, infoArtistPosition + Vector2(0, 30), infoBgPosition + infoBgSize, tocolor(255, 255, 255, 200 * trackInfoAnimAlpha), 1,
                  Assets.fonts.helpText, "left", "top", true)
    end
end

function MusicPlayer.start()
    addEventHandler("onClientSoundStopped", resourceRoot, playNextTrack)
    addEventHandler("onClientPreRender", root, update)
    addEventHandler("onClientRender", root, draw)

    currentTrack = math.random(1, TRACKS_COUNT)
    playNextTrack()

    bindKey("N", "down", playNextTrack)

    if isElement(sound) then
        sound.volume = 0
        sound.playbackPosition = math.random(0, sound.length * 0.5)
    end

    soundVolume = MUStunrc_VOLUME
end

function MusicPlayer.fadeOut()
    soundVolume = 0
end

function MusicPlayer.stop()
    removeEventHandler("onClientSoundStopped", resourceRoot, playNextTrack)
    removeEventHandler("onClientPreRender", root, update)
    removeEventHandler("onClientRender", root, draw)

    hideTrackInfo()
    unbindKey("N", "down", playNextTrack)

    if isElement(sound) then
        destroyElement(sound)
        sound = nil
    end
end
