addEvent("tunrc_Markers.use", false)
addEventHandler("tunrc_Markers.use", root, function()
    local mapName = source:getData("RaceMarker.map")
    if type(mapName) ~= "string" then
        return 
    end
    LobbyScreen.toggle(mapName)
end)

addEventHandler("onClientMarkerLeave", root, function (player)
    if player ~= localPlayer then
        return
    end
    if source:getData("RaceMarker.map") then
        LobbyScreen.setVisible(false)
    end
end)

addEventHandler("onClientElementDestroy", root, function ()
    if not isElement(source) or not source.getData then
        return
    end 
    if source:getData("RaceMarker.map") then
        LobbyScreen.setVisible(false)
    end
end)