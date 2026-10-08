//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Standard shader with internal liquid effects";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	CsgoForward();
	Depth("csgo_depth_only.vfx");
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
	Feature( F_FOAM, 0..1, "Creates Foam" );
	Feature( F_NO_LIQUID, 0..1, "Empty Bottle" );
	Feature( F_USE_TEST_VALUES, 0..1, "Force use the static test values" );
	Feature( F_OPAQUE_REFRACT, 0..1, "Draw opaque using background copy as refract" );
	Feature( F_IRIDESCENCE, 0..1, "Iridescent effects" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_NO_LIQUID, F_FOAM ), "No Liquid means no foam" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_NO_LIQUID=0, S_MODE_TOOLS_VIS=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	float4 vBlendWeight               : BLENDWEIGHT0   < Semantic( BlendWeight ); >;              
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0, S_NO_LIQUID=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_NO_LIQUID, F_NO_LIQUID );
	StaticCombo( S_USE_TEST_VALUES, F_USE_TEST_VALUES );
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
	
	// Liquid
	float3 g_flLiquidCenterOffset < Range3(-10, -10, -10, 10, 10, 10); UiType(VectorText); UiGroup("Liquid, 100/33"); >;
	
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
	
	// Test Values
	float3 g_vTestGravityDir < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Test Values, 100/32"); >;
	
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
	
	struct _1565
	{
	    mat4 _m0;
	    mat4 _m1;
	    float _m2;
	    vec4 _m3;
	};
	
	layout(set = 0) uniform _1565 PerViewConstantBuffer_t;
	
	struct _1346
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    vec3 g_flLiquidCenterOffset;
	};
	
	layout(set = 0) uniform _1346 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 4) in uvec4 vBlendIndices;
	layout(location = 6) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out float output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec3 output_4;
	layout(location = 5) out vec3 output_5;
	layout(location = 6) out vec4 output_6;
	layout(location = 7) out vec4 output_7;
	layout(location = 8) out vec3 output_8;
	layout(location = 9) out vec3 output_9;
	layout(location = 10) out vec4 output_10;
	layout(location = 11) centroid out vec4 output_11;
	layout(location = 12) centroid out vec3 output_12;
	layout(location = 13) out vec4 output_13;
	layout(location = 14) flat out uint output_14;
	
	void main()
	{
	    uint _13771 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5 >> uint(16)) & 15u;
	    bool _21645 = _13771 == 1u;
	    uint _21785;
	    if (_21645)
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
	    float _16337 = _7654 * g_instanceBuffer_1._m0[nInstanceIdx]._m7;
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _16665 = vec4(_12151.xyz, 1.0);
	    vec4 _18237 = (_16665 + (PerViewConstantBuffer_t._m3 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9360 = vTexCoord.xyxy;
	    _9360.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _9360.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m2);
	    vec4 _20488 = _9360;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _16337);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    float _12758 = _13062.x;
	    vec4 _23714 = _11399;
	    _23714.x = _12758;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    uint _21786;
	    if (_21645)
	    {
	        _21786 = g_instanceBuffer_1._m0[nInstanceIdx]._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21786 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    }
	    vec3 _8077 = vec4(_Globals_.g_flLiquidCenterOffset, 1.0) * g_transformBuffer_1._m0[_21786]._m0;
	    uint _3245 = uint(_16337 * 255.0);
	    uint _5220 = _3245 & 15u;
	    uint _5221 = (_3245 >> uint(4)) & 15u;
	    float _6905;
	    if (_5220 != 0u)
	    {
	        _6905 = float(_5220 + 1u) * 0.0625;
	    }
	    else
	    {
	        _6905 = 0.0;
	    }
	    float _20653;
	    if (_5221 != 0u)
	    {
	        _20653 = float(_5221 + 1u) * 0.0625;
	    }
	    else
	    {
	        _20653 = 0.0;
	    }
	    vec2 _5686 = (vec2(_6905, _20653) * 2.0) - vec2(1.0);
	    float _6218 = _5686.x * 3.1415927410125732421875;
	    vec2 _7776 = floor(vec2(sin(_6218), cos(_6218)) * 10000.0) * vec2(9.9999997473787516355514526367188e-05);
	    float _21280 = _5686.y;
	    float _19942 = sqrt(1.0 - (_21280 * _21280));
	    vec3 _23064 = vec3(_21280, _7776.x * _19942, _7776.y * _19942);
	    output_0 = vPositionOs - _Globals_.g_flLiquidCenterOffset;
	    output_1 = _8077;
	    output_2 = fract((PerViewConstantBuffer_t._m2 + _12758) * 0.004999999888241291046142578125) * 200.0;
	    output_3 = vec4(0.0, 0.0, 1.0, 0.0) * g_transformBuffer_1._m0[_21786]._m0;
	    output_4 = _23064;
	    output_5 = (vec4(_23064.xyz, 0.0).xyzw * PerViewConstantBuffer_t._m1).xyz;
	    output_6 = _16665.xyzw * PerViewConstantBuffer_t._m1;
	    output_7 = vec4(_8077.xyz, 1.0).xyzw * PerViewConstantBuffer_t._m1;
	    output_8 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_9 = _11179;
	    output_10 = _20488;
	    output_11 = _23714;
	    output_12 = _11179;
	    output_13 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_14 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(bSimpleLiquidMaterial, true);
	
}

PS
{
	StaticCombo( S_FOAM, F_FOAM );
	StaticCombo( S_NO_LIQUID, F_NO_LIQUID );
	StaticCombo( S_OPAQUE_REFRACT, F_OPAQUE_REFRACT );
	StaticCombo( S_IRIDESCENCE, F_IRIDESCENCE );
	StaticCombo( S_USE_TEST_VALUES, F_USE_TEST_VALUES );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Allow1( S_NO_LIQUID, S_FOAM ) );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_USE_BGREFRACT, 0..1 );
	DynamicCombo( D_USE_DEPTH, 0..1 );
	DynamicCombo( D_MSAA_DEPTH, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Requires( D_USE_BGREFRACT, S_OPAQUE_REFRACT ) );
	DynamicComboRule( Requires( D_MSAA_DEPTH, D_USE_BGREFRACT ) );
	DynamicComboRule( Requires( D_MSAA_DEPTH, D_USE_DEPTH ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_flRainExposureLocalTimer < Attribute("RainExposureLocalTimer"); UiType(Slider); >;
	float g_flRainExposureToSkyWetness < Attribute("RainExposureToSkyWetness"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tBGRefract < Attribute("BGRefract"); SrgbRead(true); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tColorA < Channel(RGB, Box(TextureColorA), Srgb); Channel(A, Box(TextureMetalnessA), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDroplets < Attribute("WetnessDroplets"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2D g_tLiquidMask < Channel(R, Box(TextureLiquidMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLiquidMask < Channel(R, Box(TextureLiquidMask), Linear); Channel(G, Box(TextureIridescentThickness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalA < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormalA, TextureRoughnessA), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	float4 g_vInvTextureDim < Source(InvTextureDim); SourceArg(g_tBGRefract) UiType(VectorText); >;
	
	// Simple Material
	CreateInputTexture2D(TextureColorA, Srgb, 8, "", "_color", "Simple Material,10/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormalA, Linear, 8, "NormalizeNormals", "_normal", "Simple Material,10/20", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureRoughnessA, Linear, 8, "Inverse", "_rough", "Simple Material,10/30", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureMetalnessA, Linear, 8, "", "_metal", "Simple Material,10/40", Default4(0, 0, 0, 0));
	
	// Iridescence
	CreateInputTexture2D(TextureIridescentThickness, Linear, 8, "", "_mask", "Iridescence,200/0", Default4(0.5, 0.5, 0.5, 0));
	float g_flIridescentScale < Default(1.5); Range(-8, 8); UiType(Slider); UiGroup("Iridescence,200/10"); >;
	float g_flIridescentThickness < Default(1); Range(0, 8); UiType(Slider); UiGroup("Iridescence,200/20"); >;
	float g_flIridescentReflectionBoost < Default(4); Range(0, 100); UiType(Slider); UiGroup("Iridescence,200/30"); >;
	float g_flIridescentStrength < Default(0.5); Range(0, 2); UiType(Slider); UiGroup("Iridescence,200/40"); >;
	
	// Liquid
	CreateInputTexture2D(TextureLiquidMask, Linear, 8, "Inverse", "_mask", "Liquid,100/5", Default4(0.5, 0.5, 0.5, 0));
	float g_flMaskMinimum < UiType(Slider); UiGroup("Liquid, 100/10"); >;
	float g_flMaskMaximum < Default(1); UiType(Slider); UiGroup("Liquid, 100/15"); >;
	float g_flLiquidWobbleSpeed < Default(1); Range(-50, 50); UiType(Slider); UiGroup("Liquid, 100/20"); >;
	float g_flLiquidWobbleScale < Default(0.01); Range(0, 0.1); UiType(Slider); UiGroup("Liquid, 100/21"); Expression(exists(LiquidWobbleScale) ? LiquidWobbleScale : this); >;
	float g_flLiquidWobbleWavelength < Default(1); Range(0, 50); UiType(Slider); UiGroup("Liquid, 100/22"); >;
	float g_flLiquidLevelHeight < UiType(Slider); UiGroup("Liquid, 100/25"); Expression(exists(LiquidLevelHeight) ? LiquidLevelHeight : this); >;
	float g_flLiquidLevelHeightDelta < Default(0.3); UiType(Slider); UiGroup("Liquid, 100/25"); >;
	float3 g_vLiquidLevelUpwardsMinMidMax < Default2(-20, 0); Range3(-100, -100, -100, 100, 100, 100); UiType(VectorText); UiGroup("Liquid, 100/30"); >;
	float3 g_vLiquidLevelDownwardsMinMidMax < Default2(-20, 0); Range3(-100, -100, -100, 100, 100, 100); UiType(VectorText); UiGroup("Liquid, 100/31"); >;
	float3 g_vLiquidLevelSidewardsMinMidMax < Default2(-20, 0); Range3(-100, -100, -100, 100, 100, 100); UiType(VectorText); UiGroup("Liquid, 100/32"); >;
	float g_flLiquidColorHueShift < Range(-180, 180); UiType(Slider); UiGroup("Liquid, 100/41"); Expression(radians(this)); >;
	float3 g_vLiquidColor < Default3(0.6, 0.4, 0.1); UiType(Color); UiGroup("Liquid, 100/41"); Expression(SrgbGammaToLinear(this)); >;
	float g_flLiquidBrightness < Default(1); Range(0, 40); UiType(Slider); UiGroup("Liquid, 100/42"); >;
	float g_flLiquidEmissiveStrength < Range(0, 10); UiType(Slider); UiGroup("Liquid, 100/43"); >;
	float g_flLiquidInnerGlow < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Liquid, 100/43"); >;
	float3 g_vFoamColor < Default3(0.5, 1, 0.2); UiType(Color); UiGroup("Liquid, 100/46"); Expression(SrgbGammaToLinear(this)); >;
	float g_flFoamLevelAdjust < Range(-50, 50); UiType(Slider); UiGroup("Liquid, 100/47"); >;
	float g_flSurfaceTension < Default(0.5); Range(-100, 100); UiType(Slider); UiGroup("Liquid, 100/48"); >;
	float g_flLiquidSharpness < Default(30); Range(0.5, 100); UiType(Slider); UiGroup("Liquid, 100/50"); >;
	float g_flBrightenEmptyArea < Default(3); Range(0, 20); UiType(Slider); UiGroup("Liquid, 100/55"); >;
	float g_flLiquidBackOffset < Default(6); Range(0, 100); UiType(Slider); UiGroup("Liquid, 100/60"); >;
	float g_flLiquidBackFade < Range(0, 8); UiType(Slider); UiGroup("Liquid, 100/61"); >;
	float g_flLiquidBackCylinderOrSphere < UiType(Slider); UiGroup("Liquid, 100/65"); >;
	float g_flFresnelGlassThickness < Default(0.4); UiType(Slider); UiGroup("Liquid, 100/70"); >;
	float g_flLiquidRoughness < Default(0.3); UiType(Slider); UiGroup("Liquid, 100/70"); >;
	float g_flLiquidSpecularStrength < Default(1); Range(0, 50); UiType(Slider); UiGroup("Liquid, 100/70"); >;
	float g_flLiquidSurfaceSpecularStrength < Default(1); Range(0, 50); UiType(Slider); UiGroup("Liquid, 100/70"); >;
	float g_flTransmissiveStrength < Default(1); Range(0, 50); UiType(Slider); UiGroup("Liquid, 100/70"); >;
	float g_flWaterLineStrength < Default(0.5); Range(0, 10); UiType(Slider); UiGroup("Liquid, 100/70"); >;
	
	// Refraction
	float g_flCubeRefractBrightness < Default(1); Range(0, 10); UiType(Slider); UiGroup("Refraction, 100/70"); >;
	float g_flCubeRefractLiquidTransparency < Default(0.5); Range(0, 2); UiType(Slider); UiGroup("Refraction, 100/70"); >;
	float g_flCubeRefractTransparency < Default(0.5); Range(0, 2); UiType(Slider); UiGroup("Refraction, 100/70"); >;
	float g_flRefractRoughnessMultiplier < Default(1); Range(0.1, 4); UiType(Slider); UiGroup("Refraction, 100/70"); >;
	float g_flGlassRefraction < Default(1.03); UiType(Slider); UiGroup("Refraction, 100/80"); >;
	float g_flLiquidRefraction < Default(0.75); UiType(Slider); UiGroup("Refraction, 100/90"); >;
	float g_flLiquidSurfaceRefraction < Default(0.8); UiType(Slider); UiGroup("Refraction, 100/100"); >;
	float g_flBackgroundRefractionBlendStrength < Default(1); UiType(Slider); UiGroup("Refraction, 100/110"); >;
	
	// Bubbles
	float g_flBubbleDepthFalloff < Default(1.5); Range(0.01, 10); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float g_flBubbleOpacity < Range(0, 10); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float g_flBubbleScale < Default(0.6); Range(0.1, 2); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float g_flBubbleSpaceScale < Default(0.75); Range(0.1, 10); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float g_flBubbleSpeed < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float g_flBubbleStrength < Default(5); Range(0.1, 20); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float g_flBubblesMaximum < Default(0.65); Range(0, 20); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float g_flBubblesMinimum < Default(0.15); Range(0, 20); UiType(Slider); UiGroup("Bubbles, 100/70"); >;
	float3 g_vBubbleColorInner < UiType(Color); UiGroup("Bubbles, 100/70"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vBubbleColorOuter < Default3(1, 1, 1); UiType(Color); UiGroup("Bubbles, 100/70"); Expression(SrgbGammaToLinear(this)); >;
	
	// Test Values
	float g_flTestAgitation < Default(0.3); UiType(Slider); UiGroup("Test Values, 100/70"); >;
	float g_flTestFoaming < UiType(Slider); UiGroup("Test Values, 100/70"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_IRIDESCENCE == 1)
		Texture2D g_tLiquidMask < Channel(R, Box(TextureLiquidMask), Linear); Channel(G, Box(TextureIridescentThickness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	
	// Variant parameters
	Texture2D g_tLiquidMask < Channel(R, Box(TextureLiquidMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 11 (name: g_vLiquidLevelDownwardsMinMidMax) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_KHR_shader_subgroup_arithmetic : require
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
	
	struct _194
	{
	    vec4 _m0[3];
	};
	
	struct _404
	{
	    vec4 _m0[4];
	};
	
	struct _1677
	{
	    mat4x3 _m0;
	    vec3 _m1;
	    uint _m2;
	    vec3 _m3;
	    vec4 _m4;
	    vec3 _m5;
	    vec4 _m6;
	};
	
	struct _890
	{
	    _1677 _m0[128];
	};
	
	struct _1341
	{
	    mat4x3 _m0;
	    vec3 _m1;
	    vec3 _m2;
	    vec3 _m3;
	    uint _m4;
	};
	
	struct _2157
	{
	    _1341 _m0[128];
	};
	
	struct _1463
	{
	    mat4 _m0[4];
	};
	
	struct _1556
	{
	    mat4x3 _m0;
	    vec3 _m1;
	    vec3 _m2;
	    vec4 _m3;
	    vec3 _m4;
	    vec3 _m5;
	};
	
	struct _1909
	{
	    _1556 _m0[400];
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
	
	vec4 _3;
	vec3 _4;
	
	struct _2445
	{
	    float g_flReflectance;
	    float g_flRainExposureToSkyWetness;
	    float g_flRainExposureLocalTimer;
	    float g_flMaskMinimum;
	    float g_flMaskMaximum;
	    float g_flLiquidWobbleSpeed;
	    float g_flLiquidWobbleScale;
	    float g_flLiquidWobbleWavelength;
	    float g_flLiquidLevelHeight;
	    float g_flLiquidLevelHeightDelta;
	    vec3 g_vLiquidLevelUpwardsMinMidMax;
	    vec3 g_vLiquidLevelDownwardsMinMidMax;
	    vec3 g_vLiquidLevelSidewardsMinMidMax;
	    vec3 g_vLiquidColor;
	    float g_flLiquidColorHueShift;
	    float g_flLiquidBrightness;
	    float g_flLiquidInnerGlow;
	    float g_flLiquidEmissiveStrength;
	    float g_flSurfaceTension;
	    float g_flLiquidSharpness;
	    float g_flBrightenEmptyArea;
	    float g_flLiquidBackOffset;
	    float g_flLiquidBackCylinderOrSphere;
	    float g_flLiquidBackFade;
	    float g_flWaterLineStrength;
	    float g_flFresnelGlassThickness;
	    float g_flTransmissiveStrength;
	    float g_flLiquidSpecularStrength;
	    float g_flLiquidSurfaceSpecularStrength;
	    float g_flLiquidRoughness;
	    float g_flCubeRefractTransparency;
	    float g_flCubeRefractLiquidTransparency;
	    float g_flCubeRefractBrightness;
	    float g_flRefractRoughnessMultiplier;
	    float g_flGlassRefraction;
	    float g_flLiquidRefraction;
	    float g_flLiquidSurfaceRefraction;
	    float g_flBubbleScale;
	    float g_flBubbleSpaceScale;
	    float g_flBubblesMinimum;
	    float g_flBubblesMaximum;
	    float g_flBubbleDepthFalloff;
	    float g_flBubbleStrength;
	    float g_flBubbleSpeed;
	    vec3 g_vBubbleColorInner;
	    vec3 g_vBubbleColorOuter;
	    float g_flBubbleOpacity;
	};
	
	layout(set = 1) uniform _2445 _Globals_;
	
	struct _2416
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    ivec4 _m3;
	    float _m4;
	    float _m5;
	    mat4 _m6;
	    vec2 _m7;
	    float _m8;
	    vec4 _m9;
	};
	
	layout(set = 1) uniform _2416 PerViewConstantBufferCsgo_t;
	
	struct _1290
	{
	    vec2 _m0;
	    vec2 _m1;
	    vec4 _m2;
	    vec3 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1290 PerViewConstantBuffer_t;
	
	struct _438
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    _194 _m5;
	    _404 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    uvec4 _m10;
	    uvec4 _m11;
	    uvec4 _m12;
	    uvec4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	    _890 _m16;
	    _2157 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    int _m20;
	    float _m21;
	    vec4 _m22;
	    float _m23;
	    float _m24;
	    float _m25;
	    float _m26;
	    _1463 _m27;
	    _404 _m28;
	};
	
	layout(set = 3) uniform _438 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	struct _1766
	{
	    _1909 _m0;
	};
	
	layout(set = 1) uniform _1766 PerViewLightProbeVolumeConstantBuffer_t;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 54) uniform texture2D g_tDroplets;
	layout(set = 1, binding = 14) uniform sampler g_sAniso;
	layout(set = 1, binding = 43) uniform texture2D g_tColorA;
	layout(set = 1, binding = 19) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 44) uniform texture2D g_tNormalA;
	layout(set = 1, binding = 55) uniform texture2D g_tLiquidMask;
	layout(set = 1, binding = 45) uniform texture3D g_tLPV_Irradiance;
	layout(set = 1, binding = 15) uniform sampler g_sBilinearClamp;
	layout(set = 1, binding = 40) uniform textureCubeArray g_tEnvironmentMap;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 22) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 18) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 39) uniform texture2D g_tSsao;
	layout(set = 1, binding = 23) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 51) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 35) uniform texture2DArray g_tBRDFLookup;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in float input_2;
	layout(location = 3) in vec3 input_3;
	layout(location = 4) in vec3 input_4;
	layout(location = 5) in vec3 input_5;
	layout(location = 6) in vec4 input_6;
	layout(location = 7) in vec4 input_7;
	layout(location = 8) in vec3 input_8;
	layout(location = 9) in vec3 input_9;
	layout(location = 10) in vec4 input_10;
	layout(location = 11) centroid in vec4 input_11;
	layout(location = 12) centroid in vec3 input_12;
	layout(location = 13) in vec4 input_13;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    float _6560 = 1.0 / _11408.w;
	    vec4 _20606 = _11408;
	    _20606.w = _6560;
	    float _12497 = _Globals_.g_flRainExposureToSkyWetness * PerViewConstantBufferCsgo_t._m5;
	    bool _15436 = _12497 > 0.0;
	    float _13136;
	    vec2 _13960;
	    float _16305;
	    vec4 _24918;
	    if (_15436)
	    {
	        vec3 _10413 = input_8 + PerViewConstantBufferCsgo_t._m9.xyz;
	        vec2 _18197 = input_10.xy * 2.5;
	        vec2 _20826;
	        if ((length(cross(vec3(dFdx(input_10.xy), 0.0), vec3(dFdy(input_10.xy), 0.0))) / max(9.9999997473787516355514526367188e-05, length(cross(dFdx(_10413), dFdy(_10413))))) < 0.00200000009499490261077880859375)
	        {
	            _20826 = _18197 * 3.0;
	        }
	        else
	        {
	            _20826 = _18197;
	        }
	        vec4 _20877 = texture(sampler2D(g_tDroplets, g_sAniso), (_20826 + (_10413.xy * 9.9999997473787516355514526367188e-05)).xy);
	        vec2 _8562 = (_20877.xy * 2.0) - vec2(1.0);
	        _8562.y = -_8562.y;
	        float _7729 = _20877.w;
	        float _10538 = saturate((((_12497 * 0.25) - fract((_20877.z + (input_0.x * 0.00999999977648258209228515625)) + (((_Globals_.g_flRainExposureLocalTimer * 0.100000001490116119384765625) * PerViewConstantBufferCsgo_t._m4) * PerViewConstantBufferCsgo_t._m4))) * 5.0) / (PerViewConstantBufferCsgo_t._m5 + 0.001000000047497451305389404296875)) * saturate((input_9.z + 0.75) * 4.0);
	        vec2 _13861 = input_10.xy + (((_8562.xy * (-0.0199999995529651641845703125)) * _10538) * _7729);
	        vec4 _20488;
	        _20488.x = _13861.x;
	        _20488.y = _13861.y;
	        _13136 = _10538;
	        _16305 = _7729;
	        _13960 = _8562;
	        _24918 = _20488;
	    }
	    else
	    {
	        _13136 = 0.0;
	        _16305 = 0.0;
	        _13960 = vec2(0.0);
	        _24918 = input_10;
	    }
	    vec3 _21709;
	    if (dot(input_9.xyz, input_9.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_12.xyz;
	    }
	    else
	    {
	        _21709 = input_9.xyz;
	    }
	    vec3 _20700 = normalize(_21709);
	    vec3 _20308 = input_8 + PerViewConstantBufferCsgo_t._m9.xyz;
	    vec3 _9982;
	    float _22456;
	    if (_15436)
	    {
	        float _13437 = saturate(_12497);
	        float _13192 = _13136 * _16305;
	        _9982 = mix(normalize(mix(_20700, _20700, vec3(1.0 + (((saturate(_13192 + (_13437 * 0.5)) * 0.25) * _13437) * 1.5)))), normalize((((vec3(1.0, 0.0, 0.0) * _13960.x).xyz + (vec3(0.0, 1.0, 0.0) * _13960.y)).xyz + (_20700.xyz * sqrt(1.0 - saturate(dot(_13960.xy, _13960.xy))))).xyz), vec3(_13136));
	        _22456 = saturate(_13192 * 2.0);
	    }
	    else
	    {
	        _9982 = vec3(1.0);
	        _22456 = 0.0;
	    }
	    vec4 _22452 = texture(sampler2D(g_tColorA, g_sUserConfig), _24918.xy);
	    vec4 _19718 = texture(sampler2D(g_tNormalA, g_sUserConfig), _24918.xy);
	    float _9413 = _19718.x;
	    float _19725 = _19718.y;
	    float _16783 = (_9413 + _19725) - 1.00392162799835205078125;
	    float _11176 = _9413 - _19725;
	    vec3 _23372 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    vec3 _20024 = input_9.xyz * 1.0;
	    vec3 _14435 = cross(_20024.xyz, input_13.xyz) * ((input_13.w > 0.0) ? 1.0 : (-1.0));
	    vec3 _20195;
	    if (notEqual(PerViewConstantBufferCsgo_t._m3, ivec4(0)).w)
	    {
	        _20195 = -_14435;
	    }
	    else
	    {
	        _20195 = _14435;
	    }
	    vec3 _23415 = normalize((((input_13.xyz * _23372.x).xyz + (_20195.xyz * (-_23372.y))).xyz + (_20024.xyz * _23372.z)).xyz);
	    vec3 _24402 = normalize(input_4);
	    vec4 _3300 = texture(sampler2D(g_tLiquidMask, g_sUserConfig), _24918.xy);
	    float _22843 = saturate((_3300.x - _Globals_.g_flMaskMinimum) * (1.0 / (_Globals_.g_flMaskMaximum + 0.001000000047497451305389404296875)));
	    vec3 _10145 = normalize(_20308 - PerViewConstantBuffer_t._m3.xyz);
	    vec3 _21475 = -_10145;
	    float _13948 = saturate(1.0 - dot(_21475, _23415));
	    float _20985 = saturate(2.0 * (_13948 - _Globals_.g_flFresnelGlassThickness));
	    vec3 _14119 = _22452.xyz * mix(vec3(1.0), vec3(0.20000000298023223876953125), vec3(_20985 * _22843));
	    vec4 _23714;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    float _12833 = (3.0 * input_2) * floor(_Globals_.g_flLiquidWobbleSpeed * 200.0);
	    float _5292 = _12833 * 0.004999999888241291046142578125;
	    float _5345 = pow(input_11.z, 2.0) + 0.00999999977648258209228515625;
	    vec3 _10970 = input_0.xyz;
	    vec3 _4669 = input_6.xyz - input_7.xyz;
	    vec3 _24818 = normalize(vec3(input_5.xy, 0.0));
	    float _6473 = dot(_4669, cross(_24818, vec3(0.0, 0.0, 1.0)));
	    float _7602 = dot(_4669, _24818);
	    vec3 _7986;
	    _7986.x = _6473;
	    _7986.y = _7602;
	    vec3 _13427 = -_24402;
	    float _14629 = dot(normalize(input_3), _13427);
	    vec3 _15143 = mix(mix(_Globals_.g_vLiquidLevelDownwardsMinMidMax, _Globals_.g_vLiquidLevelSidewardsMinMidMax, vec3(saturate(_14629 + 1.0))), _Globals_.g_vLiquidLevelUpwardsMinMidMax, vec3(saturate(_14629)));
	    float _8437 = ((1.0 - _Globals_.g_flLiquidLevelHeightDelta) + (_Globals_.g_flLiquidLevelHeightDelta * input_11.x)) * _Globals_.g_flLiquidLevelHeight;
	    float _17433 = mix(mix(_15143.x, _15143.y, saturate(_8437 * 2.0)), _15143.z, saturate((_8437 - 0.5) * 2.0)) + dot(input_1, _13427);
	    float _22288 = length(_23415 * _13427);
	    float _4623 = ((_13948 * mix(0.25, 1.0, _22288)) + (pow(_13948, 5.0) * 0.800000011920928955078125)) * _Globals_.g_flSurfaceTension;
	    float _14290 = mix(0.5, 1.0, abs(_14629));
	    float _4122 = (_Globals_.g_flLiquidWobbleWavelength * _14290) * mix(0.20000000298023223876953125, 0.60000002384185791015625, _5345);
	    float _14276 = _12833 * 0.103999994695186614990234375;
	    float _17945 = 1.0 - _22288;
	    float _14277 = _12833 * (-0.103999994695186614990234375);
	    float _23968 = ((((((((_5345 * exp(sin(dot(vec2(-1.2421100139617919921875, 1.14207398891448974609375) * _4122, _7986.xy) + (_12833 * 0.034000001847743988037109375)) - 1.0)) * 0.125) + (exp(sin(dot(vec2(2.8210999965667724609375, 2.9207398891448974609375) * _4122, _7986.xy) + (_12833 * 0.0439999997615814208984375)) - 1.0) * 0.3333333432674407958984375)) + ((_5345 * exp(sin(dot(vec2(-3.2421100139617919921875, -3.642074108123779296875) * _4122, _7986.xy) + (_12833 * 0.0240000002086162567138671875)) - 1.0)) * 0.111111111938953399658203125)) + ((_5345 * exp(sin(dot(vec2(3.7421100139617919921875, -3.642074108123779296875) * _4122, _7986.xy) + (_12833 * 0.02900000102818012237548828125)) - 1.0)) * 0.111111111938953399658203125)) * exp((sin(dot(vec2(-8.74211025238037109375, 13.64207363128662109375) * _4122, _7986.xy) + _14276) * _17945) * 0.14000000059604644775390625)) * exp((sin(dot(vec2(13.74211025238037109375, 14.64207363128662109375) * _4122, _7986.xy) + _14277) * _17945) * 0.12999999523162841796875)) * exp((sin(dot(vec2(-23.7421092987060546875, -13.64207363128662109375) * _4122, _7986.xy) + _14276) * _17945) * 0.100000001490116119384765625)) * exp((sin(dot(vec2(31.7421092987060546875, -20.6420745849609375) * _4122, _7986.xy) + _14277) * _17945) * 0.07999999821186065673828125);
	    float _3144 = (((((_23968 * _Globals_.g_flLiquidWobbleScale) * pow(_5345, 2.0)) * _14290) * 15.0) * (1.5 - _13948)) - (_5345 * 0.25);
	    float _11687 = dot(_20308, _13427);
	    float _8828 = dot(_10145, _24402);
	    vec2 _8199 = (vec2(_6473, _7602) * _Globals_.g_flBubbleSpaceScale).xy + ((_19718.xy - vec2(0.5)) * 0.25);
	    float _8867 = _8199.x;
	    float _3053 = (1.5 * (_Globals_.g_flBubbleScale * mix(_Globals_.g_flBubblesMinimum, _Globals_.g_flBubblesMaximum, pow(input_11.z, 9.0) + (input_11.y * 0.25)))) / (1.0 + abs((((_17433 + _4623) + _3144) - _11687) * _Globals_.g_flBubbleDepthFalloff));
	    float _23496 = _8199.y + ((0.4000000059604644775390625 * _3144) * _3053);
	    vec2 _8159 = _8199;
	    _8159.y = _23496;
	    float _5823 = (sin(_23496) * 0.25) + (sin(_23496 * 23.1984004974365234375) * 0.0199999995529651641845703125);
	    float _3752 = (sin(_8867 * 1.29400002956390380859375) * 0.25) + (sin(_8867 * 18.1984004974365234375) * 0.039999999105930328369140625);
	    float _23988 = _19718.z;
	    float _5580 = 4.0 * (1.0 - _23988);
	    float _9501 = 1.0 / max(_3053, 0.001000000047497451305389404296875);
	    vec2 _8382 = ((fract((((_8159 + vec2(0.20000000298023223876953125 - _5823, 0.356000006198883056640625 + _3752)) * 0.60000002384185791015625) + (((vec2(0.100000001490116119384765625, 1.0) * _5292) * 0.25) * _Globals_.g_flBubbleSpeed)) * 1.7400000095367431640625) * 2.0) - vec2(1.0)) * _9501;
	    float _22266 = length(_8382);
	    float _14443 = saturate(_5580 * (1.0 - _22266));
	    vec2 _20855 = _8382 * pow(_22266, 2.0);
	    vec2 _15571 = ((fract((((_8159 + vec2((-0.20000000298023223876953125) + _5823, (-0.560000002384185791015625) - _3752)) * 0.550000011920928955078125) + (((vec2(-0.100000001490116119384765625, 1.0) * _5292) * 0.300000011920928955078125) * _Globals_.g_flBubbleSpeed)) * 2.7400000095367431640625) * 2.0) - vec2(1.0)) * _9501;
	    float _21462 = length(_15571);
	    float _14444 = saturate(_5580 * (1.0 - _21462));
	    vec2 _23695 = _15571 * pow(_21462, 2.0);
	    float _11723 = _14443 + _14444;
	    float _15087 = _5823 * 0.5;
	    float _9552 = _3752 * 0.5;
	    vec2 _15572 = ((fract((((_8159 + vec2(0.3499999940395355224609375 - _15087, 0.60000002384185791015625 - _9552)) * 0.5) + (((vec2(0.12999999523162841796875, 1.0) * _5292) * 0.3499999940395355224609375) * _Globals_.g_flBubbleSpeed)) * 4.7399997711181640625) * 2.0) - vec2(1.0)) * _9501;
	    float _21463 = length(_15572);
	    float _14445 = saturate(_5580 * (1.0 - _21463));
	    vec2 _23696 = _15572 * pow(_21463, 2.0);
	    float _11724 = _11723 + _14445;
	    vec2 _15574 = ((fract((((_8159 + vec2((-0.4199999868869781494140625) + _15087, (-0.7599999904632568359375) + _9552)) * 0.449999988079071044921875) + (((vec2(-0.14000000059604644775390625, 1.0) * _5292) * 0.4000000059604644775390625) * _Globals_.g_flBubbleSpeed)) * 5.340000152587890625) * 2.0) - vec2(1.0)) * _9501;
	    float _21464 = length(_15574);
	    float _14446 = saturate(_5580 * (1.0 - _21464));
	    vec2 _23697 = _15574 * pow(_21464, 2.0);
	    vec3 _23013 = vec4(vec4(vec4(mix(_Globals_.g_vBubbleColorInner, _Globals_.g_vBubbleColorOuter, vec3(length(_20855))) * _14443, _14443).xyz + (mix(_Globals_.g_vBubbleColorInner, _Globals_.g_vBubbleColorOuter, vec3(length(_23695))) * _14444), _11723).xyz + (mix(_Globals_.g_vBubbleColorInner, _Globals_.g_vBubbleColorOuter, vec3(length(_23696))) * _14445), _11724).xyz + (mix(_Globals_.g_vBubbleColorInner, _Globals_.g_vBubbleColorOuter, vec3(length(_23697))) * _14446);
	    float _19498 = (_11724 + _14446) * _3053;
	    float _3921 = ((_17433 + _3144) + (_19498 * 0.02500000037252902984619140625)) + (abs(_8828) * (-0.0500000007450580596923828125));
	    float _4095 = (_Globals_.g_flLiquidSharpness * _22843) * mix(1.0, 0.20000000298023223876953125, pow(_23988, 1.5));
	    float _5526 = _11687 - ((_3921 + _4623) + mix(0.0, min(0.300000011920928955078125, saturate(1.0 - abs(_24402.z))) * (_13948 - 0.20000000298023223876953125), 1.5));
	    float _16978 = 1.0 - _13948;
	    float _19871 = pow(_16978, 2.0);
	    float _4472 = ((1.0 - saturate((abs(_5526 - 0.0500000007450580596923828125) * _19871) * _4095)) * _19871) * _Globals_.g_flWaterLineStrength;
	    float _12614 = saturate((_5526 * _4095) * 0.25);
	    float _3697 = 1.0 - _12614;
	    _10970.z = input_0.z * _Globals_.g_flLiquidBackCylinderOrSphere;
	    float _5854 = (((1.5 * _Globals_.g_flLiquidBackOffset) * pow(saturate(_8828), 2.0)) * _16978) * length(_10970.xyz);
	    float _14945 = _5526 - _5854;
	    float _13659 = saturate((_14945 * _4095) * 0.125);
	    float _5461 = 1.0 - saturate((saturate(_5526 / _5854) * _Globals_.g_flLiquidBackFade) * 0.5);
	    float _7534 = (1.0 - _13659) * _5461;
	    float _21055 = saturate((_4472 + _3697) + _7534);
	    float _9387 = saturate((_7534 - _3697) * _22843);
	    float _21761 = saturate(_21055 * _22843);
	    float _9466 = saturate(_3697);
	    vec2 _4221 = (((((_20855 * _14443) + (_23695 * _14444)) + (_23696 * _14445)) + (_23697 * _14446)) * _3053) * _9466;
	    float _16782 = 1.0 - _4472;
	    vec3 _12355 = (_Globals_.g_vLiquidColor * _Globals_.g_flLiquidBrightness) * saturate(_16782);
	    float _12442 = cos(_Globals_.g_flLiquidColorHueShift);
	    float _12935;
	    do
	    {
	        float _17002 = _12355.x;
	        float _10964 = _12355.y;
	        float _21520 = _12355.z;
	        float _18473 = max(_17002, max(_10964, _21520));
	        if (_18473 == 0.0)
	        {
	            _12935 = 0.0;
	            break;
	        }
	        _12935 = (_18473 - min(_17002, min(_10964, _21520))) / _18473;
	        break;
	    } while(false);
	    vec3 _4789 = mix(vec3(dot(_12355.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), ((_12355 * _12442) + (cross(vec3(0.57735002040863037109375), _12355) * sin(_Globals_.g_flLiquidColorHueShift))) + ((vec3(0.57735002040863037109375) * dot(vec3(0.57735002040863037109375), _12355)) * (1.0 - _12442)), vec3(pow(_12935, 0.125))) * mix(vec3(1.0), vec4(_23013, _19498).xyz * 4.0, vec3(saturate(_Globals_.g_flBubbleOpacity * (_19498 * _9466))));
	    vec3 _14120 = _23714.xyz * mix(vec3(1.0), _4789, vec3(_21761));
	    vec4 _23718;
	    _23718.x = _14120.x;
	    _23718.y = _14120.y;
	    _23718.z = _14120.z;
	    vec3 _22490 = _23718.xyz + (((((_4789 * _Globals_.g_flLiquidBrightness) * pow(_16978, 3.0)) * _21761) / vec3(1.0 + max(_3921 - _11687, 0.0))) * _Globals_.g_flLiquidInnerGlow);
	    vec4 _20489;
	    _20489.x = _22490.x;
	    _20489.y = _22490.y;
	    _20489.z = _22490.z;
	    vec3 _21285 = _20489.xyz * (1.0 + ((_Globals_.g_flBrightenEmptyArea * _22843) * saturate(1.0 - _21055)));
	    vec4 _8673;
	    _8673.x = _21285.x;
	    _8673.y = _21285.y;
	    _8673.z = _21285.z;
	    vec3 _15116 = normalize(mix(normalize(mix(_23415, _21475, vec3(-0.300000011920928955078125)) + (((PerViewConstantBuffer_t._m4 * _4221.y) + (cross(PerViewConstantBuffer_t._m4, _10145) * _4221.x)) * _Globals_.g_flBubbleStrength)), normalize(vec3(_3144 * 0.5, 0.0, 0.0) - _24402), vec3(((saturate(1.0 - ((saturate(_5526) - saturate(_14945)) * 0.5)) * saturate(_21055)) * _9387) * (0.25 + (_5461 * 0.666666686534881591796875)))) * 1.10000002384185791015625);
	    float _11859 = mix(mix(_Globals_.g_flGlassRefraction, _Globals_.g_flLiquidRefraction, _21055), _Globals_.g_flLiquidSurfaceRefraction, _9387);
	    float _7133 = 1.0 - _20985;
	    vec2 _23399 = vec2(_23988);
	    float _18392 = _22452.w;
	    vec3 _24253 = mix(vec3(_Globals_.g_flReflectance).xyz, _8673.xyz, vec3(_18392));
	    vec3 _22362 = _15116.xyz;
	    vec3 _7997 = _20308.xyz;
	    vec3 _17138 = normalize(_7997 - PerViewConstantBuffer_t._m3.xyz);
	    vec3 _23996 = _17138.xyz;
	    vec3 _14278 = mix(_23415, mix(_23415, _22362, vec3(0.75)), vec3(_21055)).xyz;
	    vec3 _11823 = refract(_23996, _14278, _11859);
	    vec3 _7431 = mix(reflect(_23996, _14278), _11823, vec3(length(_11823)));
	    vec3 _9893 = _23415.xyz;
	    vec3 _12027 = -_9893;
	    uvec2 _7663 = uvec2(PerViewLightingConstantBufferGpu_t._m13.x);
	    uvec2 _12083 = uvec2(_20606.xy - PerViewConstantBuffer_t._m0.xy) >> _7663;
	    uint _7519 = (_12083.y * PerViewLightingConstantBufferGpu_t._m13.y) + _12083.x;
	    uint _13530 = PerViewLightingConstantBufferGpu_t._m12.y + (_7519 * PerViewLightingConstantBufferGpu_t._m12.z);
	    uint _6271 = uint(clamp(_6560 * PerViewLightingConstantBufferGpu_t._m14.x, 0.0, PerViewLightingConstantBufferGpu_t._m14.y));
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m12.x + (_6271 * PerViewLightingConstantBufferGpu_t._m12.z);
	    vec3 _13137;
	    float _16307;
	    _13137 = vec3(0.0);
	    _16307 = 0.0;
	    uint _8896;
	    vec3 _13139;
	    float _14082;
	    bool _18361;
	    uint _17017 = 0u;
	    bool _17133 = false;
	    for (;;)
	    {
	        bool _12885;
	        if (_17017 < PerViewLightingConstantBufferGpu_t._m12.z)
	        {
	            _12885 = !_17133;
	        }
	        else
	        {
	            _12885 = false;
	        }
	        if (!_12885)
	        {
	            break;
	        }
	        uint _14477 = subgroupOr(g_CullBits_1._m0[_13530 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        vec3 _13138;
	        _13138 = _13137;
	        uint _10155;
	        vec3 _13212;
	        float _15671;
	        float _16324 = _16307;
	        uint _17018 = _14477;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                _13139 = _13138;
	                _14082 = _16324;
	                _18361 = _17133;
	                break;
	            }
	            uint _18153 = uint(findLSB(_17018));
	            int _12608 = int(_18153 + (_17017 * 32u));
	            _10155 = _17018 & (_17018 - 1u);
	            vec4 _17484 = vec4(_7997, 1.0);
	            vec3 _15472 = (PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m0 * _17484).xyz;
	            vec3 _7190 = saturate((_15472 - PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m1.xyz) * PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m3);
	            vec3 _19651 = saturate((PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m2.xyz - _15472) * PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m3);
	            float _17265 = min(min(_7190.x, min(_7190.y, _7190.z)), min(_19651.x, min(_19651.y, _19651.z)));
	            if (_17265 == 0.0)
	            {
	                _13212 = _13138;
	                _15671 = _16324;
	                _13138 = _13212;
	                _16324 = _15671;
	                _17018 = _10155;
	                continue;
	            }
	            float _9613 = ((_17265 * _17265) * (((-2.0) * _17265) + 3.0)) * (1.0 - _16324);
	            float _6673 = _16324 + _9613;
	            vec3 _24893 = PerViewLightProbeVolumeConstantBuffer_t._m0._m0[PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m4]._m0 * _17484;
	            vec3 _6343 = _24893.xyz;
	            _6343.z = _24893.z * 0.16666667163372039794921875;
	            vec3 _19423 = clamp(_6343.xyz, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m4]._m1, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m4]._m2);
	            _19423.z = _19423.z * 6.0;
	            vec3 _23126 = (_19423.xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m4]._m4).xyz + PerViewLightProbeVolumeConstantBuffer_t._m0._m0[PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m4]._m5;
	            _23126.z = _23126.z * 0.16666667163372039794921875;
	            vec3 _17330 = _12027.xyz;
	            vec3 _16057 = mix(vec3(0.0, 0.16666667163372039794921875, 0.3333333432674407958984375), vec3(0.5, 0.666666686534881591796875, 0.833333313465118408203125), step(_17330, vec3(0.0)).xyz);
	            vec3 _16868 = _17330 * _17330;
	            vec3 _13872 = _13138 + (((((textureLod(sampler3D(g_tLPV_Irradiance, g_sBilinearClamp), _23126.xyz + vec3(0.0, 0.0, _16057.x), 0.0).xyz * _16868.x) + (textureLod(sampler3D(g_tLPV_Irradiance, g_sBilinearClamp), _23126.xyz + vec3(0.0, 0.0, _16057.y), 0.0).xyz * _16868.y)) + (textureLod(sampler3D(g_tLPV_Irradiance, g_sBilinearClamp), _23126.xyz + vec3(0.0, 0.0, _16057.z), 0.0).xyz * _16868.z)).xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[PerViewLightingConstantBufferGpu_t._m17._m0[_12608]._m4]._m3.xyz) * _9613);
	            if (_6673 > 0.9900000095367431640625)
	            {
	                _13139 = _13872;
	                _14082 = _6673;
	                _18361 = true;
	                break;
	            }
	            _13212 = _13872;
	            _15671 = _6673;
	            _13138 = _13212;
	            _16324 = _15671;
	            _17018 = _10155;
	            continue;
	        }
	        _8896 = _17017 + 1u;
	        _13137 = _13139;
	        _16307 = _14082;
	        _17133 = _18361;
	        _17017 = _8896;
	        continue;
	    }
	    vec3 _20940;
	    if (_16307 < 0.9900000095367431640625)
	    {
	        vec4 _23876 = vec4(_12027.xyz, 1.0);
	        _20940 = _13137 + (vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _23876), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _23876), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _23876)) * (1.0 - _16307));
	    }
	    else
	    {
	        _20940 = _13137;
	    }
	    vec2 _13387 = _23399.xy;
	    float _23698 = mix(0.100000001490116119384765625, 1.0, saturate(dot(_13387, vec2(0.5)) * _Globals_.g_flRefractRoughnessMultiplier));
	    float _23570 = PerViewLightingConstantBufferGpu_t._m15.y * sqrt(_23698);
	    float _17223 = _23698 * _23698;
	    float _20711 = saturate(1.0 - _17223);
	    vec3 _7292 = normalize(mix(_7431, _7431, vec3(_20711 * (sqrt(_20711) + _17223))));
	    uint _12111 = PerViewLightingConstantBufferGpu_t._m11.y + (_7519 * PerViewLightingConstantBufferGpu_t._m11.z);
	    uint _23395 = PerViewLightingConstantBufferGpu_t._m11.x + (_6271 * PerViewLightingConstantBufferGpu_t._m11.z);
	    vec4 _13140;
	    float _16308;
	    vec3 _17114;
	    _13140 = vec4(0.0);
	    _16308 = 0.00999999977648258209228515625;
	    _17114 = vec3(0.0);
	    uint _8897;
	    vec4 _13143;
	    vec3 _14891;
	    float _16310;
	    bool _18362;
	    uint _17019 = 0u;
	    bool _17134 = false;
	    for (;;)
	    {
	        bool _12886;
	        if (_17019 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12886 = !_17134;
	        }
	        else
	        {
	            _12886 = false;
	        }
	        if (!_12886)
	        {
	            break;
	        }
	        uint _14478 = subgroupOr(g_CullBits_1._m0[_12111 + _17019] & g_CullBits_1._m0[_23395 + _17019]);
	        vec3 _13141;
	        vec4 _16309;
	        _13141 = _17114;
	        _16309 = _13140;
	        uint _10156;
	        vec3 _13142;
	        vec4 _16381;
	        float _16479;
	        uint _17020 = _14478;
	        float _17135 = _16308;
	        for (;;)
	        {
	            if (!(_17020 != 0u))
	            {
	                _13143 = _16309;
	                _16310 = _17135;
	                _14891 = _13141;
	                _18362 = _17134;
	                break;
	            }
	            uint _18154 = uint(findLSB(_17020));
	            int _12609 = int(_18154 + (_17019 * 32u));
	            _10156 = _17020 & (_17020 - 1u);
	            vec3 _24589 = PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0 * vec4(_7997, 1.0);
	            vec3 _7743 = _24589.xyz;
	            vec3 _8794 = saturate((_7743 - PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m1) * PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m4.xyz);
	            vec3 _19652 = saturate((PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m3 - _7743) * PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m4.xyz);
	            float _17266 = min(min(_8794.x, min(_8794.y, _8794.z)), min(_19652.x, min(_19652.y, _19652.z)));
	            if (_17266 == 0.0)
	            {
	                _13142 = _13141;
	                _16381 = _16309;
	                _16479 = _17135;
	                _13141 = _13142;
	                _16309 = _16381;
	                _17135 = _16479;
	                _17020 = _10156;
	                continue;
	            }
	            vec3 _24234 = _24589.xyz;
	            vec3 _7648 = (PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0 * vec4(_7292.xyz, 0.0)).xyz;
	            vec3 _11253 = max(((PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m3.xyz - _24234) / _7648).xyz, ((PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m1.xyz - _24234) / _7648).xyz);
	            float _11076 = ((_17266 * _17266) * (((-2.0) * _17266) + 3.0)) * (1.0 - _17135);
	            float _13713 = _17135 + _11076;
	            vec3 _15431 = _13141 + ((textureLod(samplerCubeArray(g_tEnvironmentMap, g_sTrilinearWrap), vec4(mix(_24234 + (_7648 * abs(min(_11253.x, min(_11253.y, _11253.z)))), _7648, vec3(_23698)).xyz, float(PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m2)), _23570).xyz * PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m5) * _11076);
	            vec4 _7460 = _16309 + (PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m6 * _11076);
	            if (_13713 > 0.9900000095367431640625)
	            {
	                _13143 = _7460;
	                _16310 = _13713;
	                _14891 = _15431;
	                _18362 = true;
	                break;
	            }
	            _13142 = _15431;
	            _16381 = _7460;
	            _16479 = _13713;
	            _13141 = _13142;
	            _16309 = _16381;
	            _17135 = _16479;
	            _17020 = _10156;
	            continue;
	        }
	        _8897 = _17019 + 1u;
	        _13140 = _13143;
	        _16308 = _16310;
	        _17114 = _14891;
	        _17134 = _18362;
	        _17019 = _8897;
	        continue;
	    }
	    float _18406 = mix(_Globals_.g_flCubeRefractTransparency, _Globals_.g_flCubeRefractLiquidTransparency, _21055);
	    vec3 _19791 = (mix(_8673.xyz * mix(1.25, 0.75, _13948), vec3(1.0), vec3(saturate(_18406 - 1.0))) * ((_17114 / vec3(_16308)).xyz * min(dot(_20940.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_7431.xyz, 1.0), (_13140 / vec4(_16308)).xyzw), max((_23698 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz) * _Globals_.g_flCubeRefractBrightness;
	    vec3 _10033 = vec3(saturate(_18406 * _22843));
	    vec3 _7811 = ((_4789 * _21761) * _Globals_.g_flLiquidEmissiveStrength).xyz + mix(vec3(0.0), _19791, _10033);
	    bvec3 _19899 = bvec3(all(equal(_9982, vec3(1.0))));
	    vec3 _17892 = mix(_9982, _23415, _19899);
	    vec3 _10560 = _20700.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _11004 = max(_23399.xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _10170 = -_20700;
	    vec4 _22272 = vec4(_9893, 1.0);
	    vec3 _18708 = vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _22272), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _22272), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _22272));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    float _21710;
	    if (_20059)
	    {
	        vec3 _11394 = _20700.xyz;
	        vec2 _10548 = ((floor(_20606.xy * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m7.xy) + (PerViewConstantBufferCsgo_t._m7.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10548).xyzw - _20606.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m7.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20966 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20966;
	        vec2 _23169;
	        if (_12286)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m7.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m7.x * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.y * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.z * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.w * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21710 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_13232, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10548 + mix(_23169, PerViewConstantBufferCsgo_t._m7.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20966))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    bvec4 _24466 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    bool _20060 = _24466.w;
	    float _21711;
	    if (_20060)
	    {
	        _21711 = _21710 * textureLod(sampler2D(g_tSsao, g_sUserConfig), (_20606.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21711 = _21710;
	    }
	    bool _14874 = PerViewLightingConstantBufferGpu_t._m20 != 0;
	    float _21712;
	    SPIRV_CROSS_BRANCH
	    if (_14874)
	    {
	        int _23989;
	        int _10191;
	        float _13144;
	        vec3 _14976;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m20))
	            {
	                _13144 = 1.0;
	                _14976 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_8.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m27._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m22[_13039])
	            {
	                vec3 _19471 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19471.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m24)) + vec2(PerViewLightingConstantBufferGpu_t._m23));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m28._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m28._m0[_13039].xy;
	                vec3 _20490 = _19471;
	                _20490.x = _20561.x;
	                _20490.y = _20561.y;
	                _13144 = saturate(_22193.x * _22193.y);
	                _14976 = _20490;
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
	            vec2 _7045;
	            vec2 _7046;
	            vec2 _7735;
	            float _8969;
	            float _8970;
	            float _15996;
	            float _17299;
	            vec2 _18870;
	            vec4 _20581;
	            vec4 _22023;
	            float _23727;
	            do
	            {
	                float _21452 = saturate(_14976.z + PerViewLightingConstantBufferGpu_t._m21);
	                _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                _22023 = PerViewLightingConstantBufferGpu_t._m1;
	                _17299 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15996 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18870 = vec2(_17299, _15996);
	                _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7045 = vec2(_8969, _15996);
	                _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7046 = vec2(_17299, _8970);
	                _7735 = vec2(_8969, _8970);
	                float _15310 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + _18870).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + _7045).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + _7046).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + _7735).xy, _21452), 0.0)).xyzw, vec4(0.25));
	                bool _12887;
	                if (_15310 == 0.0)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    _12887 = _15310 == 1.0;
	                }
	                if (_12887)
	                {
	                    _23727 = _15310;
	                    break;
	                }
	                _23727 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + vec2(_17299, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + vec2(_8969, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + vec2(0.0, _8970)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14976.xy + vec2(0.0, _15996)).xy, _21452), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14976.xy, _21452), 0.0) * _22023.y);
	                break;
	            } while(false);
	            float _12502;
	            SPIRV_CROSS_BRANCH
	            if (_13144 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m20 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_8.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m27._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m28._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m28._m0[_15335].xy;
	                    vec3 _20491;
	                    _20491.x = _20562.x;
	                    _20491.y = _20562.y;
	                    float _12501;
	                    do
	                    {
	                        float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m21);
	                        float _15311 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + _18870).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + _7045).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + _7046).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + _7735).xy, _20322), 0.0)).xyzw, vec4(0.25));
	                        bool _12888;
	                        if (_15311 == 0.0)
	                        {
	                            _12888 = true;
	                        }
	                        else
	                        {
	                            _12888 = _15311 == 1.0;
	                        }
	                        if (_12888)
	                        {
	                            _12501 = _15311;
	                            break;
	                        }
	                        _12501 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + vec2(_17299, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + vec2(_8969, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + vec2(0.0, _8970)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20491.xy + vec2(0.0, _15996)).xy, _20322), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20491.xy, _20322), 0.0) * _22023.y);
	                        break;
	                    } while(false);
	                    _7934 = _12501;
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12502 = mix(_7934, _23727, _13144);
	            }
	            else
	            {
	                _12502 = _23727;
	            }
	            _18423 = _12502;
	        }
	        else
	        {
	            _18423 = 1.0;
	        }
	        float _13279 = mix(_18423, 1.0, saturate((distance(_20308.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m26) + PerViewLightingConstantBufferGpu_t._m25));
	        float _12503;
	        if (_24465.y)
	        {
	            _12503 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_20606.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12503 = _13279;
	        }
	        _21712 = _12503;
	    }
	    else
	    {
	        _21712 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m18.xyz, _9893) * _21712) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _9893, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_23415.xyz, PerViewLightingConstantBufferGpu_t._m18.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_22456 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m18.xyz);
	            float _8124 = saturate(_22456);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * saturate((_8780 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_9893, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m18.xyz), 1.0, _8124))), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_11004, vec2(PerViewLightingConstantBufferGpu_t._m18.w));
	        vec3 _21889 = (-_17138).xyz;
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m18.xyz + _21889).xyz;
	        vec3 _19012 = _15460.xyz;
	        float _12386 = dot(_12281, _19012);
	        vec3 _22995 = _24253.xyz;
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _24198 = _25211 / (((_12386 * _12386) * ((_25211 * _25211) - 1.0)) + 1.0);
	        float _16150 = _9850 + 1.0;
	        float _6835 = (_16150 * _16150) * 0.125;
	        float _19569 = 1.0 - _6835;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m19.xyz * _21712).xyz;
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz + (_18223.xyz * _16808);
	        _24878 = (((_22995 + ((vec3(1.0) - _22995) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m18.xyz, _12281))), 5.0))) * ((_24198 * _24198) / ((4.0 * ((_13811 * _19569) + _6835)) * ((max(0.0, dot(_19012, _21889)) * _19569) + _6835)))).xyz * _13811).xyz * _16808;
	    }
	    else
	    {
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz;
	        _24878 = vec3(0.0);
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20061 = _24467.x;
	    vec4 _20617;
	    if (_20061)
	    {
	        vec4 _18621 = vec4(_20308.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m6;
	        float _20176 = _18621.w;
	        vec2 _11415 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11415.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6651.y = clamp(((1.0 - _11415.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6651.w = _20176;
	        _20617 = _6651;
	    }
	    else
	    {
	        _20617 = _20606;
	    }
	    uvec2 _6814 = uvec2(_20617.xy - PerViewConstantBuffer_t._m0.xy) >> _7663;
	    uint _12131 = PerViewLightingConstantBufferGpu_t._m10.y + (((_6814.y * PerViewLightingConstantBufferGpu_t._m13.y) + _6814.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _23396 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_20617.w * PerViewLightingConstantBufferGpu_t._m14.x, 0.0, PerViewLightingConstantBufferGpu_t._m14.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13145;
	    vec3 _16311;
	    vec3 _17136;
	    _13145 = vec3(0.0);
	    _16311 = _9716;
	    _17136 = _24878;
	    uint _21567;
	    vec3 _13146;
	    vec3 _16312;
	    vec3 _17137;
	    uint _17021 = 0u;
	    for (;;)
	    {
	        if (!(_17021 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14479 = subgroupOr(g_CullBits_1._m0[_12131 + _17021] & g_CullBits_1._m0[_23396 + _17021]);
	        _13146 = _13145;
	        _16312 = _17136;
	        _17137 = _16311;
	        uint _20344;
	        vec3 _13147;
	        vec3 _16382;
	        vec3 _16480;
	        uint _17022 = _14479;
	        for (;;)
	        {
	            if (!(_17022 != 0u))
	            {
	                break;
	            }
	            int _12610 = int(uint(findLSB(_17022)) + (_17021 * 32u));
	            _20344 = _17022 & (_17022 - 1u);
	            do
	            {
	                vec4 _24894 = g_BarnLights_1._m0[_12610]._m0 * vec4(input_8.xyz, 1.0);
	                vec3 _10521 = _24894.xyz / vec3(_24894.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21777 = _10521.z;
	                _22905.z = _21777;
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
	                bool _12889;
	                if (!_7424)
	                {
	                    _12889 = true;
	                }
	                else
	                {
	                    _12889 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12610]._m15 * vec4(input_8.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12889)
	                {
	                    _13147 = _13146;
	                    _16382 = _16312;
	                    _16480 = _17137;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12610]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12610]._m5.z) * g_BarnLights_1._m0[_12610]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12610]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12610]._m5.y;
	                float _17331 = 2.0 * g_BarnLights_1._m0[_12610]._m5.w;
	                float _19825 = _17331 * g_BarnLights_1._m0[_12610]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12610]._m5.x)) - _18492, (_23572 * g_BarnLights_1._m0[_12610]._m5.z) + (_17331 * g_BarnLights_1._m0[_12610]._m5.x)) * g_BarnLights_1._m0[_12610]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12610]._m3.z > 0.0)
	                {
	                    _21316 = smoothstep(0.0, 1.0, _21777 * g_BarnLights_1._m0[_12610]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12610]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21777) * g_BarnLights_1._m0[_12610]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12610]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12610]._m2.xyz - input_8.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _20958 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _20958;
	                        float _25105 = dot(-_20958, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _20958;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _20958 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12610]._m2.w / max(_18345, g_BarnLights_1._m0[_12610]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12610]._m3.x + (g_BarnLights_1._m0[_12610]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12610]._m6.x + (g_BarnLights_1._m0[_12610]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12610]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12610]._m5.z) - (_17331 * g_BarnLights_1._m0[_12610]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11179 = g_BarnLights_1._m0[_12610]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12610]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12610]._m8.z > 0.0)
	                {
	                    _24419 = !_20061;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                vec3 _21548;
	                SPIRV_CROSS_BRANCH
	                if (g_BarnLights_1._m0[_12610]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights_1._m0[_12610]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_12610]._m9.x, _22154.x) * smoothstep(1.0, g_BarnLights_1._m0[_12610]._m9.y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15267 = 2.0 / g_BarnLights_1._m0[_12610]._m9.z;
	                            float _15018 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12610]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12610]._m9.x * g_BarnLights_1._m0[_12610]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12610]._m9.y * _11473, _15267) + pow(g_BarnLights_1._m0[_12610]._m9.x * _15018, _15267), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15267) + pow(_15018, _15267), 1.1754943508222875079687365372222e-38), _23041);
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
	                    vec3 _12504;
	                    if (g_BarnLights_1._m0[_12610]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12610]._m5.xyz, g_BarnLights_1._m0[_12610]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
	                        float _15157 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15157).xyz;
	                        vec3 _23593 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12610]._m5.w) + (_23593 * _15157)) + cross(_23593, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12610]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12610]._m9.zw) + g_BarnLights_1._m0[_12610]._m9.xy;
	                        vec3 _20493 = _14081;
	                        _20493.x = _20564.x;
	                        _20493.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20493.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12610]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12610]._m9.zw) + g_BarnLights_1._m0[_12610]._m9.xy;
	                        vec3 _20492 = _13791;
	                        _20492.x = _20563.x;
	                        _20492.y = _20563.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20492.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13147 = _13146;
	                    _16382 = _16312;
	                    _16480 = _17137;
	                    break;
	                }
	                vec3 _21549;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12610]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23720 = _21642;
	                        _23720.x = _6281.x;
	                        _23720.y = _6281.y;
	                        _19629 = _23720;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m21);
	                        vec2 _14623 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12610]._m8.zw, g_BarnLights_1._m0[_12610]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0)).xyzw, vec4(0.25));
	                        bool _12890;
	                        if (_15312 == 0.0)
	                        {
	                            _12890 = true;
	                        }
	                        else
	                        {
	                            _12890 = _15312 == 1.0;
	                        }
	                        if (_12890)
	                        {
	                            _24972 = _15312;
	                            break;
	                        }
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14623 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14623, _11455), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_12610]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _13147 = _13146;
	                        _16382 = _16312;
	                        _16480 = _17137;
	                        break;
	                    }
	                    _21549 = _19878;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15462 = mix(_17892, _9893, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_23415.xyz, _11179.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18224;
	                if (_22456 > 0.0)
	                {
	                    float _8781 = dot(_15462, _11179.xyz);
	                    float _8125 = saturate(_22456);
	                    _18224 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * saturate((_8781 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_9893, _15462, vec3(10.0)), _11179.xyz), 1.0, _8125))), vec3(_8125));
	                }
	                else
	                {
	                    _18224 = _17875;
	                }
	                vec2 _17302 = max(_11004, vec2(g_BarnLights_1._m0[_12610]._m11));
	                vec3 _21890 = (-_17138).xyz;
	                vec3 _12282 = normalize(_11179.xyz + _21890).xyz;
	                vec3 _19014 = _15462.xyz;
	                float _12387 = dot(_12282, _19014);
	                vec3 _22996 = _24253.xyz;
	                float _9851 = _17302.x;
	                float _25212 = _9851 * _9851;
	                float _24199 = _25212 / (((_12387 * _12387) * ((_25212 * _25212) - 1.0)) + 1.0);
	                float _16151 = _9851 + 1.0;
	                float _6836 = (_16151 * _16151) * 0.125;
	                float _19571 = 1.0 - _6836;
	                _13147 = _13146.xyz;
	                _16382 = _16312.xyz + ((((_22996 + ((vec3(1.0) - _22996) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11179.xyz, _12282))), 5.0))) * ((_24199 * _24199) / ((4.0 * ((_13812 * _19571) + _6836)) * ((max(0.0, dot(_19014, _21890)) * _19571) + _6836)))).xyz * _13812).xyz * _21549.xyz);
	                _16480 = _17137.xyz + (_18224.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13146 = _13147;
	            _16312 = _16382;
	            _17137 = _16480;
	            _17022 = _20344;
	            continue;
	        }
	        _21567 = _17021 + 1u;
	        _13145 = _13146;
	        _16311 = _17137;
	        _17136 = _16312;
	        _17021 = _21567;
	        continue;
	    }
	    vec3 _23721 = -_17138;
	    float _17139 = _11004.x + _11004.y;
	    float _19583 = _17139 * _17139;
	    float _17752 = dot(_11004.xy, vec2(0.5));
	    vec3 _24388 = _17892.xyz;
	    vec3 _13688 = _17892.xyz;
	    float _10356 = PerViewLightingConstantBufferGpu_t._m15.y * sqrt(_17752);
	    float _18435 = _17752 * _17752;
	    float _20712 = saturate(1.0 - _18435);
	    vec3 _10698 = normalize(mix(_24388, reflect(_23996, _13688).xyz, vec3(_20712 * (sqrt(_20712) + _18435))));
	    vec4 _13148;
	    float _16313;
	    vec3 _17115;
	    _13148 = vec4(0.0);
	    _16313 = 0.00999999977648258209228515625;
	    _17115 = vec3(0.0);
	    uint _8898;
	    vec4 _13151;
	    vec3 _14892;
	    float _16315;
	    bool _18389;
	    uint _17024 = 0u;
	    bool _17140 = false;
	    for (;;)
	    {
	        bool _12891;
	        if (_17024 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12891 = !_17140;
	        }
	        else
	        {
	            _12891 = false;
	        }
	        if (!_12891)
	        {
	            break;
	        }
	        uint _14480 = subgroupOr(g_CullBits_1._m0[_12111 + _17024] & g_CullBits_1._m0[_23395 + _17024]);
	        vec3 _13149;
	        vec4 _16314;
	        _13149 = _17115;
	        _16314 = _13148;
	        uint _10159;
	        vec3 _13150;
	        vec4 _16383;
	        float _16481;
	        uint _17025 = _14480;
	        float _17141 = _16313;
	        for (;;)
	        {
	            if (!(_17025 != 0u))
	            {
	                _13151 = _16314;
	                _16315 = _17141;
	                _14892 = _13149;
	                _18389 = _17140;
	                break;
	            }
	            uint _18156 = uint(findLSB(_17025));
	            int _12611 = int(_18156 + (_17024 * 32u));
	            _10159 = _17025 & (_17025 - 1u);
	            vec3 _24590 = PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m0 * vec4(_7997, 1.0);
	            vec3 _7749 = _24590.xyz;
	            vec3 _8795 = saturate((_7749 - PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m1) * PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m4.xyz);
	            vec3 _19653 = saturate((PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m3 - _7749) * PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m4.xyz);
	            float _17267 = min(min(_8795.x, min(_8795.y, _8795.z)), min(_19653.x, min(_19653.y, _19653.z)));
	            if (_17267 == 0.0)
	            {
	                _13150 = _13149;
	                _16383 = _16314;
	                _16481 = _17141;
	                _13149 = _13150;
	                _16314 = _16383;
	                _17141 = _16481;
	                _17025 = _10159;
	                continue;
	            }
	            vec3 _24235 = _24590.xyz;
	            vec3 _7649 = (PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m0 * vec4(_10698.xyz, 0.0)).xyz;
	            vec3 _11254 = max(((PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m3.xyz - _24235) / _7649).xyz, ((PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m1.xyz - _24235) / _7649).xyz);
	            float _11077 = ((_17267 * _17267) * (((-2.0) * _17267) + 3.0)) * (1.0 - _17141);
	            float _13714 = _17141 + _11077;
	            vec3 _15432 = _13149 + ((textureLod(samplerCubeArray(g_tEnvironmentMap, g_sTrilinearWrap), vec4(mix(_24235 + (_7649 * abs(min(_11254.x, min(_11254.y, _11254.z)))), _7649, vec3(_17752)).xyz, float(PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m2)), _10356).xyz * PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m5) * _11077);
	            vec4 _7461 = _16314 + (PerViewLightingConstantBufferGpu_t._m16._m0[_12611]._m6 * _11077);
	            if (_13714 > 0.9900000095367431640625)
	            {
	                _13151 = _7461;
	                _16315 = _13714;
	                _14892 = _15432;
	                _18389 = true;
	                break;
	            }
	            _13150 = _15432;
	            _16383 = _7461;
	            _16481 = _13714;
	            _13149 = _13150;
	            _16314 = _16383;
	            _17141 = _16481;
	            _17025 = _10159;
	            continue;
	        }
	        _8898 = _17024 + 1u;
	        _13148 = _13151;
	        _16313 = _16315;
	        _17115 = _14892;
	        _17140 = _18389;
	        _17024 = _8898;
	        continue;
	    }
	    vec3 _20869 = _23721.xyz;
	    vec4 _11487 = textureLod(sampler2DArray(g_tBRDFLookup, g_sBilinearClamp), vec3((vec2(_17752, sqrt(1.0 - max(0.0, dot(_20869, _24388)))) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _7300 = mix(_11487.xxx, _11487.yyy, _24253);
	    float _21809 = 1.0 - _11487.y;
	    vec3 _15517 = _24253 + ((vec3(1.0) - _24253) * vec3(0.0476190485060214996337890625));
	    vec3 _23208 = ((_7300 * _15517) / (vec3(1.0) - (_15517 * _21809))) * _21809;
	    vec3 _13436 = vec3(_21711).xyz;
	    vec3 _22686 = (_16311.xyz + ((_18708 * (vec3(1.0) - (_7300 + _23208))).xyz * _13436).xyz) * mix((_8673.xyz * (1.0 - _18392)).xyz, _19791, _10033).xyz;
	    vec3 _15752 = vec4(_22686, 1.0).xyz + _7811.xyz;
	    vec4 _20494;
	    _20494.x = _15752.x;
	    _20494.y = _15752.y;
	    _20494.z = _15752.z;
	    vec3 _15753 = _20494.xyz + ((_17136 * (vec3(1.0) + (_24253 * ((0.125 * (_19583 * _19583)) * saturate(dot(_17892, _23721)))))).xyz * _13436).xyz;
	    vec4 _20495;
	    _20495.x = _15753.x;
	    _20495.y = _15753.y;
	    _20495.z = _15753.z;
	    vec3 _15754 = _20495.xyz + ((((_17115 / vec3(_16313)).xyz * min(dot(_18708.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_13688, 1.0), (_13148 / vec4(_16313)).xyzw), max((_17752 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_7300 + _23208)).xyz * _13436).xyz;
	    vec4 _20496;
	    _20496.x = _15754.x;
	    _20496.y = _15754.y;
	    _20496.z = _15754.z;
	    vec3 _20177 = _20496.xyz + (_13145.xyz * (((((mix(normalize(_8673.xyz), _8673.xyz, vec3(0.949999988079071044921875)) * _22843) * _16978) * _7133) * 0.100000001490116119384765625) * _Globals_.g_flTransmissiveStrength).xyz);
	    vec4 _20497;
	    _20497.x = _20177.x;
	    _20497.y = _20177.y;
	    _20497.z = _20177.z;
	    float _14346 = _23988 + 0.20000000298023223876953125;
	    float _15102 = pow(saturate(dot(normalize(refract(_10145.xyz, _14278, mix(_11859, 1.0, 0.5)).xyz), PerViewLightingConstantBufferGpu_t._m18.xyz)), 40.0 / _14346);
	    vec3 _13862 = _20497.xyz + ((((((_8673.xyz * (pow(PerViewLightingConstantBufferGpu_t._m19.xyz, vec3(2.0)) * (((_15102 + (pow(_15102, 400.0 / _14346) * 4.0)) * _22843) * 4.0))) * _18406) * 2.0) * _Globals_.g_flCubeRefractBrightness) * _22843) * 1.0);
	    vec4 _20498;
	    _20498.x = _13862.x;
	    _20498.y = _13862.y;
	    _20498.z = _13862.z;
	    vec3 _23984 = mix(_9982, _15116, _19899);
	    vec3 _15654 = dFdx(_10560);
	    vec3 _23647 = dFdy(_10560);
	    vec3 _10348 = _15654.xyz;
	    vec3 _12421 = _23647.xyz;
	    vec2 _11005 = max(mix(mix(_13387, vec2(saturate(_Globals_.g_flLiquidRoughness)), vec2(saturate((_12614 - _13659) * 2.0))).xy, vec2(0.75), vec2((((1.0 - saturate((abs(_5526 - 0.0900000035762786865234375) * _19871) * _4095)) * _19871) * _Globals_.g_flWaterLineStrength) * 2.0)).xy, vec2(pow(saturate(max(dot(_10348, _10348), dot(_12421, _12421))), 0.333000004291534423828125)));
	    vec4 _20111 = vec4(_22362, 1.0);
	    float _12892;
	    if (_20059)
	    {
	        vec3 _11395 = _20700.xyz;
	        vec2 _10549 = ((floor(_20606.xy * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m7.xy) + (PerViewConstantBufferCsgo_t._m7.xy * 0.5)).xy;
	        vec4 _18419 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10549).xyzw - _20606.zzzz;
	        float _18580 = _18419.w;
	        float _12016 = _18419.z;
	        bool _12287 = abs(_12016) < _18580;
	        vec2 _23170;
	        if (_12287)
	        {
	            _23170 = vec2(PerViewConstantBufferCsgo_t._m7.x, 0.0);
	        }
	        else
	        {
	            _23170 = vec2(0.0);
	        }
	        float _20969 = _12287 ? _12016 : _18580;
	        float _15375 = _18419.x;
	        bool _12288 = abs(_15375) < _20969;
	        vec2 _23171;
	        if (_12288)
	        {
	            _23171 = vec2(0.0, PerViewConstantBufferCsgo_t._m7.y);
	        }
	        else
	        {
	            _23171 = _23170;
	        }
	        vec4 _10011 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m7.x * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.y * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.z * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.w * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13233 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _11395), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _11395), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _11395), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _11395)).xyzw, vec4(0.0)) * normalize(saturate(((_10011 - vec4(max(max(_10011.x, _10011.y), max(_10011.z, _10011.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _12892 = (1.0 / (dot(_13233, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_13233, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10549 + mix(_23171, PerViewConstantBufferCsgo_t._m7.xy, bvec2(abs(_18419.y) < (_12288 ? _15375 : _20969))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _12892 = 1.0;
	    }
	    float _12893;
	    if (_20060)
	    {
	        _12893 = _12892 * textureLod(sampler2D(g_tSsao, g_sUserConfig), (_20606.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _12893 = _12892;
	    }
	    float _8718;
	    SPIRV_CROSS_BRANCH
	    if (_14874)
	    {
	        int _23993;
	        int _10192;
	        float _13152;
	        vec3 _14978;
	        int _13040 = 0;
	        for (;;)
	        {
	            if (!(_13040 < PerViewLightingConstantBufferGpu_t._m20))
	            {
	                _13152 = 1.0;
	                _14978 = vec3(0.0);
	                _10192 = -1;
	                break;
	            }
	            vec4 _18323 = vec4(input_8.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m27._m0[_13040];
	            float _12780 = _18323.x;
	            if (max(abs(_12780), abs(_18323.y)) < PerViewLightingConstantBufferGpu_t._m22[_13040])
	            {
	                vec3 _19472 = vec3(_12780, _18323.yz);
	                vec2 _24805 = _19472.xy;
	                vec2 _22194 = vec2(1.0) - saturate((abs(_24805) * vec2(PerViewLightingConstantBufferGpu_t._m24)) + vec2(PerViewLightingConstantBufferGpu_t._m23));
	                vec2 _20565 = (_24805 * PerViewLightingConstantBufferGpu_t._m28._m0[_13040].zw) + PerViewLightingConstantBufferGpu_t._m28._m0[_13040].xy;
	                vec3 _20499 = _19472;
	                _20499.x = _20565.x;
	                _20499.y = _20565.y;
	                _13152 = saturate(_22194.x * _22194.y);
	                _14978 = _20499;
	                _10192 = _13040;
	                break;
	            }
	            _23993 = _13040 + 1;
	            _13040 = _23993;
	            continue;
	        }
	        float _18424;
	        if (_10192 >= 0)
	        {
	            vec2 _7049;
	            vec2 _7050;
	            vec2 _7750;
	            float _8974;
	            float _8976;
	            float _15998;
	            float _17304;
	            vec2 _18875;
	            vec4 _20583;
	            vec4 _22025;
	            float _23728;
	            do
	            {
	                float _21453 = saturate(_14978.z + PerViewLightingConstantBufferGpu_t._m21);
	                _20583 = PerViewLightingConstantBufferGpu_t._m0;
	                _22025 = PerViewLightingConstantBufferGpu_t._m1;
	                _17304 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15998 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18875 = vec2(_17304, _15998);
	                _8974 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7049 = vec2(_8974, _15998);
	                _8976 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7050 = vec2(_17304, _8976);
	                _7750 = vec2(_8974, _8976);
	                float _15313 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + _18875).xy, _21453), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + _7049).xy, _21453), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + _7050).xy, _21453), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + _7750).xy, _21453), 0.0)).xyzw, vec4(0.25));
	                bool _12894;
	                if (_15313 == 0.0)
	                {
	                    _12894 = true;
	                }
	                else
	                {
	                    _12894 = _15313 == 1.0;
	                }
	                if (_12894)
	                {
	                    _23728 = _15313;
	                    break;
	                }
	                _23728 = ((_15313 * (_20583.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + vec2(_17304, 0.0)).xy, _21453), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + vec2(_8974, 0.0)).xy, _21453), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + vec2(0.0, _8976)).xy, _21453), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14978.xy + vec2(0.0, _15998)).xy, _21453), 0.0)).xyzw, _22025.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14978.xy, _21453), 0.0) * _22025.y);
	                break;
	            } while(false);
	            float _12508;
	            SPIRV_CROSS_BRANCH
	            if (_13152 < 1.0)
	            {
	                float _7935;
	                if (_10192 < (PerViewLightingConstantBufferGpu_t._m20 - 1))
	                {
	                    int _15336 = _10192 + 1;
	                    vec4 _19672 = vec4(input_8.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m27._m0[_15336];
	                    vec2 _20568 = (_19672.xy * PerViewLightingConstantBufferGpu_t._m28._m0[_15336].zw) + PerViewLightingConstantBufferGpu_t._m28._m0[_15336].xy;
	                    vec3 _20500;
	                    _20500.x = _20568.x;
	                    _20500.y = _20568.y;
	                    float _12505;
	                    do
	                    {
	                        float _20323 = saturate(_19672.z + PerViewLightingConstantBufferGpu_t._m21);
	                        float _15314 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + _18875).xy, _20323), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + _7049).xy, _20323), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + _7050).xy, _20323), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + _7750).xy, _20323), 0.0)).xyzw, vec4(0.25));
	                        bool _12895;
	                        if (_15314 == 0.0)
	                        {
	                            _12895 = true;
	                        }
	                        else
	                        {
	                            _12895 = _15314 == 1.0;
	                        }
	                        if (_12895)
	                        {
	                            _12505 = _15314;
	                            break;
	                        }
	                        _12505 = ((_15314 * (_20583.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + vec2(_17304, 0.0)).xy, _20323), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + vec2(_8974, 0.0)).xy, _20323), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + vec2(0.0, _8976)).xy, _20323), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20500.xy + vec2(0.0, _15998)).xy, _20323), 0.0)).xyzw, _22025.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20500.xy, _20323), 0.0) * _22025.y);
	                        break;
	                    } while(false);
	                    _7935 = _12505;
	                }
	                else
	                {
	                    _7935 = 1.0;
	                }
	                _12508 = mix(_7935, _23728, _13152);
	            }
	            else
	            {
	                _12508 = _23728;
	            }
	            _18424 = _12508;
	        }
	        else
	        {
	            _18424 = 1.0;
	        }
	        float _13280 = mix(_18424, 1.0, saturate((distance(_20308.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m26) + PerViewLightingConstantBufferGpu_t._m25));
	        float _12509;
	        if (_24465.y)
	        {
	            _12509 = min(_13280, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_20606.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12509 = _13280;
	        }
	        _8718 = _12509;
	    }
	    else
	    {
	        _8718 = 1.0;
	    }
	    vec3 _12896;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m18.xyz, _22362) * _8718) > 0.0)
	    {
	        float _10545 = max(0.0, dot(_15116.xyz, PerViewLightingConstantBufferGpu_t._m18.xyz));
	        vec2 _21614 = max(_11005, vec2(PerViewLightingConstantBufferGpu_t._m18.w));
	        vec3 _21891 = _23721.xyz;
	        vec3 _12283 = normalize(PerViewLightingConstantBufferGpu_t._m18.xyz + _21891).xyz;
	        vec3 _19016 = mix(_23984, _22362, bvec3(all(equal(_23984, vec3(1.0))))).xyz;
	        float _12388 = dot(_12283, _19016);
	        vec3 _22997 = _24253.xyz;
	        float _9852 = _21614.x;
	        float _25213 = _9852 * _9852;
	        float _24200 = _25213 / (((_12388 * _12388) * ((_25213 * _25213) - 1.0)) + 1.0);
	        float _16152 = _9852 + 1.0;
	        float _6838 = (_16152 * _16152) * 0.125;
	        float _19573 = 1.0 - _6838;
	        _12896 = (((_22997 + ((vec3(1.0) - _22997) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m18.xyz, _12283))), 5.0))) * ((_24200 * _24200) / ((4.0 * ((_10545 * _19573) + _6838)) * ((max(0.0, dot(_19016, _21891)) * _19573) + _6838)))).xyz * _10545).xyz * (PerViewLightingConstantBufferGpu_t._m19.xyz * _8718).xyz;
	    }
	    else
	    {
	        _12896 = vec3(0.0);
	    }
	    vec4 _20618;
	    if (_20061)
	    {
	        vec4 _18624 = vec4(_20308.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m6;
	        float _20178 = _18624.w;
	        vec2 _11416 = _18624.xy / vec2(_20178);
	        vec4 _6652;
	        _6652.x = clamp(((_11416.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6652.y = clamp(((1.0 - _11416.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6652.w = _20178;
	        _20618 = _6652;
	    }
	    else
	    {
	        _20618 = _20606;
	    }
	    uvec2 _6815 = uvec2(_20618.xy - PerViewConstantBuffer_t._m0.xy) >> _7663;
	    uint _14522 = PerViewLightingConstantBufferGpu_t._m10.y + (((_6815.y * PerViewLightingConstantBufferGpu_t._m13.y) + _6815.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _7535 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_20618.w * PerViewLightingConstantBufferGpu_t._m14.x, 0.0, PerViewLightingConstantBufferGpu_t._m14.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13155;
	    _13155 = _12896;
	    uint _21568;
	    vec3 _13158;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14482 = subgroupOr(g_CullBits_1._m0[_14522 + _16208] & g_CullBits_1._m0[_7535 + _16208]);
	        _13158 = _13155;
	        uint _20345;
	        vec3 _12512;
	        uint _16209 = _14482;
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            int _12612 = int(uint(findLSB(_16209)) + (_16208 * 32u));
	            _20345 = _16209 & (_16209 - 1u);
	            do
	            {
	                vec4 _24895 = g_BarnLights_1._m0[_12612]._m0 * vec4(input_8.xyz, 1.0);
	                vec3 _10523 = _24895.xyz / vec3(_24895.w);
	                vec4 _22906;
	                _22906.x = _10523.x;
	                _22906.y = _10523.y;
	                float _21790 = _10523.z;
	                _22906.z = _21790;
	                vec3 _21643 = _22906.xyz;
	                bool _7425;
	                if (all(greaterThan(_22906.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7425 = all(lessThan(_22906.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12897;
	                if (!_7425)
	                {
	                    _12897 = true;
	                }
	                else
	                {
	                    _12897 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12612]._m15 * vec4(input_8.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12897)
	                {
	                    _12512 = _13158;
	                    break;
	                }
	                float _23574 = 2.0 * g_BarnLights_1._m0[_12612]._m5.y;
	                float _18494 = (2.0 * g_BarnLights_1._m0[_12612]._m5.z) * g_BarnLights_1._m0[_12612]._m5.z;
	                float _14806 = 2.0 * g_BarnLights_1._m0[_12612]._m5.x;
	                float _9059 = _14806 * g_BarnLights_1._m0[_12612]._m5.y;
	                float _17332 = 2.0 * g_BarnLights_1._m0[_12612]._m5.w;
	                float _19826 = _17332 * g_BarnLights_1._m0[_12612]._m5.z;
	                vec3 _16269 = vec3(_9059 - _19826, (1.0 - (_14806 * g_BarnLights_1._m0[_12612]._m5.x)) - _18494, (_23574 * g_BarnLights_1._m0[_12612]._m5.z) + (_17332 * g_BarnLights_1._m0[_12612]._m5.x)) * g_BarnLights_1._m0[_12612]._m6.z;
	                float _21317;
	                if (g_BarnLights_1._m0[_12612]._m3.z > 0.0)
	                {
	                    _21317 = smoothstep(0.0, 1.0, _21790 * g_BarnLights_1._m0[_12612]._m3.z);
	                }
	                else
	                {
	                    _21317 = 1.0;
	                }
	                float _19668;
	                if (g_BarnLights_1._m0[_12612]._m3.w > 0.0)
	                {
	                    _19668 = _21317 * smoothstep(0.0, 1.0, (1.0 - _21790) * g_BarnLights_1._m0[_12612]._m3.w);
	                }
	                else
	                {
	                    _19668 = _21317;
	                }
	                vec3 _11180;
	                float _11634;
	                if (g_BarnLights_1._m0[_12612]._m2.w != 0.0)
	                {
	                    vec3 _10018 = g_BarnLights_1._m0[_12612]._m2.xyz - input_8.xyz;
	                    float _18346 = dot(_10018, _10018);
	                    float _17648 = sqrt(_18346);
	                    vec3 _20959 = _10018 - _16269;
	                    vec3 _10211;
	                    do
	                    {
	                        vec3 _20230 = (_10018 + _16269) - _20959;
	                        float _25106 = dot(-_20959, _20230);
	                        if (_25106 <= 0.0)
	                        {
	                            _10211 = _20959;
	                            break;
	                        }
	                        else
	                        {
	                            _10211 = _20959 + (_20230 * min(1.0, _25106 / dot(_20230, _20230)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11180 = _10018 / vec3(_17648);
	                    _11634 = ((_19668 * (g_BarnLights_1._m0[_12612]._m2.w / max(_18346, g_BarnLights_1._m0[_12612]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12612]._m3.x + (g_BarnLights_1._m0[_12612]._m3.y * _17648))) * saturate(g_BarnLights_1._m0[_12612]._m6.x + (g_BarnLights_1._m0[_12612]._m6.y * dot(vec3((1.0 - (_23574 * g_BarnLights_1._m0[_12612]._m5.y)) - _18494, _9059 + _19826, (_14806 * g_BarnLights_1._m0[_12612]._m5.z) - (_17332 * g_BarnLights_1._m0[_12612]._m5.y)), normalize(_10211))));
	                }
	                else
	                {
	                    _11180 = g_BarnLights_1._m0[_12612]._m2.xyz;
	                    _11634 = _19668;
	                }
	                vec3 _17829 = (g_BarnLights_1._m0[_12612]._m4.xyz * 1.0).xyz * _11634;
	                bool _24421;
	                if (g_BarnLights_1._m0[_12612]._m8.z > 0.0)
	                {
	                    _24421 = !_20061;
	                }
	                else
	                {
	                    _24421 = false;
	                }
	                vec3 _21550;
	                SPIRV_CROSS_BRANCH
	                if (g_BarnLights_1._m0[_12612]._m4.w == 0.0)
	                {
	                    float _10343;
	                    do
	                    {
	                        vec2 _22155 = abs(_22906.xy);
	                        if (g_BarnLights_1._m0[_12612]._m9.z == 0.0)
	                        {
	                            _10343 = smoothstep(1.0, g_BarnLights_1._m0[_12612]._m9.x, _22155.x) * smoothstep(1.0, g_BarnLights_1._m0[_12612]._m9.y, _22155.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11474 = _22155.x;
	                            float _15268 = 2.0 / g_BarnLights_1._m0[_12612]._m9.z;
	                            float _15019 = _22155.y;
	                            float _23042 = (-0.5) * g_BarnLights_1._m0[_12612]._m9.z;
	                            float _11982 = (g_BarnLights_1._m0[_12612]._m9.x * g_BarnLights_1._m0[_12612]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12612]._m9.y * _11474, _15268) + pow(g_BarnLights_1._m0[_12612]._m9.x * _15019, _15268), 1.1754943508222875079687365372222e-38), _23042);
	                            float _16525 = pow(max(pow(_11474, _15268) + pow(_15019, _15268), 1.1754943508222875079687365372222e-38), _23042);
	                            if (_11982 < _16525)
	                            {
	                                _10343 = smoothstep(_16525, _11982, 1.0);
	                                break;
	                            }
	                            else
	                            {
	                                _10343 = float(_16525 > 1.0);
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _21550 = _17829.xyz * _10343;
	                }
	                else
	                {
	                    vec3 _12510;
	                    if (g_BarnLights_1._m0[_12612]._m4.w < 0.0)
	                    {
	                        vec4 _17796 = vec4(-g_BarnLights_1._m0[_12612]._m5.xyz, g_BarnLights_1._m0[_12612]._m5.w);
	                        vec4 _19009 = _17796.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24990 = _19009.xyz;
	                        vec3 _23630 = vec4((-_11180).xyz, 0.0).xyz;
	                        float _15161 = -dot(_23630, _24990);
	                        vec3 _20482 = vec4((_23630 * _19009.w) + cross(_23630, _24990), _15161).xyz;
	                        vec3 _23594 = _17796.xyz;
	                        vec3 _12171 = ((_20482 * g_BarnLights_1._m0[_12612]._m5.w) + (_23594 * _15161)) + cross(_23594, _20482);
	                        vec3 _14083 = vec3(vec2(atan(_12171.y, -_12171.x) * 0.15915493667125701904296875, acos(_12171.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12612]._m4.w);
	                        vec2 _20570 = (_14083.xy * g_BarnLights_1._m0[_12612]._m9.zw) + g_BarnLights_1._m0[_12612]._m9.xy;
	                        vec3 _20502 = _14083;
	                        _20502.x = _20570.x;
	                        _20502.y = _20570.y;
	                        _12510 = _17829.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20502.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13792 = vec3(fma(_22906.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12612]._m4.w);
	                        vec2 _20569 = (_13792.xy * g_BarnLights_1._m0[_12612]._m9.zw) + g_BarnLights_1._m0[_12612]._m9.xy;
	                        vec3 _20501 = _13792;
	                        _20501.x = _20569.x;
	                        _20501.y = _20569.y;
	                        _12510 = _17829.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20501.xyz, 0.0).xyz;
	                    }
	                    _21550 = _12510;
	                }
	                if (all(equal(_21550.xyz, vec3(0.0))))
	                {
	                    _12512 = _13158;
	                    break;
	                }
	                vec3 _22671;
	                if (_24421)
	                {
	                    vec3 _19630;
	                    if ((g_BarnLights_1._m0[_12612]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6282 = _22906.yx * vec2(1.0, -1.0);
	                        vec3 _23723 = _21643;
	                        _23723.x = _6282.x;
	                        _23723.y = _6282.y;
	                        _19630 = _23723;
	                    }
	                    else
	                    {
	                        _19630 = _21643;
	                    }
	                    float _24973;
	                    do
	                    {
	                        float _11456 = saturate(_19630.z + PerViewLightingConstantBufferGpu_t._m21);
	                        vec2 _14625 = vec3(fma(_19630.xy, g_BarnLights_1._m0[_12612]._m8.zw, g_BarnLights_1._m0[_12612]._m8.xy), _19630.z).xy;
	                        float _15315 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11456), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11456), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11456), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11456), 0.0)).xyzw, vec4(0.25));
	                        bool _12898;
	                        if (_15315 == 0.0)
	                        {
	                            _12898 = true;
	                        }
	                        else
	                        {
	                            _12898 = _15315 == 1.0;
	                        }
	                        if (_12898)
	                        {
	                            _24973 = _15315;
	                            break;
	                        }
	                        _24973 = ((_15315 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _11456), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _11456), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11456), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14625 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11456), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14625, _11456), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19879 = _21550.xyz * mix(1.0, _24973, g_BarnLights_1._m0[_12612]._m12);
	                    if (all(equal(_19879.xyz, vec3(0.0))))
	                    {
	                        _12512 = _13158;
	                        break;
	                    }
	                    _22671 = _19879;
	                }
	                else
	                {
	                    _22671 = _21550;
	                }
	                float _10546 = max(0.0, dot(_15116.xyz, _11180.xyz));
	                vec2 _21615 = max(_11005, vec2(g_BarnLights_1._m0[_12612]._m11));
	                vec3 _21892 = _23721.xyz;
	                vec3 _12284 = normalize(_11180.xyz + _21892).xyz;
	                vec3 _19017 = mix(_23984, _22362, bvec3(all(equal(_23984, vec3(1.0))))).xyz;
	                float _12391 = dot(_12284, _19017);
	                vec3 _22998 = _24253.xyz;
	                float _9853 = _21615.x;
	                float _25214 = _9853 * _9853;
	                float _24201 = _25214 / (((_12391 * _12391) * ((_25214 * _25214) - 1.0)) + 1.0);
	                float _16153 = _9853 + 1.0;
	                float _6839 = (_16153 * _16153) * 0.125;
	                float _19576 = 1.0 - _6839;
	                _12512 = _13158.xyz + ((((_22998 + ((vec3(1.0) - _22998) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11180.xyz, _12284))), 5.0))) * ((_24201 * _24201) / ((4.0 * ((_10546 * _19576) + _6839)) * ((max(0.0, dot(_19017, _21892)) * _19576) + _6839)))).xyz * _10546).xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13158 = _12512;
	            _16209 = _20345;
	            continue;
	        }
	        _21568 = _16208 + 1u;
	        _13155 = _13158;
	        _16208 = _21568;
	        continue;
	    }
	    float _17142 = _11005.x + _11005.y;
	    float _19584 = _17142 * _17142;
	    float _17753 = dot(_11005.xy, vec2(0.5));
	    vec3 _24389 = _23984.xyz;
	    vec3 _13689 = _23984.xyz;
	    float _10357 = PerViewLightingConstantBufferGpu_t._m15.y * sqrt(_17753);
	    float _18436 = _17753 * _17753;
	    float _20713 = saturate(1.0 - _18436);
	    vec3 _10699 = normalize(mix(_24389, reflect(_23996, _13689).xyz, vec3(_20713 * (sqrt(_20713) + _18436))));
	    vec4 _13153;
	    float _16316;
	    vec3 _17116;
	    _13153 = vec4(0.0);
	    _16316 = 0.00999999977648258209228515625;
	    _17116 = vec3(0.0);
	    uint _8899;
	    vec4 _13161;
	    vec3 _14894;
	    float _16318;
	    bool _18416;
	    uint _17028 = 0u;
	    bool _17143 = false;
	    for (;;)
	    {
	        bool _12899;
	        if (_17028 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12899 = !_17143;
	        }
	        else
	        {
	            _12899 = false;
	        }
	        if (!_12899)
	        {
	            break;
	        }
	        uint _14484 = subgroupOr(g_CullBits_1._m0[_12111 + _17028] & g_CullBits_1._m0[_23395 + _17028]);
	        vec3 _13154;
	        vec4 _16317;
	        _13154 = _17116;
	        _16317 = _13153;
	        uint _10162;
	        vec3 _13160;
	        vec4 _16384;
	        float _16482;
	        uint _17029 = _14484;
	        float _17144 = _16316;
	        for (;;)
	        {
	            if (!(_17029 != 0u))
	            {
	                _13161 = _16317;
	                _16318 = _17144;
	                _14894 = _13154;
	                _18416 = _17143;
	                break;
	            }
	            uint _18158 = uint(findLSB(_17029));
	            int _12613 = int(_18158 + (_17028 * 32u));
	            _10162 = _17029 & (_17029 - 1u);
	            vec3 _24591 = PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m0 * vec4(_7997, 1.0);
	            vec3 _7765 = _24591.xyz;
	            vec3 _8796 = saturate((_7765 - PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m1) * PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m4.xyz);
	            vec3 _19654 = saturate((PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m3 - _7765) * PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m4.xyz);
	            float _17268 = min(min(_8796.x, min(_8796.y, _8796.z)), min(_19654.x, min(_19654.y, _19654.z)));
	            if (_17268 == 0.0)
	            {
	                _13160 = _13154;
	                _16384 = _16317;
	                _16482 = _17144;
	                _13154 = _13160;
	                _16317 = _16384;
	                _17144 = _16482;
	                _17029 = _10162;
	                continue;
	            }
	            vec3 _24236 = _24591.xyz;
	            vec3 _7650 = (PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m0 * vec4(_10699.xyz, 0.0)).xyz;
	            vec3 _11255 = max(((PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m3.xyz - _24236) / _7650).xyz, ((PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m1.xyz - _24236) / _7650).xyz);
	            float _11078 = ((_17268 * _17268) * (((-2.0) * _17268) + 3.0)) * (1.0 - _17144);
	            float _13715 = _17144 + _11078;
	            vec3 _15433 = _13154 + ((textureLod(samplerCubeArray(g_tEnvironmentMap, g_sTrilinearWrap), vec4(mix(_24236 + (_7650 * abs(min(_11255.x, min(_11255.y, _11255.z)))), _7650, vec3(_17753)).xyz, float(PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m2)), _10357).xyz * PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m5) * _11078);
	            vec4 _7462 = _16317 + (PerViewLightingConstantBufferGpu_t._m16._m0[_12613]._m6 * _11078);
	            if (_13715 > 0.9900000095367431640625)
	            {
	                _13161 = _7462;
	                _16318 = _13715;
	                _14894 = _15433;
	                _18416 = true;
	                break;
	            }
	            _13160 = _15433;
	            _16384 = _7462;
	            _16482 = _13715;
	            _13154 = _13160;
	            _16317 = _16384;
	            _17144 = _16482;
	            _17029 = _10162;
	            continue;
	        }
	        _8899 = _17028 + 1u;
	        _13153 = _13161;
	        _16316 = _16318;
	        _17116 = _14894;
	        _17143 = _18416;
	        _17028 = _8899;
	        continue;
	    }
	    vec4 _11488 = textureLod(sampler2DArray(g_tBRDFLookup, g_sBilinearClamp), vec3((vec2(_17753, sqrt(1.0 - max(0.0, dot(_20869, _24389)))) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _7301 = mix(_11488.xxx, _11488.yyy, _24253);
	    float _21634 = 1.0 - _11488.y;
	    vec3 _13440 = vec3(_12893).xyz;
	    vec4 _23724 = vec4(0.0, 0.0, 0.0, 1.0);
	    _23724.x = _7811.x;
	    _23724.y = _7811.y;
	    _23724.z = _7811.z;
	    vec3 _15759 = _23724.xyz + ((_13155 * (vec3(1.0) + (_24253 * ((0.125 * (_19584 * _19584)) * saturate(dot(_23984, _23721)))))).xyz * _13440).xyz;
	    vec4 _20503 = _23724;
	    _20503.x = _15759.x;
	    _20503.y = _15759.y;
	    _20503.z = _15759.z;
	    vec3 _15733 = _20503.xyz + ((((_17116 / vec3(_16316)).xyz * min(dot(vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _20111), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _20111), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _20111)).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_13689, 1.0), (_13153 / vec4(_16316)).xyzw), max((_17753 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_7301 + (((_7301 * _15517) / (vec3(1.0) - (_15517 * _21634))) * _21634))).xyz * _13440).xyz;
	    vec4 _13888 = _20503;
	    _13888.x = _15733.x;
	    _13888.y = _15733.y;
	    _13888.z = _15733.z;
	    vec3 _13863 = _20498.xyz + ((((((_13888.xyz * mix(_22452.xyz, _20498.xyz, vec3(0.5))) * mix(_Globals_.g_flLiquidSpecularStrength, _Globals_.g_flLiquidSurfaceSpecularStrength * saturate(_8828 * 4.0), _12614)) * _21761) * _16782) * _7133) * 1.0);
	    _13888.x = _13863.x;
	    _13888.y = _13863.y;
	    _13888.z = _13863.z;
	    output_0 = _13888;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(NeedsLocalSpaceVertices, true);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	BoolAttribute(bSimpleLiquidMaterial, true);
	BoolAttribute(OpaqueRefract, F_OPAQUE_REFRACT ? 1 : 0);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
}
