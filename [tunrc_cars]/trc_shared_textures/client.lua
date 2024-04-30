function CarSharedTexture()
	if exports.tunrc_Config:getProperty("graphics.textures_quality") == 0 then
		cartxdshared = engineLoadTXD("shared_tex_low.txd")
	elseif exports.tunrc_Config:getProperty("graphics.textures_quality") == 1 then
		cartxdshared = engineLoadTXD("shared_tex_mid.txd")
	else
		cartxdshared = engineLoadTXD("shared_tex.txd")
	end
	return cartxdshared
end