//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Generic compositing shader that outputs an image-space HemiOct-encoded tangent normal from a black-and-white heightmap.";
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
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
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
	
	float g_flNormalScale < Default(1); Range(0, 32); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nHeightChannel < Range(0, 3); UiType(Slider); >;
	Texture2D g_tHeight < Channel(RGB, None(TextureHeight), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGB, None(TextureNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// Options
	CreateInputTexture2D(TextureHeight, Linear, 8, "", "", "Options", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureNormal, Linear, 8, "", "", "Options", Default4(0.5, 0.5, 1, 0));
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flNormalScale : packoffset(c0);
	    int _Globals_1_g_nHeightChannel : packoffset(c0.y);
	};
	
	Texture2D<float4> g_tNormal : register(t30, space1);
	SamplerState DefaultSamplerState_0 : register(s14, space1);
	Texture2D<float4> g_tHeight : register(t31, space1);
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
	    float4 _19372 = g_tNormal.Sample(DefaultSamplerState_0, input_0.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _17934 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    float4 _20540 = g_tHeight.Sample(DefaultSamplerState_0_1, input_0.xy);
	    float _19496 = ddx(_20540[_Globals_1_g_nHeightChannel]);
	    float _24200 = ddy(_20540[_Globals_1_g_nHeightChannel]);
	    float _18996 = sqrt((1.0f - (_19496 * _19496)) - (_24200 * _24200));
	    float3 _10356 = normalize(float3(_17934.xy + float3(float3(-_19496, _24200, 0.0f).xy * _Globals_1_g_flNormalScale, _18996).xy, _17934.z * _18996));
	    float2 _9840 = _10356.xy * (1.0f / ((abs(_10356.x) + abs(_10356.y)) + _10356.z));
	    float _9145 = _9840.x;
	    float _9493 = _9840.y;
	    float2 _21825 = (float2(_9145 + _9493, _9145 - _9493) * 0.5f) + 0.5f.xx;
	    float3 _18364 = float3(_21825, 0.0f);
	    float _16086 = _19372.z;
	    _18364.z = _16086;
	    float3 _12210 = _18364.xyz * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((_18364.xyz * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (_21825.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _12210.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _23035;
	    if (_21825.y <= 0.040449999272823333740234375f)
	    {
	        _23035 = _12210.y;
	    }
	    else
	    {
	        _23035 = _7676.y;
	    }
	    float _19494;
	    if (_16086 <= 0.040449999272823333740234375f)
	    {
	        _19494 = _12210.z;
	    }
	    else
	    {
	        _19494 = _7676.z;
	    }
	    output_0 = float4(float3(_21354, _23035, _19494), _19372.w);
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
