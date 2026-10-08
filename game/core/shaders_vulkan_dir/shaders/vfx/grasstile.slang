//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Grass Shader";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Forward();
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vPositionOs                       : POSITION0  < Semantic( PosXy ); >;                 
	float4 vSide_Top_Right                   : TEXCOORD0  < Semantic( PosXyzw ); >;               
	float4 vDensityMask                      : TEXCOORD1  < Semantic( PosXyzw ); >;               
	float2 nInstanceIdx                      : TEXCOORD13 < Semantic( InstanceTransformUv ); >;   
	float2 vUStart_VStart_UVScale_GrassQuadU : TEXCOORD14 < Semantic( InstanceTransformUv ); >;   
};

VS
{
	StaticCombo( S_TOOLS_ENABLED, 0, Sys( 1 ) );
	DynamicCombo( D_DENSITY_MODE, 0..2 );
	DynamicCombo( D_TOP_DOWN_VIEW, 0..1 );
	DynamicCombo( D_SUN_SHADOW_CASCADE_SIZE, 0..4 );
	DynamicCombo( D_VERTEX_LIGHTING, 0..1 );
	DynamicComboRule( Requires( D_SUN_SHADOW_CASCADE_SIZE, D_VERTEX_LIGHTING ) );
	
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	Texture2D g_tDensityArray < Attribute("DensityArray"); SrgbRead(false); >;
	Texture2D g_tHeightArray < Attribute("HeightArray"); SrgbRead(false); >;
	Texture2D g_tSkewBrightness < Attribute("SkewBrightness"); SrgbRead(false); >;
	Texture2D g_tTintArray < Attribute("TintArray"); SrgbRead(false); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float3 g_vFadeParams < Default3(1000, 1500, 1); Attribute("FadeParams"); UiType(VectorText); >;
	float3 g_vWindDir < Default2(0.707, 0.707); Attribute("WindDir"); UiType(VectorText); >;
	float3 g_vWindOffset < Default3(0.25, 0.2, 0.21); Attribute("WindOffset"); UiType(VectorText); >;
	float4 g_vWindStrengthFreqMulHighStrength < Default4(0.25, 0.03, 0.003, 0.25); Attribute("WindStrengthFreq"); UiType(VectorText); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 2 (name: g_vWindDir) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _113
	{
	    vec4 _m0[8];
	};
	
	vec3 _3;
	vec2 _4;
	vec4 _5;
	
	layout(set = 0, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 0, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _64
	{
	    _113 _m0;
	    _113 _m1;
	    _113 _m2;
	    _113 _m3;
	    _113 _m4;
	};
	
	layout(set = 0) uniform _64 GrassParamsPerQuadSlice_t;
	
	struct _1209
	{
	    vec4 g_vWindStrengthFreqMulHighStrength;
	    vec3 g_vWindOffset;
	    vec3 g_vWindDir;
	    vec3 g_vFadeParams;
	};
	
	layout(set = 0) uniform _1209 _Globals_;
	
	struct _1288
	{
	    mat4 _m0;
	    vec4 _m1;
	    vec3 _m2;
	};
	
	layout(set = 0) uniform _1288 PerViewConstantBuffer_t;
	
	layout(set = 0, binding = 35) uniform texture2D g_tDensityArray;
	layout(set = 0, binding = 14) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear;
	layout(set = 0, binding = 36) uniform texture2D g_tHeightArray;
	layout(set = 0, binding = 15) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_1;
	layout(set = 0, binding = 37) uniform texture2D g_tSkewBrightness;
	layout(set = 0, binding = 16) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_2;
	layout(set = 0, binding = 38) uniform texture2D g_tTintArray;
	layout(set = 0, binding = 17) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_3;
	
	layout(location = 0) in vec2 vPositionOs;
	layout(location = 1) in vec4 vSide_Top_Right;
	layout(location = 2) in vec4 vDensityMask;
	layout(location = 3) in uint nInstanceIdx;
	layout(location = 4) in vec4 vUStart_VStart_UVScale_GrassQuadU;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec2 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec3 output_4;
	
	void main()
	{
	    vec4 _10881 = fract(vDensityMask.xyzw + (saturate(vDensityMask.xyzw * 1000000.0) * ((g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].w * 0.013698630034923553466796875) + (g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[1].w * 0.005181347019970417022705078125))));
	    float _21853 = abs(vPositionOs.x);
	    vec2 _10547 = (vUStart_VStart_UVScale_GrassQuadU.xy + (vec2(_21853, vPositionOs.y) * vUStart_VStart_UVScale_GrassQuadU.z)).xy;
	    vec4 _10799 = textureLod(sampler2D(g_tHeightArray, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_1), _10547, 0.0);
	    float _17919 = _10799.x;
	    vec4 _12684 = textureLod(sampler2D(g_tSkewBrightness, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_2), _10547, 0.0);
	    vec2 _7707 = (_12684.xy * 2.0) - vec2(1.0);
	    vec3 _22101;
	    _22101.x = _7707.x;
	    _22101.y = _7707.y;
	    vec4 _13292 = _10881 * 1000000.0;
	    float _14802 = saturate(dot(textureLod(sampler2D(g_tDensityArray, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear), _10547, 0.0).xyzw - _10881, _13292));
	    float _18203 = saturate(vSide_Top_Right.y * 1000000.0);
	    vec4 _24664 = (vec4(vec2(vSide_Top_Right.x, _18203).xy, vSide_Top_Right.zw) * 2.0) - vec4(1.0);
	    vec3 _24823 = normalize(vec3(_24664.zw, 0.0));
	    int _18779 = int(vUStart_VStart_UVScale_GrassQuadU.w);
	    vec4 _7832 = saturate(_13292);
	    float _15699 = dot(mix(GrassParamsPerQuadSlice_t._m1._m0[_18779], GrassParamsPerQuadSlice_t._m2._m0[_18779], vec4(vSide_Top_Right.y)), _7832) * _14802;
	    vec3 _13005 = ((vec3(_22101.xy, 0.0) * mat3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].xyz, g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[1].xyz, g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[2].xyz)).xyz * _Globals_.g_vFadeParams.z).xyz;
	    float _11300 = length(_13005);
	    vec3 _18636 = vec3(_11300);
	    float _6967 = dot(vec4(0.0, 1.0, 2.0, 3.0), _7832);
	    float _23131 = vUStart_VStart_UVScale_GrassQuadU.w * 0.125;
	    vec2 _10633;
	    if ((float(int(sign(vPositionOs.x))) * (dot(GrassParamsPerQuadSlice_t._m4._m0[_18779], _7832) * _14802)) > 0.0)
	    {
	        vec2 _10180;
	        _10180.x = _23131 + (((1.0 - vSide_Top_Right.x) + _6967) * 0.03125);
	        _10633 = _10180;
	    }
	    else
	    {
	        vec2 _10181;
	        _10181.x = _23131 + ((vSide_Top_Right.x + _6967) * 0.03125);
	        _10633 = _10181;
	    }
	    vec3 _13631 = (vec4(vec3(vec3(256.0 * (_21853 - 0.5), 256.0 * (vPositionOs.y - 0.5), _17919).xy + ((_24823.xy * (0.5 * _24664.x)) * (dot(GrassParamsPerQuadSlice_t._m0._m0[_18779], _7832) * _14802)), _17919 + ((_18203 * _15699) * (1.0 - _11300))).xyz, 1.0) * g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0).xyz;
	    vec3 _6344 = _13631;
	    _6344.z = 0.0;
	    vec3 _7692 = (_6344.xyz * _Globals_.g_vWindStrengthFreqMulHighStrength.yyy) + _Globals_.g_vWindOffset.xyz;
	    float _20211 = _7692.x;
	    vec4 _20488;
	    _20488.x = _20211;
	    _20488.y = _7692.y;
	    _20488.z = _7692.z;
	    vec4 _21368 = abs((fract((fract(vec4(_20211, _7692.yz, dot(_20488.xyz, vec3(1.0))).xyzw * vec4(0.5, 1.0, 0.5, 1.5)) * 2.0) + vec4(-0.5)) * 2.0) - vec4(1.0));
	    vec3 _9428 = mix((_Globals_.g_vWindDir * (dot((((_21368 * _21368) * (vec4(3.0) - (_21368 * 2.0))) * vec4(1.0, 0.5, 0.25, 0.0500000007450580596923828125)).xyzw, vec4(1.0)) * _Globals_.g_vWindStrengthFreqMulHighStrength.x)) * (dot(GrassParamsPerQuadSlice_t._m3._m0[_18779], _7832) * _14802), (_13005 / _18636).xyz, _18636) * _18203;
	    vec3 _15100 = _13631 + (_9428 * _15699);
	    vec4 _17914 = (vec4(_15100.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = _15100;
	    output_1 = mix(cross(vec3(0.0, 0.0, 1.0), _24823).xyz, (vec3(0.0, 0.0, 1.0) + _9428.xyz).xyz, vec3(0.800000011920928955078125));
	    output_2 = vec2(_10633.x, 1.0 - _18203);
	    output_3 = vec3(textureLod(sampler2D(g_tTintArray, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_3), _10547, 0.0).xyz);
	    output_4 = vec3(_12684.z, 1.0 - saturate((length((_13631 - PerViewConstantBuffer_t._m2).xyz) - _Globals_.g_vFadeParams.x) / _Globals_.g_vFadeParams.y), 0.0);
	    _17914.y = -_17914.y;
	    gl_Position = _17914;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_TOOLS_ENABLED, 0, Sys( 1 ) );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	DynamicCombo( D_ALPHA_TEST, 0..1 );
	DynamicCombo( D_SUN_SHADOW_CASCADE_SIZE, 0..4 );
	DynamicCombo( D_VERTEX_LIGHTING, 0..1 );
	DynamicComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, D_SUN_SHADOW_CASCADE_SIZE ) );
	DynamicComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, D_VERTEX_LIGHTING ) );
	
	RenderState(DepthEnable, exists(ShaderVar_WireframeDepthEnable) ? ShaderVar_WireframeDepthEnable : true);
	float g_flAlphaTestThreshold < Default(0.3); UiType(Slider); >;
	Texture2D g_tGrassQuadArray < Attribute("GrassQuadArray"); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer RoughnessLightingGlobalsCB_t : register(b3, space1)
	{
	    float4 RoughnessLightingGlobalsCB_t_1_m0 : packoffset(c0);
	};
	
	cbuffer SunLightShaderParamsCB_t : register(b4, space1)
	{
	    float3 SunLightShaderParamsCB_t_1_m0 : packoffset(c0);
	    float3 SunLightShaderParamsCB_t_1_m1 : packoffset(c1);
	};
	
	Texture2D<float4> g_tGrassQuadArray : register(t31, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MipBias_0 : register(s15, space1);
	
	static float3 input_1;
	static float2 input_2;
	static float3 input_3;
	static float3 input_4;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_1 : TEXCOORD1;
	    float2 input_2 : TEXCOORD2;
	    float3 input_3 : TEXCOORD3;
	    float3 input_4 : TEXCOORD4;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _19372 = g_tGrassQuadArray.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MipBias_0, input_2.xy);
	    float _14493 = _19372.w * input_4.y;
	    float3 _14744 = normalize(input_1.xyz).xyz;
	    float3 _23378 = clamp(_14744, 0.0f.xxx, 1.0f.xxx);
	    float3 _23904 = clamp(-_14744, 0.0f.xxx, 1.0f.xxx);
	    output_0 = float4(float4(((_19372.xyz * input_3.xyz) * lerp(0.0f.xxx, 1.0f.xxx, (clamp(input_4.x, 0.0f, 0.699999988079071044921875f) * 1.4285714626312255859375f).xxx).xyz) * input_4.x, _14493).xyz * ((RoughnessLightingGlobalsCB_t_1_m0.xyz * (dot(float3(0.60000002384185791015625f, 0.4000000059604644775390625f, 1.0f), _23378 * _23378) + dot(float3(0.60000002384185791015625f, 0.4000000059604644775390625f, 0.20000000298023223876953125f), _23904 * _23904))).xyz + ((SunLightShaderParamsCB_t_1_m0.xyz * (pow(saturate(dot(_14744, SunLightShaderParamsCB_t_1_m1.xyz)), 0.60000002384185791015625f) * 0.800000011920928955078125f)) * 1.0f)).xyz, _14493);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, true);
	BoolAttribute(ForwardLayerOnly, true);
	
}
