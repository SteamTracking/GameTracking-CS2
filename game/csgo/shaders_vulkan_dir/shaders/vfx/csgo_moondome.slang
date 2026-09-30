//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "(S1) moondome shader for CSGO.";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	Depth("csgo_depth_only.vfx");
	Default();
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                           // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	uint4  nPackedFrame  : NORMAL0        < Semantic( CompressedTangentFrame ); >;                
	float4 vNormalOs     : NORMAL0        < Semantic( Normal ); >;                                
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                 // D_CS_VERTEX_ANIMATION=0
	float2 vLightmapUV   : TEXCOORD3      < Semantic( LightmapUV ); >;                             // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float2 vTexCoord     : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                        
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression(g_nScaleTexCoordUByModelScaleAxis!=0 || g_nScaleTexCoordVByModelScaleAxis!=0); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,g_vTexCoordCenter.x+g_vTexCoordOffset.x+v2*g_vTexCoordCenter.y-v1*g_vTexCoordCenter.x)); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,g_vTexCoordCenter.y+g_vTexCoordOffset.y-(v2*g_vTexCoordCenter.x+v1*g_vTexCoordCenter.y))); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _1260
	{
	    mat4 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _1260 PerViewConstantBuffer_t;
	
	struct _1124
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	};
	
	layout(set = 0) uniform _1124 _Globals_;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in uvec4 vBlendIndices;
	layout(location = 4) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) centroid out vec4 output_3;
	layout(location = 4) flat out uint output_4;
	
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
	    vec3 _17940;
	    if (_13771 > 0u)
	    {
	        _17940 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].z);
	    }
	    else
	    {
	        _17940 = vec3(1.0);
	    }
	    vec3 _12151 = vec4(vPositionOs.xyz * _17940.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9360 = vTexCoord.xyxy;
	    _9360.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _9360.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _9360;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    output_0 = _12151;
	    output_1 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    output_2 = _20488;
	    output_3 = vec4(1.0);
	    output_4 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	TextureCube g_tCubeMap < Channel(RGB, Box(TextureCubeMap), Srgb); OutputFormat(RGBA8888); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Texture
	CreateInputTexture2D(TextureCubeMap, Srgb, 8, "", "", "Texture", Default4(1, 1, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// CubeParallax
	float g_flCubeParallax < Range(-1, 1); UiType(Slider); UiGroup("CubeParallax/10"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Variant parameters
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float3 PerViewConstantBuffer_t_1_m0 : packoffset(c26);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    int _Globals_1_g_bFogEnabled : packoffset(c0.z);
	    float _Globals_1_g_flCubeParallax : packoffset(c5.z);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m3 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m4 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m5 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m6 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c34);
	};
	
	Texture2D<float4> g_tColor : register(t52, space1);
	SamplerState g_sUserConfig : register(s20, space1);
	TextureCube<float4> g_tCubeMap : register(t43, space1);
	SamplerState Filter_Anisotropic_MaxAniso_8 : register(s14, space1);
	TextureCube<float4> g_tFogCubeTexture : register(t42, space1);
	SamplerState g_sTrilinearClamp : register(s18, space1);
	
	static float3 input_0;
	static float4 input_2;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float4 input_2 : TEXCOORD2;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _19391 = g_tColor.Sample(g_sUserConfig, input_2.xy);
	    float4 _18900 = 1.0f.xxxx;
	    _18900.x = _19391.x;
	    _18900.y = _19391.y;
	    _18900.z = _19391.z;
	    float3 _21117 = _18900.xyz * g_tCubeMap.Sample(Filter_Anisotropic_MaxAniso_8, normalize(normalize(input_0 - PerViewConstantBuffer_t_1_m0.xyz) + (input_0.xyz * _Globals_1_g_flCubeParallax)).xyz).xyz;
	    float4 _23714 = _18900;
	    _23714.x = _21117.x;
	    _23714.y = _21117.y;
	    _23714.z = _21117.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _23187 = input_0.xyz - PerViewConstantBuffer_t_1_m0.xyz;
	        float3 _9057 = _23187.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _23187.xyz;
	            bool _12885;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m3.x)
	            {
	                _12885 = (input_0.z * PerViewConstantBufferCsgo_t_1_m3.z) < PerViewConstantBufferCsgo_t_1_m3.y;
	            }
	            else
	            {
	                _12885 = false;
	            }
	            [branch]
	            if (_12885)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m0.xy + (PerViewConstantBufferCsgo_t_1_m0.zw * float2(length(_21493), input_0.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m1.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m1.y)) * PerViewConstantBufferCsgo_t_1_m2.w;
	                _19340 = lerp(_23714.xyz, float4(PerViewConstantBufferCsgo_t_1_m2.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _23714.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _23714;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12886;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m7.x)
	            {
	                _12886 = (PerViewConstantBufferCsgo_t_1_m7.z * input_0.z) < PerViewConstantBufferCsgo_t_1_m7.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            if (_12886)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m4.y) + PerViewConstantBufferCsgo_t_1_m4.x), PerViewConstantBufferCsgo_t_1_m4.w)) * saturate(pow(max(0.0f, (input_0.z * PerViewConstantBufferCsgo_t_1_m5.y) + PerViewConstantBufferCsgo_t_1_m5.x), PerViewConstantBufferCsgo_t_1_m5.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m7.w;
	                _19341 = lerp(_23944.xyz, float4((g_tFogCubeTexture.SampleLevel(g_sTrilinearClamp, normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m6).xyz).xyz, PerViewConstantBufferCsgo_t_1_m5.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m4.z))) * PerViewConstantBufferCsgo_t_1_m8.x).xyz, _8892).xyz, _8892.xxx);
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
	        _6805 = _23714;
	    }
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_2 = stage_input.input_2;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(unlit, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	BoolAttribute(DoNotCastShadows, true);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
}
