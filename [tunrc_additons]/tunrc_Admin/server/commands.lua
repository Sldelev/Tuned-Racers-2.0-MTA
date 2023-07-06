local commands = {}

local function hasPlayerEnoughRights(player, requestedGroup)
	if not isElement(player) then
		return false
	end
	if not requestedGroup then
		return false
	end
	if isPlayerAdmin(player) then
		return true
	end
	local playerGroup = player:getData("group")
	if playerGroup == "admin" then
		return true
	end
	if playerGroup == "moderator" and requestedGroup == "moderator" then
		return true
	end
	return false
end

local function addCommand(name, group, handler)
	if type(name) ~= "string" or type(handler) ~= "function" then
		return false
	end
	if not group then
		group = "admin"
	end
	commands[name] = { handler = handler, group = group }
end

local function executeCommand(player, name, ...)
	if type(name) ~= "string" then
		return false
	end
	if type(commands[name]) ~= "table" then
		return false
	end
	if type(commands[name].handler) ~= "function" then
		return false
	end
	if not hasPlayerEnoughRights(player, commands[name].group) then
		return false
	end
	return commands[name].handler(player, ...)
end

addCommand("givemoney", "admin", function (admin, player, amount)
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Amount: %s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"givemoney",
		tostring(player.name),
		tostring(player:getData("username")),
		tostring(amount)))	
	return exports.tunrc_Core:givePlayerMoney(player, amount)
end)

addCommand("setpremium", "admin", function (admin, player, duration)
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Amount: %s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"givemoney",
		tostring(player.name),
		tostring(player:getData("username")),
		tostring(duration)))	
	return exports.tunrc_Core:setPlayerPremium(player, duration)
end)

addCommand("givexp", "admin", function (admin, player, amount)
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Amount: %s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"givexp",
		tostring(player.name),
		tostring(player:getData("username")),
		tostring(amount)))	
	return exports.tunrc_Core:givePlayerXP(player, amount)
end)

addCommand("givecar", "admin", function (admin, player, name)
	local model = exports.tunrc_Shared:getVehicleModelFromName(name)
	if type(model) ~= "number" then
		return false
	end
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Car name: %s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"givecar",
		tostring(player.name),
		tostring(player:getData("username")),
		tostring(name)))

	return exports.tunrc_Core:addPlayerVehicle(player, model)
end)

addCommand("removecar", "admin", function (admin, player, id)
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Car id: %s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"removecar",
		tostring(player.name),
		tostring(player:getData("username")),
		tostring(id)))	

	return exports.tunrc_Core:removePlayerVehicle(player, id)
end)

addCommand("settime", "admin", function (admin, hh, mm)
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Time: %s:%s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"settime",
		tostring(hh),
		tostring(mm)))	

	return exports.tunrc_Time:setServerTime(hh, mm)
end)

addCommand("kick", "moderator", function (admin, player, reason)
	if not isElement(player) then
		return
	end
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Reason: %s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"kick",
		tostring(player.name),
		tostring(player:getData("username")),
		tostring(reason)))		
	return kickPlayer(player, admin, reason)
end)

addCommand("ban", "moderator", function (admin, player, duration, reason)
	exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Duration: %s | Reason: %s",
		tostring(admin.name),
		tostring(admin:getData("username")),
		"ban",
		tostring(player.name),
		tostring(player:getData("username")),
		tostring(duration),
		tostring(reason)))		

	triggerClientEvent("tunrc_Admin.showMessage", resourceRoot, "ban", admin, player)
	return exports.tunrc_Core:banPlayer(player, duration, reason)
end)

addCommand("mute", { "moderator", "judge" }, function (admin, player, duration, reason)
	if exports.tunrc_Core:mutePlayer(player, duration) then
		exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s) | Duration: %s | Reason: %s",
			tostring(admin.name),
			tostring(admin:getData("username")),
			"mute",
			tostring(player.name),
			tostring(player:getData("username")),
			tostring(duration),
			tostring(reason)))
		triggerClientEvent("tunrc_Admin.showMessage", resourceRoot, "mute", admin, player, duration)
	end
end)

addCommand("unmute", "moderator", function (admin, player)
	if exports.tunrc_Core:unmutePlayer(player) then
		exports.tunrc_Logger:log("admin", string.format("Admin: %s (%s) | Command: %s | Target Player: %s (%s)",
			tostring(admin.name),
			tostring(admin:getData("username")),
			"unmute",
			tostring(player.name),
			tostring(player:getData("username"))))
		triggerClientEvent("tunrc_Admin.showMessage", resourceRoot, "unmute", admin, player)
	end
end)

addCommand("destroyCar", "moderator", function (admin, player)
	--return exports.tunrc_Core:mutePlayer(player, duration)
end)

addEvent("tunrc_Admin.executeCommand", true)
addEventHandler("tunrc_Admin.executeCommand", root, function (commandName, ...)
	executeCommand(client, commandName, ...)
end)