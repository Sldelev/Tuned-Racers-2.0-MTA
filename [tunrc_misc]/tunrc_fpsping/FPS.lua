F_SCREEN_X, F_SCREEN_Y 	= guiGetScreenSize();

local iFPS 				= 0;
local iFrames 			= 0;
local iStartTick 		= getTickCount();
    
function GetFPS()
	return iFPS;
end
    
addEventHandler( "onClientRender", root,
	function()
		iFrames = iFrames + 1;
		if getTickCount() - iStartTick >= 1000 then
			iFPS 		= iFrames;
			iFrames 	= 0;
			iStartTick 	= getTickCount();
		end
	end
);

local myRenderTarget

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        myRenderTarget = dxCreateRenderTarget(200, 200, true)       -- Create a render target

        if (myRenderTarget) then 
            updateRenderTarget()     -- Our function to draw to the render target (see below)
        end
    end
)

addEventHandler( "onClientRender", root,
    function()
        if myRenderTarget then
			if F_SCREEN_X ~= 1920 then
				dxDrawImage(F_SCREEN_X * (1835/1920), F_SCREEN_Y / 1.04, 100, 100, myRenderTarget)
			else
				dxDrawImage(F_SCREEN_X / 1.033, F_SCREEN_Y / 1.03, 100, 100, myRenderTarget)
			end
        end
    end
)

function updateRenderTarget()
    dxSetRenderTarget(myRenderTarget, true)
    dxSetBlendMode("modulate_add")  -- Set 'modulate_add' when drawing stuff on the render target
		
		dxDrawText( 
			"FPS: " .. GetFPS(), 10, 10, 0, 0, tocolor( 225, 225, 225, 255 ), 2, "default-bold");      -- Draw a square with random color

    dxSetBlendMode("blend")  -- Restore default blending
    dxSetRenderTarget()      -- Restore default render target
end
setTimer ( updateRenderTarget, 1000, 0)