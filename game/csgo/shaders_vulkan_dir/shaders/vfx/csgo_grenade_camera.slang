//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Grenade Camera";
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
	float2 vTexcoord   : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                              
};

VS
{
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float3 vPositionSs;
	static float2 vTexcoord;
	static float2 output_0;
	
	struct VS_INPUT
	{
	    float3 vPositionSs : POSITION0;
	    float2 vTexcoord : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14456 = float4(vPositionSs, 1.0f);
	    output_0 = vTexcoord;
	    _14456.y = -vPositionSs.y;
	    gl_Position = _14456;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    vTexcoord = stage_input.vTexcoord;
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
	DynamicCombo( D_MSAA_TEXTURE, 0..1 );
	
	float g_flCameraDuration < Attribute("CameraDuration"); UiType(Slider); >;
	float g_flJumpThrow < Attribute("JumpThrow"); UiType(Slider); >;
	int g_nTextureHeight < Attribute("TextureHeight"); UiType(Slider); >;
	int g_nTextureWidth < Attribute("TextureWidth"); UiType(Slider); >;
	Texture2D g_tCameraTexture < Attribute("CameraTexture"); SrgbRead(false); >;
	Texture2D g_tJumpThrowIcon < Channel(RGBA, Box(TextureJumpThrowIcon), Srgb); OutputFormat(BC7); SrgbRead(false); >;
	
	// Icons
	CreateInputTexture2D(TextureJumpThrowIcon, Srgb, 8, "", "", "Icons", Default4(1, 1, 1, 0));
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c18.w);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c22);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flCameraDuration : packoffset(c0.z);
	    int _Globals_1_g_nTextureWidth : packoffset(c1);
	    int _Globals_1_g_nTextureHeight : packoffset(c1.y);
	    float _Globals_1_g_flJumpThrow : packoffset(c1.z);
	};
	
	Texture2D<float4> g_tCameraTexture : register(t30, space1);
	SamplerState DefaultSamplerState_0 : register(s22, space1);
	Texture2D<float4> g_tJumpThrowIcon : register(t31, space1);
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
	    float _3458 = PerViewConstantBuffer_t_1_m1.x / PerViewConstantBuffer_t_1_m1.y;
	    float _18675 = 0.100000001490116119384765625f * _3458;
	    float _5682 = ((smoothstep(0.0f, _18675, input_0.x) * smoothstep(1.0f, 1.0f - _18675, input_0.x)) * smoothstep(0.0f, 0.100000001490116119384765625f, input_0.y)) * smoothstep(1.0f, 0.89999997615814208984375f, input_0.y);
	    float _10748 = smoothstep(0.5f, 0.5099999904632568359375f, _5682);
	    float2 _13537 = float2(1.0f / float(_Globals_1_g_nTextureWidth), 1.0f / float(_Globals_1_g_nTextureHeight));
	    float3 _13155;
	    _13155 = 0.0f.xxx;
	    int _21567;
	    float3 _13156;
	    int _16208 = 0;
	    for (;;)
	    {
	        if (!(_16208 < 3))
	        {
	            break;
	        }
	        _13156 = _13155;
	        int _9913;
	        float3 _10789;
	        int _16209 = 0;
	        for (;;)
	        {
	            if (!(_16209 < 3))
	            {
	                break;
	            }
	            _10789 = _13156 + g_tCameraTexture.Sample(DefaultSamplerState_0, (input_0.xy + (float2(float(_16208), float(_16209)) * _13537)).xy).xyz;
	            _9913 = _16209 + 1;
	            _13156 = _10789;
	            _16209 = _9913;
	            continue;
	        }
	        _21567 = _16208 + 1;
	        _13155 = _13156;
	        _16208 = _21567;
	        continue;
	    }
	    float3 _10289 = lerp(0.0f.xxx, (_13155 * 0.111111111938953399658203125f).xyz, _10748.xxx);
	    float3 _11275;
	    if (_Globals_1_g_flJumpThrow > 0.0f)
	    {
	        float2 _22640 = float2(0.100000001490116119384765625f, (-0.300000011920928955078125f) + (fmod(PerViewConstantBuffer_t_1_m0, 0.5f) * 0.100000001490116119384765625f)) + (input_0.xy * 4.0f);
	        _22640.y = _22640.y * _3458;
	        float4 _3300 = g_tJumpThrowIcon.Sample(g_sBilinearClamp, _22640);
	        _11275 = lerp(_10289.xyz, _3300.xyz, (_3300.w * _Globals_1_g_flJumpThrow).xxx);
	    }
	    else
	    {
	        _11275 = _10289;
	    }
	    float _3092 = input_0.x - (input_0.y * 0.100000001490116119384765625f);
	    output_0 = float4(pow(_11275, 2.2000000476837158203125f.xxx), lerp(_5682, 1.0f, _10748) * smoothstep(_3092 - 0.100000001490116119384765625f, _3092, _Globals_1_g_flCameraDuration * 8.0f));
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
