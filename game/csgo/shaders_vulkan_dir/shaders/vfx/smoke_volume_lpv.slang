//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Smoke Volume LPV";
	DevShader = true;
	Version = 1;
	
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
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	RWTexture3D<float4> g_SmokeVolumeLPV < Attribute("SmokeVolumeLPV"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 4372 (name: LightProbeVolumeData_t), member index 1 (name: _m1) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
	
	struct _1570
	{
	    vec4 _m0[16];
	};
	
	struct _1430
	{
	    vec4 _m0;
	    vec4 _m1;
	    mat4x3 _m2;
	    int _m3;
	    uint _m4;
	};
	
	struct _1439
	{
	    _1430 _m0[64];
	};
	
	struct _1556
	{
	    mat4x3 _m0;
	    vec3 _m1;
	    vec3 _m2;
	    vec4 _m3;
	    vec3 _m4;
	    vec3 _m5;
	};
	
	struct _1329
	{
	    _1556 _m0[400];
	};
	
	struct _200
	{
	    mat4 _m0;
	    mat4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec3 _m6;
	    uint _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    mat4x3 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    mat4 _m23;
	};
	
	vec4 _3;
	
	struct _1088
	{
	    _1570 _m0;
	};
	
	layout(set = 0) uniform _1088 SmokeConstantBuffer_t;
	
	struct _2287
	{
	    uvec4 _m0;
	    _1439 _m1;
	};
	
	layout(set = 0) uniform _2287 LightProbeVolumeData_t;
	
	struct _606
	{
	    _1329 _m0;
	};
	
	layout(set = 0) uniform _606 PerViewLightProbeVolumeConstantBuffer_t;
	
	struct _1007
	{
	    vec3 _m0;
	};
	
	layout(set = 0) uniform _1007 PerViewConstantBuffer_t;
	
	struct _1454
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    float _m5;
	    uint _m6;
	};
	
	layout(set = 3) uniform _1454 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	struct _1011
	{
	    ivec4 _m0;
	};
	
	layout(set = 0) uniform _1011 PerViewConstantBufferCsgo_t;
	
	layout(set = 0, binding = 42) uniform texture3D g_tLPV_Irradiance;
	layout(set = 0, binding = 16) uniform sampler g_sBilinearClamp;
	layout(set = 0, binding = 17) uniform sampler g_sTrilinearWrap;
	layout(set = 0, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 0, binding = 23) uniform sampler g_sCookieSampler;
	layout(set = 0, binding = 24) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 0, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 0, binding = 46) uniform texture3D g_tLPV_Shadows;
	layout(set = 0, binding = 158) uniform writeonly image3D g_SmokeVolumeLPV;
	
	void main()
	{
	    uint _18909 = clamp(gl_GlobalInvocationID.z, 0u, 16u);
	    uvec2 _14205 = uvec2(uint((34.0 * float(uint(clamp(SmokeConstantBuffer_t._m0._m0[_18909].w, 0.0, 16.0)))) + float(gl_GlobalInvocationID.x)), gl_GlobalInvocationID.y);
	    int _4300;
	    int _13039 = 0;
	    SPIRV_CROSS_LOOP
	    for (;;)
	    {
	        if (!(_13039 < 32))
	        {
	            break;
	        }
	        vec3 _18075 = (((vec3(uvec3(gl_GlobalInvocationID.xy, uint(_13039))) - vec3(16.0)) * 20.0) + vec3(10.0)) + SmokeConstantBuffer_t._m0._m0[int(_18909)].xyz;
	        vec4 _21339 = vec4(_18075 - vec3(10.0), 0.0);
	        vec4 _23211 = (_21339 + vec4(_18075 + vec3(10.0), 0.0)) * 0.5;
	        float _8285 = length(_23211 - _21339);
	        int _18141 = int(LightProbeVolumeData_t._m0[_18909]);
	        int _17133;
	        _17133 = -1;
	        int _8896;
	        float _13137;
	        bool _14891;
	        int _16306;
	        int _18360;
	        float _13136 = 9999999.0;
	        int _16305 = -1;
	        int _17017 = 0;
	        bool _17114 = false;
	        for (;;)
	        {
	            bool _7956_ladder_break = false;
	            do
	            {
	                if (!(_17017 < _18141))
	                {
	                    _7956_ladder_break = true;
	                    break;
	                }
	                uint _15059 = (_18909 * 32u) + uint(_17017);
	                vec3 _7678 = LightProbeVolumeData_t._m1._m0[_15059]._m2 * vec4(_18075.xyz, 1.0);
	                vec3 _17147 = LightProbeVolumeData_t._m1._m0[_15059]._m0.xyz - _7678;
	                vec3 _7179 = _7678 - LightProbeVolumeData_t._m1._m0[_15059]._m1.xyz;
	                vec3 _11965 = vec3(max(_17147.x, 0.0), max(_17147.y, 0.0), max(_17147.z, 0.0)) + vec3(max(_7179.x, 0.0), max(_7179.y, 0.0), max(_7179.z, 0.0));
	                float _14811 = sqrt(dot(_11965, _11965));
	                bool _8325 = _14811 == 0.0;
	                float _20890 = _8325 ? length(_7678) : _14811;
	                if (_8325 == _17114)
	                {
	                    bool _12885;
	                    if (_8325)
	                    {
	                        _12885 = LightProbeVolumeData_t._m1._m0[_15059]._m3 != _16305;
	                    }
	                    else
	                    {
	                        _12885 = false;
	                    }
	                    if (_12885)
	                    {
	                        if (LightProbeVolumeData_t._m1._m0[_15059]._m3 < _16305)
	                        {
	                            _13137 = _13136;
	                            _16306 = _16305;
	                            _14891 = _17114;
	                            _18360 = _17133;
	                            break;
	                        }
	                    }
	                    else
	                    {
	                        if (_20890 > _13136)
	                        {
	                            _13137 = _13136;
	                            _16306 = _16305;
	                            _14891 = _17114;
	                            _18360 = _17133;
	                            break;
	                        }
	                    }
	                    if (!_8325)
	                    {
	                        vec3 _21857 = LightProbeVolumeData_t._m1._m0[_15059]._m2 * vec4(_23211.xyz, 1.0);
	                        vec3 _15862 = LightProbeVolumeData_t._m1._m0[_15059]._m0.xyz - _21857;
	                        vec3 _7180 = _21857 - LightProbeVolumeData_t._m1._m0[_15059]._m1.xyz;
	                        vec3 _11966 = vec3(max(_15862.x, 0.0), max(_15862.y, 0.0), max(_15862.z, 0.0)) + vec3(max(_7180.x, 0.0), max(_7180.y, 0.0), max(_7180.z, 0.0));
	                        if (_8285 < sqrt(dot(_11966, _11966)))
	                        {
	                            _13137 = _13136;
	                            _16306 = _16305;
	                            _14891 = _17114;
	                            _18360 = _17133;
	                            break;
	                        }
	                    }
	                }
	                else
	                {
	                    if (!_8325)
	                    {
	                        _13137 = _13136;
	                        _16306 = _16305;
	                        _14891 = _17114;
	                        _18360 = _17133;
	                        break;
	                    }
	                }
	                _13137 = _20890;
	                _16306 = LightProbeVolumeData_t._m1._m0[_15059]._m3;
	                _14891 = _8325;
	                _18360 = int(LightProbeVolumeData_t._m1._m0[_15059]._m4);
	                break;
	            } while(false);
	            if (_7956_ladder_break)
	            {
	                break;
	            }
	            _8896 = _17017 + 1;
	            _13136 = _13137;
	            _16305 = _16306;
	            _17114 = _14891;
	            _17133 = _18360;
	            _17017 = _8896;
	            continue;
	        }
	        vec3 _9087 = normalize(_18075 - SmokeConstantBuffer_t._m0._m0[_18909].xyz);
	        uint _21017 = uint(max(0, _17133));
	        vec3 _24893 = PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m0 * vec4(_18075.xyz, 1.0);
	        vec3 _6343 = _24893.xyz;
	        vec3 _6393 = _6343;
	        _6393.z = _24893.z * 0.16666667163372039794921875;
	        vec3 _19423 = clamp(_6393.xyz, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m1, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m2);
	        _19423.z = _19423.z * 6.0;
	        vec3 _23126 = (_19423.xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m4).xyz + PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m5;
	        _23126.z = _23126.z * 0.16666667163372039794921875;
	        vec3 _17330 = _9087.xyz;
	        vec3 _16057 = mix(vec3(0.0, 0.16666667163372039794921875, 0.3333333432674407958984375), vec3(0.5, 0.666666686534881591796875, 0.833333313465118408203125), step(_17330, vec3(0.0)).xyz);
	        vec3 _16868 = _17330 * _17330;
	        vec3 _13062 = (((textureLod(sampler3D(g_tLPV_Irradiance, g_sBilinearClamp), _23126.xyz + vec3(0.0, 0.0, _16057.x), 0.0).xyz * _16868.x) + (textureLod(sampler3D(g_tLPV_Irradiance, g_sBilinearClamp), _23126.xyz + vec3(0.0, 0.0, _16057.y), 0.0).xyz * _16868.y)) + (textureLod(sampler3D(g_tLPV_Irradiance, g_sBilinearClamp), _23126.xyz + vec3(0.0, 0.0, _16057.z), 0.0).xyz * _16868.z)).xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m3.xyz;
	        vec4 _23714;
	        _23714.x = _13062.x;
	        _23714.y = _13062.y;
	        _23714.z = _13062.z;
	        vec3 _18003 = _18075 - PerViewConstantBuffer_t._m0;
	        vec3 _13155;
	        _13155 = vec3(0.0);
	        uint _4283;
	        vec3 _5974;
	        uint _16208 = 0u;
	        for (;;)
	        {
	            if (!(_16208 < PerViewLightingConstantBufferGpu_t._m6))
	            {
	                break;
	            }
	            int _14247 = int(_16208);
	            vec3 _20617;
	            do
	            {
	                vec3 _14644 = _18003.xyz;
	                vec4 _24894 = g_BarnLights_1._m0[_14247]._m0 * vec4(_18003.xyz, 1.0);
	                vec3 _10521 = _24894.xyz / vec3(_24894.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7424 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7424 = false;
	                }
	                bool _12886;
	                if (!_7424)
	                {
	                    _12886 = true;
	                }
	                else
	                {
	                    _12886 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_14247]._m15 * vec4(_14644, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12886)
	                {
	                    _20617 = vec3(0.0);
	                    break;
	                }
	                float _23570 = 2.0 * g_BarnLights_1._m0[_14247]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_14247]._m5.z) * g_BarnLights_1._m0[_14247]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_14247]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_14247]._m5.y;
	                float _17331 = 2.0 * g_BarnLights_1._m0[_14247]._m5.w;
	                float _19825 = _17331 * g_BarnLights_1._m0[_14247]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_14247]._m5.x)) - _18492, (_23570 * g_BarnLights_1._m0[_14247]._m5.z) + (_17331 * g_BarnLights_1._m0[_14247]._m5.x)) * g_BarnLights_1._m0[_14247]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_14247]._m3.z > 0.0)
	                {
	                    _21316 = smoothstep(0.0, 1.0, _21775 * g_BarnLights_1._m0[_14247]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_14247]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21775) * g_BarnLights_1._m0[_14247]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_14247]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_14247]._m2.xyz - _14644;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _20958 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _20958;
	                        float _25105 = dot(-_20958, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _20958;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _20958 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_14247]._m2.w / max(_18345, g_BarnLights_1._m0[_14247]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_14247]._m3.x + (g_BarnLights_1._m0[_14247]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_14247]._m6.x + (g_BarnLights_1._m0[_14247]._m6.y * dot(vec3((1.0 - (_23570 * g_BarnLights_1._m0[_14247]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_14247]._m5.z) - (_17331 * g_BarnLights_1._m0[_14247]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11179 = g_BarnLights_1._m0[_14247]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_14247]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_14247]._m8.z > 0.0)
	                {
	                    _24419 = !notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).x;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                vec3 _21548;
	                SPIRV_CROSS_BRANCH
	                if (g_BarnLights_1._m0[_14247]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights_1._m0[_14247]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_14247]._m9.x, _22154.x) * smoothstep(1.0, g_BarnLights_1._m0[_14247]._m9.y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_14247]._m9.z;
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_14247]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_14247]._m9.x * g_BarnLights_1._m0[_14247]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_14247]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_14247]._m9.x * _15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0);
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _21548 = _17828.xyz * _10342;
	                }
	                else
	                {
	                    vec3 _12501;
	                    if (g_BarnLights_1._m0[_14247]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_14247]._m5.xyz, g_BarnLights_1._m0[_14247]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23593 = _17795.xyz;
	                        vec3 _12172 = ((_20479 * g_BarnLights_1._m0[_14247]._m5.w) + (_23593 * _15156)) + cross(_23593, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12172.y, -_12172.x) * 0.15915493667125701904296875, acos(_12172.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_14247]._m4.w);
	                        vec2 _20562 = (_14081.xy * g_BarnLights_1._m0[_14247]._m9.zw) + g_BarnLights_1._m0[_14247]._m9.xy;
	                        vec3 _20489 = _14081;
	                        _20489.x = _20562.x;
	                        _20489.y = _20562.y;
	                        _12501 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20489.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_14247]._m4.w);
	                        vec2 _20561 = (_13791.xy * g_BarnLights_1._m0[_14247]._m9.zw) + g_BarnLights_1._m0[_14247]._m9.xy;
	                        vec3 _20488 = _13791;
	                        _20488.x = _20561.x;
	                        _20488.y = _20561.y;
	                        _12501 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20488.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12501;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _20617 = vec3(0.0);
	                    break;
	                }
	                vec3 _19630;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_14247]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23715 = _21642;
	                        _23715.x = _6281.x;
	                        _23715.y = _6281.y;
	                        _19629 = _23715;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m5);
	                        vec2 _14614 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_14247]._m8.zw, g_BarnLights_1._m0[_14247]._m8.xy), _19629.z).xy;
	                        float _15310 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0)).xyzw, vec4(0.25));
	                        bool _12887;
	                        if (_15310 == 0.0)
	                        {
	                            _12887 = true;
	                        }
	                        else
	                        {
	                            _12887 = _15310 == 1.0;
	                        }
	                        if (_12887)
	                        {
	                            _24972 = _15310;
	                            break;
	                        }
	                        _24972 = ((_15310 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14614 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14614, _11455), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_14247]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _20617 = vec3(0.0);
	                        break;
	                    }
	                    _19630 = _19878;
	                }
	                else
	                {
	                    _19630 = _21548;
	                }
	                _20617 = vec3(max(0.0, dot(_9087.xyz, _11179.xyz))).xyz * _19630.xyz;
	                break;
	            } while(false);
	            _5974 = _13155 + (_20617.xyz * mix(1.0, 0.100000001490116119384765625, saturate((sqrt(dot(g_BarnLights_1._m0[_16208]._m4.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * g_BarnLights_1._m0[_16208]._m2.w) - 80.0) * 0.00999999977648258209228515625))).xyz;
	            _4283 = _16208 + 1u;
	            _13155 = _5974;
	            _16208 = _4283;
	            continue;
	        }
	        imageStore(g_SmokeVolumeLPV, ivec3(uvec3(ivec3(ivec2(_14205), _13039))), vec4(_23714.xyz + _13155, 1.0 - dot(textureLod(sampler3D(g_tLPV_Shadows, g_sBilinearClamp), ((saturate(_6343).xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m4).xyz + PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_21017]._m5).xyz, 0.0).xyzw, PerViewLightingConstantBufferGpu_t._m4)));
	        _4300 = _13039 + 1;
	        _13039 = _4300;
	        continue;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
