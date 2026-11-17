//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Standard shader for surfaces that require normal maps";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs, psrs
}

MODES
{
	CsgoForward();
	RayTrace("csgo_complex.vfx");
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
	Feature( F_AMBIENT_OCCLUSION_TEXTURE, 0..1, "PBR" );
	Feature( F_PAINT_VERTEX_COLORS, 0..1, "Vertex Color" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_PAINT_VERTEX_COLORS=1
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
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression(g_nScaleTexCoordUByModelScaleAxis!=0 || g_nScaleTexCoordVByModelScaleAxis!=0); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,g_vTexCoordCenter.x+g_vTexCoordOffset.x+v2*g_vTexCoordCenter.y-v1*g_vTexCoordCenter.x)); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,g_vTexCoordCenter.y+g_vTexCoordOffset.y-(v2*g_vTexCoordCenter.x+v1*g_vTexCoordCenter.y))); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _1234
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1234 _Globals_;
	
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
	    float _7654 = _23812.w;
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
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _7654 * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11399;
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
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, true);
	
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
	#endif
}

PS
{
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_AMBIENT_OCCLUSION_TEXTURE, F_AMBIENT_OCCLUSION_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, D_OPAQUE_FADE ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, D_OPAQUE_FADE ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
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
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureAmbientOcclusion), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_METALNESS_TEXTURE == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureAmbientOcclusion), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2830
	{
	    float4 _m0[3];
	};
	
	struct _30
	{
	    float4 _m0[4];
	};
	
	struct _1953
	{
	    column_major float4x4 _m0[4];
	};
	
	struct _200
	{
	    column_major float4x4 _m0;
	    column_major float4x4 _m1;
	    float4 _m2;
	    float4 _m3;
	    float4 _m4;
	    float4 _m5;
	    float3 _m6;
	    uint _m7;
	    float4 _m8;
	    float4 _m9;
	    float4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    column_major float4x3 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
	    column_major float4x4 _m23;
	};
	
	static float3 _4;
	static float4 _5;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    uint _Globals_1_g_tColor : packoffset(c0);
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c1);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c1.y);
	    uint _Globals_1_g_sPointClamp : packoffset(c1.z);
	    uint _Globals_1_g_sUserConfig : packoffset(c2.y);
	    uint _Globals_1_g_sUserConfigAllowGlobalMipBias : packoffset(c2.z);
	    uint _Globals_1_g_sCookieSampler : packoffset(c3);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c3.y);
	    int _Globals_1_g_bFogEnabled : packoffset(c3.w);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c4);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c4.y);
	    float _Globals_1_g_flReflectance : packoffset(c4.z);
	    uint _Globals_1_g_tNormal : packoffset(c8.y);
	    uint _Globals_1_g_tAmbientOcclusion : packoffset(c9);
	    float _Globals_1_g_flMetalness : packoffset(c9.y);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m3 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.w);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c5.z);
	    uint PerViewConstantBufferCsgo_t_1_m7 : packoffset(c6.z);
	    uint PerViewConstantBufferCsgo_t_1_m8 : packoffset(c8.y);
	    uint PerViewConstantBufferCsgo_t_1_m9 : packoffset(c8.z);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m12 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m20 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m21 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m22 : packoffset(c35);
	};
	
	cbuffer FireConstantBufferCsgo_t : register(b5, space1)
	{
	    uint FireConstantBufferCsgo_t_1_m0 : packoffset(c360);
	    uint FireConstantBufferCsgo_t_1_m1 : packoffset(c360.y);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c20.z);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c22);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2830 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _30 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c16);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c17);
	    float4 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c24);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1953.z);
	    float4 PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1955.w);
	    _1953 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _30 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
	    uint PerViewLightingConstantBufferGpu_t_1_m20 : packoffset(c1996);
	    uint PerViewLightingConstantBufferGpu_t_1_m21 : packoffset(c1996.y);
	};
	
	ByteAddressBuffer g_CullBits : register(t30, space3);
	ByteAddressBuffer g_BarnLights : register(t31, space3);
	Texture2D<float4> g_bindless_Texture2D_float4[65536] : register(t46, space4);
	SamplerState g_bindless_Sampler[2048] : register(s29, space4);
	SamplerComparisonState g_bindless_Sampler_1[2048] : register(s29, space4);
	Texture3D<float4> g_bindless_Texture3D_float4[65536] : register(t46, space4);
	TextureCubeArray<float4> g_bindless_TextureCubeArray_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static bool gl_FrontFacing;
	static float3 input_0;
	static float3 input_1;
	static float4 input_2;
	static float4 input_3;
	static float3 input_4;
	static float4 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	    centroid float3 input_4 : TEXCOORD4;
	    float4 input_5 : TEXCOORD5;
	    float4 gl_FragCoord : SV_Position;
	    bool gl_FrontFacing : SV_IsFrontFace;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _11408 = gl_FragCoord;
	    _11408.w = 1.0f / _11408.w;
	    float3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375f)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
	    bool _14874 = _Globals_1_g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
	    [branch]
	    if (_12885)
	    {
	        _10251 = _21709 * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _10061 = input_0 + PerViewConstantBufferCsgo_t_1_m22.xyz;
	    float4 _19680 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_2.xy);
	    float3 _21103 = _19680.xyz * input_3.xyz;
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], float2(input_2.xy).xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_2.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _18354 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    float2 _12835 = _19372.zz;
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
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
	    float3 _12631 = input_1.xyz * (_24327 ? (-1.0f) : 1.0f);
	    float3 _14435 = cross(_12631.xyz, input_5.xyz) * ((input_5.w > 0.0f) ? 1.0f : (-1.0f));
	    float3 _7424;
	    if (bool4(PerViewConstantBufferCsgo_t_1_m2.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m2.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m2.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m2.w != int4(0, 0, 0, 0).w).w)
	    {
	        _7424 = -_14435;
	    }
	    else
	    {
	        _7424 = _14435;
	    }
	    float3 _20480;
	    if (!_24327)
	    {
	        float3 _7482 = _18354;
	        _7482.y = -_18354.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _18354;
	    }
	    float3 _16230 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    float3 _21379 = _10061.xyz;
	    float3 _19870 = ddx(_21379);
	    float3 _9944 = ddy(_21379);
	    bool _12428 = (FireConstantBufferCsgo_t_1_m1 & 2u) != 0u;
	    float3 _13138;
	    float2 _13153;
	    float _24595;
	    [branch]
	    if (_12428)
	    {
	        bool _12887;
	        if (FireConstantBufferCsgo_t_1_m0 > 0u)
	        {
	            _12887 = true;
	        }
	        else
	        {
	            _12887 = (FireConstantBufferCsgo_t_1_m1 & 1u) != 0u;
	        }
	        float _6569;
	        float _13136;
	        float _13151;
	        [branch]
	        if (_12887)
	        {
	            float4 _11179 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m9].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f);
	            _13136 = _11179.x;
	            _13151 = _11179.y;
	            _6569 = _11179.w;
	        }
	        else
	        {
	            _13136 = 0.0f;
	            _13151 = 0.0f;
	            _6569 = 0.0f;
	        }
	        bool _17653 = _13136 > 0.0f;
	        bool _12888;
	        if (_17653)
	        {
	            _12888 = true;
	        }
	        else
	        {
	            _12888 = _13151 > 0.0f;
	        }
	        bool _12889;
	        if (_12888)
	        {
	            _12889 = true;
	        }
	        else
	        {
	            _12889 = _6569 > 0.0f;
	        }
	        float4 _20309;
	        [branch]
	        if (_12889)
	        {
	            float3 _14004 = pow(abs(_24347.xyz), 8.0f.xxx);
	            float3 _11969 = _14004 / dot(_14004, 1.0f.xxx).xxx;
	            float3 _18011 = _11969 * step(0.1500000059604644775390625f.xxx, _11969);
	            float3 _7622 = _18011 / max(dot(_18011, 1.0f.xxx), 9.9999997473787516355514526367188e-05f).xxx;
	            float _13822 = _7622.z;
	            float4 _21316;
	            [branch]
	            if (_13822 > 0.0f)
	            {
	                float _10504 = radians(37.0f);
	                float _17093 = cos(_10504);
	                float _6434 = sin(_10504);
	                float2x2 _15707 = float2x2(float2(_17093, -_6434) * 0.0078125f.xx, float2(_6434, _17093) * 0.0078125f.xx);
	                _21316 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m8].SampleGrad(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], mul(_15707, _10061.xy), mul(_15707, _19870.xy), mul(_15707, _9944.xy)) * _13822;
	            }
	            else
	            {
	                _21316 = 0.0f.xxxx;
	            }
	            float _10004 = _7622.x;
	            float4 _21317;
	            [branch]
	            if (_10004 > 0.0f)
	            {
	                float _10505 = radians(37.0f);
	                float _17094 = cos(_10505);
	                float _6435 = sin(_10505);
	                float2x2 _15708 = float2x2(float2(_17094, -_6435) * 0.0078125f.xx, float2(_6435, _17094) * 0.0078125f.xx);
	                _21317 = _21316 + (g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m8].SampleGrad(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], mul(_15708, _10061.yz), mul(_15708, _19870.yz), mul(_15708, _9944.yz)) * _10004);
	            }
	            else
	            {
	                _21317 = _21316;
	            }
	            float _10005 = _7622.y;
	            float4 _12501;
	            [branch]
	            if (_10005 > 0.0f)
	            {
	                float _10506 = radians(37.0f);
	                float _17095 = cos(_10506);
	                float _6437 = sin(_10506);
	                float2x2 _15709 = float2x2(float2(_17095, -_6437) * 0.0078125f.xx, float2(_6437, _17095) * 0.0078125f.xx);
	                _12501 = _21317 + (g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m8].SampleGrad(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], mul(_15709, _10061.xz), mul(_15709, _19870.xz), mul(_15709, _9944.xz)) * _10005);
	            }
	            else
	            {
	                _12501 = _21317;
	            }
	            _20309 = _12501;
	        }
	        else
	        {
	            _20309 = 0.5f.xxxx;
	        }
	        float _16380 = saturate(_6569 * lerp(1.0f, _20309.x * 2.0f, 0.17499999701976776123046875f));
	        float _16385 = 1.0f - _Globals_1_g_flMetalness;
	        float3 _21101 = (_21103.xyz * lerp(1.0f, 0.64999997615814208984375f, _16380 * lerp(0.300000011920928955078125f, 1.0f, saturate(_19372.z * 2.0f) * _16385))).xyz * lerp(1.0f.xxx, float3(0.75f, 0.62000000476837158203125f, 0.2800000011920928955078125f), (_16380 * 0.5f).xxx);
	        float3 _13137;
	        float _13152;
	        float2 _22371;
	        [branch]
	        if (_17653 ? _12428 : false)
	        {
	            float _16981 = _13136 * 2.0f;
	            float _13023 = saturate(_16981);
	            float _10371 = (_20309.x - 0.5f) * 0.699999988079071044921875f;
	            float _20671 = saturate(_13023 + (_10371 * saturate(_13023 * 4.0f)));
	            float _24490 = lerp(0.60000002384185791015625f, 1.0f, smoothstep(0.4000000059604644775390625f, 0.800000011920928955078125f, _24347.z));
	            float _20739 = (saturate((_20671 * 1.60000002384185791015625f) - 0.4000000059604644775390625f) * _24490) * lerp(1.0f, 0.800000011920928955078125f, _Globals_1_g_flMetalness);
	            float3 _14201 = _21101.xyz;
	            float3 _15381 = (_14201 * lerp(1.0f.xxx, float3(0.800000011920928955078125f, 0.699999988079071044921875f, 0.5f), ((((smoothstep(0.0f, 0.25f, _20671) * saturate(dot(_14201, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * 2.0f)) * _16385) * 0.4000000059604644775390625f) * _24490).xxx)).xyz;
	            float _7286 = saturate(saturate(_13023 + (_10371 * _13023)) * 1.2000000476837158203125f) * 7.0f;
	            float2 _24755 = _19372.zz;
	            _13137 = (lerp(_15381, _15381 * lerp(lerp(lerp(lerp(lerp(lerp(lerp(1.0f.xxx, float3(1.0f, 0.85000002384185791015625f, 0.550000011920928955078125f), saturate(_7286).xxx), float3(0.89999997615814208984375f, 0.60000002384185791015625f, 0.25f), saturate(_7286 - 1.0f).xxx), float3(0.64999997615814208984375f, 0.3499999940395355224609375f, 0.20000000298023223876953125f), saturate(_7286 - 2.0f).xxx), float3(0.5f, 0.20000000298023223876953125f, 0.5f), saturate(_7286 - 3.0f).xxx), float3(0.20000000298023223876953125f, 0.300000011920928955078125f, 0.75f), saturate(_7286 - 4.0f).xxx), float3(0.449999988079071044921875f, 0.60000002384185791015625f, 0.800000011920928955078125f), saturate(_7286 - 5.0f).xxx), float3(0.60000002384185791015625f, 0.62000000476837158203125f, 0.64999997615814208984375f), saturate(_7286 - 6.0f).xxx), (_Globals_1_g_flMetalness * 0.4000000059604644775390625f).xxx).xyz * lerp(1.0f, 0.60000002384185791015625f * lerp(1.0f, _20309.z * 2.0f, 0.5f), _20739)).xyz * lerp(1.0f, 0.20000000298023223876953125f, saturate(_16981 - 1.0f) * _20739);
	            _13152 = _Globals_1_g_flMetalness * lerp(1.0f, 0.89999997615814208984375f, _20739);
	            _22371 = lerp(_24755, max(_24755, 0.85000002384185791015625f.xx), (_20739 * 0.25f).xx);
	        }
	        else
	        {
	            _13137 = _21101;
	            _13152 = _Globals_1_g_flMetalness;
	            _22371 = _12835;
	        }
	        _13138 = _13137;
	        _13153 = lerp(_22371.xy, min(_22371.xy, 0.0500000007450580596923828125f.xx), saturate(_6569 * 0.89999997615814208984375f).xx);
	        _24595 = _13152;
	    }
	    else
	    {
	        _13138 = _21103;
	        _13153 = _12835;
	        _24595 = _Globals_1_g_flMetalness;
	    }
	    float3 _12351 = lerp(_Globals_1_g_flReflectance.xxx.xyz, _13138.xyz, _24595.xxx);
	    bool3 _24249 = all(bool3(true, true, true)).xxx;
	    float3 _17892 = float3(_24249.x ? _16230.x : 1.0f.xxx.x, _24249.y ? _16230.y : 1.0f.xxx.y, _24249.z ? _16230.z : 1.0f.xxx.z);
	    float3 _10560 = _24347.xyz;
	    float3 _11099 = ddx(_10560);
	    float3 _9175 = ddy(_10560);
	    float3 _10347 = _11099.xyz;
	    float3 _12420 = _9175.xyz;
	    float2 _21813 = max(_13153.xy, pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125f).xx);
	    float3 _15598 = -_24347;
	    float3 _24735 = _16230.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21710;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
	        float2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m12) * PerViewConstantBufferCsgo_t_1_m11.xy) + (PerViewConstantBufferCsgo_t_1_m11.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        float2 _23168;
	        if (_12285)
	        {
	            _23168 = float2(PerViewConstantBufferCsgo_t_1_m11.x, 0.0f);
	        }
	        else
	        {
	            _23168 = 0.0f.xx;
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        float2 _23169;
	        if (_12286)
	        {
	            _23169 = float2(0.0f, PerViewConstantBufferCsgo_t_1_m11.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        bool2 _13083 = (abs(_18418.y) < (_12286 ? _15372 : _20965)).xx;
	        float4 _10010 = normalize(float4(PerViewLightingConstantBufferGpu_t_1_m2.x * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.y * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.z * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.w * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xy, 0.25f))), 0.5f, 0.5f)));
	        float4 _13232 = max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx) * normalize(clamp(((_10010 - max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)).xxxx) + 0.20000000298023223876953125f.xxxx) * 5.0f.xxxx, 0.0f.xxxx, 1.0f.xxxx));
	        _21710 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11087 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m11.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m11.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float _8634 = dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _24735);
	    float _12320;
	    [branch]
	    if (_8634 > 0.0f)
	    {
	        float _12504;
	        [branch]
	        if (PerViewLightingConstantBufferGpu_t_1_m11 != 0)
	        {
	            int _23989;
	            int _10191;
	            float _13139;
	            float3 _14975;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m11))
	                {
	                    _13139 = 1.0f;
	                    _14975 = 0.0f.xxx;
	                    _10191 = -1;
	                    break;
	                }
	                float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039], float4(input_0.xyz, 1.0f));
	                float _12779 = _18322.x;
	                if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t_1_m13[_13039])
	                {
	                    float3 _19470 = float3(_12779, _18322.yz);
	                    float2 _24804 = _19470.xy;
	                    float2 _22193 = 1.0f.xx - clamp((abs(_24804) * PerViewLightingConstantBufferGpu_t_1_m15.xx) + PerViewLightingConstantBufferGpu_t_1_m14.xx, 0.0f.xx, 1.0f.xx);
	                    float2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t_1_m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t_1_m19._m0[_13039].xy;
	                    float3 _20488 = _19470;
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
	            float _21711;
	            if (_10191 >= 0)
	            {
	                float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t_1_m12));
	                float _12502;
	                [branch]
	                if (_13139 < 1.0f)
	                {
	                    float _7934;
	                    if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m11 - 1))
	                    {
	                        int _15335 = _10191 + 1;
	                        float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335], float4(input_0.xyz, 1.0f));
	                        float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].xy;
	                        float3 _20489;
	                        _20489.x = _20562.x;
	                        _20489.y = _20562.y;
	                        _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t_1_m12));
	                    }
	                    else
	                    {
	                        _7934 = 1.0f;
	                    }
	                    _12502 = lerp(_7934, _18270, _13139);
	                }
	                else
	                {
	                    _12502 = _18270;
	                }
	                _21711 = _12502;
	            }
	            else
	            {
	                _21711 = 1.0f;
	            }
	            float _13279 = lerp(_21711, 1.0f, saturate((distance(_21379, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m17) + PerViewLightingConstantBufferGpu_t_1_m16));
	            float _12503;
	            if (_24465.y)
	            {
	                _12503 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	            }
	            else
	            {
	                _12503 = _13279;
	            }
	            _12504 = _12503;
	        }
	        else
	        {
	            _12504 = 1.0f;
	        }
	        _12320 = _12504;
	    }
	    else
	    {
	        _12320 = 1.0f;
	    }
	    float3 _9716;
	    float3 _24878;
	    [branch]
	    if ((_8634 * _12320) > 0.0f)
	    {
	        bool3 _19899 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	        float _11797 = max(0.0f, dot(_16230.xyz, PerViewLightingConstantBufferGpu_t_1_m9.xyz));
	        float2 _9840 = max(_21813, PerViewLightingConstantBufferGpu_t_1_m9.w.xx);
	        float3 _12281 = normalize(PerViewLightingConstantBufferGpu_t_1_m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, float3(_19899.x ? _24735.x : _17892.x, _19899.y ? _24735.y : _17892.y, _19899.z ? _24735.z : _17892.z).xyz);
	        float _19210 = max(0.0f, dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0f)) + 1.0f;
	        float3 _16808 = (PerViewLightingConstantBufferGpu_t_1_m10.xyz * _12320).xyz;
	        _9716 = ((_12351.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0f) + 2.0f)))).xyz * _11797).xyz * _16808;
	        _24878 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (_11797.xxx.xyz * _16808);
	    }
	    else
	    {
	        _9716 = 0.0f.xxx;
	        _24878 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19363;
	    if (_20060)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m10, float4(_21379, 1.0f).xyzw);
	        float _20176 = _18621.w;
	        float2 _11414 = _18621.xy / _20176.xx;
	        float4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0f) * PerViewConstantBuffer_t_1_m1.x) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.x - 1.0f);
	        _6651.y = clamp(((1.0f - _11414.y) * PerViewConstantBuffer_t_1_m1.y) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.y - 1.0f);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uint2 _12083 = uint2(_19363.xy - PerViewConstantBuffer_t_1_m0.xy) >> PerViewLightingConstantBufferGpu_t_1_m6.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t_1_m7.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m7.y)) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    float3 _13140;
	    float3 _16324;
	    _13140 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    float3 _13141;
	    float3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t_1_m5.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load<uint>((_10838 + _17017) * 4 + 0) & g_CullBits.Load<uint>((_23393 + _17017) * 4 + 0));
	        _13141 = _13140;
	        _16325 = _16324;
	        uint _20344;
	        float3 _13212;
	        float3 _15670;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(firstbitlow(_17018) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                float4x4 _14097 = float4x4(g_BarnLights.Load<float>(_12608 * 480 + 0), g_BarnLights.Load<float>(_12608 * 480 + 16), g_BarnLights.Load<float>(_12608 * 480 + 32), g_BarnLights.Load<float>(_12608 * 480 + 48), g_BarnLights.Load<float>(_12608 * 480 + 4), g_BarnLights.Load<float>(_12608 * 480 + 20), g_BarnLights.Load<float>(_12608 * 480 + 36), g_BarnLights.Load<float>(_12608 * 480 + 52), g_BarnLights.Load<float>(_12608 * 480 + 8), g_BarnLights.Load<float>(_12608 * 480 + 24), g_BarnLights.Load<float>(_12608 * 480 + 40), g_BarnLights.Load<float>(_12608 * 480 + 56), g_BarnLights.Load<float>(_12608 * 480 + 12), g_BarnLights.Load<float>(_12608 * 480 + 28), g_BarnLights.Load<float>(_12608 * 480 + 44), g_BarnLights.Load<float>(_12608 * 480 + 60));
	                float4 _24893 = mul(float4(input_0.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
	                float3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7425 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
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
	                    float4x3 _16509 = float4x3(g_BarnLights.Load<float>(_12608 * 480 + 272), g_BarnLights.Load<float>(_12608 * 480 + 288), g_BarnLights.Load<float>(_12608 * 480 + 304), g_BarnLights.Load<float>(_12608 * 480 + 276), g_BarnLights.Load<float>(_12608 * 480 + 292), g_BarnLights.Load<float>(_12608 * 480 + 308), g_BarnLights.Load<float>(_12608 * 480 + 280), g_BarnLights.Load<float>(_12608 * 480 + 296), g_BarnLights.Load<float>(_12608 * 480 + 312), g_BarnLights.Load<float>(_12608 * 480 + 284), g_BarnLights.Load<float>(_12608 * 480 + 300), g_BarnLights.Load<float>(_12608 * 480 + 316));
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), _16509).xyz);
	                    _12891 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12891)
	                {
	                    _13212 = _13141;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).y;
	                float _18492 = (2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).z) * g_BarnLights.Load<float4>(_12608 * 480 + 176).z;
	                float _14805 = 2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).x;
	                float _9058 = _14805 * g_BarnLights.Load<float4>(_12608 * 480 + 176).y;
	                float _17330 = 2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).w;
	                float _19825 = _17330 * g_BarnLights.Load<float4>(_12608 * 480 + 176).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * g_BarnLights.Load<float4>(_12608 * 480 + 176).x)) - _18492, (_23572 * g_BarnLights.Load<float4>(_12608 * 480 + 176).z) + (_17330 * g_BarnLights.Load<float4>(_12608 * 480 + 176).x)) * g_BarnLights.Load<float3>(_12608 * 480 + 192).z;
	                float _21318;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 144).z > 0.0f)
	                {
	                    _21318 = min(1.0f, _21776 * g_BarnLights.Load<float4>(_12608 * 480 + 144).z);
	                }
	                else
	                {
	                    _21318 = 1.0f;
	                }
	                float _19667;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 144).w > 0.0f)
	                {
	                    _19667 = _21318 * min(1.0f, (1.0f - _21776) * g_BarnLights.Load<float4>(_12608 * 480 + 144).w);
	                }
	                else
	                {
	                    _19667 = _21318;
	                }
	                float3 _11180;
	                float _11633;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 128).w != 0.0f)
	                {
	                    float3 _10017 = g_BarnLights.Load<float4>(_12608 * 480 + 128).xyz - input_0.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    float3 _12302 = _10017 - _16268;
	                    float3 _10210;
	                    do
	                    {
	                        float3 _20229 = (_10017 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0f)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0f, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11180 = _10017 / _17647.xxx;
	                    _11633 = ((_19667 * (g_BarnLights.Load<float4>(_12608 * 480 + 128).w / max(_18345, g_BarnLights.Load<float4>(_12608 * 480 + 128).w))) * saturate(g_BarnLights.Load<float4>(_12608 * 480 + 144).x + (g_BarnLights.Load<float4>(_12608 * 480 + 144).y * _17647))) * saturate(g_BarnLights.Load<float3>(_12608 * 480 + 192).x + (g_BarnLights.Load<float3>(_12608 * 480 + 192).y * dot(float3((1.0f - (_23572 * g_BarnLights.Load<float4>(_12608 * 480 + 176).y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights.Load<float4>(_12608 * 480 + 176).z) - (_17330 * g_BarnLights.Load<float4>(_12608 * 480 + 176).y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11180 = g_BarnLights.Load<float4>(_12608 * 480 + 128).xyz;
	                    _11633 = _19667;
	                }
	                float3 _17828 = (g_BarnLights.Load<float4>(_12608 * 480 + 160).xyz * 1.0f).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 208).z > 0.0f)
	                {
	                    _24419 = !_20060;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                float3 _21548;
	                [branch]
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 160).w == 0.0f)
	                {
	                    float _10342;
	                    do
	                    {
	                        float2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights.Load<float4>(_12608 * 480 + 224).z == 0.0f)
	                        {
	                            _10342 = smoothstep(1.0f, g_BarnLights.Load<float4>(_12608 * 480 + 224).x, _22154.x) * smoothstep(1.0f, g_BarnLights.Load<float4>(_12608 * 480 + 224).y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0f / g_BarnLights.Load<float4>(_12608 * 480 + 224).z;
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * g_BarnLights.Load<float4>(_12608 * 480 + 224).z;
	                            float _11981 = (g_BarnLights.Load<float4>(_12608 * 480 + 224).x * g_BarnLights.Load<float4>(_12608 * 480 + 224).y) * pow(max(pow(g_BarnLights.Load<float4>(_12608 * 480 + 224).y * _11473, _15266) + pow(g_BarnLights.Load<float4>(_12608 * 480 + 224).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0f);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0f);
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
	                    float3 _12505;
	                    if (g_BarnLights.Load<float4>(_12608 * 480 + 160).w < 0.0f)
	                    {
	                        float4 _17795 = float4(-g_BarnLights.Load<float4>(_12608 * 480 + 176).xyz, g_BarnLights.Load<float4>(_12608 * 480 + 176).w);
	                        float4 _19008 = _17795.xyzw * float4(-1.0f, -1.0f, -1.0f, 1.0f);
	                        float3 _24989 = _19008.xyz;
	                        float3 _23629 = float4((-_11180).xyz, 0.0f).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        float3 _20479 = float4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        float3 _23592 = _17795.xyz;
	                        float3 _12170 = ((_20479 * g_BarnLights.Load<float4>(_12608 * 480 + 176).w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -g_BarnLights.Load<float4>(_12608 * 480 + 160).w);
	                        float2 _20564 = (_14081.xy * g_BarnLights.Load<float4>(_12608 * 480 + 224).zw) + g_BarnLights.Load<float4>(_12608 * 480 + 224).xy;
	                        float3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12505 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _20492.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), g_BarnLights.Load<float4>(_12608 * 480 + 160).w);
	                        float2 _20563 = (_13791.xy * g_BarnLights.Load<float4>(_12608 * 480 + 224).zw) + g_BarnLights.Load<float4>(_12608 * 480 + 224).xy;
	                        float3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12505 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _20491.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12505;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _13212 = _13141;
	                    _15670 = _16325;
	                    break;
	                }
	                float3 _22671;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load<uint>(_12608 * 480 + 264) & 4u) != 0u)
	                    {
	                        float2 _6281 = _22905.yx * float2(1.0f, -1.0f);
	                        float3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, g_BarnLights.Load<float4>(_12608 * 480 + 208).zw, g_BarnLights.Load<float4>(_12608 * 480 + 208).xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t_1_m12)), g_BarnLights.Load<float>(_12608 * 480 + 260));
	                    float3 _16449 = _20482.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
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
	                bool3 _19900 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	                float _11799 = max(0.0f, dot(_16230.xyz, _11180.xyz));
	                float2 _9841 = max(_21813, g_BarnLights.Load<float>(_12608 * 480 + 256).xx);
	                float3 _12282 = normalize(_11180.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, float3(_19900.x ? _24735.x : _17892.x, _19900.y ? _24735.y : _17892.y, _19900.z ? _24735.z : _17892.z).xyz);
	                float _19211 = max(0.0f, dot(_11180.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25213 = _9851 * _9851;
	                float _19096 = _25213 * _25213;
	                float _15348 = ((_12387 * _12387) * (_19096 - 1.0f)) + 1.0f;
	                _13212 = _13141.xyz + (((_12351.xyz * (_19096 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0f) + 2.0f)))).xyz * _11799).xyz * _22671.xyz);
	                _15670 = _16325.xyz + (_11799.xxx.xyz * _22671.xyz);
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
	    float _17172 = dot(_21813.xy, 0.5f.xx);
	    float3 _6253 = _17892.xyz;
	    float3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0f - _17225);
	    float4 _15343 = (float4(-1.0f, -0.0274999998509883880615234375f, -0.572000026702880859375f, 0.02199999988079071044921875f) * _17172) + float4(1.0f, 0.0425000004470348358154296875f, 1.03999996185302734375f, -0.039999999105930328369140625f);
	    float _21215 = _15343.x;
	    float2 _24572 = (float2(-1.03999996185302734375f, 1.03999996185302734375f) * ((min(_21215 * _21215, exp2((-9.27999973297119140625f) * max(0.0f, dot((-_17138).xyz, _6253)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    float2 _11427 = float2(_20339, _24572.x + _20339);
	    float3 _8745 = float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz;
	    float3 _16991 = _16324.xyz + _8745;
	    float3 _20418 = (_21710 * _19068.x).xxx.xyz;
	    float3 _22686 = (_16324.xyz + (_8745 * _20418).xyz) * (_13138.xyz * (1.0f - _24595)).xyz;
	    float _12931 = _22686.x;
	    float4 _11204 = float4(_12931, _22686.yz, input_3.w);
	    _11204.x = _12931;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    float3 _15752 = _11204.xyz + (_13140.xyz * _20418).xyz;
	    float4 _20490 = _11204;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    float3 _15734 = _20490.xyz + ((((lerp(_11427.xxx, _11427.yyy, _12351) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m7].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6253, reflect(_17138.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16991), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f))).xyz * _20418).xyz;
	    float4 _13888 = _20490;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _6538 = _21379 - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _6538.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _6538.xyz;
	            bool _12892;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m16.x)
	            {
	                _12892 = (_10061.z * PerViewConstantBufferCsgo_t_1_m16.z) < PerViewConstantBufferCsgo_t_1_m16.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            [branch]
	            if (_12892)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m13.xy + (PerViewConstantBufferCsgo_t_1_m13.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m14.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m14.y)) * PerViewConstantBufferCsgo_t_1_m15.w;
	                _19340 = lerp(_13888.xyz, float4(PerViewConstantBufferCsgo_t_1_m15.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12893;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m20.x)
	            {
	                _12893 = (PerViewConstantBufferCsgo_t_1_m20.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m20.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m17.y) + PerViewConstantBufferCsgo_t_1_m17.x), PerViewConstantBufferCsgo_t_1_m17.w)) * saturate(pow(max(0.0f, (_10061.z * PerViewConstantBufferCsgo_t_1_m18.y) + PerViewConstantBufferCsgo_t_1_m18.x), PerViewConstantBufferCsgo_t_1_m18.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m20.w;
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m19).xyz).xyz, PerViewConstantBufferCsgo_t_1_m18.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m17.z))) * PerViewConstantBufferCsgo_t_1_m21.x).xyz, _8892).xyz, _8892.xxx);
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
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    gl_FrontFacing = stage_input.gl_FrontFacing;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    input_5 = stage_input.input_5;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
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
