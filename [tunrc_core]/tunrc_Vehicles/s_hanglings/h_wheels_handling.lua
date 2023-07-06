function updateVehicleWheelAcceleration(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = 0.38
	local value1 = 0.74
	local value2 = 0.58
	local AdditionalValueAngleR = vehicle:getData("WheelsAngleR")
	local AdditionalValueAngleF = vehicle:getData("WheelsAngleF")
	local AdditionalValueCastor = vehicle:getData("WheelsCastor")
	local AdditionalValueWidthR = vehicle:getData("WheelsWidthR")
	local AdditionalValueWidthF = vehicle:getData("WheelsWidthF")
	value = value + (AdditionalValueAngleF / 20) - (AdditionalValueAngleR / 20) - (AdditionalValueWidthF / 20) + (AdditionalValueWidthR / 20)
	value1 = value1 - (AdditionalValueAngleR / 20) + (AdditionalValueWidthR / 20) - (AdditionalValueAngleF / 20) + (AdditionalValueWidthF / 20)  
	value2 = value2 - (AdditionalValueWidthF / 20) + (AdditionalValueCastor / 300) - (AdditionalValueWidthR / 20)
	setVehicleHandling(vehicle, "tractionBias", value)
	setVehicleHandling(vehicle, "tractionLoss", value1)
	setVehicleHandling(vehicle, "tractionMultiplier", value2)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "veh_acceleration" then
		updateVehicleWheelAcceleration(source)
	end
end)