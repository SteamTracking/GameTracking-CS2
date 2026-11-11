//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Unlit translucent effects material, useful for fog cards, fire, clouds, glows, etc.";
	DevShader = false;
	Version = 3;
	
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
	Feature( F_DEPTH_FEATHER, 0..1, "Depth Feather" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices   : BLENDINDICES0  < Semantic( BlendIndices ); >;                         // D_CS_VERTEX_ANIMATION=0
	float4 vBlendColorTint : COLOR0         < Semantic( VertexPaintTintColor ); >;                
	uint4  nPackedFrame    : NORMAL0        < Semantic( CompressedTangentFrame ); >;              
	float4 vNormalOs       : NORMAL0        < Semantic( Normal ); >;                              
	float3 vPositionOs     : POSITION0      < Semantic( PosXyz ); >;                               // D_CS_VERTEX_ANIMATION=0
	float2 vLightmapUV     : TEXCOORD3      < Semantic( LightmapUV ); >;                           // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float2 vTexCoord       : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                      
	float2 nInstanceIdx    : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                 
};

VS
{
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
	float4 g_vCodeDrivenScale < Attribute("CodeDrivenScale"); UiType(VectorText); >;
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
	
	struct _1330
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    vec4 g_vCodeDrivenScale;
	};
	
	layout(set = 0) uniform _1330 _Globals_;
	
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
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in uvec4 vBlendIndices;
	layout(location = 4) in uint nInstanceIdx;
	layout(location = 5) in vec4 vBlendColorTint;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) centroid out vec4 output_3;
	layout(location = 4) flat out uint output_4;
	
	void main()
	{
	    vec3 _9716;
	    vec2 _24954;
	    if (length(_Globals_.g_vCodeDrivenScale.xyz) > 0.0)
	    {
	        _9716 = vPositionOs.xyz * _Globals_.g_vCodeDrivenScale.xyz;
	        _24954 = vTexCoord.xy * _Globals_.g_vCodeDrivenScale.xz;
	    }
	    else
	    {
	        _9716 = vPositionOs;
	        _24954 = vTexCoord;
	    }
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
	    vec3 _12151 = vec4(_9716.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9360 = _24954.xyxy;
	    _9360.x = dot(_24954.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(_24954.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
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
	    bool _12885;
	    if (vBlendColorTint.x == 0.0)
	    {
	        _12885 = vBlendColorTint.y == 0.0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    bool _12886;
	    if (_12885)
	    {
	        _12886 = vBlendColorTint.z == 0.0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _7424;
	    if (_12886)
	    {
	        _7424 = vBlendColorTint.w == 0.0;
	    }
	    else
	    {
	        _7424 = false;
	    }
	    vec4 _19363;
	    if (!_7424)
	    {
	        _19363 = _23714.xyzw * vBlendColorTint.xyzw;
	    }
	    else
	    {
	        _19363 = _23714;
	    }
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    output_2 = _20488;
	    output_3 = _19363;
	    output_4 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(VertexPaintUIPickColorAlpha, true);
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_DEPTH_FEATHER, F_DEPTH_FEATHER );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SCENE_DEPTH_MSAA, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SCENE_DEPTH_MSAA, S_DEPTH_FEATHER ) );
	
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tMask1 < Channel(R, Box(TextureMask1), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMask2 < Channel(R, Box(TextureMask2), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMask3 < Channel(R, Box(TextureMask3), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tSceneDepth < Attribute("SceneDepth"); SrgbRead(false); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	float g_flColorBoost < Default(1); Range(0, 500); UiType(Slider); UiGroup("Color"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Mask 1
	CreateInputTexture2D(TextureMask1, Linear, 8, "", "_mask", "Mask 1,13/10", Default4(1, 1, 1, 0));
	float2 g_vMask1PanSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Mask 1,13/11"); >;
	float2 g_vMask1Scale < Default2(1, 1); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Mask 1,13/12"); >;
	
	// Mask 2
	CreateInputTexture2D(TextureMask2, Linear, 8, "", "_mask", "Mask 2,14/10", Default4(1, 1, 1, 0));
	float2 g_vMask2PanSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Mask 2,14/11"); >;
	float2 g_vMask2Scale < Default2(1, 1); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Mask 2,14/12"); >;
	
	// Mask 3
	CreateInputTexture2D(TextureMask3, Linear, 8, "", "_mask", "Mask 3,15/10", Default4(1, 1, 1, 0));
	float2 g_vMask3PanSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Mask 3,14/11"); >;
	float2 g_vMask3Scale < Default2(1, 1); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Mask 3,14/12"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Distance Fade
	float g_flFadeDistance < Default(1); Range(0, 5000); UiType(Slider); UiGroup("Distance Fade,12/10"); >;
	float g_flFadeFalloff < Default(1); Range(1, 10); UiType(Slider); UiGroup("Distance Fade,12/11"); >;
	float g_flFadeMin < UiType(Slider); UiGroup("Distance Fade,12/12"); >;
	float g_flFadeMax < Default(1); UiType(Slider); UiGroup("Distance Fade,12/13"); >;
	
	// Depth Feather
	float g_flFeatherDistance < Range(0, 2000); UiType(Slider); UiGroup("Depth Feather,11/12"); >;
	float g_flFeatherFalloff < Default(1); Range(1, 10); UiType(Slider); UiGroup("Depth Feather,11/13"); >;
	
	// Fresnel
	float g_flFresnelExponent < Default(0.001); Range(0.001, 10); UiType(Slider); UiGroup("Fresnel,10/10"); >;
	float g_flFresnelFalloff < Default(1); Range(1, 10); UiType(Slider); UiGroup("Fresnel,10/11"); >;
	float g_flFresnelMin < UiType(Slider); UiGroup("Fresnel,10/12"); >;
	float g_flFresnelMax < Default(1); UiType(Slider); UiGroup("Fresnel,10/13"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    int _Globals_1_g_bFogEnabled : packoffset(c0.z);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c0.w);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c1);
	    float _Globals_1_g_flOpacityScale : packoffset(c5.z);
	    float _Globals_1_g_flColorBoost : packoffset(c5.w);
	    float _Globals_1_g_flFresnelExponent : packoffset(c6);
	    float _Globals_1_g_flFresnelFalloff : packoffset(c6.y);
	    float _Globals_1_g_flFresnelMin : packoffset(c6.z);
	    float _Globals_1_g_flFresnelMax : packoffset(c6.w);
	    float _Globals_1_g_flFadeDistance : packoffset(c7.z);
	    float _Globals_1_g_flFadeFalloff : packoffset(c7.w);
	    float _Globals_1_g_flFadeMin : packoffset(c8);
	    float _Globals_1_g_flFadeMax : packoffset(c8.y);
	    float2 _Globals_1_g_vMask1PanSpeed : packoffset(c8.z);
	    float2 _Globals_1_g_vMask1Scale : packoffset(c9);
	    float2 _Globals_1_g_vMask2PanSpeed : packoffset(c9.z);
	    float2 _Globals_1_g_vMask2Scale : packoffset(c10);
	    float2 _Globals_1_g_vMask3PanSpeed : packoffset(c10.z);
	    float2 _Globals_1_g_vMask3Scale : packoffset(c11);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m3 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m4 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m5 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m6 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c35);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c18.w);
	    float3 PerViewConstantBuffer_t_1_m1 : packoffset(c26);
	};
	
	Texture2D<float4> g_tColor : register(t51, space1);
	SamplerState g_sUserConfigAllowGlobalMipBias : register(s21, space1);
	Texture2D<float4> g_tMask1 : register(t52, space1);
	SamplerState g_sUserConfig : register(s20, space1);
	Texture2D<float4> g_tMask2 : register(t53, space1);
	Texture2D<float4> g_tMask3 : register(t54, space1);
	TextureCube<float4> g_tFogCubeTexture : register(t42, space1);
	SamplerState g_sTrilinearClamp : register(s18, space1);
	
	static bool gl_FrontFacing;
	static float3 input_0;
	static float3 input_1;
	static float4 input_2;
	static float4 input_3;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	    bool gl_FrontFacing : SV_IsFrontFace;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    bool _12885;
	    if (_Globals_1_g_bRenderBackfaceNormals != 0)
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
	        _10251 = input_1.xyz * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = input_1.xyz;
	    }
	    float3 _7639 = input_0 + PerViewConstantBufferCsgo_t_1_m9.xyz;
	    float4 _19680 = g_tColor.Sample(g_sUserConfigAllowGlobalMipBias, input_2.xy);
	    float3 _3980 = _7639 - PerViewConstantBuffer_t_1_m1;
	    float _13654 = (input_3.w * (_19680.w * _Globals_1_g_flOpacityScale)) * ((((g_tMask1.Sample(g_sUserConfig, ((input_2.xy * _Globals_1_g_vMask1Scale) + (_Globals_1_g_vMask1PanSpeed * PerViewConstantBuffer_t_1_m0)).xy).x * g_tMask2.Sample(g_sUserConfig, ((input_2.xy * _Globals_1_g_vMask2Scale) + (_Globals_1_g_vMask2PanSpeed * PerViewConstantBuffer_t_1_m0)).xy).x) * g_tMask3.Sample(g_sUserConfig, ((input_2.xy * _Globals_1_g_vMask3Scale) + (_Globals_1_g_vMask3PanSpeed * PerViewConstantBuffer_t_1_m0)).xy).x) * lerp(_Globals_1_g_flFresnelMin, _Globals_1_g_flFresnelMax, saturate(pow(saturate(dot(-normalize(_3980), normalize(_10251).xyz)), _Globals_1_g_flFresnelExponent) * _Globals_1_g_flFresnelFalloff))) * pow(lerp(_Globals_1_g_flFadeMin, _Globals_1_g_flFadeMax, saturate(length(_3980 / _Globals_1_g_flFadeDistance.xxx))), _Globals_1_g_flFadeFalloff));
	    float3 _10984 = ((_19680.xyz * input_3.xyz).xyz * 1.0f) * _Globals_1_g_flColorBoost;
	    float _15244 = _10984.x;
	    float4 _11203 = float4(_15244, _10984.yz, _13654);
	    _11203.x = _15244;
	    _11203.y = _10984.y;
	    _11203.z = _10984.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _18726 = _7639.xyz - PerViewConstantBuffer_t_1_m1.xyz;
	        float3 _9057 = _18726.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _18726.xyz;
	            bool _12886;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m3.x)
	            {
	                _12886 = (_7639.z * PerViewConstantBufferCsgo_t_1_m3.z) < PerViewConstantBufferCsgo_t_1_m3.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            [branch]
	            if (_12886)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m0.xy + (PerViewConstantBufferCsgo_t_1_m0.zw * float2(length(_21493), _7639.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m1.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m1.y)) * PerViewConstantBufferCsgo_t_1_m2.w;
	                _19340 = lerp(_11203.xyz, float4(PerViewConstantBufferCsgo_t_1_m2.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _11203.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _11203;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12887;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m7.x)
	            {
	                _12887 = (PerViewConstantBufferCsgo_t_1_m7.z * _7639.z) < PerViewConstantBufferCsgo_t_1_m7.y;
	            }
	            else
	            {
	                _12887 = false;
	            }
	            if (_12887)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m4.y) + PerViewConstantBufferCsgo_t_1_m4.x), PerViewConstantBufferCsgo_t_1_m4.w)) * saturate(pow(max(0.0f, (_7639.z * PerViewConstantBufferCsgo_t_1_m5.y) + PerViewConstantBufferCsgo_t_1_m5.x), PerViewConstantBufferCsgo_t_1_m5.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m7.w;
	                _19341 = lerp(_23944.xyz, float4((g_tFogCubeTexture.SampleLevel(g_sTrilinearClamp, normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m6).xyz).xyz, PerViewConstantBufferCsgo_t_1_m5.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m4.z))) * PerViewConstantBufferCsgo_t_1_m8.x).xyz, _8892).xyz, _8892.xxx);
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
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FrontFacing = stage_input.gl_FrontFacing;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(unlit, true);
	BoolAttribute(translucent, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	BoolAttribute(SupportsLightmapping, false);
	BoolAttribute(AcceptsDecals, false);
	
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(BlendEnable, true);
	RenderState(BlendEnable0, true);
	RenderState(BlendEnable1, true);
	RenderState(BlendEnable2, true);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthWriteEnable, false);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(DstBlend0, One);
	RenderState(DstBlend1, One);
	RenderState(DstBlend2, One);
	RenderState(DstBlendAlpha0, One);
	RenderState(DstBlendAlpha1, One);
	RenderState(DstBlendAlpha2, One);
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
