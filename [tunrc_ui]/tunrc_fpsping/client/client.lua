FPS = {}
UI = exports.tunrc_UI
local FPS_SHOW_PROPERTY = "ui.show_fps"
local screenWidth, screenHeight = UI:getScreenSize()
local width = 40
local height = 30
local offset = 30
local fpspanel

local iFPS 				= 0;
local iFrames 			= 0;
local iStartTick 		= getTickCount();

function FPS.create()
	if fpspanel then
		return
	end
	
	fpspanel = UI:createTrcRoundedRectangle {
		x       = screenWidth - width - offset,
		y       = 13,
		width   = width,
		height  = height,
		radius = 10,
		color = tocolor(220, 220, 220),
		hover = true,
		hoverColor = tocolor(130, 130, 200),
		darkToggle = true,
		darkColor = tocolor(50, 50, 50),
		hoverDarkColor = tocolor(30, 30, 30),
		shadow = true
	}
	UI:addChild(fpspanel)
		
	FPSTitle = UI:createDpLabel {
		x = width / 2,
		y = 2,
		width = 0,
		height = 0,
		text = "100",
		alignX = "center",
		color = tocolor (50, 50, 50, 150),
		darkToggle = true,
		darkColor = tocolor(255, 255, 255, 150),
		fontType = "lightSmall",
		alignX = "center"
	}
	UI:addChild(fpspanel, FPSTitle)
end
addEventHandler("onClientResourceStart", resourceRoot, FPS.create)

function FPS.refresh()
	if localPlayer:getData("activeUI") or localPlayer:getData("tunrc_Core.state") then
		UI:setVisible(fpspanel, false)
        return
    end

	iFrames = iFrames + 1;
	if getTickCount() - iStartTick >= 1000 then
		iFPS 		= iFrames;
		iFrames 	= 0;
		iStartTick 	= getTickCount();
	end
	
	UI:setText(FPSTitle, iFPS)
	UI:setVisible(fpspanel, exports.tunrc_Config:getProperty(FPS_SHOW_PROPERTY))
end
addEventHandler ( "onClientRender", root, FPS.refresh )

function isVisible()
    return UI:getVisible(fpspanel)
end