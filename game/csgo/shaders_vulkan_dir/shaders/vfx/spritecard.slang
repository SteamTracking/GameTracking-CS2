//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader used by the particle system";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	CsgoForward();
	GBuffer(S_MODE_GBUFFER);
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsShadingComplexity(S_MODE_TOOLS_SHADING_COMPLEXITY);
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
}

FEATURES
{
	Feature( F_DRAW_AS_TRAIL, 0..1, "" );
	Feature( F_MOTION_VECTORS, 0..1, "" );
	Feature( F_TEXTURE_LAYERS, 0..4 (0="None", 1="TextureLayer1", 2="TextureLayer2", 3="TextureLayer3", 4="TextureLayer4"), "" );
	Feature( F_REFRACT, 0..1, "" );
	Feature( F_HSV_SHIFT, 0..1, "" );
	Feature( F_PARTICLE_SHADOWS, 0..1, "" );
	Feature( F_REVERSE_DEPTH, 0..1, "" );
	Feature( F_DISABLE_DEPTHTEST, 0..1, "" );
	Feature( F_LIGHTEN_MODE, 0..1, "" );
	Feature( F_MOD2X, 0..1, "" );
	Feature( F_FOG_PARTICLES, 0..1, "" );
	Feature( F_OPAQUE, 0..1, "" );
	Feature( F_SELF_ILLUM_PER_PARTICLE, 0..1, "" );
	FeatureRule( Allow1( F_REVERSE_DEPTH, F_DISABLE_DEPTHTEST ), "Cannot disable depth test and use reverse depth test at the same time" );
	FeatureRule( Requires( F_MOTION_VECTORS, F_TEXTURE_LAYERS==0, F_TEXTURE_LAYERS==1, F_TEXTURE_LAYERS==2 ), "Maximum cbuffer allowances for motion + layers is 2 layers and 1 motion" );
	FeatureRule( Allow1( F_PARTICLE_SHADOWS, F_REVERSE_DEPTH ), "Particle shadows and Reverse Depth are incompatible" );
	FeatureRule( Allow1( F_PARTICLE_SHADOWS, F_DISABLE_DEPTHTEST ), "Particle shadows and Disable Depth Test are incompatible" );
	FeatureRule( Allow1( F_PARTICLE_SHADOWS, F_DRAW_AS_TRAIL ), "Particle shadows and Trails are incompatible" );
	FeatureRule( Allow1( F_PARTICLE_SHADOWS, F_LIGHTEN_MODE ), "Particle shadows and Lighten mode are incompatible" );
	FeatureRule( Allow1( F_PARTICLE_SHADOWS, F_REFRACT ), "Particle shadows and Refract are incompatible" );
	FeatureRule( Allow1( F_PARTICLE_SHADOWS, F_OPAQUE ), "Particle shadows and Opaque are incompatible" );
}

COMMON
{
	#include "system.fxc"
}

VS
{
	StaticCombo( S_MODE_GBUFFER, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_MODE_TOOLS_SHADING_COMPLEXITY, 0..1 );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_DRAW_AS_TRAIL, F_DRAW_AS_TRAIL );
	StaticCombo( S_MOTION_VECTORS, F_MOTION_VECTORS );
	StaticCombo( S_PARTICLE_SHADOWS, F_PARTICLE_SHADOWS );
	StaticCombo( S_TEXTURE_LAYERS, F_TEXTURE_LAYERS );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_MOTION_VECTORS ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_MODE_TOOLS_WIREFRAME ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_DRAW_AS_TRAIL ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_PARTICLE_SHADOWS ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_PARTICLE_SHADOWS ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_PARTICLE_SHADOWS ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_TEXTURE_LAYERS==0, S_TEXTURE_LAYERS==1, S_TEXTURE_LAYERS==2, S_TEXTURE_LAYERS==3 ) );
	StaticComboRule( Requires( S_MOTION_VECTORS, S_TEXTURE_LAYERS==0, S_TEXTURE_LAYERS==1, S_TEXTURE_LAYERS==2 ) );
	StaticComboRule( Allow1( S_PARTICLE_SHADOWS, S_DRAW_AS_TRAIL ) );
	DynamicCombo( D_QUAD_OVERDRAW, 0..1 );
	DynamicCombo( D_SUPPORT_FRAME_CROP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_PANORAMA_PARTICLE, 0..1 );
	DynamicComboRule( Requires( D_QUAD_OVERDRAW, S_MODE_TOOLS_SHADING_COMPLEXITY ) );
	DynamicComboRule( Requires( D_PANORAMA_PARTICLE, D_QUAD_OVERDRAW==0 ) );
	DynamicComboRule( Requires( D_PANORAMA_PARTICLE, D_BAKED_LIGHTING_FROM_PROBE==0 ) );
	DynamicComboRule( Allow1( S_MODE_GBUFFER, D_PANORAMA_PARTICLE ) );
	DynamicComboRule( Allow1( S_PARTICLE_SHADOWS, D_PANORAMA_PARTICLE ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2D g_tParticleSheetTexture < Attribute("SheetTexture"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1428
	{
	    float4 _m0[3];
	};
	
	struct _200
	{
	    column_major float4x4 _m0;
	    column_major float4x4 _m1;
	    float4 _m2;
	    float4 _m3;
	    float4 _m4;
	    float4 _m5;
	    float3 _m6;
	    uint _m7;
	    float4 _m8;
	    float4 _m9;
	    float4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    column_major float4x3 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
	    column_major float4x4 _m23;
	};
	
	static float _4;
	static float3 _5;
	static float4 _6;
	
	cbuffer SpritecardVertexControls_t : register(b3, space0)
	{
	    float4 SpritecardVertexControls_t_1_m0 : packoffset(c0);
	    float4 SpritecardVertexControls_t_1_m1 : packoffset(c1);
	    float4 SpritecardVertexControls_t_1_m2 : packoffset(c2);
	    float4 SpritecardVertexControls_t_1_m3 : packoffset(c3);
	    float4 SpritecardVertexControls_t_1_m4 : packoffset(c4);
	    float4 SpritecardVertexControls_t_1_m5 : packoffset(c5);
	    float2 SpritecardVertexControls_t_1_m6 : packoffset(c11);
	    float2 SpritecardVertexControls_t_1_m7 : packoffset(c11.z);
	    uint3 SpritecardVertexControls_t_1_m8 : packoffset(c16);
	    uint SpritecardVertexControls_t_1_m9 : packoffset(c16.w);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c17);
	    float PerViewConstantBuffer_t_1_m2 : packoffset(c19.z);
	    float PerViewConstantBuffer_t_1_m3 : packoffset(c19.w);
	    float2 PerViewConstantBuffer_t_1_m4 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m5 : packoffset(c20.z);
	    float2 PerViewConstantBuffer_t_1_m6 : packoffset(c21);
	    float PerViewConstantBuffer_t_1_m7 : packoffset(c23);
	    float PerViewConstantBuffer_t_1_m8 : packoffset(c23.y);
	    float4 PerViewConstantBuffer_t_1_m9 : packoffset(c24);
	    float3 PerViewConstantBuffer_t_1_m10 : packoffset(c26);
	    float3 PerViewConstantBuffer_t_1_m11 : packoffset(c27);
	    float3 PerViewConstantBuffer_t_1_m12 : packoffset(c28);
	    float3 PerViewConstantBuffer_t_1_m13 : packoffset(c29);
	};
	
	cbuffer SpriteCardPixelControls_t : register(b4, space0)
	{
	    uint2 SpriteCardPixelControls_t_1_m0 : packoffset(c19);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b6, space0)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c2);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c12);
	    float4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c35);
	    float PerViewConstantBufferCsgo_t_1_m3 : packoffset(c36.w);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    float4 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c0);
	    float4 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c1);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c2);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c3);
	    _1428 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c7);
	    float4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1946);
	    float PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1953.z);
	};
	
	ByteAddressBuffer g_CullBits : register(t30, space3);
	ByteAddressBuffer g_BarnLights : register(t31, space3);
	SamplerState AddressU_Wrap_AddressV_Wrap_Filter_MinMagMipPoint : register(s14, space0);
	Texture2D<float4> g_tParticleSheetTexture : register(t42, space0);
	SamplerState g_sCookieSampler : register(s26, space0);
	SamplerComparisonState g_tShadowDepthBufferCmpSampler : register(s27, space0);
	Texture2D<float4> g_tShadowDepthBufferDepth : register(t36, space0);
	SamplerState g_sTrilinearWrap : register(s20, space0);
	Texture3D<float4> g_tLightCookieTexture : register(t34, space0);
	
	static float4 gl_Position;
	static float gl_ClipDistance[1];
	static float2 input_TEXCOORD0;
	static float4 input_TEXCOORD1;
	static float4 input_TEXCOORD2;
	static float4 input_COLOR0;
	static float3 input_POSITION0;
	static float4 input_TEXCOORD3;
	static float3 input_TEXCOORD4;
	static float4 output_0;
	static float4 output_1;
	static float3 output_2;
	static float3 output_3;
	static float4 output_4;
	static float4 output_5;
	
	struct VS_INPUT
	{
	    float2 input_TEXCOORD0 : TEXCOORD0;
	    float4 input_TEXCOORD1 : TEXCOORD1;
	    float4 input_TEXCOORD2 : TEXCOORD2;
	    float4 input_COLOR0 : TEXCOORD3;
	    float3 input_POSITION0 : TEXCOORD4;
	    float4 input_TEXCOORD3 : TEXCOORD5;
	    float3 input_TEXCOORD4 : TEXCOORD6;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float3 output_3 : TEXCOORD3;
	    nointerpolation float4 output_4 : TEXCOORD4;
	    float4 output_5 : TEXCOORD5;
	    float4 gl_Position : SV_Position;
	    float gl_ClipDistance0 : SV_ClipDistance0;
	};
	
	void MainVs_inner()
	{
	    float3 _13445 = input_POSITION0;
	    uint _22646 = min(4u, ((SpritecardVertexControls_t_1_m9 >> uint(1)) & 7u));
	    bool _12885;
	    if (_22646 == 0u)
	    {
	        _12885 = SpritecardVertexControls_t_1_m2.z == 0.0f;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _21709;
	    if (_12885)
	    {
	        float _3628 = PerViewConstantBuffer_t_1_m6.y / PerViewConstantBuffer_t_1_m6.x;
	        float3 _12501;
	        if (_3628 > 1.77777779102325439453125f)
	        {
	            float3 _18603 = _13445;
	            _18603.y = _13445.y * (1.77777779102325439453125f / _3628);
	            _12501 = _18603;
	        }
	        else
	        {
	            float3 _18602 = _13445;
	            _18602.x = _13445.x * (_3628 * 0.5625f);
	            _12501 = _18602;
	        }
	        _21709 = _12501;
	    }
	    else
	    {
	        _21709 = _13445;
	    }
	    float _22759 = (input_TEXCOORD0.x * 0.5f) + 0.5f;
	    float _24186 = (input_TEXCOORD0.y * (-0.5f)) + 0.5f;
	    float4 _21120 = float4(_22759, _24186, _22759, _24186);
	    float4 _9982;
	    float4 _23824;
	    if ((SpritecardVertexControls_t_1_m9 & 32768u) == 0u)
	    {
	        float2 _11358 = float2(SpritecardVertexControls_t_1_m5.xy);
	        float2 _13746 = float2(SpritecardVertexControls_t_1_m5.zw);
	        int _14314 = int(SpritecardVertexControls_t_1_m4.x);
	        float _15589 = float(((_14314 & 31) >> 4) & 1);
	        int _9473 = int(SpritecardVertexControls_t_1_m8.x);
	        uint _11758 = uint(_9473 & 15);
	        uint _12835 = uint(_14314 & 15);
	        uint _14730 = uint(int(SpritecardVertexControls_t_1_m4.y) & 15);
	        int _10222 = _9473 & 65535;
	        int _20705 = int(SpritecardVertexControls_t_1_m4.z);
	        uint _23506 = uint((_20705 >> 12) & 15);
	        uint _14704 = uint((int(SpriteCardPixelControls_t_1_m0.y) >> 16) & 15);
	        float4 _15093;
	        do
	        {
	            if (_14704 == 2u)
	            {
	                float _20483;
	                do
	                {
	                    float _13196;
	                    bool _16075;
	                    switch (_11758)
	                    {
	                        case 1u:
	                        {
	                            _13196 = input_TEXCOORD1.z + 1.0f;
	                            _16075 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13196 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16075 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13196 = input_TEXCOORD1.y;
	                            _16075 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13196 = input_TEXCOORD1.w;
	                            _16075 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13196 = input_COLOR0.w;
	                            _16075 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13196 = input_TEXCOORD3.w;
	                            _16075 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13196 = input_TEXCOORD3.x;
	                            _16075 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13196 = input_TEXCOORD3.y;
	                            _16075 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13196 = input_TEXCOORD3.z;
	                            _16075 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13196 = frac(input_TEXCOORD1.x * 5657.4111328125f);
	                            _16075 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13196 = (frac(input_TEXCOORD1.x * 5657.4111328125f) - 0.5f) * 2.0f;
	                            _16075 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13196 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 5657.4111328125f)) + 1.0f;
	                            _16075 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12478 = (frac(input_TEXCOORD1.x * 5657.4111328125f) - 0.5f) * 2.0f;
	                            _13196 = (_12478 * input_TEXCOORD1.z) + float(int(sign(_12478)));
	                            _16075 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13196 = _4;
	                            _16075 = false;
	                            break;
	                        }
	                    }
	                    if (_16075)
	                    {
	                        _20483 = _13196;
	                        break;
	                    }
	                    _20483 = 1.0f;
	                    break;
	                } while(false);
	                float2 _11182 = 1.0f.xx / (_13746.xy * _20483.xx);
	                float _12909;
	                do
	                {
	                    float _13197;
	                    bool _16076;
	                    switch (_12835)
	                    {
	                        case 1u:
	                        {
	                            _13197 = input_TEXCOORD1.z + 1.0f;
	                            _16076 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13197 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16076 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13197 = input_TEXCOORD1.y;
	                            _16076 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13197 = input_TEXCOORD1.w;
	                            _16076 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13197 = input_COLOR0.w;
	                            _16076 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13197 = input_TEXCOORD3.w;
	                            _16076 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13197 = input_TEXCOORD3.x;
	                            _16076 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13197 = input_TEXCOORD3.y;
	                            _16076 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13197 = input_TEXCOORD3.z;
	                            _16076 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13197 = frac(input_TEXCOORD1.x * 1231.67041015625f);
	                            _16076 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13197 = (frac(input_TEXCOORD1.x * 1231.67041015625f) - 0.5f) * 2.0f;
	                            _16076 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13197 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 1231.67041015625f)) + 1.0f;
	                            _16076 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12479 = (frac(input_TEXCOORD1.x * 1231.67041015625f) - 0.5f) * 2.0f;
	                            _13197 = (_12479 * input_TEXCOORD1.z) + float(int(sign(_12479)));
	                            _16076 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13197 = _4;
	                            _16076 = false;
	                            break;
	                        }
	                    }
	                    if (_16076)
	                    {
	                        _12909 = _13197;
	                        break;
	                    }
	                    _12909 = 1.0f;
	                    break;
	                } while(false);
	                float _19457;
	                do
	                {
	                    float _13198;
	                    bool _16077;
	                    switch (_14730)
	                    {
	                        case 1u:
	                        {
	                            _13198 = input_TEXCOORD1.z + 1.0f;
	                            _16077 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13198 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16077 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13198 = input_TEXCOORD1.y;
	                            _16077 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13198 = input_TEXCOORD1.w;
	                            _16077 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13198 = input_COLOR0.w;
	                            _16077 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13198 = input_TEXCOORD3.w;
	                            _16077 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13198 = input_TEXCOORD3.x;
	                            _16077 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13198 = input_TEXCOORD3.y;
	                            _16077 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13198 = input_TEXCOORD3.z;
	                            _16077 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13198 = frac(input_TEXCOORD1.x * 1542.87060546875f);
	                            _16077 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13198 = (frac(input_TEXCOORD1.x * 1542.87060546875f) - 0.5f) * 2.0f;
	                            _16077 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13198 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 1542.87060546875f)) + 1.0f;
	                            _16077 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12480 = (frac(input_TEXCOORD1.x * 1542.87060546875f) - 0.5f) * 2.0f;
	                            _13198 = (_12480 * input_TEXCOORD1.z) + float(int(sign(_12480)));
	                            _16077 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13198 = _4;
	                            _16077 = false;
	                            break;
	                        }
	                    }
	                    if (_16077)
	                    {
	                        _19457 = _13198;
	                        break;
	                    }
	                    _19457 = 1.0f;
	                    break;
	                } while(false);
	                float2 _8770 = (_11358.xy * float2(_12909, _19457)) + lerp(0.0f.xx, frac(float2(input_TEXCOORD1.x * 1718.4361572265625f, input_TEXCOORD1.x * 1271.89013671875f)), _15589.xx);
	                float _22687;
	                do
	                {
	                    float _13199;
	                    bool _16078;
	                    switch (_23506)
	                    {
	                        case 1u:
	                        {
	                            _13199 = input_TEXCOORD1.z + 1.0f;
	                            _16078 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13199 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16078 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13199 = input_TEXCOORD1.y;
	                            _16078 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13199 = input_TEXCOORD1.w;
	                            _16078 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13199 = input_COLOR0.w;
	                            _16078 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13199 = input_TEXCOORD3.w;
	                            _16078 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13199 = input_TEXCOORD3.x;
	                            _16078 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13199 = input_TEXCOORD3.y;
	                            _16078 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13199 = input_TEXCOORD3.z;
	                            _16078 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13199 = frac(input_TEXCOORD1.x * 4574.43115234375f);
	                            _16078 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13199 = (frac(input_TEXCOORD1.x * 4574.43115234375f) - 0.5f) * 2.0f;
	                            _16078 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13199 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 4574.43115234375f)) + 1.0f;
	                            _16078 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12481 = (frac(input_TEXCOORD1.x * 4574.43115234375f) - 0.5f) * 2.0f;
	                            _13199 = (_12481 * input_TEXCOORD1.z) + float(int(sign(_12481)));
	                            _16078 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13199 = _4;
	                            _16078 = false;
	                            break;
	                        }
	                    }
	                    if (_16078)
	                    {
	                        _22687 = _13199;
	                        break;
	                    }
	                    _22687 = 1.0f;
	                    break;
	                } while(false);
	                _15093 = float4(_8770.x, _8770.y * _11182.y, _11182.x, _22687);
	                break;
	            }
	            else
	            {
	                float _12961;
	                do
	                {
	                    float _13188;
	                    bool _16068;
	                    switch (_11758)
	                    {
	                        case 1u:
	                        {
	                            _13188 = input_TEXCOORD1.z + 1.0f;
	                            _16068 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13188 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16068 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13188 = input_TEXCOORD1.y;
	                            _16068 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13188 = input_TEXCOORD1.w;
	                            _16068 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13188 = input_COLOR0.w;
	                            _16068 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13188 = input_TEXCOORD3.w;
	                            _16068 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13188 = input_TEXCOORD3.x;
	                            _16068 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13188 = input_TEXCOORD3.y;
	                            _16068 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13188 = input_TEXCOORD3.z;
	                            _16068 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13188 = frac(input_TEXCOORD1.x * 5657.4111328125f);
	                            _16068 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13188 = (frac(input_TEXCOORD1.x * 5657.4111328125f) - 0.5f) * 2.0f;
	                            _16068 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13188 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 5657.4111328125f)) + 1.0f;
	                            _16068 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12471 = (frac(input_TEXCOORD1.x * 5657.4111328125f) - 0.5f) * 2.0f;
	                            _13188 = (_12471 * input_TEXCOORD1.z) + float(int(sign(_12471)));
	                            _16068 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13188 = _4;
	                            _16068 = false;
	                            break;
	                        }
	                    }
	                    if (_16068)
	                    {
	                        _12961 = _13188;
	                        break;
	                    }
	                    _12961 = 1.0f;
	                    break;
	                } while(false);
	                float _12907;
	                do
	                {
	                    float _13189;
	                    bool _16069;
	                    switch (_12835)
	                    {
	                        case 1u:
	                        {
	                            _13189 = input_TEXCOORD1.z + 1.0f;
	                            _16069 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13189 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16069 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13189 = input_TEXCOORD1.y;
	                            _16069 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13189 = input_TEXCOORD1.w;
	                            _16069 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13189 = input_COLOR0.w;
	                            _16069 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13189 = input_TEXCOORD3.w;
	                            _16069 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13189 = input_TEXCOORD3.x;
	                            _16069 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13189 = input_TEXCOORD3.y;
	                            _16069 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13189 = input_TEXCOORD3.z;
	                            _16069 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13189 = frac(input_TEXCOORD1.x * 1231.67041015625f);
	                            _16069 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13189 = (frac(input_TEXCOORD1.x * 1231.67041015625f) - 0.5f) * 2.0f;
	                            _16069 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13189 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 1231.67041015625f)) + 1.0f;
	                            _16069 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12472 = (frac(input_TEXCOORD1.x * 1231.67041015625f) - 0.5f) * 2.0f;
	                            _13189 = (_12472 * input_TEXCOORD1.z) + float(int(sign(_12472)));
	                            _16069 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13189 = _4;
	                            _16069 = false;
	                            break;
	                        }
	                    }
	                    if (_16069)
	                    {
	                        _12907 = _13189;
	                        break;
	                    }
	                    _12907 = 1.0f;
	                    break;
	                } while(false);
	                float _22649;
	                do
	                {
	                    float _13190;
	                    bool _16070;
	                    switch (_14730)
	                    {
	                        case 1u:
	                        {
	                            _13190 = input_TEXCOORD1.z + 1.0f;
	                            _16070 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13190 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16070 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13190 = input_TEXCOORD1.y;
	                            _16070 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13190 = input_TEXCOORD1.w;
	                            _16070 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13190 = input_COLOR0.w;
	                            _16070 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13190 = input_TEXCOORD3.w;
	                            _16070 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13190 = input_TEXCOORD3.x;
	                            _16070 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13190 = input_TEXCOORD3.y;
	                            _16070 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13190 = input_TEXCOORD3.z;
	                            _16070 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13190 = frac(input_TEXCOORD1.x * 1542.87060546875f);
	                            _16070 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13190 = (frac(input_TEXCOORD1.x * 1542.87060546875f) - 0.5f) * 2.0f;
	                            _16070 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13190 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 1542.87060546875f)) + 1.0f;
	                            _16070 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12473 = (frac(input_TEXCOORD1.x * 1542.87060546875f) - 0.5f) * 2.0f;
	                            _13190 = (_12473 * input_TEXCOORD1.z) + float(int(sign(_12473)));
	                            _16070 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13190 = _4;
	                            _16070 = false;
	                            break;
	                        }
	                    }
	                    if (_16070)
	                    {
	                        _22649 = _13190;
	                        break;
	                    }
	                    _22649 = 1.0f;
	                    break;
	                } while(false);
	                float _20618;
	                do
	                {
	                    float _13191;
	                    bool _16071;
	                    switch (uint((_10222 >> 4) & 15))
	                    {
	                        case 1u:
	                        {
	                            _13191 = input_TEXCOORD1.z + 1.0f;
	                            _16071 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13191 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16071 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13191 = input_TEXCOORD1.y;
	                            _16071 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13191 = input_TEXCOORD1.w;
	                            _16071 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13191 = input_COLOR0.w;
	                            _16071 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13191 = input_TEXCOORD3.w;
	                            _16071 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13191 = input_TEXCOORD3.x;
	                            _16071 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13191 = input_TEXCOORD3.y;
	                            _16071 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13191 = input_TEXCOORD3.z;
	                            _16071 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13191 = frac(input_TEXCOORD1.x * 2969.86181640625f);
	                            _16071 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13191 = (frac(input_TEXCOORD1.x * 2969.86181640625f) - 0.5f) * 2.0f;
	                            _16071 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13191 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 2969.86181640625f)) + 1.0f;
	                            _16071 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12474 = (frac(input_TEXCOORD1.x * 2969.86181640625f) - 0.5f) * 2.0f;
	                            _13191 = (_12474 * input_TEXCOORD1.z) + float(int(sign(_12474)));
	                            _16071 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13191 = _4;
	                            _16071 = false;
	                            break;
	                        }
	                    }
	                    if (_16071)
	                    {
	                        _20618 = _13191;
	                        break;
	                    }
	                    _20618 = 1.0f;
	                    break;
	                } while(false);
	                float2 _13165 = _21120.xy - 0.5f.xx;
	                float _19475 = SpritecardVertexControls_t_1_m4.w * _20618;
	                float _9169 = cos(_19475);
	                float _25014 = sin(_19475);
	                float _11443 = _13165.x;
	                float _7575 = _13165.y;
	                float4 _8993;
	                _8993.x = (_11443 * _9169) + (_7575 * (-_25014));
	                _8993.y = (_11443 * _25014) + (_7575 * _9169);
	                float _21262;
	                do
	                {
	                    float _13193;
	                    bool _16072;
	                    switch (uint((_10222 >> 8) & 15))
	                    {
	                        case 1u:
	                        {
	                            _13193 = input_TEXCOORD1.z + 1.0f;
	                            _16072 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13193 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16072 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13193 = input_TEXCOORD1.y;
	                            _16072 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13193 = input_TEXCOORD1.w;
	                            _16072 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13193 = input_COLOR0.w;
	                            _16072 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13193 = input_TEXCOORD3.w;
	                            _16072 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13193 = input_TEXCOORD3.x;
	                            _16072 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13193 = input_TEXCOORD3.y;
	                            _16072 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13193 = input_TEXCOORD3.z;
	                            _16072 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13193 = frac(input_TEXCOORD1.x * 1944.34521484375f);
	                            _16072 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13193 = (frac(input_TEXCOORD1.x * 1944.34521484375f) - 0.5f) * 2.0f;
	                            _16072 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13193 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 1944.34521484375f)) + 1.0f;
	                            _16072 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12475 = (frac(input_TEXCOORD1.x * 1944.34521484375f) - 0.5f) * 2.0f;
	                            _13193 = (_12475 * input_TEXCOORD1.z) + float(int(sign(_12475)));
	                            _16072 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13193 = _4;
	                            _16072 = false;
	                            break;
	                        }
	                    }
	                    if (_16072)
	                    {
	                        _21262 = _13193;
	                        break;
	                    }
	                    _21262 = 1.0f;
	                    break;
	                } while(false);
	                float4 _20274 = float4((((_8993.xy / _13746.xy) * (1.0f / _12961)) + frac((_11358.xy * float2(_12907, _22649)) + 0.5f.xx)) + lerp(0.0f.xx, frac(float2(input_TEXCOORD1.x * 1718.4361572265625f, input_TEXCOORD1.x * 1271.89013671875f)), _15589.xx), _21262, 1.0f);
	                float4 _12908;
	                if (_14704 >= 3u)
	                {
	                    float _22341;
	                    do
	                    {
	                        float _13194;
	                        bool _16073;
	                        switch (uint((_10222 >> 12) & 15))
	                        {
	                            case 1u:
	                            {
	                                _13194 = input_TEXCOORD1.z + 1.0f;
	                                _16073 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13194 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16073 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13194 = input_TEXCOORD1.y;
	                                _16073 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13194 = input_TEXCOORD1.w;
	                                _16073 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13194 = input_COLOR0.w;
	                                _16073 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13194 = input_TEXCOORD3.w;
	                                _16073 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13194 = input_TEXCOORD3.x;
	                                _16073 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13194 = input_TEXCOORD3.y;
	                                _16073 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13194 = input_TEXCOORD3.z;
	                                _16073 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13194 = frac(input_TEXCOORD1.x * 2704.225341796875f);
	                                _16073 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13194 = (frac(input_TEXCOORD1.x * 2704.225341796875f) - 0.5f) * 2.0f;
	                                _16073 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13194 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 2704.225341796875f)) + 1.0f;
	                                _16073 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12476 = (frac(input_TEXCOORD1.x * 2704.225341796875f) - 0.5f) * 2.0f;
	                                _13194 = (_12476 * input_TEXCOORD1.z) + float(int(sign(_12476)));
	                                _16073 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13194 = _4;
	                                _16073 = false;
	                                break;
	                            }
	                        }
	                        if (_16073)
	                        {
	                            _22341 = _13194;
	                            break;
	                        }
	                        _22341 = 1.0f;
	                        break;
	                    } while(false);
	                    float4 _10003 = _20274;
	                    _10003.w = _22341;
	                    _12908 = _10003;
	                }
	                else
	                {
	                    _12908 = _20274;
	                }
	                float _20311;
	                do
	                {
	                    float _13195;
	                    bool _16074;
	                    switch (_23506)
	                    {
	                        case 1u:
	                        {
	                            _13195 = input_TEXCOORD1.z + 1.0f;
	                            _16074 = true;
	                            break;
	                        }
	                        case 2u:
	                        {
	                            _13195 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                            _16074 = true;
	                            break;
	                        }
	                        case 3u:
	                        {
	                            _13195 = input_TEXCOORD1.y;
	                            _16074 = true;
	                            break;
	                        }
	                        case 4u:
	                        {
	                            _13195 = input_TEXCOORD1.w;
	                            _16074 = true;
	                            break;
	                        }
	                        case 5u:
	                        {
	                            _13195 = input_COLOR0.w;
	                            _16074 = true;
	                            break;
	                        }
	                        case 6u:
	                        {
	                            _13195 = input_TEXCOORD3.w;
	                            _16074 = true;
	                            break;
	                        }
	                        case 7u:
	                        {
	                            _13195 = input_TEXCOORD3.x;
	                            _16074 = true;
	                            break;
	                        }
	                        case 8u:
	                        {
	                            _13195 = input_TEXCOORD3.y;
	                            _16074 = true;
	                            break;
	                        }
	                        case 9u:
	                        {
	                            _13195 = input_TEXCOORD3.z;
	                            _16074 = true;
	                            break;
	                        }
	                        case 10u:
	                        {
	                            _13195 = frac(input_TEXCOORD1.x * 4574.43115234375f);
	                            _16074 = true;
	                            break;
	                        }
	                        case 11u:
	                        {
	                            _13195 = (frac(input_TEXCOORD1.x * 4574.43115234375f) - 0.5f) * 2.0f;
	                            _16074 = true;
	                            break;
	                        }
	                        case 12u:
	                        {
	                            _13195 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 4574.43115234375f)) + 1.0f;
	                            _16074 = true;
	                            break;
	                        }
	                        case 13u:
	                        {
	                            float _12477 = (frac(input_TEXCOORD1.x * 4574.43115234375f) - 0.5f) * 2.0f;
	                            _13195 = (_12477 * input_TEXCOORD1.z) + float(int(sign(_12477)));
	                            _16074 = true;
	                            break;
	                        }
	                        default:
	                        {
	                            _13195 = _4;
	                            _16074 = false;
	                            break;
	                        }
	                    }
	                    if (_16074)
	                    {
	                        _20311 = _13195;
	                        break;
	                    }
	                    _20311 = 1.0f;
	                    break;
	                } while(false);
	                float4 _18605 = _12908;
	                _18605.w = _12908.w * _20311;
	                _15093 = _18605;
	                break;
	            }
	            break; // unreachable workaround
	        } while(false);
	        float4 _12503;
	        if (clamp(SpritecardVertexControls_t_1_m9 & 262144u, 0u, 1u) == 1u)
	        {
	            float _12838;
	            do
	            {
	                float _13200;
	                bool _16079;
	                switch (uint(_20705 & 15))
	                {
	                    case 1u:
	                    {
	                        _13200 = input_TEXCOORD1.z + 1.0f;
	                        _16079 = true;
	                        break;
	                    }
	                    case 2u:
	                    {
	                        _13200 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                        _16079 = true;
	                        break;
	                    }
	                    case 3u:
	                    {
	                        _13200 = input_TEXCOORD1.y;
	                        _16079 = true;
	                        break;
	                    }
	                    case 4u:
	                    {
	                        _13200 = input_TEXCOORD1.w;
	                        _16079 = true;
	                        break;
	                    }
	                    case 5u:
	                    {
	                        _13200 = input_COLOR0.w;
	                        _16079 = true;
	                        break;
	                    }
	                    case 6u:
	                    {
	                        _13200 = input_TEXCOORD3.w;
	                        _16079 = true;
	                        break;
	                    }
	                    case 7u:
	                    {
	                        _13200 = input_TEXCOORD3.x;
	                        _16079 = true;
	                        break;
	                    }
	                    case 8u:
	                    {
	                        _13200 = input_TEXCOORD3.y;
	                        _16079 = true;
	                        break;
	                    }
	                    case 9u:
	                    {
	                        _13200 = input_TEXCOORD3.z;
	                        _16079 = true;
	                        break;
	                    }
	                    case 10u:
	                    {
	                        _13200 = frac(input_TEXCOORD1.x * 238.839996337890625f);
	                        _16079 = true;
	                        break;
	                    }
	                    case 11u:
	                    {
	                        _13200 = (frac(input_TEXCOORD1.x * 238.839996337890625f) - 0.5f) * 2.0f;
	                        _16079 = true;
	                        break;
	                    }
	                    case 12u:
	                    {
	                        _13200 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 238.839996337890625f)) + 1.0f;
	                        _16079 = true;
	                        break;
	                    }
	                    case 13u:
	                    {
	                        float _12482 = (frac(input_TEXCOORD1.x * 238.839996337890625f) - 0.5f) * 2.0f;
	                        _13200 = (_12482 * input_TEXCOORD1.z) + float(int(sign(_12482)));
	                        _16079 = true;
	                        break;
	                    }
	                    default:
	                    {
	                        _13200 = _4;
	                        _16079 = false;
	                        break;
	                    }
	                }
	                if (_16079)
	                {
	                    _12838 = _13200;
	                    break;
	                }
	                _12838 = 1.0f;
	                break;
	            } while(false);
	            float _19168;
	            do
	            {
	                float _13201;
	                bool _16080;
	                switch (uint((_20705 >> 4) & 15))
	                {
	                    case 1u:
	                    {
	                        _13201 = input_TEXCOORD1.z + 1.0f;
	                        _16080 = true;
	                        break;
	                    }
	                    case 2u:
	                    {
	                        _13201 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                        _16080 = true;
	                        break;
	                    }
	                    case 3u:
	                    {
	                        _13201 = input_TEXCOORD1.y;
	                        _16080 = true;
	                        break;
	                    }
	                    case 4u:
	                    {
	                        _13201 = input_TEXCOORD1.w;
	                        _16080 = true;
	                        break;
	                    }
	                    case 5u:
	                    {
	                        _13201 = input_COLOR0.w;
	                        _16080 = true;
	                        break;
	                    }
	                    case 6u:
	                    {
	                        _13201 = input_TEXCOORD3.w;
	                        _16080 = true;
	                        break;
	                    }
	                    case 7u:
	                    {
	                        _13201 = input_TEXCOORD3.x;
	                        _16080 = true;
	                        break;
	                    }
	                    case 8u:
	                    {
	                        _13201 = input_TEXCOORD3.y;
	                        _16080 = true;
	                        break;
	                    }
	                    case 9u:
	                    {
	                        _13201 = input_TEXCOORD3.z;
	                        _16080 = true;
	                        break;
	                    }
	                    case 10u:
	                    {
	                        _13201 = frac(input_TEXCOORD1.x * 84.74559783935546875f);
	                        _16080 = true;
	                        break;
	                    }
	                    case 11u:
	                    {
	                        _13201 = (frac(input_TEXCOORD1.x * 84.74559783935546875f) - 0.5f) * 2.0f;
	                        _16080 = true;
	                        break;
	                    }
	                    case 12u:
	                    {
	                        _13201 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 84.74559783935546875f)) + 1.0f;
	                        _16080 = true;
	                        break;
	                    }
	                    case 13u:
	                    {
	                        float _12483 = (frac(input_TEXCOORD1.x * 84.74559783935546875f) - 0.5f) * 2.0f;
	                        _13201 = (_12483 * input_TEXCOORD1.z) + float(int(sign(_12483)));
	                        _16080 = true;
	                        break;
	                    }
	                    default:
	                    {
	                        _13201 = _4;
	                        _16080 = false;
	                        break;
	                    }
	                }
	                if (_16080)
	                {
	                    _19168 = _13201;
	                    break;
	                }
	                _19168 = 1.0f;
	                break;
	            } while(false);
	            float4 _19842 = float4(-1.0f, -1.0f, 1.0f, 0.0f);
	            _19842.z = 1.0f - _12838;
	            _19842.w = _19168;
	            _12503 = _19842;
	        }
	        else
	        {
	            _12503 = float4(-1.0f, -1.0f, 1.0f, 0.0f);
	        }
	        _9982 = _15093;
	        _23824 = _12503;
	    }
	    else
	    {
	        float4 _12262;
	        float4 _19880;
	        if (SpritecardVertexControls_t_1_m7.y > 0.0f)
	        {
	            float _21710;
	            do
	            {
	                float _13185;
	                bool _16065;
	                switch (uint(((int(SpritecardVertexControls_t_1_m8.x) & 65535) >> 4) & 15))
	                {
	                    case 1u:
	                    {
	                        _13185 = input_TEXCOORD1.z + 1.0f;
	                        _16065 = true;
	                        break;
	                    }
	                    case 2u:
	                    {
	                        _13185 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                        _16065 = true;
	                        break;
	                    }
	                    case 3u:
	                    {
	                        _13185 = input_TEXCOORD1.y;
	                        _16065 = true;
	                        break;
	                    }
	                    case 4u:
	                    {
	                        _13185 = input_TEXCOORD1.w;
	                        _16065 = true;
	                        break;
	                    }
	                    case 5u:
	                    {
	                        _13185 = input_COLOR0.w;
	                        _16065 = true;
	                        break;
	                    }
	                    case 6u:
	                    {
	                        _13185 = input_TEXCOORD3.w;
	                        _16065 = true;
	                        break;
	                    }
	                    case 7u:
	                    {
	                        _13185 = input_TEXCOORD3.x;
	                        _16065 = true;
	                        break;
	                    }
	                    case 8u:
	                    {
	                        _13185 = input_TEXCOORD3.y;
	                        _16065 = true;
	                        break;
	                    }
	                    case 9u:
	                    {
	                        _13185 = input_TEXCOORD3.z;
	                        _16065 = true;
	                        break;
	                    }
	                    case 10u:
	                    {
	                        _13185 = frac(input_TEXCOORD1.x * 1.34700000286102294921875f);
	                        _16065 = true;
	                        break;
	                    }
	                    case 11u:
	                    {
	                        _13185 = (frac(input_TEXCOORD1.x * 1.34700000286102294921875f) - 0.5f) * 2.0f;
	                        _16065 = true;
	                        break;
	                    }
	                    case 12u:
	                    {
	                        _13185 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 1.34700000286102294921875f)) + 1.0f;
	                        _16065 = true;
	                        break;
	                    }
	                    case 13u:
	                    {
	                        float _12468 = (frac(input_TEXCOORD1.x * 1.34700000286102294921875f) - 0.5f) * 2.0f;
	                        _13185 = (_12468 * input_TEXCOORD1.z) + float(int(sign(_12468)));
	                        _16065 = true;
	                        break;
	                    }
	                    default:
	                    {
	                        _13185 = _4;
	                        _16065 = false;
	                        break;
	                    }
	                }
	                if (_16065)
	                {
	                    _21710 = _13185;
	                    break;
	                }
	                _21710 = 1.0f;
	                break;
	            } while(false);
	            float _16161 = _21710 * SpritecardVertexControls_t_1_m4.w;
	            float _7037 = 1.0f / SpritecardVertexControls_t_1_m6.x;
	            float _24760 = SpritecardVertexControls_t_1_m7.x + ((3.0f * (((input_TEXCOORD2.x - SpritecardVertexControls_t_1_m7.y) >= 0.0f) ? 0.0f : input_TEXCOORD2.x)) * SpritecardVertexControls_t_1_m6.y);
	            float4 _23814 = g_tParticleSheetTexture.SampleLevel(AddressU_Wrap_AddressV_Wrap_Filter_MinMagMipPoint, float2(0.0f, _24760), 0.0f);
	            float _11313;
	            if ((SpritecardVertexControls_t_1_m9 & 4096u) != 0u)
	            {
	                _11313 = 0.0002441443502902984619140625f / _23814.y;
	            }
	            else
	            {
	                _11313 = 1.0f;
	            }
	            float _17794 = (((_11313 * SpritecardVertexControls_t_1_m6.x) * 0.5f) * (input_TEXCOORD1.z * lerp(_16161, 1.0f, float(_16161 == 0.0f)))) * SpritecardVertexControls_t_1_m1.w;
	            float _17072 = 2.0f * floor(_17794);
	            float _10306;
	            if (_23814.z > 0.0f)
	            {
	                _10306 = min(SpritecardVertexControls_t_1_m6.x - 2.0f, _17072);
	            }
	            else
	            {
	                _10306 = fmod(_17072, SpritecardVertexControls_t_1_m6.x);
	            }
	            float _11877 = _10306 * _7037;
	            float4 _11179 = g_tParticleSheetTexture.SampleLevel(AddressU_Wrap_AddressV_Wrap_Filter_MinMagMipPoint, float2(_11877, _24760), 0.0f);
	            float _11756 = lerp(_11179.x, _11179.w, frac(_17794));
	            float _25172 = _24760 + SpritecardVertexControls_t_1_m6.y;
	            float4 _22166 = g_tParticleSheetTexture.SampleLevel(AddressU_Wrap_AddressV_Wrap_Filter_MinMagMipPoint, float2(_11877, _25172), 0.0f);
	            float4 _21927 = g_tParticleSheetTexture.SampleLevel(AddressU_Wrap_AddressV_Wrap_Filter_MinMagMipPoint, float2(_11877, _24760 + (2.0f * SpritecardVertexControls_t_1_m6.y)), 0.0f);
	            float4 _11487 = g_tParticleSheetTexture.SampleLevel(AddressU_Wrap_AddressV_Wrap_Filter_MinMagMipPoint, float2(_11877 + _7037, _25172), 0.0f);
	            float2 _20234 = _11487.xy;
	            float2 _6786 = _22166.xy;
	            float2 _7648 = (_11487.zw - _20234).xy;
	            float2 _20524 = ((_22166.zw - _6786) / _7648).xy;
	            float2 _22862 = _6786 - (_20234 * _20524);
	            float _24522 = _22862.x;
	            float4 _22101;
	            _22101.x = _24522;
	            _22101.y = _22862.y;
	            float4 _11665 = float4(_24522, _22862.y, _22101.xy + _20524);
	            float2 _14865 = _21927.xy;
	            float2 _23732 = ((_21927.zw - _14865) / _7648).xy;
	            float2 _22863 = _14865 - (_20234 * _23732);
	            float _24523 = _22863.x;
	            float4 _22102;
	            _22102.x = _24523;
	            _22102.y = _22863.y;
	            float4 _19645 = float4(_24523, _22863.y, _22102.xy + _23732);
	            float _14426 = _11756 * 0.5f;
	            float _8035 = _14426 + 0.5f;
	            float4 _15186 = lerp(_21120, ((_21120 - 0.5f.xxxx) * saturate(1.0f / SpritecardVertexControls_t_1_m3.y)) + 0.5f.xxxx, float4(_8035, _8035, _14426, _14426));
	            float4 _20271 = float4((_15186.x / SpritecardVertexControls_t_1_m5.z) + SpritecardVertexControls_t_1_m5.x, (_15186.y / SpritecardVertexControls_t_1_m5.w) + SpritecardVertexControls_t_1_m5.y, (_15186.z / SpritecardVertexControls_t_1_m5.z) + SpritecardVertexControls_t_1_m5.x, (_15186.w / SpritecardVertexControls_t_1_m5.w) + SpritecardVertexControls_t_1_m5.y);
	            float2 _13920 = _11665.xy;
	            float2 _19858 = _19645.xy;
	            float4 _23767 = float4(-1.0f, -1.0f, 1.0f, 0.0f);
	            _23767.x = _11756;
	            _23767.y = 0.0f;
	            _12262 = float4(_13920 + (_20271.xy * (_11665.zw - _13920)), _19858 + (_20271.zw * (_19645.zw - _19858)));
	            _19880 = _23767;
	        }
	        else
	        {
	            float2 _11357 = float2(SpritecardVertexControls_t_1_m5.xy);
	            float2 _13745 = float2(SpritecardVertexControls_t_1_m5.zw);
	            int _14313 = int(SpritecardVertexControls_t_1_m4.x);
	            float _15588 = float(((_14313 & 31) >> 4) & 1);
	            int _9472 = int(SpritecardVertexControls_t_1_m8.x);
	            uint _11757 = uint(_9472 & 15);
	            uint _12834 = uint(_14313 & 15);
	            uint _14729 = uint(int(SpritecardVertexControls_t_1_m4.y) & 15);
	            int _10221 = _9472 & 65535;
	            uint _23505 = uint((int(SpritecardVertexControls_t_1_m4.z) >> 12) & 15);
	            uint _14700 = uint((int(SpriteCardPixelControls_t_1_m0.y) >> 16) & 15);
	            float4 _10883;
	            do
	            {
	                if (_14700 == 2u)
	                {
	                    float _20482;
	                    do
	                    {
	                        float _13181;
	                        bool _16061;
	                        switch (_11757)
	                        {
	                            case 1u:
	                            {
	                                _13181 = input_TEXCOORD1.z + 1.0f;
	                                _16061 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13181 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16061 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13181 = input_TEXCOORD1.y;
	                                _16061 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13181 = input_TEXCOORD1.w;
	                                _16061 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13181 = input_COLOR0.w;
	                                _16061 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13181 = input_TEXCOORD3.w;
	                                _16061 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13181 = input_TEXCOORD3.x;
	                                _16061 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13181 = input_TEXCOORD3.y;
	                                _16061 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13181 = input_TEXCOORD3.z;
	                                _16061 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13181 = frac(input_TEXCOORD1.x * 33.658000946044921875f);
	                                _16061 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13181 = (frac(input_TEXCOORD1.x * 33.658000946044921875f) - 0.5f) * 2.0f;
	                                _16061 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13181 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 33.658000946044921875f)) + 1.0f;
	                                _16061 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12464 = (frac(input_TEXCOORD1.x * 33.658000946044921875f) - 0.5f) * 2.0f;
	                                _13181 = (_12464 * input_TEXCOORD1.z) + float(int(sign(_12464)));
	                                _16061 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13181 = _4;
	                                _16061 = false;
	                                break;
	                            }
	                        }
	                        if (_16061)
	                        {
	                            _20482 = _13181;
	                            break;
	                        }
	                        _20482 = 1.0f;
	                        break;
	                    } while(false);
	                    float2 _11181 = 1.0f.xx / (_13745.xy * _20482.xx);
	                    float _12906;
	                    do
	                    {
	                        float _13182;
	                        bool _16062;
	                        switch (_12834)
	                        {
	                            case 1u:
	                            {
	                                _13182 = input_TEXCOORD1.z + 1.0f;
	                                _16062 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13182 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16062 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13182 = input_TEXCOORD1.y;
	                                _16062 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13182 = input_TEXCOORD1.w;
	                                _16062 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13182 = input_COLOR0.w;
	                                _16062 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13182 = input_TEXCOORD3.w;
	                                _16062 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13182 = input_TEXCOORD3.x;
	                                _16062 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13182 = input_TEXCOORD3.y;
	                                _16062 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13182 = input_TEXCOORD3.z;
	                                _16062 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13182 = frac(input_TEXCOORD1.x * 7.327655792236328125f);
	                                _16062 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13182 = (frac(input_TEXCOORD1.x * 7.327655792236328125f) - 0.5f) * 2.0f;
	                                _16062 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13182 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 7.327655792236328125f)) + 1.0f;
	                                _16062 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12465 = (frac(input_TEXCOORD1.x * 7.327655792236328125f) - 0.5f) * 2.0f;
	                                _13182 = (_12465 * input_TEXCOORD1.z) + float(int(sign(_12465)));
	                                _16062 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13182 = _4;
	                                _16062 = false;
	                                break;
	                            }
	                        }
	                        if (_16062)
	                        {
	                            _12906 = _13182;
	                            break;
	                        }
	                        _12906 = 1.0f;
	                        break;
	                    } while(false);
	                    float _19456;
	                    do
	                    {
	                        float _13183;
	                        bool _16063;
	                        switch (_14729)
	                        {
	                            case 1u:
	                            {
	                                _13183 = input_TEXCOORD1.z + 1.0f;
	                                _16063 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13183 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16063 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13183 = input_TEXCOORD1.y;
	                                _16063 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13183 = input_TEXCOORD1.w;
	                                _16063 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13183 = input_COLOR0.w;
	                                _16063 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13183 = input_TEXCOORD3.w;
	                                _16063 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13183 = input_TEXCOORD3.x;
	                                _16063 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13183 = input_TEXCOORD3.y;
	                                _16063 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13183 = input_TEXCOORD3.z;
	                                _16063 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13183 = frac(input_TEXCOORD1.x * 9.17909908294677734375f);
	                                _16063 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13183 = (frac(input_TEXCOORD1.x * 9.17909908294677734375f) - 0.5f) * 2.0f;
	                                _16063 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13183 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 9.17909908294677734375f)) + 1.0f;
	                                _16063 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12466 = (frac(input_TEXCOORD1.x * 9.17909908294677734375f) - 0.5f) * 2.0f;
	                                _13183 = (_12466 * input_TEXCOORD1.z) + float(int(sign(_12466)));
	                                _16063 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13183 = _4;
	                                _16063 = false;
	                                break;
	                            }
	                        }
	                        if (_16063)
	                        {
	                            _19456 = _13183;
	                            break;
	                        }
	                        _19456 = 1.0f;
	                        break;
	                    } while(false);
	                    float2 _8731 = (_11357.xy * float2(_12906, _19456)) + lerp(0.0f.xx, frac(float2(input_TEXCOORD1.x * 10.22360324859619140625f, input_TEXCOORD1.x * 7.56693744659423828125f)), _15588.xx);
	                    float _22686;
	                    do
	                    {
	                        float _13184;
	                        bool _16064;
	                        switch (_23505)
	                        {
	                            case 1u:
	                            {
	                                _13184 = input_TEXCOORD1.z + 1.0f;
	                                _16064 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13184 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16064 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13184 = input_TEXCOORD1.y;
	                                _16064 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13184 = input_TEXCOORD1.w;
	                                _16064 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13184 = input_COLOR0.w;
	                                _16064 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13184 = input_TEXCOORD3.w;
	                                _16064 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13184 = input_TEXCOORD3.x;
	                                _16064 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13184 = input_TEXCOORD3.y;
	                                _16064 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13184 = input_TEXCOORD3.z;
	                                _16064 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13184 = frac(input_TEXCOORD1.x * 27.2149562835693359375f);
	                                _16064 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13184 = (frac(input_TEXCOORD1.x * 27.2149562835693359375f) - 0.5f) * 2.0f;
	                                _16064 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13184 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 27.2149562835693359375f)) + 1.0f;
	                                _16064 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12467 = (frac(input_TEXCOORD1.x * 27.2149562835693359375f) - 0.5f) * 2.0f;
	                                _13184 = (_12467 * input_TEXCOORD1.z) + float(int(sign(_12467)));
	                                _16064 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13184 = _4;
	                                _16064 = false;
	                                break;
	                            }
	                        }
	                        if (_16064)
	                        {
	                            _22686 = _13184;
	                            break;
	                        }
	                        _22686 = 1.0f;
	                        break;
	                    } while(false);
	                    _10883 = float4(_8731.x, _8731.y * _11181.y, _11181.x, _22686);
	                    break;
	                }
	                else
	                {
	                    float _12960;
	                    do
	                    {
	                        float _13174;
	                        bool _16054;
	                        switch (_11757)
	                        {
	                            case 1u:
	                            {
	                                _13174 = input_TEXCOORD1.z + 1.0f;
	                                _16054 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13174 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16054 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13174 = input_TEXCOORD1.y;
	                                _16054 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13174 = input_TEXCOORD1.w;
	                                _16054 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13174 = input_COLOR0.w;
	                                _16054 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13174 = input_TEXCOORD3.w;
	                                _16054 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13174 = input_TEXCOORD3.x;
	                                _16054 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13174 = input_TEXCOORD3.y;
	                                _16054 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13174 = input_TEXCOORD3.z;
	                                _16054 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13174 = frac(input_TEXCOORD1.x * 33.658000946044921875f);
	                                _16054 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13174 = (frac(input_TEXCOORD1.x * 33.658000946044921875f) - 0.5f) * 2.0f;
	                                _16054 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13174 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 33.658000946044921875f)) + 1.0f;
	                                _16054 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12457 = (frac(input_TEXCOORD1.x * 33.658000946044921875f) - 0.5f) * 2.0f;
	                                _13174 = (_12457 * input_TEXCOORD1.z) + float(int(sign(_12457)));
	                                _16054 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13174 = _4;
	                                _16054 = false;
	                                break;
	                            }
	                        }
	                        if (_16054)
	                        {
	                            _12960 = _13174;
	                            break;
	                        }
	                        _12960 = 1.0f;
	                        break;
	                    } while(false);
	                    float _12904;
	                    do
	                    {
	                        float _13175;
	                        bool _16055;
	                        switch (_12834)
	                        {
	                            case 1u:
	                            {
	                                _13175 = input_TEXCOORD1.z + 1.0f;
	                                _16055 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13175 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16055 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13175 = input_TEXCOORD1.y;
	                                _16055 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13175 = input_TEXCOORD1.w;
	                                _16055 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13175 = input_COLOR0.w;
	                                _16055 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13175 = input_TEXCOORD3.w;
	                                _16055 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13175 = input_TEXCOORD3.x;
	                                _16055 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13175 = input_TEXCOORD3.y;
	                                _16055 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13175 = input_TEXCOORD3.z;
	                                _16055 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13175 = frac(input_TEXCOORD1.x * 7.327655792236328125f);
	                                _16055 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13175 = (frac(input_TEXCOORD1.x * 7.327655792236328125f) - 0.5f) * 2.0f;
	                                _16055 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13175 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 7.327655792236328125f)) + 1.0f;
	                                _16055 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12458 = (frac(input_TEXCOORD1.x * 7.327655792236328125f) - 0.5f) * 2.0f;
	                                _13175 = (_12458 * input_TEXCOORD1.z) + float(int(sign(_12458)));
	                                _16055 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13175 = _4;
	                                _16055 = false;
	                                break;
	                            }
	                        }
	                        if (_16055)
	                        {
	                            _12904 = _13175;
	                            break;
	                        }
	                        _12904 = 1.0f;
	                        break;
	                    } while(false);
	                    float _22648;
	                    do
	                    {
	                        float _13176;
	                        bool _16056;
	                        switch (_14729)
	                        {
	                            case 1u:
	                            {
	                                _13176 = input_TEXCOORD1.z + 1.0f;
	                                _16056 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13176 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16056 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13176 = input_TEXCOORD1.y;
	                                _16056 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13176 = input_TEXCOORD1.w;
	                                _16056 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13176 = input_COLOR0.w;
	                                _16056 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13176 = input_TEXCOORD3.w;
	                                _16056 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13176 = input_TEXCOORD3.x;
	                                _16056 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13176 = input_TEXCOORD3.y;
	                                _16056 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13176 = input_TEXCOORD3.z;
	                                _16056 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13176 = frac(input_TEXCOORD1.x * 9.17909908294677734375f);
	                                _16056 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13176 = (frac(input_TEXCOORD1.x * 9.17909908294677734375f) - 0.5f) * 2.0f;
	                                _16056 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13176 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 9.17909908294677734375f)) + 1.0f;
	                                _16056 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12459 = (frac(input_TEXCOORD1.x * 9.17909908294677734375f) - 0.5f) * 2.0f;
	                                _13176 = (_12459 * input_TEXCOORD1.z) + float(int(sign(_12459)));
	                                _16056 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13176 = _4;
	                                _16056 = false;
	                                break;
	                            }
	                        }
	                        if (_16056)
	                        {
	                            _22648 = _13176;
	                            break;
	                        }
	                        _22648 = 1.0f;
	                        break;
	                    } while(false);
	                    float _20617;
	                    do
	                    {
	                        float _13177;
	                        bool _16057;
	                        switch (uint((_10221 >> 4) & 15))
	                        {
	                            case 1u:
	                            {
	                                _13177 = input_TEXCOORD1.z + 1.0f;
	                                _16057 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13177 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16057 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13177 = input_TEXCOORD1.y;
	                                _16057 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13177 = input_TEXCOORD1.w;
	                                _16057 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13177 = input_COLOR0.w;
	                                _16057 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13177 = input_TEXCOORD3.w;
	                                _16057 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13177 = input_TEXCOORD3.x;
	                                _16057 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13177 = input_TEXCOORD3.y;
	                                _16057 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13177 = input_TEXCOORD3.z;
	                                _16057 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13177 = frac(input_TEXCOORD1.x * 17.6687908172607421875f);
	                                _16057 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13177 = (frac(input_TEXCOORD1.x * 17.6687908172607421875f) - 0.5f) * 2.0f;
	                                _16057 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13177 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 17.6687908172607421875f)) + 1.0f;
	                                _16057 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12460 = (frac(input_TEXCOORD1.x * 17.6687908172607421875f) - 0.5f) * 2.0f;
	                                _13177 = (_12460 * input_TEXCOORD1.z) + float(int(sign(_12460)));
	                                _16057 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13177 = _4;
	                                _16057 = false;
	                                break;
	                            }
	                        }
	                        if (_16057)
	                        {
	                            _20617 = _13177;
	                            break;
	                        }
	                        _20617 = 1.0f;
	                        break;
	                    } while(false);
	                    float2 _13164 = _21120.xy - 0.5f.xx;
	                    float _19474 = SpritecardVertexControls_t_1_m4.w * _20617;
	                    float _9168 = cos(_19474);
	                    float _25013 = sin(_19474);
	                    float _11442 = _13164.x;
	                    float _7574 = _13164.y;
	                    float4 _8992;
	                    _8992.x = (_11442 * _9168) + (_7574 * (-_25013));
	                    _8992.y = (_11442 * _25013) + (_7574 * _9168);
	                    float _21261;
	                    do
	                    {
	                        float _13178;
	                        bool _16058;
	                        switch (uint((_10221 >> 8) & 15))
	                        {
	                            case 1u:
	                            {
	                                _13178 = input_TEXCOORD1.z + 1.0f;
	                                _16058 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13178 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16058 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13178 = input_TEXCOORD1.y;
	                                _16058 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13178 = input_TEXCOORD1.w;
	                                _16058 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13178 = input_COLOR0.w;
	                                _16058 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13178 = input_TEXCOORD3.w;
	                                _16058 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13178 = input_TEXCOORD3.x;
	                                _16058 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13178 = input_TEXCOORD3.y;
	                                _16058 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13178 = input_TEXCOORD3.z;
	                                _16058 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13178 = frac(input_TEXCOORD1.x * 11.56761837005615234375f);
	                                _16058 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13178 = (frac(input_TEXCOORD1.x * 11.56761837005615234375f) - 0.5f) * 2.0f;
	                                _16058 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13178 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 11.56761837005615234375f)) + 1.0f;
	                                _16058 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12461 = (frac(input_TEXCOORD1.x * 11.56761837005615234375f) - 0.5f) * 2.0f;
	                                _13178 = (_12461 * input_TEXCOORD1.z) + float(int(sign(_12461)));
	                                _16058 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13178 = _4;
	                                _16058 = false;
	                                break;
	                            }
	                        }
	                        if (_16058)
	                        {
	                            _21261 = _13178;
	                            break;
	                        }
	                        _21261 = 1.0f;
	                        break;
	                    } while(false);
	                    float4 _20273 = float4((((_8992.xy / _13745.xy) * (1.0f / _12960)) + frac((_11357.xy * float2(_12904, _22648)) + 0.5f.xx)) + lerp(0.0f.xx, frac(float2(input_TEXCOORD1.x * 10.22360324859619140625f, input_TEXCOORD1.x * 7.56693744659423828125f)), _15588.xx), _21261, 1.0f);
	                    float4 _12905;
	                    if (_14700 >= 3u)
	                    {
	                        float _22340;
	                        do
	                        {
	                            float _13179;
	                            bool _16059;
	                            switch (uint((_10221 >> 12) & 15))
	                            {
	                                case 1u:
	                                {
	                                    _13179 = input_TEXCOORD1.z + 1.0f;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 2u:
	                                {
	                                    _13179 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 3u:
	                                {
	                                    _13179 = input_TEXCOORD1.y;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 4u:
	                                {
	                                    _13179 = input_TEXCOORD1.w;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 5u:
	                                {
	                                    _13179 = input_COLOR0.w;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 6u:
	                                {
	                                    _13179 = input_TEXCOORD3.w;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 7u:
	                                {
	                                    _13179 = input_TEXCOORD3.x;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 8u:
	                                {
	                                    _13179 = input_TEXCOORD3.y;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 9u:
	                                {
	                                    _13179 = input_TEXCOORD3.z;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 10u:
	                                {
	                                    _13179 = frac(input_TEXCOORD1.x * 16.0884227752685546875f);
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 11u:
	                                {
	                                    _13179 = (frac(input_TEXCOORD1.x * 16.0884227752685546875f) - 0.5f) * 2.0f;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 12u:
	                                {
	                                    _13179 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 16.0884227752685546875f)) + 1.0f;
	                                    _16059 = true;
	                                    break;
	                                }
	                                case 13u:
	                                {
	                                    float _12462 = (frac(input_TEXCOORD1.x * 16.0884227752685546875f) - 0.5f) * 2.0f;
	                                    _13179 = (_12462 * input_TEXCOORD1.z) + float(int(sign(_12462)));
	                                    _16059 = true;
	                                    break;
	                                }
	                                default:
	                                {
	                                    _13179 = _4;
	                                    _16059 = false;
	                                    break;
	                                }
	                            }
	                            if (_16059)
	                            {
	                                _22340 = _13179;
	                                break;
	                            }
	                            _22340 = 1.0f;
	                            break;
	                        } while(false);
	                        float4 _10002 = _20273;
	                        _10002.w = _22340;
	                        _12905 = _10002;
	                    }
	                    else
	                    {
	                        _12905 = _20273;
	                    }
	                    float _20309;
	                    do
	                    {
	                        float _13180;
	                        bool _16060;
	                        switch (_23505)
	                        {
	                            case 1u:
	                            {
	                                _13180 = input_TEXCOORD1.z + 1.0f;
	                                _16060 = true;
	                                break;
	                            }
	                            case 2u:
	                            {
	                                _13180 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                                _16060 = true;
	                                break;
	                            }
	                            case 3u:
	                            {
	                                _13180 = input_TEXCOORD1.y;
	                                _16060 = true;
	                                break;
	                            }
	                            case 4u:
	                            {
	                                _13180 = input_TEXCOORD1.w;
	                                _16060 = true;
	                                break;
	                            }
	                            case 5u:
	                            {
	                                _13180 = input_COLOR0.w;
	                                _16060 = true;
	                                break;
	                            }
	                            case 6u:
	                            {
	                                _13180 = input_TEXCOORD3.w;
	                                _16060 = true;
	                                break;
	                            }
	                            case 7u:
	                            {
	                                _13180 = input_TEXCOORD3.x;
	                                _16060 = true;
	                                break;
	                            }
	                            case 8u:
	                            {
	                                _13180 = input_TEXCOORD3.y;
	                                _16060 = true;
	                                break;
	                            }
	                            case 9u:
	                            {
	                                _13180 = input_TEXCOORD3.z;
	                                _16060 = true;
	                                break;
	                            }
	                            case 10u:
	                            {
	                                _13180 = frac(input_TEXCOORD1.x * 27.2149562835693359375f);
	                                _16060 = true;
	                                break;
	                            }
	                            case 11u:
	                            {
	                                _13180 = (frac(input_TEXCOORD1.x * 27.2149562835693359375f) - 0.5f) * 2.0f;
	                                _16060 = true;
	                                break;
	                            }
	                            case 12u:
	                            {
	                                _13180 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 27.2149562835693359375f)) + 1.0f;
	                                _16060 = true;
	                                break;
	                            }
	                            case 13u:
	                            {
	                                float _12463 = (frac(input_TEXCOORD1.x * 27.2149562835693359375f) - 0.5f) * 2.0f;
	                                _13180 = (_12463 * input_TEXCOORD1.z) + float(int(sign(_12463)));
	                                _16060 = true;
	                                break;
	                            }
	                            default:
	                            {
	                                _13180 = _4;
	                                _16060 = false;
	                                break;
	                            }
	                        }
	                        if (_16060)
	                        {
	                            _20309 = _13180;
	                            break;
	                        }
	                        _20309 = 1.0f;
	                        break;
	                    } while(false);
	                    float4 _18604 = _12905;
	                    _18604.w = _12905.w * _20309;
	                    _10883 = _18604;
	                    break;
	                }
	                break; // unreachable workaround
	            } while(false);
	            _12262 = _10883;
	            _19880 = float4(-1.0f, -1.0f, 1.0f, 0.0f);
	        }
	        float4 _12502;
	        if (clamp(SpritecardVertexControls_t_1_m9 & 262144u, 0u, 1u) == 1u)
	        {
	            int _9748 = int(SpritecardVertexControls_t_1_m4.z);
	            float _12837;
	            do
	            {
	                float _13186;
	                bool _16066;
	                switch (uint(_9748 & 15))
	                {
	                    case 1u:
	                    {
	                        _13186 = input_TEXCOORD1.z + 1.0f;
	                        _16066 = true;
	                        break;
	                    }
	                    case 2u:
	                    {
	                        _13186 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                        _16066 = true;
	                        break;
	                    }
	                    case 3u:
	                    {
	                        _13186 = input_TEXCOORD1.y;
	                        _16066 = true;
	                        break;
	                    }
	                    case 4u:
	                    {
	                        _13186 = input_TEXCOORD1.w;
	                        _16066 = true;
	                        break;
	                    }
	                    case 5u:
	                    {
	                        _13186 = input_COLOR0.w;
	                        _16066 = true;
	                        break;
	                    }
	                    case 6u:
	                    {
	                        _13186 = input_TEXCOORD3.w;
	                        _16066 = true;
	                        break;
	                    }
	                    case 7u:
	                    {
	                        _13186 = input_TEXCOORD3.x;
	                        _16066 = true;
	                        break;
	                    }
	                    case 8u:
	                    {
	                        _13186 = input_TEXCOORD3.y;
	                        _16066 = true;
	                        break;
	                    }
	                    case 9u:
	                    {
	                        _13186 = input_TEXCOORD3.z;
	                        _16066 = true;
	                        break;
	                    }
	                    case 10u:
	                    {
	                        _13186 = frac(input_TEXCOORD1.x * 238.839996337890625f);
	                        _16066 = true;
	                        break;
	                    }
	                    case 11u:
	                    {
	                        _13186 = (frac(input_TEXCOORD1.x * 238.839996337890625f) - 0.5f) * 2.0f;
	                        _16066 = true;
	                        break;
	                    }
	                    case 12u:
	                    {
	                        _13186 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 238.839996337890625f)) + 1.0f;
	                        _16066 = true;
	                        break;
	                    }
	                    case 13u:
	                    {
	                        float _12469 = (frac(input_TEXCOORD1.x * 238.839996337890625f) - 0.5f) * 2.0f;
	                        _13186 = (_12469 * input_TEXCOORD1.z) + float(int(sign(_12469)));
	                        _16066 = true;
	                        break;
	                    }
	                    default:
	                    {
	                        _13186 = _4;
	                        _16066 = false;
	                        break;
	                    }
	                }
	                if (_16066)
	                {
	                    _12837 = _13186;
	                    break;
	                }
	                _12837 = 1.0f;
	                break;
	            } while(false);
	            float _19167;
	            do
	            {
	                float _13187;
	                bool _16067;
	                switch (uint((_9748 >> 4) & 15))
	                {
	                    case 1u:
	                    {
	                        _13187 = input_TEXCOORD1.z + 1.0f;
	                        _16067 = true;
	                        break;
	                    }
	                    case 2u:
	                    {
	                        _13187 = (input_TEXCOORD1.z * SpritecardVertexControls_t_1_m1.w) + 1.0f;
	                        _16067 = true;
	                        break;
	                    }
	                    case 3u:
	                    {
	                        _13187 = input_TEXCOORD1.y;
	                        _16067 = true;
	                        break;
	                    }
	                    case 4u:
	                    {
	                        _13187 = input_TEXCOORD1.w;
	                        _16067 = true;
	                        break;
	                    }
	                    case 5u:
	                    {
	                        _13187 = input_COLOR0.w;
	                        _16067 = true;
	                        break;
	                    }
	                    case 6u:
	                    {
	                        _13187 = input_TEXCOORD3.w;
	                        _16067 = true;
	                        break;
	                    }
	                    case 7u:
	                    {
	                        _13187 = input_TEXCOORD3.x;
	                        _16067 = true;
	                        break;
	                    }
	                    case 8u:
	                    {
	                        _13187 = input_TEXCOORD3.y;
	                        _16067 = true;
	                        break;
	                    }
	                    case 9u:
	                    {
	                        _13187 = input_TEXCOORD3.z;
	                        _16067 = true;
	                        break;
	                    }
	                    case 10u:
	                    {
	                        _13187 = frac(input_TEXCOORD1.x * 84.74559783935546875f);
	                        _16067 = true;
	                        break;
	                    }
	                    case 11u:
	                    {
	                        _13187 = (frac(input_TEXCOORD1.x * 84.74559783935546875f) - 0.5f) * 2.0f;
	                        _16067 = true;
	                        break;
	                    }
	                    case 12u:
	                    {
	                        _13187 = (input_TEXCOORD1.z * frac(input_TEXCOORD1.x * 84.74559783935546875f)) + 1.0f;
	                        _16067 = true;
	                        break;
	                    }
	                    case 13u:
	                    {
	                        float _12470 = (frac(input_TEXCOORD1.x * 84.74559783935546875f) - 0.5f) * 2.0f;
	                        _13187 = (_12470 * input_TEXCOORD1.z) + float(int(sign(_12470)));
	                        _16067 = true;
	                        break;
	                    }
	                    default:
	                    {
	                        _13187 = _4;
	                        _16067 = false;
	                        break;
	                    }
	                }
	                if (_16067)
	                {
	                    _19167 = _13187;
	                    break;
	                }
	                _19167 = 1.0f;
	                break;
	            } while(false);
	            float4 _19841 = _19880;
	            _19841.z = 1.0f - _12837;
	            _19841.w = _19167;
	            _12502 = _19841;
	        }
	        else
	        {
	            float4 _14250 = _19880;
	            _14250.z = 1.0f;
	            _14250.w = 0.0f;
	            _12502 = _14250;
	        }
	        _9982 = _12262;
	        _23824 = _12502;
	    }
	    float3 _18058 = input_COLOR0.xyz * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((input_COLOR0.xyz * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (input_COLOR0.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _18058.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (input_COLOR0.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _18058.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19494;
	    if (input_COLOR0.z <= 0.040449999272823333740234375f)
	    {
	        _19494 = _18058.z;
	    }
	    else
	    {
	        _19494 = _7676.z;
	    }
	    float4 _12910 = lerp(input_COLOR0, float4(float3(_21354, _21355, _19494), input_COLOR0.w), float((int(SpritecardVertexControls_t_1_m4.z) >> 8) & 15).xxxx);
	    bool _9660 = _22646 == 3u;
	    bool _21166;
	    if (_9660)
	    {
	        _21166 = true;
	    }
	    else
	    {
	        _21166 = _22646 == 4u;
	    }
	    bool3 _18801 = _21166.xxx;
	    float3 _22185 = float3(_18801.x ? input_TEXCOORD4.x : float3(0.0f, 0.0f, 1.0f).x, _18801.y ? input_TEXCOORD4.y : float3(0.0f, 0.0f, 1.0f).y, _18801.z ? input_TEXCOORD4.z : float3(0.0f, 0.0f, 1.0f).z);
	    int _17152 = int(_22646);
	    float3 _13141;
	    float4 _13203;
	    float3 _24249;
	    do
	    {
	        if (_17152 == 5)
	        {
	            float _11440 = sin(input_TEXCOORD3.z);
	            float _20038 = cos(input_TEXCOORD3.z);
	            float _16880 = sin(input_TEXCOORD3.y);
	            float _13386 = cos(input_TEXCOORD3.y);
	            float _16881 = sin(input_TEXCOORD3.x);
	            float _13387 = cos(input_TEXCOORD3.x);
	            float3x3 _8134 = mul(mul(float3x3(float3(_13386, -_16880, 0.0f), float3(_16880, _13386, 0.0f), float3(0.0f, 0.0f, 1.0f)), float3x3(float3(_20038, 0.0f, _11440), float3(0.0f, 1.0f, 0.0f), float3(-_11440, 0.0f, _20038))), float3x3(float3(1.0f, 0.0f, 0.0f), float3(0.0f, _13387, -_16881), float3(0.0f, _16881, _13387)));
	            _13141 = _8134[1];
	            _13203 = _12910;
	            _24249 = mul(_8134, float3(input_TEXCOORD0.x + SpritecardVertexControls_t_1_m1.y, input_TEXCOORD0.y + SpritecardVertexControls_t_1_m1.z, 0.0f));
	            break;
	        }
	        float3 _11892;
	        float4 _13140;
	        float3 _16747;
	        if (_17152 == 0)
	        {
	            _13140 = _12910;
	            _11892 = PerViewConstantBuffer_t_1_m11;
	            _16747 = cross(PerViewConstantBuffer_t_1_m12, PerViewConstantBuffer_t_1_m11);
	        }
	        else
	        {
	            float4 _13139;
	            float3 _16401;
	            float3 _16482;
	            if (_17152 == 1)
	            {
	                _13139 = _12910;
	                _16401 = float3(0.0f, 0.0f, 1.0f);
	                _16482 = cross(float3(0.0f, 0.0f, 1.0f), PerViewConstantBuffer_t_1_m12);
	            }
	            else
	            {
	                float4 _13138;
	                float3 _16398;
	                float3 _16481;
	                if (_17152 == 2)
	                {
	                    _13138 = _12910;
	                    _16398 = float3(1.0f, 0.0f, 0.0f);
	                    _16481 = float3(0.0f, -1.0f, 0.0f);
	                }
	                else
	                {
	                    float4 _13137;
	                    float3 _16397;
	                    float3 _16480;
	                    if (_17152 == 3)
	                    {
	                        bool3 _24260 = (abs(_22185.z) > 0.100000001490116119384765625f).xxx;
	                        float3 _6350 = normalize(cross(_22185, float3(_24260.x ? float3(0.0f, -1.0f, 0.0f).x : float3(0.0f, 0.0f, 1.0f).x, _24260.y ? float3(0.0f, -1.0f, 0.0f).y : float3(0.0f, 0.0f, 1.0f).y, _24260.z ? float3(0.0f, -1.0f, 0.0f).z : float3(0.0f, 0.0f, 1.0f).z)));
	                        float4 _18608 = _12910;
	                        _18608.w = _12910.w * (1.0f - smoothstep(SpritecardVertexControls_t_1_m2.x, SpritecardVertexControls_t_1_m2.y, abs(dot(normalize(_22185), normalize(PerViewConstantBuffer_t_1_m10.xyz - _21709.xyz)))));
	                        _13137 = _18608;
	                        _16397 = _6350;
	                        _16480 = cross(_6350, _22185);
	                    }
	                    else
	                    {
	                        float4 _13136;
	                        float3 _16396;
	                        float3 _16479;
	                        if (_17152 == 4)
	                        {
	                            float3 _18756 = normalize(_22185);
	                            float4 _18607 = _12910;
	                            _18607.w = _12910.w * (1.0f - smoothstep(SpritecardVertexControls_t_1_m2.x, SpritecardVertexControls_t_1_m2.y, abs(dot(_18756, normalize(PerViewConstantBuffer_t_1_m10.xyz - _21709.xyz)))));
	                            _13136 = _18607;
	                            _16396 = normalize(cross(_22185, PerViewConstantBuffer_t_1_m12));
	                            _16479 = _18756;
	                        }
	                        else
	                        {
	                            _13136 = _12910;
	                            _16396 = float3(0.0f, 1.0f, 0.0f);
	                            _16479 = float3(1.0f, 0.0f, 0.0f);
	                        }
	                        _13137 = _13136;
	                        _16397 = _16396;
	                        _16480 = _16479;
	                    }
	                    _13138 = _13137;
	                    _16398 = _16397;
	                    _16481 = _16480;
	                }
	                _13139 = _13138;
	                _16401 = _16398;
	                _16482 = _16481;
	            }
	            _13140 = _13139;
	            _11892 = _16401;
	            _16747 = _16482;
	        }
	        float _13567 = cos(input_TEXCOORD3.x);
	        float _8404 = sin(input_TEXCOORD3.x);
	        float3 _18015 = (_11892 * _13567) - (_16747 * _8404);
	        float _19825 = sin(input_TEXCOORD3.y);
	        float _8898 = cos(input_TEXCOORD3.y);
	        float _9794 = _18015.x;
	        float _21144 = _9794 * _9794;
	        float _24619 = _18015.y;
	        float _7331 = _24619 * _24619;
	        float _6498 = _18015.z;
	        float _17752 = _6498 * _6498;
	        float _22876 = 1.0f - _8898;
	        float _10272 = (_9794 * _24619) * _22876;
	        float _21408 = _6498 * _19825;
	        float _6451 = (_6498 * _9794) * _22876;
	        float _22637 = _24619 * _19825;
	        float _6440 = (_24619 * _6498) * _22876;
	        float _22945 = _9794 * _19825;
	        float3x3 _23397 = float3x3(float3(_21144 + ((1.0f - _21144) * _8898), _10272 - _21408, _6451 + _22637), float3(_10272 + _21408, _7331 + ((1.0f - _7331) * _8898), _6440 - _22945), float3(_6451 - _22637, _6440 + _22945, _17752 + ((1.0f - _17752) * _8898)));
	        _13141 = mul(_23397, _22185);
	        _13203 = _13140;
	        _24249 = (mul(_23397, (_16747 * _13567) + (_11892 * _8404)) * (input_TEXCOORD0.x + SpritecardVertexControls_t_1_m1.y)) + (_18015 * (input_TEXCOORD0.y + SpritecardVertexControls_t_1_m1.z));
	        break;
	    } while(false);
	    float _20054 = length(PerViewConstantBuffer_t_1_m10.xyz - _21709.xyz);
	    float _10020;
	    float4 _24447;
	    if (SpritecardVertexControls_t_1_m2.z > 0.0f)
	    {
	        float _16605 = SpritecardVertexControls_t_1_m0.y * _20054;
	        float4 _20313;
	        if (input_TEXCOORD3.w > _16605)
	        {
	            float4 _12504;
	            if (input_TEXCOORD3.w > (SpritecardVertexControls_t_1_m0.z * _20054))
	            {
	                _12504 = 0.0f.xxxx;
	            }
	            else
	            {
	                _12504 = _13203 * (1.0f - ((input_TEXCOORD3.w - _16605) / (_20054 * (SpritecardVertexControls_t_1_m0.z - SpritecardVertexControls_t_1_m0.y))));
	            }
	            _20313 = _12504;
	        }
	        else
	        {
	            _20313 = _13203;
	        }
	        _10020 = min(max(input_TEXCOORD3.w, SpritecardVertexControls_t_1_m0.x * _20054), SpritecardVertexControls_t_1_m0.w * _20054);
	        _24447 = _20313;
	    }
	    else
	    {
	        _10020 = input_TEXCOORD3.w;
	        _24447 = _13203;
	    }
	    float3 _19803 = _21709.xyz + (_24249 * ((_24447.w < 0.0039215688593685626983642578125f) ? 0.0f : _10020));
	    float3 _7336 = _19803.xyz;
	    float4 _8056 = float4(_7336, 1.0f);
	    float4 _21447 = PerViewConstantBuffer_t_1_m9 * 1.0f;
	    float4 _18275 = mul(PerViewConstantBuffer_t_1_m0, (_8056 + _21447).xyzw);
	    float _24624 = _18275.w;
	    float4 _8847 = mul(PerViewConstantBuffer_t_1_m0, (float4((_19803 + (PerViewConstantBuffer_t_1_m12 * SpritecardVertexControls_t_1_m1.x)).xyz, 1.0f) + _21447).xyzw);
	    float4 _15598 = _18275;
	    _15598.z = max(_24624 * (_8847.z / _8847.w), min(0.001000000047497451305389404296875f, _18275.z));
	    float3 _11173 = _7336 - PerViewConstantBuffer_t_1_m10.xyz;
	    float3 _19671;
	    if (_9660)
	    {
	        _19671 = faceforward(_13141, _11173.xyz, _13141);
	    }
	    else
	    {
	        _19671 = normalize(-_11173.xyz);
	    }
	    bool3 _21236 = ((SpritecardVertexControls_t_1_m9 & 2048u) == 0u).xxx;
	    float3 _10685 = _7336 - PerViewConstantBufferCsgo_t_1_m2.xyz;
	    float3 _9877 = _15598.xyz / _24624.xxx;
	    float3 _7856 = _9877;
	    _7856.y = _9877.y * (-1.0f);
	    float2 _15813 = clamp((_7856.xy * 0.5f) + 0.5f.xx, 0.0f.xx, 1.0f.xx) * ((PerViewConstantBuffer_t_1_m5.xy * PerViewConstantBufferCsgo_t_1_m3) - 0.5f.xx);
	    float4 _23718;
	    _23718.x = _15813.x;
	    _23718.y = _15813.y;
	    float _22877 = (abs(_9877.z) * (PerViewConstantBuffer_t_1_m8 - PerViewConstantBuffer_t_1_m7)) + PerViewConstantBuffer_t_1_m7;
	    _23718.z = _22877;
	    bool4 _24464 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    bool _20058 = _24464.x;
	    float4 _19363;
	    if (_20058)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m1, _8056.xyzw);
	        float _20176 = _18621.w;
	        float2 _11441 = _18621.xy / _20176.xx;
	        _19363 = float4(clamp(((_11441.x + 1.0f) * PerViewConstantBuffer_t_1_m5.x) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m5.x - 1.0f), clamp(((1.0f - _11441.y) * PerViewConstantBuffer_t_1_m5.y) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m5.y - 1.0f), _22877, _20176);
	    }
	    else
	    {
	        _19363 = _23718;
	    }
	    uint2 _12083 = uint2(_19363.xy - PerViewConstantBuffer_t_1_m4.xy) >> PerViewLightingConstantBufferGpu_t_1_m7.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m6.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m7.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m6.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m6.x + (uint(clamp(abs(PerViewConstantBuffer_t_1_m13.x / ((PerViewConstantBuffer_t_1_m13.y * saturate((_19363.z * PerViewConstantBuffer_t_1_m2) + PerViewConstantBuffer_t_1_m3)) + PerViewConstantBuffer_t_1_m13.z)) * PerViewLightingConstantBufferGpu_t_1_m8.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m8.y)) * PerViewLightingConstantBufferGpu_t_1_m6.z);
	    float3 _13155;
	    _13155 = PerViewLightingConstantBufferGpu_t_1_m5.xyz + (PerViewLightingConstantBufferGpu_t_1_m9.xyz * 1.0f).xyz;
	    uint _21569;
	    float3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t_1_m6.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load((_10838 + _16208) * 4 + 0) & g_CullBits.Load((_23393 + _16208) * 4 + 0));
	        _13156 = _13155;
	        uint _20346;
	        float3 _12506;
	        uint _16209 = _14475;
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(firstbitlow(_16209) + (_16208 * 32u));
	            _20346 = _16209 & (_16209 - 1u);
	            do
	            {
	                float3 _14644 = _10685.xyz;
	                float4x4 _14097 = asfloat(uint4x4(g_BarnLights.Load(_12608 * 480 + 0), g_BarnLights.Load(_12608 * 480 + 16), g_BarnLights.Load(_12608 * 480 + 32), g_BarnLights.Load(_12608 * 480 + 48), g_BarnLights.Load(_12608 * 480 + 4), g_BarnLights.Load(_12608 * 480 + 20), g_BarnLights.Load(_12608 * 480 + 36), g_BarnLights.Load(_12608 * 480 + 52), g_BarnLights.Load(_12608 * 480 + 8), g_BarnLights.Load(_12608 * 480 + 24), g_BarnLights.Load(_12608 * 480 + 40), g_BarnLights.Load(_12608 * 480 + 56), g_BarnLights.Load(_12608 * 480 + 12), g_BarnLights.Load(_12608 * 480 + 28), g_BarnLights.Load(_12608 * 480 + 44), g_BarnLights.Load(_12608 * 480 + 60)));
	                float4 _24895 = mul(float4(_10685.xyz, 1.0f), _14097);
	                float3 _10521 = _24895.xyz / _24895.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21779 = _10521.z;
	                _22905.z = _21779;
	                float3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7424 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
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
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(_14644, 1.0f), _16509).xyz);
	                    _12886 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12886)
	                {
	                    _12506 = _13156;
	                    break;
	                }
	                float _23570 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w;
	                float _19826 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float3 _16268 = float3(_9058 - _19826, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) - _18492, (_23570 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z > 0.0f)
	                {
	                    _21316 = smoothstep(0.0f, 1.0f, _21779 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19668;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19668 = _21316 * smoothstep(0.0f, 1.0f, (1.0f - _21779) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
	                }
	                else
	                {
	                    _19668 = _21316;
	                }
	                float3 _11185;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz - _14644;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    float3 _20958 = _10017 - _16268;
	                    float3 _10275;
	                    do
	                    {
	                        float3 _20229 = (_10017 + _16268) - _20958;
	                        float _25105 = dot(-_20958, _20229);
	                        if (_25105 <= 0.0f)
	                        {
	                            _10275 = _20958;
	                            break;
	                        }
	                        else
	                        {
	                            _10275 = _20958 + (_20229 * min(1.0f, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11185 = _10017 / _17647.xxx;
	                    _11633 = ((_19668 * (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w))) * smoothstep(0.0f, 1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).y * _17647))) * saturate(asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).y * dot(float3((1.0f - (_23570 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)) - _18492, _9058 + _19826, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)), normalize(_10275))));
	                }
	                else
	                {
	                    _11185 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz;
	                    _11633 = _19668;
	                }
	                float3 _17828 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).xyz * 1.0f).xyz * _11633;
	                bool _24419;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).z > 0.0f)
	                {
	                    _24419 = !_20058;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                float3 _21570;
	                [branch]
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w == 0.0f)
	                {
	                    float _10351;
	                    do
	                    {
	                        float2 _22154 = abs(_22905.xy);
	                        if (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z == 0.0f)
	                        {
	                            _10351 = smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x, _22154.x) * smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0f / asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * _15017, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16525 = pow(max(pow(_11473, _15266) + pow(_15017, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            if (_11981 < _16525)
	                            {
	                                _10351 = smoothstep(_16525, _11981, 1.0f);
	                                break;
	                            }
	                            else
	                            {
	                                _10351 = float(_16525 > 1.0f);
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _21570 = _17828.xyz * _10351;
	                }
	                else
	                {
	                    float3 _12505;
	                    if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w < 0.0f)
	                    {
	                        float4 _17805 = float4(-asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).xyz, asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w);
	                        float4 _19008 = _17805.xyzw * float4(-1.0f, -1.0f, -1.0f, 1.0f);
	                        float3 _24989 = _19008.xyz;
	                        float3 _23629 = float4((-_11185).xyz, 0.0f).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        float3 _20480 = float4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        float3 _23592 = _17805.xyz;
	                        float3 _12170 = ((_20480 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w) + (_23592 * _15156)) + cross(_23592, _20480);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20562 = (_14081.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20490 = _14081;
	                        _20490.x = _20562.x;
	                        _20490.y = _20562.y;
	                        _12505 = _17828.xyz * g_tLightCookieTexture.SampleLevel(g_sTrilinearWrap, _20490.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20561 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20489 = _13791;
	                        _20489.x = _20561.x;
	                        _20489.y = _20561.y;
	                        _12505 = _17828.xyz * g_tLightCookieTexture.SampleLevel(g_sCookieSampler, _20489.xyz, 0.0f).xyz;
	                    }
	                    _21570 = _12505;
	                }
	                if (all(bool3(_21570.xyz.x == 0.0f.xxx.x, _21570.xyz.y == 0.0f.xxx.y, _21570.xyz.z == 0.0f.xxx.z)))
	                {
	                    _12506 = _13156;
	                    break;
	                }
	                float3 _19630;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load(_12608 * 480 + 264) & 4u) != 0u)
	                    {
	                        float2 _6281 = _22905.yx * float2(1.0f, -1.0f);
	                        float3 _23719 = _21642;
	                        _23719.x = _6281.x;
	                        _23719.y = _6281.y;
	                        _19629 = _23719;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t_1_m10);
	                        float2 _14615 = float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy;
	                        float _15310 = dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.z, PerViewLightingConstantBufferGpu_t_1_m3.z)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.y, PerViewLightingConstantBufferGpu_t_1_m3.z)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.z, PerViewLightingConstantBufferGpu_t_1_m3.y)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.y, PerViewLightingConstantBufferGpu_t_1_m3.y)).xy, _11455)).xyzw, 0.25f.xxxx);
	                        bool _12887;
	                        if (_15310 == 0.0f)
	                        {
	                            _12887 = true;
	                        }
	                        else
	                        {
	                            _12887 = _15310 == 1.0f;
	                        }
	                        if (_12887)
	                        {
	                            _24972 = _15310;
	                            break;
	                        }
	                        _24972 = ((_15310 * (PerViewLightingConstantBufferGpu_t_1_m0.w * 4.0f)) + dot(float4(g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.z, 0.0f)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(PerViewLightingConstantBufferGpu_t_1_m2.y, 0.0f)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(0.0f, PerViewLightingConstantBufferGpu_t_1_m3.y)).xy, _11455), g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, (_14615 + float2(0.0f, PerViewLightingConstantBufferGpu_t_1_m3.z)).xy, _11455)).xyzw, PerViewLightingConstantBufferGpu_t_1_m1.xxxx)) + (g_tShadowDepthBufferDepth.SampleCmpLevelZero(g_tShadowDepthBufferCmpSampler, _14615, _11455) * PerViewLightingConstantBufferGpu_t_1_m1.y);
	                        break;
	                    } while(false);
	                    float3 _19878 = _21570.xyz * lerp(1.0f, _24972, asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
	                    float3 _16449 = _19878.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
	                    {
	                        _12506 = _13156;
	                        break;
	                    }
	                    _19630 = _19878;
	                }
	                else
	                {
	                    _19630 = _21570;
	                }
	                _12506 = _13156.xyz + _19630.xyz;
	                break;
	            } while(false);
	            _13156 = _12506;
	            _16209 = _20346;
	            continue;
	        }
	        _21569 = _16208 + 1u;
	        _13155 = _13156;
	        _16208 = _21569;
	        continue;
	    }
	    float4 _23135 = 0.0f.xxxx;
	    _23135.x = _13155.x;
	    _23135.y = _13155.y;
	    _23135.z = _13155.z;
	    float3 _15752 = _23135.xyz + float3(PerViewLightingConstantBufferGpu_t_1_m4._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m4._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m4._m0[2].w).xyz;
	    float4 _20488 = _23135;
	    _20488.x = _15752.x;
	    _20488.y = _15752.y;
	    _20488.z = _15752.z;
	    output_0 = _9982;
	    output_1 = _24447;
	    output_2 = _19803;
	    output_3 = float3(_21236.x ? _19671.x : _5.x, _21236.y ? _19671.y : _5.y, _21236.z ? _19671.z : _5.z);
	    output_4 = _23824;
	    output_5 = _20488;
	    _15598.y = -_18275.y;
	    gl_Position = _15598;
	    gl_ClipDistance[0] = dot(_8056, PerViewConstantBuffer_t_1_m1.xyzw);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    input_TEXCOORD0 = stage_input.input_TEXCOORD0;
	    input_TEXCOORD1 = stage_input.input_TEXCOORD1;
	    input_TEXCOORD2 = stage_input.input_TEXCOORD2;
	    input_COLOR0 = stage_input.input_COLOR0;
	    input_POSITION0 = stage_input.input_POSITION0;
	    input_TEXCOORD3 = stage_input.input_TEXCOORD3;
	    input_TEXCOORD4 = stage_input.input_TEXCOORD4;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.gl_ClipDistance0.x = gl_ClipDistance[0];
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    stage_output.output_5 = output_5;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_GBUFFER, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_MODE_TOOLS_SHADING_COMPLEXITY, 0..1 );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_REVERSE_DEPTH, F_REVERSE_DEPTH );
	StaticCombo( S_MOTION_VECTORS, F_MOTION_VECTORS );
	StaticCombo( S_REFRACT, F_REFRACT );
	StaticCombo( S_OPAQUE, F_OPAQUE );
	StaticCombo( S_HSV_SHIFT, F_HSV_SHIFT );
	StaticCombo( S_DRAW_AS_TRAIL, F_DRAW_AS_TRAIL );
	StaticCombo( S_TEXTURE_LAYERS, F_TEXTURE_LAYERS );
	StaticCombo( S_PARTICLE_SHADOWS, F_PARTICLE_SHADOWS );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_REVERSE_DEPTH ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_MOTION_VECTORS ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_REFRACT ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_REFRACT ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_OPAQUE ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_OPAQUE ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_MODE_TOOLS_WIREFRAME ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_DRAW_AS_TRAIL ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_OPAQUE ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_REFRACT ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_REVERSE_DEPTH ) );
	StaticComboRule( Allow1( S_MODE_GBUFFER, S_PARTICLE_SHADOWS ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_PARTICLE_SHADOWS ) );
	StaticComboRule( Requires( S_MOTION_VECTORS, S_TEXTURE_LAYERS==0, S_TEXTURE_LAYERS==1, S_TEXTURE_LAYERS==2 ) );
	StaticComboRule( Allow1( S_PARTICLE_SHADOWS, S_REVERSE_DEPTH ) );
	StaticComboRule( Allow1( S_PARTICLE_SHADOWS, S_DRAW_AS_TRAIL ) );
	StaticComboRule( Allow1( S_PARTICLE_SHADOWS, S_REFRACT ) );
	StaticComboRule( Allow1( S_PARTICLE_SHADOWS, S_OPAQUE ) );
	DynamicCombo( D_DEPTH_FEATHERING, 0..1 );
	DynamicCombo( D_SCENE_DEPTH_MSAA, 0..1 );
	DynamicCombo( D_SHADOW_MODE, 0..1 );
	DynamicCombo( D_QUAD_OVERDRAW, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_PANORAMA_PARTICLE, 0..1 );
	DynamicComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, D_DEPTH_FEATHERING ) );
	DynamicComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, D_SCENE_DEPTH_MSAA ) );
	DynamicComboRule( Allow1( S_OPAQUE, D_DEPTH_FEATHERING ) );
	DynamicComboRule( Requires( D_SHADOW_MODE, S_MODE_GBUFFER ) );
	DynamicComboRule( Requires( D_QUAD_OVERDRAW, S_MODE_TOOLS_SHADING_COMPLEXITY ) );
	DynamicComboRule( Allow1( S_MODE_GBUFFER, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Allow1( S_OPAQUE, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_PANORAMA_PARTICLE, D_QUAD_OVERDRAW==0 ) );
	DynamicComboRule( Requires( D_PANORAMA_PARTICLE, S_MODE_TOOLS_VIS==0 ) );
	DynamicComboRule( Requires( D_PANORAMA_PARTICLE, S_MODE_TOOLS_SHADING_COMPLEXITY==0 ) );
	DynamicComboRule( Requires( D_PANORAMA_PARTICLE, S_MODE_TOOLS_WIREFRAME==0 ) );
	DynamicComboRule( Allow1( S_MODE_GBUFFER, D_PANORAMA_PARTICLE ) );
	DynamicComboRule( Allow1( S_PARTICLE_SHADOWS, D_PANORAMA_PARTICLE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_PANORAMA_PARTICLE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS2, D_PANORAMA_PARTICLE ) );
	
	RenderState(BlendEnable, true);
	RenderState(BlendOp, F_LIGHTEN_MODE ? Max : Add);
	RenderState(ColorWriteEnable0, None);
	RenderState(ColorWriteEnable0, R|G);
	RenderState(ColorWriteEnable0, R|G|B);
	RenderState(DepthFunc, F_DISABLE_DEPTHTEST ? Always : LessEqual);
	RenderState(DepthWriteEnable, false);
	RenderState(DstBlend, F_LIGHTEN_MODE || (F_MOD2X ? 2 : 5));
	RenderState(DstBlendAlpha, One);
	RenderState(SrcBlend, F_MOD2X ? DestColor : One);
	RenderState(SrcBlendAlpha, F_MOD2X ? Zero : InvDestAlpha);
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tBaseTexture < Attribute("BaseTexture"); SrgbRead(true); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tDepthTexture < Attribute("SceneDepth"); SrgbRead(false); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tFrameBufferCopyTexture < Attribute("FrameBufferCopyTexture"); SrgbRead(true); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tMotionVectors < Attribute("MotionVectorsTexture"); SrgbRead(false); >;
	Texture2D g_tParticleShadow < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	RWTexture2D<float4> g_tQuadOverdrawMutexUAV < Attribute("QuadOverdrawMutexUAV"); >;
	RWTexture2D<float4> g_tQuadOverdrawUAV < Attribute("QuadOverdrawUAV"); >;
	Texture3D g_tRandom < Attribute("RandomReflection"); SrgbRead(false); >;
	Texture2D g_tShadowDepthMapAtlas < Attribute("ShadowDepthMapAtlas"); SrgbRead(false); >;
	Texture2D g_tTextureLayer1 < Attribute("TextureLayer1"); SrgbRead(true); >;
	Texture2D g_tTextureLayer2 < Attribute("TextureLayer2"); SrgbRead(true); >;
	Texture2D g_tTextureLayer3 < Attribute("TextureLayer3"); SrgbRead(true); >;
	Texture2D g_tTextureLayer4 < Attribute("TextureLayer4"); SrgbRead(true); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	float4 g_vShadingComplexity < Source(ShadingComplexity); UiType(VectorText); >;
	
	#if (S_REFRACT == 1)
		RenderState(ColorWriteEnable0, R|G|B);
	#endif
	#if (S_REVERSE_DEPTH == 1)
		RenderState(ColorWriteEnable0, R|G|B);
	#endif
	#if (S_OPAQUE == 1)
		RenderState(ColorWriteEnable0, R|G|B);
	#endif
	#if (S_MODE_TOOLS_WIREFRAME == 1)
		RenderState(ColorWriteEnable0, R|G|B);
	#endif
	
	// Variant parameters
	RenderState(ColorWriteEnable0, None);
	RenderState(ColorWriteEnable0, R|G);
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float _2;
	static float4 _3;
	static float4 _4;
	
	static const float3 _2617[15] = { 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, float3(0.0f, 1.0f, 0.0f), float3(1.0f, 0.0f, 0.0f), float3(1.0f, 0.0f, 1.0f), 0.0f.xxx, 0.0f.xxx, float3(0.0f, 1.0f, 0.0f), 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx, 0.0f.xxx };
	static const float2 _368[15] = { float2(1.0f, 0.0f), 0.0f.xx, float2(0.0f, 1.0f), 0.0f.xx, float2(1.0f, 0.0f), float2(1.0f, 0.0f), 0.0f.xx, float2(0.0f, 1.0f), 0.0f.xx, float2(1.0f, 0.0f), float2(1.0f, 0.0f), float2(1.0f, 0.0f), 0.0f.xx, 0.0f.xx, 0.0f.xx };
	
	cbuffer SpriteCardPixelControls_t : register(b4, space1)
	{
	    float4 SpriteCardPixelControls_t_1_m0 : packoffset(c0);
	    float4 SpriteCardPixelControls_t_1_m1 : packoffset(c1);
	    float4 SpriteCardPixelControls_t_1_m2 : packoffset(c3);
	    float4 SpriteCardPixelControls_t_1_m3 : packoffset(c4);
	    float4 SpriteCardPixelControls_t_1_m4 : packoffset(c5);
	    float4 SpriteCardPixelControls_t_1_m5 : packoffset(c6);
	    float4 SpriteCardPixelControls_t_1_m6 : packoffset(c8);
	    float4 SpriteCardPixelControls_t_1_m7 : packoffset(c9);
	    uint2 SpriteCardPixelControls_t_1_m8 : packoffset(c19);
	    uint SpriteCardPixelControls_t_1_m9 : packoffset(c19.z);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float3 PerViewConstantBuffer_t_1_m0 : packoffset(c26);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b6, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m3 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m4 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m5 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m6 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c34);
	};
	
	SamplerState AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1 : register(s17, space1);
	Texture2D<float4> g_tBaseTexture : register(t38, space1);
	SamplerState Filter_MinMagMipLinear_MaxAniso_1 : register(s15, space1);
	TextureCube<float4> g_tFogCubeTexture : register(t43, space1);
	SamplerState g_sTrilinearClamp : register(s21, space1);
	
	static float4 input_0;
	static float4 input_1;
	static float3 input_2;
	static float4 input_4;
	static float4 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD0;
	    float4 input_1 : TEXCOORD1;
	    float3 input_2 : TEXCOORD2;
	    nointerpolation float4 input_4 : TEXCOORD4;
	    float4 input_5 : TEXCOORD5;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    bool _13055;
	    uint _17422 = SpriteCardPixelControls_t_1_m9 & 1u;
	    bool _21944 = _17422 != 0u;
	    float4 _15476 = input_0.xyzw;
	    _15476.x = input_0.x;
	    _15476.z = input_0.z;
	    int _9501 = int(SpriteCardPixelControls_t_1_m2.z);
	    float4 _12885;
	    do
	    {
	        _13055 = float(_9501 & 1) == 1.0f;
	        if (_13055)
	        {
	            _12885 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _15476.xy);
	            break;
	        }
	        _12885 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _15476.xy);
	        break;
	    } while(false);
	    float4 _19707;
	    if (_21944)
	    {
	        float3 _22667 = _12885.xyz - float3(0.005859375f, 0.009765625f, 0.005859375f);
	        float4 _22101 = _12885;
	        _22101.x = _22667.x;
	        _22101.y = _22667.y;
	        _22101.z = _22667.z;
	        _19707 = _22101;
	    }
	    else
	    {
	        _19707 = _12885;
	    }
	    float4 _21709;
	    if ((SpriteCardPixelControls_t_1_m9 & 32768u) > 0u)
	    {
	        float4 _12502;
	        if (input_4.x > (-1.0f))
	        {
	            float4 _12886;
	            do
	            {
	                if (_13055)
	                {
	                    _12886 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _15476.zw);
	                    break;
	                }
	                _12886 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _15476.zw);
	                break;
	            } while(false);
	            float4 _12904;
	            if (_21944)
	            {
	                float3 _22668 = _12886.xyz - float3(0.005859375f, 0.009765625f, 0.005859375f);
	                float4 _22102 = _12886;
	                _22102.x = _22668.x;
	                _22102.y = _22668.y;
	                _22102.z = _22668.z;
	                _12904 = _22102;
	            }
	            else
	            {
	                _12904 = _12886;
	            }
	            int _21358;
	            do
	            {
	                if ((SpriteCardPixelControls_t_1_m9 & 1024u) != 0u)
	                {
	                    _21358 = ((SpriteCardPixelControls_t_1_m9 & 65536u) == 1u) ? 2 : 1;
	                    break;
	                }
	                else
	                {
	                    _21358 = 0;
	                    break;
	                }
	                break; // unreachable workaround
	            } while(false);
	            bool4 _8974 = (_21358 == 0).xxxx;
	            float4 _7078;
	            if (_21358 == 1)
	            {
	                _7078 = lerp(_19707, _12904, input_4.x.xxxx);
	            }
	            else
	            {
	                _7078 = float4(_8974.x ? _19707.x : 0.0f.xxxx.x, _8974.y ? _19707.y : 0.0f.xxxx.y, _8974.z ? _19707.z : 0.0f.xxxx.z, _8974.w ? _19707.w : 0.0f.xxxx.w);
	            }
	            float4 _12501;
	            if (_21358 == 2)
	            {
	                float _10302 = (1.0f - input_4.x) * sqrt(max(0.001000000047497451305389404296875f, dot(_19707.xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f))));
	                float _18360 = input_4.x * sqrt(max(0.001000000047497451305389404296875f, dot(_12904.xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f))));
	                _12501 = ((_19707 * _10302) + (_12904 * _18360)) / (_18360 + _10302).xxxx;
	            }
	            else
	            {
	                _12501 = _7078;
	            }
	            _12502 = _12501;
	        }
	        else
	        {
	            _12502 = _19707;
	        }
	        _21709 = _12502;
	    }
	    else
	    {
	        _21709 = _19707;
	    }
	    int _15090 = int(SpriteCardPixelControls_t_1_m8.x);
	    uint3 _11720 = uint3(float3(float(uint((int(SpriteCardPixelControls_t_1_m8.y) >> 16) & 15)), float(uint(_15090 & 15)), float(uint(((_15090 & 255) >> 4) & 15))));
	    uint _12528 = _11720.y;
	    uint _24623 = _11720.z;
	    float4 _12887;
	    do
	    {
	        float4 _13174;
	        bool _16054;
	        [branch]
	        switch (_11720.x)
	        {
	            case 0u:
	            {
	                _13174 = _21709;
	                _16054 = true;
	                break;
	            }
	            case 1u:
	            {
	                float _11534 = frac(SpriteCardPixelControls_t_1_m6.z * input_0.z);
	                float _16439 = _11534 / (((-0.39999997615814208984375f) * (1.0f - _11534)) + 1.0f);
	                float4 _22205 = _15476 - 0.5f.xxxx;
	                float4 _17630 = (_22205 * lerp(4.0f, 1.0f, _16439)) + 0.5f.xxxx;
	                float4 _6627 = (_22205 * lerp(1.0f, 0.0625f, _16439)) + 0.5f.xxxx;
	                float4 _12906;
	                do
	                {
	                    if (_13055)
	                    {
	                        _12906 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _17630.xy);
	                        break;
	                    }
	                    _12906 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _17630.xy);
	                    break;
	                } while(false);
	                float4 _19630;
	                do
	                {
	                    if (_13055)
	                    {
	                        _19630 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _6627.xy);
	                        break;
	                    }
	                    _19630 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _6627.xy);
	                    break;
	                } while(false);
	                float4 _10911 = lerp(_19630.xyzw, _12906.xyzw, (_16439 * _16439).xxxx);
	                _10911.w = lerp(_21709.w, _10911.w, float(_2617[int(_12528)].y != 1.0f));
	                _13174 = _10911;
	                _16054 = true;
	                break;
	            }
	            case 3u:
	            {
	                float3 _23252 = _21709.xyz * 12.9200000762939453125f;
	                float3 _7486 = (pow(_21709.xyz, 0.4166666567325592041015625f.xxx) * 1.05499994754791259765625f) - 0.054999999701976776123046875f.xxx;
	                float _21356;
	                if (_21709.x <= 0.003130800090730190277099609375f)
	                {
	                    _21356 = _23252.x;
	                }
	                else
	                {
	                    _21356 = _7486.x;
	                }
	                float _19458;
	                if (_21709.y <= 0.003130800090730190277099609375f)
	                {
	                    _19458 = _23252.y;
	                }
	                else
	                {
	                    _19458 = _7486.y;
	                }
	                float2 _20343 = _15476.xy - (((float3(_21356, _19458, _2).xy - 0.5f.xx) * 2.0f) * (((SpriteCardPixelControls_t_1_m6.w * input_0.w) * 0.125f) * _21709.w));
	                float4 _12504;
	                do
	                {
	                    if (_13055)
	                    {
	                        _12504 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _20343.xy);
	                        break;
	                    }
	                    _12504 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _20343.xy);
	                    break;
	                } while(false);
	                _13174 = _12504;
	                _16054 = true;
	                break;
	            }
	            case 4u:
	            {
	                float _11533 = frac(SpriteCardPixelControls_t_1_m6.z * input_0.z);
	                float _16438 = _11533 / (((-0.39999997615814208984375f) * (1.0f - _11533)) + 1.0f);
	                float4 _22204 = _15476 - 0.5f.xxxx;
	                float4 _17629 = (_22204 * lerp(4.0f, 1.0f, _16438)) + 0.5f.xxxx;
	                float4 _6626 = (_22204 * lerp(1.0f, 0.0625f, _16438)) + 0.5f.xxxx;
	                float4 _12905;
	                do
	                {
	                    if (_13055)
	                    {
	                        _12905 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _17629.xy);
	                        break;
	                    }
	                    _12905 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _17629.xy);
	                    break;
	                } while(false);
	                float4 _19629;
	                do
	                {
	                    if (_13055)
	                    {
	                        _19629 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _6626.xy);
	                        break;
	                    }
	                    _19629 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _6626.xy);
	                    break;
	                } while(false);
	                float4 _10910 = lerp(_19629.xyzw, _12905.xyzw, (_16438 * _16438).xxxx);
	                float3 _9674 = _10910.xyz;
	                float3 _23251 = _9674 * 12.9200000762939453125f;
	                float3 _9166 = (pow(_9674, 0.4166666567325592041015625f.xxx) * 1.05499994754791259765625f) - 0.054999999701976776123046875f.xxx;
	                float _23035;
	                if (_10910.x <= 0.003130800090730190277099609375f)
	                {
	                    _23035 = _23251.x;
	                }
	                else
	                {
	                    _23035 = _9166.x;
	                }
	                float _19457;
	                if (_10910.y <= 0.003130800090730190277099609375f)
	                {
	                    _19457 = _23251.y;
	                }
	                else
	                {
	                    _19457 = _9166.y;
	                }
	                float2 _20342 = _15476.xy - (((float3(_23035, _19457, _2).xy - 0.5f.xx) * 2.0f) * (((SpriteCardPixelControls_t_1_m6.w * input_0.w) * 0.125f) * lerp(_21709.w, _10910.w, float(_2617[int(_12528)].y != 1.0f))));
	                float4 _12503;
	                do
	                {
	                    if (_13055)
	                    {
	                        _12503 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _20342.xy);
	                        break;
	                    }
	                    _12503 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _20342.xy);
	                    break;
	                } while(false);
	                _13174 = _12503;
	                _16054 = true;
	                break;
	            }
	            case 2u:
	            {
	                int _8289 = int(_12528);
	                float4 _20655 = _368[_8289].y.xxxx;
	                float4 _9219 = lerp(lerp(float4(_21709.xyz * _21709.www, 1.0f), _21709, _368[_8289].x.xxxx), _21709.wwww, _20655);
	                float3 _25122 = _9219.xyz;
	                float3 _17379 = _25122 * 12.9200000762939453125f;
	                float3 _7485 = (pow(_25122, 0.4166666567325592041015625f.xxx) * 1.05499994754791259765625f) - 0.054999999701976776123046875f.xxx;
	                float _21354;
	                if (_9219.x <= 0.003130800090730190277099609375f)
	                {
	                    _21354 = _17379.x;
	                }
	                else
	                {
	                    _21354 = _7485.x;
	                }
	                float _21355;
	                if (_9219.y <= 0.003130800090730190277099609375f)
	                {
	                    _21355 = _17379.y;
	                }
	                else
	                {
	                    _21355 = _7485.y;
	                }
	                float _19456;
	                if (_9219.z <= 0.003130800090730190277099609375f)
	                {
	                    _19456 = _17379.z;
	                }
	                else
	                {
	                    _19456 = _7485.z;
	                }
	                float2 _14593 = float2((dot(float3(_21354, _21355, _19456).xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f)) + input_0.x) * input_0.z, input_0.y);
	                float4 _20940;
	                do
	                {
	                    if (_13055)
	                    {
	                        _20940 = g_tBaseTexture.Sample(AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipLinear_MaxAniso_1, _14593.xy);
	                        break;
	                    }
	                    _20940 = g_tBaseTexture.Sample(Filter_MinMagMipLinear_MaxAniso_1, _14593.xy);
	                    break;
	                } while(false);
	                float4 _19793 = _20940;
	                _19793.w = dot(_20940.xyz, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
	                float4 _6690 = _20940;
	                _6690.w = _21709.w;
	                _13174 = lerp(_6690, _19793, _20655);
	                _16054 = true;
	                break;
	            }
	            default:
	            {
	                _13174 = _3;
	                _16054 = false;
	                break;
	            }
	        }
	        if (_16054)
	        {
	            _12887 = _13174;
	            break;
	        }
	        _12887 = _21709;
	        break;
	    } while(false);
	    float _12907;
	    if (((_9501 >> 12) & 1) != 0)
	    {
	        _12907 = SpriteCardPixelControls_t_1_m6.y * input_0.w;
	    }
	    else
	    {
	        _12907 = SpriteCardPixelControls_t_1_m6.y;
	    }
	    float4 _12908;
	    switch (_12528)
	    {
	        case 0u:
	        {
	            float4 _22456 = _12887;
	            _22456.w = lerp(1.0f, 0.0f, float(_24623 == 4u));
	            _12908 = _22456;
	            break;
	        }
	        case 1u:
	        {
	            _12908 = _12887;
	            break;
	        }
	        case 2u:
	        {
	            float3 _14141 = lerp(1.0f.xxx, 0.0f.xxx, float(_24623 == 4u).xxx);
	            float4 _17848 = _12887;
	            _17848.x = _14141.x;
	            _17848.y = _14141.y;
	            _17848.z = _14141.z;
	            _12908 = _17848;
	            break;
	        }
	        case 3u:
	        {
	            float4 _16296 = _12887;
	            _16296.w = _12887.w;
	            _12908 = _16296;
	            break;
	        }
	        case 4u:
	        {
	            _12908 = float4(lerp(1.0f.xxx, _12887.xyz, _12887.w.xxx), 1.0f);
	            break;
	        }
	        case 5u:
	        {
	            _12908 = float4(lerp(1.0f.xxx, _12887.xyz, dot(_12887.xyz, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)).xxx), 1.0f);
	            break;
	        }
	        case 6u:
	        {
	            float4 _12954 = _12887;
	            _12954.w = dot(_12887.xyz, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
	            _12908 = _12954;
	            break;
	        }
	        case 7u:
	        {
	            _12908 = float4(lerp(1.0f.xxx, 0.0f.xxx, float(_24623 == 4u).xxx), dot(_12887.xyz, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)));
	            break;
	        }
	        case 8u:
	        {
	            _12908 = float4(1.0f, 1.0f, 1.0f, dot(_12887.xyz, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)));
	            break;
	        }
	        case 9u:
	        {
	            float4 _22473 = float4(_12887.xxx, 1.0f);
	            float3 _14140 = lerp(_22473.yzw, 0.0f.xxx, float(_24623 == 4u).xxx);
	            float4 _17847 = _22473;
	            _17847.y = _14140.x;
	            _17847.z = _14140.y;
	            _17847.w = _14140.z;
	            _12908 = _17847;
	            break;
	        }
	        case 10u:
	        {
	            float4 _22472 = float4(_12887.yyy, 1.0f);
	            float3 _14139 = lerp(_22472.xzw, 0.0f.xxx, float(_24623 == 4u).xxx);
	            float4 _17846 = _22472;
	            _17846.x = _14139.x;
	            _17846.z = _14139.y;
	            _17846.w = _14139.z;
	            _12908 = _17846;
	            break;
	        }
	        case 11u:
	        {
	            float4 _22471 = float4(_12887.zzz, 1.0f);
	            float3 _14138 = lerp(_22471.xyw, 0.0f.xxx, float(_24623 == 4u).xxx);
	            float4 _17845 = _22471;
	            _17845.x = _14138.x;
	            _17845.y = _14138.y;
	            _17845.w = _14138.z;
	            _12908 = _17845;
	            break;
	        }
	        case 12u:
	        {
	            float4 _22470 = _12887.x.xxxx;
	            float2 _14137 = lerp(_22470.yz, 0.0f.xx, float(_24623 == 4u).xx);
	            float4 _17844 = _22470;
	            _17844.y = _14137.x;
	            _17844.z = _14137.y;
	            _12908 = _17844;
	            break;
	        }
	        case 13u:
	        {
	            float4 _22469 = _12887.y.xxxx;
	            float2 _14136 = lerp(_22469.xz, 0.0f.xx, float(_24623 == 4u).xx);
	            float4 _17843 = _22469;
	            _17843.x = _14136.x;
	            _17843.z = _14136.y;
	            _12908 = _17843;
	            break;
	        }
	        case 14u:
	        {
	            float4 _22468 = _12887.z.xxxx;
	            float2 _14135 = lerp(_22468.xy, 0.0f.xx, float(_24623 == 4u).xx);
	            float4 _17842 = _22468;
	            _17842.x = _14135.x;
	            _17842.y = _14135.y;
	            _12908 = _17842;
	            break;
	        }
	        default:
	        {
	            _12908 = _12887;
	            break;
	        }
	    }
	    float4 _18229;
	    switch (_24623)
	    {
	        case 0u:
	        {
	            _18229 = _12908;
	            break;
	        }
	        case 3u:
	        {
	            _18229 = 1.0f.xxxx + _12908.xyzw;
	            break;
	        }
	        case 4u:
	        {
	            _18229 = 1.0f.xxxx - _12908.xyzw;
	            break;
	        }
	        case 1u:
	        {
	            _18229 = _12908.xyzw * 2.0f.xxxx;
	            break;
	        }
	        case 2u:
	        {
	            _18229 = _12908;
	            break;
	        }
	        case 5u:
	        {
	            _18229 = (1.0f.xxxx + _12908.xyzw) * 0.5f;
	            break;
	        }
	        case 6u:
	        {
	            float3 _17602 = 1.0f.xxx * dot(_12908.xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
	            float4 _8673 = _12908;
	            _8673.x = _17602.x;
	            _8673.y = _17602.y;
	            _8673.z = _17602.z;
	            _18229 = _8673;
	            break;
	        }
	        default:
	        {
	            _18229 = _12908;
	            break;
	        }
	    }
	    float4 _11015 = max(lerp(1.0f.xxxx, _18229, _12907.xxxx), 0.0f.xxxx);
	    float3 _21122 = _11015.xyz * input_1.xyz;
	    float _12758 = _21122.x;
	    float4 _23714 = _11015;
	    _23714.x = _12758;
	    _23714.y = _21122.y;
	    _23714.z = _21122.z;
	    float _19376 = _11015.w;
	    uint _19935 = clamp(SpriteCardPixelControls_t_1_m9 & 262144u, 0u, 1u);
	    float4 _19631;
	    if (_19935 == 0u)
	    {
	        float4 _21710;
	        [branch]
	        if (SpriteCardPixelControls_t_1_m0.w < SpriteCardPixelControls_t_1_m0.z)
	        {
	            _21710 = float4(_12758, _21122.yz, smoothstep(SpriteCardPixelControls_t_1_m0.w, SpriteCardPixelControls_t_1_m0.z, _19376));
	        }
	        else
	        {
	            _21710 = _23714;
	        }
	        bool _12888;
	        if (_19376 >= SpriteCardPixelControls_t_1_m5.x)
	        {
	            _12888 = _19376 <= SpriteCardPixelControls_t_1_m5.w;
	        }
	        else
	        {
	            _12888 = false;
	        }
	        float4 _12505;
	        [branch]
	        if (_12888)
	        {
	            float _21711;
	            if (_19376 <= SpriteCardPixelControls_t_1_m5.z)
	            {
	                _21711 = smoothstep(SpriteCardPixelControls_t_1_m5.x, SpriteCardPixelControls_t_1_m5.z, _19376);
	            }
	            else
	            {
	                _21711 = smoothstep(SpriteCardPixelControls_t_1_m5.w, SpriteCardPixelControls_t_1_m5.y, _19376);
	            }
	            _12505 = lerp(_21710, SpriteCardPixelControls_t_1_m4, _21711.xxxx);
	        }
	        else
	        {
	            _12505 = _21710;
	        }
	        _19631 = _12505;
	    }
	    else
	    {
	        _19631 = _23714;
	    }
	    float3 _7733 = lerp(_19631.xyz, dot(_19631.xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f)).xxx, SpriteCardPixelControls_t_1_m7.x.xxx);
	    float4 _17849 = _19631;
	    _17849.x = _7733.x;
	    _17849.y = _7733.y;
	    _17849.z = _7733.z;
	    float4 _21103 = SpriteCardPixelControls_t_1_m3.xyzw * _17849.xyzw;
	    float _12460 = _21103.w + SpriteCardPixelControls_t_1_m6.x;
	    float4 _14171 = _21103;
	    _14171.w = _12460;
	    float4 _6905;
	    if ((SpriteCardPixelControls_t_1_m9 & 1024u) != 0u)
	    {
	        float4 _18986 = _14171;
	        _18986.w = saturate(_12460);
	        _6905 = _18986;
	    }
	    else
	    {
	        _6905 = _14171;
	    }
	    float4 _19283;
	    if (_19935 != 0u)
	    {
	        float _20523 = max(SpriteCardPixelControls_t_1_m5.x, _6905.w);
	        float _15029 = _6905.w - SpriteCardPixelControls_t_1_m0.w;
	        float4 _13727 = _6905;
	        _13727.w = min(saturate(((input_4.z + input_4.w) - _6905.w) / ((_6905.w + SpriteCardPixelControls_t_1_m0.z) - _6905.w)) * _20523, (saturate((input_4.z - _15029) / (_6905.w - _15029)) * (-_20523)) + _20523) * max(SpriteCardPixelControls_t_1_m5.y, input_1.w);
	        _19283 = _13727;
	    }
	    else
	    {
	        float4 _18602 = _6905;
	        _18602.w = _6905.w * input_1.w;
	        _19283 = _18602;
	    }
	    float3 _11507 = _19283.xyz * (((input_5.xyz * SpriteCardPixelControls_t_1_m0.y) + SpriteCardPixelControls_t_1_m0.x.xxx) + input_5.w.xxx);
	    float4 _23715;
	    _23715.x = _11507.x;
	    _23715.y = _11507.y;
	    _23715.z = _11507.z;
	    float _21712;
	    if ((SpriteCardPixelControls_t_1_m9 & 524288u) != 0u)
	    {
	        _21712 = saturate(_19283.w * 128.0f);
	    }
	    else
	    {
	        _21712 = _19283.w;
	    }
	    float4 _11008;
	    float _13494;
	    if (_21944)
	    {
	        float3 _25193 = lerp(0.5f.xxx, lerp(0.5f.xxx, _19283.xyz, input_1.xyz).xyz, _21712.xxx);
	        float4 _17852;
	        _17852.x = _25193.x;
	        _17852.y = _25193.y;
	        _17852.z = _25193.z;
	        _11008 = _17852;
	        _13494 = _21712;
	    }
	    else
	    {
	        float4 _19688;
	        if ((SpriteCardPixelControls_t_1_m9 & 16u) != 0u)
	        {
	            float3 _16714 = _23715.xyz * SpriteCardPixelControls_t_1_m1.z;
	            float4 _8674;
	            _8674.x = _16714.x;
	            _8674.y = _16714.y;
	            _8674.z = _16714.z;
	            _19688 = _8674;
	        }
	        else
	        {
	            _19688 = _23715;
	        }
	        float4 _10894;
	        float _13264;
	        if ((SpriteCardPixelControls_t_1_m9 & 128u) != 0u)
	        {
	            float4 _13213;
	            float _15671;
	            if (_17422 == 0u)
	            {
	                float3 _3895 = input_2.xyz - PerViewConstantBuffer_t_1_m0.xyz;
	                bool4 _24464 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	                float4 _22475;
	                [branch]
	                if (_24464.y)
	                {
	                    float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m1.xy + (PerViewConstantBufferCsgo_t_1_m1.zw * float2(length(_3895.xyz), input_2.z)), 0.0f.xx, 1.0f.xx);
	                    float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m2.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m2.y)) * PerViewConstantBufferCsgo_t_1_m3.w;
	                    float3 _25191 = lerp(float4(PerViewConstantBufferCsgo_t_1_m3.xyz, _12872).xyz * SpriteCardPixelControls_t_1_m1.w, _19688.xyz, (1.0f - _12872).xxx);
	                    float4 _17850;
	                    _17850.x = _25191.x;
	                    _17850.y = _25191.y;
	                    _17850.z = _25191.z;
	                    _22475 = _17850;
	                }
	                else
	                {
	                    _22475 = _19688;
	                }
	                float4 _13212;
	                float _15670;
	                [branch]
	                if (_24464.z)
	                {
	                    float _14602 = saturate(pow(max(0.0f, (length(_3895.xyz) * PerViewConstantBufferCsgo_t_1_m4.y) + PerViewConstantBufferCsgo_t_1_m4.x), PerViewConstantBufferCsgo_t_1_m4.w)) * saturate(pow(max(0.0f, (input_2.z * PerViewConstantBufferCsgo_t_1_m5.y) + PerViewConstantBufferCsgo_t_1_m5.x), PerViewConstantBufferCsgo_t_1_m5.z));
	                    float _13668 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m7.w;
	                    float _24483 = 1.0f - _13668;
	                    float3 _25192 = lerp(float4((g_tFogCubeTexture.SampleLevel(g_sTrilinearClamp, normalize(mul(float4(_3895.xyz, 0.0f), PerViewConstantBufferCsgo_t_1_m6).xyz).xyz, PerViewConstantBufferCsgo_t_1_m5.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m4.z))) * PerViewConstantBufferCsgo_t_1_m8.x).xyz, _13668).xyz * SpriteCardPixelControls_t_1_m1.w, _22475.xyz, _24483.xxx);
	                    float4 _17851;
	                    _17851.x = _25192.x;
	                    _17851.y = _25192.y;
	                    _17851.z = _25192.z;
	                    _13212 = _17851;
	                    _15670 = _21712 * _24483;
	                }
	                else
	                {
	                    _13212 = _22475;
	                    _15670 = _21712;
	                }
	                _13213 = _13212;
	                _15671 = _15670;
	            }
	            else
	            {
	                _13213 = _19688;
	                _15671 = _21712;
	            }
	            _10894 = _13213;
	            _13264 = _15671;
	        }
	        else
	        {
	            _10894 = _19688;
	            _13264 = _21712;
	        }
	        float3 _22606 = _10894.xyz * lerp(_13264, 1.0f, saturate(-SpriteCardPixelControls_t_1_m1.w));
	        float4 _8675;
	        _8675.x = _22606.x;
	        _8675.y = _22606.y;
	        _8675.z = _22606.z;
	        _11008 = _8675;
	        _13494 = _13264;
	    }
	    float4 _23992 = float4(_11008.xyz, _13494 * abs(SpriteCardPixelControls_t_1_m1.w));
	    float4 _6805;
	    if (_21944)
	    {
	        float3 _16279 = clamp(_23992.xyz, 0.0f.xxx, 1.0f.xxx);
	        float4 _13514 = _23992;
	        _13514.x = _16279.x;
	        _13514.y = _16279.y;
	        _13514.z = _16279.z;
	        _6805 = _13514;
	    }
	    else
	    {
	        _6805 = _23992;
	    }
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_4 = stage_input.input_4;
	    input_5 = stage_input.input_5;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, true);
	
}
