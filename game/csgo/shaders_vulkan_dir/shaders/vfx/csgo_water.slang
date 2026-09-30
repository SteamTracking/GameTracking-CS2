//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Water";
	DevShader = false;
	Version = 4;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
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
	Feature( F_FRESNEL, 0..1, "Reflection" );
	Feature( F_DISABLE_REFRACTION, 0..1, "Refraction" );
	Feature( F_FLOW_NORMALS, 0..1, "Flow" );
	Feature( F_FLOW_COLOR, 0..1, "Flow" );
	Feature( F_LIGHTMAP_WATER_FOG, 0..1, "Lightmapped Water Fog" );
	Feature( F_ANIMATED_NORMALS, 0..1, "Flow" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( ChildOf( F_FLOW_COLOR, F_FLOW_NORMALS ), "Flow Color requires Flow Normals" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;             
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;    // D_COMPRESSED_NORMALS_AND_TANGENTS=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                    // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                   
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;            // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_FLOW_NORMALS, F_FLOW_NORMALS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
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
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// Normal Map
	float g_flNormalTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Normal Map"); >;
	float4 g_vExtraTexCoordScroll < UiType(VectorText); UiGroup("Normal Map"); >;
	float2 g_vNormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Normal Map"); Expression(v0 = g_flNormalTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vNormalTexCoordScale;
		v4 = this;
		-.5*v3*float2(v1-v2,v2+v1)+v4+.5); >;
	float2 g_vNormalTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Normal Map"); >;
	
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
	
	struct _1588
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    vec2 g_vNormalTexCoordScale;
	    vec2 g_vNormalTexCoordOffset;
	    vec4 g_vExtraTexCoordScroll;
	};
	
	layout(set = 0) uniform _1588 _Globals_;
	
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
	layout(location = 5) in uint nInstanceIdx;
	layout(location = 0) out vec2 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec3 output_4;
	layout(location = 5) out vec4 output_5;
	layout(location = 6) centroid out vec4 output_6;
	layout(location = 7) out vec4 output_7;
	layout(location = 8) flat out uint output_8;
	
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
	    vec3 _16000 = _12151.xyz;
	    output_0 = (vTexCoord.xy * _Globals_.g_vNormalTexCoordScale.xy).xy + _Globals_.g_vNormalTexCoordOffset.xy;
	    output_1 = vec4(((vTexCoord.x + vTexCoord.y) * 0.100000001490116119384765625) + (_Globals_.g_vExtraTexCoordScroll.x * PerViewConstantBuffer_t._m1), ((vTexCoord.y - vTexCoord.x) * 0.100000001490116119384765625) + (_Globals_.g_vExtraTexCoordScroll.y * PerViewConstantBuffer_t._m1), (vTexCoord.y * 0.449999988079071044921875) + (_Globals_.g_vExtraTexCoordScroll.z * PerViewConstantBuffer_t._m1), (vTexCoord.x * 0.449999988079071044921875) + (_Globals_.g_vExtraTexCoordScroll.w * PerViewConstantBuffer_t._m1));
	    output_2 = _16000 - PerViewConstantBuffer_t._m3.xyz;
	    output_3 = _16000 - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_4 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    output_5 = _20488;
	    output_6 = _23714;
	    output_7 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_8 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
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
	StaticCombo( S_FLOW_NORMALS, F_FLOW_NORMALS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_FRESNEL, F_FRESNEL );
	StaticCombo( S_LIGHTMAP_WATER_FOG, F_LIGHTMAP_WATER_FOG );
	StaticCombo( S_DISABLE_REFRACTION, F_DISABLE_REFRACTION );
	StaticCombo( S_ANIMATED_NORMALS, F_ANIMATED_NORMALS );
	StaticCombo( S_FLOW_COLOR, F_FLOW_COLOR );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_FLOW_COLOR ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_FRESNEL ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_LIGHTMAP_WATER_FOG ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_MODE_TOOLS_VIS ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_SHADER_QUALITY ) );
	StaticComboRule( ChildOf( S_FLOW_COLOR, S_FLOW_NORMALS ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flRefractionClipPlaneAdjust < Attribute("RefractionClipPlaneAdjust"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCubeArray g_tFallbackCubemap < Attribute("LowShaderQualityFallbackCubemap"); SrgbRead(false); >;
	Texture2D g_tFlow < Channel(RGB, Box(TextureFlow), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap3 < Attribute("debug_chart_color"); SrgbRead(false); >;
	Texture2D g_tNoise < Channel(G, Box(TextureNoise), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(AG, MipNormal(TextureNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2DArray g_tNormal < Channel(AG, MipNormal(TextureNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tRefractionMap < Attribute("FramebufferColorTexture"); SrgbRead(true); >;
	Texture2D g_tSceneDepth < Attribute("FramebufferDepthTexture"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float2 g_vRoughness < UiType(VectorText); Expression(max(.01,1-g_flGlossiness).x); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color", Default4(1, 1, 1, 0));
	
	// Flow Normals
	CreateInputTexture2D(TextureFlow, Linear, 8, "", "_flow", "Flow Normals", Default4(1, 0.5, 0, 0));
	float g_flNormalFlowLerpExp < Default(1); Range(0, 2); UiType(Slider); UiGroup("Flow Normals"); >;
	float g_flNormalFlowTimeIntervalInSeconds < Default(0.4); Range(0, 3); UiType(Slider); UiGroup("Flow Normals"); >;
	float g_flNormalFlowUvScrollDistance < Default(0.25); UiType(Slider); UiGroup("Flow Normals"); >;
	float g_flNormalUvScale < Default(1); Range(0, 1000); UiType(Slider); UiGroup("Flow Normals"); Expression(1/this); >;
	float g_flWorldPositionScale < Default(1); Range(0, 10); UiType(Slider); UiGroup("Flow Normals"); >;
	float g_flWorldUvScale < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Flow Normals"); Expression(1/this); >;
	
	// Flow Noise
	CreateInputTexture2D(TextureNoise, Linear, 8, "", "_noise", "Flow Noise", Default4(0.5, 0.5, 0.5, 0));
	float g_flNoiseStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Flow Noise"); >;
	float g_flNoiseUvScale < Default(1); Range(0, 0.5); UiStep(0.0001); UiType(Slider); UiGroup("Flow Noise"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map", Default4(0.5, 0.5, 1, 0));
	float g_flBumpStrength < Default(1); Range(0, 10); UiType(Slider); UiGroup("Normal Map"); >;
	float g_flNormalMapAnimationTimePerFrame < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Normal Map,12/10"); >;
	float g_flNormalMapAnimationTimeOffset < Range(0, 1000); UiType(Slider); UiGroup("Normal Map,12/20"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Flow Color
	float g_flColorFlowLerpExp < Default(1); Range(0, 10); UiType(Slider); UiGroup("Flow Color"); >;
	float g_flColorFlowTimeIntervalInSeconds < Default(0.4); Range(0, 3); UiType(Slider); UiGroup("Flow Color"); >;
	float g_flColorFlowUvScale < Default(1); Range(0, 10); UiType(Slider); UiGroup("Flow Color"); Expression(1/this); >;
	float g_flColorFlowUvScrollDistance < Default(0.25); UiType(Slider); UiGroup("Flow Color"); >;
	
	// Flow
	float g_flFlowTimeScale < Default(1); Range(0, 10); UiType(Slider); UiGroup("Flow"); >;
	
	// Environment Cube Map
	float g_flGlossiness < Default(1); UiType(Slider); UiGroup("Environment Cube Map"); >;
	
	// Reflections
	float g_flReflectance < Default(0.2); UiType(Slider); UiGroup("Reflections"); >;
	
	// Specular
	float g_flReflectionPower < Default(1); Range(0.01, 10); UiType(Slider); UiGroup("Specular"); >;
	float3 g_vReflectionColor < Default3(1, 1, 1); UiType(Color); UiGroup("Specular"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vReflectionDir < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Specular"); >;
	
	// Refractions
	float g_flRefractionAmount < Default(1); UiType(Slider); UiGroup("Refractions"); >;
	float g_flWaterDepth < Default(35); Range(0, 1000); UiType(Slider); UiGroup("Refractions"); >;
	float g_flWaterStart < Range(0, 1000); UiType(Slider); UiGroup("Refractions"); >;
	float3 g_vRefractionTint < Default3(1, 1, 1); UiType(Color); UiGroup("Refractions"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vWaterFogColor < Default3(0.5, 0.5, 0.5); UiType(Color); UiGroup("Refractions"); Expression(SrgbGammaToLinear(this)); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Variant parameters
	Texture2D g_tNormal < Channel(AG, MipNormal(TextureNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2DArray g_tNormal < Channel(AG, MipNormal(TextureNormal), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 4 (name: g_vRefractionTint) cannot be expressed with either HLSL packing layout or packoffset.
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
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	vec4 _4;
	vec3 _5;
	
	struct _1990
	{
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flBumpStrength;
	    vec3 g_vRefractionTint;
	    float g_flRefractionAmount;
	    vec3 g_vWaterFogColor;
	    float g_flWaterDepth;
	    float g_flWaterStart;
	    float g_flReflectance;
	    vec3 g_vReflectionDir;
	    vec3 g_vReflectionColor;
	    float g_flReflectionPower;
	    float g_flRefractionClipPlaneAdjust;
	};
	
	layout(set = 1) uniform _1990 _Globals_;
	
	struct _784
	{
	    ivec4 _m0;
	    mat4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec4 _m6;
	    vec4 _m7;
	    mat4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	};
	
	layout(set = 1) uniform _784 PerViewConstantBufferCsgo_t;
	
	struct _1239
	{
	    uvec4 _m0;
	    uvec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	};
	
	layout(set = 3) uniform _1239 PerViewLightingConstantBufferGpu_t;
	
	struct _1536
	{
	    vec4 _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    float _m4;
	    float _m5;
	    vec3 _m6;
	    vec3 _m7;
	};
	
	layout(set = 1) uniform _1536 PerViewConstantBuffer_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 1, binding = 18) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 53) uniform texture2D g_tNormal;
	layout(set = 1, binding = 27) uniform sampler DefaultSamplerState_0;
	layout(set = 1, binding = 55) uniform texture2D g_tSceneDepth;
	layout(set = 1, binding = 14) uniform sampler AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipPoint;
	layout(set = 1, binding = 41) uniform textureCubeArray g_tFallbackCubemap;
	layout(set = 1, binding = 54) uniform texture2D g_tRefractionMap;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 0) in vec2 input_0;
	layout(location = 1) in vec4 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec3 input_3;
	layout(location = 4) in vec3 input_4;
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
	        _10251 = input_4.xyz * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = input_4.xyz;
	    }
	    vec3 _10137 = input_3 + PerViewConstantBufferCsgo_t._m11.xyz;
	    vec4 _19363;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).x)
	    {
	        vec4 _18621 = vec4(_10137.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m1;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _21640;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m1.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m1.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m0.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m1.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m0.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m0.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m2.x, 0.0, PerViewLightingConstantBufferGpu_t._m2.y)) * PerViewLightingConstantBufferGpu_t._m0.z);
	    uint _17346;
	    uint _13039 = 0u;
	    for (;;)
	    {
	        if (!(_13039 < PerViewLightingConstantBufferGpu_t._m0.z))
	        {
	            break;
	        }
	        _17346 = _13039 + 1u;
	        _13039 = _17346;
	        continue;
	    }
	    vec2 _7707 = ((((texture(sampler2D(g_tNormal, DefaultSamplerState_0), input_0.xy) + texture(sampler2D(g_tNormal, DefaultSamplerState_0), input_1.xy)) + texture(sampler2D(g_tNormal, DefaultSamplerState_0), input_1.zw)) * 0.3300000131130218505859375).wy * 2.0) - vec2(1.0);
	    float _9481 = _7707.x;
	    vec3 _22101;
	    _22101.x = _9481;
	    float _21775 = _7707.y;
	    _22101.y = _21775;
	    vec3 _19529 = vec3(_9481, _21775, sqrt(saturate(1.0 - dot(_22101.xy, _22101.xy)))).xyz;
	    _19529.y = -_21775;
	    vec3 _24157 = _19529.xyz;
	    vec2 _11003 = _19529.xy * _Globals_.g_flBumpStrength;
	    _24157.x = _11003.x;
	    _24157.y = _11003.y;
	    vec3 _23712 = normalize(_24157.xyz);
	    vec3 _15878 = normalize((((vec3(1.0, 0.0, 0.0) * _23712.x).xyz + (vec3(0.0, 1.0, 0.0) * _23712.y)).xyz + (normalize(_10251).xyz * _23712.z)).xyz);
	    vec2 _21069 = _11408.xy * PerViewConstantBuffer_t._m3.xy;
	    vec2 _13706 = _21069.xy;
	    float _22133 = _10137.z;
	    vec3 _12686 = normalize(input_2.xyz).xyz;
	    float _6720 = saturate((1.0 / (_Globals_.g_flWaterDepth - _Globals_.g_flWaterStart)) * (((_22133 - _Globals_.g_flRefractionClipPlaneAdjust) - (PerViewConstantBuffer_t._m6.xyz + (_12686 * (1.0 / (((saturate((texture(sampler2D(g_tSceneDepth, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipPoint), _13706).x - PerViewConstantBuffer_t._m4) / (PerViewConstantBuffer_t._m5 - PerViewConstantBuffer_t._m4)) * PerViewConstantBuffer_t._m0.z) + PerViewConstantBuffer_t._m0.w) * dot(PerViewConstantBuffer_t._m7.xyz, _12686))))).z) + _Globals_.g_flWaterStart));
	    vec3 _17138 = normalize(_10137.xyz - PerViewConstantBuffer_t._m6.xyz);
	    vec2 _7654 = _13706 - (_15878.xy * (_Globals_.g_flRefractionAmount * _6720));
	    vec3 _4046 = texture(sampler2D(g_tRefractionMap, g_sTrilinearClamp), mix(_7654, _21069, bvec2(texture(sampler2D(g_tSceneDepth, AddressU_Clamp_AddressV_Clamp_Filter_MinMagMipPoint), _7654.xy).x < _11408.z)).xy).xyz;
	    vec3 _24093 = mix(mix(_4046, _4046 * _Globals_.g_vRefractionTint.xyz, vec3(saturate(3.5 * _6720))), _Globals_.g_vWaterFogColor, vec3(_6720)).xyz + ((textureLod(samplerCubeArray(g_tFallbackCubemap, g_sTrilinearClamp), vec4(normalize(mix(_15878, reflect(_17138.xyz, _15878.xyz).xyz, vec3(0.02231119014322757720947265625))), 0.0), PerViewLightingConstantBufferGpu_t._m3.y * 0.994987428188323974609375).xyz * saturate(2.0 * _6720)).xyz * (_Globals_.g_flReflectance * saturate((_6720 - 0.0500000007450580596923828125) * 20.0)));
	    vec4 _20488;
	    _20488.x = _24093.x;
	    _20488.y = _24093.y;
	    _20488.z = _24093.z;
	    vec3 _24094 = _20488.xyz + (_Globals_.g_vReflectionColor.xyz * pow(saturate(dot(_Globals_.g_vReflectionDir.xyz, reflect(-_17138, _15878.xyz))), _Globals_.g_flReflectionPower));
	    vec4 _20489;
	    _20489.x = _24094.x;
	    _20489.y = _24094.y;
	    _20489.z = _24094.z;
	    vec4 _13745 = vec4(saturate(_20489.xyz), 0.0);
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _10137.xyz - PerViewConstantBuffer_t._m6.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12886;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m5.x)
	            {
	                _12886 = (_22133 * PerViewConstantBufferCsgo_t._m5.z) < PerViewConstantBufferCsgo_t._m5.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12886)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m2.xy + (PerViewConstantBufferCsgo_t._m2.zw * vec2(length(_21493), _22133)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m3.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m3.y)) * PerViewConstantBufferCsgo_t._m4.w;
	                _19340 = mix(_13745.xyz, vec4(PerViewConstantBufferCsgo_t._m4.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13745.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13745;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12887;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m9.x)
	            {
	                _12887 = (PerViewConstantBufferCsgo_t._m9.z * _22133) < PerViewConstantBufferCsgo_t._m9.y;
	            }
	            else
	            {
	                _12887 = false;
	            }
	            if (_12887)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m6.y) + PerViewConstantBufferCsgo_t._m6.x), PerViewConstantBufferCsgo_t._m6.w)) * saturate(pow(max(0.0, (_22133 * PerViewConstantBufferCsgo_t._m7.y) + PerViewConstantBufferCsgo_t._m7.x), PerViewConstantBufferCsgo_t._m7.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m9.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m8 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m7.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m6.z))) * PerViewConstantBufferCsgo_t._m10.x).xyz, _8892).xyz, vec3(_8892));
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
	        _6805 = _13745;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(NeedsLightProbe, true);
	TextureAttribute(RepresentativeTexture, g_tNormal);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(bNeedsDynamicReflectionMap, false);
	BoolAttribute(bNeedsDynamicRefractionMap, false);
	BoolAttribute(mapbuilder_donotcollapse, true);
	BoolAttribute(bCsgoWater, true);
	BoolAttribute(DoNotCastShadows, true);
	FloatAttribute(flWaterDepth, g_flWaterDepth);
	FloatAttribute(flWaterStart, g_flWaterStart);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(translucent, true);
	BoolAttribute(SupportsLightmapping, true);
	Float3Attribute(LightSim_DiffuseAlbedo, 1, 1, 1);
	FloatAttribute(LightSim_Opacity_A, 1);
	
	
	// PSRS
	
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
}
