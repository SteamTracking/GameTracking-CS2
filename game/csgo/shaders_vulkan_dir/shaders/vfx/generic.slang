//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Used to display legacy content. Do not use to author new materials.";
	DevShader = true;
	Version = 26;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	CsgoForward();
	Depth("csgo_depth_only.vfx");
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_SPECULAR, 0..1, "Specular" );
	Feature( F_UNLIT, 0..1, "Lighting" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_OVERLAY, 0..1, "Overlay" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_SELF_ILLUM, 0..1, "Self Illum" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	FeatureRule( Allow1( F_UNLIT, F_SPECULAR ), "Specular and Unlit are not compatible" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_ALPHA_TEST ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Requires( F_OVERLAY, F_TRANSLUCENT ), "Overlay requires translucent" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_SELF_ILLUM, F_UNLIT ), "Self Illum and Unlit are not compatible" );
	FeatureRule( Allow1( F_UNLIT, F_TINT_MASK ), "Tint Mask and Unlit are not compatible" );
	FeatureRule( Allow1( F_OVERLAY, F_UNLIT ), "Unlit mode not supported with overlays" );
	FeatureRule( Allow1( F_OVERLAY, F_RENDER_BACKFACES ), "Render back faces not supported with overlays" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_SPECULAR, F_SPECULAR );
	StaticCombo( S_UNLIT, F_UNLIT );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Allow1( S_UNLIT, S_SPECULAR ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( S_UNLIT, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
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
	static float4 output_4;
	static uint output_5;
	
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
	    float4 output_4 : TEXCOORD4;
	    nointerpolation uint output_5 : TEXCOORD5;
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
	    float3 _12151 = mul(_12618, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _18237 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = normalize(mul(_12618, float4(vNormalOs.xyz, 0.0f)));
	    output_2 = vTexCoord.xyxy;
	    output_3 = _20063;
	    output_4 = float4(normalize(mul(_12618, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_5 = g_instanceBuffer.Load(nInstanceIdx * 32 + 20) & 65535u;
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
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	
	#if (S_SPECULAR == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_UNLIT == 0)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
}

PS
{
	StaticCombo( S_SPECULAR, F_SPECULAR );
	StaticCombo( S_UNLIT, F_UNLIT );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_OVERLAY, F_OVERLAY );
	StaticComboRule( Allow1( S_UNLIT, S_SPECULAR ) );
	StaticComboRule( Allow1( S_TRANSLUCENT, S_ALPHA_TEST ) );
	StaticComboRule( Requires( S_OVERLAY, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_SELF_ILLUM, S_UNLIT ) );
	StaticComboRule( Allow1( S_UNLIT, S_TINT_MASK ) );
	StaticComboRule( Allow1( S_OVERLAY, S_UNLIT ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( S_UNLIT, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SPECULAR, S_MODE_TOOLS_VIS ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT, S_ALPHA_TEST ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT, S_ALPHA_TEST ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Allow1( S_OVERLAY, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap3 < Attribute("debug_chart_color"); SrgbRead(false); >;
	Texture2D g_tMetalnessReflectanceFresnel < Channel(R, Box(TextureMetalness), Linear); Channel(G, Box(TextureReflectance), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(AG, MipNormal(TextureNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tRoughness < Channel(RGBA, AnisoNormal(TextureNormal, TextureGlossiness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	Texture2D g_tTintMask < Channel(G, Box(TextureTintMask), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float2 g_vMetalnessScaleAndBias < UiType(VectorText); Expression(float2(max(g_vMetalnessRange.x,g_vMetalnessRange.y)-g_vMetalnessRange.x,g_vMetalnessRange.x)); >;
	float2 g_vReflectanceScaleAndBias < UiType(VectorText); Expression(float2(max(g_vReflectanceRange.x,g_vReflectanceRange.y)-g_vReflectanceRange.x,g_vReflectanceRange.x)); >;
	float2 g_vRoughnessScaleAndBias < UiType(VectorText); Expression(float2(max(1-g_vGlossinessRange.x,1-g_vGlossinessRange.y)-(1-g_vGlossinessRange.y),1-g_vGlossinessRange.y)); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression(g_flSelfIllumScale*g_vSelfIllumTint.xyz); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); >;
	
	// Lighting
	CreateInputTexture2D(TextureGlossiness, Linear, 8, "", "_gloss", "Lighting,30/Gloss,20/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureReflectance, Linear, 8, "", "_refl", "Lighting,30/Reflectance,10/10", Default4(0.1, 0.1, 0.1, 0));
	float2 g_vGlossinessRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Gloss/20"); >;
	float2 g_vMetalnessRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Metalness/20"); >;
	float2 g_vReflectanceRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Reflectance/20"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	float g_flBumpStrength < Default(1); Range(0, 10); UiType(Slider); UiGroup("Normal Map"); >;
	
	// Self Illum
	CreateInputTexture2D(TextureSelfIllumMask, Linear, 8, "", "_selfillum", "Self Illum", Default4(1, 1, 1, 0));
	float g_flSelfIllumScale < Default(1); Range(0, 16); UiType(Slider); UiGroup("Self Illum"); >;
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_OVERLAY == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 4 (name: g_vColorTint) cannot be expressed with either HLSL packing layout or packoffset.
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
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	struct _2116
	{
	    vec4 _m0[3];
	};
	
	struct _2326
	{
	    vec4 _m0[4];
	};
	
	struct _1802
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
	
	vec3 _4;
	vec4 _5;
	
	struct _1132
	{
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flBumpStrength;
	    vec3 g_vColorTint;
	};
	
	layout(set = 1) uniform _1132 _Globals_;
	
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
	
	struct _295
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    _2116 _m4;
	    _2326 _m5;
	    vec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    uvec4 _m9;
	    uvec4 _m10;
	    vec4 _m11;
	    vec4 _m12;
	    vec4 _m13;
	    int _m14;
	    float _m15;
	    vec4 _m16;
	    float _m17;
	    float _m18;
	    float _m19;
	    float _m20;
	    _1802 _m21;
	    _2326 _m22;
	};
	
	layout(set = 3) uniform _295 PerViewLightingConstantBufferGpu_t;
	
	struct _1194
	{
	    vec2 _m0;
	    vec2 _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 1) uniform _1194 PerViewConstantBuffer_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 51) uniform texture2D g_tColor;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 52) uniform texture2D g_tNormal;
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 22) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 18) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 39) uniform texture2D g_tSsao;
	layout(set = 1, binding = 19) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 23) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 49) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec4 input_2;
	layout(location = 3) centroid in vec4 input_3;
	layout(location = 4) in vec4 input_4;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
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
	        _10251 = input_1.xyz * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = input_1.xyz;
	    }
	    vec3 _24347 = normalize(_10251);
	    vec3 _11095 = input_0 + PerViewConstantBufferCsgo_t._m16.xyz;
	    vec4 _19414 = texture(sampler2D(g_tColor, g_sTrilinearWrap), input_2.xy);
	    vec2 _7707 = (texture(sampler2D(g_tNormal, g_sTrilinearWrap), input_2.xy).wy * 2.0) - vec2(1.0);
	    float _9481 = _7707.x;
	    vec3 _22101;
	    _22101.x = _9481;
	    float _21775 = _7707.y;
	    _22101.y = _21775;
	    vec3 _19529 = vec3(_9481, _21775, sqrt(saturate(1.0 - dot(_22101.xy, _22101.xy)))).xyz;
	    _19529.y = -_21775;
	    vec3 _24157 = _19529.xyz;
	    vec2 _11003 = _19529.xy * _Globals_.g_flBumpStrength;
	    _24157.x = _11003.x;
	    _24157.y = _11003.y;
	    vec3 _23332 = normalize(_24157.xyz);
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
	    vec3 _14435 = cross(_12631.xyz, input_4.xyz) * ((input_4.w > 0.0) ? 1.0 : (-1.0));
	    vec3 _7424;
	    if (notEqual(PerViewConstantBufferCsgo_t._m3, ivec4(0)).w)
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
	        vec3 _16556 = _23332;
	        _16556.y = -_23332.y;
	        _20480 = _16556;
	    }
	    else
	    {
	        _20480 = _23332;
	    }
	    vec3 _24299 = normalize((((input_4.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    vec3 _24927 = -_24347;
	    vec3 _24735 = _24299.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    float _21709;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _10547 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m6) * PerViewConstantBufferCsgo_t._m5.xy) + (PerViewConstantBufferCsgo_t._m5.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10547).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m5.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12286)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m5.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m6.x * fma(dot(_24927, normalize(vec3(PerViewLightingConstantBufferGpu_t._m5._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m6.y * fma(dot(_24927, normalize(vec3(PerViewLightingConstantBufferGpu_t._m5._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m6.z * fma(dot(_24927, normalize(vec3(PerViewLightingConstantBufferGpu_t._m5._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m6.w * fma(dot(_24927, normalize(vec3(PerViewLightingConstantBufferGpu_t._m5._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m5._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21709 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m7.x)) * (PerViewLightingConstantBufferGpu_t._m7.x + dot(_13232, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10547 + mix(_23169, PerViewConstantBufferCsgo_t._m5.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21709 = 1.0;
	    }
	    float _21710;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).w)
	    {
	        _21710 = _21709 * textureLod(sampler2D(g_tSsao, g_sUserConfig), (_11408.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21710 = _21709;
	    }
	    float _21711;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m14 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m14))
	            {
	                _13136 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m21._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m16[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m18)) + vec2(PerViewLightingConstantBufferGpu_t._m17));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m22._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m22._m0[_13039].xy;
	                vec3 _20488 = _19470;
	                _20488.x = _20561.x;
	                _20488.y = _20561.y;
	                _13136 = saturate(_22193.x * _22193.y);
	                _14975 = _20488;
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
	            float _17299;
	            vec2 _18870;
	            vec4 _20581;
	            vec4 _22023;
	            float _23727;
	            do
	            {
	                float _21452 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m15);
	                _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                _22023 = PerViewLightingConstantBufferGpu_t._m1;
	                _17299 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15996 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18870 = vec2(_17299, _15996);
	                _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7045 = vec2(_8969, _15996);
	                _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7046 = vec2(_17299, _8970);
	                _7735 = vec2(_8969, _8970);
	                float _15310 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _18870).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7045).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7046).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7735).xy, _21452), 0.0)).xyzw, vec4(0.25));
	                bool _12887;
	                if (_15310 == 0.0)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    _12887 = _15310 == 1.0;
	                }
	                if (_12887)
	                {
	                    _23727 = _15310;
	                    break;
	                }
	                _23727 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_17299, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_8969, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _8970)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _15996)).xy, _21452), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, _21452), 0.0) * _22023.y);
	                break;
	            } while(false);
	            float _12502;
	            SPIRV_CROSS_BRANCH
	            if (_13136 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m14 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m21._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m22._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m22._m0[_15335].xy;
	                    vec3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    float _12501;
	                    do
	                    {
	                        float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m15);
	                        float _15311 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _18870).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7045).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7046).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7735).xy, _20322), 0.0)).xyzw, vec4(0.25));
	                        bool _12888;
	                        if (_15311 == 0.0)
	                        {
	                            _12888 = true;
	                        }
	                        else
	                        {
	                            _12888 = _15311 == 1.0;
	                        }
	                        if (_12888)
	                        {
	                            _12501 = _15311;
	                            break;
	                        }
	                        _12501 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(_17299, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(_8969, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(0.0, _8970)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(0.0, _15996)).xy, _20322), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20489.xy, _20322), 0.0) * _22023.y);
	                        break;
	                    } while(false);
	                    _7934 = _12501;
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12502 = mix(_7934, _23727, _13136);
	            }
	            else
	            {
	                _12502 = _23727;
	            }
	            _19363 = _12502;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, saturate((distance(_11095.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m20) + PerViewLightingConstantBufferGpu_t._m19));
	        float _12503;
	        if (_24465.y)
	        {
	            _12503 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_11408.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12503 = _13279;
	        }
	        _21711 = _12503;
	    }
	    else
	    {
	        _21711 = 1.0;
	    }
	    vec3 _21712;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m12.xyz, _24735) * _21711) > 0.0)
	    {
	        _21712 = PerViewLightingConstantBufferGpu_t._m8.xyz + (vec3(max(0.0, dot(_24299.xyz, PerViewLightingConstantBufferGpu_t._m12.xyz))).xyz * (PerViewLightingConstantBufferGpu_t._m13.xyz * _21711).xyz);
	    }
	    else
	    {
	        _21712 = PerViewLightingConstantBufferGpu_t._m8.xyz;
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20061 = _24467.x;
	    vec4 _19364;
	    if (_20061)
	    {
	        vec4 _18621 = vec4(_11095.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m4;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m0.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m10.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m9.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m10.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m9.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m9.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m11.x, 0.0, PerViewLightingConstantBufferGpu_t._m11.y)) * PerViewLightingConstantBufferGpu_t._m9.z);
	    vec3 _13155;
	    _13155 = _21712;
	    uint _21567;
	    vec3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t._m9.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _16208] & g_CullBits_1._m0[_23393 + _16208]);
	        _13156 = _13155;
	        uint _20344;
	        vec3 _12505;
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
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_0.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21777 = _10521.z;
	                _22905.z = _21777;
	                vec3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7425 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12889;
	                if (!_7425)
	                {
	                    _12889 = true;
	                }
	                else
	                {
	                    _12889 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_0.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12889)
	                {
	                    _12505 = _13156;
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
	                    _21316 = smoothstep(0.0, 1.0, _21777 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21777) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
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
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23571 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11179 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24419 = !_20061;
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
	                        vec2 _22154 = abs(_22905.xy);
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
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20491.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20490.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _12505 = _13156;
	                    break;
	                }
	                vec3 _19630;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23715 = _21642;
	                        _23715.x = _6281.x;
	                        _23715.y = _6281.y;
	                        _19629 = _23715;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m15);
	                        vec2 _14615 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14615 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0)).xyzw, vec4(0.25));
	                        bool _12890;
	                        if (_15312 == 0.0)
	                        {
	                            _12890 = true;
	                        }
	                        else
	                        {
	                            _12890 = _15312 == 1.0;
	                        }
	                        if (_12890)
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
	                        _12505 = _13156;
	                        break;
	                    }
	                    _19630 = _19878;
	                }
	                else
	                {
	                    _19630 = _21548;
	                }
	                _12505 = _13156.xyz + (vec3(max(0.0, dot(_24299.xyz, _11179.xyz))).xyz * _19630.xyz);
	                break;
	            } while(false);
	            _13156 = _12505;
	            _16209 = _20344;
	            continue;
	        }
	        _21567 = _16208 + 1u;
	        _13155 = _13156;
	        _16208 = _21567;
	        continue;
	    }
	    vec3 _22686 = (_13155.xyz + (vec3(dot(PerViewLightingConstantBufferGpu_t._m4._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m4._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m4._m0[2].xyzw, _23875)).xyz * vec3(_21710).xyz).xyz) * ((_19414.xyz * _Globals_.g_vColorTint.xyz) * input_3.xyz).xyz;
	    float _12931 = _22686.x;
	    vec4 _11204 = vec4(_12931, _22686.yz, input_3.w);
	    _11204.x = _12931;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _10666 = _11095.xyz - PerViewConstantBuffer_t._m3.xyz;
	        vec3 _9057 = _10666.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _10666.xyz;
	            bool _12891;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m10.x)
	            {
	                _12891 = (_11095.z * PerViewConstantBufferCsgo_t._m10.z) < PerViewConstantBufferCsgo_t._m10.y;
	            }
	            else
	            {
	                _12891 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12891)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m7.xy + (PerViewConstantBufferCsgo_t._m7.zw * vec2(length(_21493), _11095.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m8.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m8.y)) * PerViewConstantBufferCsgo_t._m9.w;
	                _19340 = mix(_11204.xyz, vec4(PerViewConstantBufferCsgo_t._m9.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _11204.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _11204;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12892;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m14.x)
	            {
	                _12892 = (PerViewConstantBufferCsgo_t._m14.z * _11095.z) < PerViewConstantBufferCsgo_t._m14.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            if (_12892)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m11.y) + PerViewConstantBufferCsgo_t._m11.x), PerViewConstantBufferCsgo_t._m11.w)) * saturate(pow(max(0.0, (_11095.z * PerViewConstantBufferCsgo_t._m12.y) + PerViewConstantBufferCsgo_t._m12.x), PerViewConstantBufferCsgo_t._m12.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m14.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m13 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m12.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m11.z))) * PerViewConstantBufferCsgo_t._m15.x).xyz, _8892).xyz, vec3(_8892));
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
	        _6805 = _11204;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(SupportsLightmapping, F_UNLIT ? 0 : 1);
	BoolAttribute(PerVertexLighting, F_UNLIT ? 0 : 1);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(translucent, F_TRANSLUCENT ? 1 : 0);
	BoolAttribute(alphatest, F_ALPHA_TEST ? 1 : 0);
	BoolAttribute(overlay, F_OVERLAY ? 1 : 0);
	BoolAttribute(DoubleSided, F_RENDER_BACKFACES ? 1 : 0);
	
	#if (S_UNLIT == 1)
		BoolAttribute(unlit, true);
	#endif
	#if (S_UNLIT == 0)
		BoolAttribute(NeedsLightProbe, true);
	#endif
	#if (S_SELF_ILLUM == 1)
		BoolAttribute(NeedsLightProbe, true);
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SPECULAR == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
		BoolAttribute(NeedsLightProbe, true);
	#endif
	#if (S_SPECULAR == 0)
		BoolAttribute(NeedsLightProbe, true);
	#endif
	#if (S_SELF_ILLUM == 0)
		BoolAttribute(NeedsLightProbe, true);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(BlendEnable, F_TRANSLUCENT ? true : false);
	RenderState(BlendEnable0, true);
	RenderState(BlendEnable1, true);
	RenderState(BlendEnable2, true);
	RenderState(ColorWriteEnable0, R|G|B);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, -64);
	RenderState(DepthBiasClamp, 0);
	RenderState(DepthWriteEnable, F_TRANSLUCENT ? false : true);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(DstBlend0, One);
	RenderState(DstBlend1, One);
	RenderState(DstBlend2, One);
	RenderState(DstBlendAlpha0, One);
	RenderState(DstBlendAlpha1, One);
	RenderState(DstBlendAlpha2, One);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(SrcBlend0, One);
	RenderState(SrcBlend1, One);
	RenderState(SrcBlend2, One);
	RenderState(SrcBlendAlpha0, One);
	RenderState(SrcBlendAlpha1, One);
	RenderState(SrcBlendAlpha2, One);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
}
