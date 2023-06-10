CooldownDialog = {}

local UI = exports.tunrc_UI

local PANEL_SIZE = Vector2(350, 120)
local TEXT_OFFSET = 15
local BUTTON_HEIGHT = 50

local screenSize = Vector2(UI:getScreenSize())
local isVisible = false

local ui = {}
local data = {}

local cooldownTimer

local function killCooldownTimer()
    if cooldownTimer then
        cooldownTimer:destroy()
        cooldownTimer = nil
    end
end

function CooldownDialog.show(leftTime)
    if isVisible or localPlayer:getData("activeUI") then
        return false
    end
    if type(leftTime) ~= "number" then
        return false
    end
    isVisible = true

    data.leftTime = leftTime

    CooldownDialog.update()
    if leftTime > 0 then
        cooldownTimer = Timer(CooldownDialog.update, 1000, 0)
    end

    UI:setVisible(ui.panel, true)
    showCursor(true)

    localPlayer:setData("activeUI", "sellVehicleCooldownDialog")
    return true
end

function CooldownDialog.update()
    data.leftTime = data.leftTime - 1
    if data.leftTime > 0 then
        timeLeftString = ("%02d:%02d:%02d"):format(data.leftTime / 3600, data.leftTime / 60 % 60, data.leftTime % 60)
        UI:setText(ui.timeLeft, timeLeftString)
        UI:setText(ui.text, exports.tunrc_Lang:getString("sell_vehicle_cooldown_text"))
    else
        killCooldownTimer()
        UI:setText(ui.timeLeft, exports.tunrc_Lang:getString("sell_vehicle_cooldown_available"))
        UI:setText(ui.text, '')
    end
end

function CooldownDialog.hide()
    if not isVisible then
        return false
    end
    isVisible = false

    killCooldownTimer()

    UI:setVisible(ui.panel, false)
    showCursor(false)

    localPlayer:setData("activeUI", false)
    UI:fadeScreen(false)

    return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    ui.panel = UI:createDpPanel {
        x       = (screenSize.x - PANEL_SIZE.x) / 2,
        y       = (screenSize.y - PANEL_SIZE.y) / 2,
        width   = PANEL_SIZE.x,
        height  = PANEL_SIZE.y,
        type    = "light"
    }
    UI:addChild(ui.panel)
    UI:setVisible(ui.panel, false)

    -- Кнопка отмены
    ui.cancelButton = UI:createDpButton({
        x      = 0,
        y      = PANEL_SIZE.y,
        width  = PANEL_SIZE.x,
        height = BUTTON_HEIGHT,
        locale = "sell_vehicle_cancel_button",
        type   = "primary"
    })
    UI:addChild(ui.panel, ui.cancelButton)

    -- Заголовок
    ui.title = UI:createDpLabel {
        x        = TEXT_OFFSET,
        y        = 0,
        width    = PANEL_SIZE.x - TEXT_OFFSET * 2,
        height   = BUTTON_HEIGHT,
        alignX   = "center",
        alignY   = "center",
        clip     = true,
        locale   = "sell_vehicle_cooldown_title",
        type     = "primary",
        fontType = "defaultSmall",
    }
    UI:addChild(ui.panel, ui.title)

    -- Время
    ui.timeLeft = UI:createDpLabel {
        x           = TEXT_OFFSET,
        y           = BUTTON_HEIGHT,
        width       = PANEL_SIZE.x - TEXT_OFFSET * 2,
        height      = PANEL_SIZE.y - BUTTON_HEIGHT,
        alignX      = "center",
        alignY      = "top",
        clip        = true,
        wordBreak   = true,
        type        = "primary",
        fontType    = "defaultLarger"
    }
    UI:addChild(ui.panel, ui.timeLeft)

    -- Пояснение
    ui.text = UI:createDpLabel {
        x           = TEXT_OFFSET,
        y           = BUTTON_HEIGHT,
        width       = PANEL_SIZE.x - TEXT_OFFSET * 2,
        height      = PANEL_SIZE.y - BUTTON_HEIGHT - 5,
        alignX      = "center",
        alignY      = "bottom",
        clip        = true,
        wordBreak   = true,
        type        = "dark",
        fontType    = "defaultSmall"
    }
    UI:addChild(ui.panel, ui.text)
end)

addEvent("tunrc_UI.click", false)
addEventHandler("tunrc_UI.click", resourceRoot, function (widget)
    if widget == ui.cancelButton then
        exports.tunrc_Sounds:playSound("ui_back.wav")
        CooldownDialog.hide()
    end
end)
