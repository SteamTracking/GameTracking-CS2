//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader to downsample with bloom threshold.";
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
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vPositionPs : POSITION0  < Semantic( position ); >;                                    
};

VS
{
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float3 vPositionPs;
	
	struct VS_INPUT
	{
	    float3 vPositionPs : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _15970 = float4(vPositionPs.xy, 0.0f, 1.0f);
	    _15970.y = -vPositionPs.y;
	    gl_Position = _15970;
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
	DynamicCombo( D_COLORBUFFER_TONEMAPSPACE, 0..2 );
	DynamicCombo( D_THRESHOLD_ALL_SAMPLES, 0..1 );
	DynamicCombo( D_DOWNSAMPLE_JIMENEZ, 0..1 );
	DynamicCombo( D_LOCAL_CONTRAST, 0..1 );
	DynamicCombo( D_OUTPUT_PANO, 0..1 );
	DynamicCombo( D_COLOR_CORRECTION_LUT, 0..1 );
	DynamicComboRule( Requires( D_COLOR_CORRECTION_LUT, D_OUTPUT_PANO ) );
	
	float g_flBloomScale < Attribute("bloomScale"); UiType(Slider); >;
	float g_flColorCorrectionDefaultWeight < Attribute("ColorCorrectionDefaultWeight"); UiType(Slider); >;
	Texture3D g_tColorCorrection < Attribute("ColorCorrectionTex"); SrgbRead(false); >;
	Texture2D g_tInput < Attribute("InputTexture"); SrgbRead(false); >;
	Texture2D g_tQuarterResEffectsColor < Attribute("QuarterResEffectsBloomInputTexture"); SrgbRead(false); >;
	float4 g_vInvTexDim < Source(InvTextureDim); SourceArg(g_tInput) UiType(VectorText); >;
	float3 g_vThresholdParams < UiType(VectorText); Expression(float3(-bloomThreshold/bloomThresholdWidth,1/bloomThresholdWidth,skyboxBloomStrength)); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 2 (name: g_vInvTexDim) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_samplerless_texture_functions : require
	
	vec4 _3;
	
	struct _1117
	{
	    float g_flBloomScale;
	    vec3 g_vThresholdParams;
	    vec4 g_vInvTexDim;
	};
	
	layout(set = 1) uniform _1117 _Globals_;
	
	struct _985
	{
	    float _m0;
	};
	
	layout(set = 1) uniform _985 PerViewConstantBuffer_t;
	
	layout(set = 1, binding = 30) uniform texture2D g_tInput;
	layout(set = 1, binding = 14) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagLinearMipPoint;
	layout(set = 1, binding = 31) uniform texture2D g_tQuarterResEffectsColor;
	
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec2 _22165 = (gl_FragCoord.xy * (_Globals_.g_vInvTexDim.xy * 4.0)).xy;
	    vec4 _20428 = (((textureLodOffset(sampler2D(g_tInput, AddressU_Clamp_AddressV_Clamp_Filter_MinMagLinearMipPoint), _22165, 0.0, ivec2(-1)) + textureLodOffset(sampler2D(g_tInput, AddressU_Clamp_AddressV_Clamp_Filter_MinMagLinearMipPoint), _22165, 0.0, ivec2(-1, 1))) + textureLodOffset(sampler2D(g_tInput, AddressU_Clamp_AddressV_Clamp_Filter_MinMagLinearMipPoint), _22165, 0.0, ivec2(1))) + textureLodOffset(sampler2D(g_tInput, AddressU_Clamp_AddressV_Clamp_Filter_MinMagLinearMipPoint), _22165, 0.0, ivec2(1, -1))) * 0.25;
	    vec3 _15742 = ((_20428 * saturate(((PerViewConstantBuffer_t._m0 * dot(_20428.xyz, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375))) * _Globals_.g_vThresholdParams.y) + _Globals_.g_vThresholdParams.x)) * _Globals_.g_flBloomScale).xyz + texelFetch(g_tQuarterResEffectsColor, ivec3(ivec2(gl_FragCoord.xy), 0).xy, 0).xyz;
	    vec4 _20488;
	    _20488.x = _15742.x;
	    _20488.y = _15742.y;
	    _20488.z = _15742.z;
	    output_0 = vec4(_20488.xyz, 1.0);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
