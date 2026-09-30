//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Crosshair";
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
};

VS
{
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float3 vPositionSs;
	
	struct VS_INPUT
	{
	    float3 vPositionSs : TEXCOORD0;
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
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1372
	{
	    float4 _m0;
	    float _m1;
	    uint _m2;
	    float2 _m3;
	    float4 _m4;
	    float4 _m5;
	};
	
	struct _1750
	{
	    _1372 _m0[16];
	};
	
	cbuffer CrosshairParamBuffer_t : register(b2, space1)
	{
	    _1750 CrosshairParamBuffer_t_1_m0 : packoffset(c0);
	    float2 CrosshairParamBuffer_t_1_m1 : packoffset(c64);
	    uint CrosshairParamBuffer_t_1_m2 : packoffset(c64.z);
	};
	
	
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
	    int2 _15332 = int2(gl_FragCoord.xy - CrosshairParamBuffer_t_1_m1);
	    float4 _13136;
	    float4 _16324;
	    _13136 = 0.0f.xxxx;
	    _16324 = 0.0f.xxxx;
	    uint _8087;
	    float4 _14382;
	    float4 _19322;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < CrosshairParamBuffer_t_1_m2))
	        {
	            break;
	        }
	        float2 _19321;
	        do
	        {
	            if (CrosshairParamBuffer_t_1_m0._m0[_17017]._m2 == 1u)
	            {
	                float2 _10358 = float2(_15332) - CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.xy;
	                float _9043 = atan2(_10358.x, -_10358.y);
	                float _8094 = CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z - CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.w;
	                float _15850 = length(_10358);
	                float _24623 = max(smoothstep(0.0f, 1.57079637050628662109375f, _9043), smoothstep(-1.57079637050628662109375f, -3.1415927410125732421875f, _9043));
	                float _21806 = CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z + lerp(CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.x, CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.y, _24623);
	                float _8979 = _8094 - lerp(CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.y, CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.x, _24623);
	                _19321 = float2(smoothstep(_21806 + 0.5f, _21806 - 0.5f, _15850) * smoothstep(_8979 - 0.5f, _8979 + 0.5f, _15850), smoothstep(CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z + 0.5f, CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z - 0.5f, _15850) * smoothstep(_8094 - 0.5f, _8094 + 0.5f, _15850));
	                break;
	            }
	            if (CrosshairParamBuffer_t_1_m0._m0[_17017]._m2 == 2u)
	            {
	                float2 _10359 = float2(_15332) - CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.xy;
	                float _17815 = atan2(_10359.x, -_10359.y);
	                float _25028 = abs((_17815 - (floor(_17815 * 0.636619746685028076171875f) * 1.57079637050628662109375f)) - 0.785398185253143310546875f);
	                float _11627 = length(_10359);
	                float _13480 = max(_11627, 1.0f);
	                float _20601 = 1.0f / _13480;
	                float _6621 = 0.5f * CrosshairParamBuffer_t_1_m0._m0[_17017]._m1;
	                float _24624 = max(smoothstep(0.0f, 1.57079637050628662109375f, _17815), smoothstep(-1.57079637050628662109375f, -3.1415927410125732421875f, _17815));
	                float _11476 = lerp(CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.x, CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.y, _24624);
	                float _17887 = 0.5f / _13480;
	                float _18480 = CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z - CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.w;
	                float _6994 = CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z + _11476;
	                float _8980 = _18480 - lerp(CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.y, CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.x, _24624);
	                _19321 = float2(smoothstep(_6994 + 0.5f, _6994 - 0.5f, _11627) * smoothstep(_8980 - 0.5f, _8980 + 0.5f, _11627), smoothstep(CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z + 0.5f, CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.z - 0.5f, _11627) * smoothstep(_18480 - 0.5f, _18480 + 0.5f, _11627)) * float2(smoothstep(_6621 + ((_11476 + 0.5f) * _20601), _6621 + ((_11476 - 0.5f) * _20601), _25028), smoothstep(_6621 + _17887, _6621 - _17887, _25028));
	                break;
	            }
	            float2 _13027 = float2(_15332);
	            float2 _14945 = CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.xy - CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.x.xx;
	            bool _25239;
	            if (all(bool2(_13027.x >= _14945.x, _13027.y >= _14945.y)))
	            {
	                float2 _12606 = CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.zw + CrosshairParamBuffer_t_1_m0._m0[_17017]._m3.y.xx;
	                _25239 = all(bool2(_13027.x <= _12606.x, _13027.y <= _12606.y));
	            }
	            else
	            {
	                _25239 = false;
	            }
	            bool _23149;
	            if (all(bool2(_13027.x >= CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.xy.x, _13027.y >= CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.xy.y)))
	            {
	                _23149 = all(bool2(_13027.x <= CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.zw.x, _13027.y <= CrosshairParamBuffer_t_1_m0._m0[_17017]._m0.zw.y));
	            }
	            else
	            {
	                _23149 = false;
	            }
	            _19321 = float2(float(_25239), float(_23149));
	            break;
	        } while(false);
	        float _5756 = _19321.y * CrosshairParamBuffer_t_1_m0._m0[_17017]._m4.w;
	        if (_5756 >= _16324.w)
	        {
	            _19322 = float4(CrosshairParamBuffer_t_1_m0._m0[_17017]._m4.xyz, _5756);
	        }
	        else
	        {
	            _19322 = _16324;
	        }
	        float _5682 = _19321.x * CrosshairParamBuffer_t_1_m0._m0[_17017]._m5.w;
	        if (_5682 >= _13136.w)
	        {
	            _14382 = float4(CrosshairParamBuffer_t_1_m0._m0[_17017]._m5.xyz, _5682);
	        }
	        else
	        {
	            _14382 = _13136;
	        }
	        _8087 = _17017 + 1u;
	        _13136 = _14382;
	        _16324 = _19322;
	        _17017 = _8087;
	        continue;
	    }
	    float _24128 = (1.0f - _16324.w) * _13136.w;
	    float _20214 = lerp(0.0f, 1.0f, _24128);
	    output_0 = float4(lerp(float4(lerp(0.0f.xxx, _13136.xyz, _24128.xxx), _20214).xyz, _16324.xyz, _16324.w.xxx), lerp(_20214, 1.0f, _16324.w));
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
