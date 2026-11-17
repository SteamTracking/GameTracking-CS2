//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Smoke Volume";
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
	float4 vPositionPs : POSITION0  < Semantic( position ); >;                                    
	float4 vTexCoord   : TEXCOORD0  < Semantic( texcoord ); >;                                    
};

VS
{
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b0, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c4);
	    float3 PerViewConstantBuffer_t_1_m1 : packoffset(c26);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float2 vTexCoord;
	static float2 output_0;
	static float4 output_1;
	static float3 output_2;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14817 = float4(vPositionPs, 0.0f, 1.0f);
	    float4 _14015 = mul(PerViewConstantBuffer_t_1_m0, float4((vTexCoord.x * 2.0f) - 1.0f, ((1.0f - vTexCoord.y) * 2.0f) - 1.0f, 1.0f, 1.0f));
	    _14817.y = -vPositionPs.y;
	    gl_Position = _14817;
	    output_0 = vTexCoord;
	    output_1 = 1.0f.xxxx;
	    output_2 = normalize((_14015.xyz / _14015.w.xxx) - PerViewConstantBuffer_t_1_m1.xyz);
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
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_INFERNO_ENVIRONMENT, 0..2 );
	DynamicCombo( D_INFERNO_MSAA, 0..1 );
	DynamicComboRule( Requires( D_INFERNO_MSAA, D_INFERNO_ENVIRONMENT ) );
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tDepth < Attribute("DepthBuffer"); SrgbRead(false); >;
	Texture2D g_tFire < Attribute("Fire"); SrgbRead(false); >;
	Texture2D g_tInputTexture < Attribute("InputTexture"); SrgbRead(false); >;
	Texture2D g_tSceneDepth < Attribute("SceneDepthInferno"); SrgbRead(false); >;
	Texture3D g_tSmokeNoiseTex < Channel(RG, None(TextureNoise), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	
	// Noise
	CreateInputTexture2D(TextureNoise, Srgb, 8, "", "_z0000", "Noise", Default4(1, 1, 1, 1));
	
	// Settings
	float g_flTintStrength < Default(1); UiType(Slider); UiGroup("Settings"); >;
	float3 g_vTintColor < UiType(Color); UiGroup("Settings"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vTintColor) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_samplerless_texture_functions : require
	layout(early_fragment_tests) in;
	
	struct _2620
	{
	    vec4 _m0[256];
	};
	
	struct _2746
	{
	    vec4 _m0[16];
	};
	
	struct _1786
	{
	    uvec4 _m0[64];
	};
	
	struct _1876
	{
	    uvec4 _m0[4];
	};
	
	struct _755
	{
	    _2620 _m0;
	    _2746 _m1;
	    _1786 _m2;
	    _1876 _m3;
	};
	
	layout(set = 1) uniform _755 BoundingBoxConstantBufferFire_t;
	
	struct _1285
	{
	    vec4 _m0;
	    float _m1;
	    float _m2;
	    float _m3;
	    vec3 _m4;
	    vec3 _m5;
	};
	
	layout(set = 1) uniform _1285 PerViewConstantBuffer_t;
	
	struct _1033
	{
	    float g_flTintStrength;
	    vec3 g_vTintColor;
	};
	
	layout(set = 1) uniform _1033 _Globals_;
	
	layout(set = 1, binding = 50) uniform texture2D g_tSceneDepth;
	layout(set = 1, binding = 51) uniform texture3D g_tSmokeNoiseTex;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearWrap;
	
	layout(location = 0) in vec2 input_0;
	layout(location = 2) in vec3 input_2;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    uint _9443 = uint(dot(floor(input_0.xy * 4.0), vec2(1.0, 4.0)));
	    uint _23984 = _9443 / 4u;
	    uint _8742 = _9443 % 4u;
	    if (BoundingBoxConstantBufferFire_t._m3._m0[_23984][_8742] == 0u)
	    {
	        discard;
	    }
	    vec3 _15651 = PerViewConstantBuffer_t._m4 + (input_2 * (1.0 / (((saturate((texelFetch(g_tSceneDepth, ivec3(ivec2(gl_FragCoord.xy), 0).xy, 0).x - PerViewConstantBuffer_t._m2) / (PerViewConstantBuffer_t._m3 - PerViewConstantBuffer_t._m2)) * PerViewConstantBuffer_t._m0.z) + PerViewConstantBuffer_t._m0.w) * dot(PerViewConstantBuffer_t._m5.xyz, input_2))));
	    float _13155;
	    _13155 = 0.0;
	    uint _8822;
	    float _12124;
	    uint _16208 = BoundingBoxConstantBufferFire_t._m3._m0[_23984][_8742];
	    for (;;)
	    {
	        if (!(_16208 != 0u))
	        {
	            break;
	        }
	        uint _17426 = uint(findLSB(_16208));
	        _8822 = _16208 & (_16208 - 1u);
	        float _9489 = PerViewConstantBuffer_t._m1 - BoundingBoxConstantBufferFire_t._m1._m0[_17426].x;
	        uint _10083 = _17426 * 16u;
	        uint _14293 = _10083 + _9443;
	        uint _15661 = _14293 / 4u;
	        uint _8743 = _14293 % 4u;
	        float _13156;
	        _13156 = 0.0;
	        uint _10019;
	        float _12501;
	        uint _16209 = BoundingBoxConstantBufferFire_t._m2._m0[_15661][_8743];
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            uint _17427 = uint(findLSB(_16209));
	            _10019 = _16209 & (_16209 - 1u);
	            uint _23944 = _10083 + _17427;
	            vec3 _11346 = _15651 - BoundingBoxConstantBufferFire_t._m0._m0[_23944].xyz;
	            _11346.z = _11346.z * 2.0;
	            float _24065 = PerViewConstantBuffer_t._m1 - BoundingBoxConstantBufferFire_t._m0._m0[_23944].w;
	            float _9251 = length(_11346) - _24065;
	            if (_9251 >= 100.0)
	            {
	                _12501 = _13156;
	                _13156 = _12501;
	                _16209 = _10019;
	                continue;
	            }
	            _12501 = max(_13156, (smoothstep(100.0, 50.0, _9251) * smoothstep(0.0, 1.0, _24065)) * smoothstep(6.5, 5.5, BoundingBoxConstantBufferFire_t._m0._m0[_23944].w - BoundingBoxConstantBufferFire_t._m1._m0[_17426].x));
	            _13156 = _12501;
	            _16209 = _10019;
	            continue;
	        }
	        float _18039 = _13156 * smoothstep(0.0, 0.5, _9489);
	        float _19755;
	        if (_18039 > 0.0)
	        {
	            _15651.z = _15651.z + (100.0 * smoothstep(7.0, 0.0, _9489));
	            vec4 _12091 = textureLod(sampler3D(g_tSmokeNoiseTex, g_sTrilinearWrap), (_15651 * 0.007000000216066837310791015625).xyz, 0.0);
	            _19755 = saturate((_12091.y + _18039) * _18039) * (0.85000002384185791015625 + (_12091.x * 0.100000001490116119384765625));
	        }
	        else
	        {
	            _19755 = _18039;
	        }
	        _12124 = max(_13155, _19755 * smoothstep(20.0, 6.0, _9489));
	        _13155 = _12124;
	        _16208 = _8822;
	        continue;
	    }
	    if ((_13155 - 9.9999997473787516355514526367188e-05) < 0.0)
	    {
	        discard;
	    }
	    output_0 = vec4(_Globals_.g_vTintColor, _13155) * _Globals_.g_flTintStrength;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
