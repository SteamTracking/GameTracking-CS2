//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Standard shader for all non-blend surfaces";
	DevShader = false;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Depth("depth_only.vfx");
	ProjectionDepth("depth_only.vfx");
	Forward();
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
}

FEATURES
{
	Feature( F_SPECULAR, 0..1, "Specular" );
	Feature( F_SPECULAR_CUBE_MAP, 0..1 (0="None", 1="In-game Cube Map"), "Specular" );
	Feature( F_UNLIT, 0..1, "Lighting" );
	Feature( F_MORPH_SUPPORTED, 0..1, "Morph" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_OVERLAY, 0..1, "Overlay" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_SELF_ILLUM, 0..1, "Self Illum" );
	Feature( F_PAINT_VERTEX_COLORS, 0..1, "Vertex Color Painting" );
	FeatureRule( Requires( F_SPECULAR_CUBE_MAP, F_SPECULAR ), "Requires Specular" );
	FeatureRule( Allow1( F_UNLIT, F_SPECULAR ), "Specular and Unlit are not compatible" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_ALPHA_TEST ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Requires( F_OVERLAY, F_TRANSLUCENT ), "Overlay requires translucent" );
	FeatureRule( Allow1( F_SELF_ILLUM, F_UNLIT ), "Self Illum and Unlit are not compatible" );
	FeatureRule( Allow1( F_PAINT_VERTEX_COLORS, F_TRANSLUCENT ), "Vertex Color Painting and Tranlucent are not compatible" );
	FeatureRule( Allow1( F_OVERLAY, F_UNLIT ), "Unlit mode not supported with overlays" );
	FeatureRule( Allow1( F_OVERLAY, F_MORPH_SUPPORTED ), "Morphing not supported with overlays" );
	FeatureRule( Allow1( F_OVERLAY, F_RENDER_BACKFACES ), "Render back faces not supported with overlays" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor                     : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_PAINT_VERTEX_COLORS=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;    // D_COMPRESSED_NORMALS_AND_TANGENTS=1
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_BLEND_WEIGHT_COUNT=1, D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vBlendWeight               : BLENDWEIGHT0   < Semantic( BlendWeight ); >;               // D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                    // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	uint4  nVertexIndex               : TEXCOORD14     < Semantic( MorphIndex ); >;                // D_MORPH=1
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                   
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;            // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_UNLIT, F_UNLIT );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_MORPH_SUPPORTED, F_MORPH_SUPPORTED );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_UNLIT ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_PAINT_VERTEX_COLORS, S_TRANSLUCENT ) );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_MORPH, 0..1 );
	DynamicComboRule( Requires( D_MORPH, S_MORPH_SUPPORTED ) );
	DynamicComboRule( Allow1( S_TRANSLUCENT, D_MORPH ) );
	
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	Texture2D g_tCompositeMorphTextureAtlas < Attribute("CompositeMorphTextureAtlas"); SrgbRead(false); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Normal Map
	float2 g_vNormalTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Normal Map"); >;
	
	// Color
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/40"); >;
	
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
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c17);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float2 _Globals_1_g_vTexCoordScale : packoffset(c1);
	    float2 _Globals_1_g_vTexCoordOffset : packoffset(c1.z);
	    float2 _Globals_1_g_vNormalTexCoordScale : packoffset(c2);
	};
	
	
	static float4 gl_Position;
	static float gl_ClipDistance[1];
	static uint nInstanceIdx;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static float4 vTangentUOs_flTangentVSign;
	static float3 output_0;
	static float4 output_1;
	static float3 output_2;
	static float4 output_3;
	static float4 output_4;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    float4 vTangentUOs_flTangentVSign : TEXCOORD3;
	    uint nInstanceIdx : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float4 output_3 : TEXCOORD3;
	    float4 output_4 : TEXCOORD4;
	    float4 gl_Position : SV_Position;
	    float gl_ClipDistance0 : SV_ClipDistance0;
	};
	
	void MainVs_inner()
	{
	    float4 _23812 = float4(uint4(g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 255u, (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
	    float3 _6253 = _23812.xyz;
	    float3 _17828 = _6253 * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((_6253 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _17828.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    float3x4 _9216 = asfloat(uint3x4(g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 32)));
	    float3 _11198 = normalize(mul(_9216, float4(vNormalOs.xyz, 0.0f)));
	    float3 _12861 = mul(_9216, float4(vTangentUOs_flTangentVSign.xyz, 0.0f)).xyz;
	    float3 _24912 = _11198.xyz;
	    float3 _19938 = mul(_9216, float4(vPositionOs.xyz, 1.0f));
	    float4 _18256 = mul(PerViewConstantBuffer_t_1_m0, (float4(_19938.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m2 * 1.0f)).xyzw);
	    output_0 = _11198;
	    output_1 = float4((vTexCoord.xy * _Globals_1_g_vTexCoordScale.xy) + _Globals_1_g_vTexCoordOffset.xy, ((vTexCoord.xy * _Globals_1_g_vNormalTexCoordScale.xy) * _Globals_1_g_vTexCoordScale.xy) + _Globals_1_g_vTexCoordOffset.xy);
	    output_2 = _19938;
	    output_3 = float4(_21354, _21355, _19302, _23812.w);
	    output_4 = float4(normalize(_12861 - (_24912 * dot(_12861, _24912))), vTangentUOs_flTangentVSign.w);
	    _18256.y = -_18256.y;
	    gl_Position = _18256;
	    gl_ClipDistance[0] = dot(float4(_19938.xyz, 1.0f), PerViewConstantBuffer_t_1_m1.xyzw);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    nInstanceIdx = stage_input.nInstanceIdx;
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    vTangentUOs_flTangentVSign = stage_input.vTangentUOs_flTangentVSign;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.gl_ClipDistance0.x = gl_ClipDistance[0];
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	#if (S_TRANSLUCENT == 0)
		BoolAttribute(VertexPaintUIPickColor, true);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
	#endif
}

PS
{
	StaticCombo( S_UNLIT, F_UNLIT );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_TOOLS_ENABLED, 0, Sys( 1 ) );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_SPECULAR, F_SPECULAR );
	StaticCombo( S_SPECULAR_CUBE_MAP, F_SPECULAR_CUBE_MAP );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_RENDER_BACKFACES, F_RENDER_BACKFACES );
	StaticCombo( S_OVERLAY, F_OVERLAY );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_UNLIT ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_SPECULAR ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, S_TOOLS_ENABLED ) );
	StaticComboRule( Requires( S_SPECULAR_CUBE_MAP, S_SPECULAR ) );
	StaticComboRule( Allow1( S_UNLIT, S_SPECULAR ) );
	StaticComboRule( Allow1( S_TRANSLUCENT, S_ALPHA_TEST ) );
	StaticComboRule( Requires( S_OVERLAY, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_SELF_ILLUM, S_UNLIT ) );
	StaticComboRule( Allow1( S_OVERLAY, S_UNLIT ) );
	StaticComboRule( Allow1( S_OVERLAY, S_RENDER_BACKFACES ) );
	DynamicCombo( D_ALPHATINT, 0..1 );
	DynamicComboRule( Allow1( S_MODE_TOOLS_WIREFRAME, D_ALPHATINT ) );
	
	RenderState(BackStencilPassOp, Replace);
	RenderState(BlendEnable, true);
	RenderState(DepthEnable, exists(ShaderVar_WireframeDepthEnable) ? ShaderVar_WireframeDepthEnable : true);
	RenderState(DepthWriteEnable, false);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(StencilEnable, true);
	RenderState(StencilPassOp, Replace);
	RenderState(StencilRef, 1);
	RenderState(StencilWriteMask, 1);
	float g_flCubeMapBlur < UiType(Slider); Expression(g_flCubeMapBlurAmount*9+1); >;
	int g_nEnvMapIndex < Attribute("EnvMapIndex"); UiType(Slider); >;
	Texture2D g_tColor < Channel(RGB, Box(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	TextureCubeArray g_tEnvLightProbes < Attribute("EnvMapArray"); SrgbRead(true); >;
	Texture2D g_tMetalnessReflectanceFresnel < Channel(R, Box(TextureMetalness), Linear); Channel(G, Box(TextureReflectance), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(AG, MipNormal(TextureNormal), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tRoughness < Channel(RGBA, AnisoNormal(TextureNormal, TextureGlossiness), Linear); OutputFormat(DXT5); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	float2 g_vMetalnessScaleAndBias < UiType(VectorText); Expression(float2(max(g_vMetalnessRange.x,g_vMetalnessRange.y)-g_vMetalnessRange.x,g_vMetalnessRange.x)); >;
	float2 g_vReflectanceScaleAndBias < UiType(VectorText); Expression(float2(max(g_vReflectanceRange.x,g_vReflectanceRange.y)-g_vReflectanceRange.x,g_vReflectanceRange.x)); >;
	float2 g_vRoughnessScaleAndBias < UiType(VectorText); Expression(float2(max(1-g_vGlossinessRange.x,1-g_vGlossinessRange.y)-(1-g_vGlossinessRange.y),1-g_vGlossinessRange.y)); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression(g_flSelfIllumScale*g_vSelfIllumTint.xyz); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); >;
	
	// Lighting
	CreateInputTexture2D(TextureGlossiness, Linear, 8, "", "_gloss", "Lighting,30/Gloss,20/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureReflectance, Linear, 8, "", "_refl", "Lighting,30/Reflectance,10/10", Default4(0.1, 0.1, 0.1, 0));
	float2 g_vGlossinessRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Gloss/20"); >;
	float2 g_vMetalnessRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Metalness/20"); >;
	float2 g_vReflectanceRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Reflectance/20"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	float g_flBumpStrength < Default(1); Range(0, 10); UiType(Slider); UiGroup("Normal Map"); >;
	
	// Self Illum
	CreateInputTexture2D(TextureSelfIllumMask, Linear, 8, "", "_selfillum", "Self Illum", Default4(1, 1, 1, 0));
	float g_flSelfIllumScale < Default(1); Range(0, 16); UiType(Slider); UiGroup("Self Illum"); >;
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Cube Map
	float g_flCubeMapBlurAmount < Default(1); Range(0, 2); UiType(Slider); UiGroup("Cube Map,40/30"); >;
	
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_OVERLAY == 1)
		Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST == 0)
		Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_UNLIT == 0)
		Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_MODE_TOOLS_WIREFRAME == 0)
		Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_TOOLS_ENABLED == 0)
		Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	#if (S_RENDER_BACKFACES == 0)
		Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, Box(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float3 _2;
	static float4 _3;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flBumpStrength : packoffset(c0.w);
	    float3 _Globals_1_g_vColorTint : packoffset(c1);
	    float2 _Globals_1_g_vRoughnessScaleAndBias : packoffset(c3.y);
	};
	
	cbuffer RoughnessLightingGlobalsCB_t : register(b3, space1)
	{
	    float4 RoughnessLightingGlobalsCB_t_1_m0 : packoffset(c0);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c18);
	    float3 PerViewConstantBuffer_t_1_m1 : packoffset(c26);
	    float3 PerViewConstantBuffer_t_1_m2 : packoffset(c31);
	    float PerViewConstantBuffer_t_1_m3 : packoffset(c31.w);
	    float PerViewConstantBuffer_t_1_m4 : packoffset(c32);
	    float PerViewConstantBuffer_t_1_m5 : packoffset(c32.y);
	    float PerViewConstantBuffer_t_1_m6 : packoffset(c32.z);
	};
	
	cbuffer SunLightShaderParamsCB_t : register(b4, space1)
	{
	    float3 SunLightShaderParamsCB_t_1_m0 : packoffset(c0);
	    float3 SunLightShaderParamsCB_t_1_m1 : packoffset(c1);
	};
	
	Texture2D<float4> g_tColor : register(t32, space1);
	SamplerState DefaultSamplerState_0 : register(s16, space1);
	Texture2D<float4> g_tNormal : register(t33, space1);
	Texture2D<float4> g_tRoughness : register(t34, space1);
	
	static float3 input_0;
	static float4 input_1;
	static float4 input_3;
	static float4 input_4;
	static float3 input_2;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float4 input_1 : TEXCOORD1;
	    float3 input_2 : TEXCOORD2;
	    float4 input_3 : TEXCOORD3;
	    float4 input_4 : TEXCOORD4;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float2 _7707 = (g_tNormal.Sample(DefaultSamplerState_0, input_1.zw).wy * 2.0f) - 1.0f.xx;
	    float _9481 = _7707.x;
	    float3 _22101;
	    _22101.x = _9481;
	    float _21775 = _7707.y;
	    _22101.y = _21775;
	    float3 _19739 = float3(_9481, _21775, sqrt(saturate(1.0f - dot(_22101.xy, _22101.xy))));
	    _19739.y = -_21775;
	    float3 _24157 = _19739.xyz;
	    float2 _11003 = _19739.xy * _Globals_1_g_flBumpStrength;
	    _24157.x = _11003.x;
	    _24157.y = _11003.y;
	    float3 _23712 = normalize(_24157.xyz);
	    float4 _3300 = g_tRoughness.Sample(DefaultSamplerState_0, input_1.xy);
	    float3 _14744 = normalize((((normalize(input_4.xyz).xyz * _23712.x).xyz + ((normalize(cross(normalize(input_0.xyz).xyz, input_4.xyz)) * input_4.w).xyz * _23712.y)).xyz + (input_0.xyz * _23712.z)).xyz).xyz;
	    float3 _23378 = clamp(_14744, 0.0f.xxx, 1.0f.xxx);
	    float3 _23904 = clamp(-_14744, 0.0f.xxx, 1.0f.xxx);
	    float _7186 = (1.0f - min(1.0f, ((((_3300.z + _3300.w) * 0.5f) * _Globals_1_g_vRoughnessScaleAndBias.x) + _Globals_1_g_vRoughnessScaleAndBias.y) + ((_3300.x + _3300.y) * 0.5f))) * 0.800000011920928955078125f;
	    float3 _21103 = ((RoughnessLightingGlobalsCB_t_1_m0.xyz * (dot(float3(0.60000002384185791015625f, 0.4000000059604644775390625f, 1.0f), _23378 * _23378) + dot(float3(0.60000002384185791015625f, 0.4000000059604644775390625f, 0.20000000298023223876953125f), _23904 * _23904))).xyz + ((SunLightShaderParamsCB_t_1_m0.xyz * (pow(saturate(dot(_14744, SunLightShaderParamsCB_t_1_m1.xyz)), _7186 + 0.60000002384185791015625f) * ((_7186 + 1.60000002384185791015625f) * 0.5f))) * 1.0f)).xyz * ((g_tColor.Sample(DefaultSamplerState_0, input_1.xy).xyz * _Globals_1_g_vColorTint.xyz) * input_3.xyz).xyz;
	    float4 _13888;
	    _13888.x = _21103.x;
	    _13888.y = _21103.y;
	    _13888.z = _21103.z;
	    float3 _19800 = lerp(_13888.xyz, PerViewConstantBuffer_t_1_m2.xyz, saturate(min(PerViewConstantBuffer_t_1_m5, pow(saturate((distance(input_2.xyz, PerViewConstantBuffer_t_1_m1.xyz) * PerViewConstantBuffer_t_1_m4) + PerViewConstantBuffer_t_1_m3), PerViewConstantBuffer_t_1_m6))).xxx);
	    float4 _17842;
	    _17842.x = _19800.x;
	    _17842.y = _19800.y;
	    _17842.z = _19800.z;
	    output_0 = float4(_17842.xyz * PerViewConstantBuffer_t_1_m0, 1.0f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    input_2 = stage_input.input_2;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(NeedsLightProbe, F_UNLIT ? 0 : 1);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(SupportsMappingDimensions, true);
	
	#if (S_UNLIT == 1)
		BoolAttribute(unlit, true);
		BoolAttribute(ForwardLayerOnly, true);
		BoolAttribute(mapbuilder_donotcollapse, true);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
		BoolAttribute(ForwardLayerOnly, true);
		BoolAttribute(mapbuilder_donotcollapse, true);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
	#endif
	#if (S_SPECULAR_CUBE_MAP == 1)
		BoolAttribute(environmentmapped, true);
	#endif
	#if (S_SPECULAR_CUBE_MAP == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_OVERLAY == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_SELF_ILLUM == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_UNLIT == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_TOOLS_ENABLED == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_SPECULAR == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_MODE_TOOLS_WIREFRAME == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_RENDER_BACKFACES == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
		BoolAttribute(ForwardLayerOnly, true);
		BoolAttribute(mapbuilder_donotcollapse, true);
	#endif
	#if (S_OVERLAY == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
		BoolAttribute(ForwardLayerOnly, true);
		BoolAttribute(mapbuilder_donotcollapse, true);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
		BoolAttribute(ForwardLayerOnly, true);
		BoolAttribute(mapbuilder_donotcollapse, true);
	#endif
	#if (S_RENDER_BACKFACES == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(overlay, true);
	#endif
	#if (S_SPECULAR == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
		BoolAttribute(translucent, true);
		BoolAttribute(ForwardLayerOnly, true);
		BoolAttribute(mapbuilder_donotcollapse, true);
		BoolAttribute(overlay, true);
	#endif
}
