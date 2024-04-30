local hotels = {
	{
		garage = {
			position = Vector3(595, -1240, 18),
			rotation = Vector3(0, 0, 0),
		},
		position = Vector3 {x = 1787.025, y = -1384.408, z = 15.393},
		rotation = Vector3(0, 0, 90),
		dimension = 0,
		interior = 0
	}
}

local function getHotelForPlayer(player)
	if not isElement(player) then
		return false
	end
	local id = player:getData("_id")
	if type(id) ~= "number" then
		return false
	end

	local hotelIndex = (id - 1) % #hotels + 1
	if not hotels[hotelIndex] then
		hotelIndex = 1
	end
	return hotels[hotelIndex]
end

function hasPlayerHouse(player)
	return not not player:getData("house_id")
end

function getHouseDimension(houseId)
	if type(houseId) ~= "number" then
		return false
	end
	return 50000 + houseId
end

function getPlayerHouseLocation(player)
	if not isElement(player) then
		return false
	end
	if not hasPlayerHouse(player) then
		return getHotelForPlayer(player), true
	elseif hasPlayerHouse(player) then
	return exports.tunrc_Core:getUserHouseId(userId)
	end
	local houseData = player:getData("house_data")
	local houseId = player:getData("house_id")
	if not houseId or type(houseData) ~= "table" then
		outputDebugString("No houseId")
		return false
	end
	return {
		garage = {
			position = Vector3(unpack(houseData.garage)),
			rotation = Vector3(0, 0, houseData.garage_rotation)
		},
		position = Vector3(unpack(houseData.spawn)),
		rotation = Vector3(0, 0, houseData.spawn_rotation),
		dimension = getHouseDimension(houseId),
		interior = houseData.interior
	}
end

function getGarPos()
return { garage = {
			position = Vector3(unpack(houseData.garage)),
			rotation = Vector3(0, 0, houseData.garage_rotation)
		 },
}		 
end		 