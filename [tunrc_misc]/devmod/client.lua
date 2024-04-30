addCommandHandler("dev",
    function()
        setDevelopmentMode(true)
    end
)

addCommandHandler("premiuminfo",function()
	local timestamp = getRealTime(false).timestamp
	local premiuminfo = localPlayer:getData("premium_expires")
	outputDebugString("Non real time stamp premium: " ..premiuminfo.. ". non real time stamp:" .. timestamp)
end)

addCommandHandler("setTutorial",function()
	localPlayer:setData("tutorialActive", true)
	outputDebugString("Set Tutorial to active")
end)

addCommandHandler("resetAUI",function()
	localPlayer:setData("activeUI", false)
end)

addCommandHandler("getMyVehChrome",function()
	local chrome = localPlayer.vehicle:getData("ChromePower")
	outputDebugString(chrome)
end)

addEventHandler("onClientVehicleCollision", root,
	function(collider, damageImpulseMag, bodyPart, x, y, z, nx, ny, nz)
		if getDevelopmentMode() == true then
			if ( source == getPedOccupiedVehicle(localPlayer) ) then
				if damageImpulseMag > 1000 then
					local m = createMarker(x, y, z, "corona", 2, 0, 9, 231)
					setElementDimension(m, localPlayer.dimension)
					setTimer(destroyElement, 2000, 1, m)
				end
			end
		end
	end
)