//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "MBOIT final combine with scene";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	CsgoForward();
	ToolsVis();
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
	float4 vTexCoord   : TEXCOORD0  < Semantic( texcoord ); >;                                    
};

VS
{
	DynamicCombo( D_UPSCALE_MIXED, 0..1 );
	
	float4 g_vlowResTexelSize < Attribute("LowResTexelSize"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c4);
	    float3 PerViewConstantBuffer_t_1_m1 : packoffset(c26);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float2 vTexCoord;
	static float2 output_0;
	static float4 output_1;
	static float3 output_2;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14817 = float4(vPositionPs, 0.0f, 1.0f);
	    float4 _14015 = mul(PerViewConstantBuffer_t_1_m0, float4((vTexCoord.x * 2.0f) - 1.0f, ((1.0f - vTexCoord.y) * 2.0f) - 1.0f, 1.0f, 1.0f));
	    output_0 = vTexCoord;
	    output_1 = 1.0f.xxxx;
	    output_2 = normalize((_14015.xyz / _14015.w.xxx) - PerViewConstantBuffer_t_1_m1.xyz);
	    _14817.y = -vPositionPs.y;
	    gl_Position = _14817;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vTexCoord = stage_input.vTexCoord;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_UPSCALE_MIXED, 0..1 );
	DynamicCombo( D_COMBINE_HI_RES, 0..1 );
	DynamicCombo( D_DENOISE_SMOKE, 0..1 );
	DynamicCombo( D_COVER_GAPS, 0..2 );
	DynamicCombo( D_SMOKE_PERF_TEST, 0..1 );
	DynamicComboRule( Allow1( D_DENOISE_SMOKE, D_COMBINE_HI_RES, D_COVER_GAPS ) );
	
	RenderState(StencilRef, 128);
	bool g_bDiscardSmokeBehind < Attribute("bDiscardSmokeBehind"); UiType(CheckBox); >;
	bool g_bIgnoreSmokeDepth < Attribute("bIgnoreSmokeDepth"); UiType(CheckBox); >;
	Texture2D g_tFullresMask < Attribute("fullresMask"); SrgbRead(false); >;
	Texture2D g_tHiResDepth < Attribute("hiresDepth"); SrgbRead(false); >;
	Texture2D g_tLoResDepth < Attribute("loresDepth"); SrgbRead(false); >;
	Texture2D g_tMboitOptimDepthTexture < Attribute("SmokeOptimDepthTex"); SrgbRead(false); >;
	Texture2D g_tMoitFinal < Attribute("MoitFinalTex"); SrgbRead(true); >;
	Texture2D g_tMoitFinalHiRes < Attribute("MoitFinalHiResTex"); SrgbRead(true); >;
	Texture2D g_tSmokeDepthHalf < Attribute("SmokeOptimDepthHalfTex"); SrgbRead(false); >;
	Texture2D g_tSmokeDepthQuarter < Attribute("SmokeOptimDepthQuarterTex"); SrgbRead(false); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	float4 g_vlowResTexelSize < Attribute("LowResTexelSize"); UiType(VectorText); >;
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float4 PerViewConstantBuffer_t_1_m0 : packoffset(c22);
	};
	
	Texture2D<float4> g_tMoitFinal : register(t30, space1);
	SamplerState g_sPointClamp : register(s19, space1);
	Texture2D<float4> g_tZeroth_Moment : register(t31, space1);
	
	static float4 gl_FragCoord;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float2 _13326 = (gl_FragCoord.xy * PerViewConstantBuffer_t_1_m0.xy).xy;
	    float4 _14259 = g_tMoitFinal.SampleLevel(g_sPointClamp, _13326, 0.0f);
	    float _21603 = _14259.w + 9.9999997473787516355514526367188e-06f;
	    float _15899 = 1.0f - exp(-g_tZeroth_Moment.SampleLevel(g_sPointClamp, _13326, 0.0f).x);
	    output_0 = float4(float4(_14259.xyz * (_15899 / _21603), _21603).xyz, (_15899 >= 0.99989998340606689453125f) ? 1.0f : _15899);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
