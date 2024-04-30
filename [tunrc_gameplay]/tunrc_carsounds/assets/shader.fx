texture gTexture;

sampler Sampler0 = sampler_state
{
	Texture = (gTexture);
};

struct PSInput
{
	float4 Diffuse : COLOR0;
	float2 TexCoord : TEXCOORD0;
};

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float4 finalColor = tex2D(Sampler0, PS.TexCoord);
	finalColor.rgb *= 1.25;
	finalColor.rgb *= PS.Diffuse.rgb;
	finalColor.rgb *= PS.Diffuse.a;
	return saturate(finalColor);
}

technique backfire_downsided
{
	pass P0
	{
		BlendOp = 5;
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

// Fallback
technique fallback
{
	pass P0
	{
		// Just draw normally
	}
}
