//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "s2 version of lightmappedgeneric/worldvertextransition shader for csgo.";
	DevShader = false;
	Version = 4;
	
	// Platform: VULKAN_SM_60
	// Programs: ps, psrs, rtx, vs
}

MODES
{
	Depth("csgo_depth_only.vfx");
	CsgoForward();
	RayTrace();
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
	Feature( F_SPECULAR_DIRECT, 0..1, "Direct/Per-Pixel Specular - S1 $phong" );
	Feature( F_SPECULAR_INDIRECT, 0..1, "Indirect/Cubemap Specular - S1 $envmap" );
	Feature( F_LAYERS, 0..1 (0="LightmappedGeneric", 1="WorldVertexTransition"), "Number of Additional Layers" );
	Feature( F_TEXTURETRANSFORMS, 0..1 (0="No Texture Transforms", 1="All Texture Transforms enabled"), "Texture Transforms" );
	Feature( F_FANCY_BLENDING, 0..3 (0="VertexBlend", 1="BlendModulateTexture,rg", 2="NewLayerBlending,g", 3="NewLayerBlending,a"), "Fancy Blending" );
	Feature( F_DETAILTEXTURE, 0..2 (0="None", 1="Layer 1 Detail Only", 2="Layer 1 and 2 Detail"), "Detail Textures" );
	Feature( F_DETAILBLENDMODE, 0..1 (0="Mod2x", 1="Mod2x_Select_Two_Patterns"), "S1 Combine Modes Supported" );
	Feature( F_ADDBUMPMAPS, 0..1 (0="None", 1="Detail Bumpmaps"), "S1 Detail bumpmaps" );
	Feature( F_OVERLAY, 0..1, "Overlay" );
	Feature( F_METALNESS_TEXTURE, 0..1, "PBR" );
	Feature( F_NO_SPECULAR_AT_FULL_ROUGHNESS, 0..1, "PBR" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Requires( F_SPECULAR_DIRECT, F_SPECULAR_INDIRECT ), "Direct specular requires indirect (we'd prefer to avoid having only direct specular)" );
	FeatureRule( Requires( F_FANCY_BLENDING, F_LAYERS==1 ), "fancy blending requires multiple layers" );
	FeatureRule( Requires( F_DETAILTEXTURE==2, F_LAYERS==1 ), "Detail blend mode requires detail textures" );
	FeatureRule( Requires( F_DETAILBLENDMODE, F_DETAILTEXTURE==2, F_LAYERS==1 ), "Detail blend mode requires detail textures" );
	FeatureRule( Requires( F_ADDBUMPMAPS, F_DETAILTEXTURE==1, F_DETAILTEXTURE==2 ), "Detail bumpmaps requires detail" );
	FeatureRule( Requires( F_OVERLAY, F_TRANSLUCENT, F_ALPHA_TEST ), "Overlay requires translucent or alphatest" );
	FeatureRule( Allow1( F_OVERLAY, F_LAYERS ), "Multiple layers not supported with overlays" );
	FeatureRule( Allow1( F_OVERLAY, F_DO_NOT_CAST_SHADOWS ), "Overlay and Do Not Cast Shadow Only are not compatible" );
	FeatureRule( Allow1( F_OVERLAY, F_RENDER_BACKFACES ), "Overlay and render backfaces are not compatible" );
	FeatureRule( Requires( F_TRANSLUCENT, F_LAYERS==0 ), "Translucency not yet supported with multiple layers" );
	FeatureRule( Requires( F_ALPHA_TEST, F_LAYERS==0 ), "AlphaTest not yet supported with multiple layers" );
	FeatureRule( Allow1( F_METALNESS_TEXTURE, F_ADDITIVE_BLEND ), "Metalness Texture and Additive Blend are not compatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;    // S_LAYERS=1, S_DETAILTEXTURE=2
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_LAYERS, F_LAYERS );
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING!=0 );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_TEXTURETRANSFORMS, F_TEXTURETRANSFORMS );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAILTEXTURE==2, S_LAYERS==1 ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vBlendModulateTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flBlendModulateTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vBlendModulateTexCoordScale.x,-v2*g_vBlendModulateTexCoordScale.y,0,g_vBlendModulateTexCoordCenter.x+g_vBlendModulateTexCoordOffset.x+v2*g_vBlendModulateTexCoordScale.y*g_vBlendModulateTexCoordCenter.y-v1*g_vBlendModulateTexCoordScale.x*g_vBlendModulateTexCoordCenter.x)); >;
	float4 g_vBlendModulateTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flBlendModulateTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vBlendModulateTexCoordScale.x,v1*g_vBlendModulateTexCoordScale.y,0,g_vBlendModulateTexCoordCenter.y+g_vBlendModulateTexCoordOffset.y+v2*g_vBlendModulateTexCoordScale.x*g_vBlendModulateTexCoordCenter.x-v1*g_vBlendModulateTexCoordScale.y*g_vBlendModulateTexCoordCenter.y)); >;
	float4 g_vLayer1NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer1NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1NormalTexCoordScale.x,-v2*g_vLayer1NormalTexCoordScale.y,0,g_vLayer1NormalTexCoordCenter.x+g_vLayer1NormalTexCoordOffset.x+v2*g_vLayer1NormalTexCoordScale.y*g_vLayer1NormalTexCoordCenter.y-v1*g_vLayer1NormalTexCoordScale.x*g_vLayer1NormalTexCoordCenter.x)); >;
	float4 g_vLayer1NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer1NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1NormalTexCoordScale.x,v1*g_vLayer1NormalTexCoordScale.y,0,g_vLayer1NormalTexCoordCenter.y+g_vLayer1NormalTexCoordOffset.y+v2*g_vLayer1NormalTexCoordScale.x*g_vLayer1NormalTexCoordCenter.x-v1*g_vLayer1NormalTexCoordScale.y*g_vLayer1NormalTexCoordCenter.y)); >;
	float4 g_vLayer1TexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer1TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1TexCoordScale.x,-v2*g_vLayer1TexCoordScale.y,0,g_vLayer1TexCoordCenter.x+g_vLayer1TexCoordOffset.x+v2*g_vLayer1TexCoordScale.y*g_vLayer1TexCoordCenter.y-v1*g_vLayer1TexCoordScale.x*g_vLayer1TexCoordCenter.x)); >;
	float4 g_vLayer1TexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer1TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1TexCoordScale.x,v1*g_vLayer1TexCoordScale.y,0,g_vLayer1TexCoordCenter.y+g_vLayer1TexCoordOffset.y+v2*g_vLayer1TexCoordScale.x*g_vLayer1TexCoordCenter.x-v1*g_vLayer1TexCoordScale.y*g_vLayer1TexCoordCenter.y)); >;
	float4 g_vLayer2NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer2NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2NormalTexCoordScale.x,-v2*g_vLayer2NormalTexCoordScale.y,0,g_vLayer2NormalTexCoordCenter.x+g_vLayer2NormalTexCoordOffset.x+v2*g_vLayer2NormalTexCoordScale.y*g_vLayer2NormalTexCoordCenter.y-v1*g_vLayer2NormalTexCoordScale.x*g_vLayer2NormalTexCoordCenter.x)); >;
	float4 g_vLayer2NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer2NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2NormalTexCoordScale.x,v1*g_vLayer2NormalTexCoordScale.y,0,g_vLayer2NormalTexCoordCenter.y+g_vLayer2NormalTexCoordOffset.y+v2*g_vLayer2NormalTexCoordScale.x*g_vLayer2NormalTexCoordCenter.x-v1*g_vLayer2NormalTexCoordScale.y*g_vLayer2NormalTexCoordCenter.y)); >;
	float4 g_vLayer2TexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer2TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2TexCoordScale.x,-v2*g_vLayer2TexCoordScale.y,0,g_vLayer2TexCoordCenter.x+g_vLayer2TexCoordOffset.x+v2*g_vLayer2TexCoordScale.y*g_vLayer2TexCoordCenter.y-v1*g_vLayer2TexCoordScale.x*g_vLayer2TexCoordCenter.x)); >;
	float4 g_vLayer2TexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer2TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2TexCoordScale.x,v1*g_vLayer2TexCoordScale.y,0,g_vLayer2TexCoordCenter.y+g_vLayer2TexCoordOffset.y+v2*g_vLayer2TexCoordScale.x*g_vLayer2TexCoordCenter.x-v1*g_vLayer2TexCoordScale.y*g_vLayer2TexCoordCenter.y)); >;
	
	// Blend Modulation
	float2 g_vBlendModulateTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 20"); >;
	float2 g_vBlendModulateTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 30"); >;
	float g_flBlendModulateTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 40"); >;
	float2 g_vBlendModulateTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 50"); >;
	
	// PBR 1
	float2 g_vLayer1DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 15"); >;
	float2 g_vLayer1NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 30"); >;
	float2 g_vLayer1TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 30"); >;
	float2 g_vLayer1NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 40"); >;
	float2 g_vLayer1TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 40"); >;
	float g_flLayer1NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Normal,20 / 50"); >;
	float g_flLayer1TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Albedo,10 / 50"); >;
	float2 g_vLayer1NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 60"); >;
	float2 g_vLayer1TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 60"); >;
	
	// PBR 2
	float2 g_vLayer2DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 15"); >;
	float2 g_vLayer2NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 30"); >;
	float2 g_vLayer2TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 30"); >;
	float2 g_vLayer2NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 40"); >;
	float2 g_vLayer2TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 40"); >;
	float g_flLayer2NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Normal,20 / 50"); >;
	float g_flLayer2TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Albedo,10 / 50"); >;
	float2 g_vLayer2NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 60"); >;
	float2 g_vLayer2TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 60"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flVertexColorOpacityScale < Default(1); UiType(Slider); UiGroup("Color, 10/25"); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	
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
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c4.y);
	    float _Globals_1_g_flVertexColorOpacityScale : packoffset(c5);
	    float _Globals_1_g_flModelTintAmount : packoffset(c5.y);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space0)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c35);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static float4 vTangentUOs_flTangentVSign;
	static uint4 vBlendIndices;
	static uint nInstanceIdx;
	static float3 output_0;
	static float3 output_1;
	static float4 output_2;
	static float4 output_3;
	static float4 output_4;
	static uint output_5;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    float4 vTangentUOs_flTangentVSign : TEXCOORD3;
	    uint4 vBlendIndices : TEXCOORD4;
	    uint nInstanceIdx : TEXCOORD5;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    centroid float4 output_3 : TEXCOORD3;
	    float4 output_4 : TEXCOORD4;
	    nointerpolation uint output_5 : TEXCOORD5;
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
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        float3x4 _25207 = asfloat(uint3x4(g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 32)));
	        _21709 = _25207[0].z.xxx;
	    }
	    else
	    {
	        _21709 = 1.0f.xxx;
	    }
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
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    float _7654 = _23812.w;
	    float _16337 = _7654 * asfloat(g_instanceBuffer.Load(nInstanceIdx * 32 + 28));
	    float3 _12151 = mul(_12618, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _18237 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _9337 = vTexCoord.xyxy;
	    _9337.z = vTexCoord.x;
	    _9337.w = vTexCoord.y;
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = normalize(mul(_12618, float4(vNormalOs.xyz, 0.0f)));
	    output_2 = _9337;
	    output_3 = float4(float4(lerp(1.0f.xxx, float4(_21354, _21355, _17978, _7654).xyz, _Globals_1_g_flModelTintAmount.xxx), _16337).xyz * _Globals_1_g_vColorTint.xyz, _16337 * _Globals_1_g_flVertexColorOpacityScale);
	    output_4 = float4(normalize(mul(_12618, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_5 = g_instanceBuffer.Load(nInstanceIdx * 32 + 20) & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    vTangentUOs_flTangentVSign = stage_input.vTangentUOs_flTangentVSign;
	    vBlendIndices = stage_input.vBlendIndices;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    stage_output.output_5 = output_5;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	BoolAttribute(VertexPaintUI2Layer, true);
	BoolAttribute(VertexPaintUIPickColor, true);
	
	
	// Variant Attributes
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_LAYERS, F_LAYERS );
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING!=0 );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_TEXTURETRANSFORMS, F_TEXTURETRANSFORMS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_DETAILBLENDMODE, F_DETAILBLENDMODE );
	StaticCombo( S_OVERLAY, F_OVERLAY );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAILTEXTURE==2, S_LAYERS==1 ) );
	StaticComboRule( Requires( S_DETAILBLENDMODE, S_DETAILTEXTURE==2, S_LAYERS==1 ) );
	StaticComboRule( Requires( S_OVERLAY, S_TRANSLUCENT, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_OVERLAY, S_LAYERS ) );
	StaticComboRule( Requires( S_TRANSLUCENT, S_LAYERS==0 ) );
	StaticComboRule( Requires( S_ALPHA_TEST, S_LAYERS==0 ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SPECULAR_INDIRECT, S_MODE_TOOLS_VIS ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bAddBumpMaps < UiType(CheckBox); Expression(F_ADDBUMPMAPS ? 1 : 0); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bNoSpecularAtFullRoughness < UiType(CheckBox); Expression(F_NO_SPECULAR_AT_FULL_ROUGHNESS ? 1 : 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nFancyBlendingMode < UiType(Slider); Expression(F_FANCY_BLENDING); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tBlendModulation < Channel(RGBA, Box(TextureBlendModulation), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayer1AmbientOcclusion < Channel(R, Box3(TextureLayer1AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer1Detail < Channel(RGB, Box(TextureLayer1Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer1NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer1Normal, TextureLayer1Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2AmbientOcclusion < Channel(R, Box3(TextureLayer2AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer2Color < Channel(RGB, ArtistDefined(TextureLayer2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tLayer2Detail < Channel(RGB, Box(TextureLayer2Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer2Normal, TextureLayer2Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Blend Modulation
	CreateInputTexture2D(TextureBlendModulation, Linear, 8, "", "_blend", "Blend Modulation,20 / Texture,10 / 10", Default4(0.5, 0.5, 0.5, 0.5));
	float g_flBlendSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 60"); >;
	float g_flLayerBorderStrength < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 70"); >;
	float g_flLayerBorderOffset < Range(-1, 1); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 80"); Expression(-this); >;
	float g_flLayerBorderSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 90"); >;
	float3 g_vLayerBorderTint < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Modulation,20 / Texture,10 / 100"); Expression(SrgbGammaToLinear(this)); >;
	float g_flBevelBlendWidth < Default(4); Range(0, 10); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 110"); >;
	float g_flBevelBlendSharpness < Default(2); Range(0, 10); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 120"); >;
	float g_flBevelBlendStrength < Range(-4, 4); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 130"); >;
	
	// PBR 1
	CreateInputTexture2D(TextureLayer1AmbientOcclusion, Linear, 8, "", "_ao", "PBR 1,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer1Color, Srgb, 8, "", "_color", "PBR 1,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 1,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer1Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 1,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer1Roughness, Linear, 8, "Inverse", "_rough", "PBR 1,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Translucency, Linear, 8, "", "_trans", "PBR 1,10 / Albedo Translucency,15 / 10", Default4(1, 1, 1, 0));
	float4 g_vLayer1DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 20"); >;
	float3 g_vLayer1Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 1,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	
	// PBR 2
	CreateInputTexture2D(TextureLayer2AmbientOcclusion, Linear, 8, "", "_ao", "PBR 2,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer2Color, Srgb, 8, "", "_color", "PBR 2,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer2Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 2,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer2Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 2,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer2Roughness, Linear, 8, "Inverse", "_rough", "PBR 2,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	float4 g_vLayer2DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 20"); >;
	float3 g_vLayer2Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 2,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAlphaTestReference < Default(0.01); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	float g_flAlphaTestReference < Default(0.01); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2494
	{
	    float4 _m0[3];
	};
	
	struct _2704
	{
	    float4 _m0[4];
	};
	
	struct _465
	{
	    column_major float4x4 _m0[4];
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
	
	static float3 _4;
	static float4 _5;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c0.z);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c0.w);
	    uint _Globals_1_g_sPointClamp : packoffset(c1);
	    uint _Globals_1_g_sUserConfig : packoffset(c1.w);
	    uint _Globals_1_g_tColor : packoffset(c2.y);
	    uint _Globals_1_g_tLayer1NormalRoughness : packoffset(c2.z);
	    uint _Globals_1_g_tLayer1AmbientOcclusion : packoffset(c2.w);
	    float3 _Globals_1_g_vLayer1Tint : packoffset(c3);
	    uint _Globals_1_g_sCookieSampler : packoffset(c4.z);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c4.w);
	    int _Globals_1_g_bFogEnabled : packoffset(c5.y);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c5.z);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c5.w);
	    float _Globals_1_g_flMetalness : packoffset(c10);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m3 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.w);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c5.z);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2494 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2704 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c16);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c17);
	    float4 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1953.z);
	    float4 PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1955.w);
	    _465 PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1956);
	    _2704 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1988);
	    uint PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1996);
	    uint PerViewLightingConstantBufferGpu_t_1_m20 : packoffset(c1996.y);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c20.z);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c22);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	};
	
	ByteAddressBuffer g_CullBits : register(t30, space3);
	ByteAddressBuffer g_BarnLights : register(t31, space3);
	Texture2D<float4> g_bindless_Texture2D_float4[65536] : register(t46, space4);
	SamplerState g_bindless_Sampler[2048] : register(s29, space4);
	SamplerComparisonState g_bindless_Sampler_1[2048] : register(s29, space4);
	Texture3D<float4> g_bindless_Texture3D_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static bool gl_FrontFacing;
	static float3 input_0;
	static float3 input_1;
	static float4 input_2;
	static float4 input_3;
	static float4 input_4;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	    float4 input_4 : TEXCOORD4;
	    float4 gl_FragCoord : SV_Position;
	    bool gl_FrontFacing : SV_IsFrontFace;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _11408 = gl_FragCoord;
	    _11408.w = 1.0f / _11408.w;
	    bool _14874 = _Globals_1_g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
	    [branch]
	    if (_12885)
	    {
	        _10251 = input_1.xyz * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = input_1.xyz;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _10061 = input_0 + PerViewConstantBufferCsgo_t_1_m19.xyz;
	    float4 _19414 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_2.xy);
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tLayer1AmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], input_2.xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tLayer1NormalRoughness].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_2.zw);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _8418 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = !gl_FrontFacing;
	    }
	    else
	    {
	        _24327 = false;
	    }
	    float3 _12631 = input_1.xyz * (_24327 ? (-1.0f) : 1.0f);
	    float3 _14435 = cross(_12631.xyz, input_4.xyz) * ((input_4.w > 0.0f) ? 1.0f : (-1.0f));
	    float3 _7424;
	    if (bool4(PerViewConstantBufferCsgo_t_1_m2.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m2.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m2.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m2.w != int4(0, 0, 0, 0).w).w)
	    {
	        _7424 = -_14435;
	    }
	    else
	    {
	        _7424 = _14435;
	    }
	    float3 _20480;
	    if (!_24327)
	    {
	        float3 _7482 = _8418;
	        _7482.y = -_8418.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _8418;
	    }
	    float3 _14786 = normalize((((input_4.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    float3 _7978 = -_24347;
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21709;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
	        float2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m9) * PerViewConstantBufferCsgo_t_1_m8.xy) + (PerViewConstantBufferCsgo_t_1_m8.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _11086).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        float2 _23168;
	        if (_12285)
	        {
	            _23168 = float2(PerViewConstantBufferCsgo_t_1_m8.x, 0.0f);
	        }
	        else
	        {
	            _23168 = 0.0f.xx;
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        float2 _23169;
	        if (_12286)
	        {
	            _23169 = float2(0.0f, PerViewConstantBufferCsgo_t_1_m8.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        bool2 _13083 = (abs(_18418.y) < (_12286 ? _15372 : _20965)).xx;
	        float4 _10010 = normalize(float4(PerViewLightingConstantBufferGpu_t_1_m2.x * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.y * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.z * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.w * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xy, 0.25f))), 0.5f, 0.5f)));
	        float4 _13232 = max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx) * normalize(clamp(((_10010 - max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)).xxxx) + 0.20000000298023223876953125f.xxxx) * 5.0f.xxxx, 0.0f.xxxx, 1.0f.xxxx));
	        _21709 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11086 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m8.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m8.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21709 = 1.0f;
	    }
	    float _21710;
	    [branch]
	    if (PerViewLightingConstantBufferGpu_t_1_m10 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        float3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m10))
	            {
	                _13136 = 1.0f;
	                _14975 = 0.0f.xxx;
	                _10191 = -1;
	                break;
	            }
	            float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039], float4(input_0.xyz, 1.0f));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t_1_m12[_13039])
	            {
	                float3 _19470 = float3(_12779, _18322.yz);
	                float2 _24804 = _19470.xy;
	                float2 _22193 = 1.0f.xx - clamp((abs(_24804) * PerViewLightingConstantBufferGpu_t_1_m14.xx) + PerViewLightingConstantBufferGpu_t_1_m13.xx, 0.0f.xx, 1.0f.xx);
	                float2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039].xy;
	                float3 _20488 = _19470;
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
	        float _19363;
	        if (_10191 >= 0)
	        {
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t_1_m11));
	            float _12501;
	            [branch]
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m10 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335], float4(input_0.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t_1_m11));
	                }
	                else
	                {
	                    _7934 = 1.0f;
	                }
	                _12501 = lerp(_7934, _18270, _13136);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _19363 = _12501;
	        }
	        else
	        {
	            _19363 = 1.0f;
	        }
	        float _13279 = lerp(_19363, 1.0f, saturate((distance(_10061.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m16) + PerViewLightingConstantBufferGpu_t_1_m15));
	        float _12502;
	        if (_24465.y)
	        {
	            _12502 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21710 = _12502;
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float3 _21711;
	    [branch]
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m8.xyz, _24735) * _21710) > 0.0f)
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m8.xyz)).xxx.xyz * (PerViewLightingConstantBufferGpu_t_1_m9.xyz * _21710).xyz);
	    }
	    else
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19364;
	    if (_20060)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m7, float4(_10061.xyz, 1.0f).xyzw);
	        float _20176 = _18621.w;
	        float2 _11414 = _18621.xy / _20176.xx;
	        float4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0f) * PerViewConstantBuffer_t_1_m1.x) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.x - 1.0f);
	        _6651.y = clamp(((1.0f - _11414.y) * PerViewConstantBuffer_t_1_m1.y) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.y - 1.0f);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uint2 _12083 = uint2(_19364.xy - PerViewConstantBuffer_t_1_m0.xy) >> PerViewLightingConstantBufferGpu_t_1_m6.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m5.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t_1_m7.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m7.y)) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    float3 _13155;
	    _13155 = _21711;
	    uint _21567;
	    float3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t_1_m5.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load((_10838 + _16208) * 4 + 0) & g_CullBits.Load((_23393 + _16208) * 4 + 0));
	        _13156 = _13155;
	        uint _20344;
	        float3 _12504;
	        uint _16209 = _14475;
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(firstbitlow(_16209) + (_16208 * 32u));
	            _20344 = _16209 & (_16209 - 1u);
	            do
	            {
	                float4x4 _14097 = asfloat(uint4x4(g_BarnLights.Load(_12608 * 480 + 0), g_BarnLights.Load(_12608 * 480 + 16), g_BarnLights.Load(_12608 * 480 + 32), g_BarnLights.Load(_12608 * 480 + 48), g_BarnLights.Load(_12608 * 480 + 4), g_BarnLights.Load(_12608 * 480 + 20), g_BarnLights.Load(_12608 * 480 + 36), g_BarnLights.Load(_12608 * 480 + 52), g_BarnLights.Load(_12608 * 480 + 8), g_BarnLights.Load(_12608 * 480 + 24), g_BarnLights.Load(_12608 * 480 + 40), g_BarnLights.Load(_12608 * 480 + 56), g_BarnLights.Load(_12608 * 480 + 12), g_BarnLights.Load(_12608 * 480 + 28), g_BarnLights.Load(_12608 * 480 + 44), g_BarnLights.Load(_12608 * 480 + 60)));
	                float4 _24893 = mul(float4(input_0.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                float3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7425 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12887;
	                if (!_7425)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), _16509).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float _23571 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) - _18492, (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21775 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21775) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz - input_0.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    float3 _12302 = _10017 - _16268;
	                    float3 _10210;
	                    do
	                    {
	                        float3 _20229 = (_10017 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0f)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0f, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / _17647.xxx;
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w))) * saturate(asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).y * _17647))) * saturate(asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).y * dot(float3((1.0f - (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11179 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz;
	                    _11633 = _19667;
	                }
	                float3 _17828 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).xyz * 1.0f).xyz * _11633;
	                bool _24419;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).z > 0.0f)
	                {
	                    _24419 = !_20060;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                float3 _21548;
	                [branch]
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w == 0.0f)
	                {
	                    float _10342;
	                    do
	                    {
	                        float2 _22154 = abs(_22905.xy);
	                        if (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z == 0.0f)
	                        {
	                            _10342 = smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x, _22154.x) * smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0f / asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0f);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0f);
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
	                    float3 _12503;
	                    if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w < 0.0f)
	                    {
	                        float4 _17795 = float4(-asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).xyz, asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w);
	                        float4 _19008 = _17795.xyzw * float4(-1.0f, -1.0f, -1.0f, 1.0f);
	                        float3 _24989 = _19008.xyz;
	                        float3 _23629 = float4((-_11179).xyz, 0.0f).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        float3 _20479 = float4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        float3 _23592 = _17795.xyz;
	                        float3 _12170 = ((_20479 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20564 = (_14081.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _20491.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _20490.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float3 _19630;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load(_12608 * 480 + 264) & 4u) != 0u)
	                    {
	                        float2 _6281 = _22905.yx * float2(1.0f, -1.0f);
	                        float3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t_1_m11)), asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
	                    float3 _16449 = _20482.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
	                    {
	                        _12504 = _13156;
	                        break;
	                    }
	                    _19630 = _20482;
	                }
	                else
	                {
	                    _19630 = _21548;
	                }
	                _12504 = _13156.xyz + (max(0.0f, dot(_14786.xyz, _11179.xyz)).xxx.xyz * _19630.xyz);
	                break;
	            } while(false);
	            _13156 = _12504;
	            _16209 = _20344;
	            continue;
	        }
	        _21567 = _16208 + 1u;
	        _13155 = _13156;
	        _16208 = _21567;
	        continue;
	    }
	    float3 _22686 = (_13155.xyz + (float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz * (_21709 * _19068.x).xxx.xyz).xyz) * (((_19414.xyz * _Globals_1_g_vLayer1Tint.xyz).xyz * input_3.xyz).xyz * (1.0f - _Globals_1_g_flMetalness)).xyz;
	    float4 _11204 = float4(_22686, input_3.w);
	    _11204.x = _22686.x;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _10666 = _10061.xyz - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _10666.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _10666.xyz;
	            bool _12888;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m13.x)
	            {
	                _12888 = (_10061.z * PerViewConstantBufferCsgo_t_1_m13.z) < PerViewConstantBufferCsgo_t_1_m13.y;
	            }
	            else
	            {
	                _12888 = false;
	            }
	            [branch]
	            if (_12888)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m10.xy + (PerViewConstantBufferCsgo_t_1_m10.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m11.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m11.y)) * PerViewConstantBufferCsgo_t_1_m12.w;
	                _19340 = lerp(_11204.xyz, float4(PerViewConstantBufferCsgo_t_1_m12.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _11204.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _11204;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12889;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m17.x)
	            {
	                _12889 = (PerViewConstantBufferCsgo_t_1_m17.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m17.y;
	            }
	            else
	            {
	                _12889 = false;
	            }
	            if (_12889)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m14.y) + PerViewConstantBufferCsgo_t_1_m14.x), PerViewConstantBufferCsgo_t_1_m14.w)) * saturate(pow(max(0.0f, (_10061.z * PerViewConstantBufferCsgo_t_1_m15.y) + PerViewConstantBufferCsgo_t_1_m15.x), PerViewConstantBufferCsgo_t_1_m15.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m17.w;
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m16).xyz).xyz, PerViewConstantBufferCsgo_t_1_m15.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m14.z))) * PerViewConstantBufferCsgo_t_1_m18.x).xyz, _8892).xyz, _8892.xxx);
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
	        _6805 = _11204;
	    }
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    gl_FrontFacing = stage_input.gl_FrontFacing;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	TextureAttribute(LightSim_DiffuseAlbedoTexture1, g_tColor);
	TextureAttribute(RepresentativeTexture1, g_tColor);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(overlay, F_OVERLAY ? 1 : 0);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_LAYERS == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_DETAILBLENDMODE == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ALPHA_TEST == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_MODE_TOOLS_VIS == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_OVERLAY == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_OVERLAY == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_SPECULAR_INDIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_SPECULAR_DIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_LAYERS == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_DETAILTEXTURE == 2)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_TRANSLUCENT == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_DETAILBLENDMODE == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(BlendEnable, true);
	RenderState(BlendEnable0, true);
	RenderState(BlendEnable1, true);
	RenderState(BlendEnable2, true);
	RenderState(ColorWriteEnable0, R|G|B);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, -64);
	RenderState(DepthBiasClamp, 0);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthFunc, Equal);
	RenderState(DepthWriteEnable, false);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(DstBlend0, One);
	RenderState(DstBlend1, One);
	RenderState(DstBlend2, One);
	RenderState(DstBlendAlpha0, One);
	RenderState(DstBlendAlpha1, One);
	RenderState(DstBlendAlpha2, One);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(SrcBlend0, One);
	RenderState(SrcBlend1, One);
	RenderState(SrcBlend2, One);
	RenderState(SrcBlendAlpha0, One);
	RenderState(SrcBlendAlpha1, One);
	RenderState(SrcBlendAlpha2, One);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	#if (S_LAYERS == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ALPHA_TEST == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_TRANSLUCENT == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_OVERLAY == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_LAYERS == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	#endif
	#if (S_DETAILTEXTURE == 2)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	#endif
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, false);
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, false);
	#endif
	#if (S_OVERLAY == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, false);
	#endif
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_LAYERS, F_LAYERS );
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING!=0 );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_TEXTURETRANSFORMS, F_TEXTURETRANSFORMS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_DETAILBLENDMODE, F_DETAILBLENDMODE );
	StaticCombo( S_OVERLAY, F_OVERLAY );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow0( S_OVERLAY ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAILTEXTURE==2, S_LAYERS==1 ) );
	StaticComboRule( Requires( S_DETAILBLENDMODE, S_DETAILTEXTURE==2, S_LAYERS==1 ) );
	StaticComboRule( Requires( S_OVERLAY, S_TRANSLUCENT, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_OVERLAY, S_LAYERS ) );
	StaticComboRule( Requires( S_TRANSLUCENT, S_LAYERS==0 ) );
	StaticComboRule( Requires( S_ALPHA_TEST, S_LAYERS==0 ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool g_bAddBumpMaps < UiType(CheckBox); Expression(F_ADDBUMPMAPS ? 1 : 0); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bNoSpecularAtFullRoughness < UiType(CheckBox); Expression(F_NO_SPECULAR_AT_FULL_ROUGHNESS ? 1 : 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	int g_nFancyBlendingMode < UiType(Slider); Expression(F_FANCY_BLENDING); >;
	Texture2D g_tBlendModulation < Channel(RGBA, Box(TextureBlendModulation), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayer1Detail < Channel(RGB, Box(TextureLayer1Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer1NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer1Normal, TextureLayer1Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2Color < Channel(RGB, ArtistDefined(TextureLayer2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tLayer2Detail < Channel(RGB, Box(TextureLayer2Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer2Normal, TextureLayer2Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float4 g_vBlendModulateTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flBlendModulateTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vBlendModulateTexCoordScale.x,-v2*g_vBlendModulateTexCoordScale.y,0,g_vBlendModulateTexCoordCenter.x+g_vBlendModulateTexCoordOffset.x+v2*g_vBlendModulateTexCoordScale.y*g_vBlendModulateTexCoordCenter.y-v1*g_vBlendModulateTexCoordScale.x*g_vBlendModulateTexCoordCenter.x)); >;
	float4 g_vBlendModulateTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flBlendModulateTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vBlendModulateTexCoordScale.x,v1*g_vBlendModulateTexCoordScale.y,0,g_vBlendModulateTexCoordCenter.y+g_vBlendModulateTexCoordOffset.y+v2*g_vBlendModulateTexCoordScale.x*g_vBlendModulateTexCoordCenter.x-v1*g_vBlendModulateTexCoordScale.y*g_vBlendModulateTexCoordCenter.y)); >;
	float4 g_vLayer1NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer1NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1NormalTexCoordScale.x,-v2*g_vLayer1NormalTexCoordScale.y,0,g_vLayer1NormalTexCoordCenter.x+g_vLayer1NormalTexCoordOffset.x+v2*g_vLayer1NormalTexCoordScale.y*g_vLayer1NormalTexCoordCenter.y-v1*g_vLayer1NormalTexCoordScale.x*g_vLayer1NormalTexCoordCenter.x)); >;
	float4 g_vLayer1NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer1NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1NormalTexCoordScale.x,v1*g_vLayer1NormalTexCoordScale.y,0,g_vLayer1NormalTexCoordCenter.y+g_vLayer1NormalTexCoordOffset.y+v2*g_vLayer1NormalTexCoordScale.x*g_vLayer1NormalTexCoordCenter.x-v1*g_vLayer1NormalTexCoordScale.y*g_vLayer1NormalTexCoordCenter.y)); >;
	float4 g_vLayer1TexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer1TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1TexCoordScale.x,-v2*g_vLayer1TexCoordScale.y,0,g_vLayer1TexCoordCenter.x+g_vLayer1TexCoordOffset.x+v2*g_vLayer1TexCoordScale.y*g_vLayer1TexCoordCenter.y-v1*g_vLayer1TexCoordScale.x*g_vLayer1TexCoordCenter.x)); >;
	float4 g_vLayer1TexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer1TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1TexCoordScale.x,v1*g_vLayer1TexCoordScale.y,0,g_vLayer1TexCoordCenter.y+g_vLayer1TexCoordOffset.y+v2*g_vLayer1TexCoordScale.x*g_vLayer1TexCoordCenter.x-v1*g_vLayer1TexCoordScale.y*g_vLayer1TexCoordCenter.y)); >;
	float4 g_vLayer2NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer2NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2NormalTexCoordScale.x,-v2*g_vLayer2NormalTexCoordScale.y,0,g_vLayer2NormalTexCoordCenter.x+g_vLayer2NormalTexCoordOffset.x+v2*g_vLayer2NormalTexCoordScale.y*g_vLayer2NormalTexCoordCenter.y-v1*g_vLayer2NormalTexCoordScale.x*g_vLayer2NormalTexCoordCenter.x)); >;
	float4 g_vLayer2NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer2NormalTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2NormalTexCoordScale.x,v1*g_vLayer2NormalTexCoordScale.y,0,g_vLayer2NormalTexCoordCenter.y+g_vLayer2NormalTexCoordOffset.y+v2*g_vLayer2NormalTexCoordScale.x*g_vLayer2NormalTexCoordCenter.x-v1*g_vLayer2NormalTexCoordScale.y*g_vLayer2NormalTexCoordCenter.y)); >;
	float4 g_vLayer2TexCoordXform0 < UiType(VectorText); Expression(v0 = g_flLayer2TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2TexCoordScale.x,-v2*g_vLayer2TexCoordScale.y,0,g_vLayer2TexCoordCenter.x+g_vLayer2TexCoordOffset.x+v2*g_vLayer2TexCoordScale.y*g_vLayer2TexCoordCenter.y-v1*g_vLayer2TexCoordScale.x*g_vLayer2TexCoordCenter.x)); >;
	float4 g_vLayer2TexCoordXform1 < UiType(VectorText); Expression(v0 = g_flLayer2TexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2TexCoordScale.x,v1*g_vLayer2TexCoordScale.y,0,g_vLayer2TexCoordCenter.y+g_vLayer2TexCoordOffset.y+v2*g_vLayer2TexCoordScale.x*g_vLayer2TexCoordCenter.x-v1*g_vLayer2TexCoordScale.y*g_vLayer2TexCoordCenter.y)); >;
	
	// Blend Modulation
	CreateInputTexture2D(TextureBlendModulation, Linear, 8, "", "_blend", "Blend Modulation,20 / Texture,10 / 10", Default4(0.5, 0.5, 0.5, 0.5));
	float2 g_vBlendModulateTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 20"); >;
	float2 g_vBlendModulateTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 30"); >;
	float g_flBlendModulateTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 40"); >;
	float2 g_vBlendModulateTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 50"); >;
	float g_flBlendSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 60"); >;
	float g_flLayerBorderStrength < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 70"); >;
	float g_flLayerBorderOffset < Range(-1, 1); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 80"); Expression(-this); >;
	float g_flLayerBorderSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 90"); >;
	float3 g_vLayerBorderTint < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Modulation,20 / Texture,10 / 100"); Expression(SrgbGammaToLinear(this)); >;
	
	// PBR 1
	CreateInputTexture2D(TextureLayer1Color, Srgb, 8, "", "_color", "PBR 1,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 1,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer1Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 1,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer1Roughness, Linear, 8, "Inverse", "_rough", "PBR 1,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Translucency, Linear, 8, "", "_trans", "PBR 1,10 / Albedo Translucency,15 / 10", Default4(1, 1, 1, 0));
	float2 g_vLayer1DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 15"); >;
	float4 g_vLayer1DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 20"); >;
	float3 g_vLayer1Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 1,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	float2 g_vLayer1NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 30"); >;
	float2 g_vLayer1TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 30"); >;
	float2 g_vLayer1NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 40"); >;
	float2 g_vLayer1TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 40"); >;
	float g_flLayer1NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Normal,20 / 50"); >;
	float g_flLayer1TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Albedo,10 / 50"); >;
	float2 g_vLayer1NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 60"); >;
	float2 g_vLayer1TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 60"); >;
	
	// PBR 2
	CreateInputTexture2D(TextureLayer2Color, Srgb, 8, "", "_color", "PBR 2,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer2Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 2,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer2Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 2,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer2Roughness, Linear, 8, "Inverse", "_rough", "PBR 2,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	float2 g_vLayer2DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 15"); >;
	float4 g_vLayer2DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 20"); >;
	float3 g_vLayer2Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 2,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	float2 g_vLayer2NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 30"); >;
	float2 g_vLayer2TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 30"); >;
	float2 g_vLayer2NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 40"); >;
	float2 g_vLayer2TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 40"); >;
	float g_flLayer2NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Normal,20 / 50"); >;
	float g_flLayer2TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Albedo,10 / 50"); >;
	float2 g_vLayer2NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 60"); >;
	float2 g_vLayer2TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 60"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Lighting
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flVertexColorOpacityScale < Default(1); UiType(Slider); UiGroup("Color, 10/25"); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_LAYERS == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	#endif
	#if (S_DETAILTEXTURE == 2)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_DETAILBLENDMODE == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
	#extension GL_EXT_shader_16bit_storage : require
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
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
	
	struct VS_INPUT
	{
	    vec3 vPositionOs;
	    vec2 vTexCoord;
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
	};
	
	struct PackedRtxInstanceData_t_natural
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct _Array_natural_vector_int_4_8
	{
	    ivec4 data[8];
	};
	
	struct GeometryInfo_t_natural
	{
	    ivec4 m_nVertexAndIndexBuffers;
	    ivec4 m_nBufferBindOffsetBytes;
	    ivec4 m_nBufferStrideInBytes;
	    ivec4 m_vNormalFieldInfo;
	    ivec4 m_vTangentFieldInfo;
	    _Array_natural_vector_int_4_8 m_vTexCoordFieldInfo;
	    _Array_natural_vector_int_4_8 m_vColorFieldInfo;
	};
	
	struct BuiltInTriangleIntersectionAttributes
	{
	    vec2 barycentrics;
	};
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vNormalWs;
	    float16_t flMetalness;
	    f16vec3 vAlbedo;
	    float16_t flRoughness;
	    f16vec3 vEmissive;
	    float16_t flReflectance;
	    uint nMaterialTypeAndFlags;
	    f16vec4 vMaterialBits;
	};
	
	struct Payload_t
	{
	    vec3 vSmoothPositionWs;
	    vec3 vFaceNormalWs;
	    vec3 vInterpolatedNormalWs;
	    float flHitT;
	    float flOpacityRng;
	    int nInstance;
	    bool bFlippedNormal;
	    MaterialDataMinimal_t material;
	};
	
	vec4 _415;
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData
	{
	    float _member0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    uint _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _member0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_Geometries
	{
	    GeometryInfo_t_natural _member0[];
	} g_Geometries_1;
	
	layout(set = 3, binding = 33, std430) readonly buffer g_Indices
	{
	    uint _member0[];
	} g_Indices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices
	{
	    float _member0[];
	} g_Vertices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices_2
	{
	    uint _member0[];
	} g_Vertices_3[];
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes attrs;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	
	void main()
	{
	    uint _442 = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    vec3 _479 = vec3(g_MaterialData_1._member0[_442 / 4u], g_MaterialData_1._member0[(_442 + 4u) / 4u], g_MaterialData_1._member0[(_442 + 8u) / 4u]);
	    float _478 = g_MaterialData_1._member0[(_442 + 12u) / 4u];
	    float _477 = g_MaterialData_1._member0[(_442 + 16u) / 4u];
	    uint _476 = g_MaterialData_3._member0[(_442 + 48u) / 4u];
	    uint _475 = g_MaterialData_3._member0[(_442 + 56u) / 4u];
	    uint _474 = g_MaterialData_3._member0[(_442 + 60u) / 4u];
	    vec3 _473 = vec3(g_MaterialData_1._member0[(_442 + 80u) / 4u], g_MaterialData_1._member0[(_442 + 84u) / 4u], g_MaterialData_1._member0[(_442 + 88u) / 4u]);
	    bool _472 = g_MaterialData_5._member0[(_442 + 96u) / 4u] != 0;
	    bool _471 = g_MaterialData_5._member0[(_442 + 104u) / 4u] != 0;
	    bool _470 = g_MaterialData_5._member0[(_442 + 108u) / 4u] != 0;
	    float _469 = g_MaterialData_1._member0[(_442 + 196u) / 4u];
	    uvec3 _565;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _679 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _565 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_679 / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_679 + 4u) / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_679 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _658 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _659 = _658 & 4294967292u;
	            uint _54 = _659 / 4u;
	            uint _57 = (_659 + 4u) / 4u;
	            uint _663 = (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_54] & 4294901760u) >> uint(16);
	            uint _664 = g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_57] & 65535u;
	            uvec3 _566;
	            if (_658 == _659)
	            {
	                _566 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_54] & 65535u, _663, _664);
	            }
	            else
	            {
	                _566 = uvec3(_663, _664, (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_57] & 4294901760u) >> uint(16));
	            }
	            _565 = _566;
	            break;
	        }
	        break;
	    } while(false);
	    uint _70 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _701 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _565) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _560[3];
	    uint _703 = _701.x;
	    _560[0] = vec3(g_Vertices_1[nonuniformEXT(_70)]._member0[_703 / 4u], g_Vertices_1[nonuniformEXT(_70)]._member0[(_703 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_70)]._member0[(_703 + 8u) / 4u]);
	    uint _708 = _701.y;
	    _560[1] = vec3(g_Vertices_1[nonuniformEXT(_70)]._member0[_708 / 4u], g_Vertices_1[nonuniformEXT(_70)]._member0[(_708 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_70)]._member0[(_708 + 8u) / 4u]);
	    uint _713 = _701.z;
	    _560[2] = vec3(g_Vertices_1[nonuniformEXT(_70)]._member0[_713 / 4u], g_Vertices_1[nonuniformEXT(_70)]._member0[(_713 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_70)]._member0[(_713 + 8u) / 4u]);
	    int _561 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_561 < 3))
	        {
	            break;
	        }
	        vsInput[_561].vPositionOs = _560[_561];
	        _561++;
	        continue;
	    }
	    vec2 _562[3];
	    _562[0] = vec2(0.0);
	    _562[1] = vec2(0.0);
	    _562[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _559 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _99 = uint(_559[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _755 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _557 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _558 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _771 = (uvec3(uint(_557[_755])) * _565) + uvec3(uint(_558[_755]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _885 = _771.x;
	            _562[0] = vec2(g_Vertices_1[nonuniformEXT(_99)]._member0[_885 / 4u], g_Vertices_1[nonuniformEXT(_99)]._member0[(_885 + 4u) / 4u]);
	            uint _888 = _771.y;
	            _562[1] = vec2(g_Vertices_1[nonuniformEXT(_99)]._member0[_888 / 4u], g_Vertices_1[nonuniformEXT(_99)]._member0[(_888 + 4u) / 4u]);
	            uint _891 = _771.z;
	            _562[2] = vec2(g_Vertices_1[nonuniformEXT(_99)]._member0[_891 / 4u], g_Vertices_1[nonuniformEXT(_99)]._member0[(_891 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _111 = _771.x / 4u;
	                _562[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_99)]._member0[_111], g_Vertices_3[nonuniformEXT(_99)]._member0[_111] >> uint(16)) & uvec2(65535u))));
	                uint _114 = _771.y / 4u;
	                _562[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_99)]._member0[_114], g_Vertices_3[nonuniformEXT(_99)]._member0[_114] >> uint(16)) & uvec2(65535u))));
	                uint _117 = _771.z / 4u;
	                _562[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_99)]._member0[_117], g_Vertices_3[nonuniformEXT(_99)]._member0[_117] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _101 = _771.x / 4u;
	                    uint _784 = g_Vertices_3[nonuniformEXT(_99)]._member0[_101] & 65535u;
	                    int _556;
	                    if (_784 > 32767u)
	                    {
	                        _556 = int(4294901760u | _784);
	                    }
	                    else
	                    {
	                        _556 = int(_784);
	                    }
	                    uint _797 = (g_Vertices_3[nonuniformEXT(_99)]._member0[_101] & 4294901760u) >> uint(16);
	                    int _555;
	                    if (_797 > 32767u)
	                    {
	                        _555 = int(4294901760u | _797);
	                    }
	                    else
	                    {
	                        _555 = int(_797);
	                    }
	                    _562[0] = vec2(max(float(_556) * 3.0518509447574615478515625e-05, -1.0), max(float(_555) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _104 = _771.y / 4u;
	                    uint _811 = g_Vertices_3[nonuniformEXT(_99)]._member0[_104] & 65535u;
	                    int _554;
	                    if (_811 > 32767u)
	                    {
	                        _554 = int(4294901760u | _811);
	                    }
	                    else
	                    {
	                        _554 = int(_811);
	                    }
	                    uint _824 = (g_Vertices_3[nonuniformEXT(_99)]._member0[_104] & 4294901760u) >> uint(16);
	                    int _553;
	                    if (_824 > 32767u)
	                    {
	                        _553 = int(4294901760u | _824);
	                    }
	                    else
	                    {
	                        _553 = int(_824);
	                    }
	                    _562[1] = vec2(max(float(_554) * 3.0518509447574615478515625e-05, -1.0), max(float(_553) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _107 = _771.z / 4u;
	                    uint _838 = g_Vertices_3[nonuniformEXT(_99)]._member0[_107] & 65535u;
	                    int _552;
	                    if (_838 > 32767u)
	                    {
	                        _552 = int(4294901760u | _838);
	                    }
	                    else
	                    {
	                        _552 = int(_838);
	                    }
	                    uint _851 = (g_Vertices_3[nonuniformEXT(_99)]._member0[_107] & 4294901760u) >> uint(16);
	                    int _551;
	                    if (_851 > 32767u)
	                    {
	                        _551 = int(4294901760u | _851);
	                    }
	                    else
	                    {
	                        _551 = int(_851);
	                    }
	                    _562[2] = vec2(max(float(_552) * 3.0518509447574615478515625e-05, -1.0), max(float(_551) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _561 = 0;
	    for (;;)
	    {
	        if (!(_561 < 3))
	        {
	            break;
	        }
	        vsInput[_561].vTexCoord = _562[_561];
	        _561++;
	        continue;
	    }
	    vec3 _563[3];
	    vec4 _564[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _537 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _139 = uint(_537[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _935 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _535 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _536 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _951 = (uvec3(uint(_535[_935])) * _565) + uvec3(uint(_536[_935]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1452 = _951.x;
	                _563[0] = vec3(g_Vertices_1[nonuniformEXT(_139)]._member0[_1452 / 4u], g_Vertices_1[nonuniformEXT(_139)]._member0[(_1452 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_139)]._member0[(_1452 + 8u) / 4u]);
	                uint _1457 = _951.y;
	                _563[1] = vec3(g_Vertices_1[nonuniformEXT(_139)]._member0[_1457 / 4u], g_Vertices_1[nonuniformEXT(_139)]._member0[(_1457 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_139)]._member0[(_1457 + 8u) / 4u]);
	                uint _1462 = _951.z;
	                _563[2] = vec3(g_Vertices_1[nonuniformEXT(_139)]._member0[_1462 / 4u], g_Vertices_1[nonuniformEXT(_139)]._member0[(_1462 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_139)]._member0[(_1462 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1206 = _951.x;
	                    uvec2 _1208 = uvec2(g_Vertices_3[nonuniformEXT(_139)]._member0[_1206 / 4u], g_Vertices_3[nonuniformEXT(_139)]._member0[(_1206 + 4u) / 4u]);
	                    uint _1209 = _951.y;
	                    uvec2 _433 = uvec2(g_Vertices_3[nonuniformEXT(_139)]._member0[_1209 / 4u], g_Vertices_3[nonuniformEXT(_139)]._member0[(_1209 + 4u) / 4u]);
	                    uint _1212 = _951.z;
	                    uvec2 _432 = uvec2(g_Vertices_3[nonuniformEXT(_139)]._member0[_1212 / 4u], g_Vertices_3[nonuniformEXT(_139)]._member0[(_1212 + 4u) / 4u]);
	                    uint _1218 = _1208.x;
	                    uint _1226 = _1208.y;
	                    vec2 _1236 = ((vec2(float(_1218 & 65535u), float((_1218 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1237 = _1236.x;
	                    float _1242 = (1.0 - abs(_1237)) - abs(_1236.y);
	                    vec3 _1243 = vec3(_1237, _1236.y, _1242);
	                    float _1245 = saturate(-_1242);
	                    vec2 _1251 = _1236 + mix(vec2(_1245), vec2(-_1245), greaterThanEqual(_1236, vec2(0.0)));
	                    _1243.x = _1251.x;
	                    _1243.y = _1251.y;
	                    vec3 _539 = normalize(_1243);
	                    vec2 _1258 = ((vec2(float((_1226 >> uint(1)) & 32767u), float((_1226 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1259 = _1258.x;
	                    float _1264 = (1.0 - abs(_1259)) - abs(_1258.y);
	                    vec3 _1265 = vec3(_1259, _1258.y, _1264);
	                    float _1267 = saturate(-_1264);
	                    vec2 _1273 = _1258 + mix(vec2(_1267), vec2(-_1267), greaterThanEqual(_1258, vec2(0.0)));
	                    _1265.x = _1273.x;
	                    _1265.y = _1273.y;
	                    vec3 _538 = normalize(_1265);
	                    float _525;
	                    if ((_1226 & 1u) != 0u)
	                    {
	                        _525 = 1.0;
	                    }
	                    else
	                    {
	                        _525 = -1.0;
	                    }
	                    _563[0] = _539;
	                    _564[0].w = _525;
	                    _564[0].x = _538.x;
	                    _564[0].y = _538.y;
	                    _564[0].z = _538.z;
	                    vec2 _1315 = ((vec2(float(_433.x & 65535u), float((_433.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1316 = _1315.x;
	                    float _1321 = (1.0 - abs(_1316)) - abs(_1315.y);
	                    vec3 _1322 = vec3(_1316, _1315.y, _1321);
	                    float _1324 = saturate(-_1321);
	                    vec2 _1330 = _1315 + mix(vec2(_1324), vec2(-_1324), greaterThanEqual(_1315, vec2(0.0)));
	                    _1322.x = _1330.x;
	                    _1322.y = _1330.y;
	                    vec3 _541 = normalize(_1322);
	                    vec2 _1337 = ((vec2(float((_433.y >> uint(1)) & 32767u), float((_433.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1338 = _1337.x;
	                    float _1343 = (1.0 - abs(_1338)) - abs(_1337.y);
	                    vec3 _1344 = vec3(_1338, _1337.y, _1343);
	                    float _1346 = saturate(-_1343);
	                    vec2 _1352 = _1337 + mix(vec2(_1346), vec2(-_1346), greaterThanEqual(_1337, vec2(0.0)));
	                    _1344.x = _1352.x;
	                    _1344.y = _1352.y;
	                    vec3 _540 = normalize(_1344);
	                    float _524;
	                    if ((_433.y & 1u) != 0u)
	                    {
	                        _524 = 1.0;
	                    }
	                    else
	                    {
	                        _524 = -1.0;
	                    }
	                    _563[1] = _541;
	                    _564[1].w = _524;
	                    _564[1].x = _540.x;
	                    _564[1].y = _540.y;
	                    _564[1].z = _540.z;
	                    vec2 _1394 = ((vec2(float(_432.x & 65535u), float((_432.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1395 = _1394.x;
	                    float _1400 = (1.0 - abs(_1395)) - abs(_1394.y);
	                    vec3 _1401 = vec3(_1395, _1394.y, _1400);
	                    float _1403 = saturate(-_1400);
	                    vec2 _1409 = _1394 + mix(vec2(_1403), vec2(-_1403), greaterThanEqual(_1394, vec2(0.0)));
	                    _1401.x = _1409.x;
	                    _1401.y = _1409.y;
	                    vec3 _543 = normalize(_1401);
	                    vec2 _1416 = ((vec2(float((_432.y >> uint(1)) & 32767u), float((_432.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1417 = _1416.x;
	                    float _1422 = (1.0 - abs(_1417)) - abs(_1416.y);
	                    vec3 _1423 = vec3(_1417, _1416.y, _1422);
	                    float _1425 = saturate(-_1422);
	                    vec2 _1431 = _1416 + mix(vec2(_1425), vec2(-_1425), greaterThanEqual(_1416, vec2(0.0)));
	                    _1423.x = _1431.x;
	                    _1423.y = _1431.y;
	                    vec3 _542 = normalize(_1423);
	                    float _523;
	                    if ((_432.y & 1u) != 0u)
	                    {
	                        _523 = 1.0;
	                    }
	                    else
	                    {
	                        _523 = -1.0;
	                    }
	                    _563[2] = _543;
	                    _564[2].w = _523;
	                    _564[2].x = _542.x;
	                    _564[2].y = _542.y;
	                    _564[2].z = _542.z;
	                    break;
	                }
	                else
	                {
	                    uint _141 = _951.x / 4u;
	                    vec4 _545 = _564[0];
	                    float _973 = (float((g_Vertices_3[nonuniformEXT(_139)]._member0[_141] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _976 = (float((g_Vertices_3[nonuniformEXT(_139)]._member0[_141] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _980 = (1.0 - abs(_973)) - abs(_976);
	                    vec3 _981 = vec3(_973, _976, _980);
	                    float _983 = saturate(-_980);
	                    vec2 _984 = vec2(_973, _976);
	                    vec2 _990 = _984 + mix(vec2(_983), vec2(-_983), greaterThanEqual(_984, vec2(0.0)));
	                    _981.x = _990.x;
	                    _981.y = _990.y;
	                    vec3 _995 = normalize(_981);
	                    vec3 _544 = _995;
	                    float _996 = _995.z;
	                    float _532;
	                    if (_996 >= 0.0)
	                    {
	                        _532 = 1.0;
	                    }
	                    else
	                    {
	                        _532 = -1.0;
	                    }
	                    float _1003 = (-1.0) / (_532 + _996);
	                    float _1004 = _995.x;
	                    vec3 _533;
	                    vec3 _1012 = _533;
	                    _1012.x = 1.0 + (((_532 * _1004) * _1004) * _1003);
	                    _1012.y = _532 * ((_1004 * _995.y) * _1003);
	                    _1012.z = (-_532) * _1004;
	                    _533 = _1012;
	                    float _1020 = float((g_Vertices_3[nonuniformEXT(_139)]._member0[_141] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1026 = (_1012 * cos(_1020)) + (cross(_995, _1012) * sin(_1020));
	                    vec4 _1028 = _545;
	                    _1028.x = _1026.x;
	                    _1028.y = _1026.y;
	                    _1028.z = _1026.z;
	                    _545 = _1028;
	                    float _534;
	                    if ((g_Vertices_3[nonuniformEXT(_139)]._member0[_141] & 1u) == 0u)
	                    {
	                        _534 = -1.0;
	                    }
	                    else
	                    {
	                        _534 = 1.0;
	                    }
	                    vec4 _1039 = _545;
	                    _1039.w = _534;
	                    _545 = _1039;
	                    _563[0] = _544;
	                    _564[0] = _1039;
	                    uint _144 = _951.y / 4u;
	                    vec4 _547 = _564[1];
	                    float _1055 = (float((g_Vertices_3[nonuniformEXT(_139)]._member0[_144] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1058 = (float((g_Vertices_3[nonuniformEXT(_139)]._member0[_144] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1062 = (1.0 - abs(_1055)) - abs(_1058);
	                    vec3 _1063 = vec3(_1055, _1058, _1062);
	                    float _1065 = saturate(-_1062);
	                    vec2 _1066 = vec2(_1055, _1058);
	                    vec2 _1072 = _1066 + mix(vec2(_1065), vec2(-_1065), greaterThanEqual(_1066, vec2(0.0)));
	                    _1063.x = _1072.x;
	                    _1063.y = _1072.y;
	                    vec3 _1077 = normalize(_1063);
	                    vec3 _546 = _1077;
	                    float _1078 = _1077.z;
	                    float _529;
	                    if (_1078 >= 0.0)
	                    {
	                        _529 = 1.0;
	                    }
	                    else
	                    {
	                        _529 = -1.0;
	                    }
	                    float _1085 = (-1.0) / (_529 + _1078);
	                    float _1086 = _1077.x;
	                    vec3 _530;
	                    vec3 _1094 = _530;
	                    _1094.x = 1.0 + (((_529 * _1086) * _1086) * _1085);
	                    _1094.y = _529 * ((_1086 * _1077.y) * _1085);
	                    _1094.z = (-_529) * _1086;
	                    _530 = _1094;
	                    float _1102 = float((g_Vertices_3[nonuniformEXT(_139)]._member0[_144] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1108 = (_1094 * cos(_1102)) + (cross(_1077, _1094) * sin(_1102));
	                    vec4 _1110 = _547;
	                    _1110.x = _1108.x;
	                    _1110.y = _1108.y;
	                    _1110.z = _1108.z;
	                    _547 = _1110;
	                    float _531;
	                    if ((g_Vertices_3[nonuniformEXT(_139)]._member0[_144] & 1u) == 0u)
	                    {
	                        _531 = -1.0;
	                    }
	                    else
	                    {
	                        _531 = 1.0;
	                    }
	                    vec4 _1121 = _547;
	                    _1121.w = _531;
	                    _547 = _1121;
	                    _563[1] = _546;
	                    _564[1] = _1121;
	                    uint _147 = _951.z / 4u;
	                    vec4 _549 = _564[2];
	                    float _1137 = (float((g_Vertices_3[nonuniformEXT(_139)]._member0[_147] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1140 = (float((g_Vertices_3[nonuniformEXT(_139)]._member0[_147] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1144 = (1.0 - abs(_1137)) - abs(_1140);
	                    vec3 _1145 = vec3(_1137, _1140, _1144);
	                    float _1147 = saturate(-_1144);
	                    vec2 _1148 = vec2(_1137, _1140);
	                    vec2 _1154 = _1148 + mix(vec2(_1147), vec2(-_1147), greaterThanEqual(_1148, vec2(0.0)));
	                    _1145.x = _1154.x;
	                    _1145.y = _1154.y;
	                    vec3 _1159 = normalize(_1145);
	                    vec3 _548 = _1159;
	                    float _1160 = _1159.z;
	                    float _526;
	                    if (_1160 >= 0.0)
	                    {
	                        _526 = 1.0;
	                    }
	                    else
	                    {
	                        _526 = -1.0;
	                    }
	                    float _1167 = (-1.0) / (_526 + _1160);
	                    float _1168 = _1159.x;
	                    vec3 _527;
	                    vec3 _1176 = _527;
	                    _1176.x = 1.0 + (((_526 * _1168) * _1168) * _1167);
	                    _1176.y = _526 * ((_1168 * _1159.y) * _1167);
	                    _1176.z = (-_526) * _1168;
	                    _527 = _1176;
	                    float _1184 = float((g_Vertices_3[nonuniformEXT(_139)]._member0[_147] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1190 = (_1176 * cos(_1184)) + (cross(_1159, _1176) * sin(_1184));
	                    vec4 _1192 = _549;
	                    _1192.x = _1190.x;
	                    _1192.y = _1190.y;
	                    _1192.z = _1190.z;
	                    _549 = _1192;
	                    float _528;
	                    if ((g_Vertices_3[nonuniformEXT(_139)]._member0[_147] & 1u) == 0u)
	                    {
	                        _528 = -1.0;
	                    }
	                    else
	                    {
	                        _528 = 1.0;
	                    }
	                    vec4 _1203 = _549;
	                    _1203.w = _528;
	                    _549 = _1203;
	                    _563[2] = _548;
	                    _564[2] = _1203;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _563[0] = vec3(0.0);
	            _563[1] = vec3(0.0);
	            _563[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _550 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _197 = uint(_550[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1481 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _521 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _522 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1497 = (uvec3(uint(_521[_1481])) * _565) + uvec3(uint(_522[_1481]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1499 = _1497.x;
	            _564[0] = vec4(g_Vertices_1[nonuniformEXT(_197)]._member0[_1499 / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1499 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1499 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1499 + 12u) / 4u]);
	            uint _1505 = _1497.y;
	            _564[1] = vec4(g_Vertices_1[nonuniformEXT(_197)]._member0[_1505 / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1505 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1505 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1505 + 12u) / 4u]);
	            uint _1511 = _1497.z;
	            _564[2] = vec4(g_Vertices_1[nonuniformEXT(_197)]._member0[_1511 / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1511 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1511 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_197)]._member0[(_1511 + 12u) / 4u]);
	        }
	        else
	        {
	            _564[0] = vec4(0.0);
	            _564[1] = vec4(0.0);
	            _564[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _561 = 0;
	    for (;;)
	    {
	        if (!(_561 < 3))
	        {
	            break;
	        }
	        vsInput[_561].vNormalOs = _563[_561];
	        vsInput[_561].vTangentUOs_flTangentVSign = _564[_561];
	        _561++;
	        continue;
	    }
	    vec2 _441 = vsInput[0].vTexCoord;
	    vec3 _519 = vsInput[0].vNormalOs;
	    vec4 _520;
	    vec4 _1545 = _520;
	    _1545.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1545.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1545.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1545.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _520 = _1545;
	    vec4 _1568 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _518 = _1568;
	    vec3 _1569 = _1568.xyz;
	    vec3 _1570 = _1569 * vec3(0.077399380505084991455078125);
	    vec3 _1573 = pow((_1569 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _515;
	    if (_1568.x <= 0.040449999272823333740234375)
	    {
	        _515 = _1570.x;
	    }
	    else
	    {
	        _515 = _1573.x;
	    }
	    float _516;
	    if (_1568.y <= 0.040449999272823333740234375)
	    {
	        _516 = _1570.y;
	    }
	    else
	    {
	        _516 = _1573.y;
	    }
	    float _517;
	    if (_1568.z <= 0.040449999272823333740234375)
	    {
	        _517 = _1570.z;
	    }
	    else
	    {
	        _517 = _1573.z;
	    }
	    vec3 _1598 = vec3(_515, _516, _517);
	    vec4 _1600 = _518;
	    _1600.x = _1598.x;
	    _1600.y = _1598.y;
	    _1600.z = _1598.z;
	    _518 = _1600;
	    vec4 _444;
	    vec4 _1607 = _444;
	    _1607.x = _1600.x;
	    _1607.y = _1600.y;
	    _1607.z = _1600.z;
	    _1607.w = _1600.w;
	    _444 = _1607;
	    mat3x4 _1618 = transpose(gl_WorldToObjectEXT);
	    mat3 _514;
	    mat3 _1621 = _514;
	    _1621[0] = _1618[0].xyz;
	    _1621[1] = _1618[1].xyz;
	    _1621[2] = _1618[2].xyz;
	    _514 = _1621;
	    vec3 _1630 = normalize(_1621 * _519.xyz);
	    vec3 _445;
	    vec3 _1632 = _445;
	    _1632.x = _1630.x;
	    _1632.y = _1630.y;
	    _1632.z = _1630.z;
	    _445 = _1632;
	    mat3x4 _1644 = transpose(gl_WorldToObjectEXT);
	    mat3 _513;
	    mat3 _1647 = _513;
	    _1647[0] = _1644[0].xyz;
	    _1647[1] = _1644[1].xyz;
	    _1647[2] = _1644[2].xyz;
	    _513 = _1647;
	    vec3 _1656 = normalize(_1647 * _520.xyz);
	    vec4 _443;
	    vec4 _1658 = _443;
	    _1658.x = _1656.x;
	    _1658.y = _1656.y;
	    _1658.z = _1656.z;
	    _1658.w = _520.w;
	    _443 = _1658;
	    vec4 _1667 = _441.xyxy;
	    _1667.z = _441.x;
	    _1667.w = _441.y;
	    vec3 _1675 = mix(vec3(1.0), _1607.xyz, vec3(_477));
	    vec4 _1677 = _1607;
	    _1677.x = _1675.x;
	    _1677.y = _1675.y;
	    _1677.z = _1675.z;
	    vec3 _1685 = _1677.xyz * _479.xyz;
	    vec4 _1687 = _1677;
	    _1687.x = _1685.x;
	    _1687.y = _1685.y;
	    _1687.z = _1685.z;
	    _1687.w = _1687.w * _478;
	    vec3 _431 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _430 = _1632;
	    vec4 _429 = _1667;
	    vec4 _428 = _1687;
	    vec4 _427 = _1658;
	    vec2 _440 = vsInput[1].vTexCoord;
	    vec3 _511 = vsInput[1].vNormalOs;
	    vec4 _512;
	    vec4 _1703 = _512;
	    _1703.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _1703.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _1703.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _1703.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _512 = _1703;
	    vec4 _1726 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _510 = _1726;
	    vec3 _1727 = _1726.xyz;
	    vec3 _1728 = _1727 * vec3(0.077399380505084991455078125);
	    vec3 _1731 = pow((_1727 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _507;
	    if (_1726.x <= 0.040449999272823333740234375)
	    {
	        _507 = _1728.x;
	    }
	    else
	    {
	        _507 = _1731.x;
	    }
	    float _508;
	    if (_1726.y <= 0.040449999272823333740234375)
	    {
	        _508 = _1728.y;
	    }
	    else
	    {
	        _508 = _1731.y;
	    }
	    float _509;
	    if (_1726.z <= 0.040449999272823333740234375)
	    {
	        _509 = _1728.z;
	    }
	    else
	    {
	        _509 = _1731.z;
	    }
	    vec3 _1756 = vec3(_507, _508, _509);
	    vec4 _1758 = _510;
	    _1758.x = _1756.x;
	    _1758.y = _1756.y;
	    _1758.z = _1756.z;
	    _510 = _1758;
	    vec4 _447;
	    vec4 _1765 = _447;
	    _1765.x = _1758.x;
	    _1765.y = _1758.y;
	    _1765.z = _1758.z;
	    _1765.w = _1758.w;
	    _447 = _1765;
	    mat3x4 _1776 = transpose(gl_WorldToObjectEXT);
	    mat3 _506;
	    mat3 _1779 = _506;
	    _1779[0] = _1776[0].xyz;
	    _1779[1] = _1776[1].xyz;
	    _1779[2] = _1776[2].xyz;
	    _506 = _1779;
	    vec3 _1788 = normalize(_1779 * _511.xyz);
	    vec3 _448;
	    vec3 _1790 = _448;
	    _1790.x = _1788.x;
	    _1790.y = _1788.y;
	    _1790.z = _1788.z;
	    _448 = _1790;
	    mat3x4 _1802 = transpose(gl_WorldToObjectEXT);
	    mat3 _505;
	    mat3 _1805 = _505;
	    _1805[0] = _1802[0].xyz;
	    _1805[1] = _1802[1].xyz;
	    _1805[2] = _1802[2].xyz;
	    _505 = _1805;
	    vec3 _1814 = normalize(_1805 * _512.xyz);
	    vec4 _446;
	    vec4 _1816 = _446;
	    _1816.x = _1814.x;
	    _1816.y = _1814.y;
	    _1816.z = _1814.z;
	    _1816.w = _512.w;
	    _446 = _1816;
	    vec4 _1825 = _440.xyxy;
	    _1825.z = _440.x;
	    _1825.w = _440.y;
	    vec3 _1833 = mix(vec3(1.0), _1765.xyz, vec3(_477));
	    vec4 _1835 = _1765;
	    _1835.x = _1833.x;
	    _1835.y = _1833.y;
	    _1835.z = _1833.z;
	    vec3 _1843 = _1835.xyz * _479.xyz;
	    vec4 _1845 = _1835;
	    _1845.x = _1843.x;
	    _1845.y = _1843.y;
	    _1845.z = _1843.z;
	    _1845.w = _1845.w * _478;
	    vec3 _426 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _425 = _1790;
	    vec4 _424 = _1825;
	    vec4 _423 = _1845;
	    vec4 _422 = _1816;
	    vec2 _439 = vsInput[2].vTexCoord;
	    vec3 _503 = vsInput[2].vNormalOs;
	    vec4 _504;
	    vec4 _1861 = _504;
	    _1861.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _1861.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _1861.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _1861.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _504 = _1861;
	    vec4 _1884 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _502 = _1884;
	    vec3 _1885 = _1884.xyz;
	    vec3 _1886 = _1885 * vec3(0.077399380505084991455078125);
	    vec3 _1889 = pow((_1885 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _499;
	    if (_1884.x <= 0.040449999272823333740234375)
	    {
	        _499 = _1886.x;
	    }
	    else
	    {
	        _499 = _1889.x;
	    }
	    float _500;
	    if (_1884.y <= 0.040449999272823333740234375)
	    {
	        _500 = _1886.y;
	    }
	    else
	    {
	        _500 = _1889.y;
	    }
	    float _501;
	    if (_1884.z <= 0.040449999272823333740234375)
	    {
	        _501 = _1886.z;
	    }
	    else
	    {
	        _501 = _1889.z;
	    }
	    vec3 _1914 = vec3(_499, _500, _501);
	    vec4 _1916 = _502;
	    _1916.x = _1914.x;
	    _1916.y = _1914.y;
	    _1916.z = _1914.z;
	    _502 = _1916;
	    vec4 _450;
	    vec4 _1923 = _450;
	    _1923.x = _1916.x;
	    _1923.y = _1916.y;
	    _1923.z = _1916.z;
	    _1923.w = _1916.w;
	    _450 = _1923;
	    mat3x4 _1934 = transpose(gl_WorldToObjectEXT);
	    mat3 _498;
	    mat3 _1937 = _498;
	    _1937[0] = _1934[0].xyz;
	    _1937[1] = _1934[1].xyz;
	    _1937[2] = _1934[2].xyz;
	    _498 = _1937;
	    vec3 _1946 = normalize(_1937 * _503.xyz);
	    vec3 _451;
	    vec3 _1948 = _451;
	    _1948.x = _1946.x;
	    _1948.y = _1946.y;
	    _1948.z = _1946.z;
	    _451 = _1948;
	    vec3 _1956 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _1960 = transpose(gl_WorldToObjectEXT);
	    mat3 _497;
	    mat3 _1963 = _497;
	    _1963[0] = _1960[0].xyz;
	    _1963[1] = _1960[1].xyz;
	    _1963[2] = _1960[2].xyz;
	    _497 = _1963;
	    vec3 _1972 = normalize(_1963 * _504.xyz);
	    vec4 _449;
	    vec4 _1974 = _449;
	    _1974.x = _1972.x;
	    _1974.y = _1972.y;
	    _1974.z = _1972.z;
	    _1974.w = _504.w;
	    _449 = _1974;
	    vec4 _1983 = _439.xyxy;
	    _1983.z = _439.x;
	    _1983.w = _439.y;
	    vec3 _1991 = mix(vec3(1.0), _1923.xyz, vec3(_477));
	    vec4 _1993 = _1923;
	    _1993.x = _1991.x;
	    _1993.y = _1991.y;
	    _1993.z = _1991.z;
	    vec3 _2001 = _1993.xyz * _479.xyz;
	    vec4 _2003 = _1993;
	    _2003.x = _2001.x;
	    _2003.y = _2001.y;
	    _2003.z = _2001.z;
	    _2003.w = _2003.w * _478;
	    vec3 _421 = _1956;
	    vec3 _420 = _1948;
	    vec3 _2032 = ((_430 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_425 * attrs.barycentrics.x)) + (_1948 * attrs.barycentrics.y);
	    vec3 _438 = _2032;
	    vec4 _437 = ((_429 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_424 * attrs.barycentrics.x)) + (_1983 * attrs.barycentrics.y);
	    vec4 _436 = ((_428 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_423 * attrs.barycentrics.x)) + (_2003 * attrs.barycentrics.y);
	    vec4 _435 = ((_427 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_422 * attrs.barycentrics.x)) + (_1974 * attrs.barycentrics.y);
	    bool _434 = gl_HitKindEXT == 254u;
	    vec3 _468 = vec3(0.5);
	    vec2 _467 = vec2(0.5);
	    vec3 _466 = vec3(0.0);
	    float _465 = 0.039999999105930328369140625;
	    vec3 _464 = vec3(0.0);
	    bool _461 = false;
	    vec3 _463 = _2032.xyz;
	    vec3 _462 = normalize(cross(_426 - _431, _1956 - _431));
	    bool _495;
	    if (_470)
	    {
	        _495 = !_471;
	    }
	    else
	    {
	        _495 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_495)
	    {
	        float _496;
	        if (_434)
	        {
	            _496 = 1.0;
	        }
	        else
	        {
	            _496 = -1.0;
	        }
	        _463 *= _496;
	        if (_434)
	        {
	            _496 = 1.0;
	        }
	        else
	        {
	            _496 = -1.0;
	        }
	        _462 *= _496;
	        _461 = !_434;
	    }
	    vec3 _2090 = _463;
	    vec3 _2091 = normalize(_2090);
	    _463 = _2091;
	    vec2 _2097 = _467;
	    vec3 _2098 = _468;
	    vec3 _457 = _466;
	    float _456 = _465;
	    vec3 _455 = _464;
	    vec3 _454 = _2091;
	    vec3 _453 = _462;
	    bool _452 = _461;
	    vec4 _2105 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_475], g_bindless_Sampler[_476])), _437.xy, 0.0).xyzw;
	    vec4 _2110 = _2105;
	    _2110.w = _2105.w * _436.w;
	    vec3 _2114 = _2105.xyz * _473.xyz;
	    vec4 _2116;
	    _2116.x = _2114.x;
	    _2116.y = _2114.y;
	    _2116.z = _2114.z;
	    _2098.x = _2116.x;
	    _2098.y = _2116.y;
	    _2098.z = _2116.z;
	    vec3 _2129 = _2098.xyz * _436.xyz;
	    vec3 _2131 = _2098;
	    _2131.x = _2129.x;
	    _2131.y = _2129.y;
	    _2131.z = _2129.z;
	    vec3 _460 = _2131;
	    float _458 = _469;
	    vec4 _2140 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_474], g_bindless_Sampler[_476])), _437.zw, 0.0);
	    float _2141 = _2140.x;
	    float _2142 = _2140.y;
	    float _2144 = (_2141 + _2142) - 1.00392162799835205078125;
	    float _2145 = _2141 - _2142;
	    _2097.x = _2140.z;
	    _2097.y = _2140.z;
	    vec2 _459 = _2097;
	    if (_472)
	    {
	        vec2 _2160 = _459;
	        vec2 _2165 = _2160.xy + (smoothstep(vec2(0.89999997615814208984375), vec2(1.0), _2160.xy) * 2.0);
	        vec2 _2167 = _2160;
	        _2167.x = _2165.x;
	        _2167.y = _2165.y;
	        _459 = _2167;
	    }
	    vec3 _493 = normalize(vec3(vec2(_2144, _2145), (1.0 - abs(_2144)) - abs(_2145)));
	    bool _491;
	    if (_470)
	    {
	        _491 = !_471;
	    }
	    else
	    {
	        _491 = false;
	    }
	    if (_491)
	    {
	        float _492;
	        if (_434)
	        {
	            _492 = 1.0;
	        }
	        else
	        {
	            _492 = -1.0;
	        }
	        _491 = _492 < 0.0;
	    }
	    else
	    {
	        _491 = false;
	    }
	    float _494;
	    if (_491)
	    {
	        _494 = -1.0;
	    }
	    else
	    {
	        _494 = 1.0;
	    }
	    float _2192 = _494;
	    vec3 _2193 = _438.xyz * _2192;
	    if (_435.w > 0.0)
	    {
	        _494 = 1.0;
	    }
	    else
	    {
	        _494 = -1.0;
	    }
	    bool _489;
	    if (_470)
	    {
	        _489 = !_471;
	    }
	    else
	    {
	        _489 = false;
	    }
	    if (_489)
	    {
	        float _490;
	        if (_434)
	        {
	            _490 = 1.0;
	        }
	        else
	        {
	            _490 = -1.0;
	        }
	        _489 = _490 < 0.0;
	    }
	    else
	    {
	        _489 = false;
	    }
	    if (!_489)
	    {
	        vec3 _2225 = _493;
	        _2225.y = -_2225.y;
	        _493 = _2225;
	    }
	    vec3 _2232 = _435.xyz * _493.x;
	    vec3 _488;
	    vec3 _2234 = _488;
	    _2234.x = _2232.x;
	    _2234.y = _2232.y;
	    _2234.z = _2232.z;
	    vec3 _2244 = _2234.xyz + ((cross(_2193.xyz, _435.xyz) * _494).xyz * _493.y);
	    vec3 _2246 = _2234;
	    _2246.x = _2244.x;
	    _2246.y = _2244.y;
	    _2246.z = _2244.z;
	    vec3 _2255 = _2246.xyz + (_2193.xyz * _493.z);
	    vec3 _2257 = _2246;
	    _2257.x = _2255.x;
	    _2257.y = _2255.y;
	    _2257.z = _2255.z;
	    _488 = _2257;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _453;
	    payload.vInterpolatedNormalWs = _454;
	    vec3 _486[3] = vec3[](_431, _426, _421);
	    vec3 _487[3] = vec3[](_430, _425, _420);
	    vec3 _2304 = ((_486[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_486[1] * attrs.barycentrics.x)) + (_486[2] * attrs.barycentrics.y);
	    vec3 _480[3];
	    _480[0] = _2304 - (_487[0] * dot(_2304 - _486[0], _487[0]));
	    _480[1] = _2304 - (_487[1] * dot(_2304 - _486[1], _487[1]));
	    _480[2] = _2304 - (_487[2] * dot(_2304 - _486[2], _487[2]));
	    vec3 _2344 = ((_480[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_480[1] * attrs.barycentrics.x)) + (_480[2] * attrs.barycentrics.y);
	    vec3 _481[3];
	    _481[0] = cross(_486[0] - _486[1], _453);
	    _481[1] = cross(_486[1] - _486[2], _453);
	    _481[2] = cross(_486[2] - _486[0], _453);
	    float _482 = dot(_2344 - _2304, _453);
	    vec3 _483 = _2344;
	    int _484 = 0;
	    for (;;)
	    {
	        bool _2360_ladder_break = false;
	        do
	        {
	            if (!(_484 < 3))
	            {
	                _2360_ladder_break = true;
	                break;
	            }
	            if (_482 > 0.00999999977648258209228515625)
	            {
	                _2360_ladder_break = true;
	                break;
	            }
	            if (dot(_481[_484], _481[_484]) == 0.0)
	            {
	                break;
	            }
	            _481[_484] = normalize(_481[_484]);
	            int _485 = 0;
	            for (;;)
	            {
	                if (!(_485 < 3))
	                {
	                    break;
	                }
	                vec3 _2398 = _487[_485] - (_481[_484] * dot(_481[_484], _487[_485]));
	                _480[_485] = _2304 - (_2398 * dot(_2304 - _486[_485], _2398));
	                _485++;
	                continue;
	            }
	            vec3 _2422 = ((_480[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_480[1] * attrs.barycentrics.x)) + (_480[2] * attrs.barycentrics.y);
	            _482 = dot(_2422 - _2304, _453);
	            _483 = _2422;
	            break;
	        } while(false);
	        if (_2360_ladder_break)
	        {
	            break;
	        }
	        _484++;
	        continue;
	    }
	    if (!(_482 > 0.00999999977648258209228515625))
	    {
	        _483 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _483;
	    payload.bFlippedNormal = _452;
	    f16vec3 _2435 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_2435, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2435, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(normalize(_2257.xyz));
	    payload.material.vAlbedo = f16vec3(_460);
	    payload.material.vEmissive = f16vec3(_457);
	    payload.material.flReflectance = float16_t(_456);
	    payload.material.flMetalness = float16_t(_458);
	    payload.material.flRoughness = float16_t(dot(_459, vec2(0.5)));
	    if (any(greaterThan(_455, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _2461 = f16vec3(_455);
	        payload.material.vMaterialBits.x = _2461.x;
	        payload.material.vMaterialBits.y = _2461.y;
	        payload.material.vMaterialBits.z = _2461.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	BoolAttribute(VertexPaintUI2Layer, true);
	BoolAttribute(VertexPaintUIPickColor, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	TextureAttribute(LightSim_DiffuseAlbedoTexture1, g_tColor);
	TextureAttribute(RepresentativeTexture1, g_tColor);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(overlay, F_OVERLAY ? 1 : 0);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	#if (S_SHADER_QUALITY == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_DETAILBLENDMODE == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ALPHA_TEST == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_OVERLAY == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_LAYERS == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_LAYERS == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_DETAILBLENDMODE == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_DETAILTEXTURE == 2)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_TRANSLUCENT == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
}
