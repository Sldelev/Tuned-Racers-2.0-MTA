local TAB_NAME_PREFIX = "pmtab_"

--[[function startPM(player, message)
	if not isElement(player) then
		return false
	end
	if player.type ~= "player" then
		return false
	end
	if player == localPlayer then
		return false
	end
	local playerId = player:getData("_id")
	if not playerId then
		return
	end

	local tabName = TAB_NAME_PREFIX .. tostring(playerId)

	if Chat.getTabFromName(tabName) then
		if message then
			Chat.message(tabName, localPlayer.name .. "#FFFFFF: " .. tostring(message))
			triggerServerEvent("tunrc_Chat.pm", root, player, message)
		end
		return
	end
	Chat.createTab(tabName, exports.tunrc_Utils:removeHexFromString(player.name), false)
	Chat.setActiveTab(tabName)

	Chat.message(tabName, string.format(exports.tunrc_Lang:getString("chat_pm_started"), tostring(player.name)), 150, 150, 150)
	triggerServerEvent("tunrc_Chat.pm", root, player, false)

	if message then
		Chat.message(tabName, localPlayer.name .. "#FFFFFF: " .. tostring(message))
		triggerServerEvent("tunrc_Chat.pm", root, player, message)
	end
end]]

--[[addCommandHandler("pm", function (cmd, name, ...)
	local players = exports.tunrc_Utils:getPlayersByPartOfName(name)
	local player
	if players then
		player = players[1]
	end
	if not player then
		player = getElementByID("player_" .. tostring(name))
		if not player then
			exports.tunrc_UI:showMessageBox("PM", "Player not found")
			return
		end
	end

	local args = {...}
	local message
	if #args > 0 then
		message = table.concat(args, " ")
	end
	startPM(player, message)
end)]]

local function getPlayerByAccountId(id)
	for i, p in ipairs(getElementsByType("player")) do
		if p:getData("_id") == id then
			return p
		end
	end
end

addEventHandler("tunrc_Chat.message", root, function (tabName, message)
	if not string.find(tabName, TAB_NAME_PREFIX) then
		return
	end

	local playerId = tonumber(string.sub(tabName, string.len(TAB_NAME_PREFIX) + 1, -1))
	if not playerId then
		Chat.removeTab(tabName)
	end

	local player = getPlayerByAccountId(playerId)
	if not isElement(player) then
		Chat.message(tabName, "Игрок не подключен!")
	end
	Chat.message(tabName, localPlayer.name .. "#FFFFFF: " .. tostring(message))
	triggerServerEvent("tunrc_Chat.pm", root, player, message)
end)

addEvent("tunrc_Chat.pm", true)
addEventHandler("tunrc_Chat.pm", root, function (player, message)
	if not isElement(player) then
		return
	end
	local playerId = player:getData("_id")
	if not playerId then
		return
	end
	local tabName = TAB_NAME_PREFIX .. tostring(playerId)
	if not Chat.getTabFromName(tabName) then
		Chat.createTab(tabName, exports.tunrc_Utils:removeHexFromString(player.name), false)
		setWindowFlashing(true)
	end
	if message then
		Chat.message(tabName, player.name .. "#FFFFFF: " .. tostring(message))
	else
		Chat.message(tabName, string.format(exports.tunrc_Lang:getString("chat_pm_started"), tostring(player.name)), 150, 150, 150)
	end
end)
