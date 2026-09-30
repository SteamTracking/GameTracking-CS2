//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Generic compositing shader that draws a single texture input in screenspace.";
	DevShader = true;
	Version = 1;
	
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
	float2 vTexCoord   : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                              
};

VS
{
	
	float4 g_vViewport < Source(Viewport); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float _2;
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vViewport : packoffset(c0);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionSs;
	static float2 vTexCoord;
	static float2 output_0;
	
	struct VS_INPUT
	{
	    float2 vPositionSs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float2 _15639 = (((vPositionSs.xy - _Globals_1_g_vViewport.xy) * 2.0f) / _Globals_1_g_vViewport.zw) - 1.0f.xx;
	    float4 _14456 = float4(_15639.x, _2, 1.0f, 1.0f);
	    output_0 = vTexCoord;
	    _14456.y = _15639.y;
	    gl_Position = _14456;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    vTexCoord = stage_input.vTexCoord;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(ui, true);
	BoolAttribute(ScreenSpaceVertices, true);
	
}

PS
{
	
	float g_flAlphaBlend < UiType(Slider); >;
	Texture2D g_tTextureA < Channel(RGBA, None(TextureA), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tTextureB < Channel(RGBA, None(TextureB), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Options
	CreateInputTexture2D(TextureA, Linear, 8, "", "", "Options", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureB, Linear, 8, "", "", "Options", Default4(0, 0, 0, 0));
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flAlphaBlend : packoffset(c0);
	};
	
	Texture2D<float4> g_tTextureA : register(t30, space1);
	SamplerState DefaultSamplerState_0 : register(s14, space1);
	Texture2D<float4> g_tTextureB : register(t31, space1);
	SamplerState DefaultSamplerState_0_1 : register(s15, space1);
	
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
	    float4 _21760 = g_tTextureA.Sample(DefaultSamplerState_0, input_0.xy);
	    float4 _6805;
	    if (_Globals_1_g_flAlphaBlend > 0.0f)
	    {
	        float4 _3300 = g_tTextureB.Sample(DefaultSamplerState_0_1, input_0.xy);
	        _6805 = lerp(_21760, _3300, (_3300.w * _Globals_1_g_flAlphaBlend).xxxx);
	    }
	    else
	    {
	        _6805 = _21760;
	    }
	    output_0 = _6805;
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
