local timeForced = false

function forceTime(hh, mm)
	setTime(hh, mm)
	setMinuteDuration(60 * 1000 * 60)

	timeForced = true
end

function restoreTime()
	timeForced = false
	triggerServerEvent("tunrc_Time.requireTime", resourceRoot)
end

addEvent("tunrc_Time.updateTime", true)
addEventHandler("tunrc_Time.updateTime", resourceRoot, function (time, duration)
	if timeForced then
		return 
	end
	if type(time) == "table" then
		setTime(time.hours, time.minutes)
	end
	if type(duration) == "number" then
		setMinuteDuration(duration)
	end
	setHeatHaze(0)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	restoreTime()
end)