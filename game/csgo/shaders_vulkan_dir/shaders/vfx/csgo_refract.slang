//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Refraction";
	DevShader = false;
	Version = 2;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	CsgoForward();
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
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;             
	float4 vColor                     : COLOR0         < Semantic( Color ); >;                     // S_VERTEX_COLOR=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;    // D_COMPRESSED_NORMALS_AND_TANGENTS=1
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
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Texture Transform
	float g_flTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Texture Transform"); >;
	float2 g_vSecondaryTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Texture Transform"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Texture Transform"); Expression(v0 = g_flTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vTexCoordScale;
		v4 = this;
		-.5*v3*float2(v1-v2,v2+v1)+v4+.5); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Texture Transform"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vTexCoordOffset) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
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
	    mat3x4 _m0;
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _1224
	{
	    mat4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _1224 PerViewConstantBuffer_t;
	
	struct _1030
	{
	    vec2 g_vTexCoordScale;
	    vec2 g_vTexCoordOffset;
	};
	
	layout(set = 0) uniform _1030 _Globals_;
	
	layout(location = 5) in uint nInstanceIdx;
	layout(location = 4) in uvec4 vBlendIndices;
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec2 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec4 output_3;
	
	void main()
	{
	    uint _13771 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5 >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    }
	    vec3 _22401;
	    if (_13771 > 0u)
	    {
	        _22401 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].z);
	    }
	    else
	    {
	        _22401 = vec3(1.0);
	    }
	    vec3 _11198 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    vec3 _12861 = (vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0).xyz;
	    vec3 _24912 = _11198.xyz;
	    vec3 _12151 = vec4(vPositionOs.xyz * _22401.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _17895 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _12868 = vec4(vTexCoord, 0.0, 1.0);
	    output_0 = _11198;
	    output_1 = vec2(dot(_12868, vec4(_Globals_.g_vTexCoordScale.x, 0.0, 0.0, 0.0)), dot(_12868, vec4(0.0, _Globals_.g_vTexCoordScale.y, 0.0, 0.0))).xy + _Globals_.g_vTexCoordOffset.xy;
	    output_2 = _12151;
	    output_3 = vec4(normalize(_12861 - (_24912 * dot(_12861, _24912))), vTangentUOs_flTangentVSign.w);
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
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
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tFrameBufferCopyTexture < Attribute("FrameBufferCopyTexture"); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RGBA, MipNormal(TextureNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal2 < Channel(RGBA, MipNormal(TextureNormal2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tRefractTint < Channel(RGBA, MipNormal(TextureTintTexture), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float4 g_vFBCopyTextureRect < Default2(0, 0); Attribute("FrameBufferCopyRectangle"); UiType(VectorText); >;
	
	// Refraction
	CreateInputTexture2D(TextureNormal, Linear, 8, "", "_normal", "Refraction", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureNormal2, Linear, 8, "", "_normal", "Refraction", Default4(0.5, 0.5, 1, 0));
	float g_flRefractScale < Default(0.1); Range(0, 4); UiType(Slider); UiGroup("Refraction"); >;
	
	// Tinting
	CreateInputTexture2D(TextureTintTexture, Linear, 8, "", "", "Tinting", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Tinting"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _3;
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c21);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_g_vFBCopyTextureRect : packoffset(c0);
	    float _Globals_1_g_flRefractScale : packoffset(c1);
	    float3 _Globals_1_g_vColorTint : packoffset(c1.y);
	};
	
	Texture2D<float4> g_tNormal : register(t31, space1);
	SamplerState DefaultSamplerState_0 : register(s15, space1);
	Texture2D<float4> g_tFrameBufferCopyTexture : register(t30, space1);
	SamplerState Filter_MinMagMipLinear : register(s14, space1);
	
	static float4 gl_FragCoord;
	static float2 input_1;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_1 : TEXCOORD1;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _20877 = g_tNormal.Sample(DefaultSamplerState_0, input_1.xy);
	    float3 _7707 = (_20877.xyz * 2.0f) - 1.0f.xxx;
	    float4 _22101;
	    _22101.x = _7707.x;
	    _22101.y = _7707.y;
	    float _10894 = _20877.w;
	    float2 _12200 = (_22101.xy * (_10894 * _Globals_1_g_flRefractScale)) + ((gl_FragCoord.xy - PerViewConstantBuffer_t_1_m0.xy).xy * PerViewConstantBuffer_t_1_m1.xy).xy;
	    output_0 = float4(g_tFrameBufferCopyTexture.Sample(Filter_MinMagMipLinear, float2(lerp(_Globals_1_g_vFBCopyTextureRect.x, _Globals_1_g_vFBCopyTextureRect.z, _12200.x), lerp(_Globals_1_g_vFBCopyTextureRect.y, _Globals_1_g_vFBCopyTextureRect.w, _12200.y)).xy).xyz * _Globals_1_g_vColorTint, _10894);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, true);
	BoolAttribute(bWantsFBCopyTexture, true);
	
}
