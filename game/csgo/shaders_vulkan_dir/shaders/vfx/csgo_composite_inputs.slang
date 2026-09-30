//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "A container for a family of composite input texture resources";
	DevShader = false;
	Version = 3;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
	Feature( F_PREVIEW_CHANNEL_MODE, 0..9 (0="Preview Default", 1="Preview AO", 2="Preview Cavity", 3="Preview Mig Shading", 4="Preview No Paint", 5="Preview Position", 6="Preview Mask RGB", 7="Preview Mask R", 8="Preview Mask G", 9="Preview Mask B"), "" );
	Feature( F_SEPARATE_CHANNEL_INPUTS, 0..1 (0="Pre-packed Source1 Input", 1="Separate Channels"), "" );
	Feature( F_ENABLE_SFX_MASK, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor      : COLOR0     < Semantic( Color ); >;                                       
	float3 vPositionSs : POSITION0  < Semantic( PosXyz ); >;                                      
	float2 vTexCoord   : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                              
};

VS
{
	
	float4 g_vViewport < Source(Viewport); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float _3;
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vViewport : packoffset(c0);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionSs;
	static float4 vColor;
	static float2 vTexCoord;
	static float4 output_0;
	static float2 output_1;
	
	struct VS_INPUT
	{
	    float2 vPositionSs : TEXCOORD0;
	    float4 vColor : TEXCOORD1;
	    float2 vTexCoord : TEXCOORD2;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float2 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float2 _15639 = (((vPositionSs.xy - _Globals_1_g_vViewport.xy) * 2.0f) / _Globals_1_g_vViewport.zw) - 1.0f.xx;
	    float4 _14779 = float4(_15639.x, _3, 1.0f, 1.0f);
	    float3 _24030 = vColor.xyz * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((vColor.xyz * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (vColor.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _24030.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (vColor.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _24030.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (vColor.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _24030.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    output_0 = float4(_21354, _21355, _19302, vColor.w);
	    output_1 = vTexCoord;
	    _14779.y = _15639.y;
	    gl_Position = _14779;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    vColor = stage_input.vColor;
	    vTexCoord = stage_input.vTexCoord;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	IntAttribute(MaterialLayerCount, 1);
	StringAttribute(MaterialLayerRefType, csgo_weapon);
	StringAttribute(MaterialLayerType, csgo_composite_inputs);
	BoolAttribute(ui, true);
	BoolAttribute(ScreenSpaceVertices, true);
	
}

PS
{
	StaticCombo( S_SEPARATE_CHANNEL_INPUTS, F_SEPARATE_CHANNEL_INPUTS );
	StaticCombo( S_PREVIEW_CHANNEL_MODE, F_PREVIEW_CHANNEL_MODE );
	StaticCombo( S_ENABLE_SFX_MASK, F_ENABLE_SFX_MASK );
	
	Texture2D g_tAmbientOcclusion < Channel(RGBA, None(TextureAmbientOcclusion1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tAmbientOcclusion < Channel(R, None(TextureCavity1), Srgb); Channel(G, None(TextureAmbientOcclusion1), Srgb); Channel(A, None(TextureNoPaint1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGBA, ArtistDefined(TextureColor1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tMasks < Channel(RGB, None(TextureMasks1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); Channel(B, Box(TextureSfxMask1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tPosition < Channel(RGBA, None(TexturePosition1), Linear); OutputFormat(RGBA16161616F); SrgbRead(false); >;
	Texture2D g_tSurface < Channel(RGB, None(TextureSurface1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// Composite Inputs
	CreateInputTexture2D(TextureAmbientOcclusion1, Srgb, 8, "", "_ao", "Composite Inputs/Texture Inputs,0/10", Default4(1, 1, 1, 1));
	float g_flWeaponLength1 < Default(36); Range(0, 64); UiType(Slider); UiGroup("Composite Inputs/Metadata Inputs,10/10"); >;
	CreateInputTexture2D(TextureCavity1, Srgb, 8, "", "_cavity", "Composite Inputs/Texture Inputs,0/11", Default4(0.5, 0.5, 0.5, 1));
	CreateInputTexture2D(TextureNoPaint1, Srgb, 8, "", "_nopaint", "Composite Inputs/Texture Inputs,0/13", Default4(0, 0, 0, 1));
	CreateInputTexture2D(TextureMasks1, Linear, 8, "", "_masks", "Composite Inputs/Texture Inputs,0/20", Default4(1, 1, 1, 1));
	float g_flUvScale1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Composite Inputs/Metadata Inputs,10/20"); >;
	CreateInputTexture2D(TextureSurface1, Linear, 8, "", "_surface", "Composite Inputs/Texture Inputs,0/30", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TexturePosition1, Linear, 16, "", "_pos", "Composite Inputs/Texture Inputs,0/40", Default4(1, 1, 1, 1));
	
	// Color
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Color/11", Default4(1, 1, 1, 1));
	
	// Lighting
	CreateInputTexture2D(TextureSfxMask1, Linear, 8, "", "_mask", "Lighting/SFX/0", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/11", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/11", Default4(0.5, 0.5, 0.5, 0));
	
	#if (S_ENABLE_SFX_MASK == 1)
		Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); Channel(B, Box(TextureSfxMask1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	#if (S_SEPARATE_CHANNEL_INPUTS == 1)
		Texture2D g_tAmbientOcclusion < Channel(R, None(TextureCavity1), Srgb); Channel(G, None(TextureAmbientOcclusion1), Srgb); Channel(A, None(TextureNoPaint1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_SEPARATE_CHANNEL_INPUTS == 0)
		Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); Channel(B, Box(TextureSfxMask1), Linear); OutputFormat(BC7); SrgbRead(false); >;
		Texture2D g_tAmbientOcclusion < Channel(RGBA, None(TextureAmbientOcclusion1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _2;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flWeaponLength1 : packoffset(c0);
	    float _Globals_1_g_flUvScale1 : packoffset(c0.y);
	};
	
	Texture2D<float4> g_tAmbientOcclusion : register(t32, space1);
	SamplerState DefaultSamplerState_0 : register(s16, space1);
	Texture2D<float4> g_tMasks : register(t33, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp : register(s17, space1);
	Texture2D<float4> g_tSurface : register(t34, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_1 : register(s18, space1);
	Texture2D<float4> g_tPosition : register(t35, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_2 : register(s19, space1);
	Texture2D<float4> g_tMetalness : register(t31, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_3 : register(s15, space1);
	Texture2D<float4> g_tColor : register(t30, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_4 : register(s14, space1);
	
	static float2 input_1;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_1 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _22452 = g_tAmbientOcclusion.Sample(DefaultSamplerState_0, input_1.xy);
	    float4 _22455 = g_tPosition.Sample(AddressU_Clamp_AddressV_Clamp_2, input_1.xy);
	    float _4384 = _Globals_1_g_flUvScale1 * _Globals_1_g_flWeaponLength1;
	    float3 _10929 = lerp(float4(g_tSurface.Sample(AddressU_Clamp_AddressV_Clamp_1, input_1.xy).z.xxx, 1.0f).xyz, pow(g_tMasks.Sample(AddressU_Clamp_AddressV_Clamp, input_1.xy).xyz, 2.2000000476837158203125f.xxx), (0.3300000131130218505859375f * (1.0f - _22452.w)).xxx);
	    float4 _17842;
	    _17842.x = _10929.x;
	    _17842.y = _10929.y;
	    _17842.z = _10929.z;
	    float3 _25191 = lerp(_17842.xyz, (2.0f * frac(((floor(_22455.x * _4384) + floor(_22455.y * _4384)) + floor(_22455.z * _4384)) * 0.5f)).xxx, 0.100000001490116119384765625f.xxx);
	    float4 _17843;
	    _17843.x = _25191.x;
	    _17843.y = _25191.y;
	    _17843.z = _25191.z;
	    float3 _12546 = _17843.xyz * pow(_22452.y, 2.2000000476837158203125f);
	    float4 _8673;
	    _8673.x = _12546.x;
	    _8673.y = _12546.y;
	    _8673.z = _12546.z;
	    float4 _15488 = float4(_8673.xyz * min(1.0f.xxx, g_tColor.Sample(AddressU_Clamp_AddressV_Clamp_4, input_1.xy).xyz * 10.0f).xyz, g_tMetalness.Sample(AddressU_Clamp_AddressV_Clamp_3, input_1.xy).w);
	    output_0 = lerp(_15488, _15488, 9.9999997473787516355514526367188e-06f.xxxx);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	IntAttribute(MaterialLayerCount, 1);
	StringAttribute(MaterialLayerRefType, csgo_weapon);
	StringAttribute(MaterialLayerType, csgo_composite_inputs);
	
}
