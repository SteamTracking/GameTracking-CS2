//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Scalable Ambient Obscurance AO computation";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
	Feature( F_OUTPUT_RED_CHANNEL_ONLY, 0..1, "Outpu Red Channel Only" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 vPositionPs : POSITION0  < Semantic( PosXyz ); >;                                      
};

VS
{
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float2 vPositionPs;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _22489 = float4(vPositionPs, 0.0f, 1.0f);
	    _22489.y = -vPositionPs.y;
	    gl_Position = _22489;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_OUTPUT_RED_CHANNEL_ONLY, F_OUTPUT_RED_CHANNEL_ONLY );
	DynamicCombo( D_READ_NORMAL_FROM_TEXTURE, 0..1 );
	DynamicCombo( D_2X2_BOX_FILTER, 0..1 );
	
	float g_flAngleBias < UiType(Slider); Expression(exists(anglebias) ? anglebias : 0); >;
	float g_flBias < UiType(Slider); Expression(bias); >;
	float g_flStrength < UiType(Slider); Expression(strength); >;
	Texture2D g_tCameraDepth < Attribute("CameraDepth"); SrgbRead(false); >;
	Texture2D g_tGBufferNormalWs < Attribute("GBufferNormal"); SrgbRead(false); >;
	float2 g_vCameraDepthDimensions < Attribute("CameraDepthDimensions"); UiType(VectorText); >;
	float4 g_vProjInfo < UiType(VectorText); Expression(float4(-2/(ScreenWidth*p_00),-2/(ScreenHeight*p_11),(1-p_02)/p_00,(1+p_12)/p_11)); >;
	float4 g_vRadiusConsts < UiType(VectorText); Expression(float4(radius,radius*radius,strength/pow(radius,6),projScale*radius)); >;
	float4 g_vRadiusConsts2 < UiType(VectorText); Expression(1/pow(radius,2.4)); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vProjInfo) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_samplerless_texture_functions : require
	
	struct _1354
	{
	    vec2 g_vCameraDepthDimensions;
	    vec4 g_vProjInfo;
	    vec4 g_vRadiusConsts;
	    vec4 g_vRadiusConsts2;
	    float g_flBias;
	    float g_flStrength;
	    float g_flAngleBias;
	};
	
	layout(set = 1) uniform _1354 _Globals_;
	
	layout(set = 1, binding = 30) uniform texture2D g_tCameraDepth;
	
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    ivec2 _17556 = ivec2(gl_FragCoord.xy);
	    vec4 _19431 = texelFetch(g_tCameraDepth, ivec3(_17556.xy, 0).xy, 0);
	    float _15275 = _19431.x;
	    vec3 _13849 = vec3(((gl_FragCoord.xy * _Globals_.g_vProjInfo.xy) + _Globals_.g_vProjInfo.zw) * _15275, _15275);
	    int _6684 = _17556.x;
	    int _6863 = _17556.y;
	    float _3139 = (float((3 * _6684) ^ (_6863 + (_6684 * _6863))) * 8.0) + _Globals_.g_flAngleBias;
	    vec3 _24768 = dFdx(_13849);
	    vec3 _13627 = dFdy(_13849);
	    vec3 _19561 = normalize(cross(_24768, _13627));
	    float _7457 = abs(_Globals_.g_vRadiusConsts.w / _15275);
	    float _13155;
	    _13155 = 0.0;
	    float _3969;
	    int _4288;
	    int _16208 = 0;
	    for (;;)
	    {
	        if (!(_16208 < 11))
	        {
	            break;
	        }
	        float _16001 = float(_16208) + 0.5;
	        float _13463 = (_16001 * 3.996364116668701171875) + _3139;
	        float _12029 = _13463 - 6.283185482025146484375 * trunc(_13463 / 6.283185482025146484375);
	        float _21555 = (_16001 * 0.0909090936183929443359375) * _7457;
	        int _16477 = clamp(int(floor(log2(_21555))) - 3, 0, 5);
	        ivec2 _20377 = ivec2(vec2(cos(_12029), sin(_12029)) * _21555) + _17556;
	        ivec2 _21274 = ivec2(_16477);
	        vec4 _20039 = texelFetch(g_tCameraDepth, ivec3(clamp(_20377 >> _21274, ivec2(0), (ivec2(_Globals_.g_vCameraDepthDimensions.xy) >> _21274) - ivec2(1)).xy, _16477).xy, _16477);
	        float _10955 = _20039.x;
	        vec3 _10233 = vec3((((vec2(_20377) + vec2(0.5)).xy * _Globals_.g_vProjInfo.xy) + _Globals_.g_vProjInfo.zw) * _10955, _10955) - _13849;
	        _3969 = _13155 + ((4.0 * max(1.0 - (dot(_10233, _10233) * _Globals_.g_vRadiusConsts2.x), 0.0)) * max(dot(_10233, _19561) - _Globals_.g_flBias, 0.0));
	        _4288 = _16208 + 1;
	        _13155 = _3969;
	        _16208 = _4288;
	        continue;
	    }
	    output_0 = vec4(pow(saturate(1.0 - ((_Globals_.g_flStrength * _13155) / (11.0 * _Globals_.g_vRadiusConsts.x))), 1.39999997615814208984375), saturate(abs(_15275) * 0.00019999999494757503271102905273438), 0.0, 1.0);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
