addEvent("tunrc_DriftPoints.earnedPoints")
addEventHandler("tunrc_DriftPoints.earnedPoints", resourceRoot, function (points)
	triggerServerEvent("tunrc_DriftPoints.earnedPoints", resourceRoot, points)
end)