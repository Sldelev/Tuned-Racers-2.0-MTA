local isVisible = false

function setVisible(visible)
	visible = not not visible
	if isVisible == visible then
		return
	end
	if visible and localPlayer:getData("tunrc_Core.state") then
		return
	end	
	if visible and localPlayer:getData("activeUI") then
		return
	end
	if exports.tunrc_MainPanel:isVisible() or exports.tunrc_TabPanel:isVisible() then
		return
	end	
	isVisible = visible
	if visible then
		localPlayer:setData("tunrc_Core.state", "map")
	end
	fadeCamera(false, 0.25)
	setTimer(function ()
		exports.tunrc_HUD:setVisible(not visible)
		exports.tunrc_Nametags:setVisible(not visible)
		
		if visible then
			Map.start()
			addEventHandler("onClientRender", root, Map.draw)
			addEventHandler("onClientPreRender", root, Map.update)
		else
			removeEventHandler("onClientRender", root, Map.draw)
			removeEventHandler("onClientPreRender", root, Map.update)
			Map.stop()
			setCameraTarget(localPlayer)
			localPlayer:setData("tunrc_Core.state", false)
		end
		fadeCamera(true, 0.25)
	end, 260, 1)
	return true
end

bindKey("backspace", "down", function() setVisible(false) end)
bindKey("m", "down", function() setVisible(not isVisible) end)
bindKey("f11", "down", function() 
	setVisible(not isVisible) 
end)

if localPlayer:getData("tunrc_Core.state") == "map" then
	localPlayer:setData("tunrc_Core.state", false)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	toggleControl("radar", false)
end)

setTimer(toggleControl, 1000, 0, "radar", false)