local screenSize = {guiGetScreenSize()}

local MUSIC_VOLUME = 0.5
local BACKGROUND_COLOR = {13, 15, 17}
local LOGO_SIZE = 512

local logo
local logoStripes
local logined = 0

local showing = false

local fading = false
local fadeProgress = 0
local fadeTarget = 0

local musicEnabled = false
local musicVolume
local music

local transferBoxDownloaded = 0
local transferBoxTotal = 0

addEventHandler("onClientResourceStart", resourceRoot, function ()
  musicEnabled = not fileExists("muted")
  if not getElementData(localPlayer, "username") then
    showChat(false)
    show(false, true)
  end
end)

addEventHandler("onClientTransferBoxProgressChange", root, function(downloadedSize, totalSize)
  if not showing then
    return
  end
  if totalSize > 0 then
    transferBoxDownloaded = downloadedSize
    transferBoxTotal = totalSize
  end
end)

function draw()
  if isElement(music) and musicEnabled then
    musicVolume = musicVolume * fadeProgress
    setSoundVolume(music, musicVolume)
  end
  dxDrawRectangle(0, 0, screenSize[1], screenSize[2], tocolor(BACKGROUND_COLOR[1], BACKGROUND_COLOR[2], BACKGROUND_COLOR[3], 255 * fadeProgress))
  local logoAnimProgress = getEasingValue(math.abs(((getTickCount() - 1000) / 6000) % 2 - 1), "InOutQuad")
  local stripesAnimProgress = getEasingValue(math.abs(((getTickCount() - 500) / 2000) % 2 - 1), "InOutQuad")
  local logoSize = LOGO_SIZE - 64 + (64 * logoAnimProgress)
  local logoPosition = {screenSize[1] / 2 - logoSize / 2, screenSize[2] / 2 - logoSize / 2}
  dxDrawImage(logoPosition[1], logoPosition[2], logoSize, logoSize, logo, 0, 0, 0, tocolor(255, 255, 255, 255 * fadeProgress))
  local stripesPosition = {logoPosition[1], logoPosition[2] + 4 * stripesAnimProgress}
  dxDrawImage(stripesPosition[1], stripesPosition[2], logoSize, logoSize, logoStripes, 0, 0, 0, tocolor(255, 255, 255, 255 * fadeProgress))

  -- Transfer box
  if transferBoxTotal ~= 0 then
    local transferBoxProgress = math.min((transferBoxDownloaded / transferBoxTotal), 1)
    dxDrawRectangle(0, screenSize[2] - 8, transferBoxProgress * screenSize[1], 8, tocolor(255, 255, 255, 255 * fadeProgress))
    local textAnimProgress = getEasingValue(math.abs(getTickCount() / 1000 % 2 - 1), "Linear")
    dxDrawText(("%d%%\n%.1f / %.1f MB"):format(transferBoxProgress * 100, transferBoxDownloaded / 1000 / 1000, transferBoxTotal / 1000 / 1000),
      screenSize[1] / 2, screenSize[2] - 128, screenSize[1] / 2, screenSize[2] - 16,
      tocolor(255, 255, 255, (128 + textAnimProgress * 128) * fadeProgress), 2, "sans", "center", "center")
  end
end 

function updateFade(deltaTime)
  if fading then
    if fadeTarget > fadeProgress then
      fadeProgress = math.min(fadeTarget, fadeProgress + 0.15 * (deltaTime / 100))
    else
      fadeProgress = math.max(fadeTarget, fadeProgress - 0.15 * (deltaTime / 100))
    end
    if fadeProgress == fadeTarget then
      fading = false
      removeEventHandler("onClientPreRender", root, updateFade)

      if fadeTarget == 0 then
        removeEventHandler("onClientRender", root, draw)
        destroyElement(logo)
        destroyElement(logoStripes)
        if isElement(music) then
          destroyElement(music)
        end
        logo = nil
        logoStripes = nil
        music = nil
        musicVolume = nil
        showing = false
      end
    end
  end
end

function fadeIn()
  fading = true
  fadeProgress = 0
  fadeTarget = 1
  addEventHandler("onClientPreRender", root, updateFade, true, "high+9999")
end

function show(fade, shouldPlayMusic)
  if showing then
    return
  end

  if fade then
    fadeIn()
  else
    fadeProgress = 1
    fadeTarget = 1
  end

  logo = dxCreateTexture("logo.png", "argb", true, "clamp")
  logoStripes = dxCreateTexture("logo2.png", "argb", true, "clamp")

  if shouldPlayMusic and musicEnabled then
    --playMusic()
  end

  --exports.tunrc_HUD:setVisible(false)
  --exports.tunrc_Chat:setVisible(visible)
  --exports.tunrc_Garage:setVisible(visible)
  
  setTransferBoxVisible(false)

  showing = true
  addEventHandler("onClientRender", root, draw, true, "high+9999")
end

function hide()
  if not showing then
    return
  end
  if not fading then
    addEventHandler("onClientPreRender", root, updateFade, true, "high+9999")
  end
  fading = true
  fadeTarget = 0
  
  --exports.tunrc_Chat:setVisible(not visible)
  --exports.tunrc_Garage:setVisible(not visible)

	setTransferBoxVisible(true)
	
	exports.tunrc_LoginPanel:setVisible(true)
end

--[[function playMusic()
  if isElement(music) then
    return
  end
  music = playSound("music.mp3", true)
  musicVolume = MUSIC_VOLUME
  setSoundVolume(music, musicVolume)
end]]

function setMusicMuted(muted)
  if muted then
    if isElement(music) then
      setSoundVolume(music, 0)
    end
    local muteFile = fileCreate("muted")
    if muteFile then
      fileClose(muteFile)
    end
  else
    if not isElement(music) then
      --playMusic()
    end
    setSoundVolume(music, musicVolume)
    if fileExists("muted") then
      fileDelete("muted")
    end
  end
  musicEnabled = not muted
end
