//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Refraction";
	DevShader = false;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Forward();
	Refractions();
}

FEATURES
{
	Feature( F_USE_REFRACTED_ALPHA, 0..1, "" );
	Feature( F_BLUR, 0..1, "Refraction" );
	Feature( F_SECONDARY_NORMAL, 0..1, "Refraction" );
	Feature( F_VERTEX_COLOR, 0..1, "Tinting" );
	Feature( F_TINT_TEXTURE, 0..1, "Tinting" );
	FeatureRule( Allow1( F_BLUR, F_USE_REFRACTED_ALPHA ), "Blur and refracted alpha are incompatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor                     : COLOR0         < Semantic( Color ); >;                     // S_VERTEX_COLOR=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;    // D_COMPRESSED_NORMALS_AND_TANGENTS=1
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_BLEND_WEIGHT_COUNT=1, D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vBlendWeight               : BLENDWEIGHT0   < Semantic( BlendWeight ); >;               // D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                    // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                   
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;            // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_VERTEX_COLOR, F_VERTEX_COLOR );
	StaticCombo( S_SECONDARY_NORMAL, F_SECONDARY_NORMAL );
	StaticCombo( S_TINT_TEXTURE, F_TINT_TEXTURE );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Texture Transform
	float2 g_vSecondaryTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Texture Transform"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Texture Transform"); >;
	
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
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float2 _Globals_1_g_vTexCoordScale : packoffset(c0);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static float4 vTangentUOs_flTangentVSign;
	static uint nInstanceIdx;
	static float3 output_0;
	static float2 output_1;
	static float3 output_2;
	static float4 output_3;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	    float3 vNormalOs : NORMAL0;
	    float4 vTangentUOs_flTangentVSign : TANGENT0;
	    uint nInstanceIdx : TEXCOORD13;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float2 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float4 output_3 : TEXCOORD3;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float3x4 _9216 = float3x4(g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 32));
	    float3 _14293 = normalize(mul(_9216, float4(vNormalOs.xyz, 0.0f)));
	    float3 _12861 = mul(_9216, float4(vTangentUOs_flTangentVSign.xyz, 0.0f)).xyz;
	    float3 _24912 = _14293.xyz;
	    float3 _19956 = mul(_9216, float4(vPositionOs.xyz, 1.0f));
	    float4 _17895 = mul(PerViewConstantBuffer_t_1_m0, (float4(_19956.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _12868 = float4(vTexCoord, 0.0f, 1.0f);
	    output_0 = _14293;
	    output_1 = float2(dot(_12868, float4(_Globals_1_g_vTexCoordScale.x, 0.0f, 0.0f, 0.0f)), dot(_12868, float4(0.0f, _Globals_1_g_vTexCoordScale.y, 0.0f, 0.0f)));
	    output_2 = _19956;
	    output_3 = float4(normalize(_12861 - (_24912 * dot(_12861, _24912))), vTangentUOs_flTangentVSign.w);
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    vTangentUOs_flTangentVSign = stage_input.vTangentUOs_flTangentVSign;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_VERTEX_COLOR, F_VERTEX_COLOR );
	StaticCombo( S_SECONDARY_NORMAL, F_SECONDARY_NORMAL );
	StaticCombo( S_TINT_TEXTURE, F_TINT_TEXTURE );
	StaticCombo( S_BLUR, F_BLUR );
	StaticCombo( S_USE_REFRACTED_ALPHA, F_USE_REFRACTED_ALPHA );
	StaticComboRule( Allow1( S_BLUR, S_USE_REFRACTED_ALPHA ) );
	
	Texture2D g_tFrameBufferCopyTexture < Attribute("FrameBufferCopyTexture"); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RGBA, MipNormal(TextureNormal), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tNormal2 < Channel(RGBA, MipNormal(TextureNormal2), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tRefractTint < Channel(RGBA, MipNormal(TextureTintTexture), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	float4 g_vFBCopyTextureRect < Default4(0, 0, 1, 1); Attribute("FrameBufferCopyRectangle"); UiType(VectorText); >;
	
	// Refraction
	CreateInputTexture2D(TextureNormal, Linear, 8, "", "_normal", "Refraction", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureNormal2, Linear, 8, "", "_normal", "Refraction", Default4(0.5, 0.5, 1, 0));
	float g_flRefractScale < Default(0.1); Range(0, 4); UiType(Slider); UiGroup("Refraction"); >;
	
	// Tinting
	CreateInputTexture2D(TextureTintTexture, Linear, 8, "", "", "Tinting", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Tinting"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vFBCopyTextureRect) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	vec4 _3;
	
	struct _1408
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec3 _m3;
	    vec3 _m4;
	    float _m5;
	    float _m6;
	    float _m7;
	    float _m8;
	};
	
	layout(set = 1) uniform _1408 PerViewConstantBuffer_t;
	
	struct _1096
	{
	    vec4 g_vFBCopyTextureRect;
	    float g_flRefractScale;
	    vec3 g_vColorTint;
	};
	
	layout(set = 1) uniform _1096 _Globals_;
	
	layout(set = 1, binding = 31) uniform texture2D g_tNormal;
	layout(set = 1, binding = 15) uniform sampler DefaultSamplerState_0;
	layout(set = 1, binding = 30) uniform texture2D g_tFrameBufferCopyTexture;
	layout(set = 1, binding = 14) uniform sampler Filter_MinMagMipLinear;
	
	layout(location = 1) in vec2 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _20877 = texture(sampler2D(g_tNormal, DefaultSamplerState_0), input_1.xy);
	    vec3 _7707 = (_20877.xyz * 2.0) - vec3(1.0);
	    vec4 _22101;
	    _22101.x = _7707.x;
	    _22101.y = _7707.y;
	    float _10894 = _20877.w;
	    vec2 _12200 = (_22101.xy * (_10894 * _Globals_.g_flRefractScale)) + ((gl_FragCoord.xy - PerViewConstantBuffer_t._m1.xy).xy * PerViewConstantBuffer_t._m2.xy).xy;
	    vec4 _14779 = vec4(texture(sampler2D(g_tFrameBufferCopyTexture, Filter_MinMagMipLinear), vec2(mix(_Globals_.g_vFBCopyTextureRect.x, _Globals_.g_vFBCopyTextureRect.z, _12200.x), mix(_Globals_.g_vFBCopyTextureRect.y, _Globals_.g_vFBCopyTextureRect.w, _12200.y)).xy).xyz * _Globals_.g_vColorTint, _10894);
	    vec3 _19800 = mix(_14779.xyz, PerViewConstantBuffer_t._m4.xyz, vec3(saturate(min(PerViewConstantBuffer_t._m7, pow(saturate((distance(input_2.xyz, PerViewConstantBuffer_t._m3.xyz) * PerViewConstantBuffer_t._m6) + PerViewConstantBuffer_t._m5), PerViewConstantBuffer_t._m8)))));
	    vec4 _17842 = _14779;
	    _17842.x = _19800.x;
	    _17842.y = _19800.y;
	    _17842.z = _19800.z;
	    vec3 _11003 = _17842.xyz * PerViewConstantBuffer_t._m0;
	    vec4 _8673 = _17842;
	    _8673.x = _11003.x;
	    _8673.y = _11003.y;
	    _8673.z = _11003.z;
	    output_0 = _8673;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, true);
	
}
