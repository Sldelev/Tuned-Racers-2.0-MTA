textures = {}

shader = {}

local function MapNormals()
	table_normals = {
		['k_tu_wall_fout.obj'] = {
			"assets/normals/k_tu_wall_fout_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			1,
		},
		['j_tu_cm_mirrorout.obj'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			2,
			reflection,
		},
		['win01'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			1,
			reflection_sky,
		},
		['win04'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			1,
			reflection_sky,
		},
		['win05'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			1,
			reflection_sky,
		},
		['winv2'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			1,
			reflection_sky,
		},
		-- ls
		['scaffolding_vc'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['nt_bonav1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['comptwindo1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['lasunion95'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['lasunion96'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['lasunion5'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['sw_door18'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['sw_wind16'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['CJ_7_11_win'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['lasjmliq3'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['sl_laexpowin1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['sl_laexpowin2'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['sl_stapldoor2'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		-- lv
		['sl_laoffblokwin1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['Circus_gls_01'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['Circus_gls_02'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['Circus_gls_03'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['Circus_gls_04'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['Circus_gls_05'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['gallery01_law'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['ctmall16_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['ctmall19_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['vgsn_scrollsgn'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['striplightsblu_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['striplightsgreen_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['striplightsorange_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['striplightspinky_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['striplightsred_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['striplightsyel_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['casinolights6_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.25,
			reflection,
		},
		['casinoawn2_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['casinolightsblu_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['casinolightsyel_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['casinolit2_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['casinolights4_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['vgshopwndw01_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['vgnmetalwall2_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['vgnmetalwall3_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['vgnmetalwall4_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['vgnmetalwall5_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['vgnmetalwall6_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['luxorwindow01_128'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.25,
			reflection,
		},
		['marinawindow1_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.25,
			reflection,
		},
		['marinadoor1_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.25,
			reflection,
		},
		['vegaswigshop1_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['shopwindowlow2_256'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['corporate3'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		-- sf
		['ws_carshowdoor1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		-- sf
		['ws_carshowwin1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
		},
		['ws_skyscraperwin1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['ws_skywins4'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['ws_skywinsgreen'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection_sky,
		},
		['ws_trainstationwin1'] = {
			"assets/normals/flat_n.dds",
			{0.2,0.2,0.2,1},
			{0.4,0.4,0.4,1}, -- цвет блика нормалек
			0.1,
			1,
			0.5,
			reflection,
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
			end
			if n[7] then
				dxSetShaderValue(shader[d], "sReflectionTexture", n[7])
			end
			if n[8] then
				dxSetShaderValue(shader[d], "alphaCurrentTexture", n[8])
			end
			if n[9] then
				dxSetShaderValue(shader[d], "sSpecularTexture", n[9])
			end
		
			engineApplyShaderToWorldTexture (shader[d], d)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	reflection = dxCreateTexture ("assets/reflections/reflection.dds", "dxt5")
	reflection_sky = dxCreateTexture ("assets/reflections/reflection_sky.dds", "dxt5")
	MapNormals()
end)