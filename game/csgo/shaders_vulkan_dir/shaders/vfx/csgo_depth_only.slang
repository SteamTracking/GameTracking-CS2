//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Depth Only - Used as a Mode Fallback";
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
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_PAINT_VERTEX_COLORS, 0..1, "Vertex Color" );
	Feature( F_DEPTH_BIAS, 0..1, "Z-Buffering" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_ALPHA_TEST ), "Translucent and Alpha Test are not compatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices   : BLENDINDICES0  < Semantic( BlendIndices ); >;                         // D_CS_VERTEX_ANIMATION=0
	float4 vBlendColorTint : COLOR0         < Semantic( VertexPaintTintColor ); >;                 // S_PAINT_VERTEX_COLORS=1
	float3 vPositionOs     : POSITION0      < Semantic( PosXyz ); >;                               // D_CS_VERTEX_ANIMATION=0
	float2 vTextureCoords  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                       // S_ALPHA_TEST=1, S_PAINT_VERTEX_COLORS=1, S_TRANSLUCENT=1
	float2 nInstanceIdx    : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                 
};

VS
{
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticComboRule( Requires( S_PAINT_VERTEX_COLORS, S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_TRANSLUCENT, S_ALPHA_TEST ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	
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
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
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
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static uint nInstanceIdx;
	static uint4 vBlendIndices;
	static float3 vPositionOs;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint4 vBlendIndices : TEXCOORD1;
	    uint nInstanceIdx : TEXCOORD2;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _13771 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    float3x4 _12618 = asfloat(uint3x4(g_transformBuffer.Load4(_21785 * 48 + 0), g_transformBuffer.Load4(_21785 * 48 + 16), g_transformBuffer.Load4(_21785 * 48 + 32)));
	    float3 _22743;
	    if (_13771 > 0u)
	    {
	        float3x4 _25207 = asfloat(uint3x4(g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 32)));
	        _22743 = _25207[0].z.xxx;
	    }
	    else
	    {
	        _22743 = 1.0f.xxx;
	    }
	    float4 _19149 = mul(PerViewConstantBuffer_t_1_m0, (float4(mul(_12618, float4(vPositionOs.xyz * _22743.xyz, 1.0f)).xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    _19149.y = -_19149.y;
	    gl_Position = _19149;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    nInstanceIdx = stage_input.nInstanceIdx;
	    vBlendIndices = stage_input.vBlendIndices;
	    vPositionOs = stage_input.vPositionOs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	
	
	// Variant Attributes
	IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
}

PS
{
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticComboRule( Requires( S_PAINT_VERTEX_COLORS, S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_TRANSLUCENT, S_ALPHA_TEST ) );
	DynamicCombo( D_ALPHA_TEST_PREPASS, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_DISABLE_TRANSLUCENT_CLIP, 0..1 );
	DynamicCombo( D_FRONT_FACE_CULL, 0..1 );
	DynamicComboRule( Requires( D_ALPHA_TEST_PREPASS, S_ALPHA_TEST ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	DynamicComboRule( Requires( D_DISABLE_TRANSLUCENT_CLIP, S_TRANSLUCENT ) );
	
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, F_DEPTH_BIAS ? -64 : 0);
	RenderState(DepthBiasClamp, F_DEPTH_BIAS ? -.0005 : 0);
	RenderState(SlopeScaleDepthBias, F_DEPTH_BIAS ? -2 : 0);
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_TRANSLUCENT == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	// Dynamic combos: D_OPAQUE_FADE
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    uint PerViewConstantBufferCsgo_t_1_m0 : packoffset(c4);
	    int2 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c11);
	};
	
	Texture2D<float4> g_bindless_Texture2D_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static float4 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD0;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    if ((mad(input_0.w, 2.0f, -1.5f) + g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m0].Load(int3(int3(int2(gl_FragCoord.xy) & PerViewConstantBufferCsgo_t_1_m1, 0).xy, 0)).y) < 0.0f)
	    {
	        discard;
	    }
	    output_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
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
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(translucent, true);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
	#endif
	#if (S_TRANSLUCENT == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
	#endif
}
