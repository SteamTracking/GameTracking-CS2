//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Crosshair";
	DevShader = true;
	Version = 2;
	
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
	uint4  nPrimMaskLo : TEXCOORD0  < Semantic( PrimMaskLo ); >;                                  
	uint4  nPrimMaskHi : TEXCOORD1  < Semantic( PrimMaskHi ); >;                                  
};

VS
{
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float3 vPositionSs;
	static uint nPrimMaskLo;
	static uint nPrimMaskHi;
	static uint2 output_0;
	
	struct VS_INPUT
	{
	    float3 vPositionSs : TEXCOORD0;
	    uint nPrimMaskLo : TEXCOORD1;
	    uint nPrimMaskHi : TEXCOORD2;
	};
	
	struct PS_INPUT
	{
	    nointerpolation uint2 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14437 = float4(vPositionSs, 1.0f);
	    _14437.y = -vPositionSs.y;
	    gl_Position = _14437;
	    output_0 = uint2(nPrimMaskLo, nPrimMaskHi);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    nPrimMaskLo = stage_input.nPrimMaskLo;
	    nPrimMaskHi = stage_input.nPrimMaskHi;
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
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tFriendlyIcon < Channel(RGBA, None(TextureFriendlyIcon), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tGlyphAtlas < Channel(RGBA, None(TextureGlyphAtlas), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// Friendly
	CreateInputTexture2D(TextureFriendlyIcon, Srgb, 8, "", "", "Friendly", Default4(1, 1, 1, 0));
	
	// Glyphs
	CreateInputTexture2D(TextureGlyphAtlas, Srgb, 8, "", "", "Glyphs", Default4(1, 1, 1, 0));
	
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
	
	struct _2780
	{
	    _1372 _m0[64];
	};
	
	cbuffer CrosshairParamBuffer_t : register(b2, space1)
	{
	    _2780 CrosshairParamBuffer_t_1_m0 : packoffset(c0);
	    float2 CrosshairParamBuffer_t_1_m1 : packoffset(c256);
	};
	
	Texture2D<float4> g_tFriendlyIcon : register(t32, space1);
	SamplerState DefaultSamplerState_0 : register(s16, space1);
	Texture2D<float4> g_tGlyphAtlas : register(t31, space1);
	SamplerState DefaultSamplerState_0_1 : register(s15, space1);
	
	static float4 gl_FragCoord;
	static uint2 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    nointerpolation uint2 input_0 : TEXCOORD0;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    int2 _9733 = int2(gl_FragCoord.xy - CrosshairParamBuffer_t_1_m1);
	    float3 _13136;
	    float4 _16305;
	    uint2 _17017;
	    float4 _17133;
	    _13136 = 0.0f.xxx;
	    _16305 = 0.0f.xxxx;
	    _17133 = 0.0f.xxxx;
	    _17017 = input_0;
	    uint2 _9716;
	    float3 _13137;
	    float4 _16381;
	    float4 _19757;
	    for (;;)
	    {
	        if (!any(bool2(_17017.x != uint2(0u, 0u).x, _17017.y != uint2(0u, 0u).y)))
	        {
	            break;
	        }
	        uint _24954;
	        if (_17017.x != 0u)
	        {
	            uint2 _11131 = _17017;
	            _11131.x = _17017.x & (_17017.x - 1u);
	            _9716 = _11131;
	            _24954 = firstbitlow(_17017.x);
	        }
	        else
	        {
	            uint2 _11130 = _17017;
	            _11130.y = _17017.y & (_17017.y - 1u);
	            _9716 = _11130;
	            _24954 = 32u + firstbitlow(_17017.y);
	        }
	        float2 _7078;
	        do
	        {
	            if (CrosshairParamBuffer_t_1_m0._m0[_24954]._m2 == 4u)
	            {
	                float2 _12501;
	                do
	                {
	                    float2 _13278 = float2(_9733);
	                    bool _12885;
	                    if (any(bool2(_13278.x < CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy.x, _13278.y < CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy.y)))
	                    {
	                        _12885 = true;
	                    }
	                    else
	                    {
	                        _12885 = any(bool2(_13278.x > CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw.x, _13278.y > CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw.y));
	                    }
	                    if (_12885)
	                    {
	                        _12501 = 0.0f.xx;
	                        break;
	                    }
	                    float2 _6359 = max((CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy) + 1.0f.xx, 1.0f.xx);
	                    float2 _22235 = ((_13278 + 0.5f.xx) - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy) / _6359;
	                    float2 _15649 = 1.0f.xx / _6359;
	                    float _13155;
	                    _13155 = 0.0f;
	                    int _21567;
	                    float _13156;
	                    int _16208 = 0;
	                    for (;;)
	                    {
	                        if (!(_16208 < 3))
	                        {
	                            break;
	                        }
	                        _13156 = _13155;
	                        float _7869;
	                        int _24140;
	                        int _16209 = 0;
	                        for (;;)
	                        {
	                            if (!(_16209 < 3))
	                            {
	                                break;
	                            }
	                            _7869 = _13156 + g_tFriendlyIcon.SampleLevel(DefaultSamplerState_0, (_22235 + ((((float2(float(_16209), float(_16208)) + 0.5f.xx) * 0.3333333432674407958984375f.xx) - 0.5f.xx) * _15649)).xy, 0.0f).x;
	                            _24140 = _16209 + 1;
	                            _13156 = _7869;
	                            _16209 = _24140;
	                            continue;
	                        }
	                        _21567 = _16208 + 1;
	                        _13155 = _13156;
	                        _16208 = _21567;
	                        continue;
	                    }
	                    _12501 = float2(0.0f, _13155 * 0.111111111938953399658203125f);
	                    break;
	                } while(false);
	                _7078 = _12501;
	                break;
	            }
	            if (CrosshairParamBuffer_t_1_m0._m0[_24954]._m2 == 3u)
	            {
	                float2 _12502;
	                do
	                {
	                    float2 _13279 = float2(_9733);
	                    bool _12886;
	                    if (any(bool2(_13279.x < CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy.x, _13279.y < CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy.y)))
	                    {
	                        _12886 = true;
	                    }
	                    else
	                    {
	                        _12886 = any(bool2(_13279.x > CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw.x, _13279.y > CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw.y));
	                    }
	                    if (_12886)
	                    {
	                        _12502 = 0.0f.xx;
	                        break;
	                    }
	                    float2 _22965 = max((CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy) + 1.0f.xx, 1.0f.xx);
	                    uint _24331 = uint(CrosshairParamBuffer_t_1_m0._m0[_24954]._m1);
	                    float2 _24236 = float2(64.0f, 50.0f) * (float2(float(_24331 % 4u), float(_24331 / 4u)) + (((_13279 + 0.5f.xx) - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy) / _22965));
	                    float2 _21240 = float2(64.0f, 50.0f) / _22965;
	                    float _13157;
	                    _13157 = 0.0f;
	                    int _21568;
	                    float _13158;
	                    int _16210 = 0;
	                    for (;;)
	                    {
	                        if (!(_16210 < 3))
	                        {
	                            break;
	                        }
	                        _13158 = _13157;
	                        float _7870;
	                        int _24141;
	                        int _16211 = 0;
	                        for (;;)
	                        {
	                            if (!(_16211 < 3))
	                            {
	                                break;
	                            }
	                            _7870 = _13158 + g_tGlyphAtlas.SampleLevel(DefaultSamplerState_0_1, ((_24236 + ((((float2(float(_16211), float(_16210)) + 0.5f.xx) * 0.3333333432674407958984375f.xx) - 0.5f.xx) * _21240)) * 0.00390625f.xx).xy, 0.0f).x;
	                            _24141 = _16211 + 1;
	                            _13158 = _7870;
	                            _16211 = _24141;
	                            continue;
	                        }
	                        _21568 = _16210 + 1;
	                        _13157 = _13158;
	                        _16210 = _21568;
	                        continue;
	                    }
	                    _12502 = float2(0.0f, _13157 * 0.111111111938953399658203125f);
	                    break;
	                } while(false);
	                _7078 = _12502;
	                break;
	            }
	            if (CrosshairParamBuffer_t_1_m0._m0[_24954]._m2 == 1u)
	            {
	                float2 _10358 = float2(_9733) - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy;
	                float _9043 = atan2(_10358.x, -_10358.y);
	                float _8094 = CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.w;
	                float _15850 = length(_10358);
	                float _24623 = max(smoothstep(0.0f, 1.57079637050628662109375f, _9043), smoothstep(-1.57079637050628662109375f, -3.1415927410125732421875f, _9043));
	                float _21807 = CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z + lerp(CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.x, CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.y, _24623);
	                float _8979 = _8094 - lerp(CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.y, CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.x, _24623);
	                _7078 = float2(smoothstep(_21807 + 0.5f, _21807 - 0.5f, _15850) * smoothstep(_8979 - 0.5f, _8979 + 0.5f, _15850), smoothstep(CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z + 0.5f, CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z - 0.5f, _15850) * smoothstep(_8094 - 0.5f, _8094 + 0.5f, _15850));
	                break;
	            }
	            if (CrosshairParamBuffer_t_1_m0._m0[_24954]._m2 == 2u)
	            {
	                float2 _10359 = float2(_9733) - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy;
	                float _17815 = atan2(_10359.x, -_10359.y);
	                float _25028 = abs((_17815 - (floor(_17815 * 0.636619746685028076171875f) * 1.57079637050628662109375f)) - 0.785398185253143310546875f);
	                float _11627 = length(_10359);
	                float _13480 = max(_11627, 1.0f);
	                float _20601 = 1.0f / _13480;
	                float _6621 = 0.5f * CrosshairParamBuffer_t_1_m0._m0[_24954]._m1;
	                float _24624 = max(smoothstep(0.0f, 1.57079637050628662109375f, _17815), smoothstep(-1.57079637050628662109375f, -3.1415927410125732421875f, _17815));
	                float _11476 = lerp(CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.x, CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.y, _24624);
	                float _17887 = 0.5f / _13480;
	                float _18480 = CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z - CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.w;
	                float _6994 = CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z + _11476;
	                float _8980 = _18480 - lerp(CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.y, CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.x, _24624);
	                _7078 = float2(smoothstep(_6994 + 0.5f, _6994 - 0.5f, _11627) * smoothstep(_8980 - 0.5f, _8980 + 0.5f, _11627), smoothstep(CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z + 0.5f, CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.z - 0.5f, _11627) * smoothstep(_18480 - 0.5f, _18480 + 0.5f, _11627)) * float2(smoothstep(_6621 + ((_11476 + 0.5f) * _20601), _6621 + ((_11476 - 0.5f) * _20601), _25028), smoothstep(_6621 + _17887, _6621 - _17887, _25028));
	                break;
	            }
	            float2 _13027 = float2(_9733);
	            float2 _14945 = CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy - CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.x.xx;
	            bool _25239;
	            if (all(bool2(_13027.x >= _14945.x, _13027.y >= _14945.y)))
	            {
	                float2 _12606 = CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw + CrosshairParamBuffer_t_1_m0._m0[_24954]._m3.y.xx;
	                _25239 = all(bool2(_13027.x <= _12606.x, _13027.y <= _12606.y));
	            }
	            else
	            {
	                _25239 = false;
	            }
	            bool _23149;
	            if (all(bool2(_13027.x >= CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy.x, _13027.y >= CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.xy.y)))
	            {
	                _23149 = all(bool2(_13027.x <= CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw.x, _13027.y <= CrosshairParamBuffer_t_1_m0._m0[_24954]._m0.zw.y));
	            }
	            else
	            {
	                _23149 = false;
	            }
	            _7078 = float2(float(_25239), float(_23149));
	            break;
	        } while(false);
	        if (CrosshairParamBuffer_t_1_m0._m0[_24954]._m2 == 4u)
	        {
	            _13137 = _13136 + (CrosshairParamBuffer_t_1_m0._m0[_24954]._m4.xyz * (_7078.y * CrosshairParamBuffer_t_1_m0._m0[_24954]._m4.w));
	            _16381 = _16305;
	            _19757 = _17133;
	            _13136 = _13137;
	            _16305 = _16381;
	            _17133 = _19757;
	            _17017 = _9716;
	            continue;
	        }
	        float _5756 = _7078.y * CrosshairParamBuffer_t_1_m0._m0[_24954]._m4.w;
	        float4 _19321;
	        if (_5756 >= _17133.w)
	        {
	            _19321 = float4(CrosshairParamBuffer_t_1_m0._m0[_24954]._m4.xyz, _5756);
	        }
	        else
	        {
	            _19321 = _17133;
	        }
	        float _5682 = _7078.x * CrosshairParamBuffer_t_1_m0._m0[_24954]._m5.w;
	        float4 _12503;
	        if (_5682 >= _16305.w)
	        {
	            _12503 = float4(CrosshairParamBuffer_t_1_m0._m0[_24954]._m5.xyz, _5682);
	        }
	        else
	        {
	            _12503 = _16305;
	        }
	        _13137 = _13136;
	        _16381 = _12503;
	        _19757 = _19321;
	        _13136 = _13137;
	        _16305 = _16381;
	        _17133 = _19757;
	        _17017 = _9716;
	        continue;
	    }
	    float _24128 = (1.0f - _17133.w) * _16305.w;
	    float _20214 = lerp(0.0f, 1.0f, _24128);
	    float _20215 = lerp(_20214, 1.0f, _17133.w);
	    float4 _15027 = float4(lerp(float4(lerp(0.0f.xxx, _16305.xyz, _24128.xxx), _20214).xyz, _17133.xyz, _17133.w.xxx), _20215);
	    float3 _8218 = _15027.xyz + (_13136 * (1.0f - _20215));
	    float4 _20488 = _15027;
	    _20488.x = _8218.x;
	    _20488.y = _8218.y;
	    _20488.z = _8218.z;
	    output_0 = _20488;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
