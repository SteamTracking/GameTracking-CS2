//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Bloom";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: cs
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

CS
{
	DynamicCombo( D_BLOOM_MODE, 0..3 );
	DynamicCombo( D_PANO_OUTPUT, 0..1 );
	DynamicCombo( D_PANO_COLOR_CORRECT, 0..1 );
	DynamicCombo( D_LOCAL_CONTRAST_OUTPUT, 0..1 );
	
	float g_fEffectsScale < Attribute("EffectsScale"); UiType(Slider); >;
	float g_fPreMultiply < Attribute("PreMultiply"); UiType(Slider); >;
	float g_fRadius < Attribute("Radius"); UiType(Slider); >;
	float g_fThreshold < Attribute("Threshold"); UiType(Slider); >;
	float g_fUpScaleFilterSize < Attribute("UpScaleFilterSize"); UiType(Slider); >;
	float g_flColorCorrectionDefaultWeight < Attribute("ColorCorrectionDefaultWeight"); UiType(Slider); >;
	int g_nAuxSrcHeight < Attribute("AuxSrcHeight"); UiType(Slider); >;
	int g_nAuxSrcWidth < Attribute("AuxSrcWidth"); UiType(Slider); >;
	int g_nDstHeight < Attribute("DstHeight"); UiType(Slider); >;
	int g_nDstWidth < Attribute("DstWidth"); UiType(Slider); >;
	int g_nSrcHeight < Attribute("SrcHeight"); UiType(Slider); >;
	int g_nSrcWidth < Attribute("SrcWidth"); UiType(Slider); >;
	Texture2D g_tAuxInputDownSample < Attribute("AuxInputDownSample"); SrgbRead(false); >;
	Texture3D g_tColorCorrection < Attribute("ColorCorrectionTex"); SrgbRead(false); >;
	Texture2D g_tEffectsBloom < Attribute("EffectsBloom"); SrgbRead(false); >;
	Texture2D g_tInputDownSample < Attribute("InputDownSample"); SrgbRead(false); >;
	Texture2D g_tInputUpSample < Attribute("InputUpSample"); SrgbRead(false); >;
	RWTexture2D<float4> g_tLocalContrastOutput < Attribute("LocalContrastOutput"); >;
	RWTexture2D<float4> g_tOutput < Attribute("Output"); >;
	RWTexture2D<float4> g_tPanoOutput < Attribute("PanoOutput"); >;
	float4 g_vAuxInputDownSampleDim < Source(TextureDim); SourceArg(g_tAuxInputDownSample) UiType(VectorText); >;
	float4 g_vInputDownSampleDim < Source(TextureDim); SourceArg(g_tInputDownSample) UiType(VectorText); >;
	float4 g_vInputUpSampleDim < Source(TextureDim); SourceArg(g_tInputUpSample) UiType(VectorText); >;
	float4 g_vInvAuxInputDownSampleDim < Source(InvTextureDim); SourceArg(g_tAuxInputDownSample) UiType(VectorText); >;
	float4 g_vInvEffectsBloomDim < Source(InvTextureDim); SourceArg(g_tEffectsBloom) UiType(VectorText); >;
	float4 g_vInvInputDownSampleDim < Source(InvTextureDim); SourceArg(g_tInputDownSample) UiType(VectorText); >;
	float4 g_vInvInputUpSampleDim < Source(InvTextureDim); SourceArg(g_tInputUpSample) UiType(VectorText); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vInputDownSampleDim) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
	
	vec4 _4;
	
	struct _1146
	{
	    vec4 g_vInputDownSampleDim;
	    vec4 g_vInvInputDownSampleDim;
	    uint g_nSrcWidth;
	    uint g_nSrcHeight;
	    uint g_nDstWidth;
	    uint g_nDstHeight;
	};
	
	layout(set = 0) uniform _1146 _Globals_;
	
	layout(set = 0, binding = 30) uniform texture2D g_tInputDownSample;
	layout(set = 0, binding = 16) uniform sampler g_sBilinearClamp;
	layout(set = 0, binding = 158) uniform writeonly image2D g_tOutput;
	
	void main()
	{
	    do
	    {
	        uint _16337 = (gl_WorkGroupID.x * 8u) + gl_LocalInvocationID.x;
	        uint _24071 = (gl_WorkGroupID.y * 8u) + gl_LocalInvocationID.y;
	        uvec2 _13756 = uvec2(_16337, _24071);
	        bool _12885;
	        if (_16337 >= _Globals_.g_nDstWidth)
	        {
	            _12885 = true;
	        }
	        else
	        {
	            _12885 = _24071 >= _Globals_.g_nDstHeight;
	        }
	        if (_12885)
	        {
	            break;
	        }
	        vec2 _21281 = vec2(float(_Globals_.g_nSrcWidth), float(_Globals_.g_nSrcHeight));
	        vec2 _5745 = _21281 / _Globals_.g_vInputDownSampleDim.xy;
	        vec2 _3161 = vec2(1.0) / _21281;
	        vec2 _4190 = saturate(((vec2(_13756) + vec2(0.5)) * 2.0) * _3161) * _5745;
	        vec2 _7867 = _5745 - (_Globals_.g_vInvInputDownSampleDim.xy * 1.5);
	        vec3 _17136 = clamp((((((textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(-2.0, 2.0) / _21281), _7867), 0.0).xyz + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(2.0) / _21281), _7867), 0.0).xyz) + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(-2.0) / _21281), _7867), 0.0).xyz) + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(2.0, -2.0) / _21281), _7867), 0.0).xyz) * 0.03125) + ((((textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(0.0, 2.0) / _21281), _7867), 0.0).xyz + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(-2.0, 0.0) / _21281), _7867), 0.0).xyz) + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(2.0, 0.0) / _21281), _7867), 0.0).xyz) + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(0.0, -2.0) / _21281), _7867), 0.0).xyz) * 0.0625)) + (((((textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190, _7867), 0.0).xyz + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(-1.0, 1.0) / _21281), _7867), 0.0).xyz) + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + _3161, _7867), 0.0).xyz) + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(-1.0) / _21281), _7867), 0.0).xyz) + textureLod(sampler2D(g_tInputDownSample, g_sBilinearClamp), min(_4190 + (vec2(1.0, -1.0) / _21281), _7867), 0.0).xyz) * 0.125), vec3(0.0), vec3(65504.0));
	        imageStore(g_tOutput, ivec2(_13756), vec4(_17136, 0.0));
	        break;
	    } while(false);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
