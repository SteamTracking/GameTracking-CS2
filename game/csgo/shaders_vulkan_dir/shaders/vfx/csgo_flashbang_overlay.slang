//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Flashbang overlay effect";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs, psrs
}

MODES
{
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
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices      : BLENDINDICES0  < Semantic( BlendIndices ); >;                      // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	float4 vPerVertexLighting : COLOR1         < Semantic( PerVertexLighting ); >;                 // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame       : NORMAL0        < Semantic( CompressedTangentFrame ); >;           
	float4 vNormalOs          : NORMAL0        < Semantic( Normal ); >;                           
	float2 vLightmapUV        : TEXCOORD3      < Semantic( LightmapUV ); >;                        // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float3 vPositionOs        : POSITION0      < Semantic( PosXyz ); >;                           
	float2 vTexCoord          : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                   
	float2 nInstanceIdx       : TEXCOORD13     < Semantic( InstanceTransformUv ); >;              
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
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
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
	
	struct _985
	{
	    float _m0;
	};
	
	layout(set = 0) uniform _985 PerViewConstantBuffer_t;
	
	struct _1234
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1234 _Globals_;
	
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
	    vec3 _21709;
	    if (_13771 > 0u)
	    {
	        _21709 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].z);
	    }
	    else
	    {
	        _21709 = vec3(1.0);
	    }
	    vec4 _23812 = vec4(uvec4(g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 255u, (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 65280u) >> uint(8), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 16711680u) >> uint(16), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec3 _6253 = _23812.xyz;
	    vec3 _17828 = _6253 * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((_6253 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    float _7654 = _23812.w;
	    vec4 _11284 = vTexCoord.xyxy;
	    _11284.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _11284.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _11284.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m0);
	    vec4 _20488 = _11284;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _7654 * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11399;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    vec4 _14283 = vec4(vPositionOs, 0.5);
	    output_0 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    output_1 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    output_2 = _20488;
	    output_3 = _23714;
	    output_4 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _14283.y = -vPositionOs.y;
	    gl_Position = _14283;
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
	
	float g_flFlashbangAlpha < Attribute("FlashbangAlpha"); UiType(Slider); >;
	float g_flFlashbangScreenshotAlpha < Attribute("FlashbangScreenshotAlpha"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tFlashbangFrame < Attribute("FlashbangFrameTexture"); SrgbRead(true); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float4 PerViewConstantBuffer_t_1_m0 : packoffset(c22);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flFlashbangAlpha : packoffset(c5.z);
	    float _Globals_1_g_flFlashbangScreenshotAlpha : packoffset(c5.w);
	};
	
	Texture2D<float4> g_tFlashbangFrame : register(t53, space1);
	SamplerState g_sPointClamp : register(s19, space1);
	
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
	    float _18570 = saturate(_Globals_1_g_flFlashbangScreenshotAlpha);
	    float3 _11244 = _18570.xxx.xyz;
	    float _21709;
	    if (_18570 <= 0.040449999272823333740234375f)
	    {
	        _21709 = (_11244 * 0.077399380505084991455078125f.xxx).x;
	    }
	    else
	    {
	        _21709 = pow((_11244 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx).x;
	    }
	    float _18571 = saturate(_Globals_1_g_flFlashbangAlpha);
	    float3 _11245 = _18571.xxx.xyz;
	    float _20826;
	    if (_18571 <= 0.040449999272823333740234375f)
	    {
	        _20826 = (_11245 * 0.077399380505084991455078125f.xxx).x;
	    }
	    else
	    {
	        _20826 = pow((_11245 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx).x;
	    }
	    output_0 = float4(((pow(clamp(g_tFlashbangFrame.SampleLevel(g_sPointClamp, (gl_FragCoord.xy * PerViewConstantBuffer_t_1_m0.xy).xy, 0.0f).xyz, 0.0f.xxx, 1.0f.xxx).xyz, 2.2000000476837158203125f.xxx).xyz * _21709) * 4.0f) + _20826.xxx, 0.0f);
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
	
	
	
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, false);
	RenderState(DepthFunc, Always);
	RenderState(DepthWriteEnable, false);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
}
