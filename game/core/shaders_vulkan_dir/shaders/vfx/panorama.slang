//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Used for Panorama UI";
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
	float2 vTex        : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                              
	float2 vColor      : TEXCOORD1  < Semantic( LowPrecisionUv ); >;                              
};

VS
{
	DynamicCombo( D_DSTCOLOR_BLENDMODE, 0..8 );
	
	float2 g_vTexture4Scale < Default2(1, 1); Attribute("Texture4Scale"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float4 vPositionSs;
	static float4 vTex;
	static float4 vColor;
	static float4 output_0;
	static float4 output_1;
	
	struct VS_INPUT
	{
	    float4 vPositionSs : POSITION0;
	    float4 vTex : TEXCOORD0;
	    float4 vColor : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _19250 = vPositionSs;
	    float4 _18862 = _19250;
	    _18862.z = 0.0f;
	    output_0 = vTex;
	    output_1 = vColor;
	    _18862.y = -_19250.y;
	    gl_Position = _18862;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    vTex = stage_input.vTex;
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
	DynamicCombo( D_DSTCOLOR_BLENDMODE, 0..8 );
	DynamicCombo( D_TEXTURETYPE, 0..7 );
	DynamicCombo( D_FAST_BLUR_SAMPLES, 0..8 );
	DynamicCombo( D_RESOLVE_DESTINATION, 0..2 );
	DynamicCombo( D_MSAA_SAMPLES, 0..3 );
	DynamicComboRule( Requires( D_FAST_BLUR_SAMPLES, D_TEXTURETYPE==6 ) );
	DynamicComboRule( Requires( D_MSAA_SAMPLES, D_RESOLVE_DESTINATION==2 ) );
	DynamicComboRule( Allow1( D_RESOLVE_DESTINATION, D_TEXTURETYPE ) );
	DynamicComboRule( Allow1( D_RESOLVE_DESTINATION, D_DSTCOLOR_BLENDMODE ) );
	
	float g_flBlurSigma < Attribute("BlurSigma"); UiType(Slider); >;
	Texture2D g_tTexture0 < Attribute("Texture0"); SrgbRead(false); >;
	Texture2D g_tTexture0 < Attribute("Texture0"); SrgbRead(true); >;
	Texture2D g_tTexture1 < Attribute("Texture1"); SrgbRead(false); >;
	Texture2D g_tTexture2 < Attribute("Texture2"); SrgbRead(false); >;
	Texture2D g_tTexture3 < Attribute("Texture3"); SrgbRead(false); >;
	Texture2D g_tTexture4 < Attribute("Texture4"); SrgbRead(false); >;
	float2 g_vBlurMultiplyVec < Default2(0, 1); Attribute("BlurMultiplyVec"); UiType(VectorText); >;
	
	
	// Variant parameters
	Texture2D g_tTexture0 < Attribute("Texture0"); SrgbRead(false); >;
	Texture2D g_tTexture0 < Attribute("Texture0"); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 input_1;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_1 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = input_1;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
