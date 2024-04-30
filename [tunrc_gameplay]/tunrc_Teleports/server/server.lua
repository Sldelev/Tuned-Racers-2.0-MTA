local mapsTeleports = {
    city_ls         = Vector3 { x = 1827.9481,   y = -1395.2028,  z = 13 },
    city_ls1         = Vector3 { x = 1408.81,   y = 457.79,  z = 19.62 },
    city_ls2         = Vector3 { x = 343.65,   y = -1808.95,  z = 3.97 },
	city_ls3         = Vector3 { x = 2691,   y = -1672.52,  z = 9 },	
    city_sf         = Vector3 { x = -1991.581,  y = 137.797,    z = 27.234 } ,
	city_sf1         = Vector3 { x = -1822.38,  y = -639.283,    z = 16.17 } ,
	city_sf2         = Vector3 { x = -1033.96,  y = -508.575,    z = 31.41 } ,	
	city_sf3         = Vector3 { x = -2034.76,  y = 1190.575,    z = 45 } ,
	city_sfchill         = Vector3 { x = -2392.6,  y = -2206,    z = 35 } ,	
    city_lv         = Vector3 { x = 2152.503,   y = 1004.375,   z = 10.515 },
    city_lv1         = Vector3 { x = -1311.94,   y = 2702.35,   z = 49.47 },
	city_lv2         = Vector3 { x = 1272.47,   y = 2599.35,   z = 11 },
	city_lv3         = Vector3 { x = -362,   y = 1096,   z = 20 },
	city_market         = Vector3 { x = 2871.66,   y = 2429.35,   z = 10.25 },
	city_lv_parking_a        = Vector3 { x = 1674.14,   y = 988.39,   z = 10.45 },
	mount_sf         = Vector3 { x = -2401.66,   y = -587,   z = 132.4 },
	rr = Vector3 { x = 1213,   y = 787,   z = 6500 },
	spb = Vector3 { x = 1648,   y = 2171,   z = 2970 },
	futo = Vector3 { x = 752, y = 948, z = 3468 },
	akina = Vector3 { x = 5331.6,   y = 1764,   z = 3292 },
	akagi = Vector3 { x = 1601,   y = -49,   z = 1415 },
	minami = Vector3 { x = 111,   y = 52,   z = 8010 },
	west = Vector3 { x = -23,   y = -35,   z = 2400 },
	higashi = Vector3 { x = -45,   y = 64,   z = 3015 },
	meihan = Vector3 { x = 2790,   y = 471,   z = 7260 },
	usui = Vector3 { x = -2194,   y = 1121,   z = 5753 },
	tsu = Vector3 { x = -52,   y = 1425,   z = 7320 },
	bihoku = Vector3 { x = -4692,   y = -3184,   z = 2136 },
	okutama = Vector3 { x = -663,   y = -2851,   z = 3060 },
	primring = Vector3 { x = 2890,   y = -174,   z = 7350 },
	yz  = Vector3 { x = -7926,   y = -1448,   z = 4145 },
	galdori = Vector3 { x = -2912,   y = -2127,   z = 7050 },
	tsuchi = Vector3 { x = 2501,   y = -2421,   z = 10200 },
	happo = Vector3 { x = 1362,   y = 1126,   z = 3825 },
	iro = Vector3 { x = -2157,   y = 885,   z = 8775 },
	myogi = Vector3 { x = 2415,   y = -1891,   z = 8235 },
	nagao = Vector3 { x = -34,   y = -24,   z = 9100 },
	nano = Vector3 { x = 1500,   y = 395,   z = 12300 },
	tsukuba = Vector3 { x = -2548,   y = 269,   z = 5820 },
	atron = Vector3 { x = 60,   y = -260,   z = 2210 },
	
	--races
	d1 = Vector3 { x = 725,   y = -1395,   z = 20 },
	d2 = Vector3 { x = 1935,   y = 2022,   z = 20 },
	d3 = Vector3 { x = 2049,   y = 997,   z = 30 },
	d4 = Vector3 { x = 92.7,   y = -24.88,   z = 2210 },
	
	-- other
	trc_shrm = Vector3 { x = 1586,   y = 2252.5,   z = 4100 }
}

local cityTeleportNames = {
    city_ls = true,
    city_lv = true,
    city_sf = true
}

local cityTeleports = {
    Vector3 { x = -8169.207,    y = -1268.439,  z = 1114.1 },
    Vector3 { x = 2798.335,     y = 5122.248,   z = 140.1 },
    Vector3 { x = -7955.230,    y = -1482.596,  z = 134.011 },
    Vector3 { x = 233.051,      y = -4665.340,  z = 36.3 },
    Vector3 { x = -5947.324,    y = -2445.331,  z = 123.315 },
    Vector3 { x = 6975.113,     y = 1169.032,   z = 108.1 },
    Vector3 { x = -199.635,     y = -463.457,   z = 2.870 },
    Vector3 { x = 5596.313,     y = 1622.232,   z = 53.1 },
    Vector3 { x = 3367.047,     y = 321.202,    z = 12.3 },
    Vector3 { x = -6310.731,    y = -2538.917,  z = 94.2 },
    Vector3 { x = 5160.945,     y = -3572.130,  z = 89.4 },
    Vector3 { x = -1847.451,    y = -2759.856,  z = 1120.3 },
    Vector3 { x = -2740.114,    y = -2806.345,  z = 1436 },
    Vector3 { x = -6470.735,    y = -3292.223,  z = 311 },
    Vector3 { x = -4694.880,    y = -3179.275,  z = 116.1 },
    Vector3 { x = 6137.958,     y = -1999.080,  z = 29.7 },
    Vector3 { x = 803.378,      y = -4351.334,  z = 87.2 },
}

local cityPosition = Vector3(1467.486, -1749.974, 13.147)

addEvent("tunrc_Teleports.resetDimension", true)
addEventHandler("tunrc_Teleports.resetDimension", resourceRoot, function ()
    client.dimension = 0
    client.interior = 0
    if client.vehicle then
        client.vehicle.dimension = 0
        client.vehicle.interior = 0
    end
end)

addEvent("tunrc_Teleports.teleport", true)
addEventHandler("tunrc_Teleports.teleport", resourceRoot, function (mapName)
    local position = mapsTeleports[mapName]
    if not position then
        position = cityPosition
    end
    if cityTeleportNames[mapName] then
        mapName = nil
    end

    client:setData("activeMap", mapName)
    
    if client.vehicle then
        if client.vehicle.controller == client then
            client.vehicle.position = position
            -- Телепортировать всех игроков, сидящих в машине
            for seat, player in pairs(client.vehicle.occupants) do
                player:setData("activeMap", mapName)
            end
        else
            client.vehicle = nil
            client.position = position
        end
    else
        client.position = position
    end
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, position in ipairs(cityTeleports) do
        local cityMarker = exports.tunrc_Markers:createMarker("city", position, 180)
        cityMarker:setData("tunrc_Teleports.type", "city")
    end
end)

--[[     if isTeleporting then
         return
     end
     if client.vehicle and client.vehicle.controller ~= client then
         return
     end
     isTeleporting = true
     fadeCamera(false)
     triggerServerEvent("tunrc_Teleports.teleport", resourceRoot)
     setTimer(function()
         if client.vehicle and client.vehicle.controller == client then
             client.vehicle.position = position
             client.vehicle.rotation = Vector3(0, 0, client.vehicle.rotation.z)
         elseif not client.vehicle then
             client.position = position
         end
         exports["TD-RACEMAPS"]:unloadMap()
         exports["TD-RACEMAPS"]:loadMap(loadMap)
         fadeCamera(true)
         triggerServerEvent("tunrc_Teleports.resetDimension", resourceRoot)
         isTeleporting = false
     end, 1000, 1)]]