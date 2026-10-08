//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Grass Shader";
	DevShader = false;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	Default();
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsShadingComplexity(S_MODE_TOOLS_SHADING_COMPLEXITY);
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
}

FEATURES
{
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_ALPHA_TO_COVERAGE, 0..1, "Alpha to coverage" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vPositionOs     : POSITION0  < Semantic( PosXy ); >;                                   
	float4 vSide_Top_Right : TEXCOORD0  < Semantic( PosXyzw ); >;                                 
	float4 vDensityMask    : TEXCOORD1  < Semantic( PosXyzw ); >;                                 
	float2 nInstanceIdx    : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                     
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	DynamicCombo( D_DENSITY_MODE, 0..2 );
	
	float g_flLerpNormalToZ < Default(0.89); UiType(Slider); >;
	float g_flMinSpriteHeight < Default(16); Range(1, 50); UiType(Slider); >;
	float g_flWindFactor < Default(0.25); Range(0, 3); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tDensityArray < Attribute("DensityArray"); SrgbRead(false); >;
	Texture2D g_tHeightArray < Attribute("HeightArray"); SrgbRead(false); >;
	Texture2D g_tSkewBrightness < Attribute("SkewBrightness"); SrgbRead(false); >;
	Texture2D g_tTintArray < Attribute("TintArray"); SrgbRead(true); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float3 g_vFadeParams < Default3(3000, 1000, 1); Attribute("FadeParams"); UiType(VectorText); >;
	float3 g_vWindOffset < Default3(0.25, 0.2, 0.21); Attribute("WindOffset"); UiType(VectorText); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 4 (name: g_vWindOffset) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	struct _1119
	{
	    mat3x4 _m0;
	};
	
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
	
	struct _869
	{
	    vec4 _m0[8];
	};
	
	vec2 _3;
	vec4 _4;
	vec3 _5;
	vec2 _6;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	struct _129
	{
	    _869 _m0;
	    _869 _m1;
	    _869 _m2;
	    _869 _m3;
	    _869 _m4;
	};
	
	layout(set = 0) uniform _129 GrassParamsPerQuadSlice_t;
	
	struct _1163
	{
	    vec3 g_vFadeParams;
	    float g_flMinSpriteHeight;
	    float g_flLerpNormalToZ;
	    float g_flWindFactor;
	    vec3 g_vWindOffset;
	};
	
	layout(set = 0) uniform _1163 _Globals_;
	
	struct _1388
	{
	    mat4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 0) uniform _1388 PerViewConstantBuffer_t;
	
	struct _1164
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _1164 PerViewConstantBufferCsgo_t;
	
	layout(set = 0, binding = 30) uniform texture2D g_tDensityArray;
	layout(set = 0, binding = 14) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipPoint;
	layout(set = 0, binding = 31) uniform texture2D g_tHeightArray;
	layout(set = 0, binding = 15) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear;
	layout(set = 0, binding = 32) uniform texture2D g_tSkewBrightness;
	layout(set = 0, binding = 16) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_1;
	layout(set = 0, binding = 33) uniform texture2D g_tTintArray;
	layout(set = 0, binding = 17) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_2;
	
	layout(location = 0) in vec2 vPositionOs;
	layout(location = 1) in vec4 vSide_Top_Right;
	layout(location = 2) in vec4 vDensityMask;
	layout(location = 3) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec2 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec3 output_4;
	layout(location = 5) out vec4 output_5;
	layout(location = 6) out float output_6;
	layout(location = 7) flat out uint output_7;
	
	void main()
	{
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
	    float _19167;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _19167 = _17828.z;
	    }
	    else
	    {
	        _19167 = _7676.z;
	    }
	    vec4 _16649;
	    _16649.x = _21354;
	    _16649.y = _21355;
	    vec4 _10881 = fract(vDensityMask.xyzw + (saturate(vDensityMask.xyzw * 1000000.0) * ((g_transformBuffer_1._m0[nInstanceIdx]._m0[0].w * 0.013698630034923553466796875) + (g_transformBuffer_1._m0[nInstanceIdx]._m0[1].w * 0.005181347019970417022705078125))));
	    float _20623 = abs(vPositionOs.x);
	    vec2 _10547 = (_16649.xy + (vec2(clamp(_20623, 0.03125, 0.96875), clamp(vPositionOs.y, 0.03125, 0.96875)).xy * _19167)).xy;
	    vec4 _12684 = textureLod(sampler2D(g_tSkewBrightness, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_1), _10547, 0.0);
	    vec2 _7707 = (_12684.xy * 2.0) - vec2(1.0);
	    vec3 _22101;
	    _22101.x = _7707.x;
	    _22101.y = _7707.y;
	    vec3 _23286 = vec3(256.0 * (_20623 - 0.5), 256.0 * (vPositionOs.y - 0.5), textureLod(sampler2D(g_tHeightArray, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear), _10547, 0.0).x);
	    vec4 _13292 = _10881 * 1000000.0;
	    float _14802 = saturate(dot(textureLod(sampler2D(g_tDensityArray, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipPoint), _10547, 0.0).xyzw - _10881, _13292));
	    float _18203 = saturate(vSide_Top_Right.y * 1000000.0);
	    float _23404 = _23812.w;
	    int _23994 = int(_23404);
	    vec4 _7832 = saturate(_13292);
	    float _15699 = dot(mix(GrassParamsPerQuadSlice_t._m1._m0[_23994], GrassParamsPerQuadSlice_t._m2._m0[_23994], vec4(vSide_Top_Right.y)), _7832) * _14802;
	    float _20522 = (_15699 < _Globals_.g_flMinSpriteHeight) ? 0.0 : _15699;
	    vec3 _22017 = vec4(_23286.xyz, 1.0) * g_transformBuffer_1._m0[nInstanceIdx]._m0;
	    vec3 _14658 = _22017.xyz;
	    vec3 _17003 = _14658 - PerViewConstantBuffer_t._m3.xyz;
	    _17003.z = 0.0;
	    vec3 _25001 = normalize(_17003);
	    vec3 _9094 = normalize(cross(vec3(0.0, 0.0, 1.0), _25001));
	    vec2 _13861 = _23286.xy + ((_9094.xy * (0.5 * ((vec4(vec2(vSide_Top_Right.x, _18203).xy, _3) * 2.0) - vec4(1.0)).x)) * (dot(GrassParamsPerQuadSlice_t._m0._m0[_23994], _7832) * _14802));
	    vec3 _20488 = _23286;
	    _20488.x = _13861.x;
	    _20488.y = _13861.y;
	    vec3 _11565 = PerViewConstantBuffer_t._m3.xyz - _22017;
	    float _19511 = _11565.z;
	    _11565.z = _19511 * smoothstep(60.0, 120.0, _19511);
	    float _14690 = smoothstep(-5.0, 95.0, length(_11565));
	    float _19893 = dot(vec4(0.0, 1.0, 2.0, 3.0), _7832);
	    float _8065 = _23404 * 0.125;
	    vec2 _10633;
	    if ((float(int(sign(vPositionOs.x))) * (dot(GrassParamsPerQuadSlice_t._m4._m0[_23994], _7832) * _14802)) > 0.0)
	    {
	        vec2 _10180;
	        _10180.x = _8065 + (((1.0 - vSide_Top_Right.x) + _19893) * 0.03125);
	        _10633 = _10180;
	    }
	    else
	    {
	        vec2 _10181;
	        _10181.x = _8065 + ((vSide_Top_Right.x + _19893) * 0.03125);
	        _10633 = _10181;
	    }
	    vec3 _21625 = (vec4((_20488 + (((mix(vec3(0.0, 0.0, 1.0) - (normalize(_11565) * (1.0 - _14690)), vec3(0.0, 0.0, 1.0), vec3(_14690)) * _18203) * _20522) * (1.0 - length(((vec3(_22101.xy, 0.0) * mat3(g_transformBuffer_1._m0[nInstanceIdx]._m0[0].xyz, g_transformBuffer_1._m0[nInstanceIdx]._m0[1].xyz, g_transformBuffer_1._m0[nInstanceIdx]._m0[2].xyz)).xyz * _Globals_.g_vFadeParams.z).xyz)))).xyz, 1.0) * g_transformBuffer_1._m0[nInstanceIdx]._m0).xyz;
	    float _15276 = length((_21625 - PerViewConstantBuffer_t._m3).xyz);
	    float _24399 = 1.0 - saturate((_15276 - _Globals_.g_vFadeParams.x) / _Globals_.g_vFadeParams.y);
	    _14658.z = 0.0;
	    vec3 _7692 = (_14658.xyz * PerViewConstantBufferCsgo_t._m1.yyy) + _Globals_.g_vWindOffset.xyz;
	    float _20211 = _7692.x;
	    vec4 _20489;
	    _20489.x = _20211;
	    _20489.y = _7692.y;
	    _20489.z = _7692.z;
	    vec4 _21368 = abs((fract((fract(vec4(_20211, _7692.yz, dot(_20489.xyz, vec3(1.0))).xyzw * vec4(0.5, 1.0, 0.5, 1.5)) * 2.0) + vec4(-0.5)) * 2.0) - vec4(1.0));
	    vec3 _13823 = _21625 + ((_9094 * (length((((PerViewConstantBufferCsgo_t._m0.xyz * (dot((((_21368 * _21368) * (vec4(3.0) - (_21368 * 2.0))) * vec4(1.0, 0.5, 0.25, 0.0500000007450580596923828125)).xyzw, vec4(1.0)) * PerViewConstantBufferCsgo_t._m1.x)) * (dot(GrassParamsPerQuadSlice_t._m3._m0[_23994], _7832) * _14802)) * vec3(_Globals_.g_flWindFactor)) * _18203) - ((0.5 * _Globals_.g_flWindFactor) * _18203))) * _20522);
	    vec4 _18237 = (vec4(_13823.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec3 _9187 = _13823.xyz;
	    vec4 _25134 = vec4(1.0);
	    _25134.w = (mix(0.20000000298023223876953125, 1.0, saturate(smoothstep(-0.75, 2.25, _14690))) * _24399) * mix(1.0, 0.5, smoothstep(800.0, 1700.0, _15276));
	    output_0 = _9187 - PerViewConstantBufferCsgo_t._m2.xyz;
	    output_1 = normalize(mix(-_25001, vec3(0.0, 0.0, 1.0), vec3(_Globals_.g_flLerpNormalToZ)));
	    output_2 = vec2(_10633.x, 1.0 - _18203);
	    output_3 = vec3(textureLod(sampler2D(g_tTintArray, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_2), _10547, 0.0).xyz);
	    output_4 = vec3(_12684.z, _24399, 0.0);
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	    output_5 = _25134;
	    output_6 = dot(vec4(_9187, 1.0), PerViewConstantBuffer_t._m1.xyzw);
	    output_7 = 0u;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_MODE_TOOLS_SHADING_COMPLEXITY, 0..1 );
	StaticCombo( S_ALPHA_TO_COVERAGE, F_ALPHA_TO_COVERAGE );
	DynamicCombo( D_ALPHA_TEST, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_VERTEX_STREAM ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flAlphaTestThreshold < Default(0.3); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tColor < Attribute("GrassQuadArray"); SrgbRead(true); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tGrassQuadSpecularArray < Attribute("GrassQuadSpecularArray"); SrgbRead(false); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vGrassColorTint < UiType(Color); Expression(SrgbGammaToLinear(this)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Lighting
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1108
	{
	    float4 _m0[3];
	};
	
	struct _1890
	{
	    float4 _m0[4];
	};
	
	struct _2452
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
	
	static float4 _3;
	static float _4;
	static float3 _5;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float3 _Globals_1_g_vGrassColorTint : packoffset(c0);
	    int _Globals_1_g_bFogEnabled : packoffset(c1.y);
	    float _Globals_1_m2 : packoffset(c6.y);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c12);
	    float4 PerViewConstantBufferCsgo_t_1_m3 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m4 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m5 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m6 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    float4 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c0);
	    float4 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c1);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c2);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c3);
	    _1108 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c7);
	    float4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1953.z);
	    float4 PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1955.w);
	    _2452 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _1890 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
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
	Texture2D<float4> g_tColor : register(t43, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_Filter_Anisotropic_MaxAniso_8_MipBias_0 : register(s14, space1);
	Texture2D<float4> g_tGrassQuadSpecularArray : register(t44, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_Filter_Anisotropic_MaxAniso_8 : register(s15, space1);
	Texture2D<float4> g_tAmbientOcclusion : register(t53, space1);
	SamplerState g_sUserConfig : register(s21, space1);
	SamplerComparisonState g_tShadowDepthBufferCmpSampler : register(s25, space1);
	Texture2D<float4> g_tShadowDepthBufferDepth : register(t36, space1);
	Texture2D<float4> g_tParticleShadowBuffer : register(t51, space1);
	SamplerState g_sTrilinearClamp : register(s19, space1);
	SamplerState g_sTrilinearWrap : register(s18, space1);
	Texture3D<float4> g_tLightCookieTexture : register(t34, space1);
	SamplerState g_sCookieSampler : register(s24, space1);
	TextureCube<float4> g_tFogCubeTexture : register(t42, space1);
	
	static float4 gl_FragCoord;
	static float2 input_2;
	static float4 input_5;
	static float3 input_3;
	static float3 input_0;
	static float3 input_1;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float2 input_2 : TEXCOORD2;
	    float3 input_3 : TEXCOORD3;
	    float4 input_5 : TEXCOORD5;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _22832 = g_tColor.Sample(AddressU_Clamp_AddressV_Clamp_Filter_Anisotropic_MaxAniso_8_MipBias_0, input_2.xy);
	    float _18841 = _22832.w * input_5.w;
	    float3 _15938 = float4(clamp(_22832.xyz * (dot(sqrt(input_3.xyz), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)) * 2.0f).xxx, 0.0f.xxx, 1.0f.xxx), _18841).xyz;
	    float3 _10120 = lerp(_15938, (input_3.xyz * dot(_15938, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f))) / max(dot(input_3.xyz, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 9.9999999747524270787835121154785e-07f).xxx, g_tGrassQuadSpecularArray.Sample(AddressU_Clamp_AddressV_Clamp_Filter_Anisotropic_MaxAniso_8, input_2.xy).y.xxx);
	    float4 _17842;
	    _17842.x = _10120.x;
	    _17842.y = _10120.y;
	    _17842.z = _10120.z;
	    float4 _11408 = gl_FragCoord;
	    _11408.w = 1.0f / _11408.w;
	    float3 _7029 = normalize(input_1.xyz);
	    float3 _10753 = input_0 + PerViewConstantBufferCsgo_t_1_m12.xyz;
	    float4 _19068 = g_tAmbientOcclusion.Sample(g_sUserConfig, input_2.xy);
	    float3 _24735 = _7029.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    float _21709;
	    [branch]
	    if (PerViewLightingConstantBufferGpu_t_1_m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        float3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m11))
	            {
	                _13136 = 1.0f;
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
	            float2 _7045;
	            float2 _7046;
	            float2 _7735;
	            float _8969;
	            float _8970;
	            float _15996;
	            float _17299;
	            float2 _18870;
	            float4 _20581;
	            float4 _22023;
	            float _23727;
	            do
	            {
	                float _21452 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t_1_m12);
	                _20581 = PerViewLightingConstantBufferGpu_t_1_m0;
	                _22023 = PerViewLightingConstantBufferGpu_t_1_m1;
	                _17299 = PerViewLightingConstantBufferGpu_t_1_m2.z;
	                _15996 = PerViewLightingConstantBufferGpu_t_1_m3.z;
	                _18870 = float2(_17299, _15996);
	                _8969 = PerViewLightingConstantBufferGpu_t_1_m2.y;
	                _7045 = float2(_8969, _15996);
	                _8970 = PerViewLightingConstantBufferGpu_t_1_m3.y;
	                _7046 = float2(_17299, _8970);
	                _7735 = float2(_8969, _8970);
	                float _15310 = dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + _18870).xy, _21452), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + _7045).xy, _21452), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + _7046).xy, _21452), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + _7735).xy, _21452)).xyzw, 0.25f.xxxx);
	                bool _12885;
	                if (_15310 == 0.0f)
	                {
	                    _12885 = true;
	                }
	                else
	                {
	                    _12885 = _15310 == 1.0f;
	                }
	                if (_12885)
	                {
	                    _23727 = _15310;
	                    break;
	                }
	                _23727 = ((_15310 * (_20581.w * 4.0f)) + dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + float2(_17299, 0.0f)).xy, _21452), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + float2(_8969, 0.0f)).xy, _21452), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + float2(0.0f, _8970)).xy, _21452), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14975.xy + float2(0.0f, _15996)).xy, _21452)).xyzw, _22023.xxxx)) + (g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, _14975.xy, _21452) * _22023.y);
	                break;
	            } while(false);
	            float _12502;
	            [branch]
	            if (_13136 < 1.0f)
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
	                    float _12501;
	                    do
	                    {
	                        float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t_1_m12);
	                        float _15311 = dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + _18870).xy, _20322), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + _7045).xy, _20322), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + _7046).xy, _20322), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + _7735).xy, _20322)).xyzw, 0.25f.xxxx);
	                        bool _12886;
	                        if (_15311 == 0.0f)
	                        {
	                            _12886 = true;
	                        }
	                        else
	                        {
	                            _12886 = _15311 == 1.0f;
	                        }
	                        if (_12886)
	                        {
	                            _12501 = _15311;
	                            break;
	                        }
	                        _12501 = ((_15311 * (_20581.w * 4.0f)) + dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + float2(_17299, 0.0f)).xy, _20322), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + float2(_8969, 0.0f)).xy, _20322), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + float2(0.0f, _8970)).xy, _20322), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_20489.xy + float2(0.0f, _15996)).xy, _20322)).xyzw, _22023.xxxx)) + (g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, _20489.xy, _20322) * _22023.y);
	                        break;
	                    } while(false);
	                    _7934 = _12501;
	                }
	                else
	                {
	                    _7934 = 1.0f;
	                }
	                _12502 = lerp(_7934, _23727, _13136);
	            }
	            else
	            {
	                _12502 = _23727;
	            }
	            _19363 = _12502;
	        }
	        else
	        {
	            _19363 = 1.0f;
	        }
	        float _12513 = lerp(_19363, 1.0f, saturate((distance(_10753.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m17) + PerViewLightingConstantBufferGpu_t_1_m16));
	        float _12503;
	        if (bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w).y)
	        {
	            _12503 = min(_12513, g_tParticleShadowBuffer.SampleLevel(g_sTrilinearClamp, (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12503 = _12513;
	        }
	        _21709 = _12503;
	    }
	    else
	    {
	        _21709 = 1.0f;
	    }
	    float3 _21710;
	    [branch]
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _24735) * _21709) > 0.0f)
	    {
	        _21710 = PerViewLightingConstantBufferGpu_t_1_m5.xyz + (max(0.0f, dot(_7029.xyz, PerViewLightingConstantBufferGpu_t_1_m9.xyz)).xxx.xyz * (PerViewLightingConstantBufferGpu_t_1_m10.xyz * _21709).xyz);
	    }
	    else
	    {
	        _21710 = PerViewLightingConstantBufferGpu_t_1_m5.xyz;
	    }
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20059 = _24465.x;
	    float4 _19364;
	    if (_20059)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m2, float4(_10753.xyz, 1.0f).xyzw);
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
	    uint2 _12083 = uint2(_19364.xy - PerViewConstantBuffer_t_1_m0.xy) >> PerViewLightingConstantBufferGpu_t_1_m7.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m6.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m7.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m6.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m6.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t_1_m8.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m8.y)) * PerViewLightingConstantBufferGpu_t_1_m6.z);
	    float3 _13155;
	    _13155 = _21710;
	    uint _21567;
	    float3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t_1_m6.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load((_10838 + _16208) * 4 + 0) & g_CullBits.Load((_23393 + _16208) * 4 + 0));
	        _13156 = _13155;
	        uint _20344;
	        float3 _12505;
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
	                float4 _24893 = mul(float4(input_0.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
	                float3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7424 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
	                }
	                else
	                {
	                    _7424 = false;
	                }
	                bool _12887;
	                if (!_7424)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), _16509).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _12505 = _13156;
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
	                    _21316 = smoothstep(0.0f, 1.0f, _21776 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * smoothstep(0.0f, 1.0f, (1.0f - _21776) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz - input_0.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    float3 _20958 = _10017 - _16268;
	                    float3 _10210;
	                    do
	                    {
	                        float3 _20229 = (_10017 + _16268) - _20958;
	                        float _25105 = dot(-_20958, _20229);
	                        if (_25105 <= 0.0f)
	                        {
	                            _10210 = _20958;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _20958 + (_20229 * min(1.0f, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / _17647.xxx;
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w))) * smoothstep(0.0f, 1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).y * _17647))) * saturate(asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).y * dot(float3((1.0f - (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)), normalize(_10210))));
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
	                    _24419 = !_20059;
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
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * _15017, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15017, _15266), 1.1754943508222875079687365372222e-38f), _23041);
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
	                    float3 _12504;
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
	                        _12504 = _17828.xyz * g_tLightCookieTexture.SampleLevel(g_sTrilinearWrap, _20491.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12504 = _17828.xyz * g_tLightCookieTexture.SampleLevel(g_sCookieSampler, _20490.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _12505 = _13156;
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
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t_1_m12);
	                        float2 _14615 = float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy;
	                        float _15312 = dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.z, PerViewLightingConstantBufferGpu_t_1_m3.z)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.y, PerViewLightingConstantBufferGpu_t_1_m3.z)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.z, PerViewLightingConstantBufferGpu_t_1_m3.y)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.y, PerViewLightingConstantBufferGpu_t_1_m3.y)).xy, _11455)).xyzw, 0.25f.xxxx);
	                        bool _12888;
	                        if (_15312 == 0.0f)
	                        {
	                            _12888 = true;
	                        }
	                        else
	                        {
	                            _12888 = _15312 == 1.0f;
	                        }
	                        if (_12888)
	                        {
	                            _24972 = _15312;
	                            break;
	                        }
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t_1_m0.w * 4.0f)) + dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.z, 0.0f)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.y, 0.0f)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(0.0f, PerViewLightingConstantBufferGpu_t_1_m3.y)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(0.0f, PerViewLightingConstantBufferGpu_t_1_m3.z)).xy, _11455)).xyzw, PerViewLightingConstantBufferGpu_t_1_m1.xxxx)) + (g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, _14615, _11455) * PerViewLightingConstantBufferGpu_t_1_m1.y);
	                        break;
	                    } while(false);
	                    float3 _19878 = _21548.xyz * lerp(1.0f, _24972, asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
	                    float3 _16449 = _19878.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
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
	                _12505 = _13156.xyz + (max(0.0f, dot(_7029.xyz, _11179.xyz)).xxx.xyz * _19630.xyz);
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
	    float3 _22686 = (_13155.xyz + (float3(dot(PerViewLightingConstantBufferGpu_t_1_m4._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m4._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m4._m0[2].xyzw, _23875)).xyz * _19068.x.xxx.xyz).xyz) * (_17842.xyz * _Globals_1_g_vGrassColorTint).xyz;
	    float _12931 = _22686.x;
	    float4 _11203 = float4(_12931, _22686.yz, _4);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    float4 _18787;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _10666 = _10753.xyz - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _10666.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _10666.xyz;
	            bool _12889;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m6.x)
	            {
	                _12889 = (_10753.z * PerViewConstantBufferCsgo_t_1_m6.z) < PerViewConstantBufferCsgo_t_1_m6.y;
	            }
	            else
	            {
	                _12889 = false;
	            }
	            [branch]
	            if (_12889)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m3.xy + (PerViewConstantBufferCsgo_t_1_m3.zw * float2(length(_21493), _10753.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m4.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m4.y)) * PerViewConstantBufferCsgo_t_1_m5.w;
	                _19340 = lerp(_11203.xyz, float4(PerViewConstantBufferCsgo_t_1_m5.xyz, _12872).xyz, _12872.xxx);
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
	            bool _12890;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m10.x)
	            {
	                _12890 = (PerViewConstantBufferCsgo_t_1_m10.z * _10753.z) < PerViewConstantBufferCsgo_t_1_m10.y;
	            }
	            else
	            {
	                _12890 = false;
	            }
	            if (_12890)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m7.y) + PerViewConstantBufferCsgo_t_1_m7.x), PerViewConstantBufferCsgo_t_1_m7.w)) * saturate(pow(max(0.0f, (_10753.z * PerViewConstantBufferCsgo_t_1_m8.y) + PerViewConstantBufferCsgo_t_1_m8.x), PerViewConstantBufferCsgo_t_1_m8.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m10.w;
	                _19341 = lerp(_23944.xyz, float4((g_tFogCubeTexture.SampleLevel(g_sTrilinearClamp, normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m9).xyz).xyz, PerViewConstantBufferCsgo_t_1_m8.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m7.z))) * PerViewConstantBufferCsgo_t_1_m11.x).xyz, _8892).xyz, _8892.xxx);
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _18787 = _23944;
	    }
	    else
	    {
	        _18787 = _11203;
	    }
	    float4 _23377 = _18787;
	    _23377.w = _18841;
	    output_0 = _23377;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_2 = stage_input.input_2;
	    input_5 = stage_input.input_5;
	    input_3 = stage_input.input_3;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(translucent, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	BoolAttribute(DoNotCastShadows, false);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, false);
	BoolAttribute(ForwardLayerOnly, true);
	BoolAttribute(mapbuilder_donotcollapse, true);
	
	
	// PSRS
	
	RenderState(AlphaToCoverageEnable, F_ALPHA_TO_COVERAGE);
	RenderState(DepthEnable, exists(ShaderVar_WireframeDepthEnable) ? ShaderVar_WireframeDepthEnable : true);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
}
