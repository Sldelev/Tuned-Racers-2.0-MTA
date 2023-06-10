--exports.tunrc_Duels:getNearestCheckpoint(player)

addEvent("tunrc_Damage.respawn", true)
addEventHandler("tunrc_Damage.respawn", resourceRoot, function ()
    local vehicle = client.vehicle
    if not vehicle then
        return
    end

    local spawnPos = PathGenerator.getNearestCheckpoint(client)
    if not spawnPos then
        return
    end
    client.vehicle.position = Vector3(spawnPos.x, spawnPos.y, spawnPos.z)
    client:setData("activeMap", false)
end)