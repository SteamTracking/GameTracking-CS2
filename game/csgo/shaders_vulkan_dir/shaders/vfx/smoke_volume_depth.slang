//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Smoke Volume Depth";
	DevShader = true;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Depth();
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
	float4 vPositionPs          : POSITION0  < Semantic( position ); >;                           
	float4 vCameraToEyeRayWs    : TEXCOORD0  < Semantic( CameraToEyeWs ); >;                      
	float4 vCameraToNearPlaneWs : TEXCOORD1  < Semantic( CameraToNearPlaneRayWs ); >;             
};

VS
{
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float3 vCameraToNearPlaneWs;
	static float3 vCameraToEyeRayWs;
	static float3 output_0;
	static float3 output_1;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : POSITION0;
	    float3 vCameraToEyeRayWs : TEXCOORD0;
	    float3 vCameraToNearPlaneWs : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14437 = float4(vPositionPs, 0.0f, 1.0f);
	    _14437.y = -vPositionPs.y;
	    gl_Position = _14437;
	    output_0 = vCameraToNearPlaneWs;
	    output_1 = normalize(vCameraToEyeRayWs);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vCameraToNearPlaneWs = stage_input.vCameraToNearPlaneWs;
	    vCameraToEyeRayWs = stage_input.vCameraToEyeRayWs;
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
	DynamicCombo( D_SMOKE_NEW_VISUALS, 0..1 );
	
	bool g_bAnimateEdge < Attribute("bAnimateEdge"); UiType(CheckBox); >;
	float g_flDepthBias < Attribute("flDepthBias"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture3D g_tSmokeNoiseTex < Channel(ARGB, None(TextureNoise), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeTexA_Atlas < Attribute("SmokeVolumeTexA_Atlas"); SrgbRead(false); >;
	
	// Noise
	CreateInputTexture2D(TextureNoise, Srgb, 8, "", "_z0000", "Noise", Default4(1, 1, 1, 1));
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1528
	{
	    float4 _m0[16];
	};
	
	struct _1654
	{
	    float4 _m0[5];
	};
	
	struct _1780
	{
	    float4 _m0[2];
	};
	
	static float _4;
	
	cbuffer SmokeConstantBuffer_t : register(b4, space1)
	{
	    _1528 SmokeConstantBuffer_t_1_m0 : packoffset(c0);
	    _1528 SmokeConstantBuffer_t_1_m1 : packoffset(c16);
	    _1528 SmokeConstantBuffer_t_1_m2 : packoffset(c32);
	    _1528 SmokeConstantBuffer_t_1_m3 : packoffset(c48);
	    float4 SmokeConstantBuffer_t_1_m4 : packoffset(c98);
	    _1654 SmokeConstantBuffer_t_1_m5 : packoffset(c147);
	    _1780 SmokeConstantBuffer_t_1_m6 : packoffset(c152);
	    float SmokeConstantBuffer_t_1_m7 : packoffset(c155.z);
	    uint SmokeConstantBuffer_t_1_m8 : packoffset(c155.w);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float PerViewConstantBuffer_t_1_m1 : packoffset(c18.w);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c24);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    int _Globals_1_g_bAnimateEdge : packoffset(c0);
	    float _Globals_1_g_flDepthBias : packoffset(c0.y);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    int2 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c11);
	};
	
	Texture3D<float4> g_tSmokeVolumeTexA_Atlas : register(t43, space1);
	SamplerState g_sTrilinearClamp : register(s19, space1);
	Texture2D<float4> g_tBlueNoise : register(t30, space1);
	
	static float4 gl_FragCoord;
	static float gl_FragDepth;
	static float3 input_0;
	static float3 input_1;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float gl_FragDepth : SV_Depth;
	};
	
	void MainPs_inner()
	{
	    uint _21547 = uint(SmokeConstantBuffer_t_1_m0._m0[0].w);
	    float3 _17114;
	    _17114 = 0.0f.xxx;
	    uint _4743;
	    uint _11056;
	    float _13142;
	    float _13143;
	    float3 _14880;
	    float3 _14891;
	    float _16306;
	    uint _18360;
	    float _13136 = 0.0f;
	    float _16305 = 0.0f;
	    uint _17017 = 0u;
	    uint _17133 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < _21547))
	        {
	            _13143 = _13136;
	            _14880 = _17114;
	            _11056 = _17133;
	            break;
	        }
	        float3 _23296 = 1.0f.xxx / input_1;
	        float3 _8251 = _23296 * (SmokeConstantBuffer_t_1_m0._m0[_17017].xyz - input_0);
	        float3 _6243 = _23296 * (SmokeConstantBuffer_t_1_m1._m0[_17017].xyz - input_0);
	        float3 _7415 = min(_6243, _8251);
	        float3 _13037 = max(_6243, _8251);
	        float2 _11253 = max(_7415.xx, _7415.yz);
	        float _12676 = max(_11253.x, _11253.y);
	        float2 _16933 = min(_13037.xx, _13037.yz);
	        float _15132 = min(_16933.x, _16933.y);
	        if (!(_12676 > _15132))
	        {
	            float _14952 = max(0.0f, _12676);
	            float3 _12822 = (input_0 + (input_1 * _14952)) - SmokeConstantBuffer_t_1_m2._m0[_17017].xyz;
	            bool _3259 = SmokeConstantBuffer_t_1_m3._m0[_17017].x > 1.0f;
	            float3 _11967;
	            if (!_3259)
	            {
	                _11967 = _12822 * lerp(2.0f, 1.0f, saturate(SmokeConstantBuffer_t_1_m3._m0[_17017].z * 2.0f));
	            }
	            else
	            {
	                _11967 = _12822;
	            }
	            float3 _20183 = clamp((_11967 + 320.0f.xxx) * 0.0500000007450580596923828125f.xxx, 0.0f.xxx, 31.0f.xxx);
	            uint _14719 = uint(SmokeConstantBuffer_t_1_m2._m0[_17017].w);
	            float3 _13139;
	            float _23381;
	            do
	            {
	                int3 _12244 = int3(sign(input_1));
	                bool3 _16640 = bool3(input_1.x == 0.0f.xxx.x, input_1.y == 0.0f.xxx.y, input_1.z == 0.0f.xxx.z);
	                float3 _19587 = input_1 + float3(_16640.x ? 9.9999997473787516355514526367188e-06f.xxx.x : 0.0f.xxx.x, _16640.y ? 9.9999997473787516355514526367188e-06f.xxx.y : 0.0f.xxx.y, _16640.z ? 9.9999997473787516355514526367188e-06f.xxx.z : 0.0f.xxx.z);
	                float3 _11212 = abs(1.0f.xxx / _19587);
	                float3 _13137;
	                float3 _16324;
	                _13137 = (((float3(bool3(_12244.x > int3(0, 0, 0).x, _12244.y > int3(0, 0, 0).y, _12244.z > int3(0, 0, 0).z)) - frac(_20183)) * float3(_12244)) + (float3(bool3(_12244.x == int3(0, 0, 0).x, _12244.y == int3(0, 0, 0).y, _12244.z == int3(0, 0, 0).z)) * (_15132 - _14952))) * _11212;
	                _16324 = _20183;
	                uint _14723;
	                float3 _23259;
	                float3 _24030;
	                float _16343;
	                bool _16863;
	                uint _17018 = 0u;
	                for (;;)
	                {
	                    if (!(_17018 < 32u))
	                    {
	                        _13139 = _20183;
	                        _16343 = _16305;
	                        _16863 = false;
	                        break;
	                    }
	                    float3 _20391 = _16324 * 0.03125f.xxx;
	                    float3 _23497 = clamp(_20391, 0.0f.xxx, 1.0f.xxx);
	                    if (any(bool3(_23497.x != _20391.x, _23497.y != _20391.y, _23497.z != _20391.z)))
	                    {
	                        _13139 = _20183;
	                        _16343 = 0.0f;
	                        _16863 = true;
	                        break;
	                    }
	                    float _23661 = 34.0f * float(_14719);
	                    _23497.x = (_23661 + (_23497.x * 32.0f)) * 0.0018450184725224971771240234375f;
	                    float4 _11487 = g_tSmokeVolumeTexA_Atlas.SampleLevel(g_sTrilinearClamp, _23497.xyz, 0.0f);
	                    float2 _20693 = SmokeConstantBuffer_t_1_m3._m0[_17017].y.xx;
	                    float2 _7714 = lerp(_11487.xz, _11487.yw, _20693);
	                    float _16428 = max(_7714.x, _7714.y);
	                    if (_16428 > 0.100000001490116119384765625f)
	                    {
	                        float _13138;
	                        float3 _16325;
	                        _13138 = _16428;
	                        _16325 = _16324;
	                        float _9828;
	                        int _14722;
	                        float3 _18040;
	                        int _17019 = 0;
	                        for (;;)
	                        {
	                            if (!(_17019 < 4))
	                            {
	                                break;
	                            }
	                            _18040 = _16325 + (_19587 * 0.800000011920928955078125f);
	                            float3 _15154 = _18040 * 0.03125f.xxx;
	                            float3 _8236 = clamp(_15154, 0.0f.xxx, 1.0f.xxx);
	                            if (any(bool3(_8236.x != _15154.x, _8236.y != _15154.y, _8236.z != _15154.z)))
	                            {
	                                break;
	                            }
	                            _8236.x = (_23661 + (_8236.x * 32.0f)) * 0.0018450184725224971771240234375f;
	                            float4 _11488 = g_tSmokeVolumeTexA_Atlas.SampleLevel(g_sTrilinearClamp, _8236.xyz, 0.0f);
	                            float2 _6350 = lerp(_11488.xz, _11488.yw, _20693);
	                            float3 _14830 = _18040 + ((float3(0.300000011920928955078125f, -0.4000000059604644775390625f, -0.5f) * PerViewConstantBuffer_t_1_m1) * 1.440000057220458984375f);
	                            _9828 = _13138 + ((max(_6350.x, _6350.y) * 2.0f) * saturate(abs(((sin(_14830.x * 1.2200000286102294921875f) * 0.88999998569488525390625f) + (sin(_14830.y * 1.16999995708465576171875f) * 0.430000007152557373046875f)) + (sin(_14830.z * 3.0f) * 0.20000000298023223876953125f))));
	                            _14722 = _17019 + 1;
	                            _13138 = _9828;
	                            _16325 = _18040;
	                            _17019 = _14722;
	                            continue;
	                        }
	                        _13139 = _16324;
	                        _16343 = saturate(_13138);
	                        _16863 = true;
	                        break;
	                    }
	                    float3 _19165 = min(_13137.yzx, _13137.zxy);
	                    float3 _16849 = float3(bool3(_13137.x <= _19165.x, _13137.y <= _19165.y, _13137.z <= _19165.z));
	                    float3 _16703 = _16849 * _13137;
	                    _24030 = _20183 + (_19587 * ((_16703.x + _16703.y) + _16703.z));
	                    _23259 = _13137 + (_16849 * _11212);
	                    _14723 = _17018 + 2u;
	                    _13137 = _23259;
	                    _16324 = _24030;
	                    _17018 = _14723;
	                    continue;
	                }
	                if (_16863)
	                {
	                    _23381 = _16343;
	                    break;
	                }
	                _23381 = 0.0f;
	                break;
	            } while(false);
	            float3 _13141;
	            uint _16381;
	            float _16479;
	            if (_23381 > 0.0f)
	            {
	                float _3914 = (_23381 + 0.300000011920928955078125f) * saturate(SmokeConstantBuffer_t_1_m3._m0[_17017].z + (_3259 ? 0.5f : 0.0f));
	                uint _10837;
	                float3 _16210;
	                if (_17133 == 0u)
	                {
	                    float3 _13818 = (((_13139 * 20.0f) - 320.0f.xxx) + SmokeConstantBuffer_t_1_m2._m0[int(_17017)].xyz) + ((-input_1) * 5.0f);
	                    float3 _12683;
	                    if (dot(input_1, normalize(_13818 - PerViewConstantBuffer_t_1_m3)) < 0.0f)
	                    {
	                        _12683 = input_0 + (input_1 * 5.0f);
	                    }
	                    else
	                    {
	                        _12683 = _13818;
	                    }
	                    _10837 = _17133 | (1u << (_17017 * 2u));
	                    _16210 = _12683;
	                }
	                else
	                {
	                    _10837 = _17133;
	                    _16210 = _17114;
	                }
	                int _19776 = int(_17017);
	                float _9716;
	                float3 _24878;
	                if (SmokeConstantBuffer_t_1_m8 > 0u)
	                {
	                    float3 _13140;
	                    float _16326;
	                    _13140 = _16210;
	                    _16326 = 1.0f;
	                    uint _8896;
	                    float _10913;
	                    float3 _17551;
	                    uint _17020 = 0u;
	                    for (;;)
	                    {
	                        bool _7956_ladder_break = false;
	                        do
	                        {
	                            if (!(_17020 < SmokeConstantBuffer_t_1_m8))
	                            {
	                                _7956_ladder_break = true;
	                                break;
	                            }
	                            if ((uint(SmokeConstantBuffer_t_1_m6._m0[_17020 / 4u][_17020 % 4u]) & (1u << uint(SmokeConstantBuffer_t_1_m3._m0[_19776].w))) == 0u)
	                            {
	                                _10913 = _16326;
	                                _17551 = _13140;
	                                break;
	                            }
	                            float _10810 = SmokeConstantBuffer_t_1_m7 - SmokeConstantBuffer_t_1_m5._m0[_17020].w;
	                            float _13213;
	                            float3 _15671;
	                            if (_10810 < (SmokeConstantBuffer_t_1_m3._m0[_19776].x - 0.4000000059604644775390625f))
	                            {
	                                float _13668 = distance(_13140, SmokeConstantBuffer_t_1_m5._m0[_17020].xyz);
	                                float _13212;
	                                float3 _15670;
	                                if (_13668 < 250.0f)
	                                {
	                                    float _16611 = pow(1.0f - smoothstep(0.0f, 2.0f, _10810), 128.0f);
	                                    _13212 = min(_16326, max(smoothstep(200.0f, 240.0f, _13668 + (_16611 * 250.0f)) + pow(smoothstep(0.5f, 5.0f, _10810), 1.7999999523162841796875f), 0.0f));
	                                    _15670 = lerp(_13140, SmokeConstantBuffer_t_1_m5._m0[_17020].xyz, (((1.0f - smoothstep(100.0f, 250.0f, _13668)) * step(_10810 * 1250.0f, _13668)) * (1.0f - _16611)).xxx);
	                                }
	                                else
	                                {
	                                    _13212 = _16326;
	                                    _15670 = _13140;
	                                }
	                                _13213 = _13212;
	                                _15671 = _15670;
	                            }
	                            else
	                            {
	                                _13213 = _16326;
	                                _15671 = _13140;
	                            }
	                            _10913 = _13213;
	                            _17551 = _15671;
	                            break;
	                        } while(false);
	                        if (_7956_ladder_break)
	                        {
	                            break;
	                        }
	                        _8896 = _17020 + 1u;
	                        _13140 = _17551;
	                        _16326 = _10913;
	                        _17020 = _8896;
	                        continue;
	                    }
	                    _9716 = lerp(_3914 * 0.0199999995529651641845703125f, _3914, _16326);
	                    _24878 = _13140;
	                }
	                else
	                {
	                    _9716 = _3914;
	                    _24878 = _16210;
	                }
	                float _11659;
	                [branch]
	                if (SmokeConstantBuffer_t_1_m4.w > 0.0f)
	                {
	                    float _12501;
	                    if (SmokeConstantBuffer_t_1_m4.w < SmokeConstantBuffer_t_1_m3._m0[_19776].x)
	                    {
	                        float _24666 = SmokeConstantBuffer_t_1_m4.w * 3000.0f;
	                        float _19000 = distance(_24878, SmokeConstantBuffer_t_1_m4.xyz);
	                        _12501 = lerp(_9716 * 0.0199999995529651641845703125f, _9716, max(1.0f - (smoothstep(_24666, _24666 - 50.0f, _19000) * smoothstep(_24666 - 20000.0f, _24666 - 4000.0f, _19000)), saturate((48.0f - distance(_16210, input_0 + (input_1 * _15132))) * 0.02083333395421504974365234375f)));
	                    }
	                    else
	                    {
	                        _12501 = _9716;
	                    }
	                    _11659 = _12501;
	                }
	                else
	                {
	                    _11659 = _9716;
	                }
	                float _5523 = _13136 + lerp(_11659, saturate((_11659 - 0.699999988079071044921875f) * 10.0f), SmokeConstantBuffer_t_1_m3._m0[_17017].z);
	                if (_5523 > 1.0f)
	                {
	                    _13143 = saturate(_5523);
	                    _14880 = _16210;
	                    _11056 = _10837;
	                    break;
	                }
	                _13141 = _16210;
	                _16381 = _10837;
	                _16479 = _5523;
	            }
	            else
	            {
	                _13141 = _17114;
	                _16381 = _17133;
	                _16479 = _13136;
	            }
	            _13142 = _16479;
	            _16306 = _23381;
	            _14891 = _13141;
	            _18360 = _16381;
	        }
	        else
	        {
	            _13142 = _13136;
	            _16306 = _16305;
	            _14891 = _17114;
	            _18360 = _17133;
	        }
	        _4743 = _17017 + 1u;
	        _13136 = _13142;
	        _16305 = _16306;
	        _17114 = _14891;
	        _17133 = _18360;
	        _17017 = _4743;
	        continue;
	    }
	    if (_11056 == 0u)
	    {
	        discard;
	    }
	    float4 _18275 = mul(PerViewConstantBuffer_t_1_m0, (float4((_14880 + (-4.0f).xxx).xyz, 1.0f) + (PerViewConstantBuffer_t_1_m2 * 1.0f)).xyzw);
	    if ((mad(_13143, 2.0f, -1.5f) + frac(g_tBlueNoise.Load(int3(int3(int2(gl_FragCoord.xy) & PerViewConstantBufferCsgo_t_1_m0, 0).xy, 0)).y + ((PerViewConstantBuffer_t_1_m1 * 0.61803400516510009765625f) * float(_Globals_1_g_bAnimateEdge != 0)))) < 0.0f)
	    {
	        discard;
	    }
	    gl_FragDepth = (_18275.z / _18275.w) + (_Globals_1_g_flDepthBias * 0.100000001490116119384765625f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.gl_FragDepth = gl_FragDepth;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
