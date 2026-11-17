//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "3 layer parallax shader";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs, psrs
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
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_METALNESS_TEXTURE, 0..1, "PBR" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	Feature( F_SECONDARY_UV, 0..1, "Secondary UVs" );
	Feature( F_TRANSMISSIVE_BACKFACE_NDOTL, 0..1, "Transmissive Mask" );
	Feature( F_SECOND_LAYER_CUBEMAP, 0..1, "Layer 2 Cubemap" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
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
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_SECONDARY_UV=1
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
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
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = 0*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*float2(1,1).x,-v2*float2(1,1).y,0,float2(.5,.5).x+float2(0,0).x+v2*float2(.5,.5).y-v1*float2(.5,.5).x)); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = 0*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*float2(1,1).x,v1*float2(1,1).y,0,float2(.5,.5).y+float2(0,0).y-(v2*float2(.5,.5).x+v1*float2(.5,.5).y))); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 3 (name: g_vColorTint) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _1260
	{
	    mat4 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _1260 PerViewConstantBuffer_t;
	
	struct _1204
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	};
	
	layout(set = 0) uniform _1204 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 4) in uvec4 vBlendIndices;
	layout(location = 5) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) centroid out vec4 output_3;
	layout(location = 4) centroid out vec3 output_4;
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
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9360 = vTexCoord.xyxy;
	    _9360.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _9360.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _9360;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec4 _11150 = vec4(_21354, _21355, _17978, _23812.w * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _13062 = _11150.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11150;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _11179;
	    output_2 = _20488;
	    output_3 = _23714;
	    output_4 = _11179;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_6 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, true);
	
}

PS
{
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_TRANSMISSIVE_BACKFACE_NDOTL, F_TRANSMISSIVE_BACKFACE_NDOTL );
	StaticCombo( S_SECOND_LAYER_CUBEMAP, F_SECOND_LAYER_CUBEMAP );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
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
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, ArtistDefined(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayer0Mask < Channel(R, ArtistDefined(TextureLayer0Mask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer1Color < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); Channel(A, Box(TextureLayer1Mask), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayer2Color < Channel(RGB, ArtistDefined(TextureLayer2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	TextureCube g_tLayer2Cubemap < Channel(RGB, Box(TextureCubeMap), Srgb); OutputFormat(BC6H); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tTransmissiveMask < Channel(R, ArtistDefined(TextureTransmissiveMask), Srgb); OutputFormat(ATI1N); SrgbRead(true); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	bool g_bUseSecondaryUvForAmbientOcclusion < Default(1); UiType(CheckBox); UiGroup("Ambient Occlusion, 100"); >;
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Layer 2
	CreateInputTexture2D(TextureLayer2Color, Srgb, 8, "", "_color", "Layer 2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureCubeMap, Srgb, 8, "", "_cube", "Layer 2/2", Default4(0, 0, 0, 0));
	float3 g_vLayer2EmissiveTint < Default3(1, 1, 1); UiType(Color); UiGroup("Layer 2/2"); >;
	float g_flLayer2EmissiveLevel < Range(0, 20); UiType(Slider); UiGroup("Layer 2/3"); >;
	float g_flLayer2EmissiveFresnel < Range(0, 5); UiType(Slider); UiGroup("Layer 2/4"); >;
	float g_flLayer2RefractionAmount < UiType(Slider); UiGroup("Layer 2/4"); >;
	float g_flLayer2RoughnessBlurMin < Range(0, 30); UiType(Slider); UiGroup("Layer 2/5"); >;
	float g_flLayer2RoughnessBlurMax < Range(0, 30); UiType(Slider); UiGroup("Layer 2/6"); >;
	float g_flLayer2Offset < Range(-2000, 2000); UiType(Slider); UiGroup("Layer 2/7"); Expression(this/1024); >;
	bool g_bUseSecondaryUvForLayer2 < Default(1); UiType(CheckBox); UiGroup("Layer 2/8"); >;
	
	// Layer 0
	CreateInputTexture2D(TextureLayer0Mask, Linear, 8, "", "_mask", "Layer 0", Default4(1, 1, 1, 0));
	
	// Layer 1
	CreateInputTexture2D(TextureLayer1Color, Srgb, 8, "", "_color", "Layer 1/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer1Mask, Linear, 8, "", "_mask", "Layer 1/2", Default4(1, 1, 1, 0));
	float3 g_vLayer1EmissiveTint < Default3(1, 1, 1); UiType(Color); UiGroup("Layer 1/3"); >;
	float g_flLayer1EmissiveLevel < Range(0, 20); UiType(Slider); UiGroup("Layer 1/4"); >;
	float g_flLayer1RefractionAmount < UiType(Slider); UiGroup("Layer 1/5"); >;
	float g_flLayer1RoughnessBlurMin < Range(0, 30); UiType(Slider); UiGroup("Layer 1/6"); >;
	float g_flLayer1RoughnessBlurMax < Range(0, 30); UiType(Slider); UiGroup("Layer 1/7"); >;
	float g_flLayer1Offset < Range(-2000, 2000); UiType(Slider); UiGroup("Layer 1/8"); Expression(this/1024); >;
	bool g_bUseSecondaryUvForLayer1 < UiType(CheckBox); UiGroup("Layer 1/9"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Transmission
	CreateInputTexture2D(TextureTransmissiveMask, Srgb, 8, "", "_mask", "Transmission,10/1", Default4(1, 1, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_METALNESS_TEXTURE == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, ArtistDefined(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_vLayer1EmissiveTint) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _2998
	{
	    vec4 _m0[3];
	};
	
	struct _197
	{
	    vec4 _m0[4];
	};
	
	struct _2697
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
	
	struct _306
	{
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    uint g_sUserConfig;
	    uint g_sUserConfigAllowGlobalMipBias;
	    vec3 g_vLayer1EmissiveTint;
	    float g_flLayer1EmissiveLevel;
	    float g_flLayer1RefractionAmount;
	    float g_flLayer1RoughnessBlurMin;
	    float g_flLayer1RoughnessBlurMax;
	    float g_flLayer1Offset;
	    vec3 g_vLayer2EmissiveTint;
	    float g_flLayer2EmissiveLevel;
	    float g_flLayer2EmissiveFresnel;
	    float g_flLayer2RefractionAmount;
	    float g_flLayer2RoughnessBlurMin;
	    float g_flLayer2RoughnessBlurMax;
	    float g_flLayer2Offset;
	    uint g_tColor;
	    uint g_tLayer0Mask;
	    uint g_tLayer1Color;
	    uint g_tLayer2Color;
	    uint g_sCookieSampler;
	    uint g_tShadowDepthBufferCmpSampler;
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    uint g_tNormal;
	    uint g_tAmbientOcclusion;
	    float g_flMetalness;
	};
	
	layout(set = 1) uniform _306 _Globals_;
	
	struct _2219
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    uint _m8;
	    uint _m9;
	    mat4 _m10;
	    vec2 _m11;
	    float _m12;
	    vec4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    mat4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    vec4 _m22;
	};
	
	layout(set = 1) uniform _2219 PerViewConstantBufferCsgo_t;
	
	struct _1194
	{
	    vec2 _m0;
	    vec2 _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 1) uniform _1194 PerViewConstantBuffer_t;
	
	struct _990
	{
	    uint _m0;
	    uint _m1;
	};
	
	layout(set = 1) uniform _990 FireConstantBufferCsgo_t;
	
	struct _1373
	{
	    _2998 _m0;
	    _197 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uvec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    int _m11;
	    float _m12;
	    vec4 _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	    float _m17;
	    _2697 _m18;
	    _197 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _1373 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(set = 4, binding = 29) uniform samplerShadow g_bindless_Sampler_1[2048];
	layout(set = 4, binding = 46) uniform texture3D g_bindless_Texture3D_float4[65536];
	layout(set = 4, binding = 46) uniform textureCubeArray g_bindless_TextureCubeArray_float4[65536];
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube_float4[65536];
	
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
	    _11408.w = 1.0 / _11408.w;
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
	    vec3 _10061 = input_0 + PerViewConstantBufferCsgo_t._m22.xyz;
	    vec3 _23752 = normalize(_10061 - PerViewConstantBuffer_t._m3);
	    float _7281 = 1.0 / dot(_23752, input_1);
	    float _23826 = saturate(dot(-_23752, input_1));
	    float _21819 = saturate(pow(_23826, 0.699999988079071044921875));
	    float _22035 = (input_5.w > 0.0) ? 1.0 : (-1.0);
	    vec2 _6744 = vec2(dot(_23752, input_5.xyz), dot(_23752, cross(input_1.xyz, input_5.xyz) * _22035));
	    vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal], g_bindless_Sampler[_Globals_.g_sUserConfig]), input_2.xy);
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
	    vec3 _9739 = input_1.xyz * (_24327 ? (-1.0) : 1.0);
	    vec3 _14435 = cross(_9739.xyz, input_5.xyz) * _22035;
	    vec3 _7424;
	    if (notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0)).w)
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
	    vec3 _13532 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_9739.xyz * _20480.z)).xyz);
	    vec2 _24081 = _18354.xy;
	    float _12540 = _19372.z;
	    vec4 _21760 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor], g_bindless_Sampler[_Globals_.g_sUserConfigAllowGlobalMipBias]), input_2.xy);
	    vec4 _21761 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tLayer1Color], g_bindless_Sampler[_Globals_.g_sUserConfig]), ((_24081 * _Globals_.g_flLayer1RefractionAmount) + (input_2.xy + (_6744 * ((_Globals_.g_flLayer1Offset * _21819) * _7281)))).xy, mix(_Globals_.g_flLayer1RoughnessBlurMin, _Globals_.g_flLayer1RoughnessBlurMax, _12540));
	    vec4 _19373 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tLayer0Mask], g_bindless_Sampler[_Globals_.g_sUserConfig]), input_2.xy);
	    float _15050 = _19373.x;
	    vec3 _19877 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tLayer2Color], g_bindless_Sampler[_Globals_.g_sUserConfig]), ((_24081 * _Globals_.g_flLayer2RefractionAmount) + (input_2.xy + (_6744 * ((_Globals_.g_flLayer2Offset * _21819) * _7281)))).xy, mix(_Globals_.g_flLayer2RoughnessBlurMin, _Globals_.g_flLayer2RoughnessBlurMax, _12540)).xyz;
	    vec3 _6342 = _21761.xyz;
	    vec3 _21153 = vec3(_21761.w);
	    vec3 _23491 = mix(mix(_19877, _6342, _21153), _21760.xyz, vec3(_15050)).xyz * input_3.xyz;
	    vec4 _19068 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tAmbientOcclusion], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), input_2.xy);
	    float _10825 = _Globals_.g_flMetalness * _15050;
	    vec3 _23501 = _10061.xyz;
	    vec3 _24272 = dFdx(_23501);
	    vec3 _9944 = dFdy(_23501);
	    bool _12428 = (FireConstantBufferCsgo_t._m1 & 2u) != 0u;
	    vec3 _13138;
	    vec2 _13153;
	    float _24595;
	    SPIRV_CROSS_BRANCH
	    if (_12428)
	    {
	        bool _12887;
	        if (FireConstantBufferCsgo_t._m0 > 0u)
	        {
	            _12887 = true;
	        }
	        else
	        {
	            _12887 = (FireConstantBufferCsgo_t._m1 & 1u) != 0u;
	        }
	        float _6569;
	        float _13136;
	        float _13151;
	        SPIRV_CROSS_BRANCH
	        if (_12887)
	        {
	            vec4 _11180 = textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m9], g_bindless_Sampler[_Globals_.g_sPointClamp]), (_11408.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0);
	            _13136 = _11180.x;
	            _13151 = _11180.y;
	            _6569 = _11180.w;
	        }
	        else
	        {
	            _13136 = 0.0;
	            _13151 = 0.0;
	            _6569 = 0.0;
	        }
	        bool _17653 = _13136 > 0.0;
	        bool _12888;
	        if (_17653)
	        {
	            _12888 = true;
	        }
	        else
	        {
	            _12888 = _13151 > 0.0;
	        }
	        bool _12889;
	        if (_12888)
	        {
	            _12889 = true;
	        }
	        else
	        {
	            _12889 = _6569 > 0.0;
	        }
	        vec4 _20309;
	        SPIRV_CROSS_BRANCH
	        if (_12889)
	        {
	            vec3 _14004 = pow(abs(_24347.xyz), vec3(8.0));
	            vec3 _11969 = _14004 / vec3(dot(_14004, vec3(1.0)));
	            vec3 _18011 = _11969 * step(vec3(0.1500000059604644775390625), _11969);
	            vec3 _7622 = _18011 / vec3(max(dot(_18011, vec3(1.0)), 9.9999997473787516355514526367188e-05));
	            float _13822 = _7622.z;
	            vec4 _21316;
	            SPIRV_CROSS_BRANCH
	            if (_13822 > 0.0)
	            {
	                float _10504 = radians(37.0);
	                float _17093 = cos(_10504);
	                float _6434 = sin(_10504);
	                mat2 _15707 = mat2(vec2(_17093, -_6434) * vec2(0.0078125), vec2(_6434, _17093) * vec2(0.0078125));
	                _21316 = textureGrad(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _10061.xy * _15707, _24272.xy * _15707, _9944.xy * _15707) * _13822;
	            }
	            else
	            {
	                _21316 = vec4(0.0);
	            }
	            float _10004 = _7622.x;
	            vec4 _21317;
	            SPIRV_CROSS_BRANCH
	            if (_10004 > 0.0)
	            {
	                float _10505 = radians(37.0);
	                float _17094 = cos(_10505);
	                float _6435 = sin(_10505);
	                mat2 _15708 = mat2(vec2(_17094, -_6435) * vec2(0.0078125), vec2(_6435, _17094) * vec2(0.0078125));
	                _21317 = _21316 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _10061.yz * _15708, _24272.yz * _15708, _9944.yz * _15708) * _10004);
	            }
	            else
	            {
	                _21317 = _21316;
	            }
	            float _10005 = _7622.y;
	            vec4 _12501;
	            SPIRV_CROSS_BRANCH
	            if (_10005 > 0.0)
	            {
	                float _10506 = radians(37.0);
	                float _17095 = cos(_10506);
	                float _6437 = sin(_10506);
	                mat2 _15709 = mat2(vec2(_17095, -_6437) * vec2(0.0078125), vec2(_6437, _17095) * vec2(0.0078125));
	                _12501 = _21317 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _10061.xz * _15709, _24272.xz * _15709, _9944.xz * _15709) * _10005);
	            }
	            else
	            {
	                _12501 = _21317;
	            }
	            _20309 = _12501;
	        }
	        else
	        {
	            _20309 = vec4(0.5);
	        }
	        float _24199 = saturate(_6569 * mix(1.0, _20309.x * 2.0, 0.17499999701976776123046875));
	        float _16385 = 1.0 - _10825;
	        vec3 _21101 = (_23491.xyz * mix(1.0, 0.64999997615814208984375, _24199 * mix(0.300000011920928955078125, 1.0, saturate(_12540 * 2.0) * _16385))).xyz * mix(vec3(1.0), vec3(0.75, 0.62000000476837158203125, 0.2800000011920928955078125), vec3(_24199 * 0.5));
	        vec3 _13137;
	        float _13152;
	        vec2 _22371;
	        SPIRV_CROSS_BRANCH
	        if (_17653 ? _12428 : false)
	        {
	            float _16981 = _13136 * 2.0;
	            float _13023 = saturate(_16981);
	            float _10371 = (_20309.x - 0.5) * 0.699999988079071044921875;
	            float _20671 = saturate(_13023 + (_10371 * saturate(_13023 * 4.0)));
	            float _24490 = mix(0.60000002384185791015625, 1.0, smoothstep(0.4000000059604644775390625, 0.800000011920928955078125, _24347.z));
	            float _20739 = (saturate((_20671 * 1.60000002384185791015625) - 0.4000000059604644775390625) * _24490) * mix(1.0, 0.800000011920928955078125, _10825);
	            vec3 _14201 = _21101.xyz;
	            vec3 _15381 = (_14201 * mix(vec3(1.0), vec3(0.800000011920928955078125, 0.699999988079071044921875, 0.5), vec3((((smoothstep(0.0, 0.25, _20671) * saturate(dot(_14201, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) * 2.0)) * _16385) * 0.4000000059604644775390625) * _24490))).xyz;
	            float _7286 = saturate(saturate(_13023 + (_10371 * _13023)) * 1.2000000476837158203125) * 7.0;
	            vec2 _24755 = _19372.zz;
	            _13137 = (mix(_15381, _15381 * mix(mix(mix(mix(mix(mix(mix(vec3(1.0), vec3(1.0, 0.85000002384185791015625, 0.550000011920928955078125), vec3(saturate(_7286))), vec3(0.89999997615814208984375, 0.60000002384185791015625, 0.25), vec3(saturate(_7286 - 1.0))), vec3(0.64999997615814208984375, 0.3499999940395355224609375, 0.20000000298023223876953125), vec3(saturate(_7286 - 2.0))), vec3(0.5, 0.20000000298023223876953125, 0.5), vec3(saturate(_7286 - 3.0))), vec3(0.20000000298023223876953125, 0.300000011920928955078125, 0.75), vec3(saturate(_7286 - 4.0))), vec3(0.449999988079071044921875, 0.60000002384185791015625, 0.800000011920928955078125), vec3(saturate(_7286 - 5.0))), vec3(0.60000002384185791015625, 0.62000000476837158203125, 0.64999997615814208984375), vec3(saturate(_7286 - 6.0))), vec3(_10825 * 0.4000000059604644775390625)).xyz * mix(1.0, 0.60000002384185791015625 * mix(1.0, _20309.z * 2.0, 0.5), _20739)).xyz * mix(1.0, 0.20000000298023223876953125, saturate(_16981 - 1.0) * _20739);
	            _13152 = _10825 * mix(1.0, 0.89999997615814208984375, _20739);
	            _22371 = mix(_24755, max(_24755, vec2(0.85000002384185791015625)), vec2(_20739 * 0.25));
	        }
	        else
	        {
	            _13137 = _21101;
	            _13152 = _10825;
	            _22371 = _12835;
	        }
	        _13138 = _13137;
	        _13153 = mix(_22371.xy, min(_22371.xy, vec2(0.0500000007450580596923828125)), vec2(saturate(_6569 * 0.89999997615814208984375)));
	        _24595 = _13152;
	    }
	    else
	    {
	        _13138 = _23491;
	        _13153 = _12835;
	        _24595 = _10825;
	    }
	    vec3 _12351 = mix(vec3(_Globals_.g_flReflectance).xyz, _13138.xyz, vec3(_24595));
	    vec3 _17892 = mix(vec3(1.0), _13532, bvec3(all(bvec3(true))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21813 = max(_13153.xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec3 _24735 = _13532.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21710;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11089 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m12) * PerViewConstantBufferCsgo_t._m11.xy) + (PerViewConstantBufferCsgo_t._m11.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _11089).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m11.x, 0.0);
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
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m11.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m2.x * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.y * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.z * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.w * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21710 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], g_bindless_Sampler[_Globals_.g_sPointClamp]), (_11089 + mix(_23169, PerViewConstantBufferCsgo_t._m11.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    float _8634 = dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _24735);
	    float _12320;
	    SPIRV_CROSS_BRANCH
	    if (_8634 > 0.0)
	    {
	        float _12504;
	        SPIRV_CROSS_BRANCH
	        if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	        {
	            int _23989;
	            int _10191;
	            float _13139;
	            vec3 _14975;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	                {
	                    _13139 = 1.0;
	                    _14975 = vec3(0.0);
	                    _10191 = -1;
	                    break;
	                }
	                vec4 _18322 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_13039];
	                float _12779 = _18322.x;
	                if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	                {
	                    vec3 _19470 = vec3(_12779, _18322.yz);
	                    vec2 _24804 = _19470.xy;
	                    vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14));
	                    vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                    vec3 _20488 = _19470;
	                    _20488.x = _20561.x;
	                    _20488.y = _20561.y;
	                    _13139 = saturate(_22193.x * _22193.y);
	                    _14975 = _20488;
	                    _10191 = _13039;
	                    break;
	                }
	                _23989 = _13039 + 1;
	                _13039 = _23989;
	                continue;
	            }
	            float _7258;
	            if (_10191 >= 0)
	            {
	                float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                float _12502;
	                SPIRV_CROSS_BRANCH
	                if (_13139 < 1.0)
	                {
	                    float _7934;
	                    if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                    {
	                        int _15335 = _10191 + 1;
	                        vec4 _19671 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_15335];
	                        vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                        vec3 _20489;
	                        _20489.x = _20562.x;
	                        _20489.y = _20562.y;
	                        _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                    }
	                    else
	                    {
	                        _7934 = 1.0;
	                    }
	                    _12502 = mix(_7934, _18270, _13139);
	                }
	                else
	                {
	                    _12502 = _18270;
	                }
	                _7258 = _12502;
	            }
	            else
	            {
	                _7258 = 1.0;
	            }
	            float _13279 = mix(_7258, 1.0, saturate((distance(_23501, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16));
	            float _12503;
	            if (_24465.y)
	            {
	                _12503 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m6], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	            }
	            else
	            {
	                _12503 = _13279;
	            }
	            _12504 = _12503;
	        }
	        else
	        {
	            _12504 = 1.0;
	        }
	        _12320 = _12504;
	    }
	    else
	    {
	        _12320 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    SPIRV_CROSS_BRANCH
	    if ((_8634 * _12320) > 0.0)
	    {
	        float _11797 = max(0.0, dot(_13532.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec2 _9840 = max(_21813, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _12320).xyz;
	        _9716 = ((_12351.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _11797).xyz * _16808;
	        _24878 = PerViewLightingConstantBufferGpu_t._m4.xyz + (vec3(_11797).xyz * _16808);
	    }
	    else
	    {
	        _9716 = vec3(0.0);
	        _24878 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24466 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20060 = _24466.x;
	    vec4 _19363;
	    if (_20060)
	    {
	        vec4 _18621 = vec4(_23501, 1.0).xyzw * PerViewConstantBufferCsgo_t._m10;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m0.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13140;
	    vec3 _16324;
	    _13140 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    vec3 _13141;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13141 = _13140;
	        _16325 = _16324;
	        uint _20344;
	        vec3 _13212;
	        vec3 _15670;
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
	                bool _12891;
	                if (!_7425)
	                {
	                    _12891 = true;
	                }
	                else
	                {
	                    _12891 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_0.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12891)
	                {
	                    _13212 = _13141;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17331 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17331 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23572 * g_BarnLights_1._m0[_12608]._m5.z) + (_17331 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21318;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21318 = min(1.0, _21777 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21318 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21318 * min(1.0, (1.0 - _21777) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21318;
	                }
	                vec3 _11182;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_0.xyz;
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
	                    _11182 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * saturate(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17331 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11182 = g_BarnLights_1._m0[_12608]._m2.xyz;
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
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15019, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15019, _15266), 1.1754943508222875079687365372222e-38), _23041);
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
	                    vec3 _12505;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11182).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20493 = _14081;
	                        _20493.x = _20564.x;
	                        _20493.y = _20564.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _20493.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20492 = _13791;
	                        _20492.x = _20563.x;
	                        _20492.y = _20563.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _20492.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12505;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13141;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _22671;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13141;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _22671 = _20482;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                float _11798 = max(0.0, dot(_13532.xyz, _11182.xyz));
	                vec2 _9841 = max(_21813, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11182.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz);
	                float _19211 = max(0.0, dot(_11182.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25213 = _9851 * _9851;
	                float _19096 = _25213 * _25213;
	                float _15348 = ((_12387 * _12387) * (_19096 - 1.0)) + 1.0;
	                _13212 = _13141.xyz + (((_12351.xyz * (_19096 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _11798).xyz * _22671.xyz);
	                _15670 = _16325.xyz + (vec3(_11798).xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13141 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13140 = _13141;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21813.xy, vec2(0.5));
	    vec3 _6519 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m3.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _6519)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _20418 = vec3(_21710 * _19068.x).xyz;
	    vec4 _11665 = vec4((_16324.xyz + (_8745 * _20418).xyz) * (_13138.xyz * (1.0 - _24595)).xyz, input_3.w);
	    vec3 _15752 = _11665.xyz + (mix((((_19877 * saturate(pow(_23826, _Globals_.g_flLayer2EmissiveFresnel))) * _Globals_.g_vLayer2EmissiveTint) * _Globals_.g_flLayer2EmissiveLevel) * input_3.xyz, ((_6342 * _Globals_.g_vLayer1EmissiveTint) * _Globals_.g_flLayer1EmissiveLevel) * input_3.xyz, _21153) * (1.0 - _15050)).xyz;
	    vec4 _20490 = _11665;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    vec3 _15753 = _20490.xyz + (_13140.xyz * _20418).xyz;
	    vec4 _20491 = _20490;
	    _20491.x = _15753.x;
	    _20491.y = _15753.y;
	    _20491.z = _15753.z;
	    vec3 _15734 = _20491.xyz + ((((mix(_11427.xxx, _11427.yyy, _12351) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_6519, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _20418).xyz;
	    vec4 _13888 = _20491;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _6538 = _23501 - PerViewConstantBuffer_t._m3.xyz;
	        vec3 _9057 = _6538.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _6538.xyz;
	            bool _12892;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m16.x)
	            {
	                _12892 = (_10061.z * PerViewConstantBufferCsgo_t._m16.z) < PerViewConstantBufferCsgo_t._m16.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12892)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m13.xy + (PerViewConstantBufferCsgo_t._m13.zw * vec2(length(_21493), _10061.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m14.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m14.y)) * PerViewConstantBufferCsgo_t._m15.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m15.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12893;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m20.x)
	            {
	                _12893 = (PerViewConstantBufferCsgo_t._m20.z * _10061.z) < PerViewConstantBufferCsgo_t._m20.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m17.y) + PerViewConstantBufferCsgo_t._m17.x), PerViewConstantBufferCsgo_t._m17.w)) * saturate(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m18.y) + PerViewConstantBufferCsgo_t._m18.x), PerViewConstantBufferCsgo_t._m18.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m20.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m3], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), normalize((PerViewConstantBufferCsgo_t._m19 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m18.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m17.z))) * PerViewConstantBufferCsgo_t._m21.x).xyz, _8892).xyz, vec3(_8892));
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
	        _6805 = _13888;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	
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
	
	BoolAttribute(BindlessResources, true);
	
}
