//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Post processing";
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
	Feature( F_VIGNETTE, 0..1, "Vignette" );
	Feature( F_FILM_GRAIN, 0..1, "Film Grain" );
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
	DynamicCombo( D_FXAA, 0..1 );
	
	
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
	StaticCombo( S_VIGNETTE, F_VIGNETTE );
	StaticCombo( S_FILM_GRAIN, F_FILM_GRAIN );
	DynamicCombo( D_VIGNETTE, 0..1 );
	DynamicCombo( D_FILM_GRAIN, 0..1 );
	DynamicCombo( D_FXAA, 0..1 );
	DynamicCombo( D_COLOR_CORRECTION, 0..1 );
	DynamicCombo( D_COLOR_CORRECTION_LUT, 0..1 );
	DynamicCombo( D_BLOOM, 0..1 );
	DynamicComboRule( Requires( D_VIGNETTE, S_VIGNETTE ) );
	DynamicComboRule( Requires( D_FILM_GRAIN, S_FILM_GRAIN ) );
	
	float g_flColorCorrectionDefaultWeight < Attribute("ColorCorrectionDefaultWeight"); UiType(Slider); >;
	float g_flFadeMode < Attribute("ScreenFadeMode"); UiType(Slider); >;
	Texture2D g_tBloom < Attribute("BlurBuffer"); SrgbRead(true); >;
	Texture2D g_tColorBuffer < Attribute("ColorBuffer"); SrgbRead(true); >;
	Texture3D g_tColorCorrection < Attribute("ColorCorrectionTex"); SrgbRead(false); >;
	Texture2D g_tNoise < Channel(RGB, None(TextureNoise), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	float4 g_vBloomUvScaleClamp < UiType(VectorText); Expression(bloomBufferScaleClamp); >;
	float4 g_vInvTextureDim < Source(InvTextureDim); SourceArg(g_tColorBuffer) UiType(VectorText); >;
	float4 g_vViewFadeColor < Attribute("ScreenFadeColor"); UiType(VectorText); >;
	
	// Film Grain
	CreateInputTexture2D(TextureNoise, Linear, 8, "", "_noise", "Film Grain", Default4(0.5, 0.5, 0.5, 0));
	float g_flFilmGrainIntensity < Default(0.5); Range(0, 2); UiType(Slider); UiGroup("Film Grain"); >;
	float g_flFilmGrainRange < Default(0.2); Range(0, 0.5); UiType(Slider); UiGroup("Film Grain"); >;
	
	// HSV
	float g_flBrightness < Default(1); Range(0, 2); UiType(Slider); UiGroup("HSV"); >;
	float g_flContrast < Default(1); UiType(Slider); UiGroup("HSV"); >;
	float g_flHueShift < Range(-1, 1); UiType(Slider); UiGroup("HSV"); >;
	float g_flSaturate < Default(1); Range(0, 2); UiType(Slider); UiGroup("HSV"); >;
	
	// Color Exponents
	float g_flColorExpBlue < Default(1); Range(0.5, 2); UiType(Slider); UiGroup("Color Exponents"); >;
	float g_flColorExpGreen < Default(1); Range(0.5, 2); UiType(Slider); UiGroup("Color Exponents"); >;
	float g_flColorExpRed < Default(1); Range(0.5, 2); UiType(Slider); UiGroup("Color Exponents"); >;
	
	// Color Tint
	float g_flColorScale < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color Tint"); >;
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color Tint"); >;
	
	// Vignette
	float g_flVignetteExponent < Default(12); Range(1, 32); UiType(Slider); UiGroup("Vignette"); >;
	float g_flVignetteStrength < Default(0.75); UiType(Slider); UiGroup("Vignette"); >;
	float g_flVignetteVerticalFade < Default(1); UiType(Slider); UiGroup("Vignette"); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vViewFadeColor) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	struct _1032
	{
	    vec4 g_vViewFadeColor;
	    float g_flFadeMode;
	};
	
	layout(set = 1) uniform _1032 _Globals_;
	
	layout(set = 1, binding = 30) uniform texture2D g_tColorBuffer;
	layout(set = 1, binding = 14) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagLinearMipPoint;
	
	layout(location = 0) in vec2 input_0;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _3300 = textureLod(sampler2D(g_tColorBuffer, AddressU_Clamp_AddressV_Clamp_Filter_MinMagLinearMipPoint), input_0.xy, 0.0);
	    vec3 _13989 = _3300.xyz;
	    output_0 = vec4(mix(_13989, mix(_Globals_.g_vViewFadeColor.xyz, _Globals_.g_vViewFadeColor.xyz * _13989, vec3(_Globals_.g_flFadeMode)).xyz, vec3(_Globals_.g_vViewFadeColor.w)), _3300.w);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
