texture gTexture;
texture sReflectionTexture;

float alphaCurrentTexture = 1.0; // альфа всего вместе (от 0 до 1)
float ChromePower = 0.25; // сила отражения хрома

float4 ColorFlakes = float4(0.5,0.5,0.5,1); // это я накинул доп освещение, если тебе не нужно выкинь

float4 ColorTexture = float4(0.4,0.4,0.4,1); // цвет текстуры

#include "mta-helper.fx" // без этого работать нихуя не будет

sampler Sampler0 = sampler_state // стандартная текстура, короче dxSetShaderValue(shader, 'gTexture0', tex) тебе для замены
{
    Texture         = (gTexture0);
};

samplerCUBE ReflectionSampler = sampler_state
{
    Texture = (sReflectionTexture);
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
    MIPMAPLODBIAS = 0.000000;
};

// дополнительные хуйни
struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};



struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 Tangent : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
    float3 NormalSurf : TEXCOORD4;
    float3 View : TEXCOORD5;
    float4 BottomColor : TEXCOORD6;
    float3 SparkleTex : TEXCOORD7;
    float4 Diffuse2 : COLOR1;
};

// определяем залупу нужную
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    float3 worldPosition = MTACalcWorldPosition( VS.Position );
    PS.View = normalize(gCameraPosition - worldPosition);
    
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );
    
    PS.TexCoord = VS.TexCoord;
    PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );

    MTAFixUpNormal( VS.Normal );

    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 50.0;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 50.0;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 50.0;

    float specPower = gMaterialSpecPower;

    PS.Diffuse2.rgb = ColorFlakes.rgb*MTACalculateSpecular( gCameraDirection, gLightDirection, PS.Normal, specPower );
    PS.Diffuse2.rgb = saturate(PS.Diffuse2.rgb);
    PS.Diffuse = MTACalcGTACompleteDiffuse(PS.Normal, VS.Diffuse);
    return PS;
}

// тут уже идёт рисовка и наложение
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float4 maptex = tex2D(Sampler0,PS.TexCoord.xy);
	
    float3 vNp2 = ( PS.Normal ) ;

    float3 vView = normalize( PS.View );

    float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent, PS.Binormal, PS.Normal ) );
    float3 vNp2World = normalize( mul( mTangentToWorld, vNp2 ));
    float fFresnel2 = saturate( dot( vNp2World, vView ));

	// Count reflection vector
    float3 vReflection = reflect(PS.View,PS.Normal);

    // Hack in some bumpyness
    vReflection.x+= vNp2.x * 0.1;
    vReflection.y+= vNp2.y * 0.1;
    // Sample environment map using this reflection vector:
    float4 envMap = texCUBE( ReflectionSampler, -vReflection.xzy );

    envMap.rgb = pow(envMap.rgb, 3);
    // Brighten the environment map sampling result:
    envMap.rgb *= ChromePower;
    envMap.rgb += PS.BottomColor.rgb;
	
	// Combine result of environment map reflection with the paint color:
    float fEnvContribution = 1.0 - 0.5 * fFresnel2;


    float4 finalColor = envMap * fEnvContribution / 2 + ColorTexture*maptex;

    // доп свет
    finalColor.rgb += PS.Diffuse2.rgb*0.35;

	finalColor.a = maptex.a;
    return finalColor;
}

technique TexReplace
{
	pass P0
	{
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
		
		Texture[0] = gTexture;
	}
}

technique fallback
{
    pass P0
    {
    
    }
}
