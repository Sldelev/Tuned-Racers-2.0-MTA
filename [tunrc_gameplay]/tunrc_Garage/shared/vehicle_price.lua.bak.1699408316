function getVehicleSellPrice(vehicleName, vehicleMileage)
    local priceTable = exports.tunrc_Shared:getVehiclePrices(vehicleName)
    if type(priceTable) ~= "table" or type(priceTable[1]) ~= "number" then
		return false
	end

    local minMileageFactor = exports.tunrc_Shared:getEconomicsProperty("vehicle_sell_min_mileage_factor")
    local maxMileage = exports.tunrc_Shared:getEconomicsProperty("vehicle_sell_max_mileage")
    local mileageFactor = minMileageFactor + (math.max(0, (maxMileage - vehicleMileage)) / maxMileage) * (1.0 - minMileageFactor)

    return math.floor(priceTable[1] * mileageFactor)
end
