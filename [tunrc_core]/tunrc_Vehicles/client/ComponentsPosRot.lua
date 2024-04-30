local function updateVehicleExhPosRot(vehicle)
	-- получение положения выхлопа
	local ExhPosX = vehicle:getData("PosXExhausts")
	local ExhPosY = vehicle:getData("PosYExhausts")
	local ExhPosZ = vehicle:getData("PosZExhausts")
	-- получение поворота выхлопа
	local ExhRotX = vehicle:getData("RotXExhausts")
	local ExhRotY = vehicle:getData("RotYExhausts")
	local ExhRotZ = vehicle:getData("RotZExhausts")
	
	local exhid = vehicle:getData("Exh")
	
	if vehicle:getComponentVisible("Exh" .. tostring(exhid)) then
		local ex, ey, ez = vehicle:getComponentPosition("ExhPosLocal" .. tostring(exhid))
		local exr, eyr, ezr = vehicle:getComponentRotation("ExhPosLocal" .. tostring(exhid))
		
		vehicle:setComponentPosition("Exh" .. tostring(exhid), ex + ExhPosX, ey + ExhPosY, ez + ExhPosZ)
		vehicle:setComponentRotation("Exh" .. tostring(exhid), exr + ExhRotX, eyr + ExhRotY, ezr + ExhRotZ)
	end
	
	if vehicle:getComponentVisible("ExhSecond" .. tostring(exhid)) then
		local ex, ey, ez = vehicle:getComponentPosition("ExhSecondPosLocal" .. tostring(exhid))
		local exr, eyr, ezr = vehicle:getComponentRotation("ExhSecondPosLocal" .. tostring(exhid))
		
		vehicle:setComponentPosition("ExhSecond" .. tostring(exhid), ex - ExhPosX, ey + ExhPosY, ez + ExhPosZ)
		vehicle:setComponentRotation("ExhSecond" .. tostring(exhid), exr + ExhRotX, eyr + ExhRotY, ezr + ExhRotZ)
	end
	
	if vehicle:getComponentVisible("ExhThird" .. tostring(exhid)) then
		local ex, ey, ez = vehicle:getComponentPosition("ExhThirdPosLocal" .. tostring(exhid))
		local exr, eyr, ezr = vehicle:getComponentRotation("ExhThirdPosLocal" .. tostring(exhid))
		
		vehicle:setComponentPosition("ExhThird" .. tostring(exhid), ex + ExhPosX, ey + ExhPosY, ez + ExhPosZ)
		vehicle:setComponentRotation("ExhThird" .. tostring(exhid), exr + ExhRotX, eyr + ExhRotY, ezr + ExhRotZ)
	end
	
	if vehicle:getComponentVisible("ExhFourth" .. tostring(exhid)) then
		local ex, ey, ez = vehicle:getComponentPosition("ExhFourthPosLocal" .. tostring(exhid))
		local exr, eyr, ezr = vehicle:getComponentRotation("ExhFourthPosLocal" .. tostring(exhid))
		
		vehicle:setComponentPosition("ExhFourth" .. tostring(exhid), ex - ExhPosX, ey + ExhPosY, ez + ExhPosZ)
		vehicle:setComponentRotation("ExhFourth" .. tostring(exhid), exr + ExhRotX, eyr + ExhRotY, ezr + ExhRotZ)
	end
	return true
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if name == "PosXExhausts" or name == "PosYExhausts" or name == "PosZExhausts" or name == "RotXExhausts" or name == "RotYExhausts" or name == "RotZExhausts" then
		updateVehicleExhPosRot(source)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateVehicleExhPosRot(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateVehicleExhPosRot(source)
	end
end)