//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Textile layer for csgo_customglove compositing layer.";
	DevShader = false;
	Version = 3;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs, psrs
}

MODES
{
	CsgoForward();
	Depth("csgo_depth_only.vfx");
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_ANISOTROPIC_GLOSS, 0..1, "PBR" );
	Feature( F_CLOTH_SHADING, 0..1, "PBR" );
	Feature( F_BACKWARDS_COMPATIBILITY, 0..1 (0="Source1 Texture Layout", 1="Source2 Height Blending"), "" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_ANISOTROPIC_GLOSS, F_BACKWARDS_COMPATIBILITY==0 ), "Anisotropic Gloss is on by default in Source2 Height Blending Mode" );
	FeatureRule( Requires( F_CLOTH_SHADING, F_BACKWARDS_COMPATIBILITY==0 ), "Anisotropic Gloss is on by default in Source2 Height Blending Mode" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vDamageTexCoordXform0 < UiType(VectorText); Expression(v0 = g_fDamageTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,0,.5+g_vDamageTexCoordOffset.x+v2*.5-v1*.5)); >;
	float4 g_vDamageTexCoordXform1 < UiType(VectorText); Expression(v0 = g_fDamageTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2,v1,0,.5+g_vDamageTexCoordOffset.y-(v2*.5+v1*.5))); >;
	float4 g_vGrimeTexCoordXform0 < UiType(VectorText); Expression(v0 = g_fGrimeTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,0,.5+g_vGrimeTexCoordOffset.x+v2*.5-v1*.5)); >;
	float4 g_vGrimeTexCoordXform1 < UiType(VectorText); Expression(v0 = g_fGrimeTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2,v1,0,.5+g_vGrimeTexCoordOffset.y-(v2*.5+v1*.5))); >;
	
	// Composite Inputs
	float g_fDamageTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Wear/10"); >;
	float2 g_vDamageTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Wear/11"); >;
	float g_fGrimeTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Wear/20"); >;
	float2 g_vGrimeTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Wear/21"); >;
	
	// Material1
	float2 g_vUvScale1 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material1,1/Texcoord Transform,0/0"); >;
	
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
	    float2 _Globals_1_g_vUvScale1 : packoffset(c1.z);
	    float4 _Globals_1_g_vDamageTexCoordXform0 : packoffset(c7);
	    float4 _Globals_1_g_vDamageTexCoordXform1 : packoffset(c8);
	    float4 _Globals_1_g_vGrimeTexCoordXform0 : packoffset(c9);
	    float4 _Globals_1_g_vGrimeTexCoordXform1 : packoffset(c10);
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
	static float3 output_4;
	static float4 output_5;
	static uint output_6;
	static float4 output_7;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	    float3 vNormalOs : NORMAL0;
	    float4 vTangentUOs_flTangentVSign : TANGENT0;
	    uint4 vBlendIndices : BLENDINDICES0;
	    uint nInstanceIdx : TEXCOORD13;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    centroid float4 output_3 : TEXCOORD3;
	    centroid float3 output_4 : TEXCOORD4;
	    float4 output_5 : TEXCOORD5;
	    nointerpolation uint output_6 : TEXCOORD6;
	    float4 output_7 : TEXCOORD7;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _13771 = (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4);
	    }
	    float3x4 _12618 = float3x4(g_transformBuffer.Load<float4>(_21785 * 48 + 0), g_transformBuffer.Load<float4>(_21785 * 48 + 16), g_transformBuffer.Load<float4>(_21785 * 48 + 32));
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        float3x4 _25207 = float3x4(g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 32));
	        _21709 = _25207[0].z.xxx;
	    }
	    else
	    {
	        _21709 = 1.0f.xxx;
	    }
	    float4 _23812 = float4(uint4(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 255u, (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
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
	    float4 _20063 = float4(_21354, _21355, _17978, _7654);
	    _20063.w = _7654 * g_instanceBuffer.Load<float>(nInstanceIdx * 32 + 28);
	    float3 _11179 = normalize(mul(_12618, float4(vNormalOs.xyz, 0.0f)));
	    float3 _12151 = mul(_12618, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _18237 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _9360 = vTexCoord.xyxy;
	    float2 _13062 = vTexCoord.xy * _Globals_1_g_vUvScale1.xy;
	    _9360.z = _13062.x;
	    _9360.w = _13062.y;
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = _11179;
	    output_2 = _9360;
	    output_3 = _20063;
	    output_4 = _11179;
	    output_5 = float4(normalize(mul(_12618, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_6 = g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 20) & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	    output_7 = float4(dot(_9360.xy, _Globals_1_g_vDamageTexCoordXform0.xy) + _Globals_1_g_vDamageTexCoordXform0.w, dot(_9360.xy, _Globals_1_g_vDamageTexCoordXform1.xy) + _Globals_1_g_vDamageTexCoordXform1.w, dot(_9360.xy, _Globals_1_g_vGrimeTexCoordXform0.xy) + _Globals_1_g_vGrimeTexCoordXform0.w, dot(_9360.xy, _Globals_1_g_vGrimeTexCoordXform1.xy) + _Globals_1_g_vGrimeTexCoordXform1.w);
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
	    stage_output.output_6 = output_6;
	    stage_output.output_7 = output_7;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	StringAttribute(MaterialLayerType, csgo_textile_layer);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	
}

PS
{
	StaticCombo( S_BACKWARDS_COMPATIBILITY, F_BACKWARDS_COMPATIBILITY );
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Requires( S_ANISOTROPIC_GLOSS, S_BACKWARDS_COMPATIBILITY==0 ) );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bClothShading < UiType(CheckBox); Expression(F_CLOTH_SHADING || F_BACKWARDS_COMPATIBILITY); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	float g_fDetailBlackPointCompensation1 < UiType(Slider); Expression(1-g_fDetailBlackPoint1); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_mDamageColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint1,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast1,g_fDamageBevelColorSaturation1,g_fDamageBevelColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint1,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast1,g_fBurnishingColorSaturation1,g_fBurnishingColorBrightness1),TextureAverageColor(g_tSubstrate1)))); >;
	float4x4 g_mSubstrateColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint1,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast1,g_fSubstrateColorSaturation1,g_fSubstrateColorBrightness1),TextureAverageColor(g_tSubstrate1)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint1,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast1,g_fBurnishingColorSaturation1,g_fBurnishingColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mSurfaceColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint1,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast1,g_fSurfaceColorSaturation1,g_fSurfaceColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tDamage1 < Channel(R, Box(TextureDamageHeight1), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamageNormal1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDamageNormal1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDetail1 < Channel(RGBA, Box(TextureDetail1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailNormal1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDetailNormal1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tGrime1 < Channel(RGB, ArtistDefined(TextureGrime1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrunge1 < Channel(RGBA, Box(TextureGrunge1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2D g_tNoise < Channel(RGBA, Box(TextureNoise), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureObjectNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tObjectProperties < Channel(R, Box(TextureObjectAmbientOcclusion), Linear); Channel(G, Box(TextureObjectCurvature), Linear); Channel(B, Box(TextureObjectHighTouchMask), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	Texture2D g_tSubstrate1 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo1), Srgb); Channel(A, Box(TextureSubstrateTintMask1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrateNormal1 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal1, TextureSubstrateRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties1 < Channel(R, Box3(TextureSubstrateAmbientOcclusion1), Linear); Channel(G, Box(TextureSubstrateMetalness1), Linear); Channel(B, Box(TextureSubstrateClothMask1), Linear); Channel(A, Box(TextureSubstrateHeight1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurface < Channel(RGBA, Box(TextureSurfaceProperties), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurface1 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo1), Srgb); Channel(A, Box(TextureSurfaceTintMask1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurfaceNormal1 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal1, TextureSurfaceRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties1 < Channel(R, Box3(TextureSurfaceAmbientOcclusion1), Linear); Channel(G, Box(TextureSurfaceMetalness1), Linear); Channel(B, Box(TextureSurfaceClothMask1), Linear); Channel(A, Box(TextureSurfaceHeight1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vGrungeTexCoordXform0 < UiType(VectorText); Expression(v0 = g_fGrungeTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_fGrungeTexCoordScale;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v1*v3,-v2*v3,0,v3*v1*v7+v3*-v2*v8+(g_fGrungeTexCoordOffset.x-.5))); >;
	float4 g_vGrungeTexCoordXform1 < UiType(VectorText); Expression(v0 = g_fGrungeTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_fGrungeTexCoordScale;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v2*v3,v1*v3,0,v3*v2*v7+v3*v1*v8+(g_fGrungeTexCoordOffset.y-.5))); >;
	float4 g_vGrungeTexRotationXform0 < UiType(VectorText); Expression(v0 = -g_fGrungeTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = 1;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v1*v3,-v2*v3,0,v3*v1*v7+v3*-v2*v8+(0-.5))); >;
	float4 g_vGrungeTexRotationXform1 < UiType(VectorText); Expression(v0 = -g_fGrungeTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = 1;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v2*v3,v1*v3,0,v3*v2*v7+v3*v1*v8+(0-.5))); >;
	float3 g_vMetallicTextileAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.08,.6,1.08).x,-1.4427*log(max(.0001,1-float3(-.08,.6,1.08).y)),2-float3(-.08,.6,1.08).z)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	float3 g_vTextileAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.045,.6,1).x,-1.4427*log(max(.0001,1-float3(-.045,.6,1).y)),2-float3(-.045,.6,1).z)); >;
	
	// Material1
	CreateInputTexture2D(TextureDamageHeight1, Linear, 8, "Inverse", "_height", "Material1/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureDetail1, Linear, 8, "", "_detail", "Material1,1/Detail/1", Default4(0.5, 0.5, 1, 1));
	CreateInputTexture2D(TextureGrime1, Srgb, 8, "", "_color", "Material1/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo1, Srgb, 8, "", "_color", "Material1/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo1, Srgb, 8, "", "_color", "Material1/Surface Layer,1/1", Default4(1, 1, 1, 0));
	float2 g_vDamageLevels1 < Default2(0, 1); UiType(VectorText); UiGroup("Material1,1/Detail Damage/1"); >;
	CreateInputTexture2D(TextureSubstrateTintMask1, Linear, 8, "", "_tintmask", "Material1/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask1, Linear, 8, "", "_tintmask", "Material1/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fCurvaturePower1 < Default(1); Range(0.5, 6); UiType(Slider); UiGroup("Material1/Detail Damage/2"); >;
	float g_fDamageUvScale1 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material1/Damage Height/2"); >;
	float g_fGrimeUvScale1 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material1/Grime/2"); >;
	float g_fCurvatureWearBoost1 < UiType(Slider); UiGroup("Material1/Detail Damage/3"); >;
	float g_fGrimeTranslucency1 < Default(0.5); UiType(Slider); UiGroup("Material1/Grime/3"); >;
	float g_fDetailBlackPoint1 < Default(0.047); Range(0, 0.2); UiType(Slider); UiGroup("Material1/Detail/5"); >;
	float g_fGrimeRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Grime/5"); >;
	float3 g_vSubstrateColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Surface Layer/5"); >;
	float g_fDamageSaturation1 < Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail Damage/6"); >;
	float g_fSubstrateColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Surface Layer/6"); >;
	float g_fDamageBrightness1 < Range(-1, 3); UiType(Slider); UiGroup("Material1/Detail Damage/7"); >;
	float g_fSubstrateColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Surface Layer/7"); >;
	float g_fDamageBleaching1 < UiType(Slider); UiGroup("Material1/Detail Damage/8"); >;
	float g_fSubstrateColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Surface Layer/8"); >;
	CreateInputTexture2D(TextureDetailNormal1, Linear, 8, "", "_detailnormal", "Material1/Normal/10", Default4(0.5, 0.5, 0.5, 0.5));
	CreateInputTexture2D(TextureGrunge1, Linear, 8, "", "_grunge", "Material1/Grunge/10", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageMetalness1 < UiType(Slider); UiGroup("Material1/Detail Damage/10"); >;
	float2 g_vSurfaceGrimeMinMax1 < Default2(0, 1); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material1/Grime/10"); >;
	CreateInputTexture2D(TextureDamageNormal1, Linear, 8, "", "_damagenormal", "Material1/Normal/11", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageCloth1 < UiType(Slider); UiGroup("Material1/Detail Damage/11"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageHeightBlendSoftness1 < Default(0.01); UiType(Slider); UiGroup("Material1/Damage Height/11"); Expression(max(this,.001)); >;
	float g_fDetailGrunge1 < Range(0, 2); UiType(Slider); UiGroup("Material1/Grunge/11"); >;
	float g_fDetailScale1 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material1/Detail/11"); >;
	float2 g_vSubstrateGrimeMinMax1 < Default2(0, 1); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material1/Grime/11"); >;
	float g_fDetailNormalContrast1 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material1/Normal/12"); >;
	float g_fDetailRoughnessContrast1 < Range(-1, 1); UiType(Slider); UiGroup("Material1/Detail/12"); >;
	float2 g_vDamageMinMax1 < Default2(0, 1); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material1/Damage Height/12"); >;
	float g_fDetailRoughnessBrightness1 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material1/Detail/13"); >;
	float g_fWearBleaching1 < Default(0.25); Range(0, 3); UiType(Slider); UiGroup("Material1/Wear Edge/13"); >;
	float g_fDetailAnisotropyScalar1 < Range(-1, 1); UiType(Slider); UiGroup("Material1/Detail/14"); >;
	float g_fDetailMetalness1 < UiType(Slider); UiGroup("Material1/Detail/15"); >;
	float g_fDetailCloth1 < UiType(Slider); UiGroup("Material1/Detail/16"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fBurnishingGrime1 < Default(0.5); UiType(Slider); UiGroup("Material1/Grime/20"); >;
	float3 g_vBurnishingColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Burnishing/21"); >;
	float g_fDamageBevelColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Damage Bevel/21"); >;
	float g_fGrungeMax1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Grunge/21"); >;
	float g_fSubstrateCompositeColorTranslucency1 < Default(0.5); UiType(Slider); UiGroup("Material1/Substrate Layer/21"); >;
	float g_fBurnishingColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Damage Bevel/22"); >;
	float g_fGrungeRoughnessBrightness1 < Default(0.8); Range(0, 10); UiType(Slider); UiGroup("Material1/Grunge/22"); >;
	float g_fBurnishingColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask1 < UiType(CheckBox); UiGroup("Material1/Damage Bevel/24"); >;
	float g_fBurnishingCloth1 < UiType(Slider); UiGroup("Material1/Burnishing/25"); >;
	float g_fBurnishingMetalness1 < UiType(Slider); UiGroup("Material1/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale1 < Default(1); UiType(Slider); UiGroup("Material1/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness1 < Default(0.5); UiType(Slider); UiGroup("Material1/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness1,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Damage Bevel/31"); >;
	float g_fDamageRoughnessContrast1 < Range(-1, 1); UiType(Slider); UiGroup("Material1/Detail Damage/31"); >;
	float g_fGrimeSaturation1 < Range(-2, 2); UiType(Slider); UiGroup("Material1/Grunge/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Surface Layer/32", Default4(1, 1, 1, 0));
	float g_fDamageRoughnessBrightness1 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material1/Detail Damage/32"); >;
	float g_fGrimeBrightness1 < Range(-1, 3); UiType(Slider); UiGroup("Material1/Grunge/32"); >;
	float g_fSurfaceBurnishingRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	CreateInputTexture2D(TextureSubstrateHeight1, Linear, 8, "", "_height", "Material1/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight1, Linear, 8, "", "_height", "Material1/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	float g_fSubstrateBurnishingRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	CreateInputTexture2D(TextureSubstrateMetalness1, Srgb, 8, "", "_metal", "Material1/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness1, Linear, 8, "", "_metal", "Material1/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax1 < Default2(0, 1); UiType(VectorText); UiGroup("Material1/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask1, Srgb, 8, "", "_mask", "Material1/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask1, Linear, 8, "", "_mask", "Material1/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy1 < UiType(Slider); UiGroup("Material1/Damage Bevel/41"); >;
	float g_fDamageNormalEdgeWidth1 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material1,1/Wear Edge/41"); >;
	float2 g_vSubstrateBurnishingMinMax1 < Default2(0, 1); UiType(VectorText); UiGroup("Material1/Burnishing/41"); >;
	float g_fDamageEdgeRoughness1 < Default(0.8); UiType(Slider); UiGroup("Material1/Wear Edge/42"); >;
	float g_fDamageEdgeMetalness1 < UiType(Slider); UiGroup("Material1/Wear Edge/43"); >;
	float g_fDamageBevelMetalness1 < UiType(Slider); UiGroup("Material1/Damage Bevel/50"); >;
	float g_fDamageBevelCloth1 < UiType(Slider); UiGroup("Material1/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate1 < UiType(CheckBox); UiGroup("Material1/Damage Bevel/80"); >;
	
	// Composite Inputs
	CreateInputTexture2D(TextureObjectNormal, Linear, 8, "", "_normal", "Composite Inputs,0/Object Textures,1/0", Default4(0.5, 0.5, 1, 0));
	float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/Wear/0"); Expression(SrgbLinearToGamma(this)); >;
	CreateInputTexture2D(TextureNormal, Linear, 8, "", "_normal", "Composite Inputs/1", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureObjectAmbientOcclusion, Linear, 8, "", "_ao", "Composite Inputs/Object Textures/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceProperties, Linear, 8, "", "_ao", "Composite Inputs/1", Default4(0.5, 1, 0, 0.5));
	CreateInputTexture2D(TextureObjectCurvature, Linear, 8, "", "_curvature", "Composite Inputs/Object Textures/2", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureObjectHighTouchMask, Linear, 8, "", "_mask", "Composite Inputs/Object Textures/3", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureNoise, Linear, 8, "", "", "Composite Inputs/8", "materials/default/gloves/textiles/noise.psd");
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Composite Inputs,100/11"); >;
	float g_flSheenScale < Default(0.667); Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/Lighting,1000/12"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fGrungeTexCoordScale < Default(2.5); Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/13"); >;
	float g_fGrungeTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/14"); >;
	float2 g_fGrungeTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/15"); >;
	float g_fWearExponent < Default(1); UiType(Slider); UiGroup("Composite Inputs/49"); >;
	float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/50"); Expression(pow(this,g_fWearExponent)); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_BACKWARDS_COMPATIBILITY == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureObjectNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
		float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/Wear/0"); Expression(SrgbLinearToGamma(this)); >;
	#endif
	#if (S_ANISOTROPIC_GLOSS == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
		float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/50"); Expression(pow(this,g_fWearExponent)); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 3 (name: g_vTextileAlbedoLevels) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	const vec2 _790[4] = vec2[](vec2(-1.0), vec2(-1.0, 1.0), vec2(1.0), vec2(1.0, -1.0));
	
	struct _2158
	{
	    vec4 _m0[3];
	};
	
	struct _2368
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
	
	struct _2946
	{
	    _1677 _m0[128];
	};
	
	struct _1988
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
	
	vec3 _3;
	vec4 _4;
	
	struct _257
	{
	    int g_bClothShading;
	    int g_bFogEnabled;
	    float g_flReflectance;
	    vec3 g_vTextileAlbedoLevels;
	    vec3 g_vMetallicTextileAlbedoLevels;
	    vec4 g_vGrungeTexCoordXform0;
	    vec4 g_vGrungeTexCoordXform1;
	    vec4 g_vGrungeTexRotationXform0;
	    vec4 g_vGrungeTexRotationXform1;
	    float g_fWearProgress;
	    float g_fDetailBlackPoint1;
	    float g_fDetailBlackPointCompensation1;
	    float g_fDetailScale1;
	    float g_fDetailRoughnessContrast1;
	    float g_fDetailRoughnessBrightness1;
	    float g_fDetailMetalness1;
	    float g_fDetailCloth1;
	    float g_fDetailNormalContrast1;
	    vec2 g_vDamageLevels1;
	    float g_fDamageRoughnessContrast1;
	    float g_fDamageRoughnessBrightness1;
	    float g_fDamageSaturation1;
	    float g_fDamageBrightness1;
	    float g_fDamageMetalness1;
	    float g_fDamageCloth1;
	    float g_fDamageBleaching1;
	    float g_fCurvaturePower1;
	    float g_fCurvatureWearBoost1;
	    float g_fDamageNormalEdgeWidth1;
	    float g_fDamageEdgeRoughness1;
	    float g_fDamageEdgeMetalness1;
	    float g_fDetailGrunge1;
	    float g_fGrungeMax1;
	    float g_fGrungeRoughnessBrightness1;
	    float g_fWearBleaching1;
	    float g_fGrimeSaturation1;
	    float g_fGrimeBrightness1;
	    vec3 g_vColorTint;
	    float g_flSheenScale;
	};
	
	layout(set = 1) uniform _257 _Globals_;
	
	struct _2806
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    ivec4 _m3;
	    mat4 _m4;
	    vec2 _m5;
	    float _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	    vec4 _m12;
	    mat4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	    vec4 _m16;
	};
	
	layout(set = 1) uniform _2806 PerViewConstantBufferCsgo_t;
	
	struct _832
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    _2158 _m5;
	    _2368 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    uvec4 _m10;
	    uvec4 _m11;
	    uvec4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    _2946 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    int _m18;
	    float _m19;
	    vec4 _m20;
	    float _m21;
	    float _m22;
	    float _m23;
	    float _m24;
	    _1988 _m25;
	    _2368 _m26;
	};
	
	layout(set = 3) uniform _832 PerViewLightingConstantBufferGpu_t;
	
	struct _1194
	{
	    vec2 _m0;
	    vec2 _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 1) uniform _1194 PerViewConstantBuffer_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 51) uniform texture2D g_tSurface;
	layout(set = 1, binding = 14) uniform sampler g_sAniso;
	layout(set = 1, binding = 54) uniform texture2D g_tDetail1;
	layout(set = 1, binding = 57) uniform texture2D g_tGrunge1;
	layout(set = 1, binding = 53) uniform texture2D g_tNoise;
	layout(set = 1, binding = 52) uniform texture2D g_tNormal;
	layout(set = 1, binding = 55) uniform texture2D g_tDetailNormal1;
	layout(set = 1, binding = 56) uniform texture2D g_tDamageNormal1;
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 23) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 19) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 39) uniform texture2D g_tSsao;
	layout(set = 1, binding = 20) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 24) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 49) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 18) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 40) uniform textureCubeArray g_tEnvironmentMap;
	layout(set = 1, binding = 16) uniform sampler g_sBilinearClamp;
	layout(set = 1, binding = 35) uniform texture2DArray g_tBRDFLookup;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec4 input_2;
	layout(location = 3) centroid in vec4 input_3;
	layout(location = 4) centroid in vec3 input_4;
	layout(location = 5) in vec4 input_5;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    float _6864 = 1.0 / _11408.w;
	    vec4 _18180 = _11408;
	    _18180.w = _6864;
	    vec3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
	    vec3 _20700 = normalize(_21709);
	    vec3 _10829 = input_0 + PerViewConstantBufferCsgo_t._m16.xyz;
	    vec4 _18992 = texture(sampler2D(g_tSurface, g_sAniso), input_2.xy);
	    float _17263 = _18992.x;
	    float _14422 = pow(_17263, _Globals_.g_fCurvaturePower1);
	    float _19695 = _18992.y;
	    float _24805 = _18992.z;
	    vec2 _22630 = (input_2.xy * _Globals_.g_fDetailScale1).xy;
	    vec4 _19414 = texture(sampler2D(g_tDetail1, g_sAniso), _22630);
	    vec2 _7424 = vec2(_Globals_.g_fDetailBlackPoint1) + (_19414.xy * _Globals_.g_fDetailBlackPointCompensation1);
	    float _17962 = _7424.x;
	    float _9591 = _7424.y;
	    float _23185 = _19414.z;
	    float _24139 = 1.0 - _19414.w;
	    float _17411 = 1.0 - _17962;
	    vec2 _15902 = vec2(dot(input_2.xy, _Globals_.g_vGrungeTexCoordXform0.xy) + _Globals_.g_vGrungeTexCoordXform0.w, dot(input_2.xy, _Globals_.g_vGrungeTexCoordXform1.xy) + _Globals_.g_vGrungeTexCoordXform1.w).xy;
	    vec4 _19334 = texture(sampler2D(g_tGrunge1, g_sAniso), _15902);
	    vec3 _13748 = _19334.xyz;
	    float _17907 = dot(_13748, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec4 _22452 = texture(sampler2D(g_tNoise, g_sAniso), (input_2.xy * 2.0).xy);
	    vec4 _19372 = texture(sampler2D(g_tNormal, g_sAniso), input_2.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11176 = _16000 - _19720;
	    vec3 _17934 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    vec4 _19373 = texture(sampler2D(g_tDetailNormal1, g_sAniso), _22630);
	    float _16001 = _19373.x;
	    float _19721 = _19373.y;
	    float _16784 = (_16001 + _19721) - 1.00392162799835205078125;
	    float _11177 = _16001 - _19721;
	    vec4 _19374 = texture(sampler2D(g_tDamageNormal1, g_sAniso), _22630);
	    float _16002 = _19374.x;
	    float _19722 = _19374.y;
	    float _16785 = (_16002 + _19722) - 1.00392162799835205078125;
	    float _11178 = _16002 - _19722;
	    vec3 _24030 = _Globals_.g_vColorTint.xyz * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((_Globals_.g_vColorTint.xyz * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (_Globals_.g_vColorTint.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _24030.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_Globals_.g_vColorTint.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _24030.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19114;
	    if (_Globals_.g_vColorTint.z <= 0.040449999272823333740234375)
	    {
	        _19114 = _24030.z;
	    }
	    else
	    {
	        _19114 = _7676.z;
	    }
	    vec3 _18585 = vec3(_21354, _21355, _19114);
	    float _21912 = _14422 * _18992.w;
	    float _20765 = _Globals_.g_fCurvatureWearBoost1 * _14422;
	    float _12034 = saturate((_21912 * _19334.w) + _20765);
	    float _19034 = smoothstep(_Globals_.g_vDamageLevels1.x, _Globals_.g_vDamageLevels1.y, _12034 * _Globals_.g_fWearProgress);
	    float _9410 = 1.0 - _19034;
	    float _14100 = saturate(_19034 + ((saturate(smoothstep(_Globals_.g_vDamageLevels1.x, _Globals_.g_vDamageLevels1.y, _12034 * (_Globals_.g_fWearProgress * 4.0))) * _9410) * _23185));
	    vec3 _23388 = _18585.xyz;
	    float _17583 = dot(_23388, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _11002 = _9591 * _14422;
	    float _16103 = _17962 * _14422;
	    float _22514 = (_17263 + _19695) + _24805;
	    vec3 _18056 = max(_18585, _18585 * (1.0 + (_14422 * 0.5)));
	    float _19227 = min(1.0, mix(_9591, _17962, _14100) + ((mix(((1.0 - abs(dFdx(_11002))) * (1.0 - abs(dFdy(_11002)))) * saturate(abs(dFdx(_11002)) + abs(dFdy(_11002))), ((1.0 - abs(dFdx(_16103))) * (1.0 - abs(dFdy(_16103)))) * saturate(abs(dFdx(_16103)) + abs(dFdy(_16103))), _19034) * (1.0 - saturate(abs(dFdx(_22514))))) * (1.0 - saturate(abs(dFdy(_22514))))));
	    float _9287 = dot(vec4(_19227).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(_18056.xyz, vec3(0.001000000047497451305389404296875)));
	    vec3 _12861 = saturate((_9577 * min(_9287 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _9287) * max(_18056.x, max(_18056.y, _18056.z)))).xyz);
	    float _15624 = mix(((_Globals_.g_fWearProgress * _24805) * _Globals_.g_fWearBleaching1) * _23185, _Globals_.g_fDamageBleaching1, _19034);
	    vec3 _10558;
	    do
	    {
	        if (_Globals_.g_fGrimeSaturation1 > 0.0)
	        {
	            vec3 _22572 = normalize(_13748 * _17907).xyz - vec3(0.57700002193450927734375);
	            vec3 _7057 = saturate((normalize(_22572) * 2.0) + vec3(1.0)).xyz;
	            vec3 _15712 = _7057 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	            _10558 = mix(_13748, _7057 * (_17907 / ((_15712.x + _15712.y) + _15712.z)), vec3(saturate(_Globals_.g_fGrimeSaturation1 * pow(abs(dot(_22572, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _10558 = mix(_13748, vec3(_17907), vec3(-_Globals_.g_fGrimeSaturation1));
	            break;
	        }
	        break; // unreachable workaround
	    } while(false);
	    vec3 _23869 = (_12861 * _13748) * 2.0;
	    vec3 _16559 = mix(mix(_12861, _23869, vec3((_Globals_.g_fDetailGrunge1 * (1.0 + (_Globals_.g_fWearProgress * _Globals_.g_fDetailGrunge1))) * _9410)), (_10558 * (1.0 + _Globals_.g_fGrimeBrightness1)) * _19227, vec3(_15624));
	    vec3 _9452 = _16559.xyz;
	    vec3 _10559;
	    do
	    {
	        if (_Globals_.g_fDamageSaturation1 > 0.0)
	        {
	            vec3 _22573 = normalize(_23388 * dot(_18585.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))).xyz - vec3(0.57700002193450927734375);
	            vec3 _7058 = saturate((normalize(_22573) * 2.0) + vec3(1.0)).xyz;
	            vec3 _15713 = _7058 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	            _10559 = mix(_9452, _7058 * (dot(_9452, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / ((_15713.x + _15713.y) + _15713.z)), vec3(saturate(_Globals_.g_fDamageSaturation1 * pow(abs(dot(_22573, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _10559 = mix(_9452, vec3(dot(_16559.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(-_Globals_.g_fDamageSaturation1));
	            break;
	        }
	        break; // unreachable workaround
	    } while(false);
	    vec3 _19489 = vec3(_19034);
	    vec3 _6932 = mix(_16559, _10559 * (1.0 + _Globals_.g_fDamageBrightness1), _19489);
	    vec3 _12529 = mix(_6932, _13748 * _6932, vec3((smoothstep(0.449999988079071044921875, 0.75, (1.0 - ((_17263 * _19695) * _19695)) * _Globals_.g_fWearProgress) * (1.0 - (_17583 * 0.5))) * _Globals_.g_fGrungeMax1));
	    float _15036 = dot(_12529.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 0.5;
	    bool _12885;
	    if (_12529.x > _12529.y)
	    {
	        _12885 = _12529.x > _12529.z;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10970;
	    vec3 _12555;
	    if (_12885)
	    {
	        _10970 = vec3(0.60000002384185791015625, 1.0, 0.0) + _12529.zxy;
	        _12555 = vec3(0.20000000298023223876953125, 0.60000002384185791015625, 1.0) + _12529.zyx;
	    }
	    else
	    {
	        bool _12886;
	        if (_12529.y > _12529.x)
	        {
	            _12886 = _12529.y > _12529.z;
	        }
	        else
	        {
	            _12886 = false;
	        }
	        vec3 _13212;
	        vec3 _15670;
	        if (_12886)
	        {
	            _13212 = vec3(0.60000002384185791015625, 1.0, 0.0) + _12529.zxy;
	            _15670 = vec3(0.20000000298023223876953125, 0.60000002384185791015625, 1.0) + _12529.yzx;
	        }
	        else
	        {
	            _13212 = vec3(0.60000002384185791015625, 1.0, 0.0);
	            _15670 = vec3(0.20000000298023223876953125, 0.60000002384185791015625, 1.0);
	        }
	        _10970 = _13212;
	        _12555 = _15670;
	    }
	    bool _21112;
	    float _6982 = (pow(1.0 - _17583, 3.5) * 0.300000011920928955078125) + ((length(_12529 - vec3(_15036)) * 0.1500000059604644775390625) + 0.0500000007450580596923828125);
	    float _22476 = pow(_19695, 8.0);
	    vec3 _11286;
	    do
	    {
	        _21112 = _6982 > 0.0;
	        if (_21112)
	        {
	            vec3 _22574 = normalize(_12555.xyz * dot(_12555.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))).xyz - vec3(0.57700002193450927734375);
	            vec3 _7059 = saturate((normalize(_22574) * 2.0) + vec3(1.0)).xyz;
	            vec3 _15714 = _7059 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	            _11286 = mix(_12529.xyz, _7059 * (_15036 / ((_15714.x + _15714.y) + _15714.z)), vec3(saturate(_6982 * pow(abs(dot(_22574, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _11286 = mix(_12529.xyz, vec3(dot(_12529.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(-_6982));
	            break;
	        }
	        break; // unreachable workaround
	    } while(false);
	    vec3 _16611;
	    do
	    {
	        if (_21112)
	        {
	            vec3 _22575 = normalize(_10970.xyz * dot(_10970.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))).xyz - vec3(0.57700002193450927734375);
	            vec3 _7060 = saturate((normalize(_22575) * 2.0) + vec3(1.0)).xyz;
	            vec3 _15715 = _7060 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	            _16611 = mix(_12529.xyz, _7060 * (_15036 / ((_15715.x + _15715.y) + _15715.z)), vec3(saturate(_6982 * pow(abs(dot(_22575, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _16611 = mix(_12529.xyz, vec3(dot(_12529.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(-_6982));
	            break;
	        }
	        break; // unreachable workaround
	    } while(false);
	    vec3 _17278 = saturate(mix(mix(_11286, _16611, vec3(saturate(_22476 * _22452.x))), _12529, vec3(saturate(_22452.z * (0.5 + (_22476 * 0.5))))));
	    vec2 _13136;
	    float _16324;
	    _13136 = vec2(0.0);
	    _16324 = 0.0;
	    vec2 _10648;
	    float _14733;
	    int _18386;
	    int _17017 = 0;
	    for (;;)
	    {
	        if (!(_17017 < 4))
	        {
	            break;
	        }
	        float _24694 = _19034 - smoothstep(_Globals_.g_vDamageLevels1.x, _Globals_.g_vDamageLevels1.y, saturate((texture(sampler2D(g_tGrunge1, g_sAniso), (_15902 + (((_790[_17017] * 0.0009765625) * _Globals_.g_fDamageNormalEdgeWidth1) * 2.0)).xy).w * _21912) + _20765) * _Globals_.g_fWearProgress);
	        _10648 = _13136.xy - (_790[_17017] * _24694);
	        _14733 = _16324 + abs(_24694);
	        _18386 = _17017 + 1;
	        _13136 = _10648;
	        _16324 = _14733;
	        _17017 = _18386;
	        continue;
	    }
	    float _7827 = _16324 * 0.25;
	    vec2 _11392 = _13136.xy * (_Globals_.g_fDamageNormalEdgeWidth1 * 0.25);
	    vec3 _14827 = mix(normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))), normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))), _19489);
	    vec2 _22606 = _14827.xy * _Globals_.g_fDetailNormalContrast1;
	    vec3 _8673;
	    _8673.x = _22606.x;
	    _8673.y = _22606.y;
	    vec3 _10041 = normalize(vec3((_17934.xy + _8673.xy) - vec2(-dot(_11392, _Globals_.g_vGrungeTexRotationXform0.xy), dot(_11392, _Globals_.g_vGrungeTexRotationXform1.xy)), _17934.z));
	    float _19526 = mix(mix(_Globals_.g_fDetailMetalness1, _Globals_.g_fDamageMetalness1, _19034), _Globals_.g_fDamageEdgeMetalness1, _7827);
	    float _12929 = 1.0 - _19526;
	    float _11543 = mix(_Globals_.g_fDetailCloth1, _Globals_.g_fDamageCloth1, max(_14100, _7827)) * _12929;
	    vec3 _7958 = normalize(max(vec3(0.0003000000142492353916168212890625), _17278.xyz));
	    vec3 _21191 = vec3(_19526);
	    vec3 _23898 = mix(_Globals_.g_vTextileAlbedoLevels.xyz, _Globals_.g_vMetallicTextileAlbedoLevels.xyz, _21191);
	    vec3 _9936 = input_1.xyz * 1.0;
	    vec3 _14435 = cross(_9936.xyz, input_5.xyz) * ((input_5.w > 0.0) ? 1.0 : (-1.0));
	    vec3 _20195;
	    if (notEqual(PerViewConstantBufferCsgo_t._m3, ivec4(0)).w)
	    {
	        _20195 = -_14435;
	    }
	    else
	    {
	        _20195 = _14435;
	    }
	    vec3 _14995 = normalize((((input_5.xyz * _10041.x).xyz + (_20195.xyz * (-_10041.y))).xyz + (_9936.xyz * _10041.z)).xyz);
	    vec3 _11121 = mix(_17278.xyz, ((_7958.xyz * mix(min(_23898.x, dot(mix(_12861, _23869, vec3(_Globals_.g_fDetailGrunge1)).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _23898.z, saturate(pow(max(_17278.x, max(_17278.y, _17278.z)), _23898.y)))) / vec3(max(_7958.x, max(_7958.y, _7958.z)))).xyz, vec3(_Globals_.g_fWearProgress)).xyz;
	    vec3 _8357 = vec3(_Globals_.g_flReflectance);
	    bool _14874 = _Globals_.g_bClothShading != 0;
	    vec3 _18402;
	    SPIRV_CROSS_BRANCH
	    if (_14874)
	    {
	        _18402 = mix(_8357.xyz, saturate(sqrt(_11121) * _Globals_.g_flSheenScale), vec3(_11543));
	    }
	    else
	    {
	        _18402 = _8357;
	    }
	    vec3 _17639 = mix(_18402.xyz, _11121, _21191);
	    vec3 _17892 = mix(vec3(1.0), _14995, bvec3(all(bvec3(true))));
	    vec3 _10560 = _20700.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _11004 = max(mix(mix(vec2(1.0) * mix(saturate(((_Globals_.g_fDetailRoughnessContrast1 * (((_24139 * _24139) * 0.85000002384185791015625) + (-0.3499999940395355224609375))) + 0.5) * _Globals_.g_fDetailRoughnessBrightness1), (1.0 - _17907) + _Globals_.g_fGrungeRoughnessBrightness1, _15624), vec2(saturate(((_Globals_.g_fDamageRoughnessContrast1 * (((_17411 * _17411) * 0.85000002384185791015625) + (-0.3499999940395355224609375))) + 0.5) * _Globals_.g_fDamageRoughnessBrightness1)), vec2(_19034)).xy, vec2(_Globals_.g_fDamageEdgeRoughness1), vec2(_7827)).xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _10170 = -_20700;
	    vec3 _24735 = _14995.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    vec3 _18708 = vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _23875));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    float _21710;
	    if (_24465.x)
	    {
	        vec3 _11394 = _20700.xyz;
	        vec2 _10548 = ((floor(_18180.xy * PerViewConstantBufferCsgo_t._m6) * PerViewConstantBufferCsgo_t._m5.xy) + (PerViewConstantBufferCsgo_t._m5.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10548).xyzw - _18180.zzzz;
	        float _18579 = _18418.w;
	        float _12014 = _18418.z;
	        bool _12285 = abs(_12014) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m5.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12014 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12286)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m5.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m7.x * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.y * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.z * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.w * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21710 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_13232, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10548 + mix(_23169, PerViewConstantBufferCsgo_t._m5.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    float _21711;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).w)
	    {
	        _21711 = _21710 * textureLod(sampler2D(g_tSsao, g_sUserConfig), (_18180.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21711 = _21710;
	    }
	    float _8634 = dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _24735);
	    float _12320;
	    SPIRV_CROSS_BRANCH
	    if (_8634 > 0.0)
	    {
	        float _12504;
	        SPIRV_CROSS_BRANCH
	        if (PerViewLightingConstantBufferGpu_t._m18 != 0)
	        {
	            int _23989;
	            int _10191;
	            float _13137;
	            vec3 _14975;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < PerViewLightingConstantBufferGpu_t._m18))
	                {
	                    _13137 = 1.0;
	                    _14975 = vec3(0.0);
	                    _10191 = -1;
	                    break;
	                }
	                vec4 _18322 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_13039];
	                float _12779 = _18322.x;
	                if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m20[_13039])
	                {
	                    vec3 _19470 = vec3(_12779, _18322.yz);
	                    vec2 _24804 = _19470.xy;
	                    vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m22)) + vec2(PerViewLightingConstantBufferGpu_t._m21));
	                    vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m26._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_13039].xy;
	                    vec3 _20488 = _19470;
	                    _20488.x = _20561.x;
	                    _20488.y = _20561.y;
	                    _13137 = saturate(_22193.x * _22193.y);
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
	                vec2 _7045;
	                vec2 _7046;
	                vec2 _7735;
	                float _8969;
	                float _8970;
	                float _15996;
	                float _17299;
	                vec2 _18870;
	                vec4 _20581;
	                vec4 _22024;
	                float _23727;
	                do
	                {
	                    float _21452 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m19);
	                    _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                    _22024 = PerViewLightingConstantBufferGpu_t._m1;
	                    _17299 = PerViewLightingConstantBufferGpu_t._m2.z;
	                    _15996 = PerViewLightingConstantBufferGpu_t._m3.z;
	                    _18870 = vec2(_17299, _15996);
	                    _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                    _7045 = vec2(_8969, _15996);
	                    _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                    _7046 = vec2(_17299, _8970);
	                    _7735 = vec2(_8969, _8970);
	                    float _15310 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _18870).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7045).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7046).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7735).xy, _21452), 0.0)).xyzw, vec4(0.25));
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
	                    _23727 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_17299, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_8969, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _8970)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _15996)).xy, _21452), 0.0)).xyzw, _22024.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, _21452), 0.0) * _22024.y);
	                    break;
	                } while(false);
	                float _12502;
	                SPIRV_CROSS_BRANCH
	                if (_13137 < 1.0)
	                {
	                    float _7934;
	                    if (_10191 < (PerViewLightingConstantBufferGpu_t._m18 - 1))
	                    {
	                        int _15335 = _10191 + 1;
	                        vec4 _19671 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_15335];
	                        vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m26._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_15335].xy;
	                        vec3 _20489;
	                        _20489.x = _20562.x;
	                        _20489.y = _20562.y;
	                        float _12501;
	                        do
	                        {
	                            float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m19);
	                            float _15311 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _18870).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7045).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7046).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7735).xy, _20322), 0.0)).xyzw, vec4(0.25));
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
	                            _12501 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(_17299, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(_8969, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(0.0, _8970)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(0.0, _15996)).xy, _20322), 0.0)).xyzw, _22024.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20489.xy, _20322), 0.0) * _22024.y);
	                            break;
	                        } while(false);
	                        _7934 = _12501;
	                    }
	                    else
	                    {
	                        _7934 = 1.0;
	                    }
	                    _12502 = mix(_7934, _23727, _13137);
	                }
	                else
	                {
	                    _12502 = _23727;
	                }
	                _19363 = _12502;
	            }
	            else
	            {
	                _19363 = 1.0;
	            }
	            float _13279 = mix(_19363, 1.0, saturate((distance(_10829.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m24) + PerViewLightingConstantBufferGpu_t._m23));
	            float _12503;
	            if (_24465.y)
	            {
	                _12503 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_18180.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	            }
	            else
	            {
	                _12503 = _13279;
	            }
	            _12504 = _12503;
	        }
	        else
	        {
	            _12504 = 1.0;
	        }
	        _12320 = _12504;
	    }
	    else
	    {
	        _12320 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    SPIRV_CROSS_BRANCH
	    if ((_8634 * _12320) > 0.0)
	    {
	        float _11797 = max(0.0, dot(_14995.xyz, PerViewLightingConstantBufferGpu_t._m16.xyz));
	        vec2 _9840 = max(_11004, vec2(PerViewLightingConstantBufferGpu_t._m16.w));
	        vec3 _21889 = (-normalize(_10829.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz;
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m16.xyz + _21889).xyz;
	        vec3 _19012 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz;
	        float _12386 = dot(_12281, _19012);
	        float _25073 = max(0.0, dot(_19012, _21889));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19096 = _12386 * _12386;
	        float _24198 = _25211 / ((_19096 * ((_25211 * _25211) - 1.0)) + 1.0);
	        float _16150 = _9850 + 1.0;
	        float _6835 = (_16150 * _16150) * 0.125;
	        float _19569 = 1.0 - _6835;
	        float _21624 = (_24198 * _24198) / ((4.0 * ((_11797 * _19569) + _6835)) * ((_25073 * _19569) + _6835));
	        float _11621;
	        SPIRV_CROSS_BRANCH
	        if (_14874)
	        {
	            float _6597 = dot(_9840.xy, vec2(0.5));
	            float _20791 = max(_6597 * _6597, 9.9999997473787516355514526367188e-06);
	            float _21401 = saturate(_25073 + 0.001000000047497451305389404296875);
	            _11621 = mix(_21624, ((((2.0 + (1.0 / _20791)) * pow(1.0 - _19096, 0.5 / _20791)) / ((_11797 + _21401) - (_11797 * _21401))) * 0.124999918043613433837890625) * _11797, _11543);
	        }
	        else
	        {
	            _11621 = _21624;
	        }
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m17.xyz * _12320).xyz;
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz + (vec3(_11797).xyz * _16808);
	        _24878 = (((_17639.xyz + ((vec3(1.0) - _17639.xyz) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _12281))), 5.0))) * _11621).xyz * _11797).xyz * _16808;
	    }
	    else
	    {
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz;
	        _24878 = vec3(0.0);
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20061 = _24467.x;
	    vec4 _19364;
	    if (_20061)
	    {
	        vec4 _18621 = vec4(_10829.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m4;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _18180;
	    }
	    uvec2 _7663 = uvec2(PerViewLightingConstantBufferGpu_t._m12.x);
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m0.xy) >> _7663;
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m10.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m12.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13138;
	    vec3 _16325;
	    _13138 = _9716;
	    _16325 = _24878;
	    uint _21567;
	    vec3 _13139;
	    vec3 _16326;
	    uint _17018 = 0u;
	    for (;;)
	    {
	        if (!(_17018 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17018] & g_CullBits_1._m0[_23393 + _17018]);
	        _13139 = _16325;
	        _16326 = _13138;
	        uint _20344;
	        vec3 _13213;
	        vec3 _15671;
	        uint _17019 = _14475;
	        for (;;)
	        {
	            if (!(_17019 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_17019)) + (_17018 * 32u));
	            _20344 = _17019 & (_17019 - 1u);
	            do
	            {
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_0.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
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
	                bool _12889;
	                if (!_7425)
	                {
	                    _12889 = true;
	                }
	                else
	                {
	                    _12889 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_0.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12889)
	                {
	                    _13213 = _13139;
	                    _15671 = _16326;
	                    break;
	                }
	                float _23571 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9059 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9059 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23571 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = smoothstep(0.0, 1.0, _21776 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21776) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_0.xyz;
	                    float _18348 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18348);
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
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18348, g_BarnLights_1._m0[_12608]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23571 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9059 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
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
	                        vec3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20491.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20490.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12505;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13213 = _13139;
	                    _15671 = _16326;
	                    break;
	                }
	                vec3 _22671;
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
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m19);
	                        vec2 _14617 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0)).xyzw, vec4(0.25));
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
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14617 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14617, _11455), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _13213 = _13139;
	                        _15671 = _16326;
	                        break;
	                    }
	                    _22671 = _19878;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                float _11798 = max(0.0, dot(_14995.xyz, _11179.xyz));
	                vec2 _9841 = max(_11004, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _21890 = (-normalize(_10829.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz;
	                vec3 _12282 = normalize(_11179.xyz + _21890).xyz;
	                vec3 _19014 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz;
	                float _12387 = dot(_12282, _19014);
	                float _25074 = max(0.0, dot(_19014, _21890));
	                float _9851 = _9841.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _12387 * _12387;
	                float _24199 = _25212 / ((_19097 * ((_25212 * _25212) - 1.0)) + 1.0);
	                float _16151 = _9851 + 1.0;
	                float _6836 = (_16151 * _16151) * 0.125;
	                float _19571 = 1.0 - _6836;
	                float _21625 = (_24199 * _24199) / ((4.0 * ((_11798 * _19571) + _6836)) * ((_25074 * _19571) + _6836));
	                float _11622;
	                SPIRV_CROSS_BRANCH
	                if (_14874)
	                {
	                    float _6598 = dot(_9841.xy, vec2(0.5));
	                    float _20792 = max(_6598 * _6598, 9.9999997473787516355514526367188e-06);
	                    float _21402 = saturate(_25074 + 0.001000000047497451305389404296875);
	                    _11622 = mix(_21625, ((((2.0 + (1.0 / _20792)) * pow(1.0 - _19097, 0.5 / _20792)) / ((_11798 + _21402) - (_11798 * _21402))) * 0.124999918043613433837890625) * _11798, _11543);
	                }
	                else
	                {
	                    _11622 = _21625;
	                }
	                _13213 = _13139.xyz + ((((_17639.xyz + ((vec3(1.0) - _17639.xyz) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11179.xyz, _12282))), 5.0))) * _11622).xyz * _11798).xyz * _22671.xyz);
	                _15671 = _16326.xyz + (vec3(_11798).xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13139 = _13213;
	            _16326 = _15671;
	            _17019 = _20344;
	            continue;
	        }
	        _21567 = _17018 + 1u;
	        _13138 = _16326;
	        _16325 = _13139;
	        _17018 = _21567;
	        continue;
	    }
	    vec3 _19128 = _10829.xyz;
	    vec3 _10145 = normalize(_19128 - PerViewConstantBuffer_t._m3.xyz);
	    vec3 _19257 = -_10145;
	    float _17138 = _11004.x + _11004.y;
	    float _19582 = _17138 * _17138;
	    vec3 _22447 = vec3(1.0) + (_17639 * ((0.125 * (_19582 * _19582)) * saturate(dot(_17892, _19257))));
	    vec3 _10287;
	    SPIRV_CROSS_BRANCH
	    if (_14874)
	    {
	        _10287 = mix(_22447, vec3(1.0), vec3(_11543));
	    }
	    else
	    {
	        _10287 = _22447;
	    }
	    float _17751 = dot(_11004.xy, vec2(0.5));
	    vec3 _6520 = _17892.xyz;
	    vec3 _19081 = _17892.xyz;
	    float _23572 = PerViewLightingConstantBufferGpu_t._m14.y * sqrt(_17751);
	    float _17225 = _17751 * _17751;
	    float _20711 = saturate(1.0 - _17225);
	    vec3 _25271 = normalize(mix(_6520, reflect(_10145.xyz, _19081).xyz, vec3(_20711 * (sqrt(_20711) + _17225))));
	    uvec2 _6814 = uvec2(_18180.xy - PerViewConstantBuffer_t._m0.xy) >> _7663;
	    uint _19949 = PerViewLightingConstantBufferGpu_t._m11.y + (((_6814.y * PerViewLightingConstantBufferGpu_t._m12.y) + _6814.x) * PerViewLightingConstantBufferGpu_t._m11.z);
	    uint _23394 = PerViewLightingConstantBufferGpu_t._m11.x + (uint(clamp(_6864 * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m11.z);
	    vec4 _13140;
	    float _16305;
	    vec3 _17114;
	    _13140 = vec4(0.0);
	    _16305 = 0.00999999977648258209228515625;
	    _17114 = vec3(0.0);
	    uint _8896;
	    vec4 _13144;
	    vec3 _14891;
	    float _16307;
	    bool _18379;
	    uint _17021 = 0u;
	    bool _17133 = false;
	    for (;;)
	    {
	        bool _12891;
	        if (_17021 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12891 = !_17133;
	        }
	        else
	        {
	            _12891 = false;
	        }
	        if (!_12891)
	        {
	            break;
	        }
	        uint _14476 = subgroupOr(g_CullBits_1._m0[_19949 + _17021] & g_CullBits_1._m0[_23394 + _17021]);
	        vec3 _13141;
	        vec4 _16306;
	        _13141 = _17114;
	        _16306 = _13140;
	        uint _10154;
	        vec3 _13142;
	        vec4 _16381;
	        float _16480;
	        uint _17022 = _14476;
	        float _17134 = _16305;
	        for (;;)
	        {
	            if (!(_17022 != 0u))
	            {
	                _13144 = _16306;
	                _16307 = _17134;
	                _14891 = _13141;
	                _18379 = _17133;
	                break;
	            }
	            uint _18154 = uint(findLSB(_17022));
	            int _12609 = int(_18154 + (_17021 * 32u));
	            _10154 = _17022 & (_17022 - 1u);
	            vec3 _24589 = PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0 * vec4(_19128, 1.0);
	            vec3 _7748 = _24589.xyz;
	            vec3 _8793 = saturate((_7748 - PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m4.xyz);
	            vec3 _19651 = saturate((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3 - _7748) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m4.xyz);
	            float _17265 = min(min(_8793.x, min(_8793.y, _8793.z)), min(_19651.x, min(_19651.y, _19651.z)));
	            if (_17265 == 0.0)
	            {
	                _13142 = _13141;
	                _16381 = _16306;
	                _16480 = _17134;
	                _13141 = _13142;
	                _16306 = _16381;
	                _17134 = _16480;
	                _17022 = _10154;
	                continue;
	            }
	            vec3 _24234 = _24589.xyz;
	            vec3 _7648 = (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0 * vec4(_25271.xyz, 0.0)).xyz;
	            vec3 _11253 = max(((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3.xyz - _24234) / _7648).xyz, ((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1.xyz - _24234) / _7648).xyz);
	            float _11076 = ((_17265 * _17265) * (((-2.0) * _17265) + 3.0)) * (1.0 - _17134);
	            float _13713 = _17134 + _11076;
	            vec3 _15431 = _13141 + ((textureLod(samplerCubeArray(g_tEnvironmentMap, g_sTrilinearWrap), vec4(mix(_24234 + (_7648 * abs(min(_11253.x, min(_11253.y, _11253.z)))), _7648, vec3(_17751)).xyz, float(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m2)), _23572).xyz * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m5) * _11076);
	            vec4 _7460 = _16306 + (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m6 * _11076);
	            if (_13713 > 0.9900000095367431640625)
	            {
	                _13144 = _7460;
	                _16307 = _13713;
	                _14891 = _15431;
	                _18379 = true;
	                break;
	            }
	            _13142 = _15431;
	            _16381 = _7460;
	            _16480 = _13713;
	            _13141 = _13142;
	            _16306 = _16381;
	            _17134 = _16480;
	            _17022 = _10154;
	            continue;
	        }
	        _8896 = _17021 + 1u;
	        _13140 = _13144;
	        _16305 = _16307;
	        _17114 = _14891;
	        _17133 = _18379;
	        _17021 = _8896;
	        continue;
	    }
	    vec3 _20869 = _19257.xyz;
	    float _20784 = max(0.0, dot(_20869, _6520));
	    vec4 _11487 = textureLod(sampler2DArray(g_tBRDFLookup, g_sBilinearClamp), vec3((vec2(_17751, sqrt(1.0 - _20784)) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _18985 = mix(_11487.xxx, _11487.yyy, _17639);
	    float _10020;
	    vec3 _23440;
	    SPIRV_CROSS_BRANCH
	    if (_14874)
	    {
	        float _7173 = dot(normalize(_6520 + _20869).xyz, _6520);
	        float _22187 = max(_17225, 9.9999997473787516355514526367188e-06);
	        float _21363 = saturate(_20784 + 0.001000000047497451305389404296875);
	        _10020 = 1.0 - _11543;
	        _23440 = mix(_18985, _17639 * ((((2.0 + (1.0 / _22187)) * pow(1.0 - (_7173 * _7173), 0.5 / _22187)) / ((1.0 + _21363) - _21363)) * 0.124999918043613433837890625), vec3(_11543));
	    }
	    else
	    {
	        _10020 = 1.0;
	        _23440 = _18985;
	    }
	    float _8840 = 1.0 - _11487.y;
	    vec3 _15517 = _17639 + ((vec3(1.0) - _17639) * vec3(0.0476190485060214996337890625));
	    vec3 _20883 = ((_23440 * _15517) / (vec3(1.0) - (_15517 * _8840))) * _8840;
	    vec3 _13436 = vec3(_21711 * (((_19695 * pow(_14827.z, 0.20000000298023223876953125)) * (1.0 - (_16324 * 0.0500000007450580596923828125))) * mix(1.0, 1.0, _19034))).xyz;
	    vec3 _22686 = (_13138.xyz + ((_18708 * mix(vec3(1.0), vec3(1.0) - (_23440 + _20883), vec3(_10020))).xyz * _13436).xyz) * (_11121 * _12929).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_3.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15752 = _11203.xyz + ((_16325 * _10287).xyz * _13436).xyz;
	    vec4 _20492 = _11203;
	    _20492.x = _15752.x;
	    _20492.y = _15752.y;
	    _20492.z = _15752.z;
	    vec3 _15733 = _20492.xyz + ((((_17114 / vec3(_16305)).xyz * min(dot(_18708.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_19081, 1.0), (_13140 / vec4(_16305)).xyzw), max((_17751 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_23440 + (_20883 * _10020))).xyz * _13436).xyz;
	    vec4 _13888 = _20492;
	    _13888.x = _15733.x;
	    _13888.y = _15733.y;
	    _13888.z = _15733.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _10829.xyz - PerViewConstantBuffer_t._m3.xyz;
	        vec3 _9060 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12892;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m10.x)
	            {
	                _12892 = (_10829.z * PerViewConstantBufferCsgo_t._m10.z) < PerViewConstantBufferCsgo_t._m10.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12892)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m7.xy + (PerViewConstantBufferCsgo_t._m7.zw * vec2(length(_21493), _10829.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m8.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m8.y)) * PerViewConstantBufferCsgo_t._m9.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m9.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12893;
	            if (dot(_9060, _9060) > PerViewConstantBufferCsgo_t._m14.x)
	            {
	                _12893 = (PerViewConstantBufferCsgo_t._m14.z * _10829.z) < PerViewConstantBufferCsgo_t._m14.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m11.y) + PerViewConstantBufferCsgo_t._m11.x), PerViewConstantBufferCsgo_t._m11.w)) * saturate(pow(max(0.0, (_10829.z * PerViewConstantBufferCsgo_t._m12.y) + PerViewConstantBufferCsgo_t._m12.x), PerViewConstantBufferCsgo_t._m12.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m14.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m13 * vec4(_9060, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m12.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m11.z))) * PerViewConstantBufferCsgo_t._m15.x).xyz, _8892).xyz, vec3(_8892));
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
	        _6805 = _13888;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	StringAttribute(MaterialLayerType, csgo_textile_layer);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	
	
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
	
	StringAttribute(MaterialLayerType, csgo_textile_layer);
	
}
