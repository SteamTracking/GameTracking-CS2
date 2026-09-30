//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader for debugging LPV sample points.";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: gs, ps, vs
}

MODES
{
	Depth(S_MODE_DEPTH);
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
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
	float3 vPositionOs  : POSITION0  < Semantic( PosXyz ); >;                                     
	float2 nInstanceIdx : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                        
};

VS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_POINT_TO_CUBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1125
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    float _m7;
	};
	
	struct _1119
	{
	    row_major float3x4 _m0;
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	
	static float3 vPositionOs;
	static uint nInstanceIdx;
	static float3 output_0;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint nInstanceIdx : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	};
	
	void MainVs_inner()
	{
	    float3x4 _6463 = asfloat(uint3x4(g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 32)));
	    output_0 = mul(_6463, float4(vPositionOs.xyz, 1.0f));
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	
}

GS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_POINT_TO_CUBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Color
	float g_flPointSize < Default(4); Range(0, 16); UiType(Slider); UiGroup("Color, 10/25"); Expression(pointsize); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported shader stage.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	layout(points) in;
	layout(max_vertices = 4, triangle_strip) out;
	
	struct _1368
	{
	    mat4 _m0;
	    vec4 _m1;
	    vec3 _m2;
	    vec3 _m3;
	};
	
	layout(set = 2) uniform _1368 PerViewConstantBuffer_t;
	
	struct _985
	{
	    float _m0;
	};
	
	layout(set = 2) uniform _985 undetermined;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 2) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 input_0[1];
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec4 output_1;
	
	void main()
	{
	    vec3 _17615 = normalize(input_0[0] - PerViewConstantBuffer_t._m2);
	    vec3 _11686 = cross(_17615, PerViewConstantBuffer_t._m3).xyz;
	    vec4 _9918 = vec4(input_0[0], undetermined._m0 * 0.5);
	    vec3 _16500 = input_0[0] - (_17615 * undetermined._m0);
	    float _25224 = undetermined._m0 * (-0.60000002384185791015625);
	    vec3 _21046 = _16500 + (_11686 * _25224);
	    float _13108 = 0.60000002384185791015625 * undetermined._m0;
	    vec3 _8702 = PerViewConstantBuffer_t._m3 * _13108;
	    vec3 _7336 = (_21046 + _8702).xyz;
	    vec4 _21447 = PerViewConstantBuffer_t._m1 * 1.0;
	    vec4 _20663 = (vec4(_7336, 1.0) + _21447).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = _7336 - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _9918;
	    _20663.y = -_20663.y;
	    gl_Position = _20663;
	    EmitVertex();
	    vec3 _24428 = PerViewConstantBuffer_t._m3 * _25224;
	    vec3 _8552 = (_21046 + _24428).xyz;
	    vec4 _18907 = (vec4(_8552, 1.0) + _21447).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = _8552 - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _9918;
	    _18907.y = -_18907.y;
	    gl_Position = _18907;
	    EmitVertex();
	    vec3 _15138 = _16500 + (_11686 * _13108);
	    vec3 _7753 = (_15138 + _8702).xyz;
	    vec4 _18908 = (vec4(_7753, 1.0) + _21447).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = _7753 - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _9918;
	    _18908.y = -_18908.y;
	    gl_Position = _18908;
	    EmitVertex();
	    vec3 _18190 = (_15138 + _24428).xyz;
	    vec4 _18909 = (vec4(_18190, 1.0) + _21447).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = _18190 - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _9918;
	    _18909.y = -_18909.y;
	    gl_Position = _18909;
	    EmitVertex();
	    EndPrimitive();
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	
}

PS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_POINT_TO_CUBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_BAKED_LIGHTING_FROM_PROBE ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCubeArray g_tFallbackCubemap < Attribute("LowShaderQualityFallbackCubemap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Color
	float3 g_vAlbedo < Default3(0.5, 0.5, 0.5); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(albedo)); >;
	float g_flMetalness < UiType(Slider); UiGroup("Color,10/30"); Expression(metalness); >;
	float g_flRoughness < Default(0.5); UiType(Slider); UiGroup("Color,10/30"); Expression(roughness); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vAlbedo) cannot be expressed with either HLSL packing layout or packoffset.
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
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	struct _2339
	{
	    vec4 _m0[3];
	};
	
	struct _2549
	{
	    vec4 _m0[4];
	};
	
	struct _1069
	{
	    mat4 _m0[4];
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
	
	vec3 _3;
	vec4 _4;
	
	struct _1194
	{
	    vec2 _m0;
	    vec2 _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 1) uniform _1194 PerViewConstantBuffer_t;
	
	struct _1862
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    mat4 _m2;
	    vec2 _m3;
	    float _m4;
	    vec4 _m5;
	    vec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    mat4 _m11;
	    vec4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	};
	
	layout(set = 1) uniform _1862 PerViewConstantBufferCsgo_t;
	
	struct _1092
	{
	    vec3 g_vAlbedo;
	    float g_flRoughness;
	    float g_flMetalness;
	    int g_bFogEnabled;
	    float g_flReflectance;
	};
	
	layout(set = 1) uniform _1092 _Globals_;
	
	struct _2731
	{
	    _2339 _m0;
	    _2549 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uvec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    int _m11;
	    float _m12;
	    vec4 _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	    float _m17;
	    _1069 _m18;
	    _2549 _m19;
	};
	
	layout(set = 3) uniform _2731 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 22) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 18) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 23) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 49) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 41) uniform textureCubeArray g_tFallbackCubemap;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec4 input_1;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec3 _17493 = normalize((input_0 + PerViewConstantBufferCsgo_t._m14.xyz) - PerViewConstantBuffer_t._m3.xyz);
	    vec3 _7812 = PerViewConstantBuffer_t._m3.xyz - input_1.xyz;
	    float _14320 = dot(_17493, _7812);
	    float _15399 = (_14320 * _14320) - (dot(_7812, _7812) - (input_1.w * input_1.w));
	    if (_15399 < 0.0)
	    {
	        discard;
	    }
	    float _23182 = -_14320;
	    float _9680;
	    if (_15399 > 0.0)
	    {
	        _9680 = _23182 - sqrt(_15399);
	    }
	    else
	    {
	        _9680 = _23182;
	    }
	    vec3 _19221 = PerViewConstantBuffer_t._m3.xyz + (_17493 * _9680);
	    vec3 _15840 = normalize(_19221 - input_1.xyz);
	    vec3 _21875 = _19221 - PerViewConstantBufferCsgo_t._m14.xyz;
	    vec4 _17590 = gl_FragCoord;
	    _17590.w = 1.0 / _17590.w;
	    vec3 _12351 = mix(vec3(_Globals_.g_flReflectance).xyz, _Globals_.g_vAlbedo.xyz, vec3(_Globals_.g_flMetalness));
	    vec3 _17892 = mix(vec3(1.0), _15840, bvec3(all(bvec3(true))));
	    vec3 _10560 = _15840.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21813 = max(vec2(_Globals_.g_flRoughness).xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _15598 = -_15840;
	    vec3 _24735 = _15840.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21709;
	    if (_24464.x)
	    {
	        vec2 _10547 = ((floor(_17590.xy * PerViewConstantBufferCsgo_t._m4) * PerViewConstantBufferCsgo_t._m3.xy) + (PerViewConstantBufferCsgo_t._m3.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10547).xyzw - _17590.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m3.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12286)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m3.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m2.x * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.y * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.z * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.w * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _24735), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _24735), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _24735), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _24735)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21709 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10547 + mix(_23169, PerViewConstantBufferCsgo_t._m3.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21709 = 1.0;
	    }
	    vec3 _6606 = _21875.xyz;
	    float _21710;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	            {
	                _13136 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(_21875.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                vec3 _20488 = _19470;
	                _20488.x = _20561.x;
	                _20488.y = _20561.y;
	                _13136 = saturate(_22193.x * _22193.y);
	                _14975 = _20488;
	                _10191 = _13039;
	                break;
	            }
	            _23989 = _13039 + 1;
	            _13039 = _23989;
	            continue;
	        }
	        float _18423;
	        if (_10191 >= 0)
	        {
	            float _18270 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	            float _12501;
	            SPIRV_CROSS_BRANCH
	            if (_13136 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(_21875.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                    vec3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12501 = mix(_7934, _18270, _13136);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _18423 = _12501;
	        }
	        else
	        {
	            _18423 = 1.0;
	        }
	        float _13279 = mix(_18423, 1.0, saturate((distance(_19221.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16));
	        float _12502;
	        if (_24464.y)
	        {
	            _12502 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_17590.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21710 = _12502;
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _24735) * _21710) > 0.0)
	    {
	        float _11797 = max(0.0, dot(_10560, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec2 _9840 = max(_21813, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_19221.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21710).xyz;
	        _9716 = ((_12351.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _11797).xyz * _16808;
	        _24878 = PerViewLightingConstantBufferGpu_t._m4.xyz + (vec3(_11797).xyz * _16808);
	    }
	    else
	    {
	        _9716 = vec3(0.0);
	        _24878 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19363;
	    if (_20059)
	    {
	        vec4 _18621 = vec4(_19221.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m2;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _17590;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m0.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13137;
	    vec3 _16324;
	    _13137 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    vec3 _13138;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13138 = _13137;
	        _16325 = _16324;
	        uint _20344;
	        vec3 _13212;
	        vec3 _15670;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_17018)) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(_21875.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
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
	                bool _12885;
	                if (!_7424)
	                {
	                    _12885 = true;
	                }
	                else
	                {
	                    _12885 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(_6606, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12885)
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23572 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = min(1.0, _21776 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21776) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - _6606;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * saturate(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11179 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24419 = !_20059;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                vec3 _21548;
	                SPIRV_CROSS_BRANCH
	                if (g_BarnLights_1._m0[_12608]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights_1._m0[_12608]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.x, _22154.x) * smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
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
	                    vec3 _12503;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20492.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20491.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _22671;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13138;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _22671 = _20482;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                float _11798 = max(0.0, dot(_10560, _11179.xyz));
	                vec2 _9841 = max(_21813, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11179.xyz + (-normalize(_19221.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz);
	                float _19211 = max(0.0, dot(_11179.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13138.xyz + (((_12351.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _11798).xyz * _22671.xyz);
	                _15670 = _16325.xyz + (vec3(_11798).xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13138 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13137 = _13138;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21813.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17138 = normalize(_19221.xyz - PerViewConstantBuffer_t._m3.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _7507)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _20418 = vec3(_21709).xyz;
	    vec3 _22686 = (_16324.xyz + (_8745 * _20418).xyz) * (_Globals_.g_vAlbedo.xyz * (1.0 - _Globals_.g_flMetalness)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, 1.0);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15752 = _11203.xyz + (_13137.xyz * _20418).xyz;
	    vec4 _20490 = _11203;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    vec3 _15734 = _20490.xyz + ((((mix(_11427.xxx, _11427.yyy, _12351) * textureLod(samplerCubeArray(g_tFallbackCubemap, g_sTrilinearClamp), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _20418).xyz;
	    vec4 _13888 = _20490;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _19221.xyz - PerViewConstantBuffer_t._m3.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12886;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m8.x)
	            {
	                _12886 = (_19221.z * PerViewConstantBufferCsgo_t._m8.z) < PerViewConstantBufferCsgo_t._m8.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12886)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m5.xy + (PerViewConstantBufferCsgo_t._m5.zw * vec2(length(_21493), _19221.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m6.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m6.y)) * PerViewConstantBufferCsgo_t._m7.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m7.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12887;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m12.x)
	            {
	                _12887 = (PerViewConstantBufferCsgo_t._m12.z * _19221.z) < PerViewConstantBufferCsgo_t._m12.y;
	            }
	            else
	            {
	                _12887 = false;
	            }
	            if (_12887)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m9.y) + PerViewConstantBufferCsgo_t._m9.x), PerViewConstantBufferCsgo_t._m9.w)) * saturate(pow(max(0.0, (_19221.z * PerViewConstantBufferCsgo_t._m10.y) + PerViewConstantBufferCsgo_t._m10.x), PerViewConstantBufferCsgo_t._m10.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m12.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m11 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m10.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m9.z))) * PerViewConstantBufferCsgo_t._m13.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _6805 = _23944;
	    }
	    else
	    {
	        _6805 = _13888;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	
}
