//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Downsample/resolve depth buffer";
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
	float3 vPositionSs : POSITION0  < Semantic( PosXyz ); >;                                      
};

VS
{
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float3 vPositionSs;
	
	struct VS_INPUT
	{
	    float3 vPositionSs : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _22489 = float4(vPositionSs, 1.0f);
	    _22489.y = -vPositionSs.y;
	    gl_Position = _22489;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_MINMAX_CHECKER_2X2, 0..1 );
	DynamicCombo( D_RESOLVE, 0..1 );
	DynamicCombo( D_MAX, 0..1 );
	DynamicCombo( D_MIN, 0..1 );
	DynamicCombo( D_NON_MSAA_DEPTH, 0..1 );
	DynamicCombo( D_MSAA_SAMPLES, 0..4 );
	DynamicCombo( D_WRITE_COLOR, 0..1 );
	DynamicComboRule( Allow1( D_MINMAX_CHECKER_2X2, D_MAX, D_MIN ) );
	DynamicComboRule( Requires( D_NON_MSAA_DEPTH, D_MSAA_SAMPLES==0 ) );
	
	int g_nDownsampleRatioH < UiType(Slider); Expression(exists(g_nDownsampleRatio) ? g_nDownsampleRatio : g_nDownsampleRatioY); >;
	int g_nDownsampleRatioW < UiType(Slider); Expression(exists(g_nDownsampleRatio) ? g_nDownsampleRatio : g_nDownsampleRatioX); >;
	Texture2D g_tDepth < Attribute("DepthBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    int _Globals_1_g_nDownsampleRatioW : packoffset(c0);
	    int _Globals_1_g_nDownsampleRatioH : packoffset(c0.y);
	};
	
	Texture2DMS<float4> g_tDepth : register(t30, space1);
	
	static float4 gl_FragCoord;
	static float gl_FragDepth;
	struct PS_INPUT
	{
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float gl_FragDepth : SV_Depth;
	};
	
	void MainPs_inner()
	{
	    gl_FragDepth = g_tDepth.Load((int2(gl_FragCoord.xy).xy * int2(_Globals_1_g_nDownsampleRatioW, _Globals_1_g_nDownsampleRatioH)).xy, 0).x;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.gl_FragDepth = gl_FragDepth;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
