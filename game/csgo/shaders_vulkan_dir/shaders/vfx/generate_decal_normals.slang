//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Generate Character Decals";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_60
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
	float3 vPositionPs : POSITION0  < Semantic( PosXyz ); >;                                      
	float2 vTexCoord   : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                              
};

VS
{
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float2 vTexCoord;
	static float2 output_0;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14456 = float4(vPositionPs, 0.0f, 1.0f);
	    output_0 = vTexCoord;
	    _14456.y = -vPositionPs.y;
	    gl_Position = _14456;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vTexCoord = stage_input.vTexCoord;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tHeightfield < Attribute("g_tHeightfield"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float3 _1;
	
	Texture2D<float4> g_tHeightfield : register(t30, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp : register(s14, space1);
	
	static float2 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_0 : TEXCOORD0;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _22452 = g_tHeightfield.Sample(AddressU_Clamp_AddressV_Clamp, input_0.xy);
	    float _16990 = _22452.w;
	    float3 _24407;
	    _24407.x = ((g_tHeightfield.SampleLevel(AddressU_Clamp_AddressV_Clamp, input_0.xy, 0.0f, int2(-1, 0)).w - _16990) * (-5.0f)) + (5.0f * (g_tHeightfield.SampleLevel(AddressU_Clamp_AddressV_Clamp, input_0.xy, 0.0f, int2(0, -1)).w - _16990));
	    _24407.y = ((g_tHeightfield.SampleLevel(AddressU_Clamp_AddressV_Clamp, input_0.xy, 0.0f, int2(1, 0)).w - _16990) * (-5.0f)) + (5.0f * (g_tHeightfield.SampleLevel(AddressU_Clamp_AddressV_Clamp, input_0.xy, 0.0f, int2(0, 1)).w - _16990));
	    output_0 = float4((_24407.xy * 0.5f) + 0.5f.xx, _22452.z, _16990);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
