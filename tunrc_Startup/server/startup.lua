local SHOW_MESSAGE = true
local KICK_PLAYERS = false

local startupResources = {
	-- Экран загрузки должен загружаться раньше всех ресурсов
	"tunrc_LoadingScreen",
	"Crypt-reload",

	-- Important
	"geoip",
	"tunrc_carsounds",

	-- Assets
	"tunrc_Assets",
	"tunrc_Stickers",
	-- Configuration
	"tunrc_Config",
	"tunrc_Shared",
	"tunrc_Sounds",

	-- Core
	"tunrc_Utils",
	"tunrc_Logger",
	"tunrc_Lang",
	"tunrc_Markers",
	"tunrc_Core",
	"tunrc_WebAPI",
	"tunrc_PathGenerator",

	-- UI
	"tunrc_UI",
	"tunrc_HUD",
	"tunrc_WorldMap",
	"tunrc_Nametags",
	"tunrc_HideUI",
	"tunrc_Chat",

	"tunrc_LoginPanel",
	"tunrc_TabPanel",
	"tunrc_ModeratorPanel",
	"tunrc_GiftsPanel",
	"tunrc_overallPanel",
	"tunrc_HelpPanel",
	
	-- wheels
	"tunrc_wheels",
	
	--Машины
	-- Общие текстуры
	"trc_shared_textures",
	-- Сами автомобили
	"annis_zr350",
	"annis_remus",
	"vulcar_warrener_hkr",

	-- Gameplay
	"tunrc_TutorialMessage",
	"tunrc_SafeZones",
	"tunrc_Particles",
	"tunrc_Anims",
	"tunrc_Vehicles",
	"tunrc_WheelsManager",
	"tunrc_RaceManager",
	"tunrc_RaceLobby",
	"tunrc_PhotoMode",
	"tunrc_DriftPoints",
	"tunrc_Garage",
	"tunrc_Houses",
	"tunrc_Carshop",
	"tunrc_Damage",
	"tunrc_CameraViews",
	"tunrc_Teleports",
	"tunrc_SellVehicle",
	"tunrc_ContextMenu",
	"tunrc_wheels_rotation",
	"tunrc_WorldMusic",

	-- World
	"MAPPING",
	"TD-MAPFILES",

	-- Admin
	"tunrc_Admin",

	-- Other
	"tunrc_Greetings",
	"tunrc_Stats",

	-- Third party
	"blur_box",
	
	--maps
	"Usui_map",
	"tunrc_akina_map",
	"tunrc_akagi_map",
	"tunrc_RedRing",
	"tunrc_TsubakiLine",
	"tunrc_ebisu_minami_map",
	"tunrc_ebisu_west",
	"tunrc_ebisu_higashi_map",
	"tunrc_meihan_map",
	"tunrc_spb",
	"tunrc_galdori",
	"tunrc_okutama",
	"tunrc_primring",
	"tunrc_yz_circuit",
	"tunrc_bihoku",
	"tunrc_atron",
	"tunrc_happo",
	"tunrc_irohasaka",
	"tunrc_myogi",
	"tunrc_nagao",
	"tunrc_nanohanadai",
	"tunrc_tsuchi",
	
	-- lights scripts
	"extended_custom_coronas",
	"custom_vehicle_lights",
	"improved_vehicle_lights",
	"tunrc_lgtex",
	
	-- shaders
	"tunrc_map_nrm",
	"shader_dynamic_sky",
	"dynamic_lighting",
	"dynamic_lighting_vehicles",
	"tunrc_alphafix",
	"dl_ssao",
	"dl_fxaa",
	"tunrc_swr",
	"tunrc_RainScreenDrops",

	-- Non-important assets
	"tunrc_commands",
	"tunrc_drawdistance",
	"tunrc_fpsping",
	"tunrc_setTimeWeather",
	"tunrc_marker_creator",
	"tunrc_dontfallbike",
	"tunrc_Coll",
	"tunrc_int",
	"noclip",
	"devmod",
	
}

-- Test
-- startupResources = {"tunrc_Utils", "tunrc_Config", "tunrc_Lang", "tunrc_Chat"}

local function processResourceByName(resourceName, start)
	local resource = getResourceFromName(resourceName)
	if not resource then
		return false
	end
	if start then
		startResource(resource)
		if resource.state == "running" then
			return true
		else
			return false
		end
	else
		return stopResource(resource)
	end
end

addEventHandler("onResourceStart", resourceRoot, function ()
	local startedResourcesCount = 0
	setMaxPlayers(250)
	for i, resourceName in ipairs(startupResources) do
		if processResourceByName(resourceName, true) then
			startedResourcesCount = startedResourcesCount + 1
		else
			outputDebugString("startup: failed to start '" .. tostring(resourceName) .. "'")
		end
	end
end)

function shutdownGamemode(showMessage, kickPlayers)
	if showMessage then
		for i = 1, 20 do
			outputChatBox(" ", root, 255, 0, 0)
		end
		outputChatBox("*** GAMEMODE SHUTDOWN ***", root, 255, 0, 0)
	end
	-- Кик всех игроков перед выключением
	if kickPlayers then
		for i, player in ipairs(getElementsByType("player")) do
			player:kick("TUNEDRACERS", "GAMEMODE RESTART/SHUTDOWN")
		end
	end
	-- Выключение всех ресурсов
	for i, resourceName in ipairs(startupResources) do
		processResourceByName(resourceName, false)
	end
end

addEventHandler("onResourceStop", resourceRoot, function ()
	shutdownGamemode(SHOW_MESSAGE, KICK_PLAYERS)
end)

function shutdownServer()
	shutdownGamemode(true, true)
	setServerPassword("pls_dont_connect_or_everything_could_fuck_up")
	outputServerLog("startup: Shutdown after 3 seconds...")
	setTimer(function()
		setServerPassword(nil)
		shutdown("Server shutdown/restarting")
	end, 3000, 1)
end
