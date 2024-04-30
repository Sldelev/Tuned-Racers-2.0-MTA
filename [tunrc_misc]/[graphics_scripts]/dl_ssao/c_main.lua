local isDebugMode = false

local scx, scy = guiGetScreenSize()
local renderTarget = {RTNormal = nil, isOn = false}
aoShader = {shader = nil, colorRT = nil, enabled = false}

function enableAO()
	if aoShader.enabled then return end
	aoShader.shader, tec = dxCreateShader( "fx/primitive3D_ssao.fx" )		
	outputDebugString('dl_ssao: Using technique '..tec)
	aoShader.colorRT = dxCreateRenderTarget(scx, scy, false)
	isAllValid = true

		isAllValid = aoShader.shader and aoShader.colorRT
		if isAllValid then
			dxSetShaderValue( aoShader.shader, "fViewportSize", scx, scy )
			dxSetShaderValue( aoShader.shader, "sPixelSize", 1 / scx, 1 / scy )
			dxSetShaderValue( aoShader.shader, "sAspectRatio", scx / scy )
			dxSetShaderValue( aoShader.shader, "sRTColor", aoShader.colorRT )
			
			if exports.tunrc_Config:getProperty("graphics.ssao_quality") == 0 then
				dxSetShaderValue( aoShader.shader, "iMXAOSampleCount", 8 )
			elseif exports.tunrc_Config:getProperty("graphics.ssao_quality") == 1 then
				dxSetShaderValue( aoShader.shader, "iMXAOSampleCount", 16 )
			elseif exports.tunrc_Config:getProperty("graphics.ssao_quality") == 2 then
				dxSetShaderValue( aoShader.shader, "iMXAOSampleCount", 32 )
			elseif exports.tunrc_Config:getProperty("graphics.ssao_quality") == 3 then
				dxSetShaderValue( aoShader.shader, "iMXAOSampleCount", 64 )
			end
			
			if isDebugMode then
				dxSetShaderValue( aoShader.shader, "fBlend", 5, 6 )
			else
				dxSetShaderValue( aoShader.shader, "fBlend", 1, 3 )	
			end
		end
    aoShader.enabled = isAllValid
end

function disableAO()
	if not aoShader.enabled then return end
	aoShader.enabled = false
	destroyElement(aoShader.shader)
	aoShader.shader = nil
	destroyElement(aoShader.colorRT)
	aoShader.colorRT = nil
end

local trianglestrip_quad = {{-1, -1, 0, 0, 0}, {-1, 1, 0, 0, 1}, {1, -1, 0, 1, 0}, {1, 1, 0, 1, 1}}

local cPosX, cPosY, cPosZ = getCameraMatrix()
addEventHandler("onClientPreRender", root, function()
	if aoShader.enabled then
		dxSetRenderTarget(aoShader.colorRT)
		dxSetRenderTarget()
		dxDrawMaterialPrimitive3D( "trianglestrip", aoShader.shader, false, unpack( trianglestrip_quad ) )
	end
end, true, "high+8" )



