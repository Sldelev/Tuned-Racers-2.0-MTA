
addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Создание шейдера для исправления альфа-канала у объектов
	local shader = dxCreateShader("alphafix.fxc", 0, 0, false, "object")
	
	if (not shader) then return end
	engineApplyShaderToWorldTexture(shader, "*")
end)
