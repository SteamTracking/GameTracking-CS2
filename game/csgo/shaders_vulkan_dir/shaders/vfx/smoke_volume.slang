//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Smoke Volume";
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
	static float3 output_0;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14817 = float4(vPositionPs, 0.0f, 1.0f);
	    float4 _14015 = mul(PerViewConstantBuffer_t_1_m0, float4((vTexCoord.x * 2.0f) - 1.0f, ((1.0f - vTexCoord.y) * 2.0f) - 1.0f, 1.0f, 1.0f));
	    _14817.y = -vPositionPs.y;
	    gl_Position = _14817;
	    output_0 = normalize((_14015.xyz / _14015.w.xxx) - PerViewConstantBuffer_t_1_m1);
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
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_OPTIM, 0..1 );
	DynamicCombo( D_SMOKE_INSTANCES, 1..6 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicCombo( D_SMOKE_QUALITY, 0..1 );
	DynamicCombo( D_SMOKE_USE_NOISE_TEXTURE, 0..1 );
	DynamicCombo( D_SMOKE_NEW_VISUALS, 0..1 );
	DynamicCombo( D_SMOKE_PERF_TEST, 0..1 );
	DynamicCombo( D_SMOKE_FULLRES, 0..1 );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_OPTIM, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_QUALITY, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_USE_NOISE_TEXTURE, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_NEW_VISUALS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_PERF_TEST, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_SMOKE_FULLRES, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	RenderState(StencilRef, 128);
	int g_MixedResolutionScale < Attribute("MIXED_RESOLUTION_SCALE"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tDepthNoCharacters < Attribute("DepthNoCharacters"); SrgbRead(false); >;
	Texture2D g_tDepthTexture < Attribute("SceneDepth"); SrgbRead(false); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tMaskTexture < Attribute("SmokeMask"); SrgbRead(false); >;
	Texture2D g_tMboitOptimColorTexture < Attribute("SmokeOptimColorTex"); SrgbRead(true); >;
	Texture2D g_tMboitOptimDepthTexture < Attribute("SmokeOptimDepthTex"); SrgbRead(true); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture3D g_tSmokeNoiseTex < Channel(RG, None(TextureNoise), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeLPV_Atlas < Attribute("SmokeVolumeLPV_Atlas"); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeTexA_Atlas < Attribute("SmokeVolumeTexA_Atlas"); SrgbRead(false); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	
	// Noise
	CreateInputTexture2D(TextureNoise, Srgb, 8, "", "_z0000", "Noise", Default4(1, 1, 1, 1));
	
	// Settings
	bool g_bExtraSample < Default(1); UiType(CheckBox); UiGroup("Settings"); >;
	float g_flAOEffectDistance < Default(20); Range(0, 100); UiType(Slider); UiGroup("Settings"); >;
	float g_flAOEffectStrength < Default(0.07); Range(0, 0.2); UiType(Slider); UiGroup("Settings"); >;
	float g_flAmbientStrength < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flBoilStrength < Default(1); Range(-1, 1); UiType(Slider); UiGroup("Settings"); >;
	float g_flCSMDepthBiasX10 < Default(-0.04); Range(-0.1, 0.1); UiType(Slider); UiGroup("Settings"); >;
	float g_flDensity < Default(1); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flDirectStrength < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flInteriorDarkening < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseMax < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseMin < Range(-8, 8); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseNormalStrength < Default(0.5); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseNormalStrengthDirect < Default(1); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseOffset < Default(0.1); Range(-4, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoisePower < Default(1); Range(0.01, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseScaleHigh < Default(8); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseScaleLow < Default(2.3); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseSpeed < Default(1); Range(0, 10); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseStrengthHigh < Default(0.25); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flNoiseStrengthLow < Default(0.5); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flRayStepLength < Default(4); Range(0.1, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flRimLightStrength < Default(0.25); Range(0, 4); UiType(Slider); UiGroup("Settings"); >;
	float g_flSmokeNoiseStrength < Default(1); Range(0, 20); UiType(Slider); UiGroup("Settings"); >;
	float g_flVolumeNormalBlend < Default(0.35); UiType(Slider); UiGroup("Settings"); >;
	float g_flWispy < UiType(Slider); UiGroup("Settings"); >;
	int g_nShadowInterpolateRaySteps < Default(4); Range(1, 12); UiType(Slider); UiGroup("Settings"); >;
	int g_nShadowQuality < Range4(0, 0, 0, 0, 4, 4, 4, 4); UiOptions("0=1,1=8,2=12,3=25,4=Interpolate Ray"); UiType(Enum); UiGroup("Settings"); >;
	float3 g_vSmokeColor < Default3(1, 1, 1); UiType(Color); UiGroup("Settings"); Expression(SrgbGammaToLinear(this)); >;
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1017
	{
	    float4 _m0;
	};
	
	struct _2284
	{
	    float4 _m0[16];
	};
	
	struct _2410
	{
	    float4 _m0[5];
	};
	
	struct _2536
	{
	    float4 _m0[2];
	};
	
	static float4 _3;
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float4 PerViewConstantBuffer_t_1_m0 : packoffset(c16);
	    float PerViewConstantBuffer_t_1_m1 : packoffset(c23);
	    float PerViewConstantBuffer_t_1_m2 : packoffset(c23.y);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	    float3 PerViewConstantBuffer_t_1_m4 : packoffset(c28);
	};
	
	cbuffer SmokeConstantBuffer_t : register(b4, space1)
	{
	    _2284 SmokeConstantBuffer_t_1_m0 : packoffset(c0);
	    _2284 SmokeConstantBuffer_t_1_m1 : packoffset(c16);
	    _2284 SmokeConstantBuffer_t_1_m2 : packoffset(c32);
	    _2284 SmokeConstantBuffer_t_1_m3 : packoffset(c48);
	    _2284 SmokeConstantBuffer_t_1_m4 : packoffset(c64);
	    _2284 SmokeConstantBuffer_t_1_m5 : packoffset(c80);
	    float4 SmokeConstantBuffer_t_1_m6 : packoffset(c96);
	    float4 SmokeConstantBuffer_t_1_m7 : packoffset(c97);
	    float4 SmokeConstantBuffer_t_1_m8 : packoffset(c98);
	    _2284 SmokeConstantBuffer_t_1_m9 : packoffset(c99);
	    _2284 SmokeConstantBuffer_t_1_m10 : packoffset(c115);
	    _2284 SmokeConstantBuffer_t_1_m11 : packoffset(c131);
	    _2410 SmokeConstantBuffer_t_1_m12 : packoffset(c147);
	    _2536 SmokeConstantBuffer_t_1_m13 : packoffset(c152);
	    uint SmokeConstantBuffer_t_1_m14 : packoffset(c155.y);
	    float SmokeConstantBuffer_t_1_m15 : packoffset(c155.z);
	    uint SmokeConstantBuffer_t_1_m16 : packoffset(c155.w);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    int _Globals_1_g_MixedResolutionScale : packoffset(c8.y);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    float4 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c1946);
	};
	
	Texture2D<float4> g_tDepthTexture : register(t54, space1);
	Texture2D<float4> g_tDepthNoCharacters : register(t56, space1);
	Texture2D<float4> g_tMaskTexture : register(t55, space1);
	Texture3D<float4> g_tSmokeVolumeTexA_Atlas : register(t51, space1);
	SamplerState g_sTrilinearClamp : register(s18, space1);
	Texture3D<float4> g_tSmokeVolumeLPV_Atlas : register(t52, space1);
	
	static float4 gl_FragCoord;
	static float3 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _15861 = normalize(input_0);
	    float3 _23296 = 1.0f.xxx / _15861;
	    float3 _8251 = _23296 * (SmokeConstantBuffer_t_1_m6.xyz - PerViewConstantBuffer_t_1_m3);
	    float3 _6243 = _23296 * (SmokeConstantBuffer_t_1_m7.xyz - PerViewConstantBuffer_t_1_m3);
	    float3 _7415 = min(_6243, _8251);
	    float3 _13037 = max(_6243, _8251);
	    float2 _11253 = max(_7415.xx, _7415.yz);
	    float _12676 = max(_11253.x, _11253.y);
	    float2 _16933 = min(_13037.xx, _13037.yz);
	    float _15651 = min(_16933.x, _16933.y);
	    if (_12676 > _15651)
	    {
	        discard;
	    }
	    float _17986 = ((_12676 < 0.0f) ? 0.0f : _12676) + 6.0f;
	    int2 _11700 = int3(int2(gl_FragCoord.xy), 0).xy;
	    float _10955 = PerViewConstantBuffer_t_1_m2 - PerViewConstantBuffer_t_1_m1;
	    float _15694 = dot(PerViewConstantBuffer_t_1_m4.xyz, _15861);
	    float _10558 = 1.0f / (((saturate((g_tDepthTexture.Load(int3(_11700, 0)).x - PerViewConstantBuffer_t_1_m1) / _10955) * PerViewConstantBuffer_t_1_m0.z) + PerViewConstantBuffer_t_1_m0.w) * _15694);
	    bool _6681 = SmokeConstantBuffer_t_1_m16 > 0u;
	    bool _12885;
	    if (_6681)
	    {
	        _12885 = true;
	    }
	    else
	    {
	        _12885 = SmokeConstantBuffer_t_1_m8.w > 0.0f;
	    }
	    bool _12666;
	    [branch]
	    if (_12885)
	    {
	        _12666 = ((1.0f / (((saturate((g_tDepthNoCharacters.Load(int3(int3(int2(gl_FragCoord.xy * float(_Globals_1_g_MixedResolutionScale)), 0).xy, 0)).x - PerViewConstantBuffer_t_1_m1) / _10955) * PerViewConstantBuffer_t_1_m0.z) + PerViewConstantBuffer_t_1_m0.w) * _15694)) - _10558) > 10.0f;
	    }
	    else
	    {
	        _12666 = false;
	    }
	    float _4364 = _10558 - 2.0f;
	    [branch]
	    if (_17986 > _4364)
	    {
	        discard;
	    }
	    float3 _5607 = PerViewConstantBuffer_t_1_m3 + (_15861 * _17986);
	    float3 _4987 = PerViewConstantBuffer_t_1_m3 + (_15861 * min(_15651, _4364));
	    uint _19697 = uint(g_tMaskTexture.Load(int3(_11700, 0)).x);
	    uint _4249;
	    uint _15529;
	    _1017 _5767[1];
	    uint _6386;
	    uint _22420;
	    uint _13136 = 0u;
	    uint _16324 = 0u;
	    uint _17017 = _19697;
	    for (;;)
	    {
	        if (!(_17017 != 0u))
	        {
	            _22420 = _16324;
	            break;
	        }
	        if ((_17017 & 1u) != 0u)
	        {
	            float3 _8252 = _23296 * (SmokeConstantBuffer_t_1_m0._m0[_13136].xyz - PerViewConstantBuffer_t_1_m3);
	            float3 _6244 = _23296 * (SmokeConstantBuffer_t_1_m1._m0[_13136].xyz - PerViewConstantBuffer_t_1_m3);
	            float3 _7416 = min(_6244, _8252);
	            float3 _13038 = max(_6244, _8252);
	            float2 _11254 = max(_7416.xx, _7416.yz);
	            float2 _16934 = min(_13038.xx, _13038.yz);
	            _5767[_16324]._m0.x = max(_11254.x, _11254.y);
	            _5767[_16324]._m0.y = min(_16934.x, _16934.y);
	            _5767[_16324]._m0.z = float(_13136);
	            _6386 = _16324 + 1u;
	        }
	        else
	        {
	            _6386 = _16324;
	        }
	        if (_6386 >= 1u)
	        {
	            _22420 = _6386;
	            break;
	        }
	        _4249 = _17017 >> uint(1);
	        _15529 = _13136 + 1u;
	        _13136 = _15529;
	        _16324 = _6386;
	        _17017 = _4249;
	        continue;
	    }
	    _1017 _22684[1] = _5767;
	    float4 _13174;
	    do
	    {
	        float3 _24182 = _4987 - _5607;
	        int _18242 = int(max(2.0f, length(_24182) * 0.25f));
	        float3 _14798 = _24182 / float(_18242 - 1).xxx;
	        float _24637 = length(_14798);
	        float4 _16305;
	        float3 _17115;
	        float3 _17118;
	        _16305 = 0.0f.xxxx;
	        _17115 = float3(0.0f, 0.0f, 0.00999999977648258209228515625f);
	        _17118 = _5607;
	        float _7831;
	        int _11496;
	        float3 _12783;
	        float _13150;
	        bool _16054;
	        float3 _16312;
	        bool _16863;
	        float _17123;
	        uint _17124;
	        float4 _17153;
	        bool _13137 = false;
	        int _17018 = 0;
	        float _17114 = 0.0f;
	        float _17116 = 0.0f;
	        uint _17117 = 0u;
	        float _17133 = _17986;
	        for (;;)
	        {
	            if (!(_17018 < _18242))
	            {
	                _13174 = _16305;
	                _16054 = _13137;
	                break;
	            }
	            bool _23149;
	            if (SmokeConstantBuffer_t_1_m14 != 0u)
	            {
	                bool _12501;
	                if ((_17018 & 15) == 0)
	                {
	                    _12501 = true;
	                }
	                else
	                {
	                    _12501 = _17018 < 16;
	                }
	                _23149 = _12501;
	            }
	            else
	            {
	                _23149 = false;
	            }
	            float _24117 = _23149 ? 0.0f : _17114;
	            bool3 _9204 = _23149.xxx;
	            float _17855 = _23149 ? 0.0f : _17116;
	            uint _14433 = _23149 ? 0u : _17117;
	            float4 _13138;
	            float3 _17119;
	            _13138 = _16305;
	            _17119 = float3(_9204.x ? float3(0.0f, 0.0f, 0.00999999977648258209228515625f).x : _17115.x, _9204.y ? float3(0.0f, 0.0f, 0.00999999977648258209228515625f).y : _17115.y, _9204.z ? float3(0.0f, 0.0f, 0.00999999977648258209228515625f).z : _17115.z);
	            uint _8897;
	            float4 _13149;
	            float _14891;
	            float _16311;
	            float3 _17121;
	            uint _18361;
	            float _16306 = _24117;
	            uint _17019 = 0u;
	            float _17120 = _17855;
	            uint _17134 = _14433;
	            for (;;)
	            {
	                bool _7956_ladder_break = false;
	                do
	                {
	                    if (!(_17019 < _22420))
	                    {
	                        _13150 = _16306;
	                        _16312 = _17119;
	                        _17123 = _17120;
	                        _17124 = _17134;
	                        _17153 = _13138;
	                        _16863 = _13137;
	                        _7956_ladder_break = true;
	                        break;
	                    }
	                    uint _20424 = uint(_22684[_17019]._m0.z);
	                    if (_17133 < _22684[_17019]._m0.x)
	                    {
	                        _13149 = _13138;
	                        _16311 = _16306;
	                        _17121 = _17119;
	                        _14891 = _17120;
	                        _18361 = _17134;
	                        break;
	                    }
	                    if (_17133 > _22684[_17019]._m0.y)
	                    {
	                        _13149 = _13138;
	                        _16311 = _16306;
	                        _17121 = _17119;
	                        _14891 = _17120;
	                        _18361 = _17134;
	                        break;
	                    }
	                    uint _13141;
	                    float _16308;
	                    float3 _16882;
	                    float _17152;
	                    do
	                    {
	                        bool _12886;
	                        if (SmokeConstantBuffer_t_1_m14 == 0u)
	                        {
	                            _12886 = true;
	                        }
	                        else
	                        {
	                            _12886 = (_17134 & 3u) != 0u;
	                        }
	                        if (_12886)
	                        {
	                            _13141 = _17134;
	                            _16308 = _16306;
	                            _17152 = _17120;
	                            _16882 = _17119;
	                            break;
	                        }
	                        float _13139;
	                        float3 _16307;
	                        float _17135;
	                        _13139 = _16306;
	                        _16307 = _17119;
	                        _17135 = _17120;
	                        uint _8087;
	                        float3 _13140;
	                        float _13189;
	                        float _14382;
	                        uint _17020 = 0u;
	                        for (;;)
	                        {
	                            if (!(_17020 < min(SmokeConstantBuffer_t_1_m14, 16u)))
	                            {
	                                break;
	                            }
	                            float3 _21554 = SmokeConstantBuffer_t_1_m10._m0[_17020].xyz - SmokeConstantBuffer_t_1_m9._m0[_17020].xyz;
	                            float3 _14636 = _17118 - SmokeConstantBuffer_t_1_m9._m0[_17020].xyz;
	                            float _19448 = saturate((length(_14636 - (_21554 * saturate(dot(_14636, _21554) / dot(_21554, _21554)))) * 0.0500000007450580596923828125f) * SmokeConstantBuffer_t_1_m11._m0[_17020].x);
	                            float _14626 = smoothstep(0.0f, 0.00999999977648258209228515625f, SmokeConstantBuffer_t_1_m9._m0[_17020].w) * (1.0f - smoothstep(0.00999999977648258209228515625f, 0.20000000298023223876953125f, SmokeConstantBuffer_t_1_m9._m0[_17020].w));
	                            float _6223;
	                            [branch]
	                            if (_19448 < 1.0f)
	                            {
	                                float _18731 = max(_17135, smoothstep(0.0f, 1.0f, 1.0f - saturate(SmokeConstantBuffer_t_1_m9._m0[_17020].w + saturate(_19448 + (1.0f - saturate(length(_17118 - SmokeConstantBuffer_t_1_m10._m0[_17020].xyz) * 0.00999999977648258209228515625f))))));
	                                _13140 = lerp(_16307, normalize(SmokeConstantBuffer_t_1_m9._m0[_17020].xyz - SmokeConstantBuffer_t_1_m10._m0[_17020].xyz), _18731.xxx);
	                                _13189 = _18731;
	                                _6223 = (pow(1.0f - _19448, 64.0f) * _14626) * 10.0f;
	                            }
	                            else
	                            {
	                                _13140 = _16307;
	                                _13189 = _17135;
	                                _6223 = 0.0f;
	                            }
	                            if (SmokeConstantBuffer_t_1_m10._m0[_17020].w > 0.0f)
	                            {
	                                float _10368 = (1.0f - saturate(length(_14636) * 0.00999999977648258209228515625f)) * _14626;
	                                _14382 = max(_13139, max(_10368 * _10368, _6223));
	                            }
	                            else
	                            {
	                                _14382 = _13139;
	                            }
	                            _8087 = _17020 + 1u;
	                            _13139 = _14382;
	                            _16307 = _13140;
	                            _17135 = _13189;
	                            _17020 = _8087;
	                            continue;
	                        }
	                        _13141 = _17134 | 1u;
	                        _16308 = _13139;
	                        _17152 = _17135;
	                        _16882 = _16307;
	                        break;
	                    } while(false);
	                    float4 _21317;
	                    do
	                    {
	                        float3 _25170 = _17118 + ((normalize(_16882) * pow(_17152, 3.0f)) * 20.0f);
	                        float3 _14658 = clamp((((_25170 - SmokeConstantBuffer_t_1_m2._m0[int(_20424)].xyz) * 0.0500000007450580596923828125f.xxx) + 16.0f.xxx) * 0.03125f.xxx, 0.0f.xxx, 1.0f.xxx);
	                        float3 _21495 = clamp(_14658, 0.0f.xxx, 1.0f.xxx);
	                        uint _14092 = uint(SmokeConstantBuffer_t_1_m3._m0[_20424].z);
	                        _21495.x = ((34.0f * float(_14092)) + (_21495.x * 32.0f)) * 0.0018450184725224971771240234375f;
	                        float4 _11487 = g_tSmokeVolumeTexA_Atlas.SampleLevel(g_sTrilinearClamp, _21495.xyz, 0.0f);
	                        float2 _7714 = lerp(_11487.xz, _11487.yw, SmokeConstantBuffer_t_1_m3._m0[_20424].y.xx);
	                        float _20593 = _7714.x;
	                        float _6734 = _7714.y;
	                        float4 _13144;
	                        _13144.w = _6734;
	                        float _8283 = distance(_25170, _4987);
	                        float4 _18056;
	                        if (_20593 > _6734)
	                        {
	                            float4 _11248;
	                            _11248.w = lerp(_6734, _20593, smoothstep(10.0f, 40.0f, _8283));
	                            _18056 = _11248;
	                        }
	                        else
	                        {
	                            _18056 = _13144.xyzw;
	                        }
	                        float _6665 = saturate(lerp(_18056.w, -0.0500000007450580596923828125f, _17152));
	                        [branch]
	                        if (_6665 > 0.00999999977648258209228515625f)
	                        {
	                            float4 _20413 = g_tSmokeVolumeLPV_Atlas.SampleLevel(g_sTrilinearClamp, _21495.xyz, 0.0f);
	                            float _15720 = saturate(saturate((_6665 - 0.00999999977648258209228515625f) * 1.01010096073150634765625f) * max(0.5f, saturate((abs(sin((_14658.x * 18.840000152587890625f) + (SmokeConstantBuffer_t_1_m15 * 0.699999988079071044921875f))) + abs(cos((_14658.y * 31.40000152587890625f) + (SmokeConstantBuffer_t_1_m15 * 0.5f)))) * 0.5f))) * saturate((SmokeConstantBuffer_t_1_m5._m0[_20424].x * 2.0f) - 0.5f);
	                            float _22281 = saturate(_15720 + ((1.0f - saturate(distance(PerViewConstantBuffer_t_1_m3, _25170) * 0.100000001490116119384765625f)) * _15720));
	                            float _13147;
	                            float3 _13734;
	                            float _15157;
	                            float _16310;
	                            [branch]
	                            if (_6681)
	                            {
	                                float _13142;
	                                float3 _16309;
	                                float _17136;
	                                _13142 = SmokeConstantBuffer_t_1_m15;
	                                _16309 = _25170;
	                                _17136 = 1.0f;
	                                uint _8896;
	                                float3 _13146;
	                                float _14082;
	                                float _18360;
	                                uint _17021 = 0u;
	                                for (;;)
	                                {
	                                    bool _7957_ladder_break = false;
	                                    do
	                                    {
	                                        if (!(_17021 < SmokeConstantBuffer_t_1_m16))
	                                        {
	                                            _7957_ladder_break = true;
	                                            break;
	                                        }
	                                        if ((uint(SmokeConstantBuffer_t_1_m13._m0[_17021 >> uint(2)][_17021 & 3u]) & (1u << _14092)) == 0u)
	                                        {
	                                            _13146 = _16309;
	                                            _14082 = _17136;
	                                            _18360 = _13142;
	                                            break;
	                                        }
	                                        float _10810 = SmokeConstantBuffer_t_1_m15 - SmokeConstantBuffer_t_1_m12._m0[_17021].w;
	                                        float3 _13145;
	                                        float _16382;
	                                        float _16480;
	                                        if (_10810 < (SmokeConstantBuffer_t_1_m3._m0[_20424].x - 0.4000000059604644775390625f))
	                                        {
	                                            float _13668 = distance(_16309, SmokeConstantBuffer_t_1_m12._m0[_17021].xyz);
	                                            float3 _13143;
	                                            float _16381;
	                                            float _16479;
	                                            if (_13668 < 250.0f)
	                                            {
	                                                float _16611 = pow(1.0f - smoothstep(0.0f, 2.0f, _10810), 128.0f);
	                                                float _13560;
	                                                if (!_12666)
	                                                {
	                                                    _13560 = step(_8283, 16.0f) * (1.0f - smoothstep(0.0f, 7.0f, _10810));
	                                                }
	                                                else
	                                                {
	                                                    _13560 = 0.0f;
	                                                }
	                                                _13143 = lerp(_16309, SmokeConstantBuffer_t_1_m12._m0[_17021].xyz, (((1.0f - smoothstep(100.0f, 250.0f, _13668)) * step(_10810 * 1250.0f, _13668)) * (1.0f - _16611)).xxx);
	                                                _16381 = min(_17136, max(smoothstep(200.0f, 240.0f, _13668 + (_16611 * 250.0f)) + pow(smoothstep(0.5f, 5.0f, _10810), 1.7999999523162841796875f), _13560));
	                                                _16479 = min(_13142, SmokeConstantBuffer_t_1_m15 - (_10810 * (1.0f - smoothstep(0.0f, 5.0f, _10810))));
	                                            }
	                                            else
	                                            {
	                                                _13143 = _16309;
	                                                _16381 = _17136;
	                                                _16479 = _13142;
	                                            }
	                                            _13145 = _13143;
	                                            _16382 = _16381;
	                                            _16480 = _16479;
	                                        }
	                                        else
	                                        {
	                                            _13145 = _16309;
	                                            _16382 = _17136;
	                                            _16480 = _13142;
	                                        }
	                                        _13146 = _13145;
	                                        _14082 = _16382;
	                                        _18360 = _16480;
	                                        break;
	                                    } while(false);
	                                    if (_7957_ladder_break)
	                                    {
	                                        break;
	                                    }
	                                    _8896 = _17021 + 1u;
	                                    _13142 = _18360;
	                                    _16309 = _13146;
	                                    _17136 = _14082;
	                                    _17021 = _8896;
	                                    continue;
	                                }
	                                _13147 = _17136;
	                                _16310 = lerp(_22281 * 0.0199999995529651641845703125f, _22281, _17136);
	                                _15157 = _13142;
	                                _13734 = _16309;
	                            }
	                            else
	                            {
	                                _13147 = 1.0f;
	                                _16310 = _22281;
	                                _15157 = SmokeConstantBuffer_t_1_m15;
	                                _13734 = _25170;
	                            }
	                            float3 _6444 = _13734 * 0.00999999977648258209228515625f;
	                            float _23715 = _6444.z - (_15157 * 0.0500000007450580596923828125f);
	                            float3 _14064 = _6444;
	                            _14064.z = _23715;
	                            float3 _10565 = _14064 * 2.2999999523162841796875f;
	                            float3 _22220 = floor(_10565);
	                            float3 _8476 = frac(_10565);
	                            float _13155;
	                            _13155 = 1.0f;
	                            float _13374;
	                            float _13156;
	                            float _16208 = -1.0f;
	                            for (;;)
	                            {
	                                if (!(_16208 <= 1.0f))
	                                {
	                                    break;
	                                }
	                                _13156 = _13155;
	                                float _13375;
	                                float _13157;
	                                float _16209 = -1.0f;
	                                for (;;)
	                                {
	                                    if (!(_16209 <= 1.0f))
	                                    {
	                                        break;
	                                    }
	                                    _13157 = _13156;
	                                    float _7744;
	                                    float _11312;
	                                    float _16210 = -1.0f;
	                                    for (;;)
	                                    {
	                                        if (!(_16210 <= 1.0f))
	                                        {
	                                            break;
	                                        }
	                                        float3 _16399 = float3(_16208, _16209, _16210);
	                                        float3 _23449 = frac(fmod(_22220 + _16399, 2.2999999523162841796875f.xxx) * float3(0.103100001811981201171875f, 0.113689996302127838134765625f, 0.13786999881267547607421875f));
	                                        float3 _22705 = _23449 + dot(_23449, _23449.yxz + 19.1900005340576171875f.xxx).xxx;
	                                        float _18874 = _22705.x;
	                                        float _20358 = _22705.y;
	                                        float _13913 = _22705.z;
	                                        float3 _22245 = (_16399 + ((((-1.0f).xxx + (frac(float3((_18874 + _20358) * _13913, (_18874 + _13913) * _20358, (_20358 + _13913) * _18874)) * 2.0f)) * 0.5f) + 0.5f.xxx)) - _8476;
	                                        float _9450 = dot(_22245, _22245);
	                                        _11312 = (_9450 < _13157) ? _9450 : _13157;
	                                        _7744 = _16210 + 1.0f;
	                                        _13157 = _11312;
	                                        _16210 = _7744;
	                                        continue;
	                                    }
	                                    _13375 = _16209 + 1.0f;
	                                    _13156 = _13157;
	                                    _16209 = _13375;
	                                    continue;
	                                }
	                                _13374 = _16208 + 1.0f;
	                                _13155 = _13156;
	                                _16208 = _13374;
	                                continue;
	                            }
	                            _14064.z = _23715 - (_15157 * 0.02999999932944774627685546875f);
	                            float3 _10566 = _14064 * 6.0f;
	                            float3 _22221 = floor(_10566);
	                            float3 _8477 = frac(_10566);
	                            float _13158;
	                            _13158 = 1.0f;
	                            float _13376;
	                            float _13159;
	                            float _16211 = -1.0f;
	                            for (;;)
	                            {
	                                if (!(_16211 <= 1.0f))
	                                {
	                                    break;
	                                }
	                                _13159 = _13158;
	                                float _13377;
	                                float _13160;
	                                float _16212 = -1.0f;
	                                for (;;)
	                                {
	                                    if (!(_16212 <= 1.0f))
	                                    {
	                                        break;
	                                    }
	                                    _13160 = _13159;
	                                    float _7745;
	                                    float _11313;
	                                    float _16213 = -1.0f;
	                                    for (;;)
	                                    {
	                                        if (!(_16213 <= 1.0f))
	                                        {
	                                            break;
	                                        }
	                                        float3 _16400 = float3(_16211, _16212, _16213);
	                                        float3 _23450 = frac(fmod(_22221 + _16400, 6.0f.xxx) * float3(0.103100001811981201171875f, 0.113689996302127838134765625f, 0.13786999881267547607421875f));
	                                        float3 _22706 = _23450 + dot(_23450, _23450.yxz + 19.1900005340576171875f.xxx).xxx;
	                                        float _18875 = _22706.x;
	                                        float _20359 = _22706.y;
	                                        float _13914 = _22706.z;
	                                        float3 _22246 = (_16400 + ((((-1.0f).xxx + (frac(float3((_18875 + _20359) * _13914, (_18875 + _13914) * _20359, (_20359 + _13914) * _18875)) * 2.0f)) * 0.5f) + 0.5f.xxx)) - _8477;
	                                        float _9451 = dot(_22246, _22246);
	                                        _11313 = (_9451 < _13160) ? _9451 : _13160;
	                                        _7745 = _16213 + 1.0f;
	                                        _13160 = _11313;
	                                        _16213 = _7745;
	                                        continue;
	                                    }
	                                    _13377 = _16212 + 1.0f;
	                                    _13159 = _13160;
	                                    _16212 = _13377;
	                                    continue;
	                                }
	                                _13376 = _16211 + 1.0f;
	                                _13158 = _13159;
	                                _16211 = _13376;
	                                continue;
	                            }
	                            float _8377 = saturate((((1.0f - _13155) * 0.60000002384185791015625f) + ((1.0f - _13158) * 0.2800000011920928955078125f)) + 0.119999997317790985107421875f);
	                            float _9429;
	                            [branch]
	                            if (SmokeConstantBuffer_t_1_m5._m0[_20424].w < 1.0f)
	                            {
	                                float _17097 = clamp(SmokeConstantBuffer_t_1_m5._m0[_20424].w, 9.9999997473787516355514526367188e-05f, 0.99989998340606689453125f);
	                                float _8419 = smoothstep(0.0f, 0.800000011920928955078125f, _17097);
	                                float _14551 = smoothstep(0.20000000298023223876953125f, 1.0f, _17097);
	                                float _12502;
	                                if (_8419 == _14551)
	                                {
	                                    _12502 = _16310 * _17097;
	                                }
	                                else
	                                {
	                                    float3 _23867 = _14658 - 0.5f.xxx;
	                                    _23867.z = _23867.z * 1.2000000476837158203125f;
	                                    _12502 = _16310 * saturate(smoothstep(_8419, _14551, saturate(length(_23867))));
	                                }
	                                _9429 = _12502;
	                            }
	                            else
	                            {
	                                _9429 = _16310;
	                            }
	                            float _15862 = pow(saturate((dot(normalize(_14658 - 0.5f.xxx), PerViewLightingConstantBufferGpu_t_1_m0.xyz) * 0.800000011920928955078125f) + 0.20000000298023223876953125f), 2.0f);
	                            float _11659;
	                            [branch]
	                            if (_15862 > 0.0f)
	                            {
	                                _11659 = _15862 * _20413.w;
	                            }
	                            else
	                            {
	                                _11659 = _15862;
	                            }
	                            float3 _7844 = (((_20413.xyz * (1.0f - _9429)) * 0.5f) + (clamp(PerViewLightingConstantBufferGpu_t_1_m1.xyz, 0.0f.xxx, 1.0f.xxx) * (_11659 * (1.0f - _17152)))) * _8377;
	                            float3 _23772 = _7844 * SmokeConstantBuffer_t_1_m4._m0[_20424].xyz;
	                            float3 _25142 = lerp(_7844, _23772 * (dot(_7844.xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f)) / dot((_23772 + 0.001000000047497451305389404296875f.xxx).xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f))), (0.5f * (1.0f - SmokeConstantBuffer_t_1_m5._m0[_20424].z)).xxx).xyz;
	                            float3 _21313 = lerp(_25142, _25142 * _13147, 0.60000002384185791015625f.xxx).xyz;
	                            float _9049 = smoothstep(0.0f, 0.20000000298023223876953125f, saturate(lerp(_9429 - (1.0f - _8377), _9429 + _8377, _9429)));
	                            _21317 = _13138 + (float4(clamp((_21313 + ((_21313 * float3(8.0f, 4.0f, 0.0f)) * _16308)) * _9049, 0.0f.xxx, 1.0f.xxx), _9049) * (1.0f - _13138.w));
	                            break;
	                        }
	                        _21317 = _13138;
	                        break;
	                    } while(false);
	                    if (_21317.w > 0.990999996662139892578125f)
	                    {
	                        float4 _23482 = _21317;
	                        _23482.w = 1.0f;
	                        _13150 = _16308;
	                        _16312 = _16882;
	                        _17123 = _17152;
	                        _17124 = _13141;
	                        _17153 = _23482;
	                        _16863 = true;
	                        _7956_ladder_break = true;
	                        break;
	                    }
	                    _13149 = _21317;
	                    _16311 = _16308;
	                    _17121 = _16882;
	                    _14891 = _17152;
	                    _18361 = _13141;
	                    break;
	                } while(false);
	                if (_7956_ladder_break)
	                {
	                    break;
	                }
	                _8897 = _17019 + 1u;
	                _13138 = _13149;
	                _16306 = _16311;
	                _17119 = _17121;
	                _17120 = _14891;
	                _17134 = _18361;
	                _17019 = _8897;
	                continue;
	            }
	            if (_16863)
	            {
	                _13174 = _17153;
	                _16054 = _16863;
	                break;
	            }
	            _12783 = _17118 + _14798;
	            _7831 = _17133 + _24637;
	            _11496 = _17018 + 1;
	            _13137 = _16863;
	            _16305 = _17153;
	            _17114 = _13150;
	            _17115 = _16312;
	            _17116 = _17123;
	            _17117 = _17124;
	            _17118 = _12783;
	            _17133 = _7831;
	            _17018 = _11496;
	            continue;
	        }
	        if (_16054)
	        {
	            break;
	        }
	        break;
	    } while(false);
	    if (_13174.w < 9.9999997473787516355514526367188e-06f)
	    {
	        discard;
	    }
	    output_0 = _13174;
	}
	
	[earlydepthstencil]
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
