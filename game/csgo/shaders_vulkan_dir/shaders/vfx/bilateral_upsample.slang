//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Bilateral upsamples textures";
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
	
	float4 g_vlowResTexelSize < Attribute("LowResTexelSize"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vlowResTexelSize : packoffset(c0);
	};
	
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
	static float2 output_2;
	static float2 output_3;
	static float2 output_4;
	static float2 output_5;
	static float3 output_6;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float2 output_2 : TEXCOORD2;
	    float2 output_3 : TEXCOORD3;
	    float2 output_4 : TEXCOORD4;
	    float2 output_5 : TEXCOORD5;
	    float3 output_6 : TEXCOORD6;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14513 = float4(vPositionPs, 0.0f, 1.0f);
	    float2 _7669 = vTexCoord - (_Globals_1_g_vlowResTexelSize.xy * 0.5f);
	    float4 _14015 = mul(PerViewConstantBuffer_t_1_m0, float4((vTexCoord.x * 2.0f) - 1.0f, ((1.0f - vTexCoord.y) * 2.0f) - 1.0f, 1.0f, 1.0f));
	    output_0 = vTexCoord;
	    output_1 = 1.0f.xxxx;
	    output_2 = _7669;
	    output_3 = _7669 + float2(_Globals_1_g_vlowResTexelSize.x, 0.0f);
	    output_4 = _7669 + float2(0.0f, _Globals_1_g_vlowResTexelSize.y);
	    output_5 = _7669 + _Globals_1_g_vlowResTexelSize.xy;
	    output_6 = normalize((_14015.xyz / _14015.w.xxx) - PerViewConstantBuffer_t_1_m1.xyz);
	    _14513.y = -vPositionPs.y;
	    gl_Position = _14513;
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
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    stage_output.output_5 = output_5;
	    stage_output.output_6 = output_6;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_MIXED_RESOLUTION_COLOR_SLICES, 0..1 );
	
	int g_nMixedResolutionIndex < Attribute("MixedResolutionIndex"); UiType(Slider); >;
	Texture2D g_tInputDepthHiRes < Attribute("InputDepthHiRes"); SrgbRead(false); >;
	Texture2D g_tInputTexture < Attribute("InputTexture"); SrgbRead(true); >;
	float4 g_vlowResTexelSize < Attribute("LowResTexelSize"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_g_vlowResTexelSize : packoffset(c0);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c23);
	    float PerViewConstantBuffer_t_1_m1 : packoffset(c23.y);
	};
	
	SamplerState g_sPointClamp : register(s19, space1);
	Texture2D<float4> g_tInputDepthHiRes : register(t32, space1);
	Texture2D<float4> g_tInputTexture : register(t30, space1);
	
	static float4 gl_FragCoord;
	static float2 input_0;
	static float2 input_2;
	static float2 input_3;
	static float2 input_4;
	static float2 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_0 : TEXCOORD0;
	    float2 input_2 : TEXCOORD2;
	    float2 input_3 : TEXCOORD3;
	    float2 input_4 : TEXCOORD4;
	    float2 input_5 : TEXCOORD5;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float _20238 = saturate((g_tInputDepthHiRes.Load(int3(int3(int2(gl_FragCoord.xy), 0).xy, 0)).x - PerViewConstantBuffer_t_1_m0) / (PerViewConstantBuffer_t_1_m1 - PerViewConstantBuffer_t_1_m0));
	    float2 _19565 = frac((input_0 * _Globals_1_g_vlowResTexelSize.zw) + 0.5f.xx);
	    float _24300 = lerp(0.000899999984540045261383056640625f, 5.9999998484272509813308715820312e-05f, saturate((_20238 - 0.89999997615814208984375f) * 9.9999980926513671875f));
	    float _23980 = exp((-(_20238 * _20238)) / ((2.0f * _24300) * _24300));
	    float _6969 = _19565.x;
	    float _9518 = _23980 * (1.0f - _6969);
	    float _14922 = _19565.y;
	    float _14721 = 1.0f - _14922;
	    float _19631 = _9518 * _14721;
	    float _20716 = _9518 * _14922;
	    float _22329 = _23980 * _6969;
	    float _24495 = _22329 * _14721;
	    float _23920 = _22329 * _14922;
	    float4 _6805;
	    do
	    {
	        float _14529 = ((_20716 + _23920) + _24495) + _19631;
	        if (_14529 < 9.9999997473787516355514526367188e-06f)
	        {
	            _6805 = g_tInputTexture.SampleLevel(g_sPointClamp, input_0, 0.0f);
	            break;
	        }
	        _6805 = ((((g_tInputTexture.SampleLevel(g_sPointClamp, input_4, 0.0f) * _20716) + (g_tInputTexture.SampleLevel(g_sPointClamp, input_5, 0.0f) * _23920)) + (g_tInputTexture.SampleLevel(g_sPointClamp, input_3, 0.0f) * _24495)) + (g_tInputTexture.SampleLevel(g_sPointClamp, input_2, 0.0f) * _19631)) / _14529.xxxx;
	        break;
	    } while(false);
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
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
	
	
}
