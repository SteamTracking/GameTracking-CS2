//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "s2 version of lightmapped_4wayblend shader for csgo.";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	Depth("csgo_depth_only.vfx");
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_SPECULAR_DIRECT, 0..1, "Direct/Per-Pixel Specular - S1 $phong" );
	Feature( F_SPECULAR_INDIRECT, 0..1, "Indirect/Cubemap Specular - S1 $envmap" );
	Feature( F_DETAILTEXTURE, 0..1, "" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_SPECULAR_DIRECT, F_SPECULAR_INDIRECT ), "Direct specular requires indirect (we'd prefer to avoid having only direct specular)" );
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
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;   
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
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
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	
	// Detail
	float2 g_vDetailScale < Default2(4, 4); UiType(VectorText); UiGroup("Detail,30 / Scale,70 / 20"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vColorTint) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
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
	
	float _3;
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _1224
	{
	    mat4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _1224 PerViewConstantBuffer_t;
	
	struct _1022
	{
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1022 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec4 vColorBlendValues;
	layout(location = 1) in vec3 vPositionOs;
	layout(location = 2) in vec2 vTexCoord;
	layout(location = 3) in vec3 vNormalOs;
	layout(location = 4) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 5) in uvec4 vBlendIndices;
	layout(location = 6) in uint nInstanceIdx;
	layout(location = 0) out vec4 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) centroid out vec4 output_4;
	layout(location = 5) out vec4 output_5;
	layout(location = 6) flat out uint output_6;
	
	void main()
	{
	    uint _13771 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5 >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    }
	    vec3 _21709;
	    if (_13771 > 0u)
	    {
	        _21709 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].z);
	    }
	    else
	    {
	        _21709 = vec3(1.0);
	    }
	    vec4 _23812 = vec4(uvec4(g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 255u, (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 65280u) >> uint(8), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 16711680u) >> uint(16), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec3 _6253 = _23812.xyz;
	    vec3 _17828 = _6253 * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((_6253 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _17895 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = vColorBlendValues;
	    output_1 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    output_3 = vec4(vTexCoord.xyxy);
	    output_4 = vec4(vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _23812.w).xyz, vec3(_Globals_.g_flModelTintAmount)), _3).xyz * _Globals_.g_vColorTint.xyz, 1.0);
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_6 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	BoolAttribute(VertexPaintUI4Layer, true);
	BoolAttribute(VertexPaintUIPickColor, true);
	
	
	// Variant Attributes
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SPECULAR_INDIRECT, S_MODE_TOOLS_VIS ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
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
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCubeArray g_tFallbackCubemap < Attribute("LowShaderQualityFallbackCubemap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture2D g_tLayer1AmbientOcclusion < Channel(R, Box3(TextureLayer1AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer1NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer1Normal, TextureLayer1Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2AmbientOcclusion < Channel(R, Box3(TextureLayer2AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer2Color < Channel(RGB, ArtistDefined(TextureLayer2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tLayer2NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer2Normal, TextureLayer2Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer3AmbientOcclusion < Channel(R, Box3(TextureLayer3AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer3Color < Channel(RGB, ArtistDefined(TextureLayer3Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tLayer3NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer3Normal, TextureLayer3Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer4AmbientOcclusion < Channel(R, Box3(TextureLayer4AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer4Color < Channel(RGB, ArtistDefined(TextureLayer4Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tLayer4NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer4Normal, TextureLayer4Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap3 < Attribute("debug_chart_color"); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Detail
	CreateInputTexture2D(TextureDetail, Linear, 8, "Mod2XCenter", "_detail", "Detail,10 / Texture,70 / 10", Default4(1, 1, 1, 1));
	float4 g_vDetailBlendFactors < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("Detail,40 / 4-Way Blend,70 / 30"); >;
	
	// PBR 1
	CreateInputTexture2D(TextureLayer1AmbientOcclusion, Linear, 8, "", "_ao", "PBR 1,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer1Color, Srgb, 8, "", "_color", "PBR 1,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 1,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer1Roughness, Linear, 8, "Inverse", "_rough", "PBR 1,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	
	// PBR 2
	CreateInputTexture2D(TextureLayer2AmbientOcclusion, Linear, 8, "", "_ao", "PBR 2,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer2Color, Srgb, 8, "", "_color", "PBR 2,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer2Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 2,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer2Roughness, Linear, 8, "Inverse", "_rough", "PBR 2,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	
	// PBR 3
	CreateInputTexture2D(TextureLayer3AmbientOcclusion, Linear, 8, "", "_ao", "PBR 3,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer3Color, Srgb, 8, "", "_color", "PBR 3,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer3Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 3,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer3Roughness, Linear, 8, "Inverse", "_rough", "PBR 3,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	
	// PBR 4
	CreateInputTexture2D(TextureLayer4AmbientOcclusion, Linear, 8, "", "_ao", "PBR 4,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer4Color, Srgb, 8, "", "_color", "PBR 4,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer4Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 4,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer4Roughness, Linear, 8, "Inverse", "_rough", "PBR 4,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	// 4-Way Blend
	float4 g_vBlendEnd < Default4(1, 1, 1, 1); Range(0, 0); UiType(VectorText); UiGroup("4-Way Blend,40 / BlendEnd,70 / 30"); >;
	float4 g_vBlendStart < Default4(1, 1, 1, 1); Range(0, 0); UiType(VectorText); UiGroup("4-Way Blend,30 / BlendStart,70 / 30"); >;
	float4 g_vLumBlends < Default4(1, 1, 1, 1); Range(0, 0); UiType(VectorText); UiGroup("4-Way Blend,70 / LumBlend,70 / 30"); >;
	float4 g_vLumEnd < Default4(1, 1, 1, 1); Range(0, 0); UiType(VectorText); UiGroup("4-Way Blend,60 / LumEnd,70 / 30"); >;
	float4 g_vLumStart < Default4(1, 1, 1, 1); Range(0, 0); UiType(VectorText); UiGroup("4-Way Blend,50 / LumStart,70 / 30"); >;
	float4 g_vUVScale < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("4-Way Blend,10 / UV Scale,70 / 30"); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vUVScale) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _1654
	{
	    vec4 _m0[3];
	};
	
	struct _1864
	{
	    vec4 _m0[4];
	};
	
	struct _2767
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
	
	vec3 _3;
	vec4 _4;
	
	struct _2325
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    mat4 _m3;
	    vec2 _m4;
	    float _m5;
	    vec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	    mat4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	};
	
	layout(set = 1) uniform _2325 PerViewConstantBufferCsgo_t;
	
	struct _1574
	{
	    vec4 g_vUVScale;
	    vec4 g_vBlendStart;
	    vec4 g_vBlendEnd;
	    vec4 g_vLumStart;
	    vec4 g_vLumEnd;
	    vec4 g_vLumBlends;
	    int g_bFogEnabled;
	};
	
	layout(set = 1) uniform _1574 _Globals_;
	
	struct _1920
	{
	    _1654 _m0;
	    _1864 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uvec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    int _m10;
	    float _m11;
	    vec4 _m12;
	    float _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	    _2767 _m17;
	    _1864 _m18;
	};
	
	layout(set = 3) uniform _1920 PerViewLightingConstantBufferGpu_t;
	
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
	
	layout(set = 1, binding = 43) uniform texture2D g_tColor;
	layout(set = 1, binding = 19) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 46) uniform texture2D g_tLayer2Color;
	layout(set = 1, binding = 49) uniform texture2D g_tLayer3Color;
	layout(set = 1, binding = 52) uniform texture2D g_tLayer4Color;
	layout(set = 1, binding = 45) uniform texture2D g_tLayer1AmbientOcclusion;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 48) uniform texture2D g_tLayer2AmbientOcclusion;
	layout(set = 1, binding = 51) uniform texture2D g_tLayer3AmbientOcclusion;
	layout(set = 1, binding = 54) uniform texture2D g_tLayer4AmbientOcclusion;
	layout(set = 1, binding = 44) uniform texture2D g_tLayer1NormalRoughness;
	layout(set = 1, binding = 47) uniform texture2D g_tLayer2NormalRoughness;
	layout(set = 1, binding = 50) uniform texture2D g_tLayer3NormalRoughness;
	layout(set = 1, binding = 53) uniform texture2D g_tLayer4NormalRoughness;
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 22) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 18) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 23) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 61) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 0) in vec4 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec4 input_3;
	layout(location = 4) centroid in vec4 input_4;
	layout(location = 5) in vec4 input_5;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
	    vec3 _9451 = normalize(input_2.xyz);
	    vec3 _11095 = input_1 + PerViewConstantBufferCsgo_t._m15.xyz;
	    vec4 _19680 = texture(sampler2D(g_tColor, g_sUserConfig), input_3.xy);
	    vec2 _8896 = (input_3.xy * _Globals_.g_vUVScale.y).xy;
	    vec4 _19681 = texture(sampler2D(g_tLayer2Color, g_sUserConfig), _8896);
	    vec2 _8897 = (input_3.xy * _Globals_.g_vUVScale.z).xy;
	    vec4 _19682 = texture(sampler2D(g_tLayer3Color, g_sUserConfig), _8897);
	    vec2 _8898 = (input_3.xy * _Globals_.g_vUVScale.w).xy;
	    vec4 _19338 = texture(sampler2D(g_tLayer4Color, g_sUserConfig), _8898);
	    vec4 _19339 = texture(sampler2D(g_tLayer1AmbientOcclusion, g_sTrilinearWrap), input_3.xy);
	    vec4 _19340 = texture(sampler2D(g_tLayer2AmbientOcclusion, g_sTrilinearWrap), _8896);
	    vec4 _19341 = texture(sampler2D(g_tLayer3AmbientOcclusion, g_sTrilinearWrap), _8897);
	    vec4 _19342 = texture(sampler2D(g_tLayer4AmbientOcclusion, g_sTrilinearWrap), _8898);
	    float _20131 = smoothstep(_Globals_.g_vLumStart.x, _Globals_.g_vLumEnd.x, dot(_19680.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	    float _20132 = smoothstep(_Globals_.g_vLumStart.y, _Globals_.g_vLumEnd.y, dot(_19681.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	    float _20133 = smoothstep(_Globals_.g_vLumStart.z, _Globals_.g_vLumEnd.z, dot(_19682.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)));
	    float _23082 = smoothstep(_Globals_.g_vBlendStart.y, _Globals_.g_vBlendEnd.y, (input_0.y * mix(1.0 - _20131, _20132, _Globals_.g_vLumBlends.y)) + input_0.y);
	    float _7030 = mix(_20131, _20132, _23082);
	    float _7227 = smoothstep(_Globals_.g_vBlendStart.z, _Globals_.g_vBlendEnd.z, (input_0.z * mix(1.0 - _7030, _20133, _Globals_.g_vLumBlends.z)) + input_0.z);
	    vec4 _11431 = vec4(_23082);
	    vec4 _14169 = vec4(_7227);
	    vec4 _15176 = vec4(smoothstep(_Globals_.g_vBlendStart.w, _Globals_.g_vBlendEnd.w, (input_0.w * mix(1.0 - mix(_7030, _20133, _7227), smoothstep(_Globals_.g_vLumStart.w, _Globals_.g_vLumEnd.w, dot(_19338.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _Globals_.g_vLumBlends.w)) + input_0.w));
	    vec4 _19777 = mix(mix(mix(texture(sampler2D(g_tLayer1NormalRoughness, g_sUserConfig), input_3.xy).xyzw, texture(sampler2D(g_tLayer2NormalRoughness, g_sUserConfig), _8896).xyzw, _11431), texture(sampler2D(g_tLayer3NormalRoughness, g_sUserConfig), _8897).xyzw, _14169), texture(sampler2D(g_tLayer4NormalRoughness, g_sUserConfig), _8898).xyzw, _15176);
	    float _22845 = _19777.x;
	    float _18662 = _19777.y;
	    float _16783 = (_22845 + _18662) - 1.00392162799835205078125;
	    float _11176 = _22845 - _18662;
	    vec3 _14854 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    vec3 _12969 = input_2.xyz * 1.0;
	    vec3 _14435 = cross(_12969.xyz, input_5.xyz) * ((input_5.w > 0.0) ? 1.0 : (-1.0));
	    vec3 _20195;
	    if (notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0)).w)
	    {
	        _20195 = -_14435;
	    }
	    else
	    {
	        _20195 = _14435;
	    }
	    vec3 _14995 = normalize((((input_5.xyz * _14854.x).xyz + (_20195.xyz * (-_14854.y))).xyz + (_12969.xyz * _14854.z)).xyz);
	    vec3 _23854 = -_9451;
	    vec3 _24735 = _14995.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21709;
	    if (_24465.x)
	    {
	        vec3 _11394 = _9451.xyz;
	        vec2 _10547 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m5) * PerViewConstantBufferCsgo_t._m4.xy) + (PerViewConstantBufferCsgo_t._m4.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10547).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m4.x, 0.0);
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
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m4.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m2.x * fma(dot(_23854, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.y * fma(dot(_23854, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.z * fma(dot(_23854, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.w * fma(dot(_23854, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21709 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10547 + mix(_23169, PerViewConstantBufferCsgo_t._m4.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21709 = 1.0;
	    }
	    float _21710;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m10 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m10))
	            {
	                _13136 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_1.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m17._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m12[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m14)) + vec2(PerViewLightingConstantBufferGpu_t._m13));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m18._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m18._m0[_13039].xy;
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
	            float _18270 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m11)), 0.0);
	            float _12501;
	            SPIRV_CROSS_BRANCH
	            if (_13136 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m10 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_1.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m17._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m18._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m18._m0[_15335].xy;
	                    vec3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m11)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12501 = mix(_7934, _18270, _13136);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _19363 = _12501;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, saturate((distance(_11095.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m16) + PerViewLightingConstantBufferGpu_t._m15));
	        float _12502;
	        if (_24465.y)
	        {
	            _12502 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_11408.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21710 = _12502;
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    vec3 _21711;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m8.xyz, _24735) * _21710) > 0.0)
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t._m4.xyz + (vec3(max(0.0, dot(_14995.xyz, PerViewLightingConstantBufferGpu_t._m8.xyz))).xyz * (PerViewLightingConstantBufferGpu_t._m9.xyz * _21710).xyz);
	    }
	    else
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24466 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20060 = _24466.x;
	    vec4 _19364;
	    if (_20060)
	    {
	        vec4 _18621 = vec4(_11095.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m3;
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
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m0.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13155;
	    _13155 = _21711;
	    uint _21567;
	    vec3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _16208] & g_CullBits_1._m0[_23393 + _16208]);
	        _13156 = _13155;
	        uint _20344;
	        vec3 _12504;
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
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_1.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7424 = all(lessThan(_22905.xyz, vec3(1.0)));
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
	                    _12885 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_1.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12885)
	                {
	                    _12504 = _13156;
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
	                    _21316 = min(1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_1.xyz;
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
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * saturate(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23571 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
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
	                    _24419 = !_20060;
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
	                    vec3 _12503;
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
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20491.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20490.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _12504 = _13156;
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m11)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _12504 = _13156;
	                        break;
	                    }
	                    _19630 = _20482;
	                }
	                else
	                {
	                    _19630 = _21548;
	                }
	                _12504 = _13156.xyz + (vec3(max(0.0, dot(_14995.xyz, _11179.xyz))).xyz * _19630.xyz);
	                break;
	            } while(false);
	            _13156 = _12504;
	            _16209 = _20344;
	            continue;
	        }
	        _21567 = _16208 + 1u;
	        _13155 = _13156;
	        _16208 = _21567;
	        continue;
	    }
	    vec3 _22686 = (_13155.xyz + (vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz * vec3(_21709 * mix(mix(mix(_19339.xyzw, _19340.xyzw, _11431), _19341.xyzw, _14169), _19342.xyzw, _15176).x).xyz).xyz) * (vec3((mix(mix(mix(_19680.xyzw, _19681.xyzw, _11431), _19682.xyzw, _14169), _19338.xyzw, _15176) * input_4).xyz).xyz * 1.0).xyz;
	    vec4 _11203 = vec4(_22686, input_4.w);
	    _11203.x = _22686.x;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _10666 = _11095.xyz - PerViewConstantBuffer_t._m3.xyz;
	        vec3 _9057 = _10666.xyz;
	        vec3 _19346;
	        do
	        {
	            _21493 = _10666.xyz;
	            bool _12886;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m9.x)
	            {
	                _12886 = (_11095.z * PerViewConstantBufferCsgo_t._m9.z) < PerViewConstantBufferCsgo_t._m9.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12886)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m6.xy + (PerViewConstantBufferCsgo_t._m6.zw * vec2(length(_21493), _11095.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m7.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m7.y)) * PerViewConstantBufferCsgo_t._m8.w;
	                _19346 = mix(_11203.xyz, vec4(PerViewConstantBufferCsgo_t._m8.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19346 = _11203.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _11203;
	        _23944.x = _19346.x;
	        _23944.y = _19346.y;
	        _23944.z = _19346.z;
	        vec3 _19347;
	        do
	        {
	            bool _12887;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m13.x)
	            {
	                _12887 = (PerViewConstantBufferCsgo_t._m13.z * _11095.z) < PerViewConstantBufferCsgo_t._m13.y;
	            }
	            else
	            {
	                _12887 = false;
	            }
	            if (_12887)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m10.y) + PerViewConstantBufferCsgo_t._m10.x), PerViewConstantBufferCsgo_t._m10.w)) * saturate(pow(max(0.0, (_11095.z * PerViewConstantBufferCsgo_t._m11.y) + PerViewConstantBufferCsgo_t._m11.x), PerViewConstantBufferCsgo_t._m11.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m13.w;
	                _19347 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m12 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m11.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m10.z))) * PerViewConstantBufferCsgo_t._m14.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19347 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19347.x;
	        _23944.y = _19347.y;
	        _23944.z = _19347.z;
	        _6805 = _23944;
	    }
	    else
	    {
	        _6805 = _11203;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	
	// Variant Attributes
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
}
