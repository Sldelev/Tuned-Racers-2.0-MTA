--[[
local rots = {}
local peds = {}

addEventHandler ("onClientVehicleStartExit", root, function(pl, seat)
	if seat ~= 0 then return end
	
	local stateL = getPedControlState (pl, "vehicle_left")
	local stateR = getPedControlState (pl, "vehicle_right")
	
	rots[source] = stateL and "left" or stateR and "right"
	-- setElementData
end)

addEventHandler ("onClientVehicleExit", root, function(pl, seat)
	if seat ~= 0 then return end
	
	if not rots[source] then return end
	
	if not peds[source] then
		peds[source] = createPed (0, 0, 0, 0)
		peds[source].alpha = 0
	end
	warpPedIntoVehicle (peds[source], source)
	
	setPedControlState (peds[source], "vehicle_"..rots[source], true)
end)

addEventHandler ("onClientElementStreamOut", root, function()
	if rots[source] then
		rots[source] = nil
	end
	
	if peds[source] then
		peds[source] = nil
		if isElement (peds[source]) then
			peds[source]:destroy()
		end
	end
end)]]

local radLX, radLY, radLZ = {}, {}, {}
local radRX, radRY, radRZ = {}, {}, {}
function radExit(player, seat, door)
    if seat == 0 then
        radLX[source], radLY[source], radLZ[source] = getVehicleComponentRotation(source, "wheel_lf_dummy")
        radRX[source], radRY[source], radRZ[source] = getVehicleComponentRotation(source, "wheel_rf_dummy")
    end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), radExit)

function radEnter(player, seat, door)
    if seat == 0 then
        radLX[source], radLY[source], radLZ[source] = nil, nil, nil
        radRX[source], radRY[source], radRZ[source] = nil, nil, nil
    end
end
addEventHandler("onClientVehicleEnter", getRootElement(), radEnter)

addEventHandler("onClientRender", root, function ()
    for _, v in pairs(getElementsByType('vehicle', root, true)) do
        if radLX[v] then
            setVehicleComponentRotation(v, "wheel_lf_dummy", radLX[v], radLY[v], radLZ[v])
            setVehicleComponentRotation(v, "wheel_rf_dummy", radRX[v], radRY[v], radRZ[v])
        end
        
        -- rotxl, rotyl, rotzl = getVehicleComponentRotation(v, "wheel_lf_dummy")
        -- rotx_1, rotyl_1, rotzl_1 = getVehicleComponentRotation(v, "wheel_lf_dummy")
        -- rotxr, rotyr, rotzr = getVehicleComponentRotation(v, "wheel_rf_dummy")
        -- rotx_2, rotyl_2, rotzl_2 = getVehicleComponentRotation(v, "wheel_rf_dummy")
        -- setVehicleComponentRotation(v, "wheel_lf_dummy", rotx_1, rotyl_1, rotzl)
        -- setVehicleComponentRotation(v, "wheel_rf_dummy", rotx_2, rotyl_2, rotzr)
    end
end)
