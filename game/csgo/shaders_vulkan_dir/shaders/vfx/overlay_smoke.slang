//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Used to draw CSGO smoke overlay";
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
	float4 vColor      : COLOR0     < Semantic( color ); >;                                       
	float4 vPositionPs : POSITION0  < Semantic( position ); >;                                    
	float4 vTexCoord   : TEXCOORD0  < Semantic( texcoord ); >;                                    
};

VS
{
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float2 vTexCoord;
	static float4 vColor;
	static float2 output_0;
	static float4 output_1;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	    float4 vColor : COLOR0;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14437 = float4(vPositionPs, 0.0f, 1.0f);
	    output_0 = vTexCoord;
	    output_1 = vColor;
	    _14437.y = -vPositionPs.y;
	    gl_Position = _14437;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vTexCoord = stage_input.vTexCoord;
	    vColor = stage_input.vColor;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_ACCUM_PASS, 0..1 );
	DynamicCombo( D_VIEWMODEL_PASS, 0..1 );
	
	float g_DeltaTime < Attribute("DeltaTime"); UiType(Slider); >;
	bool g_bHEGrenExplosion < Attribute("bHEGrenExplosion"); UiType(CheckBox); >;
	Texture2D g_tSmokeAccum < Attribute("SmokeAccum"); SrgbRead(true); >;
	Texture2D g_tSmokeColor < Attribute("SmokeColor"); SrgbRead(true); >;
	Texture2D g_tSmokeDepth < Attribute("SmokeDepth"); SrgbRead(true); >;
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20.z);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c21.z);
	};
	
	Texture2D<float4> g_tSmokeAccum : register(t30, space1);
	SamplerState g_sBilinearClamp : register(s16, space1);
	
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
	    float _4384 = PerViewConstantBuffer_t_1_m1.x / PerViewConstantBuffer_t_1_m0.x;
	    float _14222 = 0.0500000007450580596923828125f / _4384;
	    float _21970 = 0.949999988079071044921875f / _4384;
	    float4 _11368 = input_0.y.xxxx;
	    float4 _6452 = lerp(lerp(g_tSmokeAccum.Sample(g_sBilinearClamp, _14222.xx), g_tSmokeAccum.Sample(g_sBilinearClamp, float2(_14222, _21970)), _11368), lerp(g_tSmokeAccum.Sample(g_sBilinearClamp, float2(_21970, _14222)), g_tSmokeAccum.Sample(g_sBilinearClamp, _21970.xx), _11368), input_0.x.xxxx);
	    output_0 = float4(_6452.xyz, smoothstep(0.0f, 0.949999988079071044921875f, _6452.w));
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
