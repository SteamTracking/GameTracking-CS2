//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Weapon Sticker Preview Shader";
	DevShader = false;
	Version = 10;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	Depth(S_MODE_DEPTH);
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_HOLOMASK_USE_DXT, 0..1, "Holomask Uses DXT Compression" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	
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
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space0)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c35);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static float4 vTangentUOs_flTangentVSign;
	static uint4 vBlendIndices;
	static uint nInstanceIdx;
	static float3 output_0;
	static float3 output_1;
	static float4 output_2;
	static float4 output_3;
	static float3 output_4;
	static float4 output_5;
	static uint output_6;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    float4 vTangentUOs_flTangentVSign : TEXCOORD3;
	    uint4 vBlendIndices : TEXCOORD4;
	    uint nInstanceIdx : TEXCOORD5;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    centroid float4 output_3 : TEXCOORD3;
	    centroid float3 output_4 : TEXCOORD4;
	    float4 output_5 : TEXCOORD5;
	    nointerpolation uint output_6 : TEXCOORD6;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _13771 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    float3x4 _12618 = asfloat(uint3x4(g_transformBuffer.Load4(_21785 * 48 + 0), g_transformBuffer.Load4(_21785 * 48 + 16), g_transformBuffer.Load4(_21785 * 48 + 32)));
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        float3x4 _25207 = asfloat(uint3x4(g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 32)));
	        _21709 = _25207[0].z.xxx;
	    }
	    else
	    {
	        _21709 = 1.0f.xxx;
	    }
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
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    float _7654 = _23812.w;
	    float4 _20063 = float4(_21354, _21355, _17978, _7654);
	    _20063.w = _7654 * asfloat(g_instanceBuffer.Load(nInstanceIdx * 32 + 28));
	    float3 _11179 = normalize(mul(_12618, float4(vNormalOs.xyz, 0.0f)));
	    float3 _12151 = mul(_12618, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _18237 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = _11179;
	    output_2 = vTexCoord.xyxy;
	    output_3 = _20063;
	    output_4 = _11179;
	    output_5 = float4(normalize(mul(_12618, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_6 = g_instanceBuffer.Load(nInstanceIdx * 32 + 20) & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    vTangentUOs_flTangentVSign = stage_input.vTangentUOs_flTangentVSign;
	    vBlendIndices = stage_input.vBlendIndices;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    stage_output.output_5 = output_5;
	    stage_output.output_6 = output_6;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, true);
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_HOLOMASK_USE_DXT, F_HOLOMASK_USE_DXT );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bActiveStickerMouseOver < Attribute("ActiveStickerMouseOver"); UiType(CheckBox); >;
	bool g_bActiveStickerMoving < Attribute("ActiveStickerMoving"); UiType(CheckBox); >;
	float g_bActiveStickerPeelStartTime < Attribute("ActiveStickerPeelStartTime"); UiType(Slider); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(0 ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((0 ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	bool g_bStickerStoreMode < Attribute("StickerStoreMode"); UiType(CheckBox); >;
	float g_fColorBoostFactor < UiType(Slider); Expression(64-1); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nActiveStickerApplySlot < Attribute("ActiveStickerApplySlot"); UiType(Slider); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tGlitterNormalSticker0 < Channel(RG, None(TextureGlitterNormalSticker0), Linear); Channel(A, None(TextureGlitterNormalMaskSticker0), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tHoloSpectrumSticker0 < Channel(RGB, Box(TextureHoloSpectrumSticker0), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap3 < Attribute("debug_chart_color"); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalRoughnessSticker0 < Channel(RGB, HemiOctIsoRoughness_RG_B(TextureNormalSticker0, TextureRoughnessSticker0), Linear); Channel(A, None(TextureSelfIllumMaskSticker0), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tSfxMaskSticker0 < Channel(RGB, Box(TextureHoloMaskSticker0), Linear); Channel(A, Box(TextureGlitterMaskSticker0), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tSfxMaskSticker0 < Channel(RGB, Box(TextureHoloMaskSticker0), Linear); Channel(A, Box(TextureGlitterMaskSticker0), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	Texture2D g_tSticker0 < Channel(RGB, Box(TextureColorSticker0), Srgb); Channel(A, Box(TextureWearMaskSticker0), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tStickerScratches < Channel(R, Box(TextureStickerScratches), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float3 g_vAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.045,.4,1.15).x,-1.4427*log(max(.0001,1-float3(-.045,.4,1.15).y)),2-float3(-.045,.4,1.15).z)); >;
	float3 g_vDarkMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.1,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.1,.4,1.08).y)),2-float3(-.1,.4,1.08).z)); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vHoloAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.05,.35,1.15).x,-1.4427*log(max(.0001,1-float3(-.05,.35,1.15).y)),2-float3(-.05,.35,1.15).z)); >;
	float3 g_vMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.45,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.45,.4,1.08).y)),2-float3(-.45,.4,1.08).z)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Sticker0
	bool g_bAutomaticPBRColorFittingSticker0 < Default(1); UiType(CheckBox); UiGroup("Sticker0 / Color / 0"); >;
	bool g_bEnableSticker0 < Default(1); UiType(CheckBox); UiGroup("Sticker0"); UiVisibility(0); >;
	bool g_bHolographicSticker0 < UiType(CheckBox); UiGroup("Sticker0 / SFX / 0"); >;
	bool g_bMetallicSticker0 < UiType(CheckBox); UiGroup("Sticker0 / Lighting / 0"); >;
	CreateInputTexture2D(TextureNormalSticker0, Linear, 8, "NormalizeNormals", "_normal", "Sticker0 / Lighting / 1", Default4(0.5, 0.5, 1, 0));
	bool g_bGlitterSticker0 < UiType(CheckBox); UiGroup("Sticker0 / SFX / 1"); >;
	bool g_bLegacyTintMultiplySticker0 < UiType(CheckBox); UiGroup("Sticker0 / Color / 1"); >;
	bool g_bPaperBackingSticker0 < UiType(CheckBox); UiGroup("Sticker0 / Wear / 1"); >;
	bool g_bPreserveRoughnessSticker0 < UiType(CheckBox); UiGroup("Sticker0 / Wear / 1"); >;
	CreateInputTexture2D(TextureColorSticker0, Srgb, 8, "", "", "Sticker0 / Color / 2", "materials/default/stickers/sticker_default.psd");
	CreateInputTexture2D(TextureRoughnessSticker0, Linear, 8, "Inverse", "_rough", "Sticker0 / Lighting / 2", "materials/default/stickers/default_rough.tga");
	CreateInputTexture2D(TextureWearMaskSticker0, Srgb, 8, "", "", "Sticker0 / Color / 2", "materials/default/stickers/default_wearmask.tga");
	float g_flSfxColorBoostSticker0 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker0 / SFX / 2"); >;
	float g_flSticker0Wear < UiType(Slider); UiGroup("Sticker0 / Wear / 2"); Expression(exists(Sticker0Wear) ? Sticker0Wear : this); >;
	CreateInputTexture2D(TextureHoloMaskSticker0, Linear, 8, "", "_holomask", "Sticker0 / SFX / 3", "materials/default/stickers/default_holomask.tga");
	float g_flColorBoostSticker0 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker0 / Color / 3"); >;
	float2 g_vWearBiasSticker0 < Default2(1, 1); Range2(0.001, -4, 4, 4); UiType(VectorText); UiGroup("Sticker0 / Wear / 3"); >;
	CreateInputTexture2D(TextureHoloSpectrumSticker0, Srgb, 8, "", "_holospectrum", "Sticker0 / SFX / 4", "materials/default/stickers/default_holospectrum.tga");
	float g_fWearScratchesSticker0 < Default(1); UiType(Slider); UiGroup("Sticker0 / Wear / 4"); >;
	float3 g_vColorTintSticker0 < Default3(1, 1, 1); UiType(Color); UiGroup("Sticker0 / Color / 4"); Expression(SrgbGammaToLinear(this)); >;
	bool g_bClampSpectrumVSticker0 < Default(1); UiType(CheckBox); UiGroup("Sticker0 / SFX / 5"); >;
	bool g_bSticker0WearPreview < UiType(CheckBox); UiGroup("Sticker0 / Wear / 5"); >;
	float g_flTintSaturateSticker0 < Default(1); UiType(Slider); UiGroup("Sticker0 / Color / 5"); Expression(1-this); >;
	CreateInputTexture2D(TextureGlitterMaskSticker0, Linear, 8, "Inverse", "_glittermask", "Sticker0 / SFX / 6", "materials/default/stickers/default_glittermask.tga");
	CreateInputTexture2D(TextureGlitterNormalSticker0, Linear, 8, "NormalizeNormals", "_normal", "Sticker0 / SFX / 7", "materials/default/stickers/squares_glitter_normal.tga");
	CreateInputTexture2D(TextureGlitterNormalMaskSticker0, Linear, 8, "", "_mask", "Sticker0 / SFX / 8", "materials/default/stickers/squares_glitter_mask.tga");
	float g_flGlitterScaleSticker0 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Sticker0 / SFX / 9"); >;
	bool g_bSelfIllumSticker0 < UiType(CheckBox); UiGroup("Sticker0 / SFX / 10"); >;
	CreateInputTexture2D(TextureSelfIllumMaskSticker0, Linear, 8, "", "_mask", "Sticker0 / SFX / 11", "materials/default/default_mask.tga");
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Sticker Inputs
	CreateInputTexture2D(TextureStickerScratches, Linear, 8, "", "", "Sticker Inputs", "materials/default/stickers/sticker_default_scratches.psd");
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_HOLOMASK_USE_DXT == 1)
		Texture2D g_tSfxMaskSticker0 < Channel(RGB, Box(TextureHoloMaskSticker0), Linear); Channel(A, Box(TextureGlitterMaskSticker0), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	#endif
	
	// Variant parameters
	Texture2D g_tSfxMaskSticker0 < Channel(RGB, Box(TextureHoloMaskSticker0), Linear); Channel(A, Box(TextureGlitterMaskSticker0), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 6 (name: g_vMetallicAlbedoLevels) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
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
	#extension GL_EXT_samplerless_texture_functions : require
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	struct _701
	{
	    vec4 _m0[3];
	};
	
	struct _911
	{
	    vec4 _m0[4];
	};
	
	struct _1677
	{
	    mat4x3 _m0;
	    vec3 _m1;
	    uint _m2;
	    vec3 _m3;
	    vec4 _m4;
	    vec3 _m5;
	    vec4 _m6;
	};
	
	struct _1269
	{
	    _1677 _m0[128];
	};
	
	struct _2848
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
	
	vec4 _4;
	vec3 _5;
	
	struct _1289
	{
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    vec3 g_vAlbedoLevels;
	    vec3 g_vDarkMetallicAlbedoLevels;
	    vec3 g_vMetallicAlbedoLevels;
	    float g_fColorBoostFactor;
	    vec3 g_vHoloAlbedoLevels;
	    int g_nActiveStickerApplySlot;
	    int g_bActiveStickerMoving;
	    float g_bActiveStickerPeelStartTime;
	    int g_bActiveStickerMouseOver;
	    int g_bStickerStoreMode;
	    int g_bEnableSticker0;
	    vec3 g_vColorTintSticker0;
	    float g_flTintSaturateSticker0;
	    int g_bAutomaticPBRColorFittingSticker0;
	    int g_bLegacyTintMultiplySticker0;
	    float g_flColorBoostSticker0;
	    float g_flSfxColorBoostSticker0;
	    int g_bMetallicSticker0;
	    int g_bHolographicSticker0;
	    int g_bPaperBackingSticker0;
	    int g_bPreserveRoughnessSticker0;
	    float g_flSticker0Wear;
	    vec2 g_vWearBiasSticker0;
	    float g_fWearScratchesSticker0;
	    int g_bSticker0WearPreview;
	    int g_bGlitterSticker0;
	    int g_bClampSpectrumVSticker0;
	    float g_flGlitterScaleSticker0;
	    int g_bSelfIllumSticker0;
	};
	
	layout(set = 1) uniform _1289 _Globals_;
	
	struct _2806
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    ivec4 _m3;
	    mat4 _m4;
	    vec2 _m5;
	    float _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	    vec4 _m12;
	    mat4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	    vec4 _m16;
	};
	
	layout(set = 1) uniform _2806 PerViewConstantBufferCsgo_t;
	
	struct _1503
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    vec3 _m4;
	    vec3 _m5;
	    vec3 _m6;
	};
	
	layout(set = 1) uniform _1503 PerViewConstantBuffer_t;
	
	struct _2145
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    _701 _m5;
	    _911 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    uvec4 _m10;
	    uvec4 _m11;
	    uvec4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    _1269 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    int _m18;
	    float _m19;
	    vec4 _m20;
	    float _m21;
	    float _m22;
	    float _m23;
	    float _m24;
	    _2848 _m25;
	    _911 _m26;
	};
	
	layout(set = 3) uniform _2145 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 51) uniform texture2D g_tColor;
	layout(set = 1, binding = 20) uniform sampler g_sUserConfigAllowGlobalMipBias;
	layout(set = 1, binding = 54) uniform texture2D g_tAmbientOcclusion;
	layout(set = 1, binding = 19) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 55) uniform texture2D g_tMetalness;
	layout(set = 1, binding = 52) uniform texture2D g_tNormal;
	layout(set = 1, binding = 14) uniform sampler g_sAniso;
	layout(set = 1, binding = 57) uniform texture2D g_tSticker0;
	layout(set = 1, binding = 59) uniform texture2D g_tNormalRoughnessSticker0;
	layout(set = 1, binding = 61) uniform texture2D g_tSfxMaskSticker0;
	layout(set = 1, binding = 25) uniform sampler g_sPoint;
	layout(set = 1, binding = 60) uniform texture2D g_tGlitterNormalSticker0;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 58) uniform texture2D g_tHoloSpectrumSticker0;
	layout(set = 1, binding = 26) uniform sampler g_sAnisoClampV;
	layout(set = 1, binding = 56) uniform texture2D g_tStickerScratches;
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 22) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 18) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 39) uniform texture2D g_tSsao;
	layout(set = 1, binding = 23) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 49) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 40) uniform textureCubeArray g_tEnvironmentMap;
	layout(set = 1, binding = 15) uniform sampler g_sBilinearClamp;
	layout(set = 1, binding = 35) uniform texture2DArray g_tBRDFLookup;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec4 input_2;
	layout(location = 3) centroid in vec4 input_3;
	layout(location = 4) centroid in vec3 input_4;
	layout(location = 5) in vec4 input_5;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    float _6484 = 1.0 / _11408.w;
	    vec4 _21678 = _11408;
	    _21678.w = _6484;
	    vec3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
	    bool _14874 = _Globals_.g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10251;
	    SPIRV_CROSS_BRANCH
	    if (_12885)
	    {
	        _10251 = _21709 * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    vec3 _24347 = normalize(_10251);
	    vec3 _7639 = input_0 + PerViewConstantBufferCsgo_t._m16.xyz;
	    vec4 _19680 = texture(sampler2D(g_tColor, g_sUserConfigAllowGlobalMipBias), input_2.xy);
	    vec4 _18992 = texture(sampler2D(g_tAmbientOcclusion, g_sUserConfig), vec2(input_2.xy).xy);
	    float _18168 = _18992.x;
	    vec4 _18993 = texture(sampler2D(g_tMetalness, g_sUserConfig), input_2.xy);
	    float _18169 = _18993.y;
	    vec4 _19372 = texture(sampler2D(g_tNormal, g_sUserConfig), input_2.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11176 = _16000 - _19720;
	    vec3 _18354 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    vec2 _12835 = _19372.zz;
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = !gl_FrontFacing;
	    }
	    else
	    {
	        _24327 = false;
	    }
	    vec3 _12631 = input_1.xyz * (_24327 ? (-1.0) : 1.0);
	    float _23240 = (input_5.w > 0.0) ? 1.0 : (-1.0);
	    vec3 _14435 = cross(_12631.xyz, input_5.xyz) * _23240;
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m3, ivec4(0));
	    bool _20058 = _24464.w;
	    vec3 _7424;
	    if (_20058)
	    {
	        _7424 = -_14435;
	    }
	    else
	    {
	        _7424 = _14435;
	    }
	    vec3 _20480;
	    if (!_24327)
	    {
	        vec3 _7482 = _18354;
	        _7482.y = -_18354.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _18354;
	    }
	    vec3 _15878 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    bool _23155 = _Globals_.g_bStickerStoreMode != 0;
	    vec3 _23987 = mix(_19680.xyz * input_3.xyz, vec3(0.0500000007450580596923828125), bvec3(_23155));
	    vec4 _13146;
	    float _13998;
	    vec3 _16310;
	    vec3 _17129;
	    vec2 _17130;
	    float _17131;
	    float _17132;
	    vec3 _17133;
	    float _17134;
	    vec3 _24173;
	    if (_Globals_.g_bEnableSticker0 != 0)
	    {
	        float _10825 = 2.5 * _Globals_.g_flGlitterScaleSticker0;
	        bool _23698 = _Globals_.g_bAutomaticPBRColorFittingSticker0 != 0;
	        bool _23699 = _Globals_.g_bLegacyTintMultiplySticker0 != 0;
	        bool _23700 = _Globals_.g_bMetallicSticker0 != 0;
	        bool _23702 = _Globals_.g_bPaperBackingSticker0 != 0;
	        bool _23704 = _Globals_.g_bSticker0WearPreview != 0;
	        bool _10966 = _24464.y;
	        float _17281 = _10966 ? 0.0 : input_3.w;
	        bool _10234 = 0 == _Globals_.g_nActiveStickerApplySlot;
	        vec2 _25030 = abs(vec2(1.0));
	        vec2 _24419 = ((input_2.xy - vec2(0.5)) * _25030.x) + vec2(0.5);
	        float _21628 = _24419.x;
	        bool _12887;
	        if (saturate(_21628) != _21628)
	        {
	            _12887 = true;
	        }
	        else
	        {
	            float _11829 = _24419.y;
	            _12887 = saturate(_11829) != _11829;
	        }
	        vec3 _13136;
	        float _16343;
	        vec2 _16863;
	        if (_23704)
	        {
	            vec2 _19209 = _24419.xy * 10.0;
	            _19209.y = _19209.y - 4.5;
	            _13136 = vec3(0.00999999977648258209228515625 + (fract((floor(_21628 * 128.0) + floor(_24419.y * 128.0)) * 0.5) * 0.0199999995529651641845703125));
	            _16343 = saturate(_21628 - (_21628 - 0.100000001490116119384765625 * trunc(_21628 / 0.100000001490116119384765625)));
	            _16863 = _19209;
	        }
	        else
	        {
	            _13136 = _23987;
	            _16343 = _Globals_.g_flSticker0Wear;
	            _16863 = _24419;
	        }
	        bool _12888;
	        if (_10234)
	        {
	            _12888 = _Globals_.g_bActiveStickerMoving == 0;
	        }
	        else
	        {
	            _12888 = false;
	        }
	        float _23727;
	        if (_12888)
	        {
	            _23727 = PerViewConstantBuffer_t._m0 - _Globals_.g_bActiveStickerPeelStartTime;
	        }
	        else
	        {
	            _23727 = 0.89999997615814208984375;
	        }
	        bool _7367 = _23727 < 0.89999997615814208984375;
	        vec2 _19287;
	        if (_23704)
	        {
	            _19287 = vec2(_16863.x, saturate(_16863.y));
	        }
	        else
	        {
	            _19287 = saturate(_16863);
	        }
	        vec4 _20322 = texture(sampler2D(g_tSticker0, g_sAniso), _19287.xy, -1.0);
	        float _7426 = _20322.w;
	        float _10511 = saturate(_7426 * 12.75);
	        vec4 _11192 = _20322;
	        _11192.w = _10511;
	        uvec2 _10918 = uvec2(textureSize(g_tSticker0, 0));
	        vec2 _14459 = vec2(1.0 / float(_10918.x), 1.0 / float(_10918.y));
	        vec2 _6345 = textureQueryLod(sampler2D(g_tSticker0, g_sAniso), clamp(_19287.xy, _14459, vec2(1.0) - _14459));
	        float _13002 = _6345.x;
	        float _8795 = 1.0 - saturate(_13002 - 3.0);
	        bool _18603 = _8795 > 0.0;
	        vec4 _23168;
	        if (_18603)
	        {
	            vec4 _17335 = _11192;
	            _17335.w = mix(_10511, max(_10511, saturate(texture(sampler2D(g_tSticker0, g_sAniso), saturate(((_19287 - vec2(0.5)) - (vec2(dot(cross(PerViewConstantBuffer_t._m6, PerViewConstantBuffer_t._m5), -_15878), dot(PerViewConstantBuffer_t._m5, _15878)) * 0.00999999977648258209228515625)) + vec2(0.5)).xy, 1.0).w * 12.75) * 0.699999988079071044921875), _8795);
	            _23168 = _17335;
	        }
	        else
	        {
	            _23168 = _11192;
	        }
	        float _24305 = _18603 ? _10511 : 1.0;
	        bool _22788;
	        if (_23168.w <= 0.0)
	        {
	            _22788 = !_7367;
	        }
	        else
	        {
	            _22788 = false;
	        }
	        vec4 _19373 = texture(sampler2D(g_tNormalRoughnessSticker0, g_sAniso), _19287.xy, -1.0);
	        float _16001 = _19373.x;
	        float _19721 = _19373.y;
	        float _16784 = (_16001 + _19721) - 1.00392162799835205078125;
	        float _11177 = _16001 - _19721;
	        vec3 _15728 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177)));
	        _15728.y = -_15728.y;
	        float _20013 = max(_13002, 3.0);
	        vec4 _11179 = textureLod(sampler2D(g_tNormal, g_sAniso), input_2.xy, _20013);
	        float _15751 = _11179.x;
	        float _17298 = _11179.y;
	        float _16785 = (_15751 + _17298) - 1.00392162799835205078125;
	        float _11178 = _15751 - _17298;
	        vec3 _15729 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178)));
	        _15729.y = -_15729.y;
	        vec3 _10176 = normalize(_15729 + ((_15728 * _23168.w) * 2.0));
	        float _16221 = min(pow(textureLod(sampler2D(g_tAmbientOcclusion, g_sAniso), input_2.xy, _20013).x, 0.75), (_24305 * 0.5) + 0.5);
	        float _13757 = _19373.z;
	        float _22924 = float(_23700);
	        vec3 _13138;
	        vec3 _16344;
	        float _16864;
	        if (_Globals_.g_bGlitterSticker0 != 0)
	        {
	            vec4 _20323 = texture(sampler2D(g_tSfxMaskSticker0, g_sAniso), _19287.xy, -1.0);
	            float _16037 = 1.0 - _20323.w;
	            vec3 _13137;
	            vec3 _16381;
	            float _16479;
	            if (_16037 != 0.0)
	            {
	                vec3 _7189 = normalize(PerViewConstantBuffer_t._m4.xyz - _7639.xyz);
	                vec4 _16749 = vec4(_19287 * _10825, (vec2(0.5) + _19287) * _10825);
	                vec2 _14097 = _16749.xy;
	                vec2 _12043 = dFdx(_14097);
	                vec2 _22140 = dFdy(_14097);
	                vec2 _8337 = max(_12043, _22140);
	                vec4 _19374 = texture(sampler2D(g_tGlitterNormalSticker0, g_sPoint), _16749.xy);
	                float _16002 = _19374.x;
	                float _19722 = _19374.y;
	                float _16786 = (_16002 + _19722) - 1.00392162799835205078125;
	                float _11180 = _16002 - _19722;
	                vec3 _16013 = normalize(vec3(vec2(_16786, _11180), (1.0 - abs(_16786)) - abs(_11180)));
	                vec3 _22292 = _16013 * _16013.z;
	                vec3 _14755 = _24347.xyz;
	                vec3 _9146 = sin(reflect(_7189, normalize((((input_5.xyz * _22292.x).xyz + (_7424.xyz * _22292.y)).xyz + (_14755 * _22292.z)).xyz)) * 12.0);
	                vec3 _7395 = max(vec3(0.0), (_9146 - vec3(0.9900000095367431640625)).xyz) * 100.00009918212890625;
	                vec3 _17144 = ((vec3(pow(dot(saturate(-_9146).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), 4.0)) + vec3(dot(saturate(vec3(0.14999997615814208984375) - _9146).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 0.25)).xyz + (((_7395.xyz + pow(_7395.yzx, vec3(4.0))) * 4.0) * 0.75)).xyz;
	                float _15604 = (0.039999999105930328369140625 * _16037) * saturate(1.0 - (min(_8337.x, _8337.y) * 40.0));
	                vec2 _24093 = _10176.xy + (_22292.xy * _15604);
	                vec3 _20488 = _10176;
	                _20488.x = _24093.x;
	                _20488.y = _24093.y;
	                vec4 _11181 = textureLod(sampler2D(g_tGlitterNormalSticker0, g_sTrilinearWrap), _16749.zw, 0.0);
	                float _15752 = _11181.x;
	                float _17300 = _11181.y;
	                float _16787 = (_15752 + _17300) - 1.00392162799835205078125;
	                float _11182 = _15752 - _17300;
	                vec3 _16014 = normalize(vec3(vec2(_16787, _11182), (1.0 - abs(_16787)) - abs(_11182)));
	                vec3 _9147 = sin(reflect(_7189, normalize((((input_5.xyz * _16014.x).xyz + (_7424.xyz * _16014.y)).xyz + (_14755 * _16014.z)).xyz)) * 12.0);
	                vec3 _7396 = max(vec3(0.0), (_9147 - vec3(0.9900000095367431640625)).xyz) * 100.00009918212890625;
	                vec3 _17145 = ((vec3(pow(dot(saturate(-_9147).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), 4.0)) + vec3(dot(saturate(vec3(0.14999997615814208984375) - _9147).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 0.25)).xyz + (((_7396.xyz + pow(_7396.yzx, vec3(4.0))) * 4.0) * 0.75)).xyz;
	                float _23793 = _11181.w;
	                vec3 _9756;
	                if (_23698)
	                {
	                    vec3 _19212 = normalize(max(vec3(0.0003000000142492353916168212890625), _23168.xyz)) * 1.059999942779541015625;
	                    vec3 _13607 = _19212.xyz;
	                    _9756 = mix(vec3(_Globals_.g_vAlbedoLevels.x), max((((_13607 * _Globals_.g_vAlbedoLevels.x) * 1.73199999332427978515625) / vec3(length(_13607))) / vec3(dot(_19212.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _19212 * mix(_Globals_.g_vAlbedoLevels.x, _Globals_.g_vAlbedoLevels.z, saturate(pow(max(_23168.x, max(_23168.y, _23168.z)), _Globals_.g_vAlbedoLevels.y)))).xyz, vec3(pow(smoothstep(0.0003000000142492353916168212890625, _Globals_.g_vAlbedoLevels.x, dot(saturate(_23168.xyz * 1.0).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), 0.5))).xyz;
	                }
	                else
	                {
	                    _9756 = _23168.xyz;
	                }
	                vec2 _13861 = _20488.xy + ((_16014.xy * _15604) * _23793);
	                vec3 _20489 = _20488;
	                _20489.x = _13861.x;
	                _20489.y = _13861.y;
	                _13137 = (max(((_17144 * 0.0500000007450580596923828125) + (_17144 * 0.949999988079071044921875)).xyz * _19374.w, ((_17145 * 0.0500000007450580596923828125) + (_17145 * 0.949999988079071044921875)).xyz * _23793) * (_9756 * _Globals_.g_flSfxColorBoostSticker0)).xyz * _16037;
	                _16381 = _20489;
	                _16479 = max(_22924, _16037 * 0.5);
	            }
	            else
	            {
	                _13137 = vec3(0.0);
	                _16381 = _10176;
	                _16479 = _22924;
	            }
	            _13138 = _13137;
	            _16344 = _16381;
	            _16864 = _16479;
	        }
	        else
	        {
	            _13138 = vec3(0.0);
	            _16344 = _10176;
	            _16864 = _22924;
	        }
	        vec4 _12889;
	        if (_23698)
	        {
	            vec3 _24156 = vec3(_16864);
	            vec3 _13747 = mix(vec3(1.0), _Globals_.g_vColorTintSticker0.xyz, _24156);
	            float _11982 = mix(0.0, _Globals_.g_flTintSaturateSticker0, _16864);
	            vec4 _12502;
	            if (_23699)
	            {
	                vec3 _22769 = mix(_23168.xyz, vec3(dot(_23168.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(_11982));
	                vec4 _17842 = _23168;
	                _17842.x = _22769.x;
	                _17842.y = _22769.y;
	                _17842.z = _22769.z;
	                vec3 _16474 = saturate(_17842.xyz * _13747);
	                float _15334 = _16474.x;
	                vec4 _13514 = _17842;
	                _13514.x = _15334;
	                float _21816 = _16474.y;
	                _13514.y = _21816;
	                float _21778 = _16474.z;
	                _13514.z = _21778;
	                vec3 _24045 = normalize(max(vec3(0.0003000000142492353916168212890625), _13514.xyz)) * 1.059999942779541015625;
	                float _6671 = dot(saturate(_13514.xyz * _Globals_.g_flColorBoostSticker0).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                vec3 _12756 = mix(_Globals_.g_vAlbedoLevels, mix(_Globals_.g_vMetallicAlbedoLevels, _Globals_.g_vDarkMetallicAlbedoLevels, vec3(smoothstep(0.550000011920928955078125, 0.0155999995768070220947265625, _6671))), _24156);
	                float _20080 = mix(_Globals_.g_vAlbedoLevels.x, _Globals_.g_vDarkMetallicAlbedoLevels.x, _16864);
	                vec3 _22777 = _24045.xyz;
	                vec3 _19114 = max((((_22777 * _20080) * 1.73199999332427978515625) / vec3(length(_22777))) / vec3(dot(_24045.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _24045 * mix(_12756.x, _12756.z, saturate(pow(max(_15334, max(_21816, _21778)) * _Globals_.g_flColorBoostSticker0, _12756.y)))).xyz;
	                vec3 _22937 = mix(vec3(_20080), mix(_19114, min(_12756.zzz, _19114 + vec3(_6671)), vec3(max(0.0, _Globals_.g_flColorBoostSticker0 - 1.0) * 0.01587301678955554962158203125)).xyz, vec3(pow(smoothstep(0.0003000000142492353916168212890625, _20080, _6671), 0.5)));
	                vec4 _13889 = _13514;
	                _13889.x = _22937.x;
	                _13889.y = _22937.y;
	                _13889.z = _22937.z;
	                _12502 = _13889;
	            }
	            else
	            {
	                vec3 _18073 = _13747.xyz;
	                vec3 _10732 = normalize(max(vec3(0.0003000000142492353916168212890625), mix(_18073 * _23168.xyz, _18073, vec3(_11982)).xyz)) * 1.059999942779541015625;
	                float _6670 = dot(saturate(_23168.xyz * _Globals_.g_flColorBoostSticker0).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                vec3 _12755 = mix(_Globals_.g_vAlbedoLevels, mix(_Globals_.g_vMetallicAlbedoLevels, _Globals_.g_vDarkMetallicAlbedoLevels, vec3(smoothstep(0.550000011920928955078125, 0.0155999995768070220947265625, _6670))), _24156);
	                float _20079 = mix(_Globals_.g_vAlbedoLevels.x, _Globals_.g_vDarkMetallicAlbedoLevels.x, _16864);
	                vec3 _22776 = _10732.xyz;
	                vec3 _19113 = max((((_22776 * _20079) * 1.73199999332427978515625) / vec3(length(_22776))) / vec3(dot(_10732.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _10732 * mix(_12755.x, _12755.z, saturate(pow(max(_23168.x, max(_23168.y, _23168.z)) * _Globals_.g_flColorBoostSticker0, _12755.y)))).xyz;
	                vec3 _22936 = mix(vec3(_20079), mix(_19113, min(_12755.zzz, _19113 + vec3(_6670)), vec3(max(0.0, _Globals_.g_flColorBoostSticker0 - 1.0) * 0.01587301678955554962158203125)).xyz, vec3(pow(smoothstep(0.0003000000142492353916168212890625, _20079, _6670), 0.5)));
	                vec4 _13888 = _23168;
	                _13888.x = _22936.x;
	                _13888.y = _22936.y;
	                _13888.z = _22936.z;
	                _12502 = _13888;
	            }
	            _12889 = _12502;
	        }
	        else
	        {
	            vec4 _12501;
	            if (_23700)
	            {
	                vec3 _20059 = mix(_23168.xyz, vec3(dot(_23168.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(_Globals_.g_flTintSaturateSticker0)) * _Globals_.g_vColorTintSticker0.xyz;
	                vec4 _23714 = _23168;
	                _23714.x = _20059.x;
	                _23714.y = _20059.y;
	                _23714.z = _20059.z;
	                vec3 _24687 = _23714.xyz * (_23699 ? _Globals_.g_flColorBoostSticker0 : 1.0);
	                vec4 _8673 = _23714;
	                _8673.x = _24687.x;
	                _8673.y = _24687.y;
	                _8673.z = _24687.z;
	                _12501 = _8673;
	            }
	            else
	            {
	                _12501 = _23168;
	            }
	            _12889 = _12501;
	        }
	        vec3 _12890;
	        if (_Globals_.g_bSelfIllumSticker0 != 0)
	        {
	            _12890 = (_12889.xyz * _19373.w) * 2.0;
	        }
	        else
	        {
	            _12890 = vec3(0.0);
	        }
	        vec4 _7479;
	        float _12015;
	        if (_Globals_.g_bHolographicSticker0 != 0)
	        {
	            vec4 _19338 = texture(sampler2D(g_tSfxMaskSticker0, g_sPoint), _19287.xy, -1.0);
	            vec4 _19718 = texture(sampler2D(g_tSfxMaskSticker0, g_sAniso), _19287.xy, -1.0);
	            vec3 _20694 = vec3(_19338.w);
	            vec3 _7714 = mix(_19338.xyz, _19718.xyz, _20694);
	            float _20576 = _7714.x;
	            float _13212;
	            vec4 _15670;
	            if (_20576 > 0.0)
	            {
	                vec3 _24006 = normalize(PerViewConstantBuffer_t._m4.xyz - _7639.xyz);
	                vec2 _20626 = vec2(_7714.y + (dot(_24006, _24347) + dot(_24006, PerViewLightingConstantBufferGpu_t._m16.xyz)), _7714.z);
	                vec3 _23509;
	                SPIRV_CROSS_BRANCH
	                if (_Globals_.g_bClampSpectrumVSticker0 != 0)
	                {
	                    _23509 = texture(sampler2D(g_tHoloSpectrumSticker0, g_sAnisoClampV), _20626, -1.0).xyz;
	                }
	                else
	                {
	                    _23509 = texture(sampler2D(g_tHoloSpectrumSticker0, g_sAniso), _20626, -1.0).xyz;
	                }
	                vec3 _25247 = mix(textureLod(sampler2D(g_tHoloSpectrumSticker0, g_sPoint), _20626, 0.0).xyz, _23509, _20694);
	                vec3 _19477 = _25247.xyz;
	                float _7244 = dot(saturate(_19477 * _Globals_.g_flSfxColorBoostSticker0).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                vec3 _19213 = normalize(max(vec3(0.0003000000142492353916168212890625), _19477)) * 1.059999942779541015625;
	                vec3 _13608 = _19213.xyz;
	                vec3 _19115 = max((((_13608 * _Globals_.g_vHoloAlbedoLevels.x) * 1.73199999332427978515625) / vec3(length(_13608))) / vec3(dot(_19213.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _19213 * mix(_Globals_.g_vHoloAlbedoLevels.x, _Globals_.g_vHoloAlbedoLevels.z, saturate(pow(max(_25247.x, max(_25247.y, _25247.z)) * _Globals_.g_flSfxColorBoostSticker0, _Globals_.g_vHoloAlbedoLevels.y)))).xyz;
	                vec3 _25191 = mix(_12889.xyz, mix(vec3(_Globals_.g_vHoloAlbedoLevels.x), mix(_19115, min(_Globals_.g_vHoloAlbedoLevels.zzz, _19115 + (vec3(_7244) * _Globals_.g_flSfxColorBoostSticker0)), vec3(max(0.0, _Globals_.g_flSfxColorBoostSticker0 - 1.0) / _Globals_.g_fColorBoostFactor)).xyz, vec3(pow(smoothstep(0.0003000000142492353916168212890625, _Globals_.g_vHoloAlbedoLevels.x, _7244), 0.5))), vec3(_20576));
	                vec4 _17843 = _12889;
	                _17843.x = _25191.x;
	                _17843.y = _25191.y;
	                _17843.z = _25191.z;
	                _13212 = _16864 * (1.0 - _20576);
	                _15670 = _17843;
	            }
	            else
	            {
	                _13212 = _16864;
	                _15670 = _12889;
	            }
	            _12015 = _13212;
	            _7479 = _15670;
	        }
	        else
	        {
	            _12015 = _16864;
	            _7479 = _12889;
	        }
	        float _13139;
	        float _14139;
	        vec4 _14611;
	        if (_16343 > 0.0)
	        {
	            vec4 _18101 = texture(sampler2D(g_tStickerScratches, g_sAniso), _19287.xy, -1.0);
	            float _12594 = 1.0 - min(_Globals_.g_fWearScratchesSticker0, _18101.x);
	            float _23653 = mix(_12594, _12594 * 0.5, _16343);
	            float _13560 = saturate(mix(_16343, _16343, _16343));
	            float _20309;
	            if (!_23702)
	            {
	                _20309 = ((_Globals_.g_vWearBiasSticker0.y * ((_Globals_.g_vWearBiasSticker0.y > 0.0) ? 0.5 : 0.25)) + 0.5) * 0.5;
	            }
	            else
	            {
	                _20309 = 0.5;
	            }
	            float _8281 = saturate(_13560 - pow(saturate((_7426 - 0.078431375324726104736328125) * 1.085106372833251953125), _Globals_.g_vWearBiasSticker0.x * _Globals_.g_vWearBiasSticker0.x));
	            vec4 _12005;
	            if (_23702)
	            {
	                float _12205 = saturate(_8281 * 2.0) + (_Globals_.g_vWearBiasSticker0.y * _13560);
	                vec3 _25192 = mix(vec3(mix(0.699999988079071044921875, 0.20000000298023223876953125 + (0.4000000059604644775390625 * _23653), _13560)), _7479.xyz, vec3(smoothstep(_12205, _12205 + 0.100000001490116119384765625, _23653)));
	                vec4 _17844 = _7479;
	                _17844.x = _25192.x;
	                _17844.y = _25192.y;
	                _17844.z = _25192.z;
	                _12005 = _17844;
	            }
	            else
	            {
	                _12005 = _7479;
	            }
	            float _18653 = saturate((_8281 * (1.0 + _20309)) - _20309);
	            float _12503;
	            if (_23700 ? true : (_Globals_.g_bPreserveRoughnessSticker0 != 0))
	            {
	                _12503 = _13757;
	            }
	            else
	            {
	                _12503 = mix(_13757, 0.800000011920928955078125, step(_23653, smoothstep(0.0, 0.3499999940395355224609375, _13560)));
	            }
	            _13139 = _13560;
	            _14139 = _12503;
	            _14611 = vec4(mix(_12005.xyz, _12005.xyz * _23653, vec3(_13560 * 0.300000011920928955078125)), _12005.w * smoothstep(_18653, _18653 + 0.100000001490116119384765625, _23653));
	        }
	        else
	        {
	            _13139 = _16343;
	            _14139 = _13757;
	            _14611 = _7479;
	        }
	        vec2 _7733 = mix(_19287.xy - vec2(0.5), _16344.xy, vec2(_14611.w));
	        vec3 _17845 = _16344;
	        _17845.x = _7733.x;
	        _17845.y = _7733.y;
	        vec4 _6617;
	        float _13143;
	        float _13694;
	        float _16307;
	        float _17118;
	        vec3 _17119;
	        if (_7367)
	        {
	            float _10421 = saturate(_23727 * 1.111111164093017578125);
	            float _23768 = saturate(_23727 * 2.22222232818603515625);
	            float _9521 = pow(_23768, 0.5);
	            float _10074 = _9521 - _19287.y;
	            float _6968 = abs(_10074);
	            float _13142;
	            float _16306;
	            vec4 _16481;
	            float _17116;
	            vec3 _17117;
	            float _17190;
	            if (_19287.y > _9521)
	            {
	                _13142 = _16221;
	                _16306 = _14139;
	                _17116 = _12015;
	                _17117 = _17845;
	                _17190 = _24305;
	                _16481 = vec4(0.0, 0.0, 0.0, _14611.w * (1.0 - pow(_6968, 0.20000000298023223876953125)));
	            }
	            else
	            {
	                float _9895 = mix(1.0, (_10074 + _9521) + (_6968 * 0.300000011920928955078125), pow(_19287.y, 0.20000000298023223876953125));
	                vec2 _16973 = _19287;
	                _16973.y = _9895;
	                vec4 _10451;
	                float _12735;
	                float _13140;
	                float _16305;
	                float _17114;
	                vec3 _17115;
	                if (_9895 < 1.0)
	                {
	                    vec4 _20991 = texture(sampler2D(g_tSticker0, g_sAniso), saturate(_16973).xy, -1.0);
	                    float _12475 = dot(_20991.xyz, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625));
	                    vec4 _19620;
	                    _19620.x = _12475;
	                    _19620.y = _12475;
	                    _19620.z = _12475;
	                    float _16956 = saturate(_20991.w * 12.75);
	                    float _18225 = mix(pow(_6968, 0.100000001490116119384765625), 1.0, _23768);
	                    vec3 _10962 = vec3(_16956);
	                    _13140 = mix(_16221, _18225, _16956);
	                    _16305 = mix(_14139, 0.800000011920928955078125, _16956);
	                    _17114 = mix(_12015, 0.0, _16956);
	                    _17115 = mix(_17845, vec3(0.0, 0.0, 1.0), _10962);
	                    _12735 = mix(_24305, 1.0, _16956);
	                    _10451 = vec4(mix(_14611.xyz * _18225, vec4(mix(_19620.xyz, vec3(0.300000011920928955078125), vec3(0.800000011920928955078125)) * pow(_6968, 0.20000000298023223876953125), _16956).xyz, _10962), max(_14611.w, _16956));
	                }
	                else
	                {
	                    _13140 = _16221;
	                    _16305 = _14139;
	                    _17114 = _12015;
	                    _17115 = _17845;
	                    _12735 = _24305;
	                    _10451 = _14611;
	                }
	                vec3 _14959 = mix(_10451.xyz, _10451.xyz * 10.0, vec3(step(0.5, _10421) * pow(smoothstep(1.0, 0.5, _10421), 20.0)));
	                vec4 _17846 = _10451;
	                _17846.x = _14959.x;
	                _17846.y = _14959.y;
	                _17846.z = _14959.z;
	                _13142 = _13140;
	                _16306 = _16305;
	                _17116 = _17114;
	                _17117 = _17115;
	                _17190 = _12735;
	                _16481 = _17846;
	            }
	            _13143 = _13142;
	            _16307 = _16306;
	            _17118 = _17116;
	            _17119 = _17117;
	            _13694 = _17190;
	            _6617 = _16481;
	        }
	        else
	        {
	            _13143 = _16221;
	            _16307 = _14139;
	            _17118 = _12015;
	            _17119 = _17845;
	            _13694 = _24305;
	            _6617 = _14611;
	        }
	        vec4 _20310;
	        if (PerViewConstantBuffer_t._m0 < 2.0)
	        {
	            vec3 _22956 = mix(_6617.xyz, _6617.xyz + vec3(1.0), vec3(pow(1.0 - (PerViewConstantBuffer_t._m0 * 0.5), 5.0)));
	            vec4 _17847 = _6617;
	            _17847.x = _22956.x;
	            _17847.y = _22956.y;
	            _17847.z = _22956.z;
	            _20310 = _17847;
	        }
	        else
	        {
	            _20310 = _6617;
	        }
	        float _12751 = _13694 * _20310.w;
	        vec4 _11402;
	        vec3 _13144;
	        float _15651;
	        float _16308;
	        float _17120;
	        vec3 _17121;
	        if (_10234)
	        {
	            vec4 _21710;
	            if (_Globals_.g_bActiveStickerMouseOver != 0)
	            {
	                vec3 _8828 = _20310.xyz * 2.0;
	                vec4 _8674 = _20310;
	                _8674.x = _8828.x;
	                _8674.y = _8828.y;
	                _8674.z = _8828.z;
	                _21710 = _8674;
	            }
	            else
	            {
	                _21710 = _20310;
	            }
	            bool _14877 = _Globals_.g_bActiveStickerMoving != 0;
	            float _10001;
	            vec4 _24335;
	            if (_14877)
	            {
	                vec2 _10159 = _19287.xy * 8.0;
	                vec3 _20326 = vec3(0.20000000298023223876953125) + saturate(vec3(dot(_21710.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))) * 0.60000002384185791015625);
	                vec4 _20490 = _21710;
	                _20490.x = _20326.x;
	                _20490.y = _20326.y;
	                _20490.z = _20326.z;
	                vec3 _20312 = _20490.xyz + vec3(fract((floor(_10159.x) + floor(_10159.y)) * 0.5) * 0.20020000636577606201171875);
	                vec4 _20491 = _20490;
	                _20491.x = _20312.x;
	                _20491.y = _20312.y;
	                _20491.z = _20312.z;
	                vec3 _22861 = _20491.xyz * _18168;
	                vec4 _8675 = _20491;
	                _8675.x = _22861.x;
	                _8675.y = _22861.y;
	                _8675.z = _22861.z;
	                _10001 = _12751 * 0.89999997615814208984375;
	                _24335 = _8675;
	            }
	            else
	            {
	                _10001 = _12751;
	                _24335 = _21710;
	            }
	            bvec3 _14008 = bvec3(_14877);
	            _13144 = mix(_13138, vec3(0.0), _14008);
	            _16308 = _14877 ? 0.800000011920928955078125 : _16307;
	            _17120 = _14877 ? 0.0 : _17118;
	            _17121 = mix(_17119, vec3(0.0, 0.0, 1.0), _14008);
	            _15651 = _10001;
	            _11402 = _24335;
	        }
	        else
	        {
	            _13144 = _13138;
	            _16308 = _16307;
	            _17120 = _17118;
	            _17121 = _17119;
	            _15651 = _12751;
	            _11402 = _20310;
	        }
	        vec4 _13145;
	        vec3 _16309;
	        vec3 _16482;
	        vec3 _17123;
	        vec2 _17124;
	        float _17125;
	        float _17126;
	        vec3 _17127;
	        float _17128;
	        float _17191;
	        if (!(_22788 ? true : _12887))
	        {
	            vec3 _23345 = vec3(_15651);
	            vec4 _7267;
	            _7267.w = max(0.0, _15651 * (1.0 - _13139));
	            _13145 = _7267;
	            _16309 = mix(vec3(0.0), _13144, _23345);
	            _17123 = mix(_13136.xyz, saturate(_11402.xyz), _23345);
	            _17124 = mix(_19372.zz, vec2(_16308), vec2(_15651));
	            _17125 = mix(_18169, _17120, _15651);
	            _17126 = mix(_18168, _13143, _11402.w);
	            _17127 = mix(vec3(0.0), _12890, _23345);
	            _17128 = _10966 ? _15651 : _17281;
	            _17191 = mix(_Globals_.g_flReflectance, 0.039999999105930328369140625, _15651);
	            _16482 = normalize(mix(_20480.xyz, _17121, _23345));
	        }
	        else
	        {
	            _13145 = vec4(0.0);
	            _16309 = vec3(0.0);
	            _17123 = _13136;
	            _17124 = _12835;
	            _17125 = _18169;
	            _17126 = _18168;
	            _17127 = vec3(0.0);
	            _17128 = _17281;
	            _17191 = _Globals_.g_flReflectance;
	            _16482 = _20480;
	        }
	        _13146 = _13145;
	        _16310 = _16309;
	        _17129 = _17123;
	        _17130 = _17124;
	        _17131 = _17125;
	        _17132 = _17126;
	        _17133 = _17127;
	        _17134 = _17128;
	        _13998 = _17191;
	        _24173 = _16482;
	    }
	    else
	    {
	        _13146 = vec4(0.0);
	        _16310 = vec3(0.0);
	        _17129 = _23987;
	        _17130 = _12835;
	        _17131 = _18169;
	        _17132 = _18168;
	        _17133 = vec3(0.0);
	        _17134 = input_3.w;
	        _13998 = _Globals_.g_flReflectance;
	        _24173 = _20480;
	    }
	    vec3 _7866 = _24173;
	    _7866.y = -_24173.y;
	    bool _12891;
	    if (_14874)
	    {
	        _12891 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12891 = false;
	    }
	    bool _24328;
	    if (_12891)
	    {
	        _24328 = !gl_FrontFacing;
	    }
	    else
	    {
	        _24328 = false;
	    }
	    vec3 _9739 = input_1.xyz * (_24328 ? (-1.0) : 1.0);
	    vec3 _24682 = cross(_9739.xyz, input_5.xyz) * _23240;
	    vec3 _7425;
	    if (_20058)
	    {
	        _7425 = -_24682;
	    }
	    else
	    {
	        _7425 = _24682;
	    }
	    vec3 _20481;
	    if (!_24328)
	    {
	        vec3 _23482 = _7866;
	        _23482.y = _24173.y;
	        _20481 = _23482;
	    }
	    else
	    {
	        _20481 = _7866;
	    }
	    vec3 _14788 = normalize((((input_5.xyz * _20481.x).xyz + (_7425.xyz * _20481.y)).xyz + (_9739.xyz * _20481.z)).xyz);
	    vec3 _12351 = mix(vec3(_13998).xyz, _17129.xyz, vec3(_17131));
	    vec3 _17892 = mix(vec3(1.0), _14788, bvec3(all(bvec3(true))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _11004 = max(_17130.xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _10170 = -_24347;
	    vec3 _24735 = _14788.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    vec3 _18708 = vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _23875));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    float _21711;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _10547 = ((floor(_21678.xy * PerViewConstantBufferCsgo_t._m6) * PerViewConstantBufferCsgo_t._m5.xy) + (PerViewConstantBufferCsgo_t._m5.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10547).xyzw - _21678.zzzz;
	        float _18579 = _18418.w;
	        float _12014 = _18418.z;
	        bool _12285 = abs(_12014) < _18579;
	        vec2 _23169;
	        if (_12285)
	        {
	            _23169 = vec2(PerViewConstantBufferCsgo_t._m5.x, 0.0);
	        }
	        else
	        {
	            _23169 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12014 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        vec2 _23170;
	        if (_12286)
	        {
	            _23170 = vec2(0.0, PerViewConstantBufferCsgo_t._m5.y);
	        }
	        else
	        {
	            _23170 = _23169;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m7.x * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.y * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.z * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.w * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13233 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21711 = (1.0 / (dot(_13233, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_13233, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10547 + mix(_23170, PerViewConstantBufferCsgo_t._m5.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21711 = 1.0;
	    }
	    float _21712;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).w)
	    {
	        _21712 = _21711 * textureLod(sampler2D(g_tSsao, g_sUserConfig), (_21678.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21712 = _21711;
	    }
	    float _21713;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m18 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13147;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m18))
	            {
	                _13147 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m20[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m22)) + vec2(PerViewLightingConstantBufferGpu_t._m21));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m26._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_13039].xy;
	                vec3 _20493 = _19470;
	                _20493.x = _20561.x;
	                _20493.y = _20561.y;
	                _13147 = saturate(_22193.x * _22193.y);
	                _14975 = _20493;
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
	            vec2 _7045;
	            vec2 _7046;
	            vec2 _7735;
	            float _8969;
	            float _8970;
	            float _15996;
	            float _17302;
	            vec2 _18870;
	            vec4 _20581;
	            vec4 _22024;
	            float _23728;
	            do
	            {
	                float _21452 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m19);
	                _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                _22024 = PerViewLightingConstantBufferGpu_t._m1;
	                _17302 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15996 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18870 = vec2(_17302, _15996);
	                _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7045 = vec2(_8969, _15996);
	                _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7046 = vec2(_17302, _8970);
	                _7735 = vec2(_8969, _8970);
	                float _15310 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _18870).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7045).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7046).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7735).xy, _21452), 0.0)).xyzw, vec4(0.25));
	                bool _12892;
	                if (_15310 == 0.0)
	                {
	                    _12892 = true;
	                }
	                else
	                {
	                    _12892 = _15310 == 1.0;
	                }
	                if (_12892)
	                {
	                    _23728 = _15310;
	                    break;
	                }
	                _23728 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_17302, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_8969, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _8970)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _15996)).xy, _21452), 0.0)).xyzw, _22024.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, _21452), 0.0) * _22024.y);
	                break;
	            } while(false);
	            float _12506;
	            SPIRV_CROSS_BRANCH
	            if (_13147 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m18 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m26._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_15335].xy;
	                    vec3 _20494;
	                    _20494.x = _20562.x;
	                    _20494.y = _20562.y;
	                    float _12505;
	                    do
	                    {
	                        float _20324 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m19);
	                        float _15311 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + _18870).xy, _20324), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + _7045).xy, _20324), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + _7046).xy, _20324), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + _7735).xy, _20324), 0.0)).xyzw, vec4(0.25));
	                        bool _12893;
	                        if (_15311 == 0.0)
	                        {
	                            _12893 = true;
	                        }
	                        else
	                        {
	                            _12893 = _15311 == 1.0;
	                        }
	                        if (_12893)
	                        {
	                            _12505 = _15311;
	                            break;
	                        }
	                        _12505 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + vec2(_17302, 0.0)).xy, _20324), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + vec2(_8969, 0.0)).xy, _20324), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + vec2(0.0, _8970)).xy, _20324), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20494.xy + vec2(0.0, _15996)).xy, _20324), 0.0)).xyzw, _22024.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20494.xy, _20324), 0.0) * _22024.y);
	                        break;
	                    } while(false);
	                    _7934 = _12505;
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12506 = mix(_7934, _23728, _13147);
	            }
	            else
	            {
	                _12506 = _23728;
	            }
	            _19363 = _12506;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, saturate((distance(_7639.xyz, PerViewConstantBuffer_t._m4) * PerViewLightingConstantBufferGpu_t._m24) + PerViewLightingConstantBufferGpu_t._m23));
	        float _12507;
	        if (_24465.y)
	        {
	            _12507 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_21678.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12507 = _13279;
	        }
	        _21713 = _12507;
	    }
	    else
	    {
	        _21713 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _24735) * _21713) > 0.0)
	    {
	        float _11797 = max(0.0, dot(_14788.xyz, PerViewLightingConstantBufferGpu_t._m16.xyz));
	        vec2 _9840 = max(_11004, vec2(PerViewLightingConstantBufferGpu_t._m16.w));
	        vec3 _21889 = (-normalize(_7639.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz;
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m16.xyz + _21889).xyz;
	        vec3 _19012 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz;
	        float _12386 = dot(_12281, _19012);
	        vec3 _22995 = _12351.xyz;
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _24198 = _25211 / (((_12386 * _12386) * ((_25211 * _25211) - 1.0)) + 1.0);
	        float _16150 = _9850 + 1.0;
	        float _6835 = (_16150 * _16150) * 0.125;
	        float _19569 = 1.0 - _6835;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m17.xyz * _21713).xyz;
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz + (vec3(_11797).xyz * _16808);
	        _24878 = (((_22995 + ((vec3(1.0) - _22995) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _12281))), 5.0))) * ((_24198 * _24198) / ((4.0 * ((_11797 * _19569) + _6835)) * ((max(0.0, dot(_19012, _21889)) * _19569) + _6835)))).xyz * _11797).xyz * _16808;
	    }
	    else
	    {
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz;
	        _24878 = vec3(0.0);
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20062 = _24467.x;
	    vec4 _19364;
	    if (_20062)
	    {
	        vec4 _18621 = vec4(_7639.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m4;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _21678;
	    }
	    uvec2 _7663 = uvec2(PerViewLightingConstantBufferGpu_t._m12.x);
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m10.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m12.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13148;
	    vec3 _16324;
	    _13148 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    vec3 _13149;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13149 = _16324;
	        _16325 = _13148;
	        uint _20344;
	        vec3 _13213;
	        vec3 _15671;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_17018)) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_0.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21782 = _10521.z;
	                _22905.z = _21782;
	                vec3 _21642 = _22905.xyz;
	                bool _7427;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7427 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7427 = false;
	                }
	                bool _12894;
	                if (!_7427)
	                {
	                    _12894 = true;
	                }
	                else
	                {
	                    _12894 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_0.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12894)
	                {
	                    _13213 = _13149;
	                    _15671 = _16325;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23572 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = smoothstep(0.0, 1.0, _21782 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21782) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11184;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_0.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _20958 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _20958;
	                        float _25105 = dot(-_20958, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _20958;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _20958 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11184 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11184 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24422;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24422 = !_20062;
	                }
	                else
	                {
	                    _24422 = false;
	                }
	                vec3 _21548;
	                SPIRV_CROSS_BRANCH
	                if (g_BarnLights_1._m0[_12608]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22156 = abs(_22905.xy);
	                        if (g_BarnLights_1._m0[_12608]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.x, _22156.x) * smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.y, _22156.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22156.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15017 = _22156.y;
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
	                    vec3 _12508;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11184).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20482 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20482 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20482);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20497 = _14081;
	                        _20497.x = _20564.x;
	                        _20497.y = _20564.y;
	                        _12508 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20497.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20496 = _13791;
	                        _20496.x = _20563.x;
	                        _20496.y = _20563.y;
	                        _12508 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20496.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12508;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13213 = _13149;
	                    _15671 = _16325;
	                    break;
	                }
	                vec3 _22671;
	                if (_24422)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6282 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23716 = _21642;
	                        _23716.x = _6282.x;
	                        _23716.y = _6282.y;
	                        _19629 = _23716;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m19);
	                        vec2 _14615 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0)).xyzw, vec4(0.25));
	                        bool _12895;
	                        if (_15312 == 0.0)
	                        {
	                            _12895 = true;
	                        }
	                        else
	                        {
	                            _12895 = _15312 == 1.0;
	                        }
	                        if (_12895)
	                        {
	                            _24972 = _15312;
	                            break;
	                        }
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14615, _11455), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _13213 = _13149;
	                        _15671 = _16325;
	                        break;
	                    }
	                    _22671 = _19878;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                float _11798 = max(0.0, dot(_14788.xyz, _11184.xyz));
	                vec2 _9841 = max(_11004, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _21890 = (-normalize(_7639.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz;
	                vec3 _12282 = normalize(_11184.xyz + _21890).xyz;
	                vec3 _19014 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz;
	                float _12387 = dot(_12282, _19014);
	                vec3 _22996 = _12351.xyz;
	                float _9852 = _9841.x;
	                float _25212 = _9852 * _9852;
	                float _24199 = _25212 / (((_12387 * _12387) * ((_25212 * _25212) - 1.0)) + 1.0);
	                float _16151 = _9852 + 1.0;
	                float _6836 = (_16151 * _16151) * 0.125;
	                float _19572 = 1.0 - _6836;
	                _13213 = _13149.xyz + ((((_22996 + ((vec3(1.0) - _22996) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11184.xyz, _12282))), 5.0))) * ((_24199 * _24199) / ((4.0 * ((_11798 * _19572) + _6836)) * ((max(0.0, dot(_19014, _21890)) * _19572) + _6836)))).xyz * _11798).xyz * _22671.xyz);
	                _15671 = _16325.xyz + (vec3(_11798).xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13149 = _13213;
	            _16325 = _15671;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13148 = _16325;
	        _16324 = _13149;
	        _17017 = _21567;
	        continue;
	    }
	    vec3 _19129 = _7639.xyz;
	    vec3 _10145 = normalize(_19129 - PerViewConstantBuffer_t._m4.xyz);
	    vec3 _19257 = -_10145;
	    float _17138 = _11004.x + _11004.y;
	    float _19583 = _17138 * _17138;
	    float _17751 = dot(_11004.xy, vec2(0.5));
	    vec3 _6519 = _17892.xyz;
	    vec3 _19081 = _17892.xyz;
	    float _23571 = PerViewLightingConstantBufferGpu_t._m14.y * sqrt(_17751);
	    float _17225 = _17751 * _17751;
	    float _20711 = saturate(1.0 - _17225);
	    vec3 _25271 = normalize(mix(_6519, reflect(_10145.xyz, _19081).xyz, vec3(_20711 * (sqrt(_20711) + _17225))));
	    uvec2 _6815 = uvec2(_21678.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _19949 = PerViewLightingConstantBufferGpu_t._m11.y + (((_6815.y * PerViewLightingConstantBufferGpu_t._m12.y) + _6815.x) * PerViewLightingConstantBufferGpu_t._m11.z);
	    uint _23394 = PerViewLightingConstantBufferGpu_t._m11.x + (uint(clamp(_6484 * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m11.z);
	    vec4 _13150;
	    float _16311;
	    vec3 _17135;
	    _13150 = vec4(0.0);
	    _16311 = 0.00999999977648258209228515625;
	    _17135 = vec3(0.0);
	    uint _8898;
	    vec4 _13153;
	    vec3 _14891;
	    float _16313;
	    bool _18381;
	    uint _17020 = 0u;
	    bool _17136 = false;
	    for (;;)
	    {
	        bool _12896;
	        if (_17020 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12896 = !_17136;
	        }
	        else
	        {
	            _12896 = false;
	        }
	        if (!_12896)
	        {
	            break;
	        }
	        uint _14476 = subgroupOr(g_CullBits_1._m0[_19949 + _17020] & g_CullBits_1._m0[_23394 + _17020]);
	        vec3 _13151;
	        vec4 _16312;
	        _13151 = _17135;
	        _16312 = _13150;
	        uint _10157;
	        vec3 _13152;
	        vec4 _16382;
	        float _16483;
	        uint _17021 = _14476;
	        float _17137 = _16311;
	        for (;;)
	        {
	            if (!(_17021 != 0u))
	            {
	                _13153 = _16312;
	                _16313 = _17137;
	                _14891 = _13151;
	                _18381 = _17136;
	                break;
	            }
	            uint _18154 = uint(findLSB(_17021));
	            int _12611 = int(_18154 + (_17020 * 32u));
	            _10157 = _17021 & (_17021 - 1u);
	            vec3 _24592 = PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m0 * vec4(_19129, 1.0);
	            vec3 _7748 = _24592.xyz;
	            vec3 _8793 = saturate((_7748 - PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m1) * PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m4.xyz);
	            vec3 _19651 = saturate((PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m3 - _7748) * PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m4.xyz);
	            float _17265 = min(min(_8793.x, min(_8793.y, _8793.z)), min(_19651.x, min(_19651.y, _19651.z)));
	            if (_17265 == 0.0)
	            {
	                _13152 = _13151;
	                _16382 = _16312;
	                _16483 = _17137;
	                _13151 = _13152;
	                _16312 = _16382;
	                _17137 = _16483;
	                _17021 = _10157;
	                continue;
	            }
	            vec3 _24234 = _24592.xyz;
	            vec3 _7648 = (PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m0 * vec4(_25271.xyz, 0.0)).xyz;
	            vec3 _11253 = max(((PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m3.xyz - _24234) / _7648).xyz, ((PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m1.xyz - _24234) / _7648).xyz);
	            float _11076 = ((_17265 * _17265) * (((-2.0) * _17265) + 3.0)) * (1.0 - _17137);
	            float _13713 = _17137 + _11076;
	            vec3 _15431 = _13151 + ((textureLod(samplerCubeArray(g_tEnvironmentMap, g_sTrilinearWrap), vec4(mix(_24234 + (_7648 * abs(min(_11253.x, min(_11253.y, _11253.z)))), _7648, vec3(_17751)).xyz, float(PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m2)), _23571).xyz * PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m5) * _11076);
	            vec4 _7460 = _16312 + (PerViewLightingConstantBufferGpu_t._m15._m0[_12611]._m6 * _11076);
	            if (_13713 > 0.9900000095367431640625)
	            {
	                _13153 = _7460;
	                _16313 = _13713;
	                _14891 = _15431;
	                _18381 = true;
	                break;
	            }
	            _13152 = _15431;
	            _16382 = _7460;
	            _16483 = _13713;
	            _13151 = _13152;
	            _16312 = _16382;
	            _17137 = _16483;
	            _17021 = _10157;
	            continue;
	        }
	        _8898 = _17020 + 1u;
	        _13150 = _13153;
	        _16311 = _16313;
	        _17135 = _14891;
	        _17136 = _18381;
	        _17020 = _8898;
	        continue;
	    }
	    vec4 _11487 = textureLod(sampler2DArray(g_tBRDFLookup, g_sBilinearClamp), vec3((vec2(_17751, sqrt(1.0 - max(0.0, dot(_19257.xyz, _6519)))) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _7300 = mix(_11487.xxx, _11487.yyy, _12351);
	    float _21809 = 1.0 - _11487.y;
	    vec3 _15517 = _12351 + ((vec3(1.0) - _12351) * vec3(0.0476190485060214996337890625));
	    vec3 _23208 = ((_7300 * _15517) / (vec3(1.0) - (_15517 * _21809))) * _21809;
	    vec3 _13436 = vec3(_21712 * _17132).xyz;
	    vec3 _17068 = _13148.xyz + ((_18708 * (vec3(1.0) - (_7300 + _23208))).xyz * _13436).xyz;
	    vec4 _11665 = vec4(_17068 * (_17129.xyz * (1.0 - _17131)).xyz, _17134);
	    vec3 _15753 = _11665.xyz + _17133.xyz;
	    vec4 _20498 = _11665;
	    _20498.x = _15753.x;
	    _20498.y = _15753.y;
	    _20498.z = _15753.z;
	    vec3 _15754 = _20498.xyz + ((_16324 * (vec3(1.0) + (_12351 * ((0.125 * (_19583 * _19583)) * saturate(dot(_17892, _19257)))))).xyz * _13436).xyz;
	    vec4 _20499 = _20498;
	    _20499.x = _15754.x;
	    _20499.y = _15754.y;
	    _20499.z = _15754.z;
	    vec3 _15733 = _20499.xyz + ((((_17135 / vec3(_16311)).xyz * min(dot(_18708.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_19081, 1.0), (_13150 / vec4(_16311)).xyzw), max((_17751 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_7300 + _23208)).xyz * _13436).xyz;
	    vec4 _13890 = _20499;
	    _13890.x = _15733.x;
	    _13890.y = _15733.y;
	    _13890.z = _15733.z;
	    vec3 _20177 = _13890.xyz + (_17068 * _16310.xyz);
	    vec4 _20500 = _13890;
	    _20500.x = _20177.x;
	    _20500.y = _20177.y;
	    _20500.z = _20177.z;
	    vec4 _12899;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22957 = _7639.xyz - PerViewConstantBuffer_t._m4.xyz;
	        vec3 _9057 = _22957.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22957.xyz;
	            bool _12897;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m10.x)
	            {
	                _12897 = (_7639.z * PerViewConstantBufferCsgo_t._m10.z) < PerViewConstantBufferCsgo_t._m10.y;
	            }
	            else
	            {
	                _12897 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12897)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m7.xy + (PerViewConstantBufferCsgo_t._m7.zw * vec2(length(_21493), _7639.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m8.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m8.y)) * PerViewConstantBufferCsgo_t._m9.w;
	                _19340 = mix(_20500.xyz, vec4(PerViewConstantBufferCsgo_t._m9.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _20500.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _20500;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12898;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m14.x)
	            {
	                _12898 = (PerViewConstantBufferCsgo_t._m14.z * _7639.z) < PerViewConstantBufferCsgo_t._m14.y;
	            }
	            else
	            {
	                _12898 = false;
	            }
	            if (_12898)
	            {
	                float _14605 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m11.y) + PerViewConstantBufferCsgo_t._m11.x), PerViewConstantBufferCsgo_t._m11.w)) * saturate(pow(max(0.0, (_7639.z * PerViewConstantBufferCsgo_t._m12.y) + PerViewConstantBufferCsgo_t._m12.x), PerViewConstantBufferCsgo_t._m12.z));
	                float _8892 = saturate(_14605) * PerViewConstantBufferCsgo_t._m14.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m13 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m12.w * saturate(1.0 - (_14605 * PerViewConstantBufferCsgo_t._m11.z))) * PerViewConstantBufferCsgo_t._m15.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _12899 = _23944;
	    }
	    else
	    {
	        _12899 = _20500;
	    }
	    bool _12900;
	    if (_23155)
	    {
	        _12900 = _13146.w <= 0.100000001490116119384765625;
	    }
	    else
	    {
	        _12900 = false;
	    }
	    if (_12900)
	    {
	        discard;
	    }
	    output_0 = _12899;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(NoZPrepass, false);
	BoolAttribute(DoNotCastShadows, false);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, false);
	BoolAttribute(SupportsLightmapping, false);
	BoolAttribute(PerVertexLighting, true);
	
	
	// PSRS
	
	RenderState(StencilRef, 3);
}
