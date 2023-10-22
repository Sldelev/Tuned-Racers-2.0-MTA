textures = {}

shader = {}

local function handlerSampler(vehicle)
	table_normals = {
		['kanjo_turbo'] = {
			"assets/normals/kanjo_turbo_n.png",
			{0.3,0.3,0.3,1},
			{0.6,0.6,0.6,1}, -- цвет блика нормалек
			1,
		},
		['vehicle_generic_mesh3'] = {
			"assets/normals/vehicle_generic_mesh3_n.dds",
			{0.3,0.3,0.3,1},
			{0.6,0.6,0.6,1}, -- цвет блика нормалек
			1,
		},
		['vehicle_generic_carbon'] = {
			"assets/normals/vehicle_generic_carbon_n.png",
			{0.4,0.4,0.4,1},
			{0.6,0.6,0.6,1}, -- цвет блика нормалек
			1,
			16,
			0.05,
		},
		['vehicle_generic_detail2'] = {
			"assets/normals/vehicle_generic_detail2_n.png",
			{0.4,0.4,0.4,1},
			{0.2,0.2,0.2,1}, -- цвет блика нормалек
			3,
		},
		['vehicle_generic_cplate2'] = {
			"assets/normals/vehicle_generic_cplate_n.png",
			{0.4,0.4,0.4,1},
			{0.3,0.3,0.3,1}, -- цвет блика нормалек
			3,
		},
		['vehicle_generic_tyrewallblack'] = {
			"assets/normals/vehicle_generic_tyrewall_n.png",
			{0.4,0.4,0.4,1},
			{0.15,0.15,0.15,1}, -- цвет блика нормалек
			3,
		},
		--['other'] = {"normals/other_normal.png"},
		}

	for d,n in pairs(table_normals) do
		textures[d] = textures[d] or dxCreateTexture (n[1])
		shader[d] = shader[d] or dxCreateShader ('assets/shaders/shader.fx')
		
			dxSetShaderValue(shader[d], "sNormalTexture", textures[d])
			if n[2] then
				dxSetShaderValue(shader[d], "ColorTexture", n[2])
			end
			if n[3] then
				dxSetShaderValue(shader[d], "ColorNormals", n[3])
			end
			if n[4] then
				dxSetShaderValue(shader[d], "normalFactor", n[4])
			end
			if n[5] then
				dxSetShaderValue(shader[d], "flakesSize", n[5])
			end	
			if n[6] then
				dxSetShaderValue(shader[d], "ChromePower", n[6])
				dxSetShaderValue(shader[d], "sReflectionTexture", shaderReflectionTexture)
			end
			if n[7] then
				dxSetShaderValue(shader[d], "alphaCurrentTexture", n[7])
			end
		
			engineApplyShaderToWorldTexture (shader[d], d)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	shaderReflectionTexture = dxCreateTexture ("assets/reflection.dds", "dxt5")

	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		handlerSampler(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		handlerSampler(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type ~= "vehicle" then
		return
	end
	handlerSampler(source)
end)