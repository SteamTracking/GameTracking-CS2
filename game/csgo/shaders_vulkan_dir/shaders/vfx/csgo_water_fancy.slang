//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Fancy Water";
	DevShader = false;
	Version = 5;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs, psrs
}

MODES
{
	CsgoForward();
	Depth(S_MODE_DEPTH);
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_REFLECTION_TYPE, 0..2 (0="Sky Color Only", 1="Environment Cube Map", 2="SSR over Environment Cube Map"), "Reflection" );
	Feature( F_REFRACTION, 0..1, "Refraction" );
	Feature( F_CAUSTICS, 0..1, "Refraction" );
	Feature( F_BLUR_REFRACTION, 0..1, "Refraction" );
	Feature( F_INTERACTION_EFFECTS, 0..1, "Interaction Effects" );
	Feature( F_TOOLS, 0..3 (0="None", 1="Show Depth", 2="Show Interaction Effects", 3="Show SSR"), "Tools" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( ChildOf( F_CAUSTICS, F_REFRACTION ), "Refraction" );
	FeatureRule( ChildOf( F_BLUR_REFRACTION, F_REFRACTION ), "Refraction" );
	FeatureRule( Requires( F_TOOLS==2, F_INTERACTION_EFFECTS ), "Interaction Effects need enabling" );
	FeatureRule( Requires( F_TOOLS==3, F_REFLECTION_TYPE==2 ), "Reflection type needs to be SSR" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;             
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;     
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;    // D_COMPRESSED_NORMALS_AND_TANGENTS=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                    // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                   
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;            // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;   
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_LIGHTMAP, D_BAKED_LIGHTING_FROM_VERTEX_STREAM ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_CS_VERTEX_ANIMATION ) );
	
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
	
	// Waves
	float g_flWaterPlaneOffset < Range(0, 20); UiType(Slider); UiGroup("Waves/Advanced"); >;
	
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
	
	struct _1340
	{
	    mat4 _m0;
	    float _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 0) uniform _1340 PerViewConstantBuffer_t;
	
	struct _1149
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    float g_flWaterPlaneOffset;
	};
	
	layout(set = 0) uniform _1149 _Globals_;
	
	struct _1074
	{
	    ivec4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _1074 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec4 vBlendColorTint;
	layout(location = 1) in vec4 vColorBlendValues;
	layout(location = 2) in vec3 vPositionOs;
	layout(location = 3) in vec2 vTexCoord;
	layout(location = 4) in vec3 vNormalOs;
	layout(location = 5) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 6) in uvec4 vBlendIndices;
	layout(location = 7) in uint nInstanceIdx;
	layout(location = 0) out vec2 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec4 output_4;
	layout(location = 5) centroid out vec4 output_5;
	layout(location = 6) out vec4 output_6;
	layout(location = 7) flat out uint output_7;
	
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
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _17940.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _7227 = vTexCoord.xyxy;
	    _7227.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _7227.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _7227.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _7227;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec3 _19648;
	    if (!notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).x)
	    {
	        vec3 _19127 = _12151.xyz;
	        vec3 _3072 = -normalize(_19127 - PerViewConstantBuffer_t._m3);
	        vec2 _8438 = ((-_3072.xy) / vec2(_3072.z)) * 0.699999988079071044921875;
	        vec3 _23691 = _19127 + (_11179.xyz * _Globals_.g_flWaterPlaneOffset);
	        vec2 _11449 = _23691.xy + ((-(normalize(_8438) * clamp(length(_8438), 0.0, 20.0))) * _Globals_.g_flWaterPlaneOffset);
	        vec3 _20489 = _23691;
	        _20489.x = _11449.x;
	        _20489.y = _11449.y;
	        _19648 = _20489;
	    }
	    else
	    {
	        _19648 = _12151;
	    }
	    vec4 _18275 = (vec4(_19648.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = vec2(_18275.zw);
	    output_1 = vColorBlendValues;
	    output_2 = _19648.xyz - PerViewConstantBufferCsgo_t._m1.xyz;
	    output_3 = _11179;
	    output_4 = _20488;
	    output_5 = vBlendColorTint;
	    output_6 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_7 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18275.y = -_18275.y;
	    gl_Position = _18275;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUI4Layer, true);
	BoolAttribute(VertexPaintUIPickColor, true);
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_REFLECTION_TYPE, F_REFLECTION_TYPE );
	StaticCombo( S_REFRACTION, F_REFRACTION );
	StaticCombo( S_CAUSTICS, F_CAUSTICS );
	StaticCombo( S_INTERACTION_EFFECTS, F_INTERACTION_EFFECTS );
	StaticCombo( S_BLUR_REFRACTION, F_BLUR_REFRACTION );
	StaticCombo( S_TOOLS, F_TOOLS );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_TOOLS==2, S_INTERACTION_EFFECTS ) );
	StaticComboRule( Requires( S_TOOLS==3, S_REFLECTION_TYPE==2 ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_REFLECTION_TYPE ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_MODE_TOOLS_VIS ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TOOLS ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY==1 ) );
	StaticComboRule( ChildOf( S_CAUSTICS, S_REFRACTION ) );
	StaticComboRule( ChildOf( S_BLUR_REFRACTION, S_REFRACTION ) );
	StaticComboRule( Requires( S_TOOLS==2, S_INTERACTION_EFFECTS ) );
	StaticComboRule( Requires( S_TOOLS==3, S_REFLECTION_TYPE==2 ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_LIGHTMAP, D_BAKED_LIGHTING_FROM_VERTEX_STREAM ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY==1 ) );
	DynamicComboRule( Allow1( S_TOOLS, D_SPECULAR_CUBE_MAP_STATIC ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_SPECULAR_CUBE_MAP_STATIC ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flForceMixResolutionScale < Attribute("ForceMixResolutionScale"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tDebris < Channel(RGB, Box(TextureDebris), Srgb); Channel(A, Box(TextureDebrisHeight), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDebrisNormal < Channel(RG, Box(TextureDebrisNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	Texture2D g_tFoam < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureFoamNormal, TextureFoam), Linear); OutputFormat(BC7); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap3 < Attribute("debug_chart_color"); SrgbRead(false); >;
	TextureCube g_tLowEndCubeMap < Channel(RGB, Box(TextureLowEndCubeMap), Srgb); OutputFormat(BC6H); SrgbRead(true); >;
	Texture2D g_tMoitFinal < Attribute("MoitFinalTex"); SrgbRead(true); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tRefractionMap < Attribute("FramebufferColorTexture"); SrgbRead(true); >;
	Texture2D g_tSceneDepth < Attribute("FramebufferDepthTexture"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	Texture2D g_tWaterEffectsMap < Attribute("WaterEffectsTexture"); SrgbRead(false); >;
	Texture2D g_tWavesNormalHeight < Channel(RG, Box(TextureWavesNormal), Linear); Channel(B, Box(TextureWavesHeight), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tZerothMoment < Attribute("zeroth_moment"); SrgbRead(true); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float2 g_vRoughness < UiType(VectorText); Expression(max(.01,1-g_flGlossiness).x); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	float4 g_vViewportExtentsTs < Attribute("ViewportExtents"); UiType(VectorText); >;
	
	// Debris
	CreateInputTexture2D(TextureDebris, Srgb, 8, "", "", "Debris", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDebrisHeight, Linear, 8, "", "", "Debris", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureDebrisNormal, Linear, 8, "", "_normal", "Debris", Default4(0.5, 0.5, 1, 0));
	float g_flDebrisEdgeSharpness < Default(10); Range(0.1, 20); UiType(Slider); UiGroup("Debris"); >;
	float g_flDebrisNormalStrength < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Debris"); >;
	float g_flDebrisOilyness < Default(0.1); UiType(Slider); UiGroup("Debris"); >;
	float g_flDebrisReflectance < Default(0.1); UiType(Slider); UiGroup("Debris"); >;
	float g_flDebrisScale < Default(1); Range(1, 400); UiType(Slider); UiGroup("Debris"); >;
	float g_flDebrisWobble < Default(1); Range(0, 8); UiType(Slider); UiGroup("Debris"); >;
	float3 g_vDebrisTint < Default3(0.7, 0.7, 0.7); UiType(Color); UiGroup("Debris"); Expression(SrgbGammaToLinear(this)); >;
	
	// Foam
	CreateInputTexture2D(TextureFoam, Srgb, 8, "Inverse", "_mask", "Foam", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureFoamNormal, Linear, 8, "NormalizeNormals", "_normal", "Foam", Default4(0.5, 0.5, 1, 0));
	float g_flFoamScale < Default(1); Range(1, 400); UiType(Slider); UiGroup("Foam"); >;
	float g_flFoamWobble < Default(1); Range(0, 8); UiType(Slider); UiGroup("Foam"); >;
	float4 g_vFoamColor < Default4(0.7, 0.7, 0.7, 1); UiType(Color); UiGroup("Foam"); Expression(SrgbGammaToLinear(this)); >;
	
	// Reflections
	CreateInputTexture2D(TextureLowEndCubeMap, Srgb, 8, "", "_cube", "Reflections", Default4(0, 0, 0, 0));
	float g_flEnvironmentMapBrightness < Default(1); Range(0, 10); UiType(Slider); UiGroup("Reflections/Cube Map"); >;
	float g_flGlossiness < Default(0.75); UiType(Slider); UiGroup("Reflections/Cube Map"); >;
	float g_flLowEndCubeMapIntensity < Default(1); Range(0, 4); UiType(Slider); UiGroup("Reflections"); >;
	float g_flReflectance < Default(0.2); UiType(Slider); UiGroup("Reflections"); >;
	float g_flReflectionDistanceEffect < Default(0.5); Range(0, 4); UiType(Slider); UiGroup("Reflections"); >;
	float g_flSSRBoost < Range(0, 200); UiType(Slider); UiGroup("Reflections/SSR"); >;
	float g_flSSRBoostThreshold < Default(1); Range(0, 2); UiType(Slider); UiGroup("Reflections/SSR"); >;
	float g_flSSRBrightness < Default(1); Range(0, 20); UiType(Slider); UiGroup("Reflections/SSR"); >;
	float g_flSSRMaxThickness < Default(4); Range(0, 20); UiType(Slider); UiGroup("Reflections/SSR"); >;
	float g_flSSRSampleJitter < Default(0.02); Range(0, 0.1); UiType(Slider); UiGroup("Reflections/SSR"); >;
	float g_flSSRStepSize < Default(0.1); UiType(Slider); UiGroup("Reflections/SSR"); >;
	int g_nSSRMaxForwardSteps < Default(20); Range(8, 200); UiType(Slider); UiGroup("Reflections/SSR"); >;
	
	// Waves
	CreateInputTexture2D(TextureWavesHeight, Linear, 8, "", "_height", "Waves/Advanced", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureWavesNormal, Linear, 8, "", "_normal", "Waves/Advanced", Default4(0.5, 0.5, 1, 0));
	float g_flEdgeHardness < Default(10); Range(0.01, 1000); UiType(Slider); UiGroup("Waves"); >;
	float g_flEdgeShapeEffect < Default(1); Range(0, 10); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flFresnelExponent < Default(5); Range(0, 50); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flHighFreqWeight < Default(0.5); UiType(Slider); UiGroup("Waves"); >;
	float g_flLowFreqWeight < Default(0.5); UiType(Slider); UiGroup("Waves"); >;
	float g_flMedFreqWeight < Default(0.5); UiType(Slider); UiGroup("Waves"); >;
	float g_flWaterInitialDirection < Default(1.5); Range(0, 6.3); UiType(Slider); UiGroup("Waves"); >;
	float g_flWaterPlaneOffset < Range(0, 20); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flWavesHeightOffset < Default(1); Range(0, 20); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flWavesNormalJitter < Default(0.1); Range(0, 2); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flWavesNormalStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flWavesPhaseOffset < Default(0.4); Range(0.3, 0.6); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flWavesSharpness < Default(0.5); Range(-2, 2); UiType(Slider); UiGroup("Waves/Advanced"); >;
	float g_flWavesSpeed < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Waves/Advanced"); >;
	int g_nWaveIterations < Default(3); Range(2, 6); UiType(Slider); UiGroup("Waves"); >;
	float2 g_vWaveScale < Default2(15, 15); Range2(5, 5, 100, 100); UiType(VectorText); UiGroup("Waves"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Caustics
	bool g_bUseTriplanarCaustics < UiType(CheckBox); UiGroup("Caustics"); >;
	float g_flCausticDepthFallOffDistance < Default(100); Range(10, 1000); UiType(Slider); UiGroup("Caustics"); >;
	float g_flCausticDistortion < Default(0.5); Range(0.3, 0.7); UiType(Slider); UiGroup("Caustics"); >;
	float g_flCausticShadowCutOff < Default(0.2); UiType(Slider); UiGroup("Caustics"); >;
	float g_flCausticSharpness < Default(0.5); UiType(Slider); UiGroup("Caustics"); >;
	float g_flCausticUVScaleMultiple < Default(2.5); Range(0.5, 10); UiType(Slider); UiGroup("Caustics"); >;
	float g_flCausticsStrength < Default(40); Range(0, 200); UiType(Slider); UiGroup("Caustics"); >;
	float4 g_vCausticsTint < Default4(0.5, 0.5, 0.5, 1); UiType(Color); UiGroup("Caustics"); >;
	
	// Vertex Paint Values
	float g_flDebrisMax < Default(1); UiType(Slider); UiGroup("Vertex Paint Values"); >;
	float g_flDebrisMin < UiType(Slider); UiGroup("Vertex Paint Values"); >;
	float g_flFoamMax < Default(1); UiType(Slider); UiGroup("Vertex Paint Values"); >;
	float g_flFoamMin < UiType(Slider); UiGroup("Vertex Paint Values"); >;
	float g_flWaterRoughnessMax < Default(1); UiType(Slider); UiGroup("Vertex Paint Values"); >;
	float g_flWaterRoughnessMin < Default(0.25); UiType(Slider); UiGroup("Vertex Paint Values"); >;
	
	// Effects
	float g_flRainStrength < Range(0, 2); UiType(Slider); UiGroup("Effects, 600,10"); >;
	
	// Refractions
	float g_flRefractChromaticSeparation < Default(0.5); UiType(Slider); UiGroup("Refractions"); >;
	float g_flRefractSampleOffset < Default(2); UiType(Slider); UiGroup("Refractions"); >;
	float g_flRefractionLimit < Default(0.1); UiType(Slider); UiGroup("Refractions"); >;
	float g_flUnderwaterDarkening < Default(0.6); UiType(Slider); UiGroup("Refractions"); >;
	float g_flWaterDecayStrength < Default(8); Range(0, 400); UiType(Slider); UiGroup("Refractions"); >;
	float g_flWaterFogShadowStrength < Default(0.5); UiType(Slider); UiGroup("Refractions"); >;
	float g_flWaterFogStrength < Default(0.5); Range(0, 80); UiType(Slider); UiGroup("Refractions"); >;
	float g_flWaterMaxDepth < Default(100); Range(0, 100); UiType(Slider); UiGroup("Refractions"); >;
	float3 g_vWaterDecayColor < Default3(1, 1, 1); UiType(Color); UiGroup("Refractions"); >;
	float3 g_vWaterFogColor < Default3(0.5, 0.5, 0.5); UiType(Color); UiGroup("Refractions"); Expression(SrgbGammaToLinear(this)); >;
	
	// Map Settings
	float g_flSkyBoxFadeRange < Default(0.05); UiType(Slider); UiGroup("Map Settings"); >;
	float g_flSkyBoxScale < Default(16); Range(0, 100); UiType(Slider); UiGroup("Map Settings"); >;
	float2 g_vMapUVMax < Default2(10241, 10241); Range2(-20000, -20000, 20000, 20000); UiType(VectorText); UiGroup("Map Settings"); >;
	float2 g_vMapUVMin < Default2(-10272, -10199); Range2(-20000, -20000, 20000, 20000); UiType(VectorText); UiGroup("Map Settings"); >;
	float3 g_vSimpleSkyReflectionColor < Default3(1, 1, 1); UiType(Color); UiGroup("Map Settings"); Expression(SrgbGammaToLinear(this)); >;
	
	// Specular
	float g_flSpecularBloomBoostStrength < Default(100); Range(0, 1000); UiType(Slider); UiGroup("Specular"); >;
	float g_flSpecularBloomBoostThreshold < Default(0.7); UiType(Slider); UiGroup("Specular"); >;
	float g_flSpecularNormalMultiple < Default(2); Range(0, 8); UiType(Slider); UiGroup("Specular"); >;
	float g_flSpecularPower < Default(300); Range(1, 1000); UiType(Slider); UiGroup("Specular"); >;
	
	// Interaction Effects
	float g_flWaterEffectCausticStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Interaction Effects, 500,50"); >;
	float g_flWaterEffectDisturbanceStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Interaction Effects, 500,50"); >;
	float g_flWaterEffectFoamStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Interaction Effects, 500,40"); >;
	float g_flWaterEffectSiltStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Interaction Effects, 500,30"); >;
	float g_flWaterEffectsRippleStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Interaction Effects, 500,20"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 8 (name: g_vMapUVMax) cannot be expressed with either HLSL packing layout or packoffset.
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
	#extension GL_EXT_samplerless_texture_functions : require
	#extension GL_KHR_shader_subgroup_arithmetic : require
	layout(early_fragment_tests) in;
	
	struct _2213
	{
	    vec4 _m0[3];
	};
	
	struct _2423
	{
	    vec4 _m0[4];
	};
	
	struct _511
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
	
	float _4;
	vec3 _5;
	vec4 _6;
	
	struct _891
	{
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flWaterPlaneOffset;
	    vec3 g_vSimpleSkyReflectionColor;
	    float g_flSkyBoxScale;
	    float g_flSkyBoxFadeRange;
	    vec2 g_vMapUVMin;
	    vec2 g_vMapUVMax;
	    float g_flWaterRoughnessMin;
	    float g_flWaterRoughnessMax;
	    float g_flFoamMin;
	    float g_flFoamMax;
	    float g_flDebrisMin;
	    float g_flDebrisMax;
	    vec3 g_vDebrisTint;
	    float g_flDebrisReflectance;
	    float g_flDebrisOilyness;
	    float g_flDebrisNormalStrength;
	    float g_flDebrisEdgeSharpness;
	    float g_flDebrisScale;
	    float g_flDebrisWobble;
	    float g_flFoamScale;
	    float g_flFoamWobble;
	    vec4 g_vFoamColor;
	    float g_flWavesHeightOffset;
	    float g_flWavesSharpness;
	    float g_flFresnelExponent;
	    float g_flWavesNormalStrength;
	    float g_flWavesNormalJitter;
	    vec2 g_vWaveScale;
	    float g_flWaterInitialDirection;
	    float g_flWavesSpeed;
	    float g_flLowFreqWeight;
	    float g_flMedFreqWeight;
	    float g_flHighFreqWeight;
	    float g_flWavesPhaseOffset;
	    float g_flEdgeShapeEffect;
	    uint g_nWaveIterations;
	    vec3 g_vWaterFogColor;
	    vec3 g_vWaterDecayColor;
	    float g_flWaterDecayStrength;
	    float g_flWaterMaxDepth;
	    float g_flWaterFogShadowStrength;
	    float g_flSpecularPower;
	    float g_flSpecularNormalMultiple;
	    float g_flSpecularBloomBoostStrength;
	    float g_flSpecularBloomBoostThreshold;
	    float g_flReflectance;
	    float g_flReflectionDistanceEffect;
	    float g_flForceMixResolutionScale;
	    float g_flRainStrength;
	};
	
	layout(set = 1) uniform _891 _Globals_;
	
	struct _2495
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    float _m3;
	    ivec2 _m4;
	    mat4 _m5;
	    vec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	    mat4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	};
	
	layout(set = 1) uniform _2495 PerViewConstantBufferCsgo_t;
	
	struct _1641
	{
	    mat4 _m0;
	    float _m1;
	    vec2 _m2;
	    vec2 _m3;
	    vec4 _m4;
	    vec3 _m5;
	    vec3 _m6;
	};
	
	layout(set = 1) uniform _1641 PerViewConstantBuffer_t;
	
	struct _1516
	{
	    _2213 _m0;
	    vec4 _m1;
	    uvec4 _m2;
	    uvec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec4 _m6;
	    int _m7;
	    float _m8;
	    vec4 _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    float _m13;
	    _511 _m14;
	    _2423 _m15;
	};
	
	layout(set = 3) uniform _1516 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 59) uniform texture2D g_tZerothMoment;
	layout(set = 1, binding = 30) uniform texture2D g_tBlueNoise;
	layout(set = 1, binding = 56) uniform texture2D g_tWavesNormalHeight;
	layout(set = 1, binding = 29) uniform sampler DefaultSamplerState_0;
	layout(set = 1, binding = 55) uniform texture2D g_tFoam;
	layout(set = 1, binding = 20) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 53) uniform texture2D g_tDebris;
	layout(set = 1, binding = 28) uniform sampler DefaultSamplerState_0_1;
	layout(set = 1, binding = 54) uniform texture2D g_tDebrisNormal;
	layout(set = 1, binding = 23) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 24) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 49) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 18) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	layout(set = 1, binding = 60) uniform texture2D g_tMoitFinal;
	
	layout(location = 1) in vec4 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec3 input_3;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    vec4 _21640 = _11408;
	    _21640.w = 1.0 / _11408.w;
	    bool _12885;
	    if (_Globals_.g_bRenderBackfaceNormals != 0)
	    {
	        _12885 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10251;
	    SPIRV_CROSS_BRANCH
	    if (_12885)
	    {
	        _10251 = input_3.xyz * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = input_3.xyz;
	    }
	    vec3 _7715 = input_2 + PerViewConstantBufferCsgo_t._m15.xyz;
	    ivec2 _11700 = ivec3(ivec2(_11408.xy * _Globals_.g_flForceMixResolutionScale), 0).xy;
	    float _21877 = exp(-texelFetch(g_tZerothMoment, _11700, 0).x);
	    float _4637 = 1.0 - _21877;
	    if (_4637 > 0.99989998340606689453125)
	    {
	        discard;
	    }
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20058 = _24464.x;
	    float _14000;
	    if (_20058)
	    {
	        _14000 = _Globals_.g_flSkyBoxScale;
	    }
	    else
	    {
	        _14000 = 1.0;
	    }
	    vec4 _19777 = texelFetch(g_tBlueNoise, ivec3(ivec2(_11408.xy) & PerViewConstantBufferCsgo_t._m4, 0).xy, 0);
	    vec3 _8199 = _7715.xyz;
	    vec3 _3980 = _8199 - PerViewConstantBuffer_t._m5;
	    vec3 _3072 = -normalize(_3980);
	    float _3558 = length(_3980) * _14000;
	    vec2 _10337 = _3072.xy;
	    float _20990 = _3072.z;
	    vec3 _11306 = mix(vec3(_10337 / vec2(_20990), sqrt(_20990)), vec3(0.0), bvec3(_20058));
	    vec2 _5201 = (-_10337) / vec2(_20990 + 0.25);
	    vec2 _19865 = (_7715.xy - _Globals_.g_vMapUVMin) / (_Globals_.g_vMapUVMax - _Globals_.g_vMapUVMin);
	    _19865.y = 1.0 - _19865.y;
	    float _24840;
	    if (_20058)
	    {
	        _24840 = _Globals_.g_flWaterRoughnessMax;
	    }
	    else
	    {
	        _24840 = max(0.0, mix(_Globals_.g_flWaterRoughnessMin, _Globals_.g_flWaterRoughnessMax, input_1.x));
	    }
	    float _7010 = _20058 ? 0.0 : max(0.0, mix(_Globals_.g_flDebrisMin, _Globals_.g_flDebrisMax, input_1.z));
	    float _13154 = _20058 ? 0.0 : max(0.0, mix(_Globals_.g_flFoamMin, _Globals_.g_flFoamMax, input_1.y));
	    vec2 _3386 = ((_8199 * _14000) + (_11306 * (0.5 - _Globals_.g_flWaterPlaneOffset))).xy * vec2(0.0333333350718021392822265625);
	    vec2 _21434 = dFdx(_3386);
	    vec2 _21118 = dFdy(_3386);
	    float _4694 = (0.5 * pow(max(dot(_21434, _21434), dot(_21118, _21118)), 0.100000001490116119384765625)) * _Globals_.g_flReflectionDistanceEffect;
	    vec2 _13136;
	    vec2 _16305;
	    vec3 _17115;
	    float _17116;
	    vec2 _17133;
	    _13136 = vec2(0.0);
	    _16305 = _Globals_.g_vWaveScale;
	    _17115 = vec3(0.0, 0.0, 1.0);
	    _17116 = 0.0;
	    _17133 = vec2(0.0);
	    float _4987;
	    vec2 _5398;
	    vec2 _6759;
	    uint _8069;
	    vec3 _8417;
	    vec2 _8974;
	    float _9798;
	    uint _17017 = 0u;
	    float _17114 = _Globals_.g_flWaterInitialDirection;
	    for (;;)
	    {
	        if (!(_17017 < _Globals_.g_nWaveIterations))
	        {
	            break;
	        }
	        float _18140 = (float(_17017) / (float(_Globals_.g_nWaveIterations) - 1.0)) * 2.0;
	        float _14126 = mix(mix(_Globals_.g_flLowFreqWeight, _Globals_.g_flMedFreqWeight, saturate(_18140)), _Globals_.g_flHighFreqWeight * _24840, saturate(_18140 - 1.0));
	        vec3 _19401 = texture(sampler2D(g_tWavesNormalHeight, DefaultSamplerState_0), ((((_3386.xy + (_13136 * 3.0)) + _17133) / _16305) + ((vec2(sin(_17114), cos(_17114)) * ((PerViewConstantBuffer_t._m1 * _Globals_.g_flWavesSpeed) * 0.5)) * sqrt(vec2(1.0) / _16305))).xy, (-1.0) * clamp(_4694, 0.0, 0.5)).xyz - vec3(0.5);
	        float _8072 = ((_19401.z * _14126) * length(_16305)) * 0.00999999977648258209228515625;
	        vec2 _9388 = _19401.xy * 2.0;
	        vec2 _10224 = vec2(_9388.x * min(1.0, _16305.y / _16305.x), _9388.y * min(1.0, _16305.x / _16305.y)).xy * (_14126 * 0.100000001490116119384765625);
	        _6759 = _13136.xy + ((((-_5201.xy) * _8072) * _Globals_.g_flWavesHeightOffset) * _24840);
	        _8974 = _17133.xy + (((_10224.xy * _Globals_.g_flWavesSharpness) * _16305) * _Globals_.g_flWavesPhaseOffset);
	        _9798 = _17116 + _8072;
	        vec2 _23792 = _17115.xy + _10224;
	        vec3 _20488;
	        _20488.x = _23792.x;
	        _8417 = _20488;
	        _8417.y = _23792.y;
	        _5398 = _16305 * _Globals_.g_flWavesPhaseOffset;
	        _8069 = _17017 + 1u;
	        _4987 = _17114 + (3.5 / float(_8069));
	        _13136 = _6759;
	        _16305 = _5398;
	        _17114 = _4987;
	        _17115 = _8417;
	        _17116 = _9798;
	        _17133 = _8974;
	        _17017 = _8069;
	        continue;
	    }
	    vec2 _9431 = mix(vec2(0.0), _17133, vec2(0.100000001490116119384765625));
	    float _11187 = _17116 * _24840;
	    float _15224 = _11187 * 60.0;
	    vec3 _8200 = _7715.xyz + (_11306 * (mix(0.5, _15224, _Globals_.g_flEdgeShapeEffect) - _Globals_.g_flWaterPlaneOffset));
	    float _9848 = _8200.x;
	    float _11979 = _8200.y;
	    float _5988 = _Globals_.g_flRainStrength * PerViewConstantBufferCsgo_t._m3;
	    vec2 _13138;
	    vec4 _13151;
	    vec3 _24633;
	    if (_5988 > 0.0)
	    {
	        float _20688 = PerViewConstantBuffer_t._m1 * 6.5;
	        vec2 _13137;
	        float _16324;
	        _13137 = vec2(0.0);
	        _16324 = 0.0;
	        int _14722;
	        float _23259;
	        vec2 _24829;
	        int _17018 = 0;
	        SPIRV_CROSS_UNROLL
	        for (;;)
	        {
	            if (!(_17018 < 2))
	            {
	                break;
	            }
	            float _11664 = float(_17018);
	            float _15378 = 0.4799999892711639404296875 * (_11664 + 0.5);
	            float _12945 = sin(_15378);
	            float _20617 = cos(_15378);
	            mat2 _23015 = mat2(vec2(_20617, -_12945), vec2(_12945, _20617));
	            float _18633 = _20688 + (_11664 * 0.3167000114917755126953125);
	            vec2 _10212 = ((_23015 * (_8200.xy * 0.119999997317790985107421875)) * (0.60000002384185791015625 + (_11664 * 0.06610000133514404296875))) + vec2(_18633 * 0.0199999995529651641845703125);
	            vec2 _10063 = _23015 * ((fract(_10212) * 2.0) - vec2(1.0));
	            float _12002 = length(_10063);
	            float _9017 = saturate(1.0 - _12002);
	            float _20212 = saturate(1.0 - (_12002 * 2.0));
	            float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	            float _7042 = _18633 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	            float _20373 = _5988 * _5988;
	            _24829 = _13137 + (((-(((normalize(_10063) * cos((_9017 * 40.0) + (PerViewConstantBuffer_t._m1 * 65.0))) * pow(_9017, 2.0)) * mix(2.0, 0.25, saturate(fwidth(_9017) * 20.0)))) * ((saturate((sin(((_9017 * 4.0) + _7042) * _5988) - (1.0 - (0.20000000298023223876953125 * _20373))) * 2.0) * _9017) / _20373)) * 2.0);
	            _23259 = _16324 + (((saturate((sin((((_20212 * 0.25) + (_7042 * 0.5)) + 4.0) * _5988) - (1.0 - (_20373 * 0.02000000141561031341552734375))) * 2.0) * _20212) / _20373) * 0.0500000007450580596923828125);
	            _14722 = _17018 + 1;
	            _13137 = _24829;
	            _16324 = _23259;
	            _17018 = _14722;
	            continue;
	        }
	        vec4 _10473;
	        _10473.z = _16324 * 400.0;
	        vec2 _24093 = _7715.xy + (_13137 * 0.5);
	        vec3 _20489 = _7715;
	        _20489.x = _24093.x;
	        _20489.y = _24093.y;
	        _13138 = _13137;
	        _13151 = _10473;
	        _24633 = _20489;
	    }
	    else
	    {
	        _13138 = vec2(0.0);
	        _13151 = vec4(0.5, 0.0, 0.0, 0.0);
	        _24633 = _7715;
	    }
	    float _4520 = (PerViewConstantBuffer_t._m1 * 3.0) + (sin(PerViewConstantBuffer_t._m1 * 0.5) * 0.100000001490116119384765625);
	    vec2 _3085 = vec2(sin(_4520 + (_11979 * 0.070000000298023223876953125)), cos(_4520 + (_9848 * 0.070000000298023223876953125)));
	    vec2 _13940 = (_24633.xyz + (_11306 * (mix(0.5, _15224, _Globals_.g_flEdgeShapeEffect * 0.5) - _Globals_.g_flWaterPlaneOffset))).xy;
	    vec2 _4842 = (_13940 / vec2(_Globals_.g_flFoamScale)) + (((_9431 * _Globals_.g_flFoamWobble) * 0.5) * (1.0 - _13154));
	    float _7424 = 0.0500000007450580596923828125 + _13151.z;
	    vec4 _19338 = texture(sampler2D(g_tFoam, g_sUserConfig), (_4842 + ((_3085 * _7424) * 0.02999999932944774627685546875)).xy);
	    vec4 _20669 = texture(sampler2D(g_tFoam, g_sUserConfig), ((_4842.yx * 0.731000006198883056640625) + ((vec2(sin(_4520 + (_11979 * 0.0599999986588954925537109375)), cos(_4520 + (_9848 * 0.0599999986588954925537109375))) * _7424) * 0.0199999995529651641845703125)).xy);
	    float _21881 = _20669.z;
	    float _12091 = _19338.z;
	    float _13724 = _19777.x;
	    float _20633 = saturate(max(_12091, _21881) + (sin(_13724) * 0.125));
	    float _16487 = saturate(_13154 * (1.0 + (_11187 * 0.480000019073486328125)));
	    float _8031 = pow(_13151.z, 1.5);
	    vec2 _17162 = ((((_13940 / vec2(_Globals_.g_flDebrisScale)) + ((_9431 * _Globals_.g_flDebrisWobble) * (1.0 - _7010))) + ((_5201.xy * ((1.0 + ((sin(_13151.z * 50.0) * 4.0) * saturate(0.100000001490116119384765625 - _8031))) * _8031)) * 0.100000001490116119384765625)) + ((_3085 * (0.100000001490116119384765625 + _13151.z)) * 0.0199999995529651641845703125)).xy;
	    vec4 _18109 = texture(sampler2D(g_tDebris, DefaultSamplerState_0_1), _17162, _8031 * 3.0);
	    float _20625 = _18109.w;
	    float _9406 = _20625 - 0.5;
	    float _3542 = _9406 * 2.0;
	    float _6806 = saturate((_20625 - (1.0 - (_7010 * saturate(1.39999997615814208984375 - (_13151.z / mix(1.0, 0.4000000059604644775390625, _20625)))))) * _Globals_.g_flDebrisEdgeSharpness);
	    float _19396 = max(0.0, (2.0 * _8031) - _3542);
	    float _4500 = saturate(1.0 - (_19396 * 10.0)) * _6806;
	    vec3 _19287 = texture(sampler2D(g_tDebrisNormal, g_sUserConfig), _17162).xyz - vec3(0.5);
	    _19287.y = -_19287.y;
	    vec2 _11003 = _19287.xy * _Globals_.g_flDebrisNormalStrength;
	    vec3 _8674;
	    _8674.x = _11003.x;
	    _8674.y = _11003.y;
	    float _12904 = saturate((((_16487 * _20633) * 0.25) + (saturate(_16487 - (1.0 - _20633)) * 0.75)) - _4500);
	    float _11140 = mix(_15224, (_11187 * 30.0) + _3542, _4500);
	    bool _10979 = !_20058;
	    vec3 _10932;
	    float _12918;
	    if (_10979)
	    {
	        vec3 _8526 = _24633.xyz + (_11306 * (mix(0.5, _11140, _Globals_.g_flEdgeShapeEffect) - _Globals_.g_flWaterPlaneOffset));
	        _10932 = _8526;
	        _12918 = max((vec4(_8526.xyz, 1.0).xyzw * PerViewConstantBuffer_t._m0).z - (PerViewConstantBuffer_t._m6.x / (PerViewConstantBuffer_t._m6.y + PerViewConstantBuffer_t._m6.z)), 0.0) * 0.00999999977648258209228515625;
	    }
	    else
	    {
	        _10932 = _8200;
	        _12918 = 1.0;
	    }
	    float _11381 = saturate(_6806 + _12904);
	    vec2 _11876 = ((((_17115 * _24840).xy * 2.0) * _Globals_.g_flWavesNormalStrength) * mix(1.0, 2.0, _4694)) * 1.0;
	    vec3 _8675;
	    _8675.x = _11876.x;
	    _8675.y = _11876.y;
	    vec2 _21285 = _8675.xy * (1.0 + (saturate(0.20000000298023223876953125 - _12918) * 8.0));
	    vec3 _8676;
	    _8676.x = _21285.x;
	    _8676.y = _21285.y;
	    vec2 _13842 = _8676.xy + ((_8674.xy * _4500) * 1.5);
	    vec3 _13831;
	    _13831.x = _13842.x;
	    _13831.y = _13842.y;
	    vec2 _24074 = _13831.xy + (mix(_19338.xy - vec2(0.5), _20669.xy - vec2(0.5), vec2(bvec2(_21881 > _12091))).xy * _12904);
	    vec3 _13832;
	    _13832.x = _24074.x;
	    _13832.y = _24074.y;
	    vec2 _24094 = _13832.xy + (_13138 * 0.5);
	    vec3 _20490;
	    _20490.x = _24094.x;
	    _20490.y = _24094.y;
	    vec2 _22768 = _20490.xy * (vec2(1.0) + (((_19777.xy - vec2(0.5)) * 2.0) * _Globals_.g_flWavesNormalJitter));
	    vec3 _23714;
	    _23714.x = _22768.x;
	    _23714.y = _22768.y;
	    vec3 _25156 = vec3(_23714.xy, sqrt(1.0 - saturate(dot(_23714.xy, _23714.xy))));
	    vec2 _8369 = _25156.xy * 3.0;
	    vec3 _3653 = vec3(_8369, sqrt(1.0 - saturate(dot(_8369, _8369))));
	    vec3 _9982;
	    vec3 _24109;
	    if (_10979)
	    {
	        float _19762 = fwidth(1.0);
	        vec3 _15760 = vec3((saturate((saturate((0.008333333767950534820556640625 - _12918) * 120.0) + saturate((0.02500000037252902984619140625 - _12918) * 8.0)) - (_19762 * 1000.0)) / (1.0 + (_3558 * 0.00200000009499490261077880859375))) * 0.60000002384185791015625);
	        _9982 = normalize(mix(_25156, vec3(0.0, 0.0, 1.0), _15760));
	        _24109 = normalize(mix(_3653, vec3(0.0, 0.0, 1.0), _15760));
	    }
	    else
	    {
	        _9982 = _25156;
	        _24109 = _3653;
	    }
	    float _16820 = pow(1.0 - saturate(dot(_3072, _24109.xyz)), _Globals_.g_flFresnelExponent);
	    vec3 _5903 = _Globals_.g_vFoamColor.xyz * (1.0 + (_12904 * 0.5));
	    float _6655 = min(_Globals_.g_flWaterMaxDepth, _12918);
	    float _9206 = (_16487 - (saturate(_13724) * 0.25)) * 0.100000001490116119384765625;
	    vec3 _5353 = mix(_Globals_.g_vWaterFogColor, _5903, vec3(_16487 * 0.100000001490116119384765625)) * exp(((_Globals_.g_vWaterDecayColor - vec3(1.0)) * vec3(_Globals_.g_flWaterDecayStrength)) * _6655);
	    float _14778 = saturate(dot(-PerViewLightingConstantBufferGpu_t._m5.xyz, reflect(-normalize(_10932.xyz - PerViewConstantBuffer_t._m5.xyz), normalize(mix(normalize(_10251).xyz, _24109.xyz, vec3(_Globals_.g_flSpecularNormalMultiple * (1.0 + (_3558 * 0.0005000000237487256526947021484375))))))));
	    float _3579 = mix(_Globals_.g_flSpecularPower, _Globals_.g_flDebrisReflectance * 8.0, _6806) * mix(2.0, 0.20000000298023223876953125, saturate(_24840));
	    float _16651 = (pow(_14778, _3579) * 0.100000001490116119384765625) + pow(_14778, _3579 * 10.0);
	    float _3039 = (saturate((1.0 - _6806) + _19396) * saturate(1.0 - (_12904 * 4.0))) * (1.0 - _9206);
	    vec3 _13711 = input_2.xyz + (((-_11306) * (vec3(_11140 * (-1.0)) + (((mix(_19777.xxx, vec3(_19777.xy, 0.0), vec3(0.100000001490116119384765625)) * 90.0) * pow(_3039, 2.0)) + vec3(_Globals_.g_flWaterPlaneOffset)))) * mix(1.0, _6655 * 2.0, 0.75));
	    vec4 _23875 = vec4(_9982.xyz, 1.0);
	    float _8634 = dot(PerViewLightingConstantBufferGpu_t._m5.xyz, _9982.xyz);
	    float _24801;
	    SPIRV_CROSS_BRANCH
	    if (_8634 > 0.0)
	    {
	        float _12504;
	        SPIRV_CROSS_BRANCH
	        if (PerViewLightingConstantBufferGpu_t._m7 != 0)
	        {
	            int _23989;
	            int _10191;
	            float _13139;
	            vec3 _14975;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < PerViewLightingConstantBufferGpu_t._m7))
	                {
	                    _13139 = 1.0;
	                    _14975 = vec3(0.0);
	                    _10191 = -1;
	                    break;
	                }
	                vec4 _18322 = vec4(_13711.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m14._m0[_13039];
	                float _12779 = _18322.x;
	                if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m9[_13039])
	                {
	                    vec3 _19470 = vec3(_12779, _18322.yz);
	                    vec2 _24805 = _19470.xy;
	                    vec2 _22193 = vec2(1.0) - saturate((abs(_24805) * vec2(PerViewLightingConstantBufferGpu_t._m11)) + vec2(PerViewLightingConstantBufferGpu_t._m10));
	                    vec2 _20561 = (_24805 * PerViewLightingConstantBufferGpu_t._m15._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m15._m0[_13039].xy;
	                    vec3 _20491 = _19470;
	                    _20491.x = _20561.x;
	                    _20491.y = _20561.y;
	                    _13139 = saturate(_22193.x * _22193.y);
	                    _14975 = _20491;
	                    _10191 = _13039;
	                    break;
	                }
	                _23989 = _13039 + 1;
	                _13039 = _23989;
	                continue;
	            }
	            float _7258;
	            if (_10191 >= 0)
	            {
	                float _18270 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m8)), 0.0);
	                float _12501;
	                SPIRV_CROSS_BRANCH
	                if (_13139 < 1.0)
	                {
	                    float _7934;
	                    if (_10191 < (PerViewLightingConstantBufferGpu_t._m7 - 1))
	                    {
	                        int _15335 = _10191 + 1;
	                        vec4 _19672 = vec4(_13711.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m14._m0[_15335];
	                        vec2 _20562 = (_19672.xy * PerViewLightingConstantBufferGpu_t._m15._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m15._m0[_15335].xy;
	                        vec3 _20492;
	                        _20492.x = _20562.x;
	                        _20492.y = _20562.y;
	                        _7934 = textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20492.xy, saturate(_19672.z + PerViewLightingConstantBufferGpu_t._m8)), 0.0);
	                    }
	                    else
	                    {
	                        _7934 = 1.0;
	                    }
	                    _12501 = mix(_7934, _18270, _13139);
	                }
	                else
	                {
	                    _12501 = _18270;
	                }
	                _7258 = _12501;
	            }
	            else
	            {
	                _7258 = 1.0;
	            }
	            float _15295 = mix(_7258, 1.0, saturate((distance(_24633.xyz, PerViewConstantBuffer_t._m5) * PerViewLightingConstantBufferGpu_t._m13) + PerViewLightingConstantBufferGpu_t._m12));
	            float _12503;
	            if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).y)
	            {
	                _12503 = min(_15295, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_21640.xy * PerViewConstantBuffer_t._m4.xy).xy, 0.0).z);
	            }
	            else
	            {
	                _12503 = _15295;
	            }
	            _12504 = _12503;
	        }
	        else
	        {
	            _12504 = 1.0;
	        }
	        _24801 = _12504;
	    }
	    else
	    {
	        _24801 = 1.0;
	    }
	    float _15858 = mix(_24801, 1.0, _3039 * 0.5);
	    vec3 _21709;
	    if ((_8634 * _15858) > 0.0)
	    {
	        _21709 = PerViewLightingConstantBufferGpu_t._m1.xyz + (vec3(max(0.0, dot(_9982.xyz, PerViewLightingConstantBufferGpu_t._m5.xyz))).xyz * (PerViewLightingConstantBufferGpu_t._m6.xyz * _15858).xyz);
	    }
	    else
	    {
	        _21709 = PerViewLightingConstantBufferGpu_t._m1.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20061 = _24465.x;
	    vec4 _19363;
	    if (_20061)
	    {
	        vec4 _18621 = vec4(_24633.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m5;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m3.x) * 0.5, 0.0, PerViewConstantBuffer_t._m3.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m3.y) * 0.5, 0.0, PerViewConstantBuffer_t._m3.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _21640;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m2.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m3.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m2.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m3.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m2.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m2.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m4.x, 0.0, PerViewLightingConstantBufferGpu_t._m4.y)) * PerViewLightingConstantBufferGpu_t._m2.z);
	    vec3 _13155;
	    _13155 = _21709;
	    uint _21567;
	    vec3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t._m2.z))
	        {
	            break;
	        }
	        uint _14476 = subgroupOr(g_CullBits_1._m0[_10838 + _16208] & g_CullBits_1._m0[_23393 + _16208]);
	        _13156 = _13155;
	        uint _20344;
	        vec3 _12506;
	        uint _16209 = _14476;
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_16209)) + (_16208 * 32u));
	            _20344 = _16209 & (_16209 - 1u);
	            do
	            {
	                vec3 _14644 = _13711.xyz;
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(_13711.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21783 = _10521.z;
	                _22905.z = _21783;
	                vec3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7425 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12886;
	                if (!_7425)
	                {
	                    _12886 = true;
	                }
	                else
	                {
	                    _12886 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(_14644, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12886)
	                {
	                    _12506 = _13156;
	                    break;
	                }
	                float _23571 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19826 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19826, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23571 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = min(1.0, _21783 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21783) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - _14644;
	                    float _18345 = dot(_10017, _10017);
	                    float _17648 = sqrt(_18345);
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
	                    _11179 = _10017 / vec3(_17648);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * saturate(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17648))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23571 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19826, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
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
	                    _24419 = !_20061;
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
	                    vec3 _12505;
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
	                        vec3 _20494 = _14081;
	                        _20494.x = _20564.x;
	                        _20494.y = _20564.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20494.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20493 = _13791;
	                        _20493.x = _20563.x;
	                        _20493.y = _20563.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20493.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12505;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _12506 = _13156;
	                    break;
	                }
	                vec3 _19630;
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m8)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _12506 = _13156;
	                        break;
	                    }
	                    _19630 = _20482;
	                }
	                else
	                {
	                    _19630 = _21548;
	                }
	                _12506 = _13156.xyz + (vec3(max(0.0, dot(_9982.xyz, _11179.xyz))).xyz * _19630.xyz);
	                break;
	            } while(false);
	            _13156 = _12506;
	            _16209 = _20344;
	            continue;
	        }
	        _21567 = _16208 + 1u;
	        _13155 = _13156;
	        _16208 = _21567;
	        continue;
	    }
	    vec3 _20780 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _22686 = (_13155.xyz + _20780) * mix(mix((_5353 * _9206) * _Globals_.g_flWaterFogShadowStrength, _5903.xyz, vec3(_12904)), vec4(_18109.xyz * (0.5 + (_4500 * 0.5)), _6806).xyz * _Globals_.g_vDebrisTint, vec3(saturate(_6806 - _19396))).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, _4);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _25191 = mix(_11203.xyz, vec3(0.0), vec3(_3039));
	    vec4 _17842 = _11203;
	    _17842.x = _25191.x;
	    _17842.y = _25191.y;
	    _17842.z = _25191.z;
	    vec3 _10929 = mix(_17842.xyz, (_5353 * 4.0) * _20780, vec3((_9206 * saturate((1.0 - _11381) + _19396)) * (1.0 - _Globals_.g_flWaterFogShadowStrength)));
	    vec4 _17843 = _17842;
	    _17843.x = _10929.x;
	    _17843.y = _10929.y;
	    _17843.z = _10929.z;
	    float _24165 = mix(_Globals_.g_flReflectance, _Globals_.g_flDebrisReflectance, _4500);
	    float _4658 = (((_16820 * (1.0 - _24165)) + _24165) * ((1.0 - (_11381 * 0.75)) - (_12904 * 2.0))) * 1.5;
	    vec3 _20158 = _17843.xyz + (((_13155.xyz * ((_16651 + (max(0.0, _16651 - (1.0 - _Globals_.g_flSpecularBloomBoostThreshold)) * _Globals_.g_flSpecularBloomBoostStrength)) * mix(1.0, _Globals_.g_flDebrisReflectance * 0.0500000007450580596923828125, _6806))) * _4658) * PerViewLightingConstantBufferGpu_t._m6.xyz);
	    float _22128 = fract(((_16820 * 20.0) + (_9406 * 8.0)) + (PerViewConstantBuffer_t._m1 * 0.100000001490116119384765625)) * 6.0;
	    float _17518 = floor(_22128);
	    float _17939 = _22128 - _17518;
	    float _9493 = 0.75 * (1.0 - _17939);
	    float _14751 = 0.75 * _17939;
	    vec3 _21710;
	    if (_17518 == 0.0)
	    {
	        _21710 = vec3(0.75, _14751, 0.0);
	    }
	    else
	    {
	        vec3 _12511;
	        if (_17518 == 1.0)
	        {
	            _12511 = vec3(_9493, 0.75, 0.0);
	        }
	        else
	        {
	            vec3 _12510;
	            if (_17518 == 2.0)
	            {
	                _12510 = vec3(0.0, 0.75, _14751);
	            }
	            else
	            {
	                vec3 _12509;
	                if (_17518 == 3.0)
	                {
	                    _12509 = vec3(0.0, _9493, 0.75);
	                }
	                else
	                {
	                    vec3 _12508;
	                    if (_17518 == 4.0)
	                    {
	                        _12508 = vec3(_14751, 0.0, 0.75);
	                    }
	                    else
	                    {
	                        _12508 = vec3(0.75, 0.0, _9493);
	                    }
	                    _12509 = _12508;
	                }
	                _12510 = _12509;
	            }
	            _12511 = _12510;
	        }
	        _21710 = _12511;
	    }
	    _17843.x = _20158.x;
	    _17843.y = _20158.y;
	    _17843.z = _20158.z;
	    vec3 _19800 = mix(_17843.xyz, mix(_Globals_.g_vSimpleSkyReflectionColor, _Globals_.g_vSimpleSkyReflectionColor * _21710, vec3(((saturate(_19396 * 20.0) * _Globals_.g_flDebrisOilyness) / (1.0 + (_3558 * 0.004999999888241291046142578125))) * saturate(1.0 - (_20990 * 5.0)))), vec3(saturate(_4658)));
	    vec4 _17844 = _17843;
	    _17844.x = _19800.x;
	    _17844.y = _19800.y;
	    _17844.z = _19800.z;
	    vec4 _22302;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _23187 = _24633.xyz - PerViewConstantBuffer_t._m5.xyz;
	        vec3 _9057 = _23187.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _23187.xyz;
	            bool _12887;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m9.x)
	            {
	                _12887 = (_24633.z * PerViewConstantBufferCsgo_t._m9.z) < PerViewConstantBufferCsgo_t._m9.y;
	            }
	            else
	            {
	                _12887 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12887)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m6.xy + (PerViewConstantBufferCsgo_t._m6.zw * vec2(length(_21493), _24633.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m7.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m7.y)) * PerViewConstantBufferCsgo_t._m8.w;
	                _19340 = mix(_17844.xyz, vec4(PerViewConstantBufferCsgo_t._m8.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _17844.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _17844;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12888;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m13.x)
	            {
	                _12888 = (PerViewConstantBufferCsgo_t._m13.z * _24633.z) < PerViewConstantBufferCsgo_t._m13.y;
	            }
	            else
	            {
	                _12888 = false;
	            }
	            if (_12888)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m10.y) + PerViewConstantBufferCsgo_t._m10.x), PerViewConstantBufferCsgo_t._m10.w)) * saturate(pow(max(0.0, (_24633.z * PerViewConstantBufferCsgo_t._m11.y) + PerViewConstantBufferCsgo_t._m11.x), PerViewConstantBufferCsgo_t._m11.z));
	                float _8894 = saturate(_14602) * PerViewConstantBufferCsgo_t._m13.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m12 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m11.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m10.z))) * PerViewConstantBufferCsgo_t._m14.x).xyz, _8894).xyz, vec3(_8894));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _22302 = _23944;
	    }
	    else
	    {
	        _22302 = _17844;
	    }
	    vec4 _10386 = _22302;
	    _10386.w = 1.0;
	    if (_10979)
	    {
	        vec2 _3206 = abs(vec2(0.5) - _19865) * 2.0;
	        if ((saturate(1.0 - saturate((max(_3206.x, _3206.y) - (1.0 - _Globals_.g_flSkyBoxFadeRange)) / _Globals_.g_flSkyBoxFadeRange)) - _13724) < 0.0)
	        {
	            discard;
	        }
	    }
	    vec4 _6805;
	    if (_4637 > 0.0)
	    {
	        vec4 _3300 = texelFetch(g_tMoitFinal, _11700, 0);
	        vec3 _8598 = _3300.xyz * (_4637 / (_3300.w + 9.9999997473787516355514526367188e-06));
	        vec4 _8677;
	        _8677.x = _8598.x;
	        _8677.y = _8598.y;
	        _8677.z = _8598.z;
	        _6805 = vec4(_8677.xyz + (_10386.xyz * _21877), 1.0);
	    }
	    else
	    {
	        _6805 = _10386;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(NeedsLightProbe, true);
	TextureAttribute(RepresentativeTexture, g_tWavesNormalHeight);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(bNeedsDynamicReflectionMap, false);
	BoolAttribute(bDisableDynamicRefractionMap, false);
	BoolAttribute(mapbuilder_donotcollapse, true);
	BoolAttribute(bCsgoWater, true);
	BoolAttribute(DoNotCastShadows, true);
	BoolAttribute(environmentmapped, (F_REFLECTION_TYPE>0) ? 1 : 0);
	BoolAttribute(environmentmappeddynamic, (F_REFLECTION_TYPE>0) ? 1 : 0);
	BoolAttribute(bReflectDynamicObjectsOnly, false);
	BoolAttribute(translucent, true);
	BoolAttribute(SupportsLightmapping, true);
	Float3Attribute(LightSim_DiffuseAlbedo, 1, 1, 1);
	FloatAttribute(LightSim_Opacity_A, 1);
	
	
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
