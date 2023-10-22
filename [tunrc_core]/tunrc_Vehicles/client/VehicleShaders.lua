VehicleShaders = {}

-- Активные шейдеры на автомобилях
local shaders = {}

-- Удаление всех шейдеров с автомобиля
local function destroyVehicleShaders(vehicle)
	for shaderName in pairs(shaders) do
		local shader = shaders[shaderName][vehicle]
		if isElement(shader) then
			destroyElement(shader)
		end
	end
	triggerEvent("tunrc_Vehicles.shadersDestroyed", vehicle)
end

function VehicleShaders.hasTexture(vehicle, textureName)
	return not not shaders[shaderName][vehicle]
end

-- Замена текстуры с именем textureName на автомобиле
function VehicleShaders.replaceTexture(vehicle, textureName, texture)
	if not isElement(vehicle) or type(textureName) ~= "string" or not isElement(texture) then
		return false
	end
	local shaderName = "texture_" .. tostring(textureName)
	if not shaders[shaderName] then
		shaders[shaderName] = {}
	end
	local shader = shaders[shaderName][vehicle]
	if isElement(shader) then
		destroyElement(shader)
		shader = nil
	end
	if not isElement(shader) then
		-- Создание нового шейдера
		shader = exports.tunrc_Assets:createShader("texture_replace.fx")
	end
	-- Не удалось создать шейдер
	if not shader then
		return false
	end
	engineApplyShaderToWorldTexture(shader, textureName, vehicle)
	shader:setValue("gTexture", texture)
	shaders[shaderName][vehicle] = shader

	return true
end

function VehicleShaders.replaceBody(vehicle, textureName, texture, Bodycolor)
	if not isElement(vehicle) or type(textureName) ~= "string" or not isElement(texture) then
		return false
	end
	local shaderName = "body_" .. tostring(textureName)
	if not shaders[shaderName] then
		shaders[shaderName] = {}
	end
	local BodyShader = shaders[shaderName][vehicle]
	if isElement(BodyShader) then
		destroyElement(BodyShader)
		BodyShader = nil
	end
	if not isElement(BodyShader) then
		-- Создание нового шейдера
		BodyShader = dxCreateShader("assets/shaders/body_shader.fx")
	end
	if not isElement(shaderReflectionTexture) then
		shaderReflectionTexture = dxCreateTexture ("assets/reflection.dds", "dxt5")
	end
	if not isElement(shaderGarageReflectionTexture) then
		shaderGarageReflectionTexture = dxCreateTexture ("assets/garage_reflection.dds", "dxt5")
	end
	if not isElement(NormalTexture) then
		NormalTexture = dxCreateTexture ("assets/normals/flat_n.dds")
	end
	if not isElement(SpecularTexture) then
		SpecularTexture = dxCreateTexture ("assets/speculars/carpaint_flakes_s.dds")
	end
	-- Не удалось создать шейдер
	if not BodyShader then
		return false
	end
	engineApplyShaderToWorldTexture(BodyShader, textureName, vehicle)
	BodyShader:setValue("gTexture", texture)
	BodyShader:setValue("sNormalTexture", NormalTexture)
	BodyShader:setValue("sSpecularTexture", SpecularTexture)
	if Bodycolor == nil then
		BodyShader:setValue("ColorNormals", {0.4,0.4,0.4,1})
	else
		BodyShader:setValue("ColorNormals", {Bodycolor[1] / 150,Bodycolor[2] / 159,Bodycolor[3] / 150,1})
	end
	if localPlayer:getData("tunrc_Core.state") == "garage" then
		BodyShader:setValue("sReflectionTexture", shaderGarageReflectionTexture)
	else
		BodyShader:setValue("sReflectionTexture", shaderReflectionTexture)
	end
	shaders[shaderName][vehicle] = BodyShader

	return true
end

function VehicleShaders.replaceColor(vehicle, textureName, r, g, b)
	if not isElement(vehicle) or type(textureName) ~= "string" then
		return false
	end
	if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
		return false
	end
	local shaderName = "color_" .. tostring(textureName)
	if not shaders[shaderName] then
		shaders[shaderName] = {}
	end
	local shader = shaders[shaderName][vehicle]
	if isElement(shader) then
		destroyElement(shader)
		shader = nil
	end
	if not isElement(shader) then
		-- Создание нового шейдера
		shader = exports.tunrc_Assets:createShader("texture_replace.fx")
	end
	-- Не удалось создать шейдер
	if not shader then
		return false
	end
	engineApplyShaderToWorldTexture(shader, textureName, vehicle)
	local texture = dxCreateTexture(1, 1)
	local pixels = texture:getPixels()
	dxSetPixelColor(pixels, 0, 0, r, g, b)
	texture:setPixels(pixels)
	shader:setValue("gTexture", texture)
	destroyElement(texture)

	shaders[shaderName][vehicle] = shader

	return true
end

function VehicleShaders.replaceGlass(vehicle, textureName, texture)
	if not isElement(vehicle) or type(textureName) ~= "string" or not isElement(texture) then
		return false
	end
	local shaderName = "glass_" .. tostring(textureName)
	if not shaders[shaderName] then
		shaders[shaderName] = {}
	end
	local shader = shaders[shaderName][vehicle]
	if isElement(shader) then
		destroyElement(shader)
		shader = nil
	end
	if not isElement(shader) then
		-- Создание нового шейдера
		shader = dxCreateShader("assets/shaders/glass.fx")
	end
	if not isElement(shaderReflectionTexture) then
		shaderReflectionTexture = dxCreateTexture ("assets/reflection.dds", "dxt5")
	end
	if not isElement(shaderGarageReflectionTexture) then
		shaderGarageReflectionTexture = dxCreateTexture ("assets/garage_reflection.dds", "dxt5")
	end
	if not isElement(NormalTexture) then
		NormalTexture = dxCreateTexture ("assets/normals/flat_n.dds")
	end
	-- Не удалось создать шейдер
	if not shader then
		return false
	end
	engineApplyShaderToWorldTexture(shader, textureName, vehicle)
	shader:setValue("gTexture", texture)
	shader:setValue("sNormalTexture", NormalTexture)
	if localPlayer:getData("tunrc_Core.state") == "garage" then
		shader:setValue("sReflectionTexture", shaderGarageReflectionTexture)
	else
		shader:setValue("sReflectionTexture", shaderReflectionTexture)
	end
	shaders[shaderName][vehicle] = shader

	return true
end

addEventHandler("onClientElementDestroy", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	destroyVehicleShaders(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	destroyVehicleShaders(source)
end)

addEventHandler("onClientVehicleExplode", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	destroyVehicleShaders(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
end)
