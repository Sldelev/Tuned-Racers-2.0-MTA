
local isTeleporting = false

function teleportToMap(name)
	if isTeleporting then
		return false
	end

	isTeleporting = true
	fadeCamera(false, 0.5)
	setTimer(function ()
		triggerServerEvent("tunrc_Teleports.teleport", resourceRoot, name)
		setTimer(fadeCamera, 500, 1, true, 0.5)
		isTeleporting = false
	end, 500, 1)
end

local function teleportToCity()
	teleportToMap()
end

addEvent("tunrc_Markers.use", false)
addEventHandler("tunrc_Markers.use", root, function ()
	local markerType = source:getData("tunrc_Teleports.type")
	if markerType and markerType == "city" then
		teleportToCity()
	end
end)

addEventHandler("onClientElementDataChange", localPlayer, function (dataName)
	if dataName == "activeMap" then
		local mapName = localPlayer:getData("activeMap")
		end
end)