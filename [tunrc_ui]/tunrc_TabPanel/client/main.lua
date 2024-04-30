local isActive = false

function setVisible(visible)
	visible = not not visible
	if visible then
		if not localPlayer:getData("username") or localPlayer:getData("tunrc_Core.state") then
			return false
		end
	end
	if localPlayer:getData("tunrc_Core.state") or exports.tunrc_overallPanel:isVisible() then
		visible = false
	end
	if localPlayer:getData("activeUI") then
		visible = false
	end

	if isActive == visible then
		return
	end
	exports.tunrc_UI:fadeScreen(visible)
	isActive = visible
	showCursor(visible)
	exports.tunrc_HUD:setVisible(not visible)
	if visible then
		Panel.start()
	else
		Panel.stop()
	end
end

local function show()
	setVisible(true)
end

local function hide()
	setVisible(false)
end

bindKey("tab", "down", show)
bindKey("tab", "up", hide)

--show()

function isVisible()
	return isActive
end
