/*
Shader: Spot Light
Implementa Spot Lights
Thiago Dias Pastor 2011
*/

#define MaxLights 30
#define SKINNED_EFFECT_MAX_BONES   72

///Constantes
float4x4	World;
float4x4	View;
float4x4	Projection;

int activeLights;

float3		lightDirection[MaxLights];
float		lightDecayExponent[MaxLights];
float		lightAngleCosine[MaxLights];
float		lightRadius[MaxLights];

float3      LightPosition[MaxLights];
float4		LightColor[MaxLights];
float4		SpecularColor;
float		SpecularPower;
float		SpecularIntensity;
float4      AmbientColor;
float		AmbientIntensity;
float		DiffuseIntensity;

float4x3 Bones[SKINNED_EFFECT_MAX_BONES];
//int hasBones;
float3      camPosition;

///Textura e Samples para a textura Diffuse
texture DiffuseTexture;
sampler2D DiffuseSampler = sampler_state
{
	Texture = <DiffuseTexture>;
    ADDRESSU = CLAMP;
	ADDRESSV = CLAMP;
	MAGFILTER = ANISOTROPIC;
	MINFILTER = ANISOTROPIC;
	MIPFILTER = LINEAR;
};

///Entrada do VertexShader
struct VertexShaderInput
{
    float3 Position : POSITION0;
	float3 Normal : Normal0;
	float2 TexCoord : TexCoord0;
	int4 boneIndex  : BLENDINDICES0; 
    float4 Weights  : BLENDWEIGHT0;
};

///Saida do Vertex Shader
struct VertexShaderOutput
{
    float4 Position			: POSITION0;	        
    float3 N				: TEXCOORD0;     
	float2 TextureCoord		: TEXCOORD1;     
	float3 V				: TEXCOORD2;
	float3 WorldPosition	: TEXCOORD3;
	
};

void Skin(inout VertexShaderInput vin, uniform int boneCount)
{

	float4x3 skinning = 0;

    [unroll]
    for (int i = 0; i < boneCount; i++)
    {
        skinning += Bones[vin.boneIndex[i]] * vin.Weights[i];
    }

    vin.Position.xyz = mul(float4(vin.Position,1), skinning);
    vin.Normal = mul(vin.Normal, (float3x3)skinning);
}

///VertexShader
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

	//if (hasBones == 1) {
		Skin(input, 4);
	//}
	
	///Transforma os vertices
    float4 worldPosition = mul(float4(input.Position,1), World);
    float4 viewPosition = mul(worldPosition, View);
    output.Position = mul(viewPosition, Projection);
	
	output.N = mul(float4(input.Normal,0), World);
	output.TextureCoord = input.TexCoord;
    output.V = camPosition -  worldPosition;	
	output.WorldPosition = worldPosition;
    return output;
}

///Pixel Shader 
float4 PixelShaderAmbientFunction(VertexShaderOutput input) : COLOR0
{
	float4 finalColor = float4(0,0,0,0);
	float4 diffuseColor = tex2D(DiffuseSampler,input.TextureCoord);    
	//return diffuseColor;
	for(int i = 0 ; i < activeLights; i ++)
	{
			float3 LightDir = LightPosition[i] - input.WorldPosition;						
			float attenuation = saturate(1.0f - length(LightDir) / lightRadius[i]);    			
			LightDir = normalize(LightDir);        
			float SdL = dot(lightDirection[i], -LightDir);  
 
			if(SdL > lightAngleCosine[i])  
			{
				float spotIntensity = pow(SdL, lightDecayExponent[i]);  
				float3 Normal = normalize(input.N);				
				float3 ViewDir = normalize(input.V);    		
				float Diff = saturate(dot(Normal, LightDir));     
				float3 Reflect = normalize(2 * Diff * Normal - LightDir);  
				float Specular = pow(saturate(dot(Reflect, ViewDir)), SpecularPower); 
				finalColor += AmbientColor*AmbientIntensity + spotIntensity * attenuation *LightColor[i] * DiffuseIntensity * diffuseColor * Diff + SpecularIntensity * SpecularColor * Specular; 
			}
	}
	return finalColor;    
}

technique TechniqueNormal
{
    pass Pass1
    {        
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderAmbientFunction();
    }
}

