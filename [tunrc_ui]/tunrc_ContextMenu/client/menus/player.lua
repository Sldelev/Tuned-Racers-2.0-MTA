local playerMenu = {
	title = "Игрок Sidelev",
	items = {}
}

remotePlayerMenu = {
	{ locale = "context_menu_player_profile", enabled = false},
	{ locale = "context_menu_player_pm", 
		click = function (player)
			if not isElement(player) then
				return
			end
			if player.type == "vehicle" then
				player = player.controller
				if not player then
					return
				end
			end
			exports.tunrc_Chat:startPM(player)
		end,

		enabled = false
	},
	{ locale = "context_menu_player_report", enabled = false}	
}

local function playAnim(name)
	return function()
		triggerServerEvent("tunrc_Anims.playAnim", root, name)
	end
end

local localPlayerMenu = {
	{ locale = "context_menu_anim_hello", click = playAnim("hello")},
	{ locale = "context_menu_anim_no", click = playAnim("no")},
	{ locale = "context_menu_anim_bye", click = playAnim("bye")},

	{ locale = "context_menu_anim_wave", click = playAnim("wave")},
	{ locale = "context_menu_anim_lay", click = playAnim("lay")},
	{ locale = "context_menu_anim_sit", click = playAnim("sit")},
	{ locale = "context_menu_anim_fucku", click = playAnim("fucku")},
	{ locale = "context_menu_anim_serious", click = playAnim("serious")},
}

function playerMenu:init(player)
	if not isElement(player) then
		return
	end
	self.title = string.format("%s %s", 
		exports.tunrc_Lang:getString("context_menu_title_player"),
		exports.tunrc_Utils:removeHexFromString(tostring(player.name)))

	if player.vehicle then
		return
	end
	if player == localPlayer then
		self.items = localPlayerMenu
	else
		self.items = remotePlayerMenu
	end
end

registerContextMenu("player", playerMenu)