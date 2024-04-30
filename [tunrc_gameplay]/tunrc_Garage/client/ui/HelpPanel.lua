HelpPanel = newclass "HelpPanel"
local screenSize = Vector2(guiGetScreenSize())

function HelpPanel:init(helpLines)
    self.helpLines = {}
    for i, line in ipairs(helpLines) do
        self.helpLines[i] = { keys = {}, text = "" }
        for j, key in ipairs(line.keys) do
            table.insert(self.helpLines[i].keys, exports.tunrc_Lang:getString(key))
        end
        self.helpLines[i].text = exports.tunrc_Lang:getString(line.locale)
    end

    self.font = Assets.fonts.helpPanelText
    self.lineHeight = 25
    self.alpha = 255
    self.targetAlpha = 255
end

function HelpPanel:draw(fadeProgress)
    local alpha = self.alpha * fadeProgress
    local y = screenSize.y - 10 - (self.lineHeight + 3) * #self.helpLines
    local x = 10
    for i, line in ipairs(self.helpLines) do
        local cx = x
		textWidth = dxGetTextWidth(line.text, 1, self.font) + 10
        for j, key in ipairs(line.keys) do
            keyWidth = dxGetTextWidth(key, 1, self.font) + 10
			dxDrawRoundedRectangle(
				cx,
				y,
				textWidth + keyWidth + 10,
				self.lineHeight,
				5,
				alpha,
				false,
				false,
				false,
				false
			 )
			TrcDrawText(key, cx, y, cx + keyWidth, y + self.lineHeight, alpha, self.font)
			cx = cx + keyWidth + 2
        end
		TrcDrawText(" | " .. line.text, cx, y, cx + textWidth, y + self.lineHeight, alpha, self.font)
        y = y + self.lineHeight + 3
    end
end

function HelpPanel:update(deltaTime)
    self.alpha = self.alpha + (self.targetAlpha - self.alpha) * deltaTime * 10
end

function HelpPanel:toggle()
    if self.targetAlpha > 255 / 2 then
        self.targetAlpha = 0
    else
        self.targetAlpha = 255
    end
end