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
	Feature( F_FILM_GRAIN, 0..1, "Film Grain" );
	Feature( F_BLOOM_LENS_DIRT, 0..1, "Bloom Lens Dirt" );
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
	StaticCombo( S_FILM_GRAIN, F_FILM_GRAIN );
	StaticCombo( S_BLOOM_LENS_DIRT, F_BLOOM_LENS_DIRT );
	DynamicCombo( D_VIGNETTE, 0..2 );
	DynamicCombo( D_LOCAL_CONTRAST, 0..1 );
	DynamicCombo( D_FILM_GRAIN, 0..1 );
	DynamicCombo( D_COLOR_CORRECTION_LUT, 0..1 );
	DynamicCombo( D_BLOOM, 0..1 );
	DynamicCombo( D_BLOOM_MODE, 0..1 );
	DynamicCombo( D_OUTPUT_LINEAR, 0..1 );
	DynamicCombo( D_COLORBUFFER_TONEMAPSPACE, 0..2 );
	DynamicComboRule( Requires( D_FILM_GRAIN, S_FILM_GRAIN ) );
	DynamicComboRule( Requires( D_BLOOM_MODE, D_BLOOM==1, S_BLOOM_LENS_DIRT==0, D_COLORBUFFER_TONEMAPSPACE==2 ) );
	
	float g_flBloomViewportScaleX < Attribute("BloomViewportScaleX"); UiType(Slider); >;
	float g_flBloomViewportScaleY < Attribute("BloomViewportScaleY"); UiType(Slider); >;
	float g_flColorCorrectionDefaultWeight < Attribute("ColorCorrectionDefaultWeight"); UiType(Slider); >;
	float g_flFadeMode < Attribute("ScreenFadeMode"); UiType(Slider); >;
	float g_flFullScreenGamma < Attribute("FullScreenGamma"); UiType(Slider); >;
	float g_flLocalContrastBlurredVignetteStrength < Attribute("localContrastBlurredVignetteStrength"); UiType(Slider); >;
	float g_flLocalContrastEdgeStrength < Attribute("localContrastEdgeStrength"); UiType(Slider); >;
	float g_flLocalContrastStrength < Attribute("localContrastStrength"); UiType(Slider); >;
	float g_flLocalContrastVignetteEnd < Attribute("localContrastVignetteEnd"); UiType(Slider); >;
	float g_flLocalContrastVignetteStart < Attribute("localContrastVignetteStart"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tBloom < Attribute("BlurBuffer"); SrgbRead(false); >;
	Texture2D g_tColorBuffer < Attribute("ColorBuffer"); SrgbRead(false); >;
	Texture3D g_tColorCorrection < Attribute("ColorCorrectionTex"); SrgbRead(false); >;
	Texture2D g_tDirt < Channel(RGB, None(TextureDirt), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNoise < Channel(RGB, None(TextureNoise), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tQuarterResUnthresholdedBlur < Attribute("QuarterResUnthresholdedBlurredTexture"); SrgbRead(false); >;
	float4 g_vBloomUvScaleClamp < UiType(VectorText); Expression(bloomBufferScaleClamp); >;
	float3 g_vNormalizedBloomStrengths < UiType(VectorText); Expression(float3(normalizedAdditiveBloomStrength,normalizedScreenBloomStrength,normalizedBlurBloomStrength)); >;
	float2 g_vNormalizedUvToColorBufferUv < UiType(VectorText); Expression(normalizedUvToColorBufferUv); >;
	float4 g_vQuarterResBlurredUnthresholdedScaleClamp < UiType(VectorText); Expression(quarterResUnthresholdedBlurredScaleClamp); >;
	float3 g_vUnNormalizedBloomStrengths < UiType(VectorText); Expression(float3(additiveBloomStrength,screenBloomStrength,blurBloomStrength)); >;
	float4 g_vViewFadeColor < Attribute("ScreenFadeColor"); UiType(VectorText); >;
	
	// Lens Dirt
	CreateInputTexture2D(TextureDirt, Linear, 8, "", "_dirt", "Lens Dirt", Default4(0, 0, 0, 0));
	float g_flBloomLensDirtIntensity < Default(0.5); Range(0, 5); UiType(Slider); UiGroup("Lens Dirt"); >;
	
	// Film Grain
	CreateInputTexture2D(TextureNoise, Linear, 8, "", "_noise", "Film Grain", Default4(0.5, 0.5, 0.5, 0));
	float g_flFilmGrainIntensity < Default(0.5); Range(0, 2); UiType(Slider); UiGroup("Film Grain"); >;
	float g_flFilmGrainRange < Default(0.2); Range(0, 0.5); UiType(Slider); UiGroup("Film Grain"); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vViewFadeColor) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	vec4 _3;
	
	struct _1018
	{
	    float _m0;
	    vec2 _m1;
	};
	
	layout(set = 1) uniform _1018 PerViewConstantBuffer_t;
	
	struct _1105
	{
	    vec2 g_vNormalizedUvToColorBufferUv;
	    vec4 g_vViewFadeColor;
	    float g_flFadeMode;
	    float g_flFullScreenGamma;
	};
	
	layout(set = 1) uniform _1105 _Globals_;
	
	struct _1245
	{
	    float _m0;
	    float _m1;
	    float _m2;
	    float _m3;
	    float _m4;
	    float _m5;
	    float _m6;
	    float _m7;
	    float _m8;
	};
	
	layout(set = 1) uniform _1245 PostProcessingConstantBuffer_t;
	
	layout(set = 1, binding = 50) uniform texture2D g_tColorBuffer;
	layout(set = 1, binding = 25) uniform sampler Filter_MinMagLinearMipPoint;
	
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _3300 = textureLod(sampler2D(g_tColorBuffer, Filter_MinMagLinearMipPoint), ((gl_FragCoord.xy * PerViewConstantBuffer_t._m1.xy).xy * _Globals_.g_vNormalizedUvToColorBufferUv.xy).xy, 0.0);
	    vec3 _9407 = _3300.xyz * (PerViewConstantBuffer_t._m0 * PostProcessingConstantBuffer_t._m0);
	    vec4 _8673;
	    _8673.x = _9407.x;
	    _8673.y = _9407.y;
	    _8673.z = _9407.z;
	    vec3 _18130 = min(_8673.xyz * 2.7999999523162841796875, vec3(PostProcessingConstantBuffer_t._m7));
	    vec3 _21494 = _18130 * PostProcessingConstantBuffer_t._m1;
	    vec3 _8585 = ((((_18130 * (_21494 + vec3(PostProcessingConstantBuffer_t._m3 * PostProcessingConstantBuffer_t._m2))) + vec3(PostProcessingConstantBuffer_t._m4 * PostProcessingConstantBuffer_t._m5)) / ((_18130 * (_21494 + vec3(PostProcessingConstantBuffer_t._m2))) + vec3(PostProcessingConstantBuffer_t._m4 * PostProcessingConstantBuffer_t._m6))) - vec3(PostProcessingConstantBuffer_t._m5 / PostProcessingConstantBuffer_t._m6)) * PostProcessingConstantBuffer_t._m8;
	    vec3 _11977 = _8585.xyz;
	    vec3 _8210 = _11977 * 12.9200000762939453125;
	    vec3 _7485 = (pow(_11977, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	    float _21354;
	    if (_8585.x <= 0.003130800090730190277099609375)
	    {
	        _21354 = _8210.x;
	    }
	    else
	    {
	        _21354 = _7485.x;
	    }
	    float _21355;
	    if (_8585.y <= 0.003130800090730190277099609375)
	    {
	        _21355 = _8210.y;
	    }
	    else
	    {
	        _21355 = _7485.y;
	    }
	    float _19167;
	    if (_8585.z <= 0.003130800090730190277099609375)
	    {
	        _19167 = _8210.z;
	    }
	    else
	    {
	        _19167 = _7485.z;
	    }
	    vec4 _16668;
	    _16668.x = _21354;
	    _16668.y = _21355;
	    _16668.z = _19167;
	    vec4 _11399 = vec4(mix(_16668.xyz, mix(_Globals_.g_vViewFadeColor.xyz, _Globals_.g_vViewFadeColor.xyz * _16668.xyz, vec3(_Globals_.g_flFadeMode)).xyz, vec3(_Globals_.g_vViewFadeColor.w)), _3300.w);
	    vec3 _25220 = pow(_11399.xyz, vec3(_Globals_.g_flFullScreenGamma * 0.454545438289642333984375));
	    vec4 _16669 = _11399;
	    _16669.x = _25220.x;
	    _16669.y = _25220.y;
	    _16669.z = _25220.z;
	    output_0 = _16669;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
