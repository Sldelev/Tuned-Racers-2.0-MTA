local function handlePlayerFirstSpawn(player)
	if not isElement(player) then
		return
	end

	player:setData("tutorialActive", true)
	player:setData("skin", math.random(0, 30))
	player:setData("doCore.state", false)
	player.model = 2
	
	local startMoney = exports.tunrc_Shared:getEconomicsProperty("start_money")
	player:setData("money", startMoney)
	
	local startVehicleName = exports.tunrc_Shared:getGameplaySetting("start_vehicle")
	if not startVehicleName then
		return
	end
	local startVehicleModel = exports.tunrc_Shared:getVehicleModelFromName(startVehicleName)
	UserVehicles.addVehicle(player:getData("_id"), startVehicleModel, 
		function()
			if isElement(player) then
				PlayerSpawn.spawn(player)
			end
		end)
end

-- Вход игрока на сервер
addEvent("tunrc_Core.login", false)
addEventHandler("tunrc_Core.login", root, function (success)
	if not success then
		return
	end
	local player = source
	UserVehicles.getVehiclesIds(player:getData("_id"), function(vehicles)
		if type(vehicles) == "table" and #vehicles > 0 then
			PlayerSpawn.spawn(player)
		else
			handlePlayerFirstSpawn(player)
		end
	end)
end)

addEvent("tunrc_Core.selfKick", true)
addEventHandler("tunrc_Core.selfKick", root, function ()
	if client.type == "player" then
		client:kick("You have been disconnected")
	end
end)

addEventHandler("onPlayerChangeNick", root, function (oldNick, newNick, changedByPlayer)
	if not changedByPlayer then
		return
	end
	exports.tunrc_Logger:log("nicknames", ("Player %s changed nickname to %s"):format(tostring(oldNick), tostring(newNick)), true)
end)
