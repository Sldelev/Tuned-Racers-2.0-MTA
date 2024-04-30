MapWorld = {}
MapWorld.position = Vector3()
local MAP_SIZE = 40
local buildingAlpha = 0

-- Текстуры
local textures = {}

function MapWorld.start()
	MapWorld.position = Vector3(localPlayer.position) + Vector3(0, 0, 100)
end

function MapWorld.stop()

end

function MapWorld.getMapFromWorldPosition(position, y, z)
	if type(position) == "number" and y and z then
		local x = position
		return x / 6000 * MAP_SIZE, y / 6000 * MAP_SIZE, z / 6000 * MAP_SIZE
	else
		return position / 6000 * MAP_SIZE
	end
end

function MapWorld.convertPositionToMap(x, y, z)
	return MapWorld.position.x + x / 6000 * MAP_SIZE, MapWorld.position.y + y / 6000 * MAP_SIZE, MapWorld.position.z + z / 6000 * MAP_SIZE
end

local _dxDrawMaterialLine3D = dxDrawMaterialLine3D
local function dxDrawMaterialLine3D(x1, y1, z1, x2, y2, z2, material, width, color, lx, ly, lz)	
	_dxDrawMaterialLine3D(
		x1 + MapWorld.position.x, 
		y1 + MapWorld.position.y, 
		z1 + MapWorld.position.z, 
		x2 + MapWorld.position.x, 
		y2 + MapWorld.position.y, 
		z2 + MapWorld.position.z, 
		material, 
		width, 
		color, 
		lx + MapWorld.position.x,
		ly + MapWorld.position.y,
		lz + MapWorld.position.z
	)
end

local function drawHorizontalPlane(x, y, z, sx, sy, direction, material, color)
	direction = math.rad(direction)
	local ox, oy = math.cos(direction) * sy / 2, math.sin(direction) * sy / 2
	dxDrawMaterialLine3D(
		x + ox,
		y + oy,
		z,
		x - ox,
		y - oy,
		z, 
		material, 
		sx,
		color,
		x, 
		y,
		z + 1
	)
end

function MapWorld.update()
	drawHorizontalPlane(0, 0, -0.1, MAP_SIZE * 3, MAP_SIZE * 3, 0, textures.fill, tocolor(10, 10, 10, 200))
	drawHorizontalPlane(0, 0, 0, MAP_SIZE, MAP_SIZE, 90, textures.map, tocolor(255, 255, 255))
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Загрузить нужные текстуры при запуске ресурса
	textures.map = DxTexture("assets/map.png", "dxt5")
	textures.fill = DxTexture("assets/pixel.png")
	textures.building = DxTexture("assets/building.png", "dxt5")
	textures.top = DxTexture("assets/top.png", "dxt5")
end)

MapWorld.drawHorizontalPlane = drawHorizontalPlane