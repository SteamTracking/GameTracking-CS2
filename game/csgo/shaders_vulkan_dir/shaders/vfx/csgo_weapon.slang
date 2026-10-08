//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Weapon Shader";
	DevShader = false;
	Version = 16;
	
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
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	Feature( F_ENABLE_SFX_MASK, 0..1, "SFX" );
	Feature( F_GLITTER, 0..1, "SFX" );
	Feature( F_IRIDESCENCE, 0..1, "SFX" );
	Feature( F_ENABLE_ADJUSTMENTS, 0..1, "Adjustments" );
	Feature( F_DETAIL_TEXTURE, 0..1 (0="Multiply", 1="Replace"), "Adjustments" );
	Feature( F_STICKERS, 0..1, "Enable Stickers" );
	Feature( F_SELF_ILLUM, 0..1, "Self Illum" );
	Feature( F_OPAQUE_REFRACT, 0..1, "Draw opaque using background copy as refract" );
	Feature( F_STATTRAK, 0..1, "Enable StatTrak" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_DETAIL_TEXTURE, F_ENABLE_ADJUSTMENTS ), "Detail texture requires Enable Adjustments" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_ADDITIVE_BLEND ), "Adjustments and Additive Blend are not compatible" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_TRANSLUCENT ), "Adjustments and Translucent are not compatible" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Allow1( F_OPAQUE_REFRACT, F_TRANSLUCENT ), "" );
	FeatureRule( Allow1( F_OPAQUE_REFRACT, F_ALPHA_TEST ), "" );
	FeatureRule( Allow1( F_OPAQUE_REFRACT, F_ADDITIVE_BLEND ), "" );
	FeatureRule( Allow1( F_OPAQUE_REFRACT, F_RENDER_BACKFACES ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_DO_NOT_CAST_SHADOWS ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_RENDER_BACKFACES ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_DISABLE_Z_BUFFERING ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_DISABLE_Z_PREPASS ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_TRANSLUCENT ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_ADDITIVE_BLEND ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_TINT_MASK ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_ENABLE_SFX_MASK ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_GLITTER ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_IRIDESCENCE ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_ENABLE_ADJUSTMENTS ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_DETAIL_TEXTURE ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_STICKERS ), "" );
	FeatureRule( Allow1( F_STATTRAK, F_OPAQUE_REFRACT ), "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                   
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;          
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_ENABLE_ADJUSTMENTS, F_ENABLE_ADJUSTMENTS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_STATTRAK, F_STATTRAK );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_STATTRAK, S_ENABLE_ADJUSTMENTS ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bStickerProjectionPreview < Attribute("StickerProjectionPreview"); UiType(CheckBox); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression(g_nScaleTexCoordUByModelScaleAxis!=0 || g_nScaleTexCoordVByModelScaleAxis!=0); >;
	float g_flPlayerOcclusionAmount < Attribute("PlayerOcclusionAmount"); UiType(Slider); >;
	float g_flWeaponOcclusionAmount < Attribute("WeaponOcclusionAmount"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float3 g_vPlayerOrigin < Attribute("PlayerOcclusionOrigin"); UiType(VectorText); >;
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
	float3 g_vWeaponOcclusionClampMaxs < Attribute("WeaponOcclusionClampMaxs"); UiType(VectorText); >;
	float3 g_vWeaponOcclusionClampMins < Attribute("WeaponOcclusionClampMins"); UiType(VectorText); >;
	float3 g_vWeaponOcclusionTestMaxs < Attribute("WeaponOcclusionTestMaxs"); UiType(VectorText); >;
	float3 g_vWeaponOcclusionTestMins < Attribute("WeaponOcclusionTestMins"); UiType(VectorText); >;
	
	// Detail Texture
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
	
	// Z-Bias
	float g_flZBias < Range(-1, 1); UiType(Slider); UiGroup("Z-Bias"); >;
	
	// StatTrak
	int g_nStatTrakValue < Range(-1, 999999); UiType(Slider); UiGroup("StatTrak"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 2 (name: g_vPlayerOrigin) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	vec4 _3;
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _2493
	{
	    int g_bStickerProjectionPreview;
	    float g_flPlayerOcclusionAmount;
	    vec3 g_vPlayerOrigin;
	    float g_flWeaponOcclusionAmount;
	    vec3 g_vWeaponOcclusionClampMins;
	    vec3 g_vWeaponOcclusionClampMaxs;
	    vec3 g_vWeaponOcclusionTestMins;
	    vec3 g_vWeaponOcclusionTestMaxs;
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    float g_flZBias;
	};
	
	layout(set = 0) uniform _2493 _Globals_;
	
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
	
	layout(location = 0) in vec2 vTexCoord2;
	layout(location = 1) in vec3 vPositionOs;
	layout(location = 2) in vec2 vTexCoord;
	layout(location = 3) in vec3 vNormalOs;
	layout(location = 4) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 5) in uvec4 vBlendIndices;
	layout(location = 6) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) centroid out vec4 output_4;
	layout(location = 5) centroid out vec3 output_5;
	layout(location = 6) out vec4 output_6;
	layout(location = 7) flat out uint output_7;
	
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
	    vec3 _21710;
	    if (_Globals_.g_flPlayerOcclusionAmount >= 0.9900000095367431640625)
	    {
	        vec3 _19127 = _12151.xyz;
	        _21710 = mix(_19127, mix(_19127, clamp(_19127, _Globals_.g_vPlayerOrigin + vec3(-16.0, -16.0, 0.0), _Globals_.g_vPlayerOrigin + vec3(16.0, 16.0, 72.0)), vec3(0.999000012874603271484375)), vec3(smoothstep(0.9900000095367431640625, 1.0, _Globals_.g_flPlayerOcclusionAmount)));
	    }
	    else
	    {
	        _21710 = _12151;
	    }
	    bool _12885;
	    if (_Globals_.g_flWeaponOcclusionAmount >= 1.0)
	    {
	        _12885 = !any(notEqual(_21710.xyz - clamp(_21710.xyz, _Globals_.g_vWeaponOcclusionTestMins, _Globals_.g_vWeaponOcclusionTestMaxs), vec3(0.0)));
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _19648;
	    if (_12885)
	    {
	        _19648 = mix(_21710.xyz, clamp(_21710.xyz, _Globals_.g_vWeaponOcclusionClampMins, _Globals_.g_vWeaponOcclusionClampMaxs), vec3(0.999000012874603271484375));
	    }
	    else
	    {
	        _19648 = _21710;
	    }
	    vec4 _21447 = PerViewConstantBuffer_t._m2 * 1.0;
	    vec4 _13593;
	    _13593.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _13593.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _7654 * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11399;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    vec3 _10020;
	    vec4 _22186;
	    if (_Globals_.g_bStickerProjectionPreview != 0)
	    {
	        vec3 _11684 = vec3(vec2(vTexCoord2.x - 0.5, 0.5 - vTexCoord2.y) * 32.0, _19648.y * 0.100000001490116119384765625);
	        _10020 = _11684;
	        _22186 = (vec4(_11684.xyz, 1.0) + _21447).xyzw * PerViewConstantBuffer_t._m0;
	    }
	    else
	    {
	        _10020 = _19648;
	        _22186 = (vec4(_19648.xyz, 1.0) + _21447).xyzw * PerViewConstantBuffer_t._m0;
	    }
	    vec4 _10630 = _22186;
	    _10630.z = _22186.z + _Globals_.g_flZBias;
	    output_0 = vPositionOs;
	    output_1 = _10020.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = _11179;
	    output_3 = vec4(_13593.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1), vTexCoord2);
	    output_4 = _23714;
	    output_5 = _11179;
	    output_6 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_7 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _10630.y = -_22186.y;
	    gl_Position = _10630;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	
}

PS
{
	StaticCombo( S_ENABLE_ADJUSTMENTS, F_ENABLE_ADJUSTMENTS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_GLITTER, F_GLITTER );
	StaticCombo( S_ENABLE_SFX_MASK, F_ENABLE_SFX_MASK );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_STICKERS, F_STICKERS );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_OPAQUE_REFRACT, F_OPAQUE_REFRACT );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_MODE_DEPTH==0 ) );
	StaticComboRule( Requires( S_STICKERS, S_MODE_DEPTH==0 ) );
	StaticComboRule( Requires( S_OPAQUE_REFRACT, S_MODE_DEPTH==0 ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_OPAQUE_REFRACT, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_OPAQUE_REFRACT, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_OPAQUE_REFRACT, S_ADDITIVE_BLEND ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_MOUSE_TRACE_COORD, 0..1 );
	DynamicCombo( D_USE_BGREFRACT, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_MODE_DEPTH==0 ) );
	DynamicComboRule( Requires( D_USE_BGREFRACT, S_OPAQUE_REFRACT ) );
	
	bool bIridescence < UiType(CheckBox); Expression(F_IRIDESCENCE); >;
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	RWBuffer<float4> g_MouseTraceCoordBuffer < Attribute("MouseTraceCoordBuffer"); >;
	bool g_bActiveStickerMouseOver < Attribute("ActiveStickerMouseOver"); UiType(CheckBox); >;
	bool g_bActiveStickerMoving < Attribute("ActiveStickerMoving"); UiType(CheckBox); >;
	float g_bActiveStickerPeelStartTime < Attribute("ActiveStickerPeelStartTime"); UiType(Slider); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bHoveringOverKeychain < Attribute("HoveringOverKeychain"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	bool g_bStickerPreviewForceOn < Attribute("StickerPreviewForceOn"); UiType(CheckBox); >;
	bool g_bStickerProjectionPreview < Attribute("StickerProjectionPreview"); UiType(CheckBox); >;
	float3 g_cInvulnerabilityColor < Attribute("InvulnerabilityColor"); UiType(VectorText); >;
	float g_fColorBoostFactor < UiType(Slider); Expression(64-1); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flFogModificationAmount < Attribute("FogModificationAmount"); UiType(Slider); >;
	float g_flHighlightTimeSticker0 < Attribute("HighlightTimeSticker0"); UiType(Slider); >;
	float g_flHighlightTimeSticker1 < Attribute("HighlightTimeSticker1"); UiType(Slider); >;
	float g_flHighlightTimeSticker2 < Attribute("HighlightTimeSticker2"); UiType(Slider); >;
	float g_flHighlightTimeSticker3 < Attribute("HighlightTimeSticker3"); UiType(Slider); >;
	float g_flHighlightTimeSticker4 < Attribute("HighlightTimeSticker4"); UiType(Slider); >;
	float g_flRainExposureLocalTimer < Attribute("RainExposureLocalTimer"); UiType(Slider); >;
	float g_flRainExposureToSkyWetness < Attribute("RainExposureToSkyWetness"); UiType(Slider); >;
	float g_flSpawnInvulnerability < Attribute("SpawnInvulnerability"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nActiveStickerApplySlot < Attribute("ActiveStickerApplySlot"); UiType(Slider); >;
	int g_nDetailBlendMode < UiType(Slider); Expression(F_DETAIL_TEXTURE); >;
	int g_nMouseTraceCoordInputX < Attribute("MouseTraceCoordInputX"); UiType(Slider); >;
	int g_nMouseTraceCoordInputY < Attribute("MouseTraceCoordInputY"); UiType(Slider); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tBGRefract < Attribute("BGRefract"); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGBA, ArtistDefined(TextureColor1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGlitterNormal < Channel(RG, None(TextureGlitterNormal), Linear); Channel(A, None(TextureGlitterMask), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tGlitterNormalSticker0 < Channel(RG, None(TextureGlitterNormalSticker0), Linear); Channel(A, None(TextureGlitterNormalMaskSticker0), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tGlitterNormalSticker1 < Channel(RG, None(TextureGlitterNormalSticker1), Linear); Channel(A, None(TextureGlitterNormalMaskSticker1), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tGlitterNormalSticker2 < Channel(RG, None(TextureGlitterNormalSticker2), Linear); Channel(A, None(TextureGlitterNormalMaskSticker2), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tGlitterNormalSticker3 < Channel(RG, None(TextureGlitterNormalSticker3), Linear); Channel(A, None(TextureGlitterNormalMaskSticker3), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tGlitterNormalSticker4 < Channel(RG, None(TextureGlitterNormalSticker4), Linear); Channel(A, None(TextureGlitterNormalMaskSticker4), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tHoloSpectrumSticker0 < Channel(RGB, Box(TextureHoloSpectrumSticker0), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHoloSpectrumSticker1 < Channel(RGB, Box(TextureHoloSpectrumSticker1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHoloSpectrumSticker2 < Channel(RGB, Box(TextureHoloSpectrumSticker2), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHoloSpectrumSticker3 < Channel(RGB, Box(TextureHoloSpectrumSticker3), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHoloSpectrumSticker4 < Channel(RGB, Box(TextureHoloSpectrumSticker4), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); Channel(B, Box(TextureSfxMask1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormalRoughnessSticker0 < Channel(RGB, HemiOctIsoRoughness_RG_B(TextureNormalSticker0, TextureRoughnessSticker0), Linear); Channel(A, None(TextureSelfIllumMaskSticker0), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalRoughnessSticker1 < Channel(RGB, HemiOctIsoRoughness_RG_B(TextureNormalSticker1, TextureRoughnessSticker1), Linear); Channel(A, None(TextureSelfIllumMaskSticker1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalRoughnessSticker2 < Channel(RGB, HemiOctIsoRoughness_RG_B(TextureNormalSticker2, TextureRoughnessSticker2), Linear); Channel(A, None(TextureSelfIllumMaskSticker2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalRoughnessSticker3 < Channel(RGB, HemiOctIsoRoughness_RG_B(TextureNormalSticker3, TextureRoughnessSticker3), Linear); Channel(A, None(TextureSelfIllumMaskSticker3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalRoughnessSticker4 < Channel(RGB, HemiOctIsoRoughness_RG_B(TextureNormalSticker4, TextureRoughnessSticker4), Linear); Channel(A, None(TextureSelfIllumMaskSticker4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tOpaqueRefractMask < Channel(R, None(TextureOpaqueRefractMask), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tSfxMaskSticker0 < Channel(RGB, Box(TextureHoloMaskSticker0), Linear); Channel(A, Box(TextureGlitterMaskSticker0), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tSfxMaskSticker1 < Channel(RGB, Box(TextureHoloMaskSticker1), Linear); Channel(A, Box(TextureGlitterMaskSticker1), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tSfxMaskSticker2 < Channel(RGB, Box(TextureHoloMaskSticker2), Linear); Channel(A, Box(TextureGlitterMaskSticker2), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tSfxMaskSticker3 < Channel(RGB, Box(TextureHoloMaskSticker3), Linear); Channel(A, Box(TextureGlitterMaskSticker3), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tSfxMaskSticker4 < Channel(RGB, Box(TextureHoloMaskSticker4), Linear); Channel(A, Box(TextureGlitterMaskSticker4), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tSticker0 < Channel(RGB, Box(TextureColorSticker0), Srgb); Channel(A, Box(TextureWearMaskSticker0), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSticker1 < Channel(RGB, Box(TextureColorSticker1), Srgb); Channel(A, Box(TextureWearMaskSticker1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSticker2 < Channel(RGB, Box(TextureColorSticker2), Srgb); Channel(A, Box(TextureWearMaskSticker2), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSticker3 < Channel(RGB, Box(TextureColorSticker3), Srgb); Channel(A, Box(TextureWearMaskSticker3), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSticker4 < Channel(RGB, Box(TextureColorSticker4), Srgb); Channel(A, Box(TextureWearMaskSticker4), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tStickerScratches < Channel(R, Box(TextureStickerScratches), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tStickerWepInputs < Channel(R, None(TextureStickerMask), Linear); Channel(G, None(TextureStickerCavity), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	float3 g_vAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.045,.4,1.15).x,-1.4427*log(max(.0001,1-float3(-.045,.4,1.15).y)),2-float3(-.045,.4,1.15).z)); >;
	float3 g_vDarkMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.1,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.1,.4,1.08).y)),2-float3(-.1,.4,1.08).z)); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vHoloAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.05,.35,1.15).x,-1.4427*log(max(.0001,1-float3(-.05,.35,1.15).y)),2-float3(-.05,.35,1.15).z)); >;
	float4 g_vInvTextureDim < Source(InvTextureDim); SourceArg(g_tBGRefract) UiType(VectorText); >;
	float4 g_vKeychainGhostHandData < Attribute("KeychainGhostHandData"); UiType(VectorText); >;
	float3 g_vMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.45,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.45,.4,1.08).y)),2-float3(-.45,.4,1.08).z)); >;
	float3 g_vMouseTraceCoordMovablePosition < Attribute("MouseTraceCoordMovablePos"); UiType(VectorText); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression(pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	float g_fHueShift < Range(-180, 180); UiType(Slider); UiGroup("Color/Adjustments/10"); Expression(radians(this)); >;
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Color/11", Default4(1, 1, 1, 1));
	float g_fSaturation < Default(1); Range(0, 2); UiType(Slider); UiGroup("Color/Adjustments/11"); >;
	float g_fContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Adjustments/15"); >;
	float g_fBrightness < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Adjustments/16"); >;
	
	// Sticker0
	bool g_bAutomaticPBRColorFittingSticker0 < Default(1); UiType(CheckBox); UiGroup("Sticker0 / Color / 0"); UiVisibility(1); >;
	bool g_bEnableSticker0 < UiType(CheckBox); UiGroup("Sticker0"); >;
	bool g_bHolographicSticker0 < UiType(CheckBox); UiGroup("Sticker0 / SFX / 0"); UiVisibility(1); >;
	bool g_bMetallicSticker0 < UiType(CheckBox); UiGroup("Sticker0 / Lighting / 0"); UiVisibility(1); >;
	CreateInputTexture2D(TextureNormalSticker0, Linear, 8, "NormalizeNormals", "_normal", "Sticker0 / Lighting / 1", Default4(0.5, 0.5, 1, 0));
	bool g_bGlitterSticker0 < UiType(CheckBox); UiGroup("Sticker0 / SFX / 1"); UiVisibility(1); >;
	bool g_bLegacyTintMultiplySticker0 < UiType(CheckBox); UiGroup("Sticker0 / Color / 1"); UiVisibility(1); >;
	bool g_bPaperBackingSticker0 < UiType(CheckBox); UiGroup("Sticker0 / Wear / 1"); UiVisibility(1); >;
	bool g_bPreserveRoughnessSticker0 < UiType(CheckBox); UiGroup("Sticker0 / Wear / 1"); UiVisibility(1); >;
	float2 g_vSticker0Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Sticker0 / Position / 1"); Expression(exists(Sticker0Offset) ? Sticker0Offset : this); >;
	CreateInputTexture2D(TextureColorSticker0, Srgb, 8, "", "", "Sticker0 / Color / 2", "materials/default/stickers/sticker_default.psd");
	CreateInputTexture2D(TextureRoughnessSticker0, Linear, 8, "Inverse", "_rough", "Sticker0 / Lighting / 2", "materials/default/stickers/default_rough.tga");
	CreateInputTexture2D(TextureWearMaskSticker0, Srgb, 8, "", "", "Sticker0 / Color / 2", "materials/default/stickers/default_wearmask.tga");
	float g_flSfxColorBoostSticker0 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker0 / SFX / 2"); UiVisibility(1); >;
	float g_flSticker0Wear < UiType(Slider); UiGroup("Sticker0 / Wear / 2"); Expression(exists(Sticker0Wear) ? Sticker0Wear : this); >;
	float2 g_vSticker0Scale < Range2(0, 0, 64, 64); UiType(VectorText); UiGroup("Sticker0 / Position / 2"); Expression(exists(Sticker0Scale) ? Sticker0Scale : this); >;
	CreateInputTexture2D(TextureHoloMaskSticker0, Linear, 8, "", "_holomask", "Sticker0 / SFX / 3", "materials/default/stickers/default_holomask.tga");
	float g_flColorBoostSticker0 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker0 / Color / 3"); UiVisibility(1); >;
	float g_flSticker0Rotation < UiType(Slider); UiGroup("Sticker0 / Position / 3"); Expression(exists(Sticker0Rotation) ? Sticker0Rotation : this); >;
	float2 g_vWearBiasSticker0 < Default2(1, 1); Range2(0.001, -4, 4, 4); UiType(VectorText); UiGroup("Sticker0 / Wear / 3"); >;
	CreateInputTexture2D(TextureHoloSpectrumSticker0, Srgb, 8, "", "_holospectrum", "Sticker0 / SFX / 4", "materials/default/stickers/default_holospectrum.tga");
	float g_fWearScratchesSticker0 < Default(1); UiType(Slider); UiGroup("Sticker0 / Wear / 4"); >;
	float3 g_vColorTintSticker0 < Default3(1, 1, 1); UiType(Color); UiGroup("Sticker0 / Color / 4"); Expression(SrgbGammaToLinear(this)); UiVisibility(1); >;
	bool g_bClampSpectrumVSticker0 < Default(1); UiType(CheckBox); UiGroup("Sticker0 / SFX / 5"); UiVisibility(1); >;
	float g_flTintSaturateSticker0 < Default(1); UiType(Slider); UiGroup("Sticker0 / Color / 5"); Expression(1-this); UiVisibility(1); >;
	CreateInputTexture2D(TextureGlitterMaskSticker0, Linear, 8, "Inverse", "_glittermask", "Sticker0 / SFX / 6", "materials/default/stickers/default_glittermask.tga");
	CreateInputTexture2D(TextureGlitterNormalSticker0, Linear, 8, "NormalizeNormals", "_normal", "Sticker0 / SFX / 7", "materials/default/stickers/squares_glitter_normal.tga");
	CreateInputTexture2D(TextureGlitterNormalMaskSticker0, Linear, 8, "", "_mask", "Sticker0 / SFX / 8", "materials/default/stickers/squares_glitter_mask.tga");
	float g_flGlitterScaleSticker0 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Sticker0 / SFX / 9"); UiVisibility(1); >;
	bool g_bSelfIllumSticker0 < UiType(CheckBox); UiGroup("Sticker0 / SFX / 10"); UiVisibility(1); >;
	CreateInputTexture2D(TextureSelfIllumMaskSticker0, Linear, 8, "", "_mask", "Sticker0 / SFX / 11", "materials/default/default_mask.tga");
	
	// Sticker1
	bool g_bAutomaticPBRColorFittingSticker1 < Default(1); UiType(CheckBox); UiGroup("Sticker1 / Color / 0"); UiVisibility(1); >;
	bool g_bEnableSticker1 < UiType(CheckBox); UiGroup("Sticker1"); >;
	bool g_bHolographicSticker1 < UiType(CheckBox); UiGroup("Sticker1 / SFX / 0"); UiVisibility(1); >;
	bool g_bMetallicSticker1 < UiType(CheckBox); UiGroup("Sticker1 / Lighting / 0"); UiVisibility(1); >;
	CreateInputTexture2D(TextureNormalSticker1, Linear, 8, "NormalizeNormals", "_normal", "Sticker1 / Lighting / 1", Default4(0.5, 0.5, 1, 0));
	bool g_bGlitterSticker1 < UiType(CheckBox); UiGroup("Sticker1 / SFX / 1"); UiVisibility(1); >;
	bool g_bLegacyTintMultiplySticker1 < UiType(CheckBox); UiGroup("Sticker1 / Color / 1"); UiVisibility(1); >;
	bool g_bPaperBackingSticker1 < UiType(CheckBox); UiGroup("Sticker1 / Wear / 1"); UiVisibility(1); >;
	bool g_bPreserveRoughnessSticker1 < UiType(CheckBox); UiGroup("Sticker1 / Wear / 1"); UiVisibility(1); >;
	float2 g_vSticker1Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Sticker1 / Position / 1"); Expression(exists(Sticker1Offset) ? Sticker1Offset : this); >;
	CreateInputTexture2D(TextureColorSticker1, Srgb, 8, "", "", "Sticker1 / Color / 2", "materials/default/stickers/sticker_default.psd");
	CreateInputTexture2D(TextureRoughnessSticker1, Linear, 8, "Inverse", "_rough", "Sticker1 / Lighting / 2", "materials/default/stickers/default_rough.tga");
	CreateInputTexture2D(TextureWearMaskSticker1, Srgb, 8, "", "", "Sticker1 / Color / 2", "materials/default/stickers/default_wearmask.tga");
	float g_flSfxColorBoostSticker1 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker1 / SFX / 2"); UiVisibility(1); >;
	float g_flSticker1Wear < UiType(Slider); UiGroup("Sticker1 / Wear / 2"); Expression(exists(Sticker1Wear) ? Sticker1Wear : this); >;
	float2 g_vSticker1Scale < Range2(0, 0, 64, 64); UiType(VectorText); UiGroup("Sticker1 / Position / 2"); Expression(exists(Sticker1Scale) ? Sticker1Scale : this); >;
	CreateInputTexture2D(TextureHoloMaskSticker1, Linear, 8, "", "_holomask", "Sticker1 / SFX / 3", "materials/default/stickers/default_holomask.tga");
	float g_flColorBoostSticker1 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker1 / Color / 3"); UiVisibility(1); >;
	float g_flSticker1Rotation < UiType(Slider); UiGroup("Sticker1 / Position / 3"); Expression(exists(Sticker1Rotation) ? Sticker1Rotation : this); >;
	float2 g_vWearBiasSticker1 < Default2(1, 1); Range2(0.001, -4, 4, 4); UiType(VectorText); UiGroup("Sticker1 / Wear / 3"); >;
	CreateInputTexture2D(TextureHoloSpectrumSticker1, Srgb, 8, "", "_holospectrum", "Sticker1 / SFX / 4", "materials/default/stickers/default_holospectrum.tga");
	float g_fWearScratchesSticker1 < Default(1); UiType(Slider); UiGroup("Sticker1 / Wear / 4"); >;
	float3 g_vColorTintSticker1 < Default3(1, 1, 1); UiType(Color); UiGroup("Sticker1 / Color / 4"); Expression(SrgbGammaToLinear(this)); UiVisibility(1); >;
	bool g_bClampSpectrumVSticker1 < Default(1); UiType(CheckBox); UiGroup("Sticker1 / SFX / 5"); UiVisibility(1); >;
	float g_flTintSaturateSticker1 < Default(1); UiType(Slider); UiGroup("Sticker1 / Color / 5"); Expression(1-this); UiVisibility(1); >;
	CreateInputTexture2D(TextureGlitterMaskSticker1, Linear, 8, "Inverse", "_glittermask", "Sticker1 / SFX / 6", "materials/default/stickers/default_glittermask.tga");
	CreateInputTexture2D(TextureGlitterNormalSticker1, Linear, 8, "NormalizeNormals", "_normal", "Sticker1 / SFX / 7", "materials/default/stickers/squares_glitter_normal.tga");
	CreateInputTexture2D(TextureGlitterNormalMaskSticker1, Linear, 8, "", "_mask", "Sticker1 / SFX / 8", "materials/default/stickers/squares_glitter_mask.tga");
	float g_flGlitterScaleSticker1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Sticker1 / SFX / 9"); UiVisibility(1); >;
	bool g_bSelfIllumSticker1 < UiType(CheckBox); UiGroup("Sticker1 / SFX / 10"); UiVisibility(1); >;
	CreateInputTexture2D(TextureSelfIllumMaskSticker1, Linear, 8, "", "_mask", "Sticker1 / SFX / 11", "materials/default/default_mask.tga");
	
	// Sticker2
	bool g_bAutomaticPBRColorFittingSticker2 < Default(1); UiType(CheckBox); UiGroup("Sticker2 / Color / 0"); UiVisibility(1); >;
	bool g_bEnableSticker2 < UiType(CheckBox); UiGroup("Sticker2"); >;
	bool g_bHolographicSticker2 < UiType(CheckBox); UiGroup("Sticker2 / SFX / 0"); UiVisibility(1); >;
	bool g_bMetallicSticker2 < UiType(CheckBox); UiGroup("Sticker2 / Lighting / 0"); UiVisibility(1); >;
	CreateInputTexture2D(TextureNormalSticker2, Linear, 8, "NormalizeNormals", "_normal", "Sticker2 / Lighting / 1", Default4(0.5, 0.5, 1, 0));
	bool g_bGlitterSticker2 < UiType(CheckBox); UiGroup("Sticker2 / SFX / 1"); UiVisibility(1); >;
	bool g_bLegacyTintMultiplySticker2 < UiType(CheckBox); UiGroup("Sticker2 / Color / 1"); UiVisibility(1); >;
	bool g_bPaperBackingSticker2 < UiType(CheckBox); UiGroup("Sticker2 / Wear / 1"); UiVisibility(1); >;
	bool g_bPreserveRoughnessSticker2 < UiType(CheckBox); UiGroup("Sticker2 / Wear / 1"); UiVisibility(1); >;
	float2 g_vSticker2Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Sticker2 / Position / 1"); Expression(exists(Sticker2Offset) ? Sticker2Offset : this); >;
	CreateInputTexture2D(TextureColorSticker2, Srgb, 8, "", "", "Sticker2 / Color / 2", "materials/default/stickers/sticker_default.psd");
	CreateInputTexture2D(TextureRoughnessSticker2, Linear, 8, "Inverse", "_rough", "Sticker2 / Lighting / 2", "materials/default/stickers/default_rough.tga");
	CreateInputTexture2D(TextureWearMaskSticker2, Srgb, 8, "", "", "Sticker2 / Color / 2", "materials/default/stickers/default_wearmask.tga");
	float g_flSfxColorBoostSticker2 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker2 / SFX / 2"); UiVisibility(1); >;
	float g_flSticker2Wear < UiType(Slider); UiGroup("Sticker2 / Wear / 2"); Expression(exists(Sticker2Wear) ? Sticker2Wear : this); >;
	float2 g_vSticker2Scale < Range2(0, 0, 64, 64); UiType(VectorText); UiGroup("Sticker2 / Position / 2"); Expression(exists(Sticker2Scale) ? Sticker2Scale : this); >;
	CreateInputTexture2D(TextureHoloMaskSticker2, Linear, 8, "", "_holomask", "Sticker2 / SFX / 3", "materials/default/stickers/default_holomask.tga");
	float g_flColorBoostSticker2 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker2 / Color / 3"); UiVisibility(1); >;
	float g_flSticker2Rotation < UiType(Slider); UiGroup("Sticker2 / Position / 3"); Expression(exists(Sticker2Rotation) ? Sticker2Rotation : this); >;
	float2 g_vWearBiasSticker2 < Default2(1, 1); Range2(0.001, -4, 4, 4); UiType(VectorText); UiGroup("Sticker2 / Wear / 3"); >;
	CreateInputTexture2D(TextureHoloSpectrumSticker2, Srgb, 8, "", "_holospectrum", "Sticker2 / SFX / 4", "materials/default/stickers/default_holospectrum.tga");
	float g_fWearScratchesSticker2 < Default(1); UiType(Slider); UiGroup("Sticker2 / Wear / 4"); >;
	float3 g_vColorTintSticker2 < Default3(1, 1, 1); UiType(Color); UiGroup("Sticker2 / Color / 4"); Expression(SrgbGammaToLinear(this)); UiVisibility(1); >;
	bool g_bClampSpectrumVSticker2 < Default(1); UiType(CheckBox); UiGroup("Sticker2 / SFX / 5"); UiVisibility(1); >;
	float g_flTintSaturateSticker2 < Default(1); UiType(Slider); UiGroup("Sticker2 / Color / 5"); Expression(1-this); UiVisibility(1); >;
	CreateInputTexture2D(TextureGlitterMaskSticker2, Linear, 8, "Inverse", "_glittermask", "Sticker2 / SFX / 6", "materials/default/stickers/default_glittermask.tga");
	CreateInputTexture2D(TextureGlitterNormalSticker2, Linear, 8, "NormalizeNormals", "_normal", "Sticker2 / SFX / 7", "materials/default/stickers/squares_glitter_normal.tga");
	CreateInputTexture2D(TextureGlitterNormalMaskSticker2, Linear, 8, "", "_mask", "Sticker2 / SFX / 8", "materials/default/stickers/squares_glitter_mask.tga");
	float g_flGlitterScaleSticker2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Sticker2 / SFX / 9"); UiVisibility(1); >;
	bool g_bSelfIllumSticker2 < UiType(CheckBox); UiGroup("Sticker2 / SFX / 10"); UiVisibility(1); >;
	CreateInputTexture2D(TextureSelfIllumMaskSticker2, Linear, 8, "", "_mask", "Sticker2 / SFX / 11", "materials/default/default_mask.tga");
	
	// Sticker3
	bool g_bAutomaticPBRColorFittingSticker3 < Default(1); UiType(CheckBox); UiGroup("Sticker3 / Color / 0"); UiVisibility(1); >;
	bool g_bEnableSticker3 < UiType(CheckBox); UiGroup("Sticker3"); >;
	bool g_bHolographicSticker3 < UiType(CheckBox); UiGroup("Sticker3 / SFX / 0"); UiVisibility(1); >;
	bool g_bMetallicSticker3 < UiType(CheckBox); UiGroup("Sticker3 / Lighting / 0"); UiVisibility(1); >;
	CreateInputTexture2D(TextureNormalSticker3, Linear, 8, "NormalizeNormals", "_normal", "Sticker3 / Lighting / 1", Default4(0.5, 0.5, 1, 0));
	bool g_bGlitterSticker3 < UiType(CheckBox); UiGroup("Sticker3 / SFX / 1"); UiVisibility(1); >;
	bool g_bLegacyTintMultiplySticker3 < UiType(CheckBox); UiGroup("Sticker3 / Color / 1"); UiVisibility(1); >;
	bool g_bPaperBackingSticker3 < UiType(CheckBox); UiGroup("Sticker3 / Wear / 1"); UiVisibility(1); >;
	bool g_bPreserveRoughnessSticker3 < UiType(CheckBox); UiGroup("Sticker3 / Wear / 1"); UiVisibility(1); >;
	float2 g_vSticker3Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Sticker3 / Position / 1"); Expression(exists(Sticker3Offset) ? Sticker3Offset : this); >;
	CreateInputTexture2D(TextureColorSticker3, Srgb, 8, "", "", "Sticker3 / Color / 2", "materials/default/stickers/sticker_default.psd");
	CreateInputTexture2D(TextureRoughnessSticker3, Linear, 8, "Inverse", "_rough", "Sticker3 / Lighting / 2", "materials/default/stickers/default_rough.tga");
	CreateInputTexture2D(TextureWearMaskSticker3, Srgb, 8, "", "", "Sticker3 / Color / 2", "materials/default/stickers/default_wearmask.tga");
	float g_flSfxColorBoostSticker3 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker3 / SFX / 2"); UiVisibility(1); >;
	float g_flSticker3Wear < UiType(Slider); UiGroup("Sticker3 / Wear / 2"); Expression(exists(Sticker3Wear) ? Sticker3Wear : this); >;
	float2 g_vSticker3Scale < Range2(0, 0, 64, 64); UiType(VectorText); UiGroup("Sticker3 / Position / 2"); Expression(exists(Sticker3Scale) ? Sticker3Scale : this); >;
	CreateInputTexture2D(TextureHoloMaskSticker3, Linear, 8, "", "_holomask", "Sticker3 / SFX / 3", "materials/default/stickers/default_holomask.tga");
	float g_flColorBoostSticker3 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker3 / Color / 3"); UiVisibility(1); >;
	float g_flSticker3Rotation < UiType(Slider); UiGroup("Sticker3 / Position / 3"); Expression(exists(Sticker3Rotation) ? Sticker3Rotation : this); >;
	float2 g_vWearBiasSticker3 < Default2(1, 1); Range2(0.001, -4, 4, 4); UiType(VectorText); UiGroup("Sticker3 / Wear / 3"); >;
	CreateInputTexture2D(TextureHoloSpectrumSticker3, Srgb, 8, "", "_holospectrum", "Sticker3 / SFX / 4", "materials/default/stickers/default_holospectrum.tga");
	float g_fWearScratchesSticker3 < Default(1); UiType(Slider); UiGroup("Sticker3 / Wear / 4"); >;
	float3 g_vColorTintSticker3 < Default3(1, 1, 1); UiType(Color); UiGroup("Sticker3 / Color / 4"); Expression(SrgbGammaToLinear(this)); UiVisibility(1); >;
	bool g_bClampSpectrumVSticker3 < Default(1); UiType(CheckBox); UiGroup("Sticker3 / SFX / 5"); UiVisibility(1); >;
	float g_flTintSaturateSticker3 < Default(1); UiType(Slider); UiGroup("Sticker3 / Color / 5"); Expression(1-this); UiVisibility(1); >;
	CreateInputTexture2D(TextureGlitterMaskSticker3, Linear, 8, "Inverse", "_glittermask", "Sticker3 / SFX / 6", "materials/default/stickers/default_glittermask.tga");
	CreateInputTexture2D(TextureGlitterNormalSticker3, Linear, 8, "NormalizeNormals", "_normal", "Sticker3 / SFX / 7", "materials/default/stickers/squares_glitter_normal.tga");
	CreateInputTexture2D(TextureGlitterNormalMaskSticker3, Linear, 8, "", "_mask", "Sticker3 / SFX / 8", "materials/default/stickers/squares_glitter_mask.tga");
	float g_flGlitterScaleSticker3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Sticker3 / SFX / 9"); UiVisibility(1); >;
	bool g_bSelfIllumSticker3 < UiType(CheckBox); UiGroup("Sticker3 / SFX / 10"); UiVisibility(1); >;
	CreateInputTexture2D(TextureSelfIllumMaskSticker3, Linear, 8, "", "_mask", "Sticker3 / SFX / 11", "materials/default/default_mask.tga");
	
	// Sticker4
	bool g_bAutomaticPBRColorFittingSticker4 < Default(1); UiType(CheckBox); UiGroup("Sticker4 / Color / 0"); UiVisibility(1); >;
	bool g_bEnableSticker4 < UiType(CheckBox); UiGroup("Sticker4"); >;
	bool g_bHolographicSticker4 < UiType(CheckBox); UiGroup("Sticker4 / SFX / 0"); UiVisibility(1); >;
	bool g_bMetallicSticker4 < UiType(CheckBox); UiGroup("Sticker4 / Lighting / 0"); UiVisibility(1); >;
	CreateInputTexture2D(TextureNormalSticker4, Linear, 8, "NormalizeNormals", "_normal", "Sticker4 / Lighting / 1", Default4(0.5, 0.5, 1, 0));
	bool g_bGlitterSticker4 < UiType(CheckBox); UiGroup("Sticker4 / SFX / 1"); UiVisibility(1); >;
	bool g_bLegacyTintMultiplySticker4 < UiType(CheckBox); UiGroup("Sticker4 / Color / 1"); UiVisibility(1); >;
	bool g_bPaperBackingSticker4 < UiType(CheckBox); UiGroup("Sticker4 / Wear / 1"); UiVisibility(1); >;
	bool g_bPreserveRoughnessSticker4 < UiType(CheckBox); UiGroup("Sticker4 / Wear / 1"); UiVisibility(1); >;
	float2 g_vSticker4Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Sticker4 / Position / 1"); Expression(exists(Sticker4Offset) ? Sticker4Offset : this); >;
	CreateInputTexture2D(TextureColorSticker4, Srgb, 8, "", "", "Sticker4 / Color / 2", "materials/default/stickers/sticker_default.psd");
	CreateInputTexture2D(TextureRoughnessSticker4, Linear, 8, "Inverse", "_rough", "Sticker4 / Lighting / 2", "materials/default/stickers/default_rough.tga");
	CreateInputTexture2D(TextureWearMaskSticker4, Srgb, 8, "", "", "Sticker4 / Color / 2", "materials/default/stickers/default_wearmask.tga");
	float g_flSfxColorBoostSticker4 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker4 / SFX / 2"); UiVisibility(1); >;
	float g_flSticker4Wear < UiType(Slider); UiGroup("Sticker4 / Wear / 2"); Expression(exists(Sticker4Wear) ? Sticker4Wear : this); >;
	float2 g_vSticker4Scale < Range2(0, 0, 64, 64); UiType(VectorText); UiGroup("Sticker4 / Position / 2"); Expression(exists(Sticker4Scale) ? Sticker4Scale : this); >;
	CreateInputTexture2D(TextureHoloMaskSticker4, Linear, 8, "", "_holomask", "Sticker4 / SFX / 3", "materials/default/stickers/default_holomask.tga");
	float g_flColorBoostSticker4 < Default(1); Range(0, 64); UiType(Slider); UiGroup("Sticker4 / Color / 3"); UiVisibility(1); >;
	float g_flSticker4Rotation < UiType(Slider); UiGroup("Sticker4 / Position / 3"); Expression(exists(Sticker4Rotation) ? Sticker4Rotation : this); >;
	float2 g_vWearBiasSticker4 < Default2(1, 1); Range2(0.001, -4, 4, 4); UiType(VectorText); UiGroup("Sticker4 / Wear / 3"); >;
	CreateInputTexture2D(TextureHoloSpectrumSticker4, Srgb, 8, "", "_holospectrum", "Sticker4 / SFX / 4", "materials/default/stickers/default_holospectrum.tga");
	float g_fWearScratchesSticker4 < Default(1); UiType(Slider); UiGroup("Sticker4 / Wear / 4"); >;
	float3 g_vColorTintSticker4 < Default3(1, 1, 1); UiType(Color); UiGroup("Sticker4 / Color / 4"); Expression(SrgbGammaToLinear(this)); UiVisibility(1); >;
	bool g_bClampSpectrumVSticker4 < Default(1); UiType(CheckBox); UiGroup("Sticker4 / SFX / 5"); UiVisibility(1); >;
	float g_flTintSaturateSticker4 < Default(1); UiType(Slider); UiGroup("Sticker4 / Color / 5"); Expression(1-this); UiVisibility(1); >;
	CreateInputTexture2D(TextureGlitterMaskSticker4, Linear, 8, "Inverse", "_glittermask", "Sticker4 / SFX / 6", "materials/default/stickers/default_glittermask.tga");
	CreateInputTexture2D(TextureGlitterNormalSticker4, Linear, 8, "NormalizeNormals", "_normal", "Sticker4 / SFX / 7", "materials/default/stickers/squares_glitter_normal.tga");
	CreateInputTexture2D(TextureGlitterNormalMaskSticker4, Linear, 8, "", "_mask", "Sticker4 / SFX / 8", "materials/default/stickers/squares_glitter_mask.tga");
	float g_flGlitterScaleSticker4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Sticker4 / SFX / 9"); UiVisibility(1); >;
	bool g_bSelfIllumSticker4 < UiType(CheckBox); UiGroup("Sticker4 / SFX / 10"); UiVisibility(1); >;
	CreateInputTexture2D(TextureSelfIllumMaskSticker4, Linear, 8, "", "_mask", "Sticker4 / SFX / 11", "materials/default/default_mask.tga");
	
	// Detail Texture
	CreateInputTexture2D(TextureDetail, Srgb, 8, "", "_detail", "Detail Texture/0", Default4(1, 1, 1, 1));
	float g_fDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture/1"); >;
	bool g_bMaskDetailTextureByTintMask < UiType(CheckBox); UiGroup("Detail Texture/2"); UiVisibility(F_TINT_MASK==1); >;
	
	// Lighting
	CreateInputTexture2D(TextureGlitterMask, Linear, 8, "", "_mask", "Lighting/SFX/Glitter", "materials/default/stickers/squares_glitter_mask.tga");
	CreateInputTexture2D(TextureGlitterNormal, Linear, 8, "NormalizeNormals", "_normal", "Lighting/SFX/Glitter", "materials/default/stickers/squares_glitter_normal.tga");
	CreateInputTexture2D(TextureSfxMask1, Linear, 8, "", "_mask", "Lighting/SFX/0", "materials/default/default_black_mask.tga");
	float g_fGlitterIntensity < Range(0, 5); UiType(Slider); UiGroup("Lighting/SFX/Glitter"); >;
	float g_fGlitterRainbowBalance < Default(0.25); Range(-1, 1); UiType(Slider); UiGroup("Lighting/SFX/Glitter"); >;
	float g_fGlitterRainbowSpread < UiType(Slider); UiGroup("Lighting/SFX/Glitter"); >;
	float g_fGlitterScale < Default(10); Range(0, 40); UiType(Slider); UiGroup("Lighting/SFX/Glitter"); >;
	float g_flIridescentHueShift < Default(0.5); UiType(Slider); UiGroup("Lighting/SFX/Iridescence"); UiVisibility(F_IRIDESCENCE==1); >;
	float g_flIridescentScale < Default(2); Range(0, 20); UiType(Slider); UiGroup("Lighting/SFX/Iridescence"); UiVisibility(F_IRIDESCENCE==1); >;
	float g_flIridescentStrength < Default(0.75); UiType(Slider); UiGroup("Lighting/SFX/Iridescence"); UiVisibility(F_IRIDESCENCE==1); >;
	float g_flPearlescentScale < Range(-120, 120); UiType(Slider); UiGroup("Lighting/SFX/Perlescence/10"); UiVisibility(F_IRIDESCENCE==1); >;
	float g_flMetalnessTransitionBias < Default(2); Range(0.001, 3); UiType(Slider); UiGroup("Lighting,30/Metalness,50/10"); >;
	float2 g_vMetalnessRemapRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Metalness,40/10"); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/11", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/11", Default4(0.5, 0.5, 0.5, 0));
	float g_fTextureRoughnessContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/11"); >;
	float g_fTextureRoughnessBrightness < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/12"); >;
	bool g_bMaskRoughnessAdjustmentsByTintMask < UiType(CheckBox); UiGroup("Lighting/Roughness/13"); UiVisibility(F_TINT_MASK==1); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Opaque Refract
	CreateInputTexture2D(TextureOpaqueRefractMask, Linear, 8, "", "", "Opaque Refract/0", Default4(1, 1, 1, 0));
	float g_flRefractStrength < Default(0.01); Range(0.001, 0.05); UiType(Slider); UiGroup("Opaque Refract/1"); >;
	float g_flRefractBlur < UiType(Slider); UiGroup("Opaque Refract/2"); >;
	float g_flRefractGlancingMask < UiType(Slider); UiGroup("Opaque Refract/3"); >;
	float g_flRefractOpacity < Default(1); UiType(Slider); UiGroup("Opaque Refract/4"); >;
	float g_flRefractContrast < Range(-1, 1); UiType(Slider); UiGroup("Opaque Refract/5"); >;
	float g_flRefractBrightness < Default(1); Range(0, 10); UiType(Slider); UiGroup("Opaque Refract/6"); >;
	
	// Self Illum
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Sticker Inputs
	CreateInputTexture2D(TextureStickerCavity, Linear, 8, "", "", "Sticker Inputs", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureStickerMask, Linear, 8, "", "", "Sticker Inputs", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureStickerScratches, Linear, 8, "", "", "Sticker Inputs", "materials/default/stickers/sticker_default_scratches.psd");
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Composite Inputs
	float g_flUvScale1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Composite Inputs/Metadata Inputs,10/20"); UiVisibility(0); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_STICKERS == 1)
	#endif
	
	// Variant parameters
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); Channel(B, Box(TextureSfxMask1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 26 (name: g_cInvulnerabilityColor) cannot be expressed with either HLSL packing layout or packoffset.
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
	#extension GL_EXT_samplerless_texture_functions : require
	layout(early_fragment_tests) in;
	
	struct _1373
	{
	    vec4 _m0[3];
	};
	
	struct _992
	{
	    vec4 _m0[4];
	};
	
	struct _1753
	{
	    mat4x3 _m0;
	    vec3 _m1;
	    uint _m2;
	    vec3 _m3;
	    uint _m4;
	    vec4 _m5;
	    vec3 _m6;
	    vec4 _m7;
	};
	
	struct _920
	{
	    _1753 _m0[128];
	};
	
	struct _1056
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
	
	struct _856
	{
	    float g_flFogModificationAmount;
	    uint g_tColor;
	    uint g_tMetalness;
	    uint g_sAniso;
	    uint g_sBilinearClamp;
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    uint g_sUserConfig;
	    uint g_sUserConfigAllowGlobalMipBias;
	    uint g_sCookieSampler;
	    uint g_tShadowDepthBufferCmpSampler;
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    uint g_tNormal;
	    uint g_tAmbientOcclusion;
	    vec2 g_vMetalnessRemapRange;
	    float g_flMetalnessTransitionBias;
	    float g_flRainExposureToSkyWetness;
	    float g_flRainExposureLocalTimer;
	    int bIridescence;
	    float g_flIridescentScale;
	    float g_flIridescentStrength;
	    float g_flIridescentHueShift;
	    float g_flSpawnInvulnerability;
	    vec3 g_cInvulnerabilityColor;
	    vec4 g_vKeychainGhostHandData;
	    float g_flPearlescentScale;
	};
	
	layout(set = 1) uniform _856 _Globals_;
	
	struct _2595
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    ivec4 _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    uint _m8;
	    uint _m9;
	    uint _m10;
	    uint _m11;
	    float _m12;
	    float _m13;
	    ivec2 _m14;
	    mat4 _m15;
	    vec2 _m16;
	    float _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    vec4 _m22;
	    vec4 _m23;
	    mat4 _m24;
	    vec4 _m25;
	    vec4 _m26;
	    vec4 _m27;
	    float _m28;
	    float _m29;
	    vec4 _m30;
	};
	
	layout(set = 1) uniform _2595 PerViewConstantBufferCsgo_t;
	
	struct _1616
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    float _m4;
	    vec4 _m5;
	    vec3 _m6;
	    vec3 _m7;
	};
	
	layout(set = 1) uniform _1616 PerViewConstantBuffer_t;
	
	struct _790
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    _1373 _m5;
	    _992 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    uvec4 _m10;
	    uvec4 _m11;
	    uvec4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    _920 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    int _m18;
	    float _m19;
	    vec4 _m20;
	    float _m21;
	    float _m22;
	    float _m23;
	    float _m24;
	    _1056 _m25;
	    _992 _m26;
	    uint _m27;
	    uint _m28;
	};
	
	layout(set = 3) uniform _790 PerViewLightingConstantBufferGpu_t;
	
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
	layout(set = 4, binding = 46) uniform textureCubeArray g_bindless_TextureCubeArray[65536];
	layout(set = 4, binding = 46) uniform texture2DArray g_bindless_Texture2DArray_float4[65536];
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube_float4[65536];
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec4 input_3;
	layout(location = 4) centroid in vec4 input_4;
	layout(location = 5) centroid in vec3 input_5;
	layout(location = 6) in vec4 input_6;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
	    float _12497 = _Globals_.g_flRainExposureToSkyWetness * PerViewConstantBufferCsgo_t._m13;
	    bool _15436 = _12497 > 0.0;
	    float _13136;
	    vec2 _13998;
	    float _16305;
	    float _17114;
	    vec4 _23261;
	    if (_15436)
	    {
	        vec3 _10413 = input_1 + PerViewConstantBufferCsgo_t._m27.xyz;
	        vec2 _18197 = input_3.xy * 2.5;
	        vec2 _20826;
	        if ((length(cross(vec3(dFdx(input_3.xy), 0.0), vec3(dFdy(input_3.xy), 0.0))) / max(9.9999997473787516355514526367188e-05, length(cross(dFdx(_10413), dFdy(_10413))))) < 0.00200000009499490261077880859375)
	        {
	            _20826 = _18197 * 3.0;
	        }
	        else
	        {
	            _20826 = _18197;
	        }
	        vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m11], g_bindless_Sampler[_Globals_.g_sAniso]), (_20826 + (_10413.xy * 9.9999997473787516355514526367188e-05)).xy);
	        vec2 _8562 = (_20877.xy * 2.0) - vec2(1.0);
	        _8562.y = -_8562.y;
	        float _7729 = _20877.w;
	        float _12471 = _20877.z + (input_0.x * 0.00999999977648258209228515625);
	        float _10538 = saturate((((_12497 * 0.25) - fract(_12471 + (((_Globals_.g_flRainExposureLocalTimer * 0.100000001490116119384765625) * PerViewConstantBufferCsgo_t._m12) * PerViewConstantBufferCsgo_t._m12))) * 5.0) / (PerViewConstantBufferCsgo_t._m13 + 0.001000000047497451305389404296875)) * saturate((input_2.z + 0.75) * 4.0);
	        vec2 _13861 = input_3.xy + (((_8562.xy * (-0.0199999995529651641845703125)) * _10538) * _7729);
	        vec4 _20488;
	        _20488.x = _13861.x;
	        _20488.y = _13861.y;
	        _13136 = _10538;
	        _16305 = _7729;
	        _17114 = _12471;
	        _13998 = _8562;
	        _23261 = _20488;
	    }
	    else
	    {
	        _13136 = 0.0;
	        _16305 = 0.0;
	        _17114 = 0.0;
	        _13998 = vec2(0.0);
	        _23261 = input_3;
	    }
	    vec3 _21709;
	    if (dot(input_2.xyz, input_2.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_5.xyz;
	    }
	    else
	    {
	        _21709 = input_2.xyz;
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
	    vec3 _10061 = input_1 + PerViewConstantBufferCsgo_t._m27.xyz;
	    vec4 _19680 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor], g_bindless_Sampler[_Globals_.g_sUserConfigAllowGlobalMipBias]), _23261.xy);
	    vec3 _21103 = _19680.xyz * input_4.xyz;
	    vec4 _19068 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tAmbientOcclusion], g_bindless_Sampler[_Globals_.g_sUserConfig]), vec2(_23261.xy).xy);
	    float _17476 = _19068.x;
	    vec4 _21760 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tMetalness], g_bindless_Sampler[_Globals_.g_sUserConfig]), _23261.xy);
	    float _20079 = mix(_Globals_.g_vMetalnessRemapRange.x, _Globals_.g_vMetalnessRemapRange.y, _21760.y);
	    float _24590 = _21760.z;
	    float _6814 = _21760.x;
	    vec2 _13746 = vec2(_6814);
	    vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal], g_bindless_Sampler[_Globals_.g_sUserConfig]), _23261.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11176 = _16000 - _19720;
	    vec3 _8418 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
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
	    vec3 _12631 = input_2.xyz * (_24327 ? (-1.0) : 1.0);
	    float _23240 = (input_6.w > 0.0) ? 1.0 : (-1.0);
	    vec3 _14435 = cross(_12631.xyz, input_6.xyz) * _23240;
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
	        vec3 _7482 = _8418;
	        _7482.y = -_8418.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _8418;
	    }
	    vec3 _7054 = normalize((((input_6.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    vec3 _6616;
	    vec3 _13137;
	    float _13694;
	    vec2 _16306;
	    vec3 _17115;
	    if (_15436)
	    {
	        float _21270 = saturate((_6814 - 0.75) * 4.0);
	        float _8927 = sqrt(1.0 - saturate(dot(_13998.xy, _13998.xy)));
	        float _20709 = saturate(_12497);
	        float _23650 = (saturate((_13136 * _16305) + (_20709 * 0.5)) * ((_21270 * 0.75) + 0.25)) * _20709;
	        float _18483 = _13136 * saturate(1.0 - _21270);
	        float _22907 = _18483 * _16305;
	        _13137 = mix(_21103, pow(_21103, vec3(1.60000002384185791015625)) * 0.60000002384185791015625, vec3(_23650));
	        _16306 = mix(_13746.xy, vec2(0.100000001490116119384765625), vec2(_17476 * saturate(((_22907 * 4.0) + ((((cos((_17114 + (_Globals_.g_flRainExposureLocalTimer * 0.20000000298023223876953125)) * 6.28318500518798828125) * 0.5) + 0.5) * _20709) * 0.20000000298023223876953125)) + (_12497 * 0.4000000059604644775390625))));
	        _17115 = mix(normalize(mix(_24347, _7054, vec3(1.0 + (_23650 * 1.5)))), normalize((((input_6.xyz * _13998.x).xyz + (_7424.xyz * _13998.y)).xyz + (_24347.xyz * _8927)).xyz), vec3(_18483));
	        _13694 = saturate(_22907 * 2.0);
	        _6616 = mix(_20480, vec3(_13998.xy, _8927) * vec3(-1.0, -1.0, 1.0), vec3(_18483 * 0.25));
	    }
	    else
	    {
	        _13137 = _21103;
	        _16306 = _13746;
	        _17115 = vec3(1.0);
	        _13694 = 0.0;
	        _6616 = _20480;
	    }
	    vec3 _20195;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.g_flPearlescentScale != 0.0)
	    {
	        float _21433 = (_Globals_.g_flPearlescentScale * (1.0 - dot(normalize(PerViewConstantBuffer_t._m6.xyz - _10061.xyz), _7054))) * _24590;
	        float _15271 = cos(_21433);
	        float _12935;
	        do
	        {
	            float _18473 = max(_13137.x, max(_13137.y, _13137.z));
	            if (_18473 == 0.0)
	            {
	                _12935 = 0.0;
	                break;
	            }
	            _12935 = (_18473 - min(_13137.x, min(_13137.y, _13137.z))) / _18473;
	            break;
	        } while(false);
	        _20195 = mix(vec3(dot(_13137.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), ((_13137.xyz * _15271) + (cross(vec3(0.57735002040863037109375), _13137.xyz) * sin(_21433))) + ((vec3(0.57735002040863037109375) * dot(vec3(0.57735002040863037109375), _13137.xyz)) * (1.0 - _15271)), vec3(pow(_12935, 0.125)));
	    }
	    else
	    {
	        _20195 = _13137;
	    }
	    vec3 _7866 = _6616;
	    _7866.y = -_6616.y;
	    bool _12887;
	    if (_14874)
	    {
	        _12887 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12887 = false;
	    }
	    bool _24328;
	    if (_12887)
	    {
	        _24328 = !gl_FrontFacing;
	    }
	    else
	    {
	        _24328 = false;
	    }
	    vec3 _9739 = input_2.xyz * (_24328 ? (-1.0) : 1.0);
	    vec3 _24682 = cross(_9739.xyz, input_6.xyz) * _23240;
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
	        _23482.y = _6616.y;
	        _20481 = _23482;
	    }
	    else
	    {
	        _20481 = _7866;
	    }
	    vec3 _14786 = normalize((((input_6.xyz * _20481.x).xyz + (_7425.xyz * _20481.y)).xyz + (_9739.xyz * _20481.z)).xyz);
	    vec3 _17328 = mix(vec3(0.0199999995529651641845703125), _20195.xyz, vec3(_20079));
	    vec3 _22671;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.bIridescence != 0)
	    {
	        vec3 _24006 = normalize(PerViewConstantBuffer_t._m6.xyz - _10061.xyz);
	        float _22128 = fract(((dot(_24006, _24347) + dot(_24006, PerViewLightingConstantBufferGpu_t._m16.xyz)) * _Globals_.g_flIridescentScale) + _Globals_.g_flIridescentHueShift) * 6.0;
	        float _17518 = floor(_22128);
	        float _18832 = _22128 - _17518;
	        float _6692 = 1.0 - _18832;
	        vec3 _19648;
	        if (_17518 == 0.0)
	        {
	            _19648 = vec3(1.0, _18832, 0.0);
	        }
	        else
	        {
	            vec3 _12504;
	            if (_17518 == 1.0)
	            {
	                _12504 = vec3(_6692, 1.0, 0.0);
	            }
	            else
	            {
	                vec3 _12503;
	                if (_17518 == 2.0)
	                {
	                    _12503 = vec3(0.0, 1.0, _18832);
	                }
	                else
	                {
	                    vec3 _12502;
	                    if (_17518 == 3.0)
	                    {
	                        _12502 = vec3(0.0, _6692, 1.0);
	                    }
	                    else
	                    {
	                        vec3 _12501;
	                        if (_17518 == 4.0)
	                        {
	                            _12501 = vec3(_18832, 0.0, 1.0);
	                        }
	                        else
	                        {
	                            _12501 = vec3(1.0, 0.0, _6692);
	                        }
	                        _12502 = _12501;
	                    }
	                    _12503 = _12502;
	                }
	                _12504 = _12503;
	            }
	            _19648 = _12504;
	        }
	        vec4 _22046 = vec4(_17328.xyz, 1.0);
	        float _24323 = dot(_22046.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _9577 = normalize(max(_19648.xyz, vec3(0.001000000047497451305389404296875)));
	        _22671 = saturate(mix(_22046.xyz, (_9577 * min(_24323 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24323) * max(_19648.x, max(_19648.y, _19648.z)))).xyz, vec3(_Globals_.g_flIridescentStrength * _24590)));
	    }
	    else
	    {
	        _22671 = _17328;
	    }
	    vec3 _17892 = mix(_17115, _14786, bvec3(all(equal(_17115, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _11004 = max(_16306.xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _10170 = -_24347;
	    vec3 _24735 = _14786.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    vec3 _18708 = vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _23875));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    float _21710;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m17) * PerViewConstantBufferCsgo_t._m16.xy) + (PerViewConstantBufferCsgo_t._m16.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m16.x, 0.0);
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
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m16.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m7.x * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.y * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.z * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.w * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21710 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sPointClamp]), (_11087 + mix(_23169, PerViewConstantBufferCsgo_t._m16.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    float _21711;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).w)
	    {
	        _21711 = _21710 * textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m9], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21711 = _21710;
	    }
	    float _21712;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m18 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13138;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m18))
	            {
	                _13138 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_1.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m20[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m22)) + vec2(PerViewLightingConstantBufferGpu_t._m21));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m26._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_13039].xy;
	                vec3 _20489 = _19470;
	                _20489.x = _20561.x;
	                _20489.y = _20561.y;
	                _13138 = saturate(_22193.x * _22193.y);
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
	            vec2 _7045;
	            vec2 _7046;
	            vec2 _7735;
	            float _8969;
	            float _8970;
	            float _15996;
	            float _17299;
	            vec2 _18870;
	            vec4 _20581;
	            vec4 _24370;
	            uint _24711;
	            float _23727;
	            do
	            {
	                float _21452 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m19);
	                _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                _24370 = PerViewLightingConstantBufferGpu_t._m1;
	                _24711 = _Globals_.g_tShadowDepthBufferCmpSampler;
	                _17299 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15996 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18870 = vec2(_17299, _15996);
	                _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7045 = vec2(_8969, _15996);
	                _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7046 = vec2(_17299, _8970);
	                _7735 = vec2(_8969, _8970);
	                float _15310 = dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + _18870).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + _7045).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + _7046).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + _7735).xy, _21452), 0.0)).xyzw, vec4(0.25));
	                bool _12888;
	                if (_15310 == 0.0)
	                {
	                    _12888 = true;
	                }
	                else
	                {
	                    _12888 = _15310 == 1.0;
	                }
	                if (_12888)
	                {
	                    _23727 = _15310;
	                    break;
	                }
	                _23727 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + vec2(_17299, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + vec2(_8969, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + vec2(0.0, _8970)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_14975.xy + vec2(0.0, _15996)).xy, _21452), 0.0)).xyzw, _24370.xxxx)) + (textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3(_14975.xy, _21452), 0.0) * _24370.y);
	                break;
	            } while(false);
	            float _12506;
	            SPIRV_CROSS_BRANCH
	            if (_13138 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m18 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_1.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m26._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_15335].xy;
	                    vec3 _20490;
	                    _20490.x = _20562.x;
	                    _20490.y = _20562.y;
	                    float _12505;
	                    do
	                    {
	                        float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m19);
	                        float _15311 = dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + _18870).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + _7045).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + _7046).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + _7735).xy, _20322), 0.0)).xyzw, vec4(0.25));
	                        bool _12889;
	                        if (_15311 == 0.0)
	                        {
	                            _12889 = true;
	                        }
	                        else
	                        {
	                            _12889 = _15311 == 1.0;
	                        }
	                        if (_12889)
	                        {
	                            _12505 = _15311;
	                            break;
	                        }
	                        _12505 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + vec2(_17299, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + vec2(_8969, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + vec2(0.0, _8970)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3((_20490.xy + vec2(0.0, _15996)).xy, _20322), 0.0)).xyzw, _24370.xxxx)) + (textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_24711]), vec3(_20490.xy, _20322), 0.0) * _24370.y);
	                        break;
	                    } while(false);
	                    _7934 = _12505;
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12506 = mix(_7934, _23727, _13138);
	            }
	            else
	            {
	                _12506 = _23727;
	            }
	            _19363 = _12506;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, saturate((distance(_10061.xyz, PerViewConstantBuffer_t._m6) * PerViewLightingConstantBufferGpu_t._m24) + PerViewLightingConstantBufferGpu_t._m23));
	        float _12507;
	        if (_24465.y)
	        {
	            _12507 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m10], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12507 = _13279;
	        }
	        _21712 = _12507;
	    }
	    else
	    {
	        _21712 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _24735) * _21712) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t._m16.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_13694 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m16.xyz);
	            float _8124 = saturate(_13694);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * saturate((_8780 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_24735, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m16.xyz), 1.0, _8124))), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_11004, vec2(PerViewLightingConstantBufferGpu_t._m16.w));
	        vec3 _21889 = (-normalize(_10061.xyz - PerViewConstantBuffer_t._m6.xyz)).xyz;
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m16.xyz + _21889).xyz;
	        vec3 _19012 = _15460.xyz;
	        float _12386 = dot(_12281, _19012);
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _24198 = _25211 / (((_12386 * _12386) * ((_25211 * _25211) - 1.0)) + 1.0);
	        float _16150 = _9850 + 1.0;
	        float _6835 = (_16150 * _16150) * 0.125;
	        float _19569 = 1.0 - _6835;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m17.xyz * _21712).xyz;
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz + (_18223.xyz * _16808);
	        _24878 = (((_22671.xyz + ((vec3(1.0) - _22671.xyz) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _12281))), 5.0))) * ((_24198 * _24198) / ((4.0 * ((_13811 * _19569) + _6835)) * ((max(0.0, dot(_19012, _21889)) * _19569) + _6835)))).xyz * _13811).xyz * _16808;
	    }
	    else
	    {
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz;
	        _24878 = vec3(0.0);
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20061 = _24467.x;
	    vec4 _19364;
	    if (_20061)
	    {
	        vec4 _18621 = vec4(_10061.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m15;
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
	        _19364 = _11408;
	    }
	    uvec2 _7663 = uvec2(PerViewLightingConstantBufferGpu_t._m12.x);
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m10.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m12.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13139;
	    vec3 _16324;
	    _13139 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    vec3 _13140;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13140 = _16324;
	        _16325 = _13139;
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
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_1.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7426;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7426 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7426 = false;
	                }
	                bool _12890;
	                if (!_7426)
	                {
	                    _12890 = true;
	                }
	                else
	                {
	                    _12890 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_1.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12890)
	                {
	                    _13212 = _13140;
	                    _15670 = _16325;
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
	                    _21316 = smoothstep(0.0, 1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
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
	                            float _15267 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15021 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15267) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15021, _15267), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15267) + pow(_15021, _15267), 1.1754943508222875079687365372222e-38), _23041);
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
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12508 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m28], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _20492.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12508 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m28], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _20491.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12508;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13140;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _21549;
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
	                    float _24972;
	                    do
	                    {
	                        float _21462 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m19);
	                        vec2 _10393 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _21462), 0.0)).xyzw, vec4(0.25));
	                        bool _12891;
	                        if (_15312 == 0.0)
	                        {
	                            _12891 = true;
	                        }
	                        else
	                        {
	                            _12891 = _15312 == 1.0;
	                        }
	                        if (_12891)
	                        {
	                            _24972 = _15312;
	                            break;
	                        }
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _21462), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m27], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_10393, _21462), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13140;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _21549 = _19878;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15462 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_14786.xyz, _11179.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18224;
	                if (_13694 > 0.0)
	                {
	                    float _8781 = dot(_15462, _11179.xyz);
	                    float _8125 = saturate(_13694);
	                    _18224 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * saturate((_8781 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_24735, _15462, vec3(10.0)), _11179.xyz), 1.0, _8125))), vec3(_8125));
	                }
	                else
	                {
	                    _18224 = _17875;
	                }
	                vec2 _17302 = max(_11004, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _21890 = (-normalize(_10061.xyz - PerViewConstantBuffer_t._m6.xyz)).xyz;
	                vec3 _12282 = normalize(_11179.xyz + _21890).xyz;
	                vec3 _19014 = _15462.xyz;
	                float _12387 = dot(_12282, _19014);
	                float _9851 = _17302.x;
	                float _25212 = _9851 * _9851;
	                float _24199 = _25212 / (((_12387 * _12387) * ((_25212 * _25212) - 1.0)) + 1.0);
	                float _16151 = _9851 + 1.0;
	                float _6836 = (_16151 * _16151) * 0.125;
	                float _19571 = 1.0 - _6836;
	                _13212 = _13140.xyz + ((((_22671.xyz + ((vec3(1.0) - _22671.xyz) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11179.xyz, _12282))), 5.0))) * ((_24199 * _24199) / ((4.0 * ((_13812 * _19571) + _6836)) * ((max(0.0, dot(_19014, _21890)) * _19571) + _6836)))).xyz * _13812).xyz * _21549.xyz);
	                _15670 = _16325.xyz + (_18224.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13140 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13139 = _16325;
	        _16324 = _13140;
	        _17017 = _21567;
	        continue;
	    }
	    vec3 _10145 = normalize(_10061.xyz - PerViewConstantBuffer_t._m6.xyz);
	    vec3 _19257 = -_10145;
	    float _17138 = _11004.x + _11004.y;
	    float _19582 = _17138 * _17138;
	    float _17751 = dot(_11004.xy, vec2(0.5));
	    vec3 _6520 = _17892.xyz;
	    vec3 _19081 = _17892.xyz;
	    float _12853 = PerViewLightingConstantBufferGpu_t._m14.y * sqrt(_17751);
	    vec3 _11901 = _10061.xyz;
	    vec3 _11008;
	    vec4 _14444;
	    if (PerViewConstantBufferCsgo_t._m29 != 0.0)
	    {
	        float _9642 = dot(vec4(((_11901 + PerViewConstantBuffer_t._m5.xyz) + ((-PerViewConstantBuffer_t._m7) * PerViewConstantBufferCsgo_t._m29)).xyz, 1.0), vec4(PerViewConstantBuffer_t._m7.xyz, dot((PerViewConstantBuffer_t._m5.xyz + PerViewConstantBuffer_t._m6.xyz).xyz + (PerViewConstantBuffer_t._m7.xyz * PerViewConstantBuffer_t._m4), PerViewConstantBuffer_t._m7.xyz)));
	        vec3 _21713;
	        if (_9642 <= 0.0)
	        {
	            _21713 = _10061;
	        }
	        else
	        {
	            _21713 = _11901 + ((-PerViewConstantBuffer_t._m7.xyz) * _9642);
	        }
	        vec4 _19975 = vec4(_21713.xyz, 1.0) * PerViewConstantBufferCsgo_t._m15;
	        float _20177 = _19975.w;
	        vec2 _11415 = _19975.xy / vec2(_20177);
	        vec4 _6652;
	        _6652.x = clamp(((_11415.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6652.y = clamp(((1.0 - _11415.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6652.w = _20177;
	        _11008 = _21713;
	        _14444 = _6652;
	    }
	    else
	    {
	        _11008 = _11901;
	        _14444 = _11408.xyzw;
	    }
	    float _22047 = _17751 * _17751;
	    float _20711 = saturate(1.0 - _22047);
	    vec3 _25271 = normalize(mix(_6520, reflect(_10145.xyz, _19081).xyz, vec3(_20711 * (sqrt(_20711) + _22047))));
	    uvec2 _6815 = uvec2(_14444.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _12130 = PerViewLightingConstantBufferGpu_t._m11.y + (((_6815.y * PerViewLightingConstantBufferGpu_t._m12.y) + _6815.x) * PerViewLightingConstantBufferGpu_t._m11.z);
	    uint _23394 = PerViewLightingConstantBufferGpu_t._m11.x + (uint(clamp(_14444.w * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m11.z);
	    vec4 _13141;
	    float _16308;
	    vec3 _17116;
	    _13141 = vec4(0.0);
	    _16308 = 0.00999999977648258209228515625;
	    _17116 = vec3(0.0);
	    uint _8896;
	    vec4 _13144;
	    vec3 _14891;
	    float _16310;
	    bool _18360;
	    uint _17020 = 0u;
	    bool _17133 = false;
	    for (;;)
	    {
	        bool _12892;
	        if (_17020 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12892 = !_17133;
	        }
	        else
	        {
	            _12892 = false;
	        }
	        if (!_12892)
	        {
	            break;
	        }
	        uint _14476 = subgroupOr(g_CullBits_1._m0[_12130 + _17020] & g_CullBits_1._m0[_23394 + _17020]);
	        vec3 _13142;
	        vec4 _16309;
	        _13142 = _17116;
	        _16309 = _13141;
	        uint _10156;
	        vec3 _13143;
	        vec4 _16381;
	        float _16479;
	        uint _17021 = _14476;
	        float _17134 = _16308;
	        for (;;)
	        {
	            if (!(_17021 != 0u))
	            {
	                _13144 = _16309;
	                _16310 = _17134;
	                _14891 = _13142;
	                _18360 = _17133;
	                break;
	            }
	            uint _18154 = uint(findLSB(_17021));
	            int _12609 = int(_18154 + (_17020 * 32u));
	            _10156 = _17021 & (_17021 - 1u);
	            vec3 _7748 = (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0 * vec4(_11008.xyz, 1.0)).xyz;
	            vec3 _8793 = saturate((_7748 - PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m5.xyz);
	            vec3 _19651 = saturate((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3 - _7748) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m5.xyz);
	            float _17265 = min(min(_8793.x, min(_8793.y, _8793.z)), min(_19651.x, min(_19651.y, _19651.z)));
	            if (_17265 == 0.0)
	            {
	                _13143 = _13142;
	                _16381 = _16309;
	                _16479 = _17134;
	                _13142 = _13143;
	                _16309 = _16381;
	                _17134 = _16479;
	                _17021 = _10156;
	                continue;
	            }
	            vec3 _19630;
	            if (PerViewConstantBufferCsgo_t._m28 != 0.0)
	            {
	                vec3 _19779 = PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1 + ((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3 - PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1) * 0.5);
	                _19630 = ((_7748 - _19779) * PerViewConstantBufferCsgo_t._m28) + _19779;
	            }
	            else
	            {
	                _19630 = _7748;
	            }
	            vec3 _7648 = (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0 * vec4(_25271.xyz, 0.0)).xyz;
	            vec3 _11253 = max(((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3.xyz - _19630.xyz) / _7648).xyz, ((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1.xyz - _19630.xyz) / _7648).xyz);
	            float _11076 = ((_17265 * _17265) * (((-2.0) * _17265) + 3.0)) * (1.0 - _17134);
	            float _13713 = _17134 + _11076;
	            vec3 _15431 = _13142 + ((textureLod(samplerCubeArray(g_bindless_TextureCubeArray[PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m4], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), vec4(mix(_19630.xyz + (_7648 * abs(min(_11253.x, min(_11253.y, _11253.z)))), _7648, vec3(_17751)).xyz, float(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m2)), _12853).xyz * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m6) * _11076);
	            vec4 _7460 = _16309 + (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m7 * _11076);
	            if (_13713 > 0.9900000095367431640625)
	            {
	                _13144 = _7460;
	                _16310 = _13713;
	                _14891 = _15431;
	                _18360 = true;
	                break;
	            }
	            _13143 = _15431;
	            _16381 = _7460;
	            _16479 = _13713;
	            _13142 = _13143;
	            _16309 = _16381;
	            _17134 = _16479;
	            _17021 = _10156;
	            continue;
	        }
	        _8896 = _17020 + 1u;
	        _13141 = _13144;
	        _16308 = _16310;
	        _17116 = _14891;
	        _17133 = _18360;
	        _17020 = _8896;
	        continue;
	    }
	    vec4 _11487 = textureLod(sampler2DArray(g_bindless_Texture2DArray_float4[PerViewConstantBufferCsgo_t._m5], g_bindless_Sampler[_Globals_.g_sBilinearClamp]), vec3((vec2(_17751, sqrt(1.0 - max(0.0, dot(_19257.xyz, _6520)))) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _7300 = mix(_11487.xxx, _11487.yyy, _22671);
	    float _21809 = 1.0 - _11487.y;
	    vec3 _15517 = _22671 + ((vec3(1.0) - _22671) * vec3(0.0476190485060214996337890625));
	    vec3 _23208 = ((_7300 * _15517) / (vec3(1.0) - (_15517 * _21809))) * _21809;
	    vec3 _13436 = vec3(_21711 * _17476).xyz;
	    vec3 _22686 = (_13139.xyz + ((_18708 * (vec3(1.0) - (_7300 + _23208))).xyz * _13436).xyz) * (_20195.xyz * pow(1.0 - _20079, _Globals_.g_flMetalnessTransitionBias)).xyz;
	    vec4 _11205 = vec4(_22686, input_4.w);
	    _11205.x = _22686.x;
	    _11205.y = _22686.y;
	    _11205.z = _22686.z;
	    vec3 _15752 = _11205.xyz + ((_16324 * (vec3(1.0) + (_22671 * ((0.125 * (_19582 * _19582)) * saturate(dot(_17892, _19257)))))).xyz * _13436).xyz;
	    vec4 _20493 = _11205;
	    _20493.x = _15752.x;
	    _20493.y = _15752.y;
	    _20493.z = _15752.z;
	    vec3 _15733 = _20493.xyz + ((((_17116 / vec3(_16308)).xyz * min(dot(_18708.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_19081, 1.0), (_13141 / vec4(_16308)).xyzw), max((_17751 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_7300 + _23208)).xyz * _13436).xyz;
	    vec4 _13888 = _20493;
	    _13888.x = _15733.x;
	    _13888.y = _15733.y;
	    _13888.z = _15733.z;
	    vec4 _19366;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _6538 = _11901 - PerViewConstantBuffer_t._m6.xyz;
	        vec3 _9057 = _6538.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _6538.xyz;
	            bool _12893;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m21.x)
	            {
	                _12893 = (_10061.z * PerViewConstantBufferCsgo_t._m21.z) < PerViewConstantBufferCsgo_t._m21.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12893)
	            {
	                float _17979 = length(_21493);
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m18.xy + (PerViewConstantBufferCsgo_t._m18.zw * vec2(mix(_17979, _17979 * PerViewConstantBufferCsgo_t._m30.y, _Globals_.g_flFogModificationAmount), _10061.z)));
	                float _13533 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m19.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m19.y)) * PerViewConstantBufferCsgo_t._m20.w;
	                float _12715 = mix(_13533, _13533 * PerViewConstantBufferCsgo_t._m30.z, _Globals_.g_flFogModificationAmount);
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m20.xyz, _12715).xyz, vec3(_12715));
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
	            bool _12894;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m25.x)
	            {
	                _12894 = (PerViewConstantBufferCsgo_t._m25.z * _10061.z) < PerViewConstantBufferCsgo_t._m25.y;
	            }
	            else
	            {
	                _12894 = false;
	            }
	            if (_12894)
	            {
	                float _17980 = length(_21493);
	                float _14602 = saturate(pow(max(0.0, (mix(_17980, _17980 * PerViewConstantBufferCsgo_t._m30.y, _Globals_.g_flFogModificationAmount) * PerViewConstantBufferCsgo_t._m22.y) + PerViewConstantBufferCsgo_t._m22.x), PerViewConstantBufferCsgo_t._m22.w)) * saturate(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m23.y) + PerViewConstantBufferCsgo_t._m23.x), PerViewConstantBufferCsgo_t._m23.z));
	                float _16973 = saturate(_14602) * mix(PerViewConstantBufferCsgo_t._m25.w, PerViewConstantBufferCsgo_t._m25.w * PerViewConstantBufferCsgo_t._m30.z, _Globals_.g_flFogModificationAmount);
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m6], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), normalize((PerViewConstantBufferCsgo_t._m24 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m23.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m22.z))) * PerViewConstantBufferCsgo_t._m26.x).xyz, _16973).xyz, vec3(_16973));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _19366 = _23944;
	    }
	    else
	    {
	        _19366 = _13888;
	    }
	    vec3 _19342;
	    if (_Globals_.g_flSpawnInvulnerability > 0.0)
	    {
	        float _11148 = 1.0 - saturate(dot(_19257, _24735));
	        _19342 = mix(_19366.xyz, _Globals_.g_cInvulnerabilityColor * (mix(dot(_19366.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), 0.5, 0.5) + (4.0 * pow(mix(_11148 * texelFetch(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], ivec3(ivec2(_11408.xy) & PerViewConstantBufferCsgo_t._m14, 0).xy, 0).y, 1.0, _11148), mix(3.0, 6.0, 1.0 + (sin(PerViewConstantBuffer_t._m0 * 20.0) * 0.5))))), vec3(_Globals_.g_flSpawnInvulnerability));
	    }
	    else
	    {
	        _19342 = _19366.xyz;
	    }
	    vec4 _23946 = _19366;
	    _23946.x = _19342.x;
	    _23946.y = _19342.y;
	    _23946.z = _19342.z;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.g_vKeychainGhostHandData.w > 0.0)
	    {
	        float _11567 = saturate((smoothstep(6.0, 2.0, distance(_Globals_.g_vKeychainGhostHandData.xyz, _11901)) - 1.0) * (-1.0));
	        if ((texelFetch(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], ivec3(ivec2(_11408.xy) & PerViewConstantBufferCsgo_t._m14, 0).xy, 0).y - mix((_11567 * 0.5099999904632568359375) + 0.5, (_11567 * 0.90999996662139892578125) + 0.100000001490116119384765625, smoothstep(0.100000001490116119384765625, 1.0, _Globals_.g_vKeychainGhostHandData.w))) < 0.0)
	        {
	            discard;
	        }
	    }
	    if (input_4.w < 1.0)
	    {
	        if ((fma(input_4.w, 2.0, -1.5) + texelFetch(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], ivec3(ivec2(_11408.xy) & PerViewConstantBufferCsgo_t._m14, 0).xy, 0).y) < 0.0)
	        {
	            discard;
	        }
	    }
	    output_0 = _23946;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	BoolAttribute(SupportsLightmapping, false);
	BoolAttribute(PerVertexLighting, true);
	StringAttribute(MaterialLayerType, csgo_weapon);
	BoolAttribute(OpaqueRefract, F_OPAQUE_REFRACT ? 1 : 0);
	
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_SELF_ILLUM == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_TINT_MASK == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_MODE_DEPTH == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_OPAQUE_REFRACT == 1)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_TRANSLUCENT == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
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
	#if (S_OPAQUE_REFRACT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(BlendEnable, true);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthWriteEnable, false);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	#if (S_ENABLE_ADJUSTMENTS == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ALPHA_TEST == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_TRANSLUCENT == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ENABLE_ADJUSTMENTS == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	#endif
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, false);
	#endif
	
	BoolAttribute(BindlessResources, true);
	
}
