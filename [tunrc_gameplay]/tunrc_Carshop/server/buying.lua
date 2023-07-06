addEvent("tunrc_Carshop.buyVehicle", true)
addEventHandler("tunrc_Carshop.buyVehicle", resourceRoot, function (model)
	if type(model) ~= "number" then
		triggerClientEvent(client, "tunrc_Carshop.buyVehicle", resourceRoot, false)
		return
	end

	local level = client:getData("level")
	local money = client:getData("money")
	if not level or not money then
		triggerClientEvent(client, "tunrc_Carshop.buyVehicle", resourceRoot, false)
		return
	end

	local vehicleName = exports.tunrc_Shared:getVehicleNameFromModel(model)
	local priceInfo = exports.tunrc_Shared:getVehiclePrices(vehicleName)
	if type(priceInfo) ~= "table" then
		triggerClientEvent(client, "tunrc_Carshop.buyVehicle", resourceRoot, false)
		return
	end
	if not priceInfo[2] then
		priceInfo[2] = 1
	end
	if priceInfo[2] > level then
		-- Слишком маленький уровень
		triggerClientEvent(client, "tunrc_Carshop.buyVehicle", resourceRoot, false)
		return
	end
	if priceInfo[1] > money then
		triggerClientEvent(client, "tunrc_Carshop.buyVehicle", resourceRoot, false)
		-- Недостаточно денег
		return
	end
	if exports.tunrc_Core:addPlayerVehicle(client, model) then
		if client:getData("isPremium") then
			client:setData("money", money - (priceInfo[1] / 1.25))
		else
			client:setData("money", money - priceInfo[1])
		end
		triggerClientEvent(client, "tunrc_Carshop.buyVehicle", resourceRoot, true)
	else
		triggerClientEvent(client, "tunrc_Carshop.buyVehicle", resourceRoot, false)
	end
end)