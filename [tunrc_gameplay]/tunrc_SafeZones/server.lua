function createSafeZone(pos1, pos2)
    local rectMin = Vector2(0, 0)
    rectMin.x = math.min(pos1.x, pos2.x)
    rectMin.y = math.min(pos1.y, pos2.y)
    local rectMax = Vector2(0, 0)
    rectMax.x = math.max(pos1.x, pos2.x)
    rectMax.y = math.max(pos1.y, pos2.y)
	local sizex = rectMax.x - rectMin.x
    local sizey = rectMax.y - rectMin.y
    local colShape = ColShape.Cuboid(rectMin.x, rectMin.y, 0, sizex, sizey, 50)
    colShape:setData("tunrc_SafeZone", true)
    return colShape
end
