-- Создание (и автоматическое удаление) маркеров

local MARKER_COLLISION_RADIUS = 5
local markersByResource = {}

function createMarker(markerType, position, direction)
	if type(markerType) ~= "string" or not position then
		return false
	end
	if type(direction) ~= "number" then
		direction = 0
	end
	local radius = getMarkerProperties(markerType).iconSize
	if radius then
		radius = radius * 0.5
	else
		radius = MARKER_COLLISION_RADIUS
	end

	local marker = Marker(position, "cylinder", radius, 0, 0, 0, 0)
	marker:setData("tunrc_Markers.type", markerType)
	if isElement(sourceResourceRoot) then
		if not markersByResource[sourceResourceRoot] then
			markersByResource[sourceResourceRoot] = {}
		end
		markersByResource[sourceResourceRoot][marker] = true
	end
	addMarkerToDraw(marker)
	marker:setData("tunrc_Markers.direction", math.rad(direction))
	return marker
end

addEventHandler("onClientResourceStop", root, function ()
	-- Удаление маркеров, созданных ресурсом после его остановки
	if markersByResource[source] then
		for marker in pairs(markersByResource[source]) do
			if isElement(marker) then
				destroyElement(marker)
			end
			markersByResource[source][marker] = nil
		end
	end
	markersByResource[source] = nil
end)
