local cameraViews = {
	0,1,2,3,5, -- Обычная камера
	DriftView,
	DriftViewA,
	CockpitView
}
local currentCameraViewIndex = 3
local currentCameraView

local function startCameraView(cameraView)
	if currentCameraView then
		currentCameraView.stop()
	end
	if cameraView and type(cameraView) == "table" then
		cameraView.start()
		currentCameraView = cameraView
		--toggleControl("change_camera", false)
	else
		if currentCameraView then
			setCameraTarget(localPlayer)
			setCameraMatrix(0, 0, 0)
			setCameraTarget(localPlayer)
			currentCameraView = nil
		end
		if localPlayer.vehicle then
			setCameraViewMode(cameraView)
		else
			--toggleControl("change_camera", true)
		end
	end
	return true
end

addEventHandler("onClientKey", root, function (key, down)
	if not down then
		return
	end
	if key ~= "v" then
		return
	end
	if exports.tunrc_Chat:isActive() == true then
		return
	end
	if localPlayer:getData("activeUI") and localPlayer:getData("activeUI") ~= "raceUI" and localPlayer:getData("activeUI") == "Chatinput" then
		return 
	end
	if not localPlayer.vehicle then
		startCameraView()
		return
	end
	currentCameraViewIndex = currentCameraViewIndex + 1
	if currentCameraViewIndex > 8 then
		currentCameraViewIndex = 1
	end
	if currentCameraViewIndex > #cameraViews then
		currentCameraViewIndex = 1
	end
	startCameraView(cameraViews[currentCameraViewIndex])
	cancelEvent()
end)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function ()
	startCameraView(cameraViews[currentCameraViewIndex])
	toggleControl("change_camera", false)
end)

addEventHandler("onClientVehicleEnter", root, function (player)
	if player ~= localPlayer then
		return
	end
	startCameraView(cameraViews[currentCameraViewIndex])
	toggleControl("change_camera", false)
end)

addEventHandler("onClientVehicleStartExit", root, function (player)
	if player ~= localPlayer then
		return
	end
	startCameraView()
	toggleControl("change_camera", true)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	if localPlayer.vehicle then
		startCameraView(cameraViews[currentCameraViewIndex])
	end
	toggleControl("change_camera", true)
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
	if currentCameraView then
		currentCameraView.stop()
	end
end)

function resetCameraView()
	startCameraView()
end