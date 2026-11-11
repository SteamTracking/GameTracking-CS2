//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Copy texture";
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
	Feature( F_WRITE_COLOR, 0..1, "" );
	Feature( F_BLEND_MUL, 0..1, "" );
	Feature( F_WRITE_DEPTH, 0..1, "" );
	Feature( F_USE_TEXCOORDS, 0..1, "" );
	Feature( F_USE_EXPLICIT_LOAD, 0..1, "" );
	Feature( F_GAMMA_CORRECT, 0..1, "" );
	Feature( F_TONEMAP, 0..1, "" );
	Feature( F_DESATURATE, 0..2 (0="Disabled", 1="Item Isolate Desaturation", 2="Variable Desaturation"), "" );
	FeatureRule( Allow1( F_USE_EXPLICIT_LOAD, F_USE_TEXCOORDS ), "Cannot use explicit load with texcoords" );
	FeatureRule( Allow1( F_WRITE_DEPTH, F_WRITE_COLOR ), "Cannot use explicit load with texcoords" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 vPositionSs : POSITION0  < Semantic( PosXyz ); >;                                      
	float2 vTexCoords  : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                               // S_USE_TEXCOORDS=1
};

VS
{
	StaticCombo( S_USE_TEXCOORDS, F_USE_TEXCOORDS );
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float3 vPositionSs;
	
	struct VS_INPUT
	{
	    float3 vPositionSs : POSITION0;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _22489 = float4(vPositionSs, 1.0f);
	    _22489.y = -vPositionSs.y;
	    gl_Position = _22489;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_WRITE_COLOR, F_WRITE_COLOR );
	StaticCombo( S_WRITE_DEPTH, F_WRITE_DEPTH );
	StaticCombo( S_BLEND_MUL, F_BLEND_MUL );
	StaticCombo( S_USE_TEXCOORDS, F_USE_TEXCOORDS );
	StaticCombo( S_USE_EXPLICIT_LOAD, F_USE_EXPLICIT_LOAD );
	StaticCombo( S_GAMMA_CORRECT, F_GAMMA_CORRECT );
	StaticCombo( S_TONEMAP, F_TONEMAP );
	StaticCombo( S_DESATURATE, F_DESATURATE );
	StaticComboRule( Allow1( S_USE_EXPLICIT_LOAD, S_USE_TEXCOORDS ) );
	StaticComboRule( Allow1( S_WRITE_DEPTH, S_WRITE_COLOR ) );
	DynamicCombo( D_VOLUME_TEXTURE, 0..1 );
	DynamicCombo( D_CHANNEL_CHOICE, 0..1 );
	DynamicCombo( D_SRGB_READ, 0..1 );
	DynamicCombo( D_BORDER_CLAMP, 0..1 );
	DynamicComboRule( Requires( D_BORDER_CLAMP, S_WRITE_COLOR ) );
	DynamicComboRule( Requires( D_BORDER_CLAMP, S_USE_TEXCOORDS ) );
	DynamicComboRule( Allow1( S_USE_EXPLICIT_LOAD, D_VOLUME_TEXTURE ) );
	
	float g_flChannelChoice < Attribute("ChannelChoice"); UiType(Slider); >;
	float g_flDesaturation < Attribute("DesaturationAmount"); UiType(Slider); >;
	float g_flExposure < Attribute("Exposure"); UiType(Slider); >;
	float g_flTexCoordW < Attribute("VolumeSliceTexCoord"); UiType(Slider); >;
	Texture3D g_tColorWarp3D < Channel(RGB, None(TextureColorWarp3D), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	Texture2D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(false); >;
	Texture2D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(true); >;
	Texture3D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(false); >;
	Texture3D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(true); >;
	Texture2D g_tDepthTexture < Attribute("CustomTexture0"); SrgbRead(false); >;
	float3 g_vColorTint < Default3(1, 1, 1); Attribute("ColorTint"); UiType(VectorText); >;
	float4 g_vScaleAndBias < Default4(0, 1, 0, 1); Attribute("ScaleAndBias"); UiType(VectorText); >;
	
	// Color
	CreateInputTexture2D(TextureColorWarp3D, Srgb, 8, "", "_z000", "Color,10/Color Warp", Default4(1, 1, 1, 1));
	
	#if (S_WRITE_COLOR == 1)
		Texture2D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(false); >;
		Texture2D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture3D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(false); >;
	Texture3D g_tCopyColor < Attribute("CustomTexture1"); SrgbRead(true); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vScaleAndBias) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	struct _1017
	{
	    vec4 g_vScaleAndBias;
	};
	
	layout(set = 1) uniform _1017 _Globals_;
	
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    output_0 = vec4(_Globals_.g_vScaleAndBias.xxxz);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
