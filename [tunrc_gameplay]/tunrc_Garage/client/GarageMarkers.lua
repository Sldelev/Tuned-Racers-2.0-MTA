local garageMarker
addEvent("tunrc_Markers.use", false)

local function updateGarageMarker()
	garageMarker.position = garage.position
end

-- Перемещение маркера гаража при покупке/продаже дома или входе на сервер
addEventHandler("onClientElementDataChange", localPlayer, function (dataName)
	if dataName == "_id" then
		updateGarageMarker()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	garageMarker = exports.tunrc_Markers:createMarker("garage", Vector3(0, 0, 0), 180)

	addEventHandler("tunrc_Markers.use", garageMarker, function()
		exports.tunrc_Garage:enterGarage()
	end)
	-- Метка на радаре
	local garageBlip = createBlip(0, 0, 0, 27)
	garageBlip:attach(garageMarker)
	garageBlip:setData("text", "blip_garage")

	updateGarageMarker()
end)