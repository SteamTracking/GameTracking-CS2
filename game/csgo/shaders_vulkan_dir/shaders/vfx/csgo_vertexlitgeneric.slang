//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "(S1) vertexlit, bump, phong shader for CSGO.";
	DevShader = false;
	Version = 4;
	
	// Platform: VULKAN_SM_60
	// Programs: ps, psrs, rtx, vs
}

MODES
{
	Depth("csgo_depth_only.vfx");
	CsgoForward();
	RayTrace();
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
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	Feature( F_SPECULAR_DIRECT, 0..1, "Direct/Per-Pixel Specular - S1 $phong" );
	Feature( F_SPECULAR_INDIRECT, 0..1, "Indirect/Cubemap Specular - S1 $envmap" );
	Feature( F_SELF_ILLUM, 0..1, "Self Illum" );
	Feature( F_DECAL_TEXTURE, 0..1, "Decal Texture" );
	Feature( F_DECAL_BLEND_MODE, 0..1, "Decal Blend Mode" );
	Feature( F_DEPTH_BIAS, 0..1, "Z-Buffering" );
	Feature( F_DETAIL_TEXTURE, 0..1 (0="None", 1="Mod2X"), "Detail Texture" );
	Feature( F_NOTINT, 0..1, "Prevent Tinting" );
	Feature( F_FORCE_UV2, 0..1, "Ensure 2nd UV set presnt in vertex data" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Requires( F_SPECULAR_DIRECT, F_SPECULAR_INDIRECT ), "Direct specular requires indirect (we'd prefer to avoid having only direct specular)" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_ADDITIVE_BLEND ), "Detail Texture and Additive Blend are not compatible" );
	FeatureRule( ChildOf( F_DECAL_BLEND_MODE, F_DECAL_TEXTURE ), "Decal Blend Mode requires Decal Texture" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1, S_SHADER_QUALITY=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_FORCE_UV2=1, S_DECAL_TEXTURE=1
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_FORCE_UV2, F_FORCE_UV2 );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_FORCE_UV2 ) );
	StaticComboRule( Requires( S_SHADER_QUALITY, S_MODE_TOOLS_VIS ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
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
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flNormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vNormalTexCoordScale.x,-v2*g_vNormalTexCoordScale.y,0,g_vNormalTexCoordCenter.x+g_vNormalTexCoordOffset.x+v2*g_vNormalTexCoordScale.y*g_vNormalTexCoordCenter.y-v1*g_vNormalTexCoordScale.x*g_vNormalTexCoordCenter.x)); >;
	float4 g_vNormalTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flNormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vNormalTexCoordScale.x,v1*g_vNormalTexCoordScale.y,0,g_vNormalTexCoordCenter.y+g_vNormalTexCoordOffset.y+v2*g_vNormalTexCoordScale.x*g_vNormalTexCoordCenter.x-v1*g_vNormalTexCoordScale.y*g_vNormalTexCoordCenter.y)); >;
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
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailTexture < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 170"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = g_flDetailTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		-.5*v3*float2(v1-v2,v2+v1)+v4+.5); >;
	
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
	
	// Normal Map
	float g_flNormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Normal Map,50"); >;
	float2 g_vNormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Normal Map,30"); >;
	float2 g_vNormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Normal Map,60"); >;
	float2 g_vNormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Normal Map,40"); >;
	
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
	
	struct _1549
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    vec4 g_vNormalTexCoordXform0;
	    vec4 g_vNormalTexCoordXform1;
	};
	
	layout(set = 0) uniform _1549 _Globals_;
	
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
	layout(location = 0) out vec2 output_0;
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
	    float _7654 = _23812.w;
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
	    output_0 = vec2(dot(vTexCoord.xy, _Globals_.g_vNormalTexCoordXform0.xy) + _Globals_.g_vNormalTexCoordXform0.w, dot(vTexCoord.xy, _Globals_.g_vNormalTexCoordXform1.xy) + _Globals_.g_vNormalTexCoordXform1.w);
	    output_1 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    output_3 = _20488;
	    output_4 = _23714;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_6 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	
	
	// Variant Attributes
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
}

PS
{
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_FORCE_UV2, F_FORCE_UV2 );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_FORCE_UV2 ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SPECULAR_INDIRECT, S_MODE_TOOLS_VIS ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	
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
	float g_flInverseBlendTint < UiType(Slider); Expression(F_NOTINT ? -1 : 1-(F_TINT_MASK ? 1 : 0)); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE ? 1 : 0); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression(pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	float g_flAmbientOcclusionScale < Range(0, 2); UiType(Slider); UiGroup("Ambient Occlusion/20"); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Decal Texture
	bool g_bUseSecondaryUvForDecal < Default(1); UiType(CheckBox); UiGroup("Decal Texture, 180"); >;
	CreateInputTexture2D(TextureDecal, Srgb, 8, "", "_decal", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDecalTranslucency, Linear, 8, "", "_trans", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailMask < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 180"); >;
	CreateInputTexture2D(TextureDetail, Linear, 8, "Mod2XCenter", "_detail", "Detail Texture,80/10", Default4(1, 1, 1, 1));
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Self Illum
	bool g_bUseSecondaryUvForSelfIllum < UiType(CheckBox); UiGroup("Self Illum,100"); >;
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
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
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2620
	{
	    float4 _m0[3];
	};
	
	struct _2830
	{
	    float4 _m0[4];
	};
	
	struct _1023
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
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c0.z);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c0.w);
	    uint _Globals_1_g_sPointClamp : packoffset(c1);
	    uint _Globals_1_g_sUserConfig : packoffset(c1.w);
	    uint _Globals_1_g_sUserConfigAllowGlobalMipBias : packoffset(c2);
	    uint _Globals_1_g_sCookieSampler : packoffset(c2.z);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c2.w);
	    int _Globals_1_g_bFogEnabled : packoffset(c3.y);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c3.z);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c3.w);
	    uint _Globals_1_g_tColor : packoffset(c7.w);
	    uint _Globals_1_g_tNormal : packoffset(c8);
	    uint _Globals_1_g_tAmbientOcclusion : packoffset(c8.w);
	    float _Globals_1_g_flAmbientOcclusionScale : packoffset(c9);
	    uint _Globals_1_g_tMetalness : packoffset(c9.y);
	    float _Globals_1_g_flInverseBlendTint : packoffset(c9.z);
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
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2620 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2830 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c16);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c17);
	    float4 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1953.z);
	    float4 PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1955.w);
	    _1023 PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1956);
	    _2830 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1988);
	    uint PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1996);
	    uint PerViewLightingConstantBufferGpu_t_1_m20 : packoffset(c1996.y);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c20.z);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c22);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	};
	
	ByteAddressBuffer g_CullBits : register(t30, space3);
	ByteAddressBuffer g_BarnLights : register(t31, space3);
	Texture2D<float4> g_bindless_Texture2D_float4[65536] : register(t46, space4);
	SamplerState g_bindless_Sampler[2048] : register(s29, space4);
	SamplerComparisonState g_bindless_Sampler_1[2048] : register(s29, space4);
	Texture3D<float4> g_bindless_Texture3D_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static bool gl_FrontFacing;
	static float2 input_0;
	static float3 input_1;
	static float3 input_2;
	static float4 input_3;
	static float4 input_4;
	static float4 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float3 input_2 : TEXCOORD2;
	    float4 input_3 : TEXCOORD3;
	    centroid float4 input_4 : TEXCOORD4;
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
	        _10251 = input_2.xyz * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = input_2.xyz;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _10061 = input_1 + PerViewConstantBufferCsgo_t_1_m19.xyz;
	    float4 _19680 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_3.xy);
	    float3 _13737 = _19680.xyz;
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], float2(input_3.zw).xy);
	    float _17476 = _19068.x;
	    float _21709;
	    if (_Globals_1_g_flAmbientOcclusionScale > 0.0f)
	    {
	        _21709 = min(lerp(1.0f, 2.0f * _17476, _Globals_1_g_flAmbientOcclusionScale), 1.0f);
	    }
	    else
	    {
	        _21709 = _17476;
	    }
	    float4 _19069 = g_bindless_Texture2D_float4[_Globals_1_g_tMetalness].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_3.xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_0.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _8418 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
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
	    float3 _12631 = input_2.xyz * (_24327 ? (-1.0f) : 1.0f);
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
	        float3 _7482 = _8418;
	        _7482.y = -_8418.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _8418;
	    }
	    float3 _14786 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    float3 _7978 = -_24347;
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21710;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
	        float2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m9) * PerViewConstantBufferCsgo_t_1_m8.xy) + (PerViewConstantBufferCsgo_t_1_m8.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        float2 _23168;
	        if (_12285)
	        {
	            _23168 = float2(PerViewConstantBufferCsgo_t_1_m8.x, 0.0f);
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
	            _23169 = float2(0.0f, PerViewConstantBufferCsgo_t_1_m8.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        bool2 _13083 = (abs(_18418.y) < (_12286 ? _15372 : _20965)).xx;
	        float4 _10010 = normalize(float4(PerViewLightingConstantBufferGpu_t_1_m2.x * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.y * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.z * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.w * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xy, 0.25f))), 0.5f, 0.5f)));
	        float4 _13232 = max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx) * normalize(clamp(((_10010 - max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)).xxxx) + 0.20000000298023223876953125f.xxxx) * 5.0f.xxxx, 0.0f.xxxx, 1.0f.xxxx));
	        _21710 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11087 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m8.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m8.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float _21711;
	    [branch]
	    if (PerViewLightingConstantBufferGpu_t_1_m10 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        float3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m10))
	            {
	                _13136 = 1.0f;
	                _14975 = 0.0f.xxx;
	                _10191 = -1;
	                break;
	            }
	            float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039], float4(input_1.xyz, 1.0f));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t_1_m12[_13039])
	            {
	                float3 _19470 = float3(_12779, _18322.yz);
	                float2 _24804 = _19470.xy;
	                float2 _22193 = 1.0f.xx - clamp((abs(_24804) * PerViewLightingConstantBufferGpu_t_1_m14.xx) + PerViewLightingConstantBufferGpu_t_1_m13.xx, 0.0f.xx, 1.0f.xx);
	                float2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039].xy;
	                float3 _20488 = _19470;
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
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t_1_m11));
	            float _12501;
	            [branch]
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m10 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335], float4(input_1.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t_1_m11));
	                }
	                else
	                {
	                    _7934 = 1.0f;
	                }
	                _12501 = lerp(_7934, _18270, _13136);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _19363 = _12501;
	        }
	        else
	        {
	            _19363 = 1.0f;
	        }
	        float _13279 = lerp(_19363, 1.0f, saturate((distance(_10061.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m16) + PerViewLightingConstantBufferGpu_t_1_m15));
	        float _12502;
	        if (_24465.y)
	        {
	            _12502 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21711 = _12502;
	    }
	    else
	    {
	        _21711 = 1.0f;
	    }
	    float3 _21712;
	    [branch]
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m8.xyz, _24735) * _21711) > 0.0f)
	    {
	        _21712 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m8.xyz)).xxx.xyz * (PerViewLightingConstantBufferGpu_t_1_m9.xyz * _21711).xyz);
	    }
	    else
	    {
	        _21712 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19364;
	    if (_20060)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m7, float4(_10061.xyz, 1.0f).xyzw);
	        float _20176 = _18621.w;
	        float2 _11414 = _18621.xy / _20176.xx;
	        float4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0f) * PerViewConstantBuffer_t_1_m1.x) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.x - 1.0f);
	        _6651.y = clamp(((1.0f - _11414.y) * PerViewConstantBuffer_t_1_m1.y) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.y - 1.0f);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uint2 _12083 = uint2(_19364.xy - PerViewConstantBuffer_t_1_m0.xy) >> PerViewLightingConstantBufferGpu_t_1_m6.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m5.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t_1_m7.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m7.y)) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    float3 _13155;
	    _13155 = _21712;
	    uint _21567;
	    float3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t_1_m5.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load((_10838 + _16208) * 4 + 0) & g_CullBits.Load((_23393 + _16208) * 4 + 0));
	        _13156 = _13155;
	        uint _20344;
	        float3 _12504;
	        uint _16209 = _14475;
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(firstbitlow(_16209) + (_16208 * 32u));
	            _20344 = _16209 & (_16209 - 1u);
	            do
	            {
	                float4x4 _14097 = asfloat(uint4x4(g_BarnLights.Load(_12608 * 480 + 0), g_BarnLights.Load(_12608 * 480 + 16), g_BarnLights.Load(_12608 * 480 + 32), g_BarnLights.Load(_12608 * 480 + 48), g_BarnLights.Load(_12608 * 480 + 4), g_BarnLights.Load(_12608 * 480 + 20), g_BarnLights.Load(_12608 * 480 + 36), g_BarnLights.Load(_12608 * 480 + 52), g_BarnLights.Load(_12608 * 480 + 8), g_BarnLights.Load(_12608 * 480 + 24), g_BarnLights.Load(_12608 * 480 + 40), g_BarnLights.Load(_12608 * 480 + 56), g_BarnLights.Load(_12608 * 480 + 12), g_BarnLights.Load(_12608 * 480 + 28), g_BarnLights.Load(_12608 * 480 + 44), g_BarnLights.Load(_12608 * 480 + 60)));
	                float4 _24893 = mul(float4(input_1.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
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
	                bool _12887;
	                if (!_7425)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(input_1.xyz, 1.0f), _16509).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float _23571 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) - _18492, (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21775 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21775) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz - input_1.xyz;
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
	                    _11179 = _10017 / _17647.xxx;
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w))) * saturate(asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).y * _17647))) * saturate(asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).y * dot(float3((1.0f - (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11179 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz;
	                    _11633 = _19667;
	                }
	                float3 _17828 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).xyz * 1.0f).xyz * _11633;
	                bool _24419;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).z > 0.0f)
	                {
	                    _24419 = !_20060;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                float3 _21548;
	                [branch]
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w == 0.0f)
	                {
	                    float _10342;
	                    do
	                    {
	                        float2 _22154 = abs(_22905.xy);
	                        if (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z == 0.0f)
	                        {
	                            _10342 = smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x, _22154.x) * smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0f / asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
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
	                    float3 _12503;
	                    if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w < 0.0f)
	                    {
	                        float4 _17795 = float4(-asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).xyz, asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w);
	                        float4 _19008 = _17795.xyzw * float4(-1.0f, -1.0f, -1.0f, 1.0f);
	                        float3 _24989 = _19008.xyz;
	                        float3 _23629 = float4((-_11179).xyz, 0.0f).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        float3 _20479 = float4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        float3 _23592 = _17795.xyz;
	                        float3 _12170 = ((_20479 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20564 = (_14081.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _20491.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _20490.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float3 _19630;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load(_12608 * 480 + 264) & 4u) != 0u)
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
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t_1_m11)), asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
	                    float3 _16449 = _20482.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
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
	                _12504 = _13156.xyz + (max(0.0f, dot(_14786.xyz, _11179.xyz)).xxx.xyz * _19630.xyz);
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
	    float3 _22686 = (_13155.xyz + (float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz * (_21710 * _21709).xxx.xyz).xyz) * (lerp(_13737, _13737 * input_4.xyz, saturate(_19680.w + _Globals_1_g_flInverseBlendTint).xxx).xyz * (1.0f - _19069.y)).xyz;
	    float4 _11204 = float4(_22686, input_4.w);
	    _11204.x = _22686.x;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _10666 = _10061.xyz - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _10666.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _10666.xyz;
	            bool _12888;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m13.x)
	            {
	                _12888 = (_10061.z * PerViewConstantBufferCsgo_t_1_m13.z) < PerViewConstantBufferCsgo_t_1_m13.y;
	            }
	            else
	            {
	                _12888 = false;
	            }
	            [branch]
	            if (_12888)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m10.xy + (PerViewConstantBufferCsgo_t_1_m10.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m11.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m11.y)) * PerViewConstantBufferCsgo_t_1_m12.w;
	                _19340 = lerp(_11204.xyz, float4(PerViewConstantBufferCsgo_t_1_m12.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _11204.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _11204;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12889;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m17.x)
	            {
	                _12889 = (PerViewConstantBufferCsgo_t_1_m17.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m17.y;
	            }
	            else
	            {
	                _12889 = false;
	            }
	            if (_12889)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m14.y) + PerViewConstantBufferCsgo_t_1_m14.x), PerViewConstantBufferCsgo_t_1_m14.w)) * saturate(pow(max(0.0f, (_10061.z * PerViewConstantBufferCsgo_t_1_m15.y) + PerViewConstantBufferCsgo_t_1_m15.x), PerViewConstantBufferCsgo_t_1_m15.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m17.w;
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m16).xyz).xyz, PerViewConstantBufferCsgo_t_1_m15.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m14.z))) * PerViewConstantBufferCsgo_t_1_m18.x).xyz, _8892).xyz, _8892.xxx);
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
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	BoolAttribute(overlay, (F_TRANSLUCENT && F_DEPTH_BIAS) ? 1 : 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	FloatAttribute(OcclusionCullingBoundsScale, F_DEPTH_BIAS ? 1.3 : 1);
	
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SPECULAR_INDIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_SPECULAR_DIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_MODE_TOOLS_VIS == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(BlendEnable, true);
	RenderState(BlendEnable0, true);
	RenderState(BlendEnable1, true);
	RenderState(BlendEnable2, true);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, F_DEPTH_BIAS ? -64 : 0);
	RenderState(DepthBiasClamp, F_DEPTH_BIAS ? -.0005 : 0);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthFunc, Equal);
	RenderState(DepthWriteEnable, false);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(DstBlend0, One);
	RenderState(DstBlend1, One);
	RenderState(DstBlend2, One);
	RenderState(DstBlendAlpha0, One);
	RenderState(DstBlendAlpha1, One);
	RenderState(DstBlendAlpha2, One);
	RenderState(SlopeScaleDepthBias, F_DEPTH_BIAS ? -2 : 0);
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
	
	#if (S_ALPHA_TEST == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_TRANSLUCENT == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, false);
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, false);
	#endif
	
	// Variant parameters
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_FORCE_UV2, F_FORCE_UV2 );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_FORCE_UV2 ) );
	StaticComboRule( Requires( S_SHADER_QUALITY, S_MODE_TOOLS_VIS ) );
	StaticComboRule( Allow0( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	float g_flInverseBlendTint < UiType(Slider); Expression(F_NOTINT ? -1 : 1-(F_TINT_MASK ? 1 : 0)); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE ? 1 : 0); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flNormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vNormalTexCoordScale.x,-v2*g_vNormalTexCoordScale.y,0,g_vNormalTexCoordCenter.x+g_vNormalTexCoordOffset.x+v2*g_vNormalTexCoordScale.y*g_vNormalTexCoordCenter.y-v1*g_vNormalTexCoordScale.x*g_vNormalTexCoordCenter.x)); >;
	float4 g_vNormalTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flNormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vNormalTexCoordScale.x,v1*g_vNormalTexCoordScale.y,0,g_vNormalTexCoordCenter.y+g_vNormalTexCoordOffset.y+v2*g_vNormalTexCoordScale.x*g_vNormalTexCoordCenter.x-v1*g_vNormalTexCoordScale.y*g_vNormalTexCoordCenter.y)); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression(pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,g_vTexCoordCenter.x+g_vTexCoordOffset.x+v2*g_vTexCoordCenter.y-v1*g_vTexCoordCenter.x)); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,g_vTexCoordCenter.y+g_vTexCoordOffset.y-(v2*g_vTexCoordCenter.x+v1*g_vTexCoordCenter.y))); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// Decal Texture
	bool g_bUseSecondaryUvForDecal < Default(1); UiType(CheckBox); UiGroup("Decal Texture, 180"); >;
	CreateInputTexture2D(TextureDecal, Srgb, 8, "", "_decal", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDecalTranslucency, Linear, 8, "", "_trans", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailMask < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 180"); >;
	bool g_bUseSecondaryUvForDetailTexture < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 170"); >;
	CreateInputTexture2D(TextureDetail, Linear, 8, "Mod2XCenter", "_detail", "Detail Texture,80/10", Default4(1, 1, 1, 1));
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = g_flDetailTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		-.5*v3*float2(v1-v2,v2+v1)+v4+.5); >;
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	float g_flNormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Normal Map,50"); >;
	float2 g_vNormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Normal Map,30"); >;
	float2 g_vNormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Normal Map,60"); >;
	float2 g_vNormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Normal Map,40"); >;
	
	// Self Illum
	bool g_bUseSecondaryUvForSelfIllum < UiType(CheckBox); UiGroup("Self Illum,100"); >;
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
	#extension GL_EXT_shader_16bit_storage : require
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
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
	
	struct VS_INPUT
	{
	    vec3 vPositionOs;
	    vec2 vTexCoord;
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
	};
	
	struct PackedRtxInstanceData_t_natural
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct _Array_natural_vector_int_4_8
	{
	    ivec4 data[8];
	};
	
	struct GeometryInfo_t_natural
	{
	    ivec4 m_nVertexAndIndexBuffers;
	    ivec4 m_nBufferBindOffsetBytes;
	    ivec4 m_nBufferStrideInBytes;
	    ivec4 m_vNormalFieldInfo;
	    ivec4 m_vTangentFieldInfo;
	    _Array_natural_vector_int_4_8 m_vTexCoordFieldInfo;
	    _Array_natural_vector_int_4_8 m_vColorFieldInfo;
	};
	
	struct BuiltInTriangleIntersectionAttributes
	{
	    vec2 barycentrics;
	};
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vNormalWs;
	    float16_t flMetalness;
	    f16vec3 vAlbedo;
	    float16_t flRoughness;
	    f16vec3 vEmissive;
	    float16_t flReflectance;
	    uint nMaterialTypeAndFlags;
	    f16vec4 vMaterialBits;
	};
	
	struct Payload_t
	{
	    vec3 vSmoothPositionWs;
	    vec3 vFaceNormalWs;
	    vec3 vInterpolatedNormalWs;
	    float flHitT;
	    float flOpacityRng;
	    int nInstance;
	    bool bFlippedNormal;
	    MaterialDataMinimal_t material;
	};
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData
	{
	    float _member0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    int _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    uint _member0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_Geometries
	{
	    GeometryInfo_t_natural _member0[];
	} g_Geometries_1;
	
	layout(set = 3, binding = 33, std430) readonly buffer g_Indices
	{
	    uint _member0[];
	} g_Indices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices
	{
	    float _member0[];
	} g_Vertices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices_2
	{
	    uint _member0[];
	} g_Vertices_3[];
	
	struct SLANG_ParameterGroup_PerViewConstantBuffer_t_natural
	{
	    mat4 g_matWorldToProjection;
	    mat4 g_matProjectionToWorld;
	    mat4 g_matWorldToView;
	    mat4 g_matViewToProjection;
	    vec4 g_vInvProjLowerRight2x2;
	    vec4 g_vClipPlane0;
	    float g_flToneMapScalarLinear;
	    float g_flInvToneMapScalarLinear;
	    float g_flRealTime;
	    float g_flGameTime;
	    vec2 g_vViewportToGBufferRatio;
	    float g_fInvViewportZRange;
	    float g_fMinViewportZScaled;
	    vec2 g_vViewportOffset;
	    vec2 g_vViewportSize;
	    vec2 g_vInvViewportSize;
	    vec2 g_vRenderTargetSize;
	    vec4 g_vInvGBufferSize;
	    float g_flViewportMinZ;
	    float g_flViewportMaxZ;
	    float g_flNearPlane;
	    float g_flFarPlane;
	    vec4 g_vWorldToCameraOffset;
	    vec4 g_vCameraAngles;
	    vec3 g_vCameraPositionWs;
	    float _PerViewPad0;
	    vec3 g_vCameraUpDirWs;
	    float _PerViewPad1;
	    vec3 g_vCameraDirWs;
	    float g_flInvMSAASampleCount;
	    vec3 g_vDepthPsToVsConversion;
	    int g_nMSAASampleCount;
	    vec2 g_vMorphTextureAtlasSize;
	    uint g_tCompositeMorphAtlasTextureIndex;
	    float _PerViewPad4;
	    vec3 g_vFogColor;
	    float g_flNegFogStartOverFogRange;
	    float g_flInvFogRange;
	    float g_flFogMaxDensity;
	    float g_flFogExponent;
	    float g_flFogBlendToBackground;
	    vec4 g_vFrameBufferCopyInvSizeAndUvScale;
	    vec4 g_vPrevWorldToCameraOffset;
	    mat4 g_matPrevWorldToProjection;
	    vec4 g_vWireframeColor;
	};
	
	layout(set = 5) uniform SLANG_ParameterGroup_PerViewConstantBuffer_t_natural PerViewConstantBuffer_t;
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes attrs;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	
	void main()
	{
	    uint _471 = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    vec4 _515 = vec4(g_MaterialData_1._member0[(_471 + 112u) / 4u], g_MaterialData_1._member0[(_471 + 116u) / 4u], g_MaterialData_1._member0[(_471 + 120u) / 4u], g_MaterialData_1._member0[(_471 + 124u) / 4u]);
	    vec4 _514 = vec4(g_MaterialData_1._member0[(_471 + 128u) / 4u], g_MaterialData_1._member0[(_471 + 132u) / 4u], g_MaterialData_1._member0[(_471 + 136u) / 4u], g_MaterialData_1._member0[(_471 + 140u) / 4u]);
	    vec2 _513 = vec2(g_MaterialData_1._member0[(_471 + 144u) / 4u], g_MaterialData_1._member0[(_471 + 148u) / 4u]);
	    vec3 _512 = vec3(g_MaterialData_1._member0[(_471 + 208u) / 4u], g_MaterialData_1._member0[(_471 + 212u) / 4u], g_MaterialData_1._member0[(_471 + 216u) / 4u]);
	    float _511 = g_MaterialData_1._member0[(_471 + 220u) / 4u];
	    vec4 _510 = vec4(g_MaterialData_1._member0[(_471 + 272u) / 4u], g_MaterialData_1._member0[(_471 + 276u) / 4u], g_MaterialData_1._member0[(_471 + 280u) / 4u], g_MaterialData_1._member0[(_471 + 284u) / 4u]);
	    vec4 _509 = vec4(g_MaterialData_1._member0[(_471 + 288u) / 4u], g_MaterialData_1._member0[(_471 + 292u) / 4u], g_MaterialData_1._member0[(_471 + 296u) / 4u], g_MaterialData_1._member0[(_471 + 300u) / 4u]);
	    bool _508 = g_MaterialData_3._member0[(_471 + 308u) / 4u] != 0;
	    bool _507 = g_MaterialData_3._member0[(_471 + 312u) / 4u] != 0;
	    uint _506 = g_MaterialData_5._member0[(_471 + 348u) / 4u];
	    uint _505 = g_MaterialData_5._member0[(_471 + 352u) / 4u];
	    uint _504 = g_MaterialData_5._member0[(_471 + 356u) / 4u];
	    uint _503 = g_MaterialData_5._member0[(_471 + 360u) / 4u];
	    uint _502 = g_MaterialData_5._member0[(_471 + 380u) / 4u];
	    float _501 = g_MaterialData_1._member0[(_471 + 384u) / 4u];
	    uvec3 _601;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _779 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _601 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_779 / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_779 + 4u) / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_779 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _758 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _759 = _758 & 4294967292u;
	            uint _56 = _759 / 4u;
	            uint _59 = (_759 + 4u) / 4u;
	            uint _763 = (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_56] & 4294901760u) >> uint(16);
	            uint _764 = g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_59] & 65535u;
	            uvec3 _602;
	            if (_758 == _759)
	            {
	                _602 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_56] & 65535u, _763, _764);
	            }
	            else
	            {
	                _602 = uvec3(_763, _764, (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_59] & 4294901760u) >> uint(16));
	            }
	            _601 = _602;
	            break;
	        }
	        break;
	    } while(false);
	    uint _72 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _801 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _601) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _596[3];
	    uint _803 = _801.x;
	    _596[0] = vec3(g_Vertices_1[nonuniformEXT(_72)]._member0[_803 / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_803 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_803 + 8u) / 4u]);
	    uint _808 = _801.y;
	    _596[1] = vec3(g_Vertices_1[nonuniformEXT(_72)]._member0[_808 / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_808 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_808 + 8u) / 4u]);
	    uint _813 = _801.z;
	    _596[2] = vec3(g_Vertices_1[nonuniformEXT(_72)]._member0[_813 / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_813 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_813 + 8u) / 4u]);
	    int _597 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_597 < 3))
	        {
	            break;
	        }
	        vsInput[_597].vPositionOs = _596[_597];
	        _597++;
	        continue;
	    }
	    vec2 _598[3];
	    _598[0] = vec2(0.0);
	    _598[1] = vec2(0.0);
	    _598[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _595 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _101 = uint(_595[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _855 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _593 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _594 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _871 = (uvec3(uint(_593[_855])) * _601) + uvec3(uint(_594[_855]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _985 = _871.x;
	            _598[0] = vec2(g_Vertices_1[nonuniformEXT(_101)]._member0[_985 / 4u], g_Vertices_1[nonuniformEXT(_101)]._member0[(_985 + 4u) / 4u]);
	            uint _988 = _871.y;
	            _598[1] = vec2(g_Vertices_1[nonuniformEXT(_101)]._member0[_988 / 4u], g_Vertices_1[nonuniformEXT(_101)]._member0[(_988 + 4u) / 4u]);
	            uint _991 = _871.z;
	            _598[2] = vec2(g_Vertices_1[nonuniformEXT(_101)]._member0[_991 / 4u], g_Vertices_1[nonuniformEXT(_101)]._member0[(_991 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _113 = _871.x / 4u;
	                _598[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_101)]._member0[_113], g_Vertices_3[nonuniformEXT(_101)]._member0[_113] >> uint(16)) & uvec2(65535u))));
	                uint _116 = _871.y / 4u;
	                _598[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_101)]._member0[_116], g_Vertices_3[nonuniformEXT(_101)]._member0[_116] >> uint(16)) & uvec2(65535u))));
	                uint _119 = _871.z / 4u;
	                _598[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_101)]._member0[_119], g_Vertices_3[nonuniformEXT(_101)]._member0[_119] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _103 = _871.x / 4u;
	                    uint _884 = g_Vertices_3[nonuniformEXT(_101)]._member0[_103] & 65535u;
	                    int _592;
	                    if (_884 > 32767u)
	                    {
	                        _592 = int(4294901760u | _884);
	                    }
	                    else
	                    {
	                        _592 = int(_884);
	                    }
	                    uint _897 = (g_Vertices_3[nonuniformEXT(_101)]._member0[_103] & 4294901760u) >> uint(16);
	                    int _591;
	                    if (_897 > 32767u)
	                    {
	                        _591 = int(4294901760u | _897);
	                    }
	                    else
	                    {
	                        _591 = int(_897);
	                    }
	                    _598[0] = vec2(max(float(_592) * 3.0518509447574615478515625e-05, -1.0), max(float(_591) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _106 = _871.y / 4u;
	                    uint _911 = g_Vertices_3[nonuniformEXT(_101)]._member0[_106] & 65535u;
	                    int _590;
	                    if (_911 > 32767u)
	                    {
	                        _590 = int(4294901760u | _911);
	                    }
	                    else
	                    {
	                        _590 = int(_911);
	                    }
	                    uint _924 = (g_Vertices_3[nonuniformEXT(_101)]._member0[_106] & 4294901760u) >> uint(16);
	                    int _589;
	                    if (_924 > 32767u)
	                    {
	                        _589 = int(4294901760u | _924);
	                    }
	                    else
	                    {
	                        _589 = int(_924);
	                    }
	                    _598[1] = vec2(max(float(_590) * 3.0518509447574615478515625e-05, -1.0), max(float(_589) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _109 = _871.z / 4u;
	                    uint _938 = g_Vertices_3[nonuniformEXT(_101)]._member0[_109] & 65535u;
	                    int _588;
	                    if (_938 > 32767u)
	                    {
	                        _588 = int(4294901760u | _938);
	                    }
	                    else
	                    {
	                        _588 = int(_938);
	                    }
	                    uint _951 = (g_Vertices_3[nonuniformEXT(_101)]._member0[_109] & 4294901760u) >> uint(16);
	                    int _587;
	                    if (_951 > 32767u)
	                    {
	                        _587 = int(4294901760u | _951);
	                    }
	                    else
	                    {
	                        _587 = int(_951);
	                    }
	                    _598[2] = vec2(max(float(_588) * 3.0518509447574615478515625e-05, -1.0), max(float(_587) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _597 = 0;
	    for (;;)
	    {
	        if (!(_597 < 3))
	        {
	            break;
	        }
	        vsInput[_597].vTexCoord = _598[_597];
	        _597++;
	        continue;
	    }
	    vec3 _599[3];
	    vec4 _600[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _573 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _141 = uint(_573[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _1035 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _571 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _572 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1051 = (uvec3(uint(_571[_1035])) * _601) + uvec3(uint(_572[_1035]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1552 = _1051.x;
	                _599[0] = vec3(g_Vertices_1[nonuniformEXT(_141)]._member0[_1552 / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1552 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1552 + 8u) / 4u]);
	                uint _1557 = _1051.y;
	                _599[1] = vec3(g_Vertices_1[nonuniformEXT(_141)]._member0[_1557 / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1557 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1557 + 8u) / 4u]);
	                uint _1562 = _1051.z;
	                _599[2] = vec3(g_Vertices_1[nonuniformEXT(_141)]._member0[_1562 / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1562 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1562 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1306 = _1051.x;
	                    uvec2 _1308 = uvec2(g_Vertices_3[nonuniformEXT(_141)]._member0[_1306 / 4u], g_Vertices_3[nonuniformEXT(_141)]._member0[(_1306 + 4u) / 4u]);
	                    uint _1309 = _1051.y;
	                    uvec2 _461 = uvec2(g_Vertices_3[nonuniformEXT(_141)]._member0[_1309 / 4u], g_Vertices_3[nonuniformEXT(_141)]._member0[(_1309 + 4u) / 4u]);
	                    uint _1312 = _1051.z;
	                    uvec2 _460 = uvec2(g_Vertices_3[nonuniformEXT(_141)]._member0[_1312 / 4u], g_Vertices_3[nonuniformEXT(_141)]._member0[(_1312 + 4u) / 4u]);
	                    uint _1318 = _1308.x;
	                    uint _1326 = _1308.y;
	                    vec2 _1336 = ((vec2(float(_1318 & 65535u), float((_1318 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1337 = _1336.x;
	                    float _1342 = (1.0 - abs(_1337)) - abs(_1336.y);
	                    vec3 _1343 = vec3(_1337, _1336.y, _1342);
	                    float _1345 = saturate(-_1342);
	                    vec2 _1351 = _1336 + mix(vec2(_1345), vec2(-_1345), greaterThanEqual(_1336, vec2(0.0)));
	                    _1343.x = _1351.x;
	                    _1343.y = _1351.y;
	                    vec3 _575 = normalize(_1343);
	                    vec2 _1358 = ((vec2(float((_1326 >> uint(1)) & 32767u), float((_1326 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1359 = _1358.x;
	                    float _1364 = (1.0 - abs(_1359)) - abs(_1358.y);
	                    vec3 _1365 = vec3(_1359, _1358.y, _1364);
	                    float _1367 = saturate(-_1364);
	                    vec2 _1373 = _1358 + mix(vec2(_1367), vec2(-_1367), greaterThanEqual(_1358, vec2(0.0)));
	                    _1365.x = _1373.x;
	                    _1365.y = _1373.y;
	                    vec3 _574 = normalize(_1365);
	                    float _561;
	                    if ((_1326 & 1u) != 0u)
	                    {
	                        _561 = 1.0;
	                    }
	                    else
	                    {
	                        _561 = -1.0;
	                    }
	                    _599[0] = _575;
	                    _600[0].w = _561;
	                    _600[0].x = _574.x;
	                    _600[0].y = _574.y;
	                    _600[0].z = _574.z;
	                    vec2 _1415 = ((vec2(float(_461.x & 65535u), float((_461.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1416 = _1415.x;
	                    float _1421 = (1.0 - abs(_1416)) - abs(_1415.y);
	                    vec3 _1422 = vec3(_1416, _1415.y, _1421);
	                    float _1424 = saturate(-_1421);
	                    vec2 _1430 = _1415 + mix(vec2(_1424), vec2(-_1424), greaterThanEqual(_1415, vec2(0.0)));
	                    _1422.x = _1430.x;
	                    _1422.y = _1430.y;
	                    vec3 _577 = normalize(_1422);
	                    vec2 _1437 = ((vec2(float((_461.y >> uint(1)) & 32767u), float((_461.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1438 = _1437.x;
	                    float _1443 = (1.0 - abs(_1438)) - abs(_1437.y);
	                    vec3 _1444 = vec3(_1438, _1437.y, _1443);
	                    float _1446 = saturate(-_1443);
	                    vec2 _1452 = _1437 + mix(vec2(_1446), vec2(-_1446), greaterThanEqual(_1437, vec2(0.0)));
	                    _1444.x = _1452.x;
	                    _1444.y = _1452.y;
	                    vec3 _576 = normalize(_1444);
	                    float _560;
	                    if ((_461.y & 1u) != 0u)
	                    {
	                        _560 = 1.0;
	                    }
	                    else
	                    {
	                        _560 = -1.0;
	                    }
	                    _599[1] = _577;
	                    _600[1].w = _560;
	                    _600[1].x = _576.x;
	                    _600[1].y = _576.y;
	                    _600[1].z = _576.z;
	                    vec2 _1494 = ((vec2(float(_460.x & 65535u), float((_460.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1495 = _1494.x;
	                    float _1500 = (1.0 - abs(_1495)) - abs(_1494.y);
	                    vec3 _1501 = vec3(_1495, _1494.y, _1500);
	                    float _1503 = saturate(-_1500);
	                    vec2 _1509 = _1494 + mix(vec2(_1503), vec2(-_1503), greaterThanEqual(_1494, vec2(0.0)));
	                    _1501.x = _1509.x;
	                    _1501.y = _1509.y;
	                    vec3 _579 = normalize(_1501);
	                    vec2 _1516 = ((vec2(float((_460.y >> uint(1)) & 32767u), float((_460.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1517 = _1516.x;
	                    float _1522 = (1.0 - abs(_1517)) - abs(_1516.y);
	                    vec3 _1523 = vec3(_1517, _1516.y, _1522);
	                    float _1525 = saturate(-_1522);
	                    vec2 _1531 = _1516 + mix(vec2(_1525), vec2(-_1525), greaterThanEqual(_1516, vec2(0.0)));
	                    _1523.x = _1531.x;
	                    _1523.y = _1531.y;
	                    vec3 _578 = normalize(_1523);
	                    float _559;
	                    if ((_460.y & 1u) != 0u)
	                    {
	                        _559 = 1.0;
	                    }
	                    else
	                    {
	                        _559 = -1.0;
	                    }
	                    _599[2] = _579;
	                    _600[2].w = _559;
	                    _600[2].x = _578.x;
	                    _600[2].y = _578.y;
	                    _600[2].z = _578.z;
	                    break;
	                }
	                else
	                {
	                    uint _143 = _1051.x / 4u;
	                    vec4 _581 = _600[0];
	                    float _1073 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1076 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1080 = (1.0 - abs(_1073)) - abs(_1076);
	                    vec3 _1081 = vec3(_1073, _1076, _1080);
	                    float _1083 = saturate(-_1080);
	                    vec2 _1084 = vec2(_1073, _1076);
	                    vec2 _1090 = _1084 + mix(vec2(_1083), vec2(-_1083), greaterThanEqual(_1084, vec2(0.0)));
	                    _1081.x = _1090.x;
	                    _1081.y = _1090.y;
	                    vec3 _1095 = normalize(_1081);
	                    vec3 _580 = _1095;
	                    float _1096 = _1095.z;
	                    float _568;
	                    if (_1096 >= 0.0)
	                    {
	                        _568 = 1.0;
	                    }
	                    else
	                    {
	                        _568 = -1.0;
	                    }
	                    float _1103 = (-1.0) / (_568 + _1096);
	                    float _1104 = _1095.x;
	                    vec3 _569;
	                    vec3 _1112 = _569;
	                    _1112.x = 1.0 + (((_568 * _1104) * _1104) * _1103);
	                    _1112.y = _568 * ((_1104 * _1095.y) * _1103);
	                    _1112.z = (-_568) * _1104;
	                    _569 = _1112;
	                    float _1120 = float((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1126 = (_1112 * cos(_1120)) + (cross(_1095, _1112) * sin(_1120));
	                    vec4 _1128 = _581;
	                    _1128.x = _1126.x;
	                    _1128.y = _1126.y;
	                    _1128.z = _1126.z;
	                    _581 = _1128;
	                    float _570;
	                    if ((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] & 1u) == 0u)
	                    {
	                        _570 = -1.0;
	                    }
	                    else
	                    {
	                        _570 = 1.0;
	                    }
	                    vec4 _1139 = _581;
	                    _1139.w = _570;
	                    _581 = _1139;
	                    _599[0] = _580;
	                    _600[0] = _1139;
	                    uint _146 = _1051.y / 4u;
	                    vec4 _583 = _600[1];
	                    float _1155 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1158 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1162 = (1.0 - abs(_1155)) - abs(_1158);
	                    vec3 _1163 = vec3(_1155, _1158, _1162);
	                    float _1165 = saturate(-_1162);
	                    vec2 _1166 = vec2(_1155, _1158);
	                    vec2 _1172 = _1166 + mix(vec2(_1165), vec2(-_1165), greaterThanEqual(_1166, vec2(0.0)));
	                    _1163.x = _1172.x;
	                    _1163.y = _1172.y;
	                    vec3 _1177 = normalize(_1163);
	                    vec3 _582 = _1177;
	                    float _1178 = _1177.z;
	                    float _565;
	                    if (_1178 >= 0.0)
	                    {
	                        _565 = 1.0;
	                    }
	                    else
	                    {
	                        _565 = -1.0;
	                    }
	                    float _1185 = (-1.0) / (_565 + _1178);
	                    float _1186 = _1177.x;
	                    vec3 _566;
	                    vec3 _1194 = _566;
	                    _1194.x = 1.0 + (((_565 * _1186) * _1186) * _1185);
	                    _1194.y = _565 * ((_1186 * _1177.y) * _1185);
	                    _1194.z = (-_565) * _1186;
	                    _566 = _1194;
	                    float _1202 = float((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1208 = (_1194 * cos(_1202)) + (cross(_1177, _1194) * sin(_1202));
	                    vec4 _1210 = _583;
	                    _1210.x = _1208.x;
	                    _1210.y = _1208.y;
	                    _1210.z = _1208.z;
	                    _583 = _1210;
	                    float _567;
	                    if ((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] & 1u) == 0u)
	                    {
	                        _567 = -1.0;
	                    }
	                    else
	                    {
	                        _567 = 1.0;
	                    }
	                    vec4 _1221 = _583;
	                    _1221.w = _567;
	                    _583 = _1221;
	                    _599[1] = _582;
	                    _600[1] = _1221;
	                    uint _149 = _1051.z / 4u;
	                    vec4 _585 = _600[2];
	                    float _1237 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1240 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1244 = (1.0 - abs(_1237)) - abs(_1240);
	                    vec3 _1245 = vec3(_1237, _1240, _1244);
	                    float _1247 = saturate(-_1244);
	                    vec2 _1248 = vec2(_1237, _1240);
	                    vec2 _1254 = _1248 + mix(vec2(_1247), vec2(-_1247), greaterThanEqual(_1248, vec2(0.0)));
	                    _1245.x = _1254.x;
	                    _1245.y = _1254.y;
	                    vec3 _1259 = normalize(_1245);
	                    vec3 _584 = _1259;
	                    float _1260 = _1259.z;
	                    float _562;
	                    if (_1260 >= 0.0)
	                    {
	                        _562 = 1.0;
	                    }
	                    else
	                    {
	                        _562 = -1.0;
	                    }
	                    float _1267 = (-1.0) / (_562 + _1260);
	                    float _1268 = _1259.x;
	                    vec3 _563;
	                    vec3 _1276 = _563;
	                    _1276.x = 1.0 + (((_562 * _1268) * _1268) * _1267);
	                    _1276.y = _562 * ((_1268 * _1259.y) * _1267);
	                    _1276.z = (-_562) * _1268;
	                    _563 = _1276;
	                    float _1284 = float((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1290 = (_1276 * cos(_1284)) + (cross(_1259, _1276) * sin(_1284));
	                    vec4 _1292 = _585;
	                    _1292.x = _1290.x;
	                    _1292.y = _1290.y;
	                    _1292.z = _1290.z;
	                    _585 = _1292;
	                    float _564;
	                    if ((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] & 1u) == 0u)
	                    {
	                        _564 = -1.0;
	                    }
	                    else
	                    {
	                        _564 = 1.0;
	                    }
	                    vec4 _1303 = _585;
	                    _1303.w = _564;
	                    _585 = _1303;
	                    _599[2] = _584;
	                    _600[2] = _1303;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _599[0] = vec3(0.0);
	            _599[1] = vec3(0.0);
	            _599[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _586 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _199 = uint(_586[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1581 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _557 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _558 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1597 = (uvec3(uint(_557[_1581])) * _601) + uvec3(uint(_558[_1581]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1599 = _1597.x;
	            _600[0] = vec4(g_Vertices_1[nonuniformEXT(_199)]._member0[_1599 / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1599 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1599 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1599 + 12u) / 4u]);
	            uint _1605 = _1597.y;
	            _600[1] = vec4(g_Vertices_1[nonuniformEXT(_199)]._member0[_1605 / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1605 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1605 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1605 + 12u) / 4u]);
	            uint _1611 = _1597.z;
	            _600[2] = vec4(g_Vertices_1[nonuniformEXT(_199)]._member0[_1611 / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1611 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1611 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1611 + 12u) / 4u]);
	        }
	        else
	        {
	            _600[0] = vec4(0.0);
	            _600[1] = vec4(0.0);
	            _600[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _597 = 0;
	    for (;;)
	    {
	        if (!(_597 < 3))
	        {
	            break;
	        }
	        vsInput[_597].vNormalOs = _599[_597];
	        vsInput[_597].vTangentUOs_flTangentVSign = _600[_597];
	        _597++;
	        continue;
	    }
	    vec2 _470 = vsInput[0].vTexCoord;
	    vec3 _555 = vsInput[0].vNormalOs;
	    vec4 _556;
	    vec4 _1645 = _556;
	    _1645.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1645.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1645.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1645.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _556 = _1645;
	    vec4 _1668 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _554 = _1668;
	    vec3 _1669 = _1668.xyz;
	    vec3 _1670 = _1669 * vec3(0.077399380505084991455078125);
	    vec3 _1673 = pow((_1669 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _551;
	    if (_1668.x <= 0.040449999272823333740234375)
	    {
	        _551 = _1670.x;
	    }
	    else
	    {
	        _551 = _1673.x;
	    }
	    float _552;
	    if (_1668.y <= 0.040449999272823333740234375)
	    {
	        _552 = _1670.y;
	    }
	    else
	    {
	        _552 = _1673.y;
	    }
	    float _553;
	    if (_1668.z <= 0.040449999272823333740234375)
	    {
	        _553 = _1670.z;
	    }
	    else
	    {
	        _553 = _1673.z;
	    }
	    vec3 _1698 = vec3(_551, _552, _553);
	    vec4 _1700 = _554;
	    _1700.x = _1698.x;
	    _1700.y = _1698.y;
	    _1700.z = _1698.z;
	    _554 = _1700;
	    vec4 _473;
	    vec4 _1707 = _473;
	    _1707.x = _1700.x;
	    _1707.y = _1700.y;
	    _1707.z = _1700.z;
	    _1707.w = _1700.w;
	    _473 = _1707;
	    mat3x4 _1718 = transpose(gl_WorldToObjectEXT);
	    mat3 _550;
	    mat3 _1721 = _550;
	    _1721[0] = _1718[0].xyz;
	    _1721[1] = _1718[1].xyz;
	    _1721[2] = _1718[2].xyz;
	    _550 = _1721;
	    vec3 _1730 = normalize(_1721 * _555.xyz);
	    vec3 _474;
	    vec3 _1732 = _474;
	    _1732.x = _1730.x;
	    _1732.y = _1730.y;
	    _1732.z = _1730.z;
	    _474 = _1732;
	    mat3x4 _1744 = transpose(gl_WorldToObjectEXT);
	    mat3 _549;
	    mat3 _1747 = _549;
	    _1747[0] = _1744[0].xyz;
	    _1747[1] = _1744[1].xyz;
	    _1747[2] = _1744[2].xyz;
	    _549 = _1747;
	    vec3 _1756 = normalize(_1747 * _556.xyz);
	    vec4 _472;
	    vec4 _1758 = _472;
	    _1758.x = _1756.x;
	    _1758.y = _1756.y;
	    _1758.z = _1756.z;
	    _1758.w = _556.w;
	    _472 = _1758;
	    vec4 _1767 = _470.xyxy;
	    vec2 _475;
	    vec2 _1768 = _475;
	    vec4 _1781 = _1767;
	    _1781.x = dot(_1767.xy, _515.xy) + _515.w;
	    _1781.y = dot(_1767.xy, _514.xy) + _514.w;
	    vec2 _1789 = _1781.xy + (_513.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1791 = _1781;
	    _1791.x = _1789.x;
	    _1791.y = _1789.y;
	    vec3 _1797 = mix(vec3(1.0), _1707.xyz, vec3(_511));
	    vec4 _1799 = _1707;
	    _1799.x = _1797.x;
	    _1799.y = _1797.y;
	    _1799.z = _1797.z;
	    vec3 _1807 = _1799.xyz * _512.xyz;
	    vec4 _1809 = _1799;
	    _1809.x = _1807.x;
	    _1809.y = _1807.y;
	    _1809.z = _1807.z;
	    _1768.x = dot(_470.xy, _510.xy) + _510.w;
	    _1768.y = dot(_470.xy, _509.xy) + _509.w;
	    vec2 _459 = _1768;
	    vec3 _458 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _457 = _1732;
	    vec4 _456 = _1791;
	    vec4 _455 = _1809;
	    vec4 _454 = _1758;
	    vec2 _469 = vsInput[1].vTexCoord;
	    vec3 _547 = vsInput[1].vNormalOs;
	    vec4 _548;
	    vec4 _1834 = _548;
	    _1834.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _1834.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _1834.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _1834.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _548 = _1834;
	    vec4 _1857 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _546 = _1857;
	    vec3 _1858 = _1857.xyz;
	    vec3 _1859 = _1858 * vec3(0.077399380505084991455078125);
	    vec3 _1862 = pow((_1858 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _543;
	    if (_1857.x <= 0.040449999272823333740234375)
	    {
	        _543 = _1859.x;
	    }
	    else
	    {
	        _543 = _1862.x;
	    }
	    float _544;
	    if (_1857.y <= 0.040449999272823333740234375)
	    {
	        _544 = _1859.y;
	    }
	    else
	    {
	        _544 = _1862.y;
	    }
	    float _545;
	    if (_1857.z <= 0.040449999272823333740234375)
	    {
	        _545 = _1859.z;
	    }
	    else
	    {
	        _545 = _1862.z;
	    }
	    vec3 _1887 = vec3(_543, _544, _545);
	    vec4 _1889 = _546;
	    _1889.x = _1887.x;
	    _1889.y = _1887.y;
	    _1889.z = _1887.z;
	    _546 = _1889;
	    vec4 _477;
	    vec4 _1896 = _477;
	    _1896.x = _1889.x;
	    _1896.y = _1889.y;
	    _1896.z = _1889.z;
	    _1896.w = _1889.w;
	    _477 = _1896;
	    mat3x4 _1907 = transpose(gl_WorldToObjectEXT);
	    mat3 _542;
	    mat3 _1910 = _542;
	    _1910[0] = _1907[0].xyz;
	    _1910[1] = _1907[1].xyz;
	    _1910[2] = _1907[2].xyz;
	    _542 = _1910;
	    vec3 _1919 = normalize(_1910 * _547.xyz);
	    vec3 _478;
	    vec3 _1921 = _478;
	    _1921.x = _1919.x;
	    _1921.y = _1919.y;
	    _1921.z = _1919.z;
	    _478 = _1921;
	    mat3x4 _1933 = transpose(gl_WorldToObjectEXT);
	    mat3 _541;
	    mat3 _1936 = _541;
	    _1936[0] = _1933[0].xyz;
	    _1936[1] = _1933[1].xyz;
	    _1936[2] = _1933[2].xyz;
	    _541 = _1936;
	    vec3 _1945 = normalize(_1936 * _548.xyz);
	    vec4 _476;
	    vec4 _1947 = _476;
	    _1947.x = _1945.x;
	    _1947.y = _1945.y;
	    _1947.z = _1945.z;
	    _1947.w = _548.w;
	    _476 = _1947;
	    vec4 _1956 = _469.xyxy;
	    vec2 _479;
	    vec2 _1957 = _479;
	    vec4 _1970 = _1956;
	    _1970.x = dot(_1956.xy, _515.xy) + _515.w;
	    _1970.y = dot(_1956.xy, _514.xy) + _514.w;
	    vec2 _1978 = _1970.xy + (_513.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1980 = _1970;
	    _1980.x = _1978.x;
	    _1980.y = _1978.y;
	    vec3 _1986 = mix(vec3(1.0), _1896.xyz, vec3(_511));
	    vec4 _1988 = _1896;
	    _1988.x = _1986.x;
	    _1988.y = _1986.y;
	    _1988.z = _1986.z;
	    vec3 _1996 = _1988.xyz * _512.xyz;
	    vec4 _1998 = _1988;
	    _1998.x = _1996.x;
	    _1998.y = _1996.y;
	    _1998.z = _1996.z;
	    _1957.x = dot(_469.xy, _510.xy) + _510.w;
	    _1957.y = dot(_469.xy, _509.xy) + _509.w;
	    vec2 _453 = _1957;
	    vec3 _452 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _451 = _1921;
	    vec4 _450 = _1980;
	    vec4 _449 = _1998;
	    vec4 _448 = _1947;
	    vec2 _468 = vsInput[2].vTexCoord;
	    vec3 _539 = vsInput[2].vNormalOs;
	    vec4 _540;
	    vec4 _2023 = _540;
	    _2023.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _2023.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _2023.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _2023.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _540 = _2023;
	    vec4 _2046 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _538 = _2046;
	    vec3 _2047 = _2046.xyz;
	    vec3 _2048 = _2047 * vec3(0.077399380505084991455078125);
	    vec3 _2051 = pow((_2047 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _535;
	    if (_2046.x <= 0.040449999272823333740234375)
	    {
	        _535 = _2048.x;
	    }
	    else
	    {
	        _535 = _2051.x;
	    }
	    float _536;
	    if (_2046.y <= 0.040449999272823333740234375)
	    {
	        _536 = _2048.y;
	    }
	    else
	    {
	        _536 = _2051.y;
	    }
	    float _537;
	    if (_2046.z <= 0.040449999272823333740234375)
	    {
	        _537 = _2048.z;
	    }
	    else
	    {
	        _537 = _2051.z;
	    }
	    vec3 _2076 = vec3(_535, _536, _537);
	    vec4 _2078 = _538;
	    _2078.x = _2076.x;
	    _2078.y = _2076.y;
	    _2078.z = _2076.z;
	    _538 = _2078;
	    vec4 _481;
	    vec4 _2085 = _481;
	    _2085.x = _2078.x;
	    _2085.y = _2078.y;
	    _2085.z = _2078.z;
	    _2085.w = _2078.w;
	    _481 = _2085;
	    mat3x4 _2096 = transpose(gl_WorldToObjectEXT);
	    mat3 _534;
	    mat3 _2099 = _534;
	    _2099[0] = _2096[0].xyz;
	    _2099[1] = _2096[1].xyz;
	    _2099[2] = _2096[2].xyz;
	    _534 = _2099;
	    vec3 _2108 = normalize(_2099 * _539.xyz);
	    vec3 _482;
	    vec3 _2110 = _482;
	    _2110.x = _2108.x;
	    _2110.y = _2108.y;
	    _2110.z = _2108.z;
	    _482 = _2110;
	    vec3 _2118 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2122 = transpose(gl_WorldToObjectEXT);
	    mat3 _533;
	    mat3 _2125 = _533;
	    _2125[0] = _2122[0].xyz;
	    _2125[1] = _2122[1].xyz;
	    _2125[2] = _2122[2].xyz;
	    _533 = _2125;
	    vec3 _2134 = normalize(_2125 * _540.xyz);
	    vec4 _480;
	    vec4 _2136 = _480;
	    _2136.x = _2134.x;
	    _2136.y = _2134.y;
	    _2136.z = _2134.z;
	    _2136.w = _540.w;
	    _480 = _2136;
	    vec4 _2145 = _468.xyxy;
	    vec2 _483;
	    vec2 _2146 = _483;
	    vec4 _2159 = _2145;
	    _2159.x = dot(_2145.xy, _515.xy) + _515.w;
	    _2159.y = dot(_2145.xy, _514.xy) + _514.w;
	    vec2 _2167 = _2159.xy + (_513.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2169 = _2159;
	    _2169.x = _2167.x;
	    _2169.y = _2167.y;
	    vec3 _2175 = mix(vec3(1.0), _2085.xyz, vec3(_511));
	    vec4 _2177 = _2085;
	    _2177.x = _2175.x;
	    _2177.y = _2175.y;
	    _2177.z = _2175.z;
	    vec3 _2185 = _2177.xyz * _512.xyz;
	    vec4 _2187 = _2177;
	    _2187.x = _2185.x;
	    _2187.y = _2185.y;
	    _2187.z = _2185.z;
	    _2146.x = dot(_468.xy, _510.xy) + _510.w;
	    _2146.y = dot(_468.xy, _509.xy) + _509.w;
	    vec3 _447 = _2118;
	    vec3 _446 = _2110;
	    vec3 _2227 = ((_457 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_451 * attrs.barycentrics.x)) + (_2110 * attrs.barycentrics.y);
	    vec2 _467 = ((_459 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_453 * attrs.barycentrics.x)) + (_2146 * attrs.barycentrics.y);
	    vec3 _466 = _2227;
	    vec4 _465 = ((_456 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_450 * attrs.barycentrics.x)) + (_2169 * attrs.barycentrics.y);
	    vec4 _464 = ((_455 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_449 * attrs.barycentrics.x)) + (_2187 * attrs.barycentrics.y);
	    vec4 _463 = ((_454 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_448 * attrs.barycentrics.x)) + (_2136 * attrs.barycentrics.y);
	    bool _462 = gl_HitKindEXT == 254u;
	    vec2 _500 = vec2(0.5);
	    float _499 = 0.0;
	    vec3 _498 = vec3(0.0);
	    float _497 = 0.039999999105930328369140625;
	    vec3 _496 = vec3(0.0);
	    bool _493 = false;
	    vec3 _495 = _2227.xyz;
	    vec3 _494 = normalize(cross(_452 - _458, _2118 - _458));
	    bool _531;
	    if (_507)
	    {
	        _531 = !_508;
	    }
	    else
	    {
	        _531 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_531)
	    {
	        float _532;
	        if (_462)
	        {
	            _532 = 1.0;
	        }
	        else
	        {
	            _532 = -1.0;
	        }
	        _495 *= _532;
	        if (_462)
	        {
	            _532 = 1.0;
	        }
	        else
	        {
	            _532 = -1.0;
	        }
	        _494 *= _532;
	        _493 = !_462;
	    }
	    vec3 _2294 = _495;
	    vec3 _2295 = normalize(_2294);
	    _495 = _2295;
	    vec2 _491 = _500;
	    float _490 = _499;
	    vec3 _489 = _498;
	    float _488 = _497;
	    vec3 _487 = _496;
	    vec3 _486 = _2295;
	    vec3 _485 = _494;
	    bool _484 = _493;
	    vec4 _2308 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_504], g_bindless_Sampler[_505])), _465.xy, 0.0);
	    vec3 _2309 = _2308.xyz;
	    vec3 _492 = mix(_2309, _2309 * _464.xyz, vec3(saturate(_2308.w + _501)));
	    _490 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_502], g_bindless_Sampler[_506])), _465.xy, 0.0).y;
	    vec4 _2330 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_503], g_bindless_Sampler[_506])), _467.xy, 0.0);
	    float _2331 = _2330.x;
	    float _2332 = _2330.y;
	    float _2334 = (_2331 + _2332) - 1.00392162799835205078125;
	    float _2335 = _2331 - _2332;
	    _491 = _2330.zz;
	    vec3 _529 = normalize(vec3(vec2(_2334, _2335), (1.0 - abs(_2334)) - abs(_2335)));
	    bool _527;
	    if (_507)
	    {
	        _527 = !_508;
	    }
	    else
	    {
	        _527 = false;
	    }
	    if (_527)
	    {
	        float _528;
	        if (_462)
	        {
	            _528 = 1.0;
	        }
	        else
	        {
	            _528 = -1.0;
	        }
	        _527 = _528 < 0.0;
	    }
	    else
	    {
	        _527 = false;
	    }
	    float _530;
	    if (_527)
	    {
	        _530 = -1.0;
	    }
	    else
	    {
	        _530 = 1.0;
	    }
	    float _2366 = _530;
	    vec3 _2367 = _466.xyz * _2366;
	    if (_463.w > 0.0)
	    {
	        _530 = 1.0;
	    }
	    else
	    {
	        _530 = -1.0;
	    }
	    bool _525;
	    if (_507)
	    {
	        _525 = !_508;
	    }
	    else
	    {
	        _525 = false;
	    }
	    if (_525)
	    {
	        float _526;
	        if (_462)
	        {
	            _526 = 1.0;
	        }
	        else
	        {
	            _526 = -1.0;
	        }
	        _525 = _526 < 0.0;
	    }
	    else
	    {
	        _525 = false;
	    }
	    if (!_525)
	    {
	        vec3 _2399 = _529;
	        _2399.y = -_2399.y;
	        _529 = _2399;
	    }
	    vec3 _2406 = _463.xyz * _529.x;
	    vec3 _524;
	    vec3 _2408 = _524;
	    _2408.x = _2406.x;
	    _2408.y = _2406.y;
	    _2408.z = _2406.z;
	    vec3 _2418 = _2408.xyz + ((cross(_2367.xyz, _463.xyz) * _530).xyz * _529.y);
	    vec3 _2420 = _2408;
	    _2420.x = _2418.x;
	    _2420.y = _2418.y;
	    _2420.z = _2418.z;
	    vec3 _2429 = _2420.xyz + (_2367.xyz * _529.z);
	    vec3 _2431 = _2420;
	    _2431.x = _2429.x;
	    _2431.y = _2429.y;
	    _2431.z = _2429.z;
	    _524 = _2431;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _485;
	    payload.vInterpolatedNormalWs = _486;
	    vec3 _522[3] = vec3[](_458, _452, _447);
	    vec3 _523[3] = vec3[](_457, _451, _446);
	    vec3 _2478 = ((_522[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_522[1] * attrs.barycentrics.x)) + (_522[2] * attrs.barycentrics.y);
	    vec3 _516[3];
	    _516[0] = _2478 - (_523[0] * dot(_2478 - _522[0], _523[0]));
	    _516[1] = _2478 - (_523[1] * dot(_2478 - _522[1], _523[1]));
	    _516[2] = _2478 - (_523[2] * dot(_2478 - _522[2], _523[2]));
	    vec3 _2518 = ((_516[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_516[1] * attrs.barycentrics.x)) + (_516[2] * attrs.barycentrics.y);
	    vec3 _517[3];
	    _517[0] = cross(_522[0] - _522[1], _485);
	    _517[1] = cross(_522[1] - _522[2], _485);
	    _517[2] = cross(_522[2] - _522[0], _485);
	    float _518 = dot(_2518 - _2478, _485);
	    vec3 _519 = _2518;
	    int _520 = 0;
	    for (;;)
	    {
	        bool _2534_ladder_break = false;
	        do
	        {
	            if (!(_520 < 3))
	            {
	                _2534_ladder_break = true;
	                break;
	            }
	            if (_518 > 0.00999999977648258209228515625)
	            {
	                _2534_ladder_break = true;
	                break;
	            }
	            if (dot(_517[_520], _517[_520]) == 0.0)
	            {
	                break;
	            }
	            _517[_520] = normalize(_517[_520]);
	            int _521 = 0;
	            for (;;)
	            {
	                if (!(_521 < 3))
	                {
	                    break;
	                }
	                vec3 _2572 = _523[_521] - (_517[_520] * dot(_517[_520], _523[_521]));
	                _516[_521] = _2478 - (_2572 * dot(_2478 - _522[_521], _2572));
	                _521++;
	                continue;
	            }
	            vec3 _2596 = ((_516[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_516[1] * attrs.barycentrics.x)) + (_516[2] * attrs.barycentrics.y);
	            _518 = dot(_2596 - _2478, _485);
	            _519 = _2596;
	            break;
	        } while(false);
	        if (_2534_ladder_break)
	        {
	            break;
	        }
	        _520++;
	        continue;
	    }
	    if (!(_518 > 0.00999999977648258209228515625))
	    {
	        _519 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _519;
	    payload.bFlippedNormal = _484;
	    f16vec3 _2609 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_2609, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2609, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(normalize(_2431.xyz));
	    payload.material.vAlbedo = f16vec3(_492);
	    payload.material.vEmissive = f16vec3(_489);
	    payload.material.flReflectance = float16_t(_488);
	    payload.material.flMetalness = float16_t(_490);
	    payload.material.flRoughness = float16_t(dot(_491, vec2(0.5)));
	    if (any(greaterThan(_487, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _2635 = f16vec3(_487);
	        payload.material.vMaterialBits.x = _2635.x;
	        payload.material.vMaterialBits.y = _2635.y;
	        payload.material.vMaterialBits.z = _2635.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SHADER_QUALITY == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
}
