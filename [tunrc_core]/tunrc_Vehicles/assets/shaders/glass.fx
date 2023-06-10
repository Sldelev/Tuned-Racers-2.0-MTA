texture gTexture;

technique TexReplace
{
	pass P0
	{
		CullMode = NONE;
		AlphaOp[0] = ADD;
		Texture[0] = gTexture;
	}
}
