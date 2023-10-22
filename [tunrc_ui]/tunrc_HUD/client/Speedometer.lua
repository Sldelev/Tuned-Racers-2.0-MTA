Speedometer = {}
local UI = exports.tunrc_UI
local PROPERTY_SHOW_SPEEDO = "ui.draw_speedo"

local screenWidth, screenHeight = guiGetScreenSize()
local SpeedometerRadius = 115
local SpeedometerOffset = 20

local function getVehicleSpeed()
	if not localPlayer.vehicle then
		return 0
	end
	return localPlayer.vehicle.velocity:getLength() * 180
end

function Speedometer.start()
	
	-- фон спидометра
	SpeedometerBack = UI:createNonCircle {
		x       = screenWidth - SpeedometerRadius - SpeedometerOffset,
        y       = screenHeight - SpeedometerRadius - SpeedometerOffset,
		radius = SpeedometerRadius,
		startangle = 0,
		endangle = 360,
		color = tocolor (235,235,235),
		darkToggle = true,
		darkColor = tocolor(30, 30, 30),
	}
	UI:addChild(SpeedometerBack)
	
	-- фон спидометра
	SpeedometerArrow = UI:createNonCircle {
		x       = 0,
        y       = 0,
		radius = SpeedometerRadius + 10,
		startangle = 135,
		endangle = 360,
		color = tocolor(130, 130, 200)
	}
	UI:addChild(SpeedometerBack, SpeedometerArrow)
	
	-- фон спидометра
	SpeedometerTopShadow = UI:createNonCircle {
		x       = 0,
        y       = 0,
		radius = SpeedometerRadius - 5,
		startangle = 0,
		endangle = 360,
		color = tocolor(20, 20, 20, 20)
	}
	UI:addChild(SpeedometerArrow, SpeedometerTopShadow)
	
	-- фон спидометра
	SpeedometerTop = UI:createNonCircle {
		x       = 0,
        y       = 0,
		radius = SpeedometerRadius - 10,
		startangle = 0,
		endangle = 360,
		color = tocolor (245,245,245),
		darkToggle = true,
		darkColor = tocolor(40, 40, 40),
	}
	UI:addChild(SpeedometerTopShadow, SpeedometerTop)
	
	SpeedometerSpeedLabel = UI:createDpLabel {
		x = 0,
		y = 0,
		width = 0,
		height = 0,
		text = "1",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255),
		fontType = "defaultBigLarger"
	}
	UI:addChild(SpeedometerTop, SpeedometerSpeedLabel)
	UIDataBinder.bind(SpeedometerSpeedLabel, "vehicle_speed", function ()
	 return string.format ("%u", tostring(getVehicleSpeed()))
	end)
	
	SpeedometerGearLabel = UI:createDpLabel {
		x = 0,
		y = -75,
		width = 0,
		height = 0,
		text = "1",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "defaultLarger"
	}
	UI:addChild(SpeedometerTop, SpeedometerGearLabel)
	UIDataBinder.bind(SpeedometerGearLabel, "vehicle_gear", function ()
		if getVehicleSpeed() == 0 then
			return "N"
		elseif getVehicleCurrentGear(localPlayer.vehicle) == 0 then
			return "R"
		else
			return string.format ("%u", tostring(exports.tunrc_carsounds:getVehicleGear(localPlayer.vehicle)))
		end
	end)
	
	SpeedometerMileageLabel = UI:createDpLabel {
		x = 0,
		y = 75,
		width = 0,
		height = 0,
		text = "1",
		alignX = "center",
		alignY = "center",
		color = tocolor (0, 0, 0, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "default"
	}
	UI:addChild(SpeedometerTop, SpeedometerMileageLabel)
	UIDataBinder.bind(SpeedometerMileageLabel, "vehicle_mileage", function ()
		return string.format("%u", localPlayer.vehicle:getData("mileage")) .. " KM"
	end)
	
end

function Speedometer.refresh()

	if not localPlayer.vehicle then
		return
	else
		if localPlayer.vehicle.controller ~= localPlayer then
			return
		end
	end

	local progress = (exports.tunrc_carsounds:getVehicleRPM(localPlayer.vehicle) / 10000) + 0.35

	local endAngle = UI:getEndangle(SpeedometerBack)
	UI:setEndangle(SpeedometerArrow, endAngle * progress)

	UIDataBinder.refresh()
end

addEventHandler("onClientRender", root, function ()
	Speedometer.refresh()
	Speedometer.setVisible()
end)

function Speedometer.isVisible()
    return UI:getVisible(SpeedometerBack)
end

function Speedometer.setVisible(visible)
    visible = not not visible
	
	if not localPlayer.vehicle then
		UI:setVisible(SpeedometerBack, false)
	else
		if localPlayer.vehicle.controller ~= localPlayer then
			return
		end
		UI:setVisible(SpeedometerBack, exports.tunrc_Config:getProperty(PROPERTY_SHOW_SPEEDO))
	end
	
	if not localPlayer:getData("activeUI") then
        return false
    end 
	
    UI:setVisible(SpeedometerBack, visible)
    UIDataBinder.setActive(visible)
end
