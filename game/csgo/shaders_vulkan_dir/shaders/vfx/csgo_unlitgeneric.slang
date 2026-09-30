//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "(S1) unlit/unlittwotexture shader for CSGO.";
	DevShader = false;
	Version = 2;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	Depth(S_MODE_DEPTH);
	Default();
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_GRADIENTMODULATION, 0..1, "Gradient Modulation" );
	Feature( F_TWOTEXTURE, 0..1, "TwoTexture" );
	Feature( F_BLEND_MODE, 0..6 (0="Opaque", 1="Translucent", 2="Alpha Test", 3="Mod2x", 4="Additive", 5="Multiply", 6="ModThenAdd"), "Blend Mode" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_TEXTURE_ANIMATION, 0..1, "Animation" );
	Feature( F_TEXTURE_ANIMATION_MODE, 0..2 (0="Sequential", 1="Random", 2="Scripted"), "Animation" );
	Feature( F_VERTEX_COLOR, 0..1, "" );
	FeatureRule( Requires( F_TRANSLUCENT, F_BLEND_MODE==2 ), "Translucent requires Alpha Test On, otherwise pick a translucent Blend Mode." );
	FeatureRule( Requires( F_TEXTURE_ANIMATION_MODE, F_TEXTURE_ANIMATION==1 ), "Texture Animation Mode requires Texture Animation On" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                           // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	float4 vColor        : COLOR0         < Semantic( Color ); >;                                  // S_VERTEX_COLOR=1
	uint4  nPackedFrame  : NORMAL0        < Semantic( CompressedTangentFrame ); >;                
	float4 vNormalOs     : NORMAL0        < Semantic( Normal ); >;                                
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                 // D_CS_VERTEX_ANIMATION=0, D_SCREEN_SPACE=1
	float2 vLightmapUV   : TEXCOORD3      < Semantic( LightmapUV ); >;                             // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float2 vTexCoord     : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                        
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	StaticCombo( S_TEXTURE_ANIMATION, F_TEXTURE_ANIMATION );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_VERTEX_COLOR, F_VERTEX_COLOR );
	StaticCombo( S_TWOTEXTURE, F_TWOTEXTURE );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SCREEN_SPACE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression(g_nScaleTexCoordUByModelScaleAxis!=0 || g_nScaleTexCoordVByModelScaleAxis!=0); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nTextureAnimationMode < UiType(Slider); Expression(F_TEXTURE_ANIMATION_MODE); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float2 g_vAnimationInvGrid < UiType(VectorText); Expression(1/g_vAnimationGrid); >;
	float4 g_vTex2CoordXform0 < UiType(VectorText); Expression(v0 = g_flTex2CoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTex2CoordScale.x,-v2*g_vTex2CoordScale.y,0,g_vTex2CoordCenter.x+g_vTex2CoordOffset.x+v2*g_vTex2CoordScale.y*g_vTex2CoordCenter.y-v1*g_vTex2CoordScale.x*g_vTex2CoordCenter.x)); >;
	float4 g_vTex2CoordXform1 < UiType(VectorText); Expression(v0 = g_flTex2CoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTex2CoordScale.x,v1*g_vTex2CoordScale.y,0,g_vTex2CoordCenter.y+g_vTex2CoordOffset.y+v2*g_vTex2CoordScale.x*g_vTex2CoordCenter.x-v1*g_vTex2CoordScale.y*g_vTex2CoordCenter.y)); >;
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
	
	// Texture Animation
	int2 g_vAnimationGrid < Default2(1, 1); Range2(1, 1, 64, 64); UiType(VectorText); UiGroup("Texture Animation,12/10"); >;
	int g_nNumAnimationCells < Default(1); Range(1, 4096); UiType(Slider); UiGroup("Texture Animation,12/20"); >;
	float g_flAnimationTimePerFrame < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Texture Animation,12/30"); >;
	float g_flAnimationTimeOffset < Range(0, 1000); UiType(Slider); UiGroup("Texture Animation,12/40"); >;
	float g_flAnimationFrame < Range(0, 4096); UiType(Slider); UiGroup("Texture Animation,12/50"); >;
	
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
	
	// PBR 1
	float2 g_vTex2CoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 30"); >;
	float2 g_vTex2CoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 40"); >;
	float g_flTex2CoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Albedo,10 / 50"); >;
	float2 g_vTex2CoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 60"); >;
	
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
	
	struct _1234
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1234 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
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
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9360 = vTexCoord.xyxy;
	    _9360.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _9360.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _9360;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _7654 * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11399;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    output_2 = _20488;
	    output_3 = _23714;
	    output_4 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_BLEND_MODE==0);
	
}

PS
{
	StaticCombo( S_BLEND_MODE, F_BLEND_MODE );
	StaticCombo( S_GRADIENTMODULATION, F_GRADIENTMODULATION );
	StaticCombo( S_TWOTEXTURE, F_TWOTEXTURE );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Requires( D_OPAQUE_FADE, S_BLEND_MODE==0 ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_BLEND_MODE==1, S_BLEND_MODE==4 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_BLEND_MODE==1, S_BLEND_MODE==4 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_BAKED_LIGHTING_FROM_VERTEX_STREAM ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_BAKED_LIGHTING_FROM_PROBE ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefined(Texture2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefinedOrAlphaWeighted(Texture2Color, Texture2Translucency), Srgb); Channel(A, Box(Texture2Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	
	// PBR 2
	CreateInputTexture2D(Texture2Color, Srgb, 8, "", "_color", "PBR 2,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(Texture2Translucency, Linear, 8, "", "_trans", "PBR 2,10 / Albedo Translucency,15 / 10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vGradientColorStop0 < Default3(1, 1, 1); UiType(Color); UiGroup("Color,20/30"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vGradientColorStop1 < Default3(1, 1, 1); UiType(Color); UiGroup("Color,20/40"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vGradientColorStop2 < Default3(1, 1, 1); UiType(Color); UiGroup("Color,20/50"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vGradientModulation_StopPositions < Default3(1, 1, 1); UiType(Color); UiGroup("Color,20/60"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_BLEND_MODE == 2)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefined(Texture2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefinedOrAlphaWeighted(Texture2Color, Texture2Translucency), Srgb); Channel(A, Box(Texture2Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    int _Globals_1_g_bFogEnabled : packoffset(c0.z);
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
	    float4 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c35);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float3 PerViewConstantBuffer_t_1_m0 : packoffset(c26);
	};
	
	Texture2D<float4> g_tColor : register(t51, space1);
	SamplerState g_sUserConfigAllowGlobalMipBias : register(s20, space1);
	TextureCube<float4> g_tFogCubeTexture : register(t42, space1);
	SamplerState g_sTrilinearClamp : register(s17, space1);
	
	static float4 input_2;
	static float4 input_3;
	static float3 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _23820 = g_tColor.Sample(g_sUserConfigAllowGlobalMipBias, input_2.xy);
	    float4 _15654 = _23820 * input_3;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _5578 = input_0 + PerViewConstantBufferCsgo_t_1_m9.xyz;
	        float3 _3895 = _5578.xyz - PerViewConstantBuffer_t_1_m0.xyz;
	        float3 _9057 = _3895.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _3895.xyz;
	            bool _12885;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m3.x)
	            {
	                _12885 = (_5578.z * PerViewConstantBufferCsgo_t_1_m3.z) < PerViewConstantBufferCsgo_t_1_m3.y;
	            }
	            else
	            {
	                _12885 = false;
	            }
	            [branch]
	            if (_12885)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m0.xy + (PerViewConstantBufferCsgo_t_1_m0.zw * float2(length(_21493), _5578.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m1.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m1.y)) * PerViewConstantBufferCsgo_t_1_m2.w;
	                _19340 = lerp(_15654.xyz, float4(PerViewConstantBufferCsgo_t_1_m2.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _15654.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _15654;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12886;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m7.x)
	            {
	                _12886 = (PerViewConstantBufferCsgo_t_1_m7.z * _5578.z) < PerViewConstantBufferCsgo_t_1_m7.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            if (_12886)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m4.y) + PerViewConstantBufferCsgo_t_1_m4.x), PerViewConstantBufferCsgo_t_1_m4.w)) * saturate(pow(max(0.0f, (_5578.z * PerViewConstantBufferCsgo_t_1_m5.y) + PerViewConstantBufferCsgo_t_1_m5.x), PerViewConstantBufferCsgo_t_1_m5.z));
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
	        _6805 = _15654;
	    }
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(unlit, true);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	BoolAttribute(SupportsLightmapping, false);
	
	#if (S_BLEND_MODE == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
		BoolAttribute(DoNotCastShadows, false);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
		BoolAttribute(DoNotCastShadows, true);
	#endif
	#if (S_BLEND_MODE == 2)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(DoNotCastShadows, false);
	#endif
	#if (S_MODE_DEPTH == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
		BoolAttribute(DoNotCastShadows, true);
		IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
	#endif
	
	// PSRS
	
	RenderState(AlphaToCoverageEnable, true);
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(BlendEnable, F_TRANSLUCENT ? true : false);
	RenderState(BlendEnable0, true);
	RenderState(BlendEnable1, true);
	RenderState(BlendEnable2, true);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthWriteEnable, false);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
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
	
	#if (S_BLEND_MODE == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_BLEND_MODE == 2)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	#endif
	
	// Variant parameters
	RenderState(DepthWriteEnable, false);
}
