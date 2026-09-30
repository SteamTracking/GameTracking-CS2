//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Projected Decals supporting lightmaps";
	DevShader = false;
	Version = 3;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_BLEND_MODE, 0..3 (0="Translucent", 1="Mod2X", 2="Emissive", 3="Liquid"), "Decal" );
	Feature( F_SAMPLE_LIGHTMAP, 0..1, "Lighting" );
	Feature( F_AUTOMATIC_PBR_COLOR_FITTING, 0..1, "Lighting" );
	Feature( F_ALPHA_MODE, 0..1 (0="Simple", 1="Cutoff"), "Decal" );
	Feature( F_USE_SHEETS, 0..1, "Use Sheet Textures" );
	Feature( F_TRIPLANAR_MAPPING, 0..1, "Decal" );
	Feature( F_CUTOFF_ANGLE, 0..1, "Decal" );
	Feature( F_NORMAL_MAP, 0..1, "Normal Map" );
	Feature( F_SPECULAR_DIRECT, 0..1, "Direct Specular" );
	Feature( F_SPECULAR_INDIRECT, 0..1 (0="None", 1="In-game Cube Map"), "Indirect Specular" );
	Feature( F_PARALLAX, 0..1, "Parallax Occlusion" );
	Feature( F_FASTAPPROX, 0..1, "Fast, Lower Quality" );
	Feature( F_BLOOD_AGING, 0..1, "Blood Spawning and Aging Effects" );
	Feature( F_DETAIL_TEXTURE, 0..1 (0="None", 1="Detail"), "Detail Texture" );
	FeatureRule( Requires( F_SAMPLE_LIGHTMAP, F_BLEND_MODE==0 ), "Sample Lightmap requires Translucent Blend Mode" );
	FeatureRule( Allow1( F_USE_SHEETS, F_ALPHA_MODE==1 ), "Sheet Textures and Alpha Cutoff are incompatible" );
	FeatureRule( Requires( F_NORMAL_MAP, F_BLEND_MODE==0, F_BLEND_MODE==3 ), "Normal map requires Translucent Blend Mode" );
	FeatureRule( Requires( F_SPECULAR_DIRECT, F_BLEND_MODE==0, F_BLEND_MODE==3 ), "Direct Specular requires Translucent Blend Mode" );
	FeatureRule( Allow1( F_PARALLAX, F_TRIPLANAR_MAPPING ), "Parallax Occlusion and Triplanar are incompatible" );
	FeatureRule( Requires( F_BLOOD_AGING, F_BLEND_MODE==0 ), "Blood Spawning and Aging Effects requires Translucent Blend Mode" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_NORMAL_MAP ), "Detail texture and normal map are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_FASTAPPROX ), "Detail texture and fast approx are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_PARALLAX ), "Detail texture and parallax are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_TRIPLANAR_MAPPING ), "Detail texture and triplanar are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_USE_SHEETS ), "Detail texture and sheet are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_SPECULAR_DIRECT ), "Detail texture and specular are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_SPECULAR_INDIRECT ), "Detail texture and specular are incompatible" );
	FeatureRule( Requires( F_DETAIL_TEXTURE, F_BLEND_MODE==0 ), "Detail texture requires Translucent Blend Mode" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 vPositionOs  : POSITION0  < Semantic( PosXyz ); >;                                     
	uint4  nSheetIdx    : TEXCOORD2  < Semantic( SheetIdx ); >;                                    // S_USE_SHEETS=1
	uint4  nFlags       : TEXCOORD1  < Semantic( Flags ); >;                                       // S_USE_SHEETS=0
	float4 flAnimParam  : TEXCOORD3  < Semantic( AnimParam ); >;                                  
	float2 vLightmapUV  : TEXCOORD4  < Semantic( LightmapUV ); >;                                 
	float2 nInstanceIdx : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                        
};

VS
{
	StaticCombo( S_USE_SHEETS, F_USE_SHEETS );
	StaticCombo( S_FASTAPPROX, F_FASTAPPROX );
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tColor < Channel(RGBA, Box(TextureColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSheetTexture < Attribute("SheetTexture"); SrgbRead(false); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vSheetSequenceAndSizes < Source(TextureSheetData); SourceArg(g_tColor) UiType(VectorText); >;
	float4 g_vShrinkWrapBB_01 < Default(0); UiType(VectorText); >;
	float4 g_vShrinkWrapBB_23 < Default3(1, 1, 1); UiType(VectorText); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color", Default4(1, 1, 1, 0));
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	
	#if (S_USE_SHEETS == 1)
		Texture2D g_tColor < Channel(RGBA, Box(TextureColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1125
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    float _m7;
	};
	
	struct _1119
	{
	    row_major float3x4 _m0;
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer BakedLightingConstantBuffer_t : register(b3, space0)
	{
	    float4 BakedLightingConstantBuffer_t_1_m0 : packoffset(c0);
	};
	
	
	static float4 gl_Position;
	static uint nInstanceIdx;
	static float3 vPositionOs;
	static uint nFlags;
	static float2 vLightmapUV;
	static float2 flAnimParam;
	static float4 output_0;
	static uint output_1;
	static uint output_2;
	static float output_3;
	static float2 output_4;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint nFlags : TEXCOORD1;
	    float2 flAnimParam : TEXCOORD3;
	    float2 vLightmapUV : TEXCOORD4;
	    uint nInstanceIdx : TEXCOORD5;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    nointerpolation uint output_1 : TEXCOORD1;
	    nointerpolation uint output_2 : TEXCOORD2;
	    nointerpolation float output_3 : TEXCOORD3;
	    float2 output_4 : TEXCOORD4;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float3x4 _9558 = asfloat(uint3x4(g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 32)));
	    float4 _23812 = float4(uint4(g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 255u, (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
	    float3 _6253 = _23812.xyz;
	    float3 _17828 = _6253 * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((_6253 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _17828.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    float4 _17895 = mul(PerViewConstantBuffer_t_1_m0, (float4(mul(_9558, float4(vPositionOs.xyz, 1.0f)).xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = float4(_21354, _21355, _19302, _23812.w);
	    output_1 = nFlags;
	    output_2 = nInstanceIdx;
	    output_3 = flAnimParam.y;
	    output_4 = vLightmapUV.xy * BakedLightingConstantBuffer_t_1_m0.xy;
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    nInstanceIdx = stage_input.nInstanceIdx;
	    vPositionOs = stage_input.vPositionOs;
	    nFlags = stage_input.nFlags;
	    vLightmapUV = stage_input.vLightmapUV;
	    flAnimParam = stage_input.flAnimParam;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(decal, true);
	
	#if (S_USE_SHEETS == 1)
		TextureAttribute(DecalSheetTexture, g_tColor);
	#endif
}

PS
{
	StaticCombo( S_USE_SHEETS, F_USE_SHEETS );
	StaticCombo( S_FASTAPPROX, F_FASTAPPROX );
	StaticCombo( S_BLEND_MODE, F_BLEND_MODE );
	StaticCombo( S_ALPHA_MODE, F_ALPHA_MODE );
	StaticCombo( S_TRIPLANAR_MAPPING, F_TRIPLANAR_MAPPING );
	StaticCombo( S_CUTOFF_ANGLE, F_CUTOFF_ANGLE );
	StaticCombo( S_NORMAL_MAP, F_NORMAL_MAP );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_BLOOD_AGING, F_BLOOD_AGING );
	StaticCombo( S_PARALLAX, F_PARALLAX );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_USE_SHEETS, S_ALPHA_MODE==1 ) );
	StaticComboRule( Requires( S_NORMAL_MAP, S_BLEND_MODE==0, S_BLEND_MODE==3 ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_BLEND_MODE==0, S_BLEND_MODE==3 ) );
	StaticComboRule( Allow1( S_PARALLAX, S_TRIPLANAR_MAPPING ) );
	StaticComboRule( Requires( S_BLOOD_AGING, S_BLEND_MODE==0 ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_NORMAL_MAP ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_FASTAPPROX ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_PARALLAX ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_TRIPLANAR_MAPPING ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_USE_SHEETS ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_SPECULAR_DIRECT ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAIL_TEXTURE, S_BLEND_MODE==0 ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_MSAA_DEPTH_BUFFER, 0..1 );
	DynamicCombo( D_TRANSLUCENT_SCENE_DEPTH, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_BLEND_MODE==0, S_BLEND_MODE==1, S_BLEND_MODE==2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS2 ) );
	
	bool bAutomaticPBRColorFitting < UiType(CheckBox); Expression(F_AUTOMATIC_PBR_COLOR_FITTING); >;
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); Channel(G, Box3(TextureMetalness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, Box(TextureColor), Linear); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGBA, Box(TextureColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGBA, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCubeArray g_tFallbackCubemap < Attribute("LowShaderQualityFallbackCubemap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tHeight < Channel(R, Box(TextureHeight), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap3 < Attribute("debug_chart_color"); SrgbRead(false); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tSceneDepth < Attribute("SceneDepthDecal"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tTranslucentSceneDepth < Attribute("TranslucentSceneDepth"); SrgbRead(false); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float3 g_vAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.045,.4,1.15).x,-1.4427*log(max(.0001,1-float3(-.045,.4,1.15).y)),2-float3(-.045,.4,1.15).z)); >;
	float2 g_vAlphaCutoffScaleAndBias < UiType(VectorText); Expression(float2(1/g_flAlphaCutoffSoftness,-1)); >;
	float2 g_vCutoffBiasScale < UiType(VectorText); Expression(float2(cos(.017453*min(180,g_flCutoffAngle+g_flCutoffAngleSoftness)),1/(cos(.017453*g_flCutoffAngle)-cos(.017453*min(180,g_flCutoffAngle+g_flCutoffAngleSoftness))))); >;
	float3 g_vDarkMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.1,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.1,.4,1.08).y)),2-float3(-.1,.4,1.08).z)); >;
	float3 g_vEmissiveTintScaled < UiType(VectorText); Expression(pow(2,g_flEmissiveBrightness).x*SrgbGammaToLinear(g_vEmissiveTint.xyz)); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.45,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.45,.4,1.08).y)),2-float3(-.45,.4,1.08).z)); >;
	float2 g_vRoughness < UiType(VectorText); Expression(max(.01,1-g_flGlossiness).x); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// PBR
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "PBR,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "PBR,10 / Metalness,40 / 10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "PBR,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "PBR,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color", Default4(1, 1, 1, 0));
	
	// Detail Texture
	CreateInputTexture2D(TextureDetail, Linear, 8, "", "_detail", "Detail Texture", Default4(1, 1, 1, 1));
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture"); >;
	
	// Parallax
	CreateInputTexture2D(TextureHeight, Linear, 8, "", "_height", "Parallax", Default4(1, 1, 1, 0));
	float g_flHeightMapScale < Default(0.02); Range(0, 0.5); UiType(Slider); UiGroup("Parallax"); >;
	int g_nLODThreshold < Default(4); Range(0, 12); UiType(Slider); UiGroup("Parallax"); >;
	int g_nMaxSamples < Default(32); Range(16, 128); UiType(Slider); UiGroup("Parallax"); >;
	int g_nMinSamples < Default(8); Range(8, 64); UiType(Slider); UiGroup("Parallax"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Emissive
	float g_flAdditiveAmount < Default(1); UiType(Slider); UiGroup("Emissive"); >;
	float g_flEmissiveBrightness < Range(-8, 8); UiType(Slider); UiGroup("Emissive"); >;
	float3 g_vEmissiveTint < Default3(1, 1, 1); UiType(Color); UiGroup("Emissive"); >;
	
	// Alpha
	float g_flAlphaCutoffSoftness < Default(0.1); UiType(Slider); UiGroup("Alpha"); >;
	float g_flDecalZAlphaScale < Default(0.01); UiType(Slider); UiGroup("Alpha"); >;
	
	// Decal
	float g_flCutoffAngle < Default(60); Range(0, 180); UiType(Slider); UiGroup("Decal"); >;
	float g_flCutoffAngleSoftness < Default(5); Range(1, 45); UiType(Slider); UiGroup("Decal"); >;
	float g_flDecalBoxGrowth < Default(1); Range(1, 4); UiType(Slider); UiGroup("Decal"); >;
	
	// BloodAgingEffects
	float g_flDecalAgeTimer < Range(0, 30); UiType(Slider); UiGroup("BloodAgingEffects"); Expression(exists(ATTRIBUTE[38c7fbae]) ? ATTRIBUTE[38c7fbae] : this); >;
	
	// Lighting
	float g_flGlossiness < Default(0.5); UiType(Slider); UiGroup("Lighting,30/Gloss,20/10"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_DETAIL_TEXTURE == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_USE_SHEETS == 1)
		Texture2D g_tColor < Channel(RGBA, Box(TextureColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_BLEND_MODE == 2)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_BLEND_MODE == 1)
		Texture2D g_tColor < Channel(RGB, Box(TextureColor), Linear); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vAlbedoLevels) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_samplerless_texture_functions : require
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	#extension GL_KHR_shader_subgroup_arithmetic : require
	layout(early_fragment_tests) in;
	
	struct _1125
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    float _m7;
	};
	
	struct _1119
	{
	    mat3x4 _m0;
	};
	
	struct _1008
	{
	    vec4 _m0[3];
	};
	
	struct _1470
	{
	    vec4 _m0[4];
	};
	
	struct _592
	{
	    mat4 _m0[4];
	};
	
	struct _200
	{
	    mat4 _m0;
	    mat4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec3 _m6;
	    uint _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    mat4x3 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    mat4 _m23;
	};
	
	vec4 _3;
	float _4;
	vec3 _5;
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _1706
	{
	    mat4 _m0;
	    float _m1;
	    float _m2;
	    vec2 _m3;
	    vec2 _m4;
	    vec2 _m5;
	    vec4 _m6;
	    vec3 _m7;
	};
	
	layout(set = 1) uniform _1706 PerViewConstantBuffer_t;
	
	struct _1272
	{
	    int bAutomaticPBRColorFitting;
	    vec3 g_vAlbedoLevels;
	    vec3 g_vDarkMetallicAlbedoLevels;
	    vec3 g_vMetallicAlbedoLevels;
	    float g_flDecalBoxGrowth;
	    float g_flDecalZAlphaScale;
	    int g_bFogEnabled;
	};
	
	layout(set = 1) uniform _1272 _Globals_;
	
	struct _1288
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    mat4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    mat4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	    vec4 _m12;
	    float _m13;
	};
	
	layout(set = 1) uniform _1288 PerViewConstantBufferCsgo_t;
	
	struct _2267
	{
	    _1008 _m0;
	    vec4 _m1;
	    uvec4 _m2;
	    uvec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec4 _m6;
	    int _m7;
	    float _m8;
	    vec4 _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    float _m13;
	    _592 _m14;
	    _1470 _m15;
	};
	
	layout(set = 3) uniform _2267 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 46) uniform texture2D g_tSceneDepth;
	layout(set = 1, binding = 21) uniform sampler AddressU_Clamp_AddressV_Clamp;
	layout(set = 1, binding = 43) uniform texture2D g_tColor;
	layout(set = 1, binding = 23) uniform sampler DefaultSamplerState_0;
	layout(set = 1, binding = 45) uniform texture2D g_tAmbientOcclusion;
	layout(set = 1, binding = 27) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 53) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 26) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 2) flat in uint input_2;
	layout(location = 0) in vec4 input_0;
	layout(location = 1) flat in uint input_1;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    float _12457;
	    vec4 _13897 = gl_FragCoord;
	    vec2 _12497 = ((_13897.xy * PerViewConstantBuffer_t._m5.xy) * 2.0) - vec2(1.0);
	    float _10528 = _12497.x;
	    float _21741 = -_12497.y;
	    ivec2 _11700 = ivec3(ivec2(_13897.xy), 0).xy;
	    vec4 _18334 = vec4(vec3(_10528, _21741, fma(texelFetch(g_tSceneDepth, _11700, 0).x, PerViewConstantBuffer_t._m1, PerViewConstantBuffer_t._m2)), 1.0) * PerViewConstantBuffer_t._m0;
	    vec3 _15076 = _18334.xyz / _18334.www;
	    mat4x3 _20563 = transpose(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[input_2]._m1]._m0);
	    vec3 _19786 = _20563[0];
	    vec3 _10294 = _19786 * (1.0 / dot(_19786, _19786));
	    vec3 _16758 = _20563[1];
	    vec3 _10295 = _16758 * (1.0 / dot(_16758, _16758));
	    vec3 _16759 = _20563[2];
	    vec3 _8651 = ((_15076 - _20563[3]) * mat3(_10294, _10295, _16759 * (1.0 / dot(_16759, _16759)))) + vec3(0.5);
	    vec3 _24011 = vec3(_8651.x, 1.0 - _8651.y, _8651.z);
	    float _13136;
	    vec3 _13151;
	    float _22382;
	    do
	    {
	        _12457 = _Globals_.g_flDecalBoxGrowth;
	        if (_12457 <= 1.0)
	        {
	            _13136 = 0.0;
	            _13151 = _24011;
	            _22382 = 1.0;
	            break;
	        }
	        float _25188 = saturate(((length(PerViewConstantBuffer_t._m7.xyz - _15076.xyz) / PerViewConstantBufferCsgo_t._m13) - 256.0) * 0.0007812500116415321826934814453125);
	        float _6919 = _12457 / mix(1.0, _12457, _25188);
	        vec2 _8218 = ((_24011.xy - vec2(0.5)) * _6919) + vec2(0.5);
	        vec3 _20488 = _24011;
	        _20488.x = _8218.x;
	        _20488.y = _8218.y;
	        _13136 = _25188;
	        _13151 = _20488;
	        _22382 = _6919;
	        break;
	    } while(false);
	    vec3 _7472 = step(vec3(0.0), _13151.xyz) * step(_13151.xyz, vec3(1.0));
	    if ((((_7472.x * _7472.y) * _7472.z) - 0.5) < 0.0)
	    {
	        discard;
	    }
	    vec4 _23972 = vec4(vec3(_10528, _21741, fma(texelFetch(g_tSceneDepth, _11700, 0).x, PerViewConstantBuffer_t._m1, PerViewConstantBuffer_t._m2)), 1.0) * PerViewConstantBuffer_t._m0;
	    vec3 _15614 = _23972.xyz / _23972.www;
	    vec4 _22905;
	    _22905.x = _15614.x;
	    _22905.y = _15614.y;
	    _22905.z = _15614.z;
	    vec2 _11476 = _13897.xy + vec2(-1.0, 0.0);
	    vec2 _12498 = ((_11476.xy * PerViewConstantBuffer_t._m5.xy) * 2.0) - vec2(1.0);
	    vec4 _23973 = vec4(vec3(_12498.x, -_12498.y, fma(texelFetch(g_tSceneDepth, ivec3(ivec2(_11476), 0).xy, 0).x, PerViewConstantBuffer_t._m1, PerViewConstantBuffer_t._m2)), 1.0) * PerViewConstantBuffer_t._m0;
	    vec3 _15615 = _23973.xyz / _23973.www;
	    vec4 _22906;
	    _22906.x = _15615.x;
	    _22906.y = _15615.y;
	    _22906.z = _15615.z;
	    vec2 _11477 = _13897.xy + vec2(1.0, 0.0);
	    vec2 _12499 = ((_11477.xy * PerViewConstantBuffer_t._m5.xy) * 2.0) - vec2(1.0);
	    vec4 _23974 = vec4(vec3(_12499.x, -_12499.y, fma(texelFetch(g_tSceneDepth, ivec3(ivec2(_11477), 0).xy, 0).x, PerViewConstantBuffer_t._m1, PerViewConstantBuffer_t._m2)), 1.0) * PerViewConstantBuffer_t._m0;
	    vec3 _15616 = _23974.xyz / _23974.www;
	    vec4 _22907;
	    _22907.x = _15616.x;
	    _22907.y = _15616.y;
	    _22907.z = _15616.z;
	    vec2 _11478 = _13897.xy + vec2(0.0, -1.0);
	    vec2 _12500 = ((_11478.xy * PerViewConstantBuffer_t._m5.xy) * 2.0) - vec2(1.0);
	    vec4 _23975 = vec4(vec3(_12500.x, -_12500.y, fma(texelFetch(g_tSceneDepth, ivec3(ivec2(_11478), 0).xy, 0).x, PerViewConstantBuffer_t._m1, PerViewConstantBuffer_t._m2)), 1.0) * PerViewConstantBuffer_t._m0;
	    vec3 _15617 = _23975.xyz / _23975.www;
	    vec4 _22908;
	    _22908.x = _15617.x;
	    _22908.y = _15617.y;
	    _22908.z = _15617.z;
	    vec2 _11479 = _13897.xy + vec2(0.0, 1.0);
	    vec2 _12501 = ((_11479.xy * PerViewConstantBuffer_t._m5.xy) * 2.0) - vec2(1.0);
	    vec4 _23976 = vec4(vec3(_12501.x, -_12501.y, fma(texelFetch(g_tSceneDepth, ivec3(ivec2(_11479), 0).xy, 0).x, PerViewConstantBuffer_t._m1, PerViewConstantBuffer_t._m2)), 1.0) * PerViewConstantBuffer_t._m0;
	    vec3 _15618 = _23976.xyz / _23976.www;
	    vec4 _22909;
	    _22909.x = _15618.x;
	    _22909.y = _15618.y;
	    _22909.z = _15618.z;
	    vec3 _19714 = _22905.xyz - _22906.xyz;
	    vec3 _22910 = _22907.xyz - _22905.xyz;
	    vec3 _22911 = _22905.xyz - _22908.xyz;
	    vec3 _20307 = _22909.xyz - _22905.xyz;
	    vec3 _21091 = mix(_22910, _19714, bvec3(abs(_19714.z) < abs(_22910.z)));
	    vec3 _20429 = mix(_20307, _22911, bvec3(abs(_22911.z) < abs(_20307.z)));
	    vec3 _24155 = _21091.xyz;
	    vec3 _17701 = _10294.xyz;
	    vec3 _8659 = -_10295.xyz;
	    vec3 _7879 = _20429.xyz;
	    vec2 _13437 = (vec3(dot(_24155, _17701), dot(_24155, _8659), _4) * 0.5).xy * _22382;
	    vec3 _8673;
	    _8673.x = _13437.x;
	    _8673.y = _13437.y;
	    vec2 _22860 = (vec3(dot(_7879, _17701), dot(_7879, _8659), _4) * 0.5).xy * _22382;
	    vec3 _8674;
	    _8674.x = _22860.x;
	    _8674.y = _22860.y;
	    vec2 _22381 = _13151.xy;
	    bool _12428 = (input_1 & 1u) != 0u;
	    vec2 _19629;
	    if (_12428)
	    {
	        vec2 _19100 = _22381;
	        _19100.x = 1.0 - _13151.x;
	        _19629 = _19100;
	    }
	    else
	    {
	        _19629 = _22381;
	    }
	    vec4 _15239 = textureGrad(sampler2D(g_tColor, AddressU_Clamp_AddressV_Clamp), _19629.xy, _8673.xy, _8674.xy);
	    vec4 _21709;
	    if (_12457 > 1.0)
	    {
	        vec2 _13168 = fwidth(_22381);
	        float _7712 = max(0.1500000059604644775390625, max(_13168.x, _13168.y));
	        vec2 _4152 = _22381 - vec2(0.5);
	        float _3149 = _7712 * _7712;
	        vec3 _20787 = _15239.xyz * (1.0 - ((0.60000002384185791015625 * _13136) * (1.0 - smoothstep(_3149 * 0.25, _3149, dot(_4152, _4152)))));
	        vec4 _8675 = _15239;
	        _8675.x = _20787.x;
	        _8675.y = _20787.y;
	        _8675.z = _20787.z;
	        _21709 = _8675;
	    }
	    else
	    {
	        _21709 = _15239;
	    }
	    float _4460 = input_0.w * (_21709.w * saturate((1.0 / _Globals_.g_flDecalZAlphaScale) * _13151.z));
	    if ((_4460 - 0.0039215688593685626983642578125) < 0.0)
	    {
	        discard;
	    }
	    vec3 _21103 = input_0.xyz * _21709.xyz;
	    vec3 _20808 = normalize(cross(_20429, _21091)).xyz;
	    vec3 _18121 = _15076.xyz + _20808;
	    vec3 _11403 = _15076 - PerViewConstantBufferCsgo_t._m12.xyz;
	    vec4 _24832 = _13897;
	    _24832.w = 1.0 / _13897.w;
	    vec2 _19287;
	    if (_12428)
	    {
	        vec2 _19101 = _22381;
	        _19101.x = 1.0 - _13151.x;
	        _19287 = _19101;
	    }
	    else
	    {
	        _19287 = _22381;
	    }
	    vec4 _11179 = textureGrad(sampler2D(g_tAmbientOcclusion, DefaultSamplerState_0), _19287.xy, _8673.xy, _8674.xy);
	    float _7969 = _11179.y;
	    vec3 _21785;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.bAutomaticPBRColorFitting != 0)
	    {
	        vec3 _11010 = _21103.xyz;
	        vec3 _24045 = normalize(max(vec3(0.0003000000142492353916168212890625), _11010)) * 1.059999942779541015625;
	        float _6670 = dot(saturate(_11010 * 1.0).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _12755 = mix(_Globals_.g_vAlbedoLevels, mix(_Globals_.g_vMetallicAlbedoLevels, _Globals_.g_vDarkMetallicAlbedoLevels, vec3(smoothstep(0.550000011920928955078125, 0.0155999995768070220947265625, _6670))), vec3(_7969));
	        float _20079 = mix(_Globals_.g_vAlbedoLevels.x, _Globals_.g_vDarkMetallicAlbedoLevels.x, _7969);
	        vec3 _22776 = _24045.xyz;
	        _21785 = mix(vec3(_20079), max((((_22776 * _20079) * 1.73199999332427978515625) / vec3(length(_22776))) / vec3(dot(_24045.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _24045 * mix(_12755.x, _12755.z, saturate(pow(max(_21103.x, max(_21103.y, _21103.z)), _12755.y)))).xyz, vec3(pow(smoothstep(0.0003000000142492353916168212890625, _20079, _6670), 0.5))).xyz * (1.0 - _7969);
	    }
	    else
	    {
	        _21785 = _21103;
	    }
	    vec4 _22272 = vec4(_20808, 1.0);
	    vec3 _6607 = _11403.xyz;
	    float _21710;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m7 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13137;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m7))
	            {
	                _13137 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(_11403.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m14._m0[_13039];
	            float _12780 = _18322.x;
	            if (max(abs(_12780), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m9[_13039])
	            {
	                vec3 _19470 = vec3(_12780, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m11)) + vec2(PerViewLightingConstantBufferGpu_t._m10));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m15._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m15._m0[_13039].xy;
	                vec3 _20489 = _19470;
	                _20489.x = _20561.x;
	                _20489.y = _20561.y;
	                _13137 = saturate(_22193.x * _22193.y);
	                _14975 = _20489;
	                _10191 = _13039;
	                break;
	            }
	            _23989 = _13039 + 1;
	            _13039 = _23989;
	            continue;
	        }
	        float _19363;
	        if (_10191 >= 0)
	        {
	            float _18270 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m8)), 0.0);
	            float _12502;
	            SPIRV_CROSS_BRANCH
	            if (_13137 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m7 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(_11403.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m14._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m15._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m15._m0[_15335].xy;
	                    vec3 _20490;
	                    _20490.x = _20562.x;
	                    _20490.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20490.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m8)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12502 = mix(_7934, _18270, _13137);
	            }
	            else
	            {
	                _12502 = _18270;
	            }
	            _19363 = _12502;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _12513 = mix(_19363, 1.0, saturate((distance(_18121.xyz, PerViewConstantBuffer_t._m7) * PerViewLightingConstantBufferGpu_t._m13) + PerViewLightingConstantBufferGpu_t._m12));
	        float _12503;
	        if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).y)
	        {
	            _12503 = min(_12513, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_24832.xy * PerViewConstantBuffer_t._m6.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12503 = _12513;
	        }
	        _21710 = _12503;
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    vec3 _21711;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m5.xyz, _20808) * _21710) > 0.0)
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t._m1.xyz + (vec3(max(0.0, dot(_20808, PerViewLightingConstantBufferGpu_t._m5.xyz))).xyz * (PerViewLightingConstantBufferGpu_t._m6.xyz * _21710).xyz);
	    }
	    else
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t._m1.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19364;
	    if (_20059)
	    {
	        vec4 _18621 = vec4(_18121.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m2;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m4.x) * 0.5, 0.0, PerViewConstantBuffer_t._m4.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m4.y) * 0.5, 0.0, PerViewConstantBuffer_t._m4.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _24832;
	    }
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m3.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m3.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m2.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m3.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m2.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m2.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m4.x, 0.0, PerViewLightingConstantBufferGpu_t._m4.y)) * PerViewLightingConstantBufferGpu_t._m2.z);
	    vec3 _13155;
	    _13155 = _21711;
	    uint _21567;
	    vec3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t._m2.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _16208] & g_CullBits_1._m0[_23393 + _16208]);
	        _13156 = _13155;
	        uint _20344;
	        vec3 _12506;
	        uint _16209 = _14475;
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_16209)) + (_16208 * 32u));
	            _20344 = _16209 & (_16209 - 1u);
	            do
	            {
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(_11403.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22912;
	                _22912.x = _10521.x;
	                _22912.y = _10521.y;
	                float _21778 = _10521.z;
	                _22912.z = _21778;
	                vec3 _21642 = _22912.xyz;
	                bool _7424;
	                if (all(greaterThan(_22912.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7424 = all(lessThan(_22912.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7424 = false;
	                }
	                bool _12885;
	                if (!_7424)
	                {
	                    _12885 = true;
	                }
	                else
	                {
	                    _12885 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(_6607, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12885)
	                {
	                    _12506 = _13156;
	                    break;
	                }
	                float _23571 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23571 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = min(1.0, _21778 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21778) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11180;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - _6607;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11180 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * saturate(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23571 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11180 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24419 = !_20059;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                vec3 _21548;
	                SPIRV_CROSS_BRANCH
	                if (g_BarnLights_1._m0[_12608]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22154 = abs(_22912.xy);
	                        if (g_BarnLights_1._m0[_12608]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.x, _22154.x) * smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0);
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _21548 = _17828.xyz * _10342;
	                }
	                else
	                {
	                    vec3 _12504;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24992 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11180).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24992);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24992), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20565 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20492 = _14081;
	                        _20492.x = _20565.x;
	                        _20492.y = _20565.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20492.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22912.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _13791;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20491.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _12506 = _13156;
	                    break;
	                }
	                vec3 _20940;
	                if (_24419)
	                {
	                    vec3 _19630;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22912.yx * vec2(1.0, -1.0);
	                        vec3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19630 = _23714;
	                    }
	                    else
	                    {
	                        _19630 = _21642;
	                    }
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(vec3(fma(_19630.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19630.z).xy, saturate(_19630.z + PerViewLightingConstantBufferGpu_t._m8)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _12506 = _13156;
	                        break;
	                    }
	                    _20940 = _20482;
	                }
	                else
	                {
	                    _20940 = _21548;
	                }
	                _12506 = _13156.xyz + (vec3(max(0.0, dot(_20808, _11180.xyz))).xyz * _20940.xyz);
	                break;
	            } while(false);
	            _13156 = _12506;
	            _16209 = _20344;
	            continue;
	        }
	        _21567 = _16208 + 1u;
	        _13155 = _13156;
	        _16208 = _21567;
	        continue;
	    }
	    vec3 _22686 = (_13155.xyz + (vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _22272), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _22272), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _22272)).xyz * vec3(_11179.x).xyz).xyz) * _21785.xyz;
	    float _12933 = _22686.x;
	    vec4 _11203 = vec4(_12933, _22686.yz, _4460);
	    _11203.x = _12933;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _10666 = _18121.xyz - PerViewConstantBuffer_t._m7.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _10666.xyz;
	            bool _12886;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m6.x)
	            {
	                _12886 = (_18121.z * PerViewConstantBufferCsgo_t._m6.z) < PerViewConstantBufferCsgo_t._m6.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12886)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m3.xy + (PerViewConstantBufferCsgo_t._m3.zw * vec2(length(_21493), _18121.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m4.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m4.y)) * PerViewConstantBufferCsgo_t._m5.w;
	                _19340 = mix(_11203.xyz, vec4(PerViewConstantBufferCsgo_t._m5.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _11203.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _11203;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12887;
	            if (dot(_10666.xyz, _10666.xyz) > PerViewConstantBufferCsgo_t._m10.x)
	            {
	                _12887 = (PerViewConstantBufferCsgo_t._m10.z * _18121.z) < PerViewConstantBufferCsgo_t._m10.y;
	            }
	            else
	            {
	                _12887 = false;
	            }
	            if (_12887)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m7.y) + PerViewConstantBufferCsgo_t._m7.x), PerViewConstantBufferCsgo_t._m7.w)) * saturate(pow(max(0.0, (_18121.z * PerViewConstantBufferCsgo_t._m8.y) + PerViewConstantBufferCsgo_t._m8.x), PerViewConstantBufferCsgo_t._m8.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m10.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m9 * vec4(_10666.xyz, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m8.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m7.z))) * PerViewConstantBufferCsgo_t._m11.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _6805 = _23944;
	    }
	    else
	    {
	        _6805 = _11203;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(decal, true);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(SupportsDecalLightmapping, F_SAMPLE_LIGHTMAP ? 1 : 0);
	FloatAttribute(LightingOriginOffset, 2);
	FloatAttribute(DecalBoxGrowth, g_flDecalBoxGrowth);
	BoolAttribute(NeedsLightProbe, true);
	
	#if (S_USE_SHEETS == 0)
		BoolAttribute(userdefinedsheets, false);
	#endif
	#if (S_ALPHA_MODE == 1)
		BoolAttribute(userdefinedsheets, false);
	#endif
	#if (S_DETAIL_TEXTURE == 0)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_USE_SHEETS == 1)
		TextureAttribute(DecalSheetTexture, g_tColor);
		BoolAttribute(userdefinedsheets, true);
	#endif
	#if (S_ALPHA_MODE == 0)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		BoolAttribute(userdefinedsheets, false);
	#endif
	#if (S_DETAIL_TEXTURE == 1)
		BoolAttribute(userdefinedsheets, false);
	#endif
	#if (S_SPECULAR_INDIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, (exists(dynamicdecal) && dynamicdecal) ? Equal : NotEqual);
	RenderState(DepthFunc, GreaterEqual);
	RenderState(DepthWriteEnable, false);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, (exists(dynamicdecal) && dynamicdecal) ? Equal : NotEqual);
	RenderState(StencilReadMask, 2);
	RenderState(StencilRef, 2);
	Texture2D g_tColor < Channel(RGB, Box(TextureColor), Linear); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGBA, Box(TextureColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color", Default4(1, 1, 1, 0));
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, Box(TextureColor), Linear); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGBA, Box(TextureColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	TextureAttribute(RepresentativeTexture, g_tColor);
	
	#if (S_USE_SHEETS == 1)
		TextureAttribute(DecalSheetTexture, g_tColor);
	#endif
}
