addCommandHandler("dev",function()
	local boolean = not getDevelopmentMode() -- true/false
	setDevelopmentMode(boolean)
	outputChatBox("DevelopmentMode: "..tostring(boolean))
end)

addCommandHandler("premiuminfo",function()
	local timestamp = getRealTime(false).timestamp
	local premiuminfo = localPlayer:getData("premium_expires")
	outputDebugString("Non real time stamp premium: " ..premiuminfo.. ". non real time stamp:" .. timestamp)
end)