 addEvent("tunrc_Garage.previewHandling", true)
 addEventHandler("tunrc_Garage.previewHandling", resourceRoot, function (vehicle, name, value)
 	if not isElement(vehicle) then
 		return
 	end
 	vehicle:setData(name, value)
 end)
