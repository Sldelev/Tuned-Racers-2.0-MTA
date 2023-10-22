//---------------------------------------------------------------------
// Settings
//---------------------------------------------------------------------
float sCamber = 10;
float sWidth = 0.2;
float sRotationX = 0;
float Castor = 0;
float CastorCoeff = 0;
float sRotationZ = 0;
float offset = 0;
float4 sColor = float4(1, 1, 1, 1);

float flakesSize = 12; // размер, допустим я на стёкла ставил 25, на кузов 1, ориентируйся на эти цифры, 1 стандарт
float normalFactor = 3; // насколько сильно давить нормали (от 0 до 1)
float ChromePower = 0.1; // сила отражения хрома

float4 ColorFlakes = float4(0.0,0.0,0.0,1); // это я накинул доп освещение, если тебе не нужно выкинь

float4 ColorNormals = float4(0.4,0.4,0.4,1); // цвет нормалек

texture sReflectionTexture;
texture sNormalTexture;
texture sSpecularTexture;

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "mta-helper.fx"

sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler SpecularSampler = sampler_state // Спекуляр
{
   Texture = (sSpecularTexture);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = POINT;
   MIPMAPLODBIAS = 0.000000;
};

sampler NormalSampler = sampler_state // это нормал мап сам
{
   Texture = (sNormalTexture);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = POINT;
   MIPMAPLODBIAS = 0.000000;
};

samplerCUBE ReflectionSampler = sampler_state
{
    Texture = (sReflectionTexture);
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
    MIPMAPLODBIAS = 0.000000;
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
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


//////////////////////////////////////////////////////////////////////////
// Function to Index this texture - use in vertex or pixel shaders ///////
//////////////////////////////////////////////////////////////////////////

float4 quat_from_axis_angle(float3 axis, float angle)
{
    float4 qr;
    float half_angle = (angle * 0.5) * 3.14159 / 180.0;
    qr.x = axis.x * sin(half_angle);
    qr.y = axis.y * sin(half_angle);
    qr.z = axis.z * sin(half_angle);
    qr.w = cos(half_angle);
    return qr;
}

float4 quat_conj(float4 q)
{
    return float4(-q.x, -q.y, -q.z, q.w);
}

float4 quat_mult(float4 q1, float4 q2)
{
  float4 qr;
  qr.x = (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y);
  qr.y = (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x);
  qr.z = (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w);
  qr.w = (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z);
  return qr;
}

float3 rotate_vertex_position(float3 position, float3 axis, float angle)
{
  float4 qr = quat_from_axis_angle(axis, angle);
  float4 qr_conj = quat_conj(qr);
  float4 q_pos = float4(position.x, position.y, position.z, 0);

  float4 q_tmp = quat_mult(qr, q_pos);
  qr = quat_mult(q_tmp, qr_conj);

  return float3(qr.x, qr.y, qr.z);
}

//------------------------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//------------------------------------------------------------------------------------------

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);

    VS.Position *= float3(1 + sWidth, 1, 1);
    VS.Position = rotate_vertex_position(VS.Position, float3(1, 0, 0), sRotationX);
    VS.Position = rotate_vertex_position(VS.Position, float3(0, 1, 0), sCamber + Castor * CastorCoeff);
    VS.Position = rotate_vertex_position(VS.Position, float3(0, 0, 1), sRotationZ);
    VS.Position += rotate_vertex_position(float3(offset, 0, 0), float3(0, 0, 1), sRotationZ);
    // Рассчитать позицию вершины на экране
    PS.Position = MTACalcScreenPosition(VS.Position);

    // Передать tex coords
    PS.TexCoord = VS.TexCoord;

    VS.Normal = rotate_vertex_position(VS.Normal, float3(1, 0, 0), sRotationX);
    VS.Normal = rotate_vertex_position(VS.Normal, float3(0, 1, 0), sCamber + Castor * CastorCoeff);
    VS.Normal = rotate_vertex_position(VS.Normal, float3(0, 0, 1), sRotationZ);
    float3 worldNormal = mul(VS.Normal, (float3x3)gWorld);

    // ------------------------------- PAINT ----------------------------------------

    float3 worldPosition = MTACalcWorldPosition( VS.Position );
    PS.View = normalize(gCameraPosition - worldPosition);

    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );

    // Transfer some stuff
    PS.TexCoord = VS.TexCoord;
    PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );
    PS.NormalSurf = VS.Normal;
	
	MTAFixUpNormal( VS.Normal );

    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 50.0;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 50.0;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 50.0;
	
	float specPower = gMaterialSpecPower;
	
	PS.Diffuse2.rgb = ColorFlakes.rgb*MTACalculateSpecular( gCameraDirection, gLight0Direction, PS.Normal, specPower );
    PS.Diffuse2.rgb = saturate(PS.Diffuse2.rgb);
    PS.Diffuse = MTACalcGTACompleteDiffuse(PS.Normal, VS.Diffuse);
    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 OutColor = 1;

    float4 paintColor = sColor;
    float4 maptex = tex2D(Sampler0, PS.TexCoord.xy);
    float4 delta = float4(0, 0, 0, 1);
    if (dot(delta,delta) < 0.2) {
        float4 Color = maptex * PS.Diffuse * 1;
        Color.a = PS.Diffuse.a;
        return Color;
    }

    // Compute paint colors
    float4 base = gMaterialAmbient;
	
	// залупа под спекуляр
	
	float4 vFlakesSpecular = tex2D(SpecularSampler, PS.TexCoord.xy*flakesSize);

    // Get the surface normal
    float3 vNormal = PS.Normal;

	float4 vFlakesNormal = tex2D(NormalSampler, PS.TexCoord.xy);

    vFlakesNormal = 2 * vFlakesNormal - 1.0;

    float3 vNp2 = ( vFlakesNormal ) ;

    float3 vView = normalize( PS.View );

    float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent, PS.Binormal, PS.Normal ) );
    float3 vNp2World = normalize( mul( mTangentToWorld, vNp2 ));
    float fFresnel2 = saturate( dot( vNp2World, vView ));

    // Count reflection vector
    float3 vReflection = reflect(PS.View,PS.Normal);

    // Hack in some bumpyness
    vReflection.x+= vFlakesSpecular.x * 0.05;
    vReflection.y+= vFlakesSpecular.y * 0.05;
    // Sample environment map using this reflection vector:
    float4 envMap = texCUBE( ReflectionSampler, -vReflection.xzy );
    // Premultiply by alpha:

    envMap.rgb = pow(envMap.rgb, 3);
    // Brighten the environment map sampling result:
    envMap.rgb *= ChromePower;
    envMap.rgb += PS.BottomColor.rgb;
    // Sample dust texture:

    // Combine result of environment map reflection with the paint color:
    float fEnvContribution = 1.0 - 0.5 * fFresnel2;

    float4 finalColor = envMap * fEnvContribution / 2 + base * 0.1;
	
    finalColor.rgb += PS.Diffuse2.rgb * 0.75;
    finalColor.a = 0.5;
    // Bodge in the car colors
    float4 Color;
    Color.rgb = 0.01 + finalColor + paintColor * PS.Diffuse;
	
	// те самые заветные нормал мапы

    float4 normals = pow( fFresnel2, 6 )*normalFactor;

    normals *= ColorNormals + vFlakesSpecular;

    normals.rgb = normals.rgb*normals.rgb*normals.rgb;
	
	Color += normals*0.3;

    Color *= maptex;
    Color.a = PS.Diffuse.a;
    return Color;
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique tec0
{
    pass P0
    {
		DepthBias=-0.000000002;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
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
