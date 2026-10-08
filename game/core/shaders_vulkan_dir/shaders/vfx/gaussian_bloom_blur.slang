//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Bloom Blur";
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
	DynamicCombo( D_FIRST_MIP, 0..1 );
	DynamicCombo( D_4X_DOWNSAMPLE, 0..1 );
	DynamicCombo( D_VIGNETTE, 0..2 );
	DynamicCombo( D_BLUR_PASS, 0..4 );
	DynamicCombo( D_FRAMEBUFFER_IS_LINEAR, 0..1 );
	DynamicCombo( D_MSAA_COLOR_BUFFER, 0..1 );
	DynamicCombo( D_TENT_FILTER, 0..1 );
	DynamicCombo( D_TONEMAP_BLEND, 0..1 );
	DynamicComboRule( Requires( D_VIGNETTE, D_FIRST_MIP ) );
	DynamicComboRule( Requires( D_4X_DOWNSAMPLE, D_BLUR_PASS==0 ) );
	DynamicComboRule( Requires( D_TONEMAP_BLEND, D_4X_DOWNSAMPLE ) );
	DynamicComboRule( Requires( D_TENT_FILTER, D_BLUR_PASS==3 ) );
	
	float g_flBloomScale < Attribute("bloomScale"); UiType(Slider); >;
	float g_flTentFilterRadius < Attribute("bloomTentFilterRadius"); UiType(Slider); >;
	Texture2D g_tQuarterResEffectsColor < Attribute("QuarterResEffectsBloomInputTexture"); SrgbRead(false); >;
	Texture2D g_tSource < Attribute("SourceTexture"); SrgbRead(false); >;
	Texture2D g_tSource < Attribute("SourceTexture"); SrgbRead(true); >;
	Texture2D g_tSource2 < Attribute("SourceTexture2"); SrgbRead(false); >;
	Texture2D g_tSource2 < Attribute("SourceTexture2"); SrgbRead(true); >;
	Texture2D g_tSourceMsaa < Attribute("SourceTextureMSAA"); SrgbRead(false); >;
	float4 g_vCombineUVScaleAndClamp < UiType(VectorText); Expression(uvscaleclamp); >;
	float4 g_vCombineUVScaleAndClamp2 < UiType(VectorText); Expression(UVScaleClamp2); >;
	float3 g_vCurrMipBlurTint < UiType(VectorText); Expression(currmipblurtint); >;
	float3 g_vPrevMipBlurTint < UiType(VectorText); Expression(prevmipblurtint); >;
	float4 g_vTexelSize < UiType(VectorText); Expression(TexelSize); >;
	float3 g_vThresholdParams < UiType(VectorText); Expression(float3(-bloomThreshold/bloomThresholdWidth,1/bloomThresholdWidth,skyboxBloomStrength)); >;
	
	
	// Variant parameters
	Texture2D g_tSource < Attribute("SourceTexture"); SrgbRead(false); >;
	Texture2D g_tSource < Attribute("SourceTexture"); SrgbRead(true); >;
	Texture2D g_tSource2 < Attribute("SourceTexture2"); SrgbRead(false); >;
	Texture2D g_tSource2 < Attribute("SourceTexture2"); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_g_vTexelSize : packoffset(c0);
	};
	
	Texture2D<float4> g_tSource : register(t30, space1);
	SamplerState AddressU_Border_AddressV_Border_BorderColor_0_Filter_MinMagMipLinear : register(s14, space1);
	
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
	    output_0 = float4(clamp(clamp(g_tSource.SampleLevel(AddressU_Border_AddressV_Border_BorderColor_0_Filter_MinMagMipLinear, ((gl_FragCoord.xy * 2.0f) * _Globals_1_g_vTexelSize.xy).xy, 0.0f).xyzw, 0.0f.xxxx, 65504.0f.xxxx), 0.0f.xxxx, 65504.0f.xxxx).xyz, 1.0f);
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
