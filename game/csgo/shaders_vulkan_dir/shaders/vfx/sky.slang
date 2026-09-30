//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Used to draw the skybox";
	DevShader = false;
	Version = 5;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	Forward();
	CsgoForward();
	ToolsVis();
	ToolsShadingComplexity(S_MODE_TOOLS_SHADING_COMPLEXITY);
}

FEATURES
{
	Feature( F_LIGHTING_ONLY, 0..1, "Rendering" );
	Feature( F_TEXTURE_FORMAT2, 0..6 (0="BC6H (HDR compressed - recommended)", 1="Dxt1 (LDR)", 2="HDR (float16)", 3="RGB (8-bit uncompressed)", 4="YCoCg (dxt compressed)", 5="RGBM (dxt compressed)", 6="RGBM (8-bit uncompressed)"), "Format" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 vPositionOs : POSITION0  < Semantic( PosXyz ); >;                                      
};

VS
{
	StaticCombo( S_LIGHTING_ONLY, F_LIGHTING_ONLY );
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_matSkyWsToOs < Attribute("SkyWsToOs"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    column_major float4x4 _Globals_1_g_matSkyWsToOs : packoffset(c0);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float PerViewConstantBuffer_t_1_m1 : packoffset(c23.z);
	    float PerViewConstantBuffer_t_1_m2 : packoffset(c23.w);
	    float4 PerViewConstantBuffer_t_1_m3 : packoffset(c24);
	    float3 PerViewConstantBuffer_t_1_m4 : packoffset(c26);
	};
	
	
	static float4 gl_Position;
	static float4 vPositionOs;
	static float3 output_0;
	static float3 output_1;
	
	struct VS_INPUT
	{
	    float4 vPositionOs : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float3 _5578 = PerViewConstantBuffer_t_1_m4.xyz + (vPositionOs.xyz * (PerViewConstantBuffer_t_1_m1 + PerViewConstantBuffer_t_1_m2));
	    float4 _17914 = mul(PerViewConstantBuffer_t_1_m0, (float4(_5578.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m3 * 1.0f)).xyzw);
	    output_0 = normalize(mul(float4(vPositionOs.xyz, 0.0f), _Globals_1_g_matSkyWsToOs).xyz);
	    output_1 = _5578;
	    _17914.y = -_17914.y;
	    gl_Position = _17914;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_SHADING_COMPLEXITY, 0..1 );
	StaticCombo( S_TEXTURE_FORMAT, F_TEXTURE_FORMAT2 );
	DynamicCombo( D_FOG_TYPE, 0..2 );
	DynamicCombo( D_MIN_ANGULAR_FOG, 0..1 );
	DynamicCombo( D_QUAD_OVERDRAW, 0..1 );
	DynamicComboRule( Requires( D_MIN_ANGULAR_FOG, D_FOG_TYPE==2 ) );
	DynamicComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, D_FOG_TYPE ) );
	DynamicComboRule( Requires( D_QUAD_OVERDRAW, S_MODE_TOOLS_SHADING_COMPLEXITY ) );
	
	float g_flFogMaxDotEnd < Attribute("FogMaxEnd"); UiType(Slider); >;
	float g_flFogMaxDotStart < Attribute("FogMaxStart"); UiType(Slider); >;
	float g_flFogMinDotEnd < Attribute("FogMinEnd"); UiType(Slider); >;
	float g_flFogMinDotStart < Attribute("FogMinStart"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	RWTexture2D<float4> g_tQuadOverdrawMutexUAV < Attribute("QuadOverdrawMutexUAV"); >;
	RWTexture2D<float4> g_tQuadOverdrawUAV < Attribute("QuadOverdrawUAV"); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(RGBA16161616F); SrgbRead(false); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(BC6H); SrgbRead(false); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, Box(SkyTexture), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float4 g_vShadingComplexity < Source(ShadingComplexity); UiType(VectorText); >;
	float3 g_vTint < Default3(1, 1, 1); Attribute("SkyTint"); UiType(VectorText); >;
	
	// Texture
	CreateInputTexture2D(SkyTexture, Linear, 8, "ConvertToYCoCg", "", "Texture", Default4(0, 0, 0, 1));
	CreateInputTexture2D(SkyTexture, Srgb, 8, "", "", "Texture", Default4(1, 1, 1, 0));
	float g_flBrightnessExposureBias < Range(-10, 10); UiType(Slider); UiGroup("Texture"); Expression(pow(2,this)); >;
	float g_flHorizonOffset < Range(-0.2, 0.2); UiType(Slider); UiGroup("Texture"); >;
	float g_flRenderOnlyExposureBias < Range(-10, 10); UiType(Slider); UiGroup("Texture"); Expression(pow(2,this)); >;
	float g_flRotation < UiType(Slider); UiGroup("Texture"); >;
	
	
	// Variant parameters
	CreateInputTexture2D(SkyTexture, Linear, 8, "ConvertToYCoCg", "", "Texture", Default4(0, 0, 0, 1));
	CreateInputTexture2D(SkyTexture, Srgb, 8, "", "", "Texture", Default4(1, 1, 1, 0));
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(RGBA16161616F); SrgbRead(false); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Linear); OutputFormat(BC6H); SrgbRead(false); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGB, Box(SkyTexture), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, Box(SkyTexture), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	TextureCube g_tSkyTexture < Channel(RGBA, RGBM(SkyTexture), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _2;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flBrightnessExposureBias : packoffset(c4.z);
	    float _Globals_1_g_flRenderOnlyExposureBias : packoffset(c4.w);
	    float3 _Globals_1_g_vTint : packoffset(c5);
	    float _Globals_1_g_flHorizonOffset : packoffset(c5.w);
	    float _Globals_1_g_flRotation : packoffset(c6);
	};
	
	TextureCube<float4> g_tSkyTexture : register(t50, space1);
	SamplerState DefaultSamplerState_0 : register(s25, space1);
	
	static float3 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _6235 = normalize(input_0.xyz);
	    float _9925 = _Globals_1_g_flRotation * 6.283185482025146484375f;
	    float _21499 = sin(_9925);
	    float _10511 = cos(_9925);
	    float _9794 = _6235.x;
	    float _6498 = _6235.y;
	    float4 _3300 = g_tSkyTexture.Sample(DefaultSamplerState_0, normalize(float3((_9794 * _10511) - (_6498 * _21499), (_9794 * _21499) + (_6498 * _10511), _6235.z + _Globals_1_g_flHorizonOffset)).xyz);
	    float4 _18900;
	    _18900.x = _3300.x;
	    _18900.y = _3300.y;
	    _18900.z = _3300.z;
	    float3 _11003 = _18900.xyz * _Globals_1_g_flBrightnessExposureBias;
	    float4 _8673;
	    _8673.x = _11003.x;
	    _8673.y = _11003.y;
	    _8673.z = _11003.z;
	    float3 _11004 = _8673.xyz * _Globals_1_g_flRenderOnlyExposureBias;
	    float4 _8674;
	    _8674.x = _11004.x;
	    _8674.y = _11004.y;
	    _8674.z = _11004.z;
	    output_0 = float4(max(_8674.xyz * _Globals_1_g_vTint.xyz, 0.0f.xxx), 1.0f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(sky, true);
	TextureAttribute(SkyTexture, g_tSkyTexture);
	FloatAttribute(SkyBrightnessExposureBias, g_flBrightnessExposureBias);
	
	#if (S_TEXTURE_FORMAT == 1)
		IntAttribute(SkyTextureFormat, 1);
	#endif
	#if (S_TEXTURE_FORMAT == 0)
		IntAttribute(SkyTextureFormat, 0);
	#endif
	#if (S_TEXTURE_FORMAT == 3)
		IntAttribute(SkyTextureFormat, 3);
	#endif
	#if (S_TEXTURE_FORMAT == 2)
		IntAttribute(SkyTextureFormat, 2);
	#endif
	#if (S_TEXTURE_FORMAT == 5)
		IntAttribute(SkyTextureFormat, 5);
	#endif
	#if (S_TEXTURE_FORMAT == 4)
		IntAttribute(SkyTextureFormat, 4);
	#endif
	#if (S_TEXTURE_FORMAT == 6)
		IntAttribute(SkyTextureFormat, 6);
	#endif
}
