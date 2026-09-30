//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Multilayer textile compositing shader for gloves.";
	DevShader = false;
	Version = 4;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
	Feature( F_BACKWARDS_COMPATIBILITY, 0..1 (0="Source1 Texture Layout", 1="Source2 Height Blending"), "" );
	Feature( F_ANISOTROPIC_GLOSS, 0..1, "Output Features" );
	Feature( F_CLOTH_SHADING, 0..1, "Output Features" );
	Feature( F_PATTERN, 0..1, "Pattern" );
	Feature( F_PATTERN_PAINT, 0..1, "Pattern" );
	Feature( F_PUFFY_PAINT, 0..1, "Pattern" );
	Feature( F_TINT_ID, 0..1, "Tint" );
	Feature( F_OUTPUT_MODE, 0..4 (0="Albedo", 1="Normal", 2="Metalness", 3="Ambient Occlusion", 4="Roughness"), "" );
	FeatureRule( Requires( F_PATTERN_PAINT, F_PATTERN, F_BACKWARDS_COMPATIBILITY==1 ), "Pattern mode requires Source2 Height Blending and Pattern" );
	FeatureRule( Requires( F_PUFFY_PAINT, F_PATTERN_PAINT, F_BACKWARDS_COMPATIBILITY==1 ), "Pattern mode requires Source2 Height Blending and Pattern Paint" );
	FeatureRule( Requires( F_TINT_ID, F_BACKWARDS_COMPATIBILITY ), "Tint ID requires Source2 Height Blending" );
	FeatureRule( Requires( F_OUTPUT_MODE==4, F_BACKWARDS_COMPATIBILITY, F_ANISOTROPIC_GLOSS ), "Roughness texture is only output separately when Anisotropic Gloss is enabled, otherwise roughness outputs with the normal." );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 vPositionSs    : POSITION0  < Semantic( PosXyz ); >;                                   
	float2 vTextureCoords : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                           
};

VS
{
	StaticCombo( S_BACKWARDS_COMPATIBILITY, F_BACKWARDS_COMPATIBILITY );
	
	// Composite Inputs
	float g_fPatternNormalDistortion < UiType(Slider); UiGroup("Composite Inputs/Pattern/6"); Expression(this*.1); UiVisibility(F_PATTERN); >;
	float g_fDamageTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Wear/10"); >;
	float2 g_vDamageTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Wear/11"); >;
	float g_fGrimeTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Wear/20"); >;
	float2 g_vGrimeTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Wear/21"); >;
	float2 g_vPatternTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Composite Inputs/Pattern/55"); UiVisibility(F_PATTERN); >;
	float2 g_vPatternTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Composite Inputs/Pattern/56"); UiVisibility(F_PATTERN); >;
	float g_fPatternTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Pattern/57"); UiVisibility(F_PATTERN); >;
	bool g_bFlipFixup < UiType(CheckBox); UiGroup("Composite Inputs/Off-Hand/58"); >;
	float2 g_vPatternTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Pattern/58"); UiVisibility(F_PATTERN); >;
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
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
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = g_fPatternTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vPatternTexCoordScale.x,-v2*g_vPatternTexCoordScale.y,0,g_vPatternTexCoordCenter.x+g_vPatternTexCoordOffset.x+v2*g_vPatternTexCoordCenter.y-v1*g_vPatternTexCoordCenter.x)); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = g_fPatternTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vPatternTexCoordScale.x,v1*g_vPatternTexCoordScale.y,0,g_vPatternTexCoordCenter.y+g_vPatternTexCoordOffset.y-(v2*g_vPatternTexCoordCenter.x+v1*g_vPatternTexCoordCenter.y))); >;
	float4 g_vViewport < Source(Viewport); UiType(VectorText); >;
	
	// Material1
	float2 g_vUvScale1 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material1,1/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset1 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material1/Texcoord Transform/1"); >;
	
	// Material2
	float2 g_vUvScale2 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material2,2/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset2 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material2/Texcoord Transform/1"); >;
	
	// Material3
	float2 g_vUvScale3 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material3,3/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Texcoord Transform/1"); >;
	
	// Material4
	float2 g_vUvScale4 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material4,4/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset4 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material4/Texcoord Transform/1"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float _2;
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vViewport : packoffset(c0);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionSs;
	static float2 vTextureCoords;
	static float4 output_0;
	
	struct VS_INPUT
	{
	    float2 vPositionSs : TEXCOORD0;
	    float2 vTextureCoords : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float2 _15639 = (((vPositionSs.xy - _Globals_1_g_vViewport.xy) * 2.0f) / _Globals_1_g_vViewport.zw) - 1.0f.xx;
	    float4 _14817 = float4(_15639.x, _2, 1.0f, 1.0f);
	    output_0 = float4(vTextureCoords.xyxy);
	    _14817.y = _15639.y;
	    gl_Position = _14817;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    vTextureCoords = stage_input.vTextureCoords;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	IntAttribute(MaterialLayerCount, 4);
	StringAttribute(MaterialLayerRefType, csgo_textile_layer);
	BoolAttribute(ui, true);
	BoolAttribute(ScreenSpaceVertices, true);
	
}

PS
{
	StaticCombo( S_BACKWARDS_COMPATIBILITY, F_BACKWARDS_COMPATIBILITY );
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_TINT_ID, F_TINT_ID );
	StaticComboRule( Requires( S_TINT_ID, S_BACKWARDS_COMPATIBILITY ) );
	
	bool g_bPattern < UiType(CheckBox); Expression(F_PATTERN ? 1 : 0); >;
	bool g_bPatternPaintEmboss < UiType(CheckBox); Expression(F_PUFFY_PAINT); >;
	bool g_bPatternPaintLayer < UiType(CheckBox); Expression(F_PATTERN_PAINT); >;
	float g_fDetailBlackPointCompensation1 < UiType(Slider); Expression(1-g_fDetailBlackPoint1); >;
	float g_fDetailBlackPointCompensation2 < UiType(Slider); Expression(1-g_fDetailBlackPoint2); >;
	float g_fDetailBlackPointCompensation3 < UiType(Slider); Expression(1-g_fDetailBlackPoint3); >;
	float g_fDetailBlackPointCompensation4 < UiType(Slider); Expression(1-g_fDetailBlackPoint4); >;
	float g_fFlipFixup < UiType(Slider); Expression(g_bFlipFixup ? -1 : 1); >;
	float g_fPaintShadowPower < UiType(Slider); Expression(max(.01,g_fPaintThickness*.15)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_mDamageColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint1,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast1,g_fDamageBevelColorSaturation1,g_fDamageBevelColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mDamageColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint2,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast2,g_fDamageBevelColorSaturation2,g_fDamageBevelColorBrightness2),TextureAverageColor(g_tSurface2)))); >;
	float4x4 g_mDamageColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint3,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast3,g_fDamageBevelColorSaturation3,g_fDamageBevelColorBrightness3),TextureAverageColor(g_tSurface3)))); >;
	float4x4 g_mDamageColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint4,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast4,g_fDamageBevelColorSaturation4,g_fDamageBevelColorBrightness4),TextureAverageColor(g_tSurface4)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint1,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast1,g_fBurnishingColorSaturation1,g_fBurnishingColorBrightness1),TextureAverageColor(g_tSubstrate1)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint2,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast2,g_fBurnishingColorSaturation2,g_fBurnishingColorBrightness2),TextureAverageColor(g_tSubstrate2)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint3,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast3,g_fBurnishingColorSaturation3,g_fBurnishingColorBrightness3),TextureAverageColor(g_tSubstrate3)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint4,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast4,g_fBurnishingColorSaturation4,g_fBurnishingColorBrightness4),TextureAverageColor(g_tSubstrate4)))); >;
	float4x4 g_mSubstrateColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint1,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast1,g_fSubstrateColorSaturation1,g_fSubstrateColorBrightness1),TextureAverageColor(g_tSubstrate1)))); >;
	float4x4 g_mSubstrateColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint2,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast2,g_fSubstrateColorSaturation2,g_fSubstrateColorBrightness2),TextureAverageColor(g_tSubstrate2)))); >;
	float4x4 g_mSubstrateColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint3,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast3,g_fSubstrateColorSaturation3,g_fSubstrateColorBrightness3),TextureAverageColor(g_tSubstrate3)))); >;
	float4x4 g_mSubstrateColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint4,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast4,g_fSubstrateColorSaturation4,g_fSubstrateColorBrightness4),TextureAverageColor(g_tSubstrate4)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint1,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast1,g_fBurnishingColorSaturation1,g_fBurnishingColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint2,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast2,g_fBurnishingColorSaturation2,g_fBurnishingColorBrightness2),TextureAverageColor(g_tSurface2)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint3,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast3,g_fBurnishingColorSaturation3,g_fBurnishingColorBrightness3),TextureAverageColor(g_tSurface3)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint4,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast4,g_fBurnishingColorSaturation4,g_fBurnishingColorBrightness4),TextureAverageColor(g_tSurface4)))); >;
	float4x4 g_mSurfaceColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint1,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast1,g_fSurfaceColorSaturation1,g_fSurfaceColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mSurfaceColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint2,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast2,g_fSurfaceColorSaturation2,g_fSurfaceColorBrightness2),TextureAverageColor(g_tSurface2)))); >;
	float4x4 g_mSurfaceColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint3,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast3,g_fSurfaceColorSaturation3,g_fSurfaceColorBrightness3),TextureAverageColor(g_tSurface3)))); >;
	float4x4 g_mSurfaceColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint4,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast4,g_fSurfaceColorSaturation4,g_fSurfaceColorBrightness4),TextureAverageColor(g_tSurface4)))); >;
	int g_nOutputMode < UiType(Slider); Expression(F_OUTPUT_MODE); >;
	Texture2D g_tDamage1 < Channel(R, Box(TextureDamageHeight1), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamage2 < Channel(R, Box(TextureDamageHeight2), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamage3 < Channel(R, Box(TextureDamageHeight3), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamage4 < Channel(R, Box(TextureDamageHeight4), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamageNormal1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDamageNormal1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDamageNormal2 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDamageNormal2), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDamageNormal3 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDamageNormal3), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDamageNormal4 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDamageNormal4), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDetail1 < Channel(RGBA, Box(TextureDetail1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetail2 < Channel(RGBA, Box(TextureDetail2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetail3 < Channel(RGBA, Box(TextureDetail3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetail4 < Channel(RGBA, Box(TextureDetail4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailNormal1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDetailNormal1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDetailNormal2 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDetailNormal2), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDetailNormal3 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDetailNormal3), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tDetailNormal4 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureDetailNormal4), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tGrime1 < Channel(RGB, ArtistDefined(TextureGrime1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrime2 < Channel(RGB, ArtistDefined(TextureGrime2), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrime3 < Channel(RGB, ArtistDefined(TextureGrime3), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrime4 < Channel(RGB, ArtistDefined(TextureGrime4), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrunge1 < Channel(RGBA, Box(TextureGrunge1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrunge2 < Channel(RGBA, Box(TextureGrunge2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrunge3 < Channel(RGBA, Box(TextureGrunge3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrunge4 < Channel(RGBA, Box(TextureGrunge4), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayerId < Channel(RGB, Box(TextureObjectMaterialId), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayerMask < Channel(RGBA, Box(TextureLayerMask), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNoise < Channel(RGBA, Box(TextureNoise), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureObjectNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tObjectProperties < Channel(R, Box(TextureObjectAmbientOcclusion), Linear); Channel(G, Box(TextureObjectCurvature), Linear); Channel(B, Box(TextureObjectHighTouchMask), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tPattern < Channel(RGBA, Box(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tPattern < Channel(RGB, Box(TexturePatternColor), Srgb); Channel(A, Box(TexturePatternTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tPatternProperties < Channel(R, Box(TexturePatternMetalness), Linear); Channel(G, Box(TexturePatternRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tSubstrate1 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo1), Srgb); Channel(A, Box(TextureSubstrateTintMask1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrate2 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo2), Srgb); Channel(A, Box(TextureSubstrateTintMask2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrate3 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo3), Srgb); Channel(A, Box(TextureSubstrateTintMask3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrate4 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo4), Srgb); Channel(A, Box(TextureSubstrateTintMask4), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrateNormal1 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal1, TextureSubstrateRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateNormal2 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal2, TextureSubstrateRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateNormal3 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal3, TextureSubstrateRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateNormal4 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal4, TextureSubstrateRoughness4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties1 < Channel(R, Box3(TextureSubstrateAmbientOcclusion1), Linear); Channel(G, Box(TextureSubstrateMetalness1), Linear); Channel(B, Box(TextureSubstrateClothMask1), Linear); Channel(A, Box(TextureSubstrateHeight1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties2 < Channel(R, Box3(TextureSubstrateAmbientOcclusion2), Linear); Channel(G, Box(TextureSubstrateMetalness2), Linear); Channel(B, Box(TextureSubstrateClothMask2), Linear); Channel(A, Box(TextureSubstrateHeight2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties3 < Channel(R, Box3(TextureSubstrateAmbientOcclusion3), Linear); Channel(G, Box(TextureSubstrateMetalness3), Linear); Channel(B, Box(TextureSubstrateClothMask3), Linear); Channel(A, Box(TextureSubstrateHeight3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties4 < Channel(R, Box3(TextureSubstrateAmbientOcclusion4), Linear); Channel(G, Box(TextureSubstrateMetalness4), Linear); Channel(B, Box(TextureSubstrateClothMask4), Linear); Channel(A, Box(TextureSubstrateHeight4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurface < Channel(RGBA, Box(TextureSurfaceProperties), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurface1 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo1), Srgb); Channel(A, Box(TextureSurfaceTintMask1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurface2 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo2), Srgb); Channel(A, Box(TextureSurfaceTintMask2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurface3 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo3), Srgb); Channel(A, Box(TextureSurfaceTintMask3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurface4 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo4), Srgb); Channel(A, Box(TextureSurfaceTintMask4), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurfaceNormal1 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal1, TextureSurfaceRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceNormal2 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal2, TextureSurfaceRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceNormal3 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal3, TextureSurfaceRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceNormal4 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal4, TextureSurfaceRoughness4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties1 < Channel(R, Box3(TextureSurfaceAmbientOcclusion1), Linear); Channel(G, Box(TextureSurfaceMetalness1), Linear); Channel(B, Box(TextureSurfaceClothMask1), Linear); Channel(A, Box(TextureSurfaceHeight1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties2 < Channel(R, Box3(TextureSurfaceAmbientOcclusion2), Linear); Channel(G, Box(TextureSurfaceMetalness2), Linear); Channel(B, Box(TextureSurfaceClothMask2), Linear); Channel(A, Box(TextureSurfaceHeight2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties3 < Channel(R, Box3(TextureSurfaceAmbientOcclusion3), Linear); Channel(G, Box(TextureSurfaceMetalness3), Linear); Channel(B, Box(TextureSurfaceClothMask3), Linear); Channel(A, Box(TextureSurfaceHeight3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties4 < Channel(R, Box3(TextureSurfaceAmbientOcclusion4), Linear); Channel(G, Box(TextureSurfaceMetalness4), Linear); Channel(B, Box(TextureSurfaceClothMask4), Linear); Channel(A, Box(TextureSurfaceHeight4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tTintId < Channel(RGB, None(TextureObjectTintId), Linear); OutputFormat(67); SrgbRead(false); >;
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
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_bFlipFixup ? -g_fPatternTexCoordRotation : g_fPatternTexCoordRotation)*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_fPatternTexCoordScale;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v1*v3,-v2*v3,0,v3*v1*v7+v3*-v2*v8+(g_fPatternTexCoordOffset.x-.5))); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_bFlipFixup ? -g_fPatternTexCoordRotation : g_fPatternTexCoordRotation)*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_fPatternTexCoordScale;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v2*v3,v1*v3,0,v3*v2*v7+v3*v1*v8+(g_fPatternTexCoordOffset.y-.5))); >;
	float4 g_vPatternTexRotationXform0 < UiType(VectorText); Expression(v0 = (g_bFlipFixup ? g_fPatternTexCoordRotation : -g_fPatternTexCoordRotation)*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = 1;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v1*v3,-v2*v3,0,v3*v1*v7+v3*-v2*v8+(0-.5))); >;
	float4 g_vPatternTexRotationXform1 < UiType(VectorText); Expression(v0 = (g_bFlipFixup ? g_fPatternTexCoordRotation : -g_fPatternTexCoordRotation)*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = 1;
		v4 = .5/((v3!=0) ? v3 : 1);
		v5 = cos(-v0);
		v6 = sin(-v0);
		v7 = v4*v5-v4*v6;
		v8 = v7*v6+v4*v5;
		float4(v2*v3,v1*v3,0,v3*v2*v7+v3*v1*v8+(0-.5))); >;
	float3 g_vTextileAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.045,.6,1).x,-1.4427*log(max(.0001,1-float3(-.045,.6,1).y)),2-float3(-.045,.6,1).z)); >;
	
	// Material1
	CreateInputTexture2D(TextureDamageHeight1, Linear, 8, "Inverse", "_height", "Material1/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureDetail1, Linear, 8, "", "_detail", "Material1,1/Detail/1", Default4(0.5, 0.5, 1, 1));
	CreateInputTexture2D(TextureGrime1, Srgb, 8, "", "_color", "Material1/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo1, Srgb, 8, "", "_color", "Material1/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo1, Srgb, 8, "", "_color", "Material1/Surface Layer,1/1", Default4(1, 1, 1, 0));
	float2 g_vDamageLevels1 < Default(0); UiType(VectorText); UiGroup("Material1,1/Detail Damage/1"); >;
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
	float2 g_vSurfaceGrimeMinMax1 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material1/Grime/10"); >;
	CreateInputTexture2D(TextureDamageNormal1, Linear, 8, "", "_damagenormal", "Material1/Normal/11", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageCloth1 < UiType(Slider); UiGroup("Material1/Detail Damage/11"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageHeightBlendSoftness1 < Default(0.01); UiType(Slider); UiGroup("Material1/Damage Height/11"); Expression(max(this,.001)); >;
	float g_fDetailGrunge1 < Range(0, 2); UiType(Slider); UiGroup("Material1/Grunge/11"); >;
	float g_fDetailScale1 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material1/Detail/11"); >;
	float2 g_vSubstrateGrimeMinMax1 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material1/Grime/11"); >;
	float g_fDetailNormalContrast1 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material1/Normal/12"); >;
	float g_fDetailRoughnessContrast1 < Range(-1, 1); UiType(Slider); UiGroup("Material1/Detail/12"); >;
	float2 g_vDamageMinMax1 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material1/Damage Height/12"); >;
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
	float g_fSubstrateCompositeColorTranslucency1 < Default(0.5); UiType(Slider); UiGroup("Material1/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
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
	float g_fSurfaceBurnishingRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	float g_fSurfaceBurnishingRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	float g_fSurfaceBurnishingRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	CreateInputTexture2D(TextureSubstrateHeight1, Linear, 8, "", "_height", "Material1/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight1, Linear, 8, "", "_height", "Material1/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	float g_fSubstrateBurnishingRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	float g_fSubstrateBurnishingRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	float g_fSubstrateBurnishingRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	float g_fSubstrateBurnishingRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	CreateInputTexture2D(TextureSubstrateMetalness1, Srgb, 8, "", "_metal", "Material1/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness1, Linear, 8, "", "_metal", "Material1/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax1 < Default(0); UiType(VectorText); UiGroup("Material1/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask1, Srgb, 8, "", "_mask", "Material1/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask1, Linear, 8, "", "_mask", "Material1/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy1 < UiType(Slider); UiGroup("Material1/Damage Bevel/41"); >;
	float g_fDamageNormalEdgeWidth1 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material1,1/Wear Edge/41"); >;
	float2 g_vSubstrateBurnishingMinMax1 < Default(0); UiType(VectorText); UiGroup("Material1/Burnishing/41"); >;
	float g_fDamageEdgeRoughness1 < Default(0.8); UiType(Slider); UiGroup("Material1/Wear Edge/42"); >;
	float g_fDamageEdgeMetalness1 < UiType(Slider); UiGroup("Material1/Wear Edge/43"); >;
	float g_fDamageBevelMetalness1 < UiType(Slider); UiGroup("Material1/Damage Bevel/50"); >;
	float g_fDamageBevelCloth1 < UiType(Slider); UiGroup("Material1/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate1 < UiType(CheckBox); UiGroup("Material1/Damage Bevel/80"); >;
	
	// Material2
	CreateInputTexture2D(TextureDamageHeight2, Linear, 8, "Inverse", "_height", "Material2/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureDetail2, Linear, 8, "", "_detail", "Material2,2/Detail/1", Default4(0.5, 0.5, 1, 1));
	CreateInputTexture2D(TextureGrime2, Srgb, 8, "", "_color", "Material2/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo2, Srgb, 8, "", "_color", "Material2/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo2, Srgb, 8, "", "_color", "Material2/Surface Layer,1/1", Default4(1, 1, 1, 0));
	float2 g_vDamageLevels2 < Default(0); UiType(VectorText); UiGroup("Material2/Detail Damage/1"); >;
	CreateInputTexture2D(TextureSubstrateTintMask2, Linear, 8, "", "_tintmask", "Material2/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask2, Linear, 8, "", "_tintmask", "Material2/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fCurvaturePower2 < Default(1); Range(0.5, 6); UiType(Slider); UiGroup("Material2/Detail Damage/2"); >;
	float g_fDamageUvScale2 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material2/Damage Height/2"); >;
	float g_fGrimeUvScale2 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material2/Grime/2"); >;
	float g_fCurvatureWearBoost2 < UiType(Slider); UiGroup("Material2/Detail Damage/3"); >;
	float g_fGrimeRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material2/Grime/3"); >;
	float g_fGrimeTranslucency2 < Default(0.5); UiType(Slider); UiGroup("Material2/Grime/3"); >;
	float g_fDetailBlackPoint2 < Default(0.047); Range(0, 0.2); UiType(Slider); UiGroup("Material2/Detail/5"); >;
	float3 g_vSubstrateColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Surface Layer/5"); >;
	float g_fDamageSaturation2 < Range(-2, 2); UiType(Slider); UiGroup("Material2/Detail Damage/6"); >;
	float g_fSubstrateColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Surface Layer/6"); >;
	float g_fDamageBrightness2 < Range(-1, 3); UiType(Slider); UiGroup("Material2/Detail Damage/7"); >;
	float g_fSubstrateColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Surface Layer/7"); >;
	float g_fDamageBleaching2 < UiType(Slider); UiGroup("Material2/Detail Damage/8"); >;
	float g_fSubstrateColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Surface Layer/8"); >;
	CreateInputTexture2D(TextureDetailNormal2, Linear, 8, "", "_detailnormal", "Material2/Normal/10", Default4(0.5, 0.5, 0.5, 0.5));
	CreateInputTexture2D(TextureGrunge2, Linear, 8, "", "_grunge", "Material2/Grunge/10", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageMetalness2 < UiType(Slider); UiGroup("Material2/Detail Damage/10"); >;
	float2 g_vSurfaceGrimeMinMax2 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material2/Grime/10"); >;
	CreateInputTexture2D(TextureDamageNormal2, Linear, 8, "", "_damagenormal", "Material2/Normal/11", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageCloth2 < UiType(Slider); UiGroup("Material2/Detail Damage/11"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageHeightBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Damage Height/11"); Expression(max(this,.001)); >;
	float g_fDetailGrunge2 < Range(0, 2); UiType(Slider); UiGroup("Material2/Grunge/11"); >;
	float g_fDetailScale2 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material2/Detail/11"); >;
	float2 g_vSubstrateGrimeMinMax2 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material2/Grime/11"); >;
	float g_fDetailNormalContrast2 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material2/Normal/12"); >;
	float g_fDetailRoughnessContrast2 < Range(-1, 1); UiType(Slider); UiGroup("Material2/Detail/12"); >;
	float2 g_vDamageMinMax2 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material2/Damage Height/12"); >;
	float g_fDetailRoughnessBrightness2 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material2/Detail/13"); >;
	float g_fWearBleaching2 < Default(0.25); Range(0, 3); UiType(Slider); UiGroup("Material2/Grunge/13"); >;
	float g_fDetailAnisotropyScalar2 < Range(-1, 1); UiType(Slider); UiGroup("Material2/Detail/14"); >;
	float g_fDamageNormalEdgeWidth2 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material2/Wear Edge/15"); >;
	float g_fDetailMetalness2 < UiType(Slider); UiGroup("Material2/Detail/15"); >;
	float g_fDamageEdgeRoughness2 < Default(0.8); UiType(Slider); UiGroup("Material2/Wear Edge/16"); >;
	float g_fDetailCloth2 < UiType(Slider); UiGroup("Material2/Detail/16"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageEdgeMetalness2 < UiType(Slider); UiGroup("Material2/Wear Edge/17"); >;
	float g_fBurnishingGrime2 < Default(0.5); UiType(Slider); UiGroup("Material2/Grime/20"); >;
	float3 g_vBurnishingColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Burnishing/21"); >;
	float g_fDamageBevelColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Damage Bevel/21"); >;
	float g_fGrungeMax2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material2/Grunge/21"); >;
	float g_fSubstrateCompositeColorTranslucency2 < Default(0.5); UiType(Slider); UiGroup("Material2/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
	float g_fBurnishingColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Damage Bevel/22"); >;
	float g_fBurnishingColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask2 < UiType(CheckBox); UiGroup("Material2/Damage Bevel/24"); >;
	float g_fBurnishingCloth2 < UiType(Slider); UiGroup("Material2/Burnishing/25"); >;
	float g_fBurnishingMetalness2 < UiType(Slider); UiGroup("Material2/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale2 < Default(1); UiType(Slider); UiGroup("Material2/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness2 < Default(0.5); UiType(Slider); UiGroup("Material2/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness2,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Damage Bevel/31"); >;
	float g_fDamageRoughnessContrast2 < Range(-1, 1); UiType(Slider); UiGroup("Material2/Detail Damage/31"); >;
	float g_fGrimeSaturation2 < Range(-2, 2); UiType(Slider); UiGroup("Material2/Grunge/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Surface Layer/32", Default4(1, 1, 1, 0));
	float g_fDamageRoughnessBrightness2 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material2/Detail Damage/32"); >;
	float g_fGrimeBrightness2 < Range(-1, 3); UiType(Slider); UiGroup("Material2/Grunge/32"); >;
	CreateInputTexture2D(TextureSubstrateHeight2, Linear, 8, "", "_height", "Material2/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight2, Linear, 8, "", "_height", "Material2/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateMetalness2, Srgb, 8, "", "_metal", "Material2/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness2, Linear, 8, "", "_metal", "Material2/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material2/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax2 < Default(0); UiType(VectorText); UiGroup("Material2/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask2, Srgb, 8, "", "_mask", "Material2/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask2, Linear, 8, "", "_mask", "Material2/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy2 < UiType(Slider); UiGroup("Material2/Damage Bevel/41"); >;
	float2 g_vSubstrateBurnishingMinMax2 < Default(0); UiType(VectorText); UiGroup("Material2/Burnishing/41"); >;
	float g_fDamageBevelMetalness2 < UiType(Slider); UiGroup("Material2/Damage Bevel/50"); >;
	float g_fDamageBevelCloth2 < UiType(Slider); UiGroup("Material2/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate2 < UiType(CheckBox); UiGroup("Material2/Damage Bevel/80"); >;
	
	// Material3
	CreateInputTexture2D(TextureDamageHeight3, Linear, 8, "Inverse", "_height", "Material3/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureDetail3, Linear, 8, "", "_detail", "Material3,3/Detail/1", Default4(0.5, 0.5, 1, 1));
	CreateInputTexture2D(TextureGrime3, Srgb, 8, "", "_color", "Material3/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo3, Srgb, 8, "", "_color", "Material3/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo3, Srgb, 8, "", "_color", "Material3/Surface Layer,1/1", Default4(1, 1, 1, 0));
	float2 g_vDamageLevels3 < Default(0); UiType(VectorText); UiGroup("Material3/Detail Damage/1"); >;
	CreateInputTexture2D(TextureSubstrateTintMask3, Linear, 8, "", "_tintmask", "Material3/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask3, Linear, 8, "", "_tintmask", "Material3/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fCurvaturePower3 < Default(1); Range(0.5, 6); UiType(Slider); UiGroup("Material3/Detail Damage/2"); >;
	float g_fDamageUvScale3 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material3/Damage Height/2"); >;
	float g_fGrimeUvScale3 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material3/Grime/2"); >;
	float g_fCurvatureWearBoost3 < UiType(Slider); UiGroup("Material3/Detail Damage/3"); >;
	float g_fGrimeRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material3/Grime/3"); >;
	float g_fGrimeTranslucency3 < Default(0.5); UiType(Slider); UiGroup("Material3/Grime/3"); >;
	float g_fDetailBlackPoint3 < Default(0.047); Range(0, 0.2); UiType(Slider); UiGroup("Material3/Detail/5"); >;
	float3 g_vSubstrateColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Surface Layer/5"); >;
	float g_fDamageSaturation3 < Range(-2, 2); UiType(Slider); UiGroup("Material3/Detail Damage/6"); >;
	float g_fSubstrateColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Surface Layer/6"); >;
	float g_fDamageBrightness3 < Range(-1, 3); UiType(Slider); UiGroup("Material3/Detail Damage/7"); >;
	float g_fSubstrateColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Surface Layer/7"); >;
	float g_fDamageBleaching3 < UiType(Slider); UiGroup("Material3/Detail Damage/8"); >;
	float g_fSubstrateColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Surface Layer/8"); >;
	CreateInputTexture2D(TextureDetailNormal3, Linear, 8, "", "_detailnormal", "Material3/Normal/10", Default4(0.5, 0.5, 0.5, 0.5));
	CreateInputTexture2D(TextureGrunge3, Linear, 8, "", "_grunge", "Material3/Grunge/10", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageMetalness3 < UiType(Slider); UiGroup("Material3/Detail Damage/10"); >;
	float2 g_vSurfaceGrimeMinMax3 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material3/Grime/10"); >;
	CreateInputTexture2D(TextureDamageNormal3, Linear, 8, "", "_damagenormal", "Material3/Normal/11", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageCloth3 < UiType(Slider); UiGroup("Material3/Detail Damage/11"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageHeightBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Damage Height/11"); Expression(max(this,.001)); >;
	float g_fDetailGrunge3 < Range(0, 2); UiType(Slider); UiGroup("Material3/Grunge/11"); >;
	float g_fDetailScale3 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material3/Detail/11"); >;
	float2 g_vSubstrateGrimeMinMax3 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material3/Grime/11"); >;
	float g_fDetailNormalContrast3 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material3/Normal/12"); >;
	float g_fDetailRoughnessContrast3 < Range(-1, 1); UiType(Slider); UiGroup("Material3/Detail/12"); >;
	float2 g_vDamageMinMax3 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material3/Damage Height/12"); >;
	float g_fDetailRoughnessBrightness3 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material3/Detail/13"); >;
	float g_fWearBleaching3 < Default(0.25); Range(0, 3); UiType(Slider); UiGroup("Material3/Wear Edge/13"); >;
	float g_fDetailAnisotropyScalar3 < Range(-1, 1); UiType(Slider); UiGroup("Material3/Detail/14"); >;
	float g_fDamageNormalEdgeWidth3 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material3/Wear Edge/15"); >;
	float g_fDetailMetalness3 < UiType(Slider); UiGroup("Material3/Detail/15"); >;
	float g_fDamageEdgeRoughness3 < Default(0.8); UiType(Slider); UiGroup("Material3/Wear Edge/16"); >;
	float g_fDetailCloth3 < UiType(Slider); UiGroup("Material3/Detail/16"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageEdgeMetalness3 < UiType(Slider); UiGroup("Material3/Wear Edge/17"); >;
	float g_fBurnishingGrime3 < Default(0.5); UiType(Slider); UiGroup("Material3/Grime/20"); >;
	float3 g_vBurnishingColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Burnishing/21"); >;
	float g_fDamageBevelColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Damage Bevel/21"); >;
	float g_fGrungeMax3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material3/Grunge/21"); >;
	float g_fSubstrateCompositeColorTranslucency3 < Default(0.5); UiType(Slider); UiGroup("Material3/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
	float g_fBurnishingColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Damage Bevel/22"); >;
	float g_fGrungeRoughnessBrightness3 < Default(0.8); Range(0, 10); UiType(Slider); UiGroup("Material3/Grunge/22"); >;
	float g_fBurnishingColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask3 < UiType(CheckBox); UiGroup("Material3/Damage Bevel/24"); >;
	float g_fBurnishingCloth3 < UiType(Slider); UiGroup("Material3/Burnishing/25"); >;
	float g_fBurnishingMetalness3 < UiType(Slider); UiGroup("Material3/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale3 < Default(1); UiType(Slider); UiGroup("Material3/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness3 < Default(0.5); UiType(Slider); UiGroup("Material3/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness3,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Damage Bevel/31"); >;
	float g_fDamageRoughnessContrast3 < Range(-1, 1); UiType(Slider); UiGroup("Material3/Detail Damage/31"); >;
	float g_fGrimeSaturation3 < Range(-2, 2); UiType(Slider); UiGroup("Material3/Grunge/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Surface Layer/32", Default4(1, 1, 1, 0));
	float g_fDamageRoughnessBrightness3 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material3/Detail Damage/32"); >;
	float g_fGrimeBrightness3 < Range(-1, 3); UiType(Slider); UiGroup("Material3/Grunge/32"); >;
	CreateInputTexture2D(TextureSubstrateHeight3, Linear, 8, "", "_height", "Material3/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight3, Linear, 8, "", "_height", "Material3/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateMetalness3, Srgb, 8, "", "_metal", "Material3/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness3, Linear, 8, "", "_metal", "Material3/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material3/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax3 < Default(0); UiType(VectorText); UiGroup("Material3/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask3, Srgb, 8, "", "_mask", "Material3/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask3, Linear, 8, "", "_mask", "Material3/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy3 < UiType(Slider); UiGroup("Material3/Damage Bevel/41"); >;
	float2 g_vSubstrateBurnishingMinMax3 < Default(0); UiType(VectorText); UiGroup("Material3/Burnishing/41"); >;
	float g_fDamageBevelMetalness3 < UiType(Slider); UiGroup("Material3/Damage Bevel/50"); >;
	float g_fDamageBevelCloth3 < UiType(Slider); UiGroup("Material3/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate3 < UiType(CheckBox); UiGroup("Material3/Damage Bevel/80"); >;
	
	// Material4
	CreateInputTexture2D(TextureDamageHeight4, Linear, 8, "Inverse", "_height", "Material4/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureDetail4, Linear, 8, "", "_detail", "Material4,4/Detail/1", Default4(0.5, 0.5, 1, 1));
	CreateInputTexture2D(TextureGrime4, Srgb, 8, "", "_color", "Material4/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo4, Srgb, 8, "", "_color", "Material4/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo4, Srgb, 8, "", "_color", "Material4/Surface Layer/1", Default4(1, 1, 1, 0));
	float2 g_vDamageLevels4 < Default(0); UiType(VectorText); UiGroup("Material4/Detail Damage/1"); >;
	CreateInputTexture2D(TextureSubstrateTintMask4, Linear, 8, "", "_tintmask", "Material4/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask4, Linear, 8, "", "_tintmask", "Material4/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fCurvaturePower4 < Default(1); Range(0.5, 6); UiType(Slider); UiGroup("Material4/Detail Damage/2"); >;
	float g_fDamageUvScale4 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material4/Damage Height/2"); >;
	float g_fGrimeUvScale4 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material4/Grime/2"); >;
	float g_fCurvatureWearBoost4 < UiType(Slider); UiGroup("Material4/Detail Damage/3"); >;
	float g_fGrimeRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material4/Grime/3"); >;
	float g_fGrimeTranslucency4 < Default(0.5); UiType(Slider); UiGroup("Material4/Grime/3"); >;
	float g_fDetailBlackPoint4 < Default(0.047); Range(0, 0.2); UiType(Slider); UiGroup("Material4/Detail/5"); >;
	float3 g_vSubstrateColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Surface Layer/5"); >;
	float g_fDamageSaturation4 < Range(-2, 2); UiType(Slider); UiGroup("Material4/Detail Damage/6"); >;
	float g_fSubstrateColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Surface Layer/6"); >;
	float g_fDamageBrightness4 < Range(-1, 3); UiType(Slider); UiGroup("Material4/Detail Damage/7"); >;
	float g_fSubstrateColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Surface Layer/7"); >;
	float g_fDamageBleaching4 < UiType(Slider); UiGroup("Material4/Detail Damage/8"); >;
	float g_fSubstrateColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Surface Layer/8"); >;
	CreateInputTexture2D(TextureDetailNormal4, Linear, 8, "", "_detailnormal", "Material4/Normal/10", Default4(0.5, 0.5, 0.5, 0.5));
	CreateInputTexture2D(TextureGrunge4, Linear, 8, "", "_grunge", "Material4/Grunge/10", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageMetalness4 < UiType(Slider); UiGroup("Material4/Detail Damage/10"); >;
	float2 g_vSurfaceGrimeMinMax4 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material4/Grime/10"); >;
	CreateInputTexture2D(TextureDamageNormal4, Linear, 8, "", "_damagenormal", "Material4/Normal/11", Default4(0.5, 0.5, 0.5, 0.5));
	float g_fDamageCloth4 < UiType(Slider); UiGroup("Material4/Detail Damage/11"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageHeightBlendSoftness4 < Default(0.01); UiType(Slider); UiGroup("Material4/Damage Height/11"); Expression(max(this,.001)); >;
	float g_fDetailGrunge4 < Range(0, 2); UiType(Slider); UiGroup("Material4/Grunge/11"); >;
	float g_fDetailScale4 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material4/Detail/11"); >;
	float2 g_vSubstrateGrimeMinMax4 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material4/Grime/11"); >;
	float g_fDetailNormalContrast4 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material4/Normal/12"); >;
	float g_fDetailRoughnessContrast4 < Range(-1, 1); UiType(Slider); UiGroup("Material4/Detail/12"); >;
	float2 g_vDamageMinMax4 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material4/Damage Height/12"); >;
	float g_fDetailRoughnessBrightness4 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material4/Detail/13"); >;
	float g_fWearBleaching4 < Default(0.25); Range(0, 3); UiType(Slider); UiGroup("Material4/Wear Edge/13"); >;
	float g_fDetailAnisotropyScalar4 < Range(-1, 1); UiType(Slider); UiGroup("Material4/Detail/14"); >;
	float g_fDamageNormalEdgeWidth4 < Default(1); Range(0, 8); UiType(Slider); UiGroup("Material4/Wear Edge/15"); >;
	float g_fDetailMetalness4 < UiType(Slider); UiGroup("Material4/Detail/15"); >;
	float g_fDamageEdgeRoughness4 < Default(0.8); UiType(Slider); UiGroup("Material4/Wear Edge/16"); >;
	float g_fDetailCloth4 < UiType(Slider); UiGroup("Material4/Detail/16"); UiVisibility(F_CLOTH_SHADING); >;
	float g_fDamageEdgeMetalness4 < UiType(Slider); UiGroup("Material4/Wear Edge/17"); >;
	float g_fBurnishingGrime4 < Default(0.5); UiType(Slider); UiGroup("Material4/Grime/20"); >;
	float3 g_vBurnishingColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Burnishing/21"); >;
	float g_fDamageBevelColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Damage Bevel/21"); >;
	float g_fGrungeMax4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material4/Grunge/21"); >;
	float g_fSubstrateCompositeColorTranslucency4 < Default(0.5); UiType(Slider); UiGroup("Material4/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
	float g_fBurnishingColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Damage Bevel/22"); >;
	float g_fGrungeRoughnessBrightness2 < Default(0.8); Range(0, 10); UiType(Slider); UiGroup("Material4/Grunge/22"); >;
	float g_fGrungeRoughnessBrightness4 < Default(0.8); Range(0, 10); UiType(Slider); UiGroup("Material4/Grunge/22"); >;
	float g_fBurnishingColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask4 < UiType(CheckBox); UiGroup("Material4/Damage Bevel/24"); >;
	float g_fBurnishingCloth4 < UiType(Slider); UiGroup("Material4/Burnishing/25"); >;
	float g_fBurnishingMetalness4 < UiType(Slider); UiGroup("Material4/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal4, Linear, 8, "NormalizeNormals", "_normal", "Material4/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal4, Linear, 8, "NormalizeNormals", "_normal", "Material4/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale4 < Default(1); UiType(Slider); UiGroup("Material4/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness4 < Default(0.5); UiType(Slider); UiGroup("Material4/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness4,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness4, Linear, 8, "Inverse", "_rough", "Material4/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness4, Linear, 8, "Inverse", "_rough", "Material4/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Damage Bevel/31"); >;
	float g_fDamageRoughnessContrast4 < Range(-1, 1); UiType(Slider); UiGroup("Material4/Detail Damage/31"); >;
	float g_fGrimeSaturation4 < Range(-2, 2); UiType(Slider); UiGroup("Material4/Grunge/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion4, Linear, 8, "", "_ao", "Material4/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion4, Linear, 8, "", "_ao", "Material4/Surface Layer/32", Default4(1, 1, 1, 0));
	float g_fDamageRoughnessBrightness4 < Default(1); Range(0, 10); UiType(Slider); UiGroup("Material4/Detail Damage/32"); >;
	float g_fGrimeBrightness4 < Range(-1, 3); UiType(Slider); UiGroup("Material4/Grunge/32"); >;
	CreateInputTexture2D(TextureSubstrateHeight4, Linear, 8, "", "_height", "Material4/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight4, Linear, 8, "", "_height", "Material4/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateMetalness4, Srgb, 8, "", "_metal", "Material4/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness4, Linear, 8, "", "_metal", "Material4/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material4/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax4 < Default(0); UiType(VectorText); UiGroup("Material4/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask4, Srgb, 8, "", "_mask", "Material4/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask4, Linear, 8, "", "_mask", "Material4/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy4 < UiType(Slider); UiGroup("Material4/Damage Bevel/41"); >;
	float2 g_vSubstrateBurnishingMinMax4 < Default(0); UiType(VectorText); UiGroup("Material4/Burnishing/41"); >;
	float g_fDamageBevelMetalness4 < UiType(Slider); UiGroup("Material4/Damage Bevel/50"); >;
	float g_fDamageBevelCloth4 < UiType(Slider); UiGroup("Material4/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate4 < UiType(CheckBox); UiGroup("Material4/Damage Bevel/80"); >;
	
	// Composite Inputs
	CreateInputTexture2D(TextureObjectNormal, Linear, 8, "", "_normal", "Composite Inputs,0/Object Textures,1/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TexturePatternColor, Srgb, 8, "", "_color", "Composite Inputs/Pattern,200/0", Default4(0, 0, 0, 1));
	float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/Wear/0"); Expression(SrgbLinearToGamma(this)); >;
	CreateInputTexture2D(TextureLayerMask, Linear, 8, "", "_mask", "Composite Inputs,5/1", Default4(0, 0, 0, 1));
	CreateInputTexture2D(TextureNormal, Linear, 8, "", "_normal", "Composite Inputs/1", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureObjectAmbientOcclusion, Linear, 8, "", "_ao", "Composite Inputs/Object Textures/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureObjectTintId, Linear, 8, "", "_tintid", "Composite Inputs/Tint by ID,100/1", Default4(0, 0, 0, 1));
	CreateInputTexture2D(TexturePattern, Linear, 8, "", "_pattern", "Composite Inputs/Pattern,3/1", Default4(0, 0, 0, 1));
	CreateInputTexture2D(TextureSurfaceProperties, Linear, 8, "", "_ao", "Composite Inputs/1", Default4(0.5, 1, 0, 0.5));
	float3 g_vColorTint1 < Default3(0.15, 0.11, 0.08); UiType(Color); UiGroup("Composite Inputs/Palette,4/1"); >;
	CreateInputTexture2D(TextureObjectCurvature, Linear, 8, "", "_curvature", "Composite Inputs/Object Textures/2", Default4(0.5, 0.5, 0.5, 0));
	bool g_bFlipFixup < UiType(CheckBox); UiGroup("Composite Inputs/Pattern/2"); >;
	float g_fColorMaskBlur < Default(2); Range(0.5, 2); UiType(Slider); UiGroup("Composite Inputs/2"); >;
	float3 g_vColorTint2 < Default3(0.23, 0.16, 0.26); UiType(Color); UiGroup("Composite Inputs/Palette/2"); >;
	CreateInputTexture2D(TextureObjectHighTouchMask, Linear, 8, "", "_mask", "Composite Inputs/Object Textures/3", Default4(0, 0, 0, 0));
	float g_fPatternTexCoordScale < Default(2.5); Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/Pattern/3"); UiVisibility(F_PATTERN); >;
	float3 g_vColorTint3 < Default3(0.16, 0.16, 0.28); UiType(Color); UiGroup("Composite Inputs/Palette/3"); >;
	float g_fPatternTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Pattern/4"); UiVisibility(F_PATTERN); >;
	float3 g_vColorTint4 < Default3(0.2, 0.3, 0.3); UiType(Color); UiGroup("Composite Inputs/Palette/4"); >;
	CreateInputTexture2D(TextureObjectMaterialId, Linear, 8, "", "_materialid", "Composite Inputs/Object Textures/5", Default4(0, 0, 0, 1));
	float2 g_fPatternTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Pattern/5"); UiVisibility(F_PATTERN); >;
	float3 g_vColorTint5 < Default3(0.09, 0.16, 0.1); UiType(Color); UiGroup("Composite Inputs/Palette/5"); >;
	float3 g_vColorTint6 < Default3(0.29, 0.26, 0.11); UiType(Color); UiGroup("Composite Inputs/Palette/6"); >;
	float3 g_vColorTint7 < Default3(0.32, 0.22, 0.12); UiType(Color); UiGroup("Composite Inputs/Palette/7"); >;
	CreateInputTexture2D(TextureNoise, Linear, 8, "", "", "Composite Inputs/8", "materials/default/gloves/textiles/noise.psd");
	float3 g_vColorTint8 < Default3(0.21, 0.12, 0.09); UiType(Color); UiGroup("Composite Inputs/Palette/8"); >;
	int4 g_vPatternPaletteIndices < Default4(5, 6, 7, 8); Range4(1, 1, 1, 1, 8, 8, 8, 8); UiType(VectorText); UiGroup("Composite Inputs/Palette/9"); UiVisibility(F_PATTERN); >;
	CreateInputTexture2D(TexturePatternTranslucency, Linear, 8, "", "_trans", "Composite Inputs/Pattern,200/10", Default4(1, 1, 1, 1));
	float g_fPatternTranslucencyThreshold < Default(0.01); UiType(Slider); UiGroup("Composite Inputs/Pattern/11"); UiVisibility(F_PUFFY_PAINT); >;
	float4 g_vId1Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/11"); Expression(SrgbGammaToLinear(this)); >;
	bool g_fPatternPaintRespectsTintMask < UiType(CheckBox); UiGroup("Composite Inputs/Pattern/12"); UiVisibility(F_PATTERN && !F_PUFFY_PAINT); >;
	float g_flSheenScale < Default(0.667); Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/12"); UiVisibility(F_CLOTH_SHADING); >;
	float4 g_vId2Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/12"); Expression(SrgbGammaToLinear(this)); >;
	float g_fGrungeTexCoordScale < Default(2.5); Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/13"); >;
	float4 g_vId3Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/13"); Expression(SrgbGammaToLinear(this)); >;
	float g_fGrungeTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/14"); >;
	float g_fPaintThickness < Default(1); Range(0, 3); UiType(Slider); UiGroup("Composite Inputs/Pattern/14"); UiVisibility(F_PATTERN); >;
	float4 g_vId4Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/14"); Expression(SrgbGammaToLinear(this)); >;
	float2 g_fGrungeTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/15"); >;
	float g_fPaintDurability < Default(0.5); UiType(Slider); UiGroup("Composite Inputs/Pattern/15"); UiVisibility(F_PATTERN); >;
	float4 g_vId5Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/15"); Expression(SrgbGammaToLinear(this)); >;
	float g_fPatternDetailInfluence < Range(-64, 64); UiType(Slider); UiGroup("Composite Inputs/Pattern/16"); UiVisibility(F_PATTERN); >;
	float4 g_vId6Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/16"); Expression(SrgbGammaToLinear(this)); >;
	float g_fPatternRoughnessBrightness < Default(1); Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/Pattern/17"); UiVisibility(F_PATTERN); >;
	float4 g_vId7Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/17"); Expression(SrgbGammaToLinear(this)); >;
	float g_fPatternMetalness < UiType(Slider); UiGroup("Composite Inputs/Pattern/18"); UiVisibility(F_PATTERN); >;
	float4 g_vId8Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/18"); Expression(SrgbGammaToLinear(this)); >;
	int g_nPatternReplaceIndex < Default(1); Range(1, 8); UiType(Slider); UiGroup("Composite Inputs/Pattern/19"); Expression(this-1); UiVisibility(F_PATTERN); >;
	CreateInputTexture2D(TexturePatternMetalness, Linear, 8, "", "_metal", "Composite Inputs/Pattern/20", Default4(0, 0, 0, 1));
	int g_nPatternMode < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=Indexed,1=Unmasked Indexed,2=Bitmap,3=Unmasked Bitmap"); UiType(Enum); UiGroup("Composite Inputs/Pattern/20"); UiVisibility(F_PATTERN); >;
	float g_fPatternEmboss < Default(0.5); Range(-4, 4); UiType(Slider); UiGroup("Composite Inputs/Pattern/30"); UiVisibility(F_PUFFY_PAINT); >;
	float g_fPuffyPaintNormalSoftness < Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/Pattern/31"); UiVisibility(F_PUFFY_PAINT); >;
	float g_fWearExponent < Default(1); UiType(Slider); UiGroup("Composite Inputs/49"); >;
	float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/50"); Expression(pow(this,g_fWearExponent)); >;
	float2 g_vPatternRoughnessContrastBrightness < Default(1); Range2(0, -0.5, 2, 0.5); UiType(VectorText); UiGroup("Composite Inputs/Pattern/84"); UiVisibility(F_PATTERN && F_PATTERN_PAINT==0); >;
	CreateInputTexture2D(TexturePatternRoughness, Linear, 8, "", "_rough", "Composite Inputs/Pattern/85", Default4(0.5, 0.5, 0.5, 1));
	float g_fPatternCloth < UiType(Slider); UiGroup("Composite Inputs/Pattern/88"); UiVisibility(F_PATTERN && F_PATTERN_PAINT==1); >;
	float g_fSubstratePatternMipBias < Range(0, 8); UiType(Slider); UiGroup("Composite Inputs/Pattern/88"); UiVisibility(F_PATTERN && !F_PATTERN_PAINT); >;
	bool g_bId1Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/101"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId2Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/102"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId3Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/103"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId4Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/104"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId5Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/105"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId6Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/106"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId7Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/107"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId8Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/108"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	
	#if (S_BACKWARDS_COMPATIBILITY == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureObjectNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
		Texture2D g_tPattern < Channel(RGB, Box(TexturePatternColor), Srgb); Channel(A, Box(TexturePatternTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/Wear/0"); Expression(SrgbLinearToGamma(this)); >;
	#endif
	#if (S_TINT_ID == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureObjectNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
		Texture2D g_tPattern < Channel(RGB, Box(TexturePatternColor), Srgb); Channel(A, Box(TexturePatternTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/Wear/0"); Expression(SrgbLinearToGamma(this)); >;
	#endif
	
	// Variant parameters
	float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/50"); Expression(pow(this,g_fWearExponent)); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tPattern < Channel(RGBA, Box(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
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
	
	const vec3 _1329[9] = vec3[](vec3(0.0, 0.0, 0.31972789764404296875), vec3(-1.0, -1.0, 0.051020406186580657958984375), vec3(-1.0, 0.0, 0.119047619402408599853515625), vec3(-1.0, 1.0, 0.051020406186580657958984375), vec3(0.0, -1.0, 0.119047619402408599853515625), vec3(0.0, 1.0, 0.119047619402408599853515625), vec3(1.0, -1.0, 0.051020406186580657958984375), vec3(1.0, 0.0, 0.119047619402408599853515625), vec3(1.0, 1.0, 0.051020406186580657958984375));
	const vec2 _592[4] = vec2[](vec2(-1.0), vec2(-1.0, 1.0), vec2(1.0), vec2(1.0, -1.0));
	vec3 _2;
	
	struct _2422
	{
	    int g_bPattern;
	    float g_flSheenScale;
	    int g_nOutputMode;
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
	    float g_fColorMaskBlur;
	    float g_fFlipFixup;
	    vec4 g_vPatternTexCoordXform0;
	    vec4 g_vPatternTexCoordXform1;
	    vec4 g_vPatternTexRotationXform0;
	    vec4 g_vPatternTexRotationXform1;
	    float g_fPatternRoughnessBrightness;
	    float g_fPatternMetalness;
	    float g_fPaintThickness;
	    float g_fPaintDurability;
	    float g_fPaintShadowPower;
	    float g_fPatternDetailInfluence;
	    int g_nPatternReplaceIndex;
	    int g_nPatternMode;
	    vec3 g_vColorTint1;
	    vec3 g_vColorTint2;
	    vec3 g_vColorTint3;
	    vec3 g_vColorTint4;
	    vec3 g_vColorTint5;
	    vec3 g_vColorTint6;
	    vec3 g_vColorTint7;
	    vec3 g_vColorTint8;
	    ivec4 g_vPatternPaletteIndices;
	    float g_fDetailBlackPoint2;
	    float g_fDetailBlackPointCompensation2;
	    float g_fDetailScale2;
	    float g_fDetailRoughnessContrast2;
	    float g_fDetailRoughnessBrightness2;
	    float g_fDetailMetalness2;
	    float g_fDetailCloth2;
	    float g_fDetailNormalContrast2;
	    vec2 g_vDamageLevels2;
	    float g_fDamageRoughnessContrast2;
	    float g_fDamageRoughnessBrightness2;
	    float g_fDamageSaturation2;
	    float g_fDamageBrightness2;
	    float g_fDamageMetalness2;
	    float g_fDamageCloth2;
	    float g_fDamageBleaching2;
	    float g_fCurvaturePower2;
	    float g_fCurvatureWearBoost2;
	    float g_fDamageNormalEdgeWidth2;
	    float g_fDamageEdgeRoughness2;
	    float g_fDamageEdgeMetalness2;
	    float g_fDetailGrunge2;
	    float g_fGrungeMax2;
	    float g_fGrungeRoughnessBrightness2;
	    float g_fWearBleaching2;
	    float g_fGrimeSaturation2;
	    float g_fGrimeBrightness2;
	    float g_fDetailBlackPoint3;
	    float g_fDetailBlackPointCompensation3;
	    float g_fDetailScale3;
	    float g_fDetailRoughnessContrast3;
	    float g_fDetailRoughnessBrightness3;
	    float g_fDetailMetalness3;
	    float g_fDetailCloth3;
	    float g_fDetailNormalContrast3;
	    vec2 g_vDamageLevels3;
	    float g_fDamageRoughnessContrast3;
	    float g_fDamageRoughnessBrightness3;
	    float g_fDamageSaturation3;
	    float g_fDamageBrightness3;
	    float g_fDamageMetalness3;
	    float g_fDamageCloth3;
	    float g_fDamageBleaching3;
	    float g_fCurvaturePower3;
	    float g_fCurvatureWearBoost3;
	    float g_fDamageNormalEdgeWidth3;
	    float g_fDamageEdgeRoughness3;
	    float g_fDamageEdgeMetalness3;
	    float g_fDetailGrunge3;
	    float g_fGrungeMax3;
	    float g_fGrungeRoughnessBrightness3;
	    float g_fWearBleaching3;
	    float g_fGrimeSaturation3;
	    float g_fGrimeBrightness3;
	    float g_fDetailBlackPoint4;
	    float g_fDetailBlackPointCompensation4;
	    float g_fDetailScale4;
	    float g_fDetailRoughnessContrast4;
	    float g_fDetailRoughnessBrightness4;
	    float g_fDetailMetalness4;
	    float g_fDetailCloth4;
	    float g_fDetailNormalContrast4;
	    vec2 g_vDamageLevels4;
	    float g_fDamageRoughnessContrast4;
	    float g_fDamageRoughnessBrightness4;
	    float g_fDamageSaturation4;
	    float g_fDamageBrightness4;
	    float g_fDamageMetalness4;
	    float g_fDamageCloth4;
	    float g_fDamageBleaching4;
	    float g_fCurvaturePower4;
	    float g_fCurvatureWearBoost4;
	    float g_fDamageNormalEdgeWidth4;
	    float g_fDamageEdgeRoughness4;
	    float g_fDamageEdgeMetalness4;
	    float g_fDetailGrunge4;
	    float g_fGrungeMax4;
	    float g_fGrungeRoughnessBrightness4;
	    float g_fWearBleaching4;
	    float g_fGrimeSaturation4;
	    float g_fGrimeBrightness4;
	};
	
	layout(set = 1) uniform _2422 _Globals_;
	
	layout(set = 1, binding = 37) uniform texture2D g_tLayerMask;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 30) uniform texture2D g_tSurface;
	layout(set = 1, binding = 33) uniform texture2D g_tDetail1;
	layout(set = 1, binding = 39) uniform texture2D g_tDetail2;
	layout(set = 1, binding = 43) uniform texture2D g_tDetail3;
	layout(set = 1, binding = 47) uniform texture2D g_tDetail4;
	layout(set = 1, binding = 36) uniform texture2D g_tGrunge1;
	layout(set = 1, binding = 42) uniform texture2D g_tGrunge2;
	layout(set = 1, binding = 46) uniform texture2D g_tGrunge3;
	layout(set = 1, binding = 50) uniform texture2D g_tGrunge4;
	layout(set = 1, binding = 32) uniform texture2D g_tNoise;
	layout(set = 1, binding = 15) uniform sampler g_sAniso;
	layout(set = 1, binding = 31) uniform texture2D g_tNormal;
	layout(set = 1, binding = 34) uniform texture2D g_tDetailNormal1;
	layout(set = 1, binding = 40) uniform texture2D g_tDetailNormal2;
	layout(set = 1, binding = 44) uniform texture2D g_tDetailNormal3;
	layout(set = 1, binding = 48) uniform texture2D g_tDetailNormal4;
	layout(set = 1, binding = 35) uniform texture2D g_tDamageNormal1;
	layout(set = 1, binding = 41) uniform texture2D g_tDamageNormal2;
	layout(set = 1, binding = 45) uniform texture2D g_tDamageNormal3;
	layout(set = 1, binding = 49) uniform texture2D g_tDamageNormal4;
	layout(set = 1, binding = 14) uniform sampler g_sPoint;
	layout(set = 1, binding = 38) uniform texture2D g_tPattern;
	
	layout(location = 0) in vec4 input_0;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec2 _13810 = input_0.xy;
	    vec4 _21836 = texture(sampler2D(g_tLayerMask, g_sTrilinearWrap), input_0.xy);
	    float _13915 = _21836.x;
	    float _21941 = _21836.y;
	    float _24699 = _21836.z;
	    float _22165 = mix(mix(mix(_Globals_.g_fDetailMetalness1, _Globals_.g_fDetailMetalness2, _13915), _Globals_.g_fDetailMetalness3, _21941), _Globals_.g_fDetailMetalness4, _24699);
	    vec2 _8506 = vec2(_13915);
	    vec2 _14169 = vec2(_21941);
	    vec2 _13884 = vec2(_24699);
	    vec2 _7502 = mix(mix(mix(_Globals_.g_vDamageLevels1, _Globals_.g_vDamageLevels2, _8506), _Globals_.g_vDamageLevels3, _14169), _Globals_.g_vDamageLevels4, _13884);
	    float _22168 = mix(mix(mix(_Globals_.g_fDamageSaturation1, _Globals_.g_fDamageSaturation2, _13915), _Globals_.g_fDamageSaturation3, _21941), _Globals_.g_fDamageSaturation4, _24699);
	    float _22171 = mix(mix(mix(_Globals_.g_fDamageNormalEdgeWidth1, _Globals_.g_fDamageNormalEdgeWidth2, _13915), _Globals_.g_fDamageNormalEdgeWidth3, _21941), _Globals_.g_fDamageNormalEdgeWidth4, _24699);
	    float _22174 = mix(mix(mix(_Globals_.g_fDetailGrunge1, _Globals_.g_fDetailGrunge2, _13915), _Globals_.g_fDetailGrunge3, _21941), _Globals_.g_fDetailGrunge4, _24699);
	    float _22177 = mix(mix(mix(_Globals_.g_fGrimeSaturation1, _Globals_.g_fGrimeSaturation2, _13915), _Globals_.g_fGrimeSaturation3, _21941), _Globals_.g_fGrimeSaturation4, _24699);
	    vec2 _22248 = _13810;
	    _22248.x = input_0.x * _Globals_.g_fFlipFixup;
	    vec4 _18992 = texture(sampler2D(g_tSurface, g_sTrilinearWrap), input_0.xy);
	    float _18168 = _18992.x;
	    float _14997 = pow(_18168, mix(mix(mix(_Globals_.g_fCurvaturePower1, _Globals_.g_fCurvaturePower2, _13915), _Globals_.g_fCurvaturePower3, _21941), _Globals_.g_fCurvaturePower4, _24699));
	    float _20235 = _18992.y;
	    float _24805 = _18992.z;
	    float _22201 = _18992.w;
	    vec2 _22630 = (_13810 * mix(mix(mix(_Globals_.g_fDetailScale1, _Globals_.g_fDetailScale2, _13915), _Globals_.g_fDetailScale3, _21941), _Globals_.g_fDetailScale4, _24699)).xy;
	    vec4 _19414 = texture(sampler2D(g_tDetail1, g_sTrilinearWrap), _22630);
	    vec2 _14800 = vec2(_Globals_.g_fDetailBlackPoint1);
	    vec2 _7443 = _14800 + (_19414.xy * _Globals_.g_fDetailBlackPointCompensation1);
	    vec4 _20488 = _19414;
	    _20488.x = _7443.x;
	    _20488.y = _7443.y;
	    vec4 _19415 = texture(sampler2D(g_tDetail2, g_sTrilinearWrap), _22630);
	    vec2 _7444 = vec2(_Globals_.g_fDetailBlackPoint2) + (_19415.xy * _Globals_.g_fDetailBlackPointCompensation2);
	    vec4 _20489 = _19415;
	    _20489.x = _7444.x;
	    _20489.y = _7444.y;
	    vec4 _19416 = texture(sampler2D(g_tDetail3, g_sTrilinearWrap), _22630);
	    vec2 _7445 = vec2(_Globals_.g_fDetailBlackPoint3) + (_19416.xy * _Globals_.g_fDetailBlackPointCompensation3);
	    vec4 _20490 = _19416;
	    _20490.x = _7445.x;
	    _20490.y = _7445.y;
	    vec4 _19417 = texture(sampler2D(g_tDetail4, g_sTrilinearWrap), _22630);
	    vec2 _7446 = vec2(_Globals_.g_fDetailBlackPoint4) + (_19417.xy * _Globals_.g_fDetailBlackPointCompensation4);
	    vec4 _20491 = _19417;
	    _20491.x = _7446.x;
	    _20491.y = _7446.y;
	    vec4 _21174 = vec4(_13915);
	    vec4 _14170 = vec4(_21941);
	    vec4 _14150 = vec4(_24699);
	    vec4 _6543 = mix(mix(mix(_20488.xyzw, _20489.xyzw, _21174), _20490.xyzw, _14170), _20491.xyzw, _14150);
	    vec2 _24074 = _14800 + (_6543.xy * _Globals_.g_fDetailBlackPointCompensation1);
	    float _10152 = _24074.x;
	    float _10579 = _24074.y;
	    float _14189 = _6543.z;
	    vec2 _23217 = vec2(dot(_22248.xy, _Globals_.g_vPatternTexCoordXform0.xy) + _Globals_.g_vPatternTexCoordXform0.w, dot(_22248.xy, _Globals_.g_vPatternTexCoordXform1.xy) + _Globals_.g_vPatternTexCoordXform1.w) + vec2((((_10579 * 2.0) - 1.0) * 0.0009765625) * _Globals_.g_fPatternDetailInfluence);
	    _23217.x = _23217.x * ((input_0.x < 0.0) ? (-1.0) : 1.0);
	    float _21717 = 1.0 - _6543.w;
	    float _7730 = saturate(((mix(mix(mix(_Globals_.g_fDetailRoughnessContrast1, _Globals_.g_fDetailRoughnessContrast2, _13915), _Globals_.g_fDetailRoughnessContrast3, _21941), _Globals_.g_fDetailRoughnessContrast4, _24699) * (((_21717 * _21717) * 0.85000002384185791015625) + (-0.3499999940395355224609375))) + 0.5) * mix(mix(mix(_Globals_.g_fDetailRoughnessBrightness1, _Globals_.g_fDetailRoughnessBrightness2, _13915), _Globals_.g_fDetailRoughnessBrightness3, _21941), _Globals_.g_fDetailRoughnessBrightness4, _24699));
	    float _17411 = 1.0 - _10152;
	    vec2 _15902 = vec2(dot(_13810, _Globals_.g_vGrungeTexCoordXform0.xy) + _Globals_.g_vGrungeTexCoordXform0.w, dot(_13810, _Globals_.g_vGrungeTexCoordXform1.xy) + _Globals_.g_vGrungeTexCoordXform1.w).xy;
	    vec4 _19338 = texture(sampler2D(g_tGrunge1, g_sTrilinearWrap), _15902);
	    vec4 _19339 = texture(sampler2D(g_tGrunge2, g_sTrilinearWrap), _15902);
	    vec4 _19340 = texture(sampler2D(g_tGrunge3, g_sTrilinearWrap), _15902);
	    vec4 _18453 = texture(sampler2D(g_tGrunge4, g_sTrilinearWrap), _15902);
	    vec4 _19739 = mix(mix(mix(_19338.xyzw, _19339.xyzw, _21174), _19340.xyzw, _14170), _18453.xyzw, _14150);
	    vec3 _12690 = _19739.xyz;
	    float _17907 = dot(_12690, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec4 _22452 = texture(sampler2D(g_tNoise, g_sAniso), (_13810 * 2.0).xy);
	    vec4 _19372 = texture(sampler2D(g_tNormal, g_sAniso), input_0.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11176 = _16000 - _19720;
	    vec3 _17934 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    vec4 _19341 = texture(sampler2D(g_tDetailNormal1, g_sTrilinearWrap), _22630);
	    vec4 _19342 = texture(sampler2D(g_tDetailNormal2, g_sTrilinearWrap), _22630);
	    vec4 _19343 = texture(sampler2D(g_tDetailNormal3, g_sTrilinearWrap), _22630);
	    vec4 _18454 = texture(sampler2D(g_tDetailNormal4, g_sTrilinearWrap), _22630);
	    vec2 _19777 = mix(mix(mix(_19341.xy, _19342.xy, _8506), _19343.xy, _14169), _18454.xy, _13884);
	    float _22845 = _19777.x;
	    float _18662 = _19777.y;
	    float _16784 = (_22845 + _18662) - 1.00392162799835205078125;
	    float _11177 = _22845 - _18662;
	    vec3 _17935 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177)));
	    vec4 _19344 = texture(sampler2D(g_tDamageNormal1, g_sTrilinearWrap), _22630);
	    vec4 _19345 = texture(sampler2D(g_tDamageNormal2, g_sTrilinearWrap), _22630);
	    vec4 _19346 = texture(sampler2D(g_tDamageNormal3, g_sTrilinearWrap), _22630);
	    vec4 _18455 = texture(sampler2D(g_tDamageNormal4, g_sTrilinearWrap), _22630);
	    vec2 _19778 = mix(mix(mix(_19344.xy, _19345.xy, _8506), _19346.xy, _14169), _18455.xy, _13884);
	    float _22846 = _19778.x;
	    float _18663 = _19778.y;
	    float _16785 = (_22846 + _18663) - 1.00392162799835205078125;
	    float _11178 = _22846 - _18663;
	    float _16408[8] = float[](0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	    int _21567;
	    int _13039 = 0;
	    for (;;)
	    {
	        if (!(_13039 < 9))
	        {
	            break;
	        }
	        vec4 _22564 = texture(sampler2D(g_tLayerMask, g_sPoint), (_13810 + ((_1329[_13039].xy * 0.0009765625) * _Globals_.g_fColorMaskBlur)).xy);
	        float _8268 = _22564.w;
	        int _23989;
	        int _13040 = 0;
	        for (;;)
	        {
	            if (!(_13040 < 8))
	            {
	                break;
	            }
	            if (float(_13040) == floor(_8268 * 8.0))
	            {
	                _16408[_13040] += _1329[_13039].z;
	            }
	            _23989 = _13040 + 1;
	            _13040 = _23989;
	            continue;
	        }
	        _21567 = _13039 + 1;
	        _13039 = _21567;
	        continue;
	    }
	    bool _14874 = _Globals_.g_bPattern != 0;
	    vec3 _12724;
	    float _13137;
	    float _16306;
	    float _17117;
	    vec3 _17118;
	    float _17119;
	    float _17120;
	    float _17121;
	    float _23554;
	    SPIRV_CROSS_BRANCH
	    if (_14874)
	    {
	        bool _12885;
	        if (_Globals_.g_nPatternMode == 1)
	        {
	            _12885 = true;
	        }
	        else
	        {
	            _12885 = _Globals_.g_nPatternMode == 3;
	        }
	        float _19287;
	        SPIRV_CROSS_BRANCH
	        if (_12885)
	        {
	            _19287 = 1.0;
	        }
	        else
	        {
	            _19287 = _16408[_Globals_.g_nPatternReplaceIndex];
	        }
	        vec4 _21760 = texture(sampler2D(g_tPattern, g_sTrilinearWrap), _23217.xy);
	        vec3 _16442[8] = vec3[](_Globals_.g_vColorTint1, _Globals_.g_vColorTint2, _Globals_.g_vColorTint3, _Globals_.g_vColorTint4, _Globals_.g_vColorTint5, _Globals_.g_vColorTint6, _Globals_.g_vColorTint7, _Globals_.g_vColorTint8);
	        float _6616;
	        float _13136;
	        vec3 _13694;
	        float _16305;
	        vec3 _17114;
	        float _17115;
	        float _17116;
	        SPIRV_CROSS_BRANCH
	        if (_Globals_.g_nPatternMode < 2)
	        {
	            float _13819 = _21760.x;
	            float _19482 = _21760.y;
	            float _19483 = _21760.z;
	            float _9865 = (_13819 + _19482) + _19483;
	            float _10776;
	            SPIRV_CROSS_BRANCH
	            if (_Globals_.g_fPaintThickness > 0.0)
	            {
	                vec4 _20322 = texture(sampler2D(g_tPattern, g_sTrilinearWrap), _23217.xy, 0.5 + (0.100000001490116119384765625 * _Globals_.g_fPaintThickness));
	                _10776 = pow(mix(1.0, (mix(pow(1.0 - _20322.x, _Globals_.g_fPaintShadowPower), 1.0, _13819) * mix(pow(1.0 - _20322.y, _Globals_.g_fPaintShadowPower), 1.0, _19482)) * mix(pow(1.0 - _20322.z, _Globals_.g_fPaintShadowPower), 1.0, _19483), _19287), 0.20000000298023223876953125);
	            }
	            else
	            {
	                _10776 = 1.0;
	            }
	            float _16230 = (saturate(_9865) * _19287) * saturate(_Globals_.g_fPaintThickness - (_14189 * pow(_Globals_.g_fWearProgress, 4.0)));
	            float _21772 = _16230 * min(1.0, _Globals_.g_fPaintThickness);
	            _13136 = _22201 - (_21772 * _Globals_.g_fPaintDurability);
	            _16305 = mix(_10579, 0.5, _16230);
	            _17114 = mix(_17935, vec3(0.0, 0.0, 1.0), vec3(_21772));
	            _17115 = _9865 * _Globals_.g_fPaintThickness;
	            _17116 = _10776;
	            _13694 = mix(mix(mix(_16442[_Globals_.g_vPatternPaletteIndices.x - 1], _16442[_Globals_.g_vPatternPaletteIndices.y - 1], vec3(_13819)), _16442[_Globals_.g_vPatternPaletteIndices.z - 1], vec3(_19482)), _16442[_Globals_.g_vPatternPaletteIndices.w - 1], vec3(_19483));
	            _6616 = _7730 * mix(1.0, _Globals_.g_fPatternRoughnessBrightness, _21772);
	        }
	        else
	        {
	            _13136 = _22201;
	            _16305 = _10579;
	            _17114 = _17935;
	            _17115 = 1.0;
	            _17116 = 1.0;
	            _13694 = _21760.xyz;
	            _6616 = _7730;
	        }
	        _13137 = mix(_22165, _Globals_.g_fPatternMetalness, _19287);
	        _16306 = _13136;
	        _17117 = _16305;
	        _17118 = _17114;
	        _17119 = _19287;
	        _17120 = _17115;
	        _17121 = _17116;
	        _12724 = _13694;
	        _23554 = _6616;
	    }
	    else
	    {
	        _13137 = _22165;
	        _16306 = _22201;
	        _17117 = _10579;
	        _17118 = _17935;
	        _17119 = 1.0;
	        _17120 = 1.0;
	        _17121 = 1.0;
	        _12724 = vec3(0.0);
	        _23554 = _7730;
	    }
	    vec3 _23805 = (((((((_Globals_.g_vColorTint1 * _16408[0]) + (_Globals_.g_vColorTint2 * _16408[1])) + (_Globals_.g_vColorTint3 * _16408[2])) + (_Globals_.g_vColorTint4 * _16408[3])) + (_Globals_.g_vColorTint5 * _16408[4])) + (_Globals_.g_vColorTint6 * _16408[5])) + (_Globals_.g_vColorTint7 * _16408[6])) + (_Globals_.g_vColorTint8 * _16408[7]);
	    vec3 _18530 = _23805.xyz;
	    vec3 _14602 = _18530 * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((_18530 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (_23805.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _14602.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23805.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _14602.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19456;
	    if (_23805.z <= 0.040449999272823333740234375)
	    {
	        _19456 = _14602.z;
	    }
	    else
	    {
	        _19456 = _7676.z;
	    }
	    vec3 _15471 = vec3(_21354, _21355, _19456);
	    vec3 _10597 = _12724.xyz * vec3(0.077399380505084991455078125);
	    vec3 _7677 = pow((_12724.xyz * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21356;
	    if (_12724.x <= 0.040449999272823333740234375)
	    {
	        _21356 = _10597.x;
	    }
	    else
	    {
	        _21356 = _7677.x;
	    }
	    float _21357;
	    if (_12724.y <= 0.040449999272823333740234375)
	    {
	        _21357 = _10597.y;
	    }
	    else
	    {
	        _21357 = _7677.y;
	    }
	    float _20482;
	    if (_12724.z <= 0.040449999272823333740234375)
	    {
	        _20482 = _10597.z;
	    }
	    else
	    {
	        _20482 = _7677.z;
	    }
	    float _11428 = _14997 * _16306;
	    float _20765 = mix(mix(mix(_Globals_.g_fCurvatureWearBoost1, _Globals_.g_fCurvatureWearBoost2, _13915), _Globals_.g_fCurvatureWearBoost3, _21941), _Globals_.g_fCurvatureWearBoost4, _24699) * _14997;
	    float _12034 = saturate((_11428 * _19739.w) + _20765);
	    float _22935 = _7502.x;
	    float _11001 = _7502.y;
	    float _19034 = smoothstep(_22935, _11001, _12034 * _Globals_.g_fWearProgress);
	    float _9410 = 1.0 - _19034;
	    float _17292 = saturate(_19034 + ((saturate(smoothstep(_22935, _11001, _12034 * (_Globals_.g_fWearProgress * 4.0))) * _9410) * _14189));
	    vec3 _20940;
	    SPIRV_CROSS_BRANCH
	    if (_14874)
	    {
	        _20940 = mix(_15471, mix(vec3(_21356, _21357, _20482), _15471, vec3(_17292)), vec3(_17119));
	    }
	    else
	    {
	        _20940 = _15471;
	    }
	    float _23685 = dot(_20940.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _11002 = _17117 * _14997;
	    float _11013 = dFdx(_11002);
	    float _11026 = dFdy(_11002);
	    float _14908 = dFdx(_11002);
	    float _23784 = dFdy(_11002);
	    float _16103 = _10152 * _14997;
	    float _15058 = dFdx(_16103);
	    float _11027 = dFdy(_16103);
	    float _14909 = dFdx(_16103);
	    float _23785 = dFdy(_16103);
	    float _22514 = (_18168 + _20235) + _24805;
	    float _17067 = dFdx(_22514);
	    float _22105 = dFdy(_22514);
	    vec3 _18056 = max(_20940, _20940 * (1.0 + (_14997 * 0.5)));
	    float _19227 = min(1.0, mix(_17117, _10152, _17292) + ((mix(((1.0 - abs(_11013)) * (1.0 - abs(_11026))) * saturate(abs(_14908) + abs(_23784)), ((1.0 - abs(_15058)) * (1.0 - abs(_11027))) * saturate(abs(_14909) + abs(_23785)), _19034) * (1.0 - saturate(abs(_17067)))) * (1.0 - saturate(abs(_22105)))));
	    float _9287 = dot(vec4(_19227).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(_18056.xyz, vec3(0.001000000047497451305389404296875)));
	    vec3 _10951 = saturate((_9577 * min(_9287 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _9287) * max(_18056.x, max(_18056.y, _18056.z)))).xyz);
	    float _15624 = mix(((_Globals_.g_fWearProgress * _24805) * mix(mix(mix(_Globals_.g_fWearBleaching1, _Globals_.g_fWearBleaching2, _13915), _Globals_.g_fWearBleaching3, _21941), _Globals_.g_fWearBleaching4, _24699)) * mix(_14189, 0.0, saturate(_17120 - 1.0)), mix(mix(mix(_Globals_.g_fDamageBleaching1, _Globals_.g_fDamageBleaching2, _13915), _Globals_.g_fDamageBleaching3, _21941), _Globals_.g_fDamageBleaching4, _24699), _19034);
	    vec3 _10558;
	    do
	    {
	        if (_22177 > 0.0)
	        {
	            vec3 _22572 = normalize(_12690 * _17907).xyz - vec3(0.57700002193450927734375);
	            vec3 _7057 = saturate((normalize(_22572) * 2.0) + vec3(1.0)).xyz;
	            vec3 _15712 = _7057 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	            _10558 = mix(_12690, _7057 * (_17907 / ((_15712.x + _15712.y) + _15712.z)), vec3(saturate(_22177 * pow(abs(dot(_22572, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _10558 = mix(_12690, vec3(_17907), vec3(-_22177));
	            break;
	        }
	        break; // unreachable workaround
	    } while(false);
	    vec3 _23869 = (_10951 * _12690) * 2.0;
	    vec3 _16559 = mix(mix(_10951, _23869, vec3((_22174 * (1.0 + (_Globals_.g_fWearProgress * _22174))) * _9410)), (_10558 * (1.0 + mix(mix(mix(_Globals_.g_fGrimeBrightness1, _Globals_.g_fGrimeBrightness2, _13915), _Globals_.g_fGrimeBrightness3, _21941), _Globals_.g_fGrimeBrightness4, _24699))) * _19227, vec3(_15624));
	    vec3 _9452 = _16559.xyz;
	    vec3 _10559;
	    do
	    {
	        if (_22168 > 0.0)
	        {
	            vec3 _22573 = normalize(_20940.xyz * dot(_20940.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))).xyz - vec3(0.57700002193450927734375);
	            vec3 _7058 = saturate((normalize(_22573) * 2.0) + vec3(1.0)).xyz;
	            vec3 _15713 = _7058 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	            _10559 = mix(_9452, _7058 * (dot(_9452, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / ((_15713.x + _15713.y) + _15713.z)), vec3(saturate(_22168 * pow(abs(dot(_22573, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _10559 = mix(_9452, vec3(dot(_16559.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(-_22168));
	            break;
	        }
	        break; // unreachable workaround
	    } while(false);
	    vec3 _19489 = vec3(_19034);
	    vec3 _6932 = mix(_16559, _10559 * (1.0 + mix(mix(mix(_Globals_.g_fDamageBrightness1, _Globals_.g_fDamageBrightness2, _13915), _Globals_.g_fDamageBrightness3, _21941), _Globals_.g_fDamageBrightness4, _24699)), _19489);
	    vec3 _12529 = mix(_6932, _12690 * _6932, vec3((smoothstep(0.449999988079071044921875, 0.75, (1.0 - ((_18168 * _20235) * _20235)) * _Globals_.g_fWearProgress) * (1.0 - (_23685 * 0.5))) * mix(mix(mix(_Globals_.g_fGrungeMax1, _Globals_.g_fGrungeMax2, _13915), _Globals_.g_fGrungeMax3, _21941), _Globals_.g_fGrungeMax4, _24699)));
	    vec3 _7286 = _12529.xyz;
	    float _15036 = dot(_7286, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 0.5;
	    float _9533 = _12529.x;
	    float _16877 = _12529.y;
	    bool _12886;
	    if (_9533 > _16877)
	    {
	        _12886 = _9533 > _12529.z;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    vec3 _10970;
	    vec3 _12555;
	    if (_12886)
	    {
	        _10970 = vec3(0.60000002384185791015625, 1.0, 0.0) + _12529.zxy;
	        _12555 = vec3(0.20000000298023223876953125, 0.60000002384185791015625, 1.0) + _12529.zyx;
	    }
	    else
	    {
	        bool _12887;
	        if (_16877 > _9533)
	        {
	            _12887 = _16877 > _12529.z;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        vec3 _13212;
	        vec3 _15670;
	        if (_12887)
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
	    float _6982 = (pow(1.0 - _23685, 3.5) * 0.300000011920928955078125) + ((length(_12529 - vec3(_15036)) * 0.1500000059604644775390625) + 0.0500000007450580596923828125);
	    float _22476 = pow(_20235, 8.0);
	    vec3 _11286;
	    do
	    {
	        _21112 = _6982 > 0.0;
	        if (_21112)
	        {
	            vec3 _22574 = normalize(_12555.xyz * dot(_12555.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))).xyz - vec3(0.57700002193450927734375);
	            vec3 _7059 = saturate((normalize(_22574) * 2.0) + vec3(1.0)).xyz;
	            vec3 _15714 = _7059 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	            _11286 = mix(_7286, _7059 * (_15036 / ((_15714.x + _15714.y) + _15714.z)), vec3(saturate(_6982 * pow(abs(dot(_22574, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _11286 = mix(_7286, vec3(dot(_12529.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(-_6982));
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
	            _16611 = mix(_7286, _7060 * (_15036 / ((_15715.x + _15715.y) + _15715.z)), vec3(saturate(_6982 * pow(abs(dot(_22575, vec3(0.57700002193450927734375))), 0.20000000298023223876953125))));
	            break;
	        }
	        else
	        {
	            _16611 = mix(_7286, vec3(dot(_12529.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), vec3(-_6982));
	            break;
	        }
	        break; // unreachable workaround
	    } while(false);
	    vec3 _17278 = saturate(mix(mix(_11286, _16611, vec3(saturate(_22476 * _22452.x))), _12529, vec3(saturate(_22452.z * (0.5 + (_22476 * 0.5))))));
	    vec2 _13138;
	    float _16324;
	    _13138 = vec2(0.0);
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
	        vec2 _10548 = (_15902 + (((_592[_17017] * 0.0009765625) * _22171) * (1.0 + _17120))).xy;
	        float _24694 = _19034 - smoothstep(_22935, _11001, saturate((mix(mix(mix(texture(sampler2D(g_tGrunge1, g_sTrilinearWrap), _10548).w, texture(sampler2D(g_tGrunge2, g_sTrilinearWrap), _10548).w, _13915), texture(sampler2D(g_tGrunge3, g_sTrilinearWrap), _10548).w, _21941), texture(sampler2D(g_tGrunge4, g_sTrilinearWrap), _10548).w, _24699) * _11428) + _20765) * _Globals_.g_fWearProgress);
	        _10648 = _13138.xy - (_592[_17017] * _24694);
	        _14733 = _16324 + abs(_24694);
	        _18386 = _17017 + 1;
	        _13138 = _10648;
	        _16324 = _14733;
	        _17017 = _18386;
	        continue;
	    }
	    float _7827 = _16324 * 0.25;
	    vec2 _11392 = _13138.xy * (_22171 * 0.25);
	    vec2 _23775;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.g_nPatternMode < 2)
	    {
	        float _11401 = (0.0009765625 * _Globals_.g_fPaintThickness) * (1.0 - _7827);
	        vec2 _13155;
	        _13155 = vec2(0.0);
	        vec2 _11588;
	        int _11797;
	        int _16208 = 0;
	        for (;;)
	        {
	            if (!(_16208 < 4))
	            {
	                break;
	            }
	            vec4 _19373 = texture(sampler2D(g_tPattern, g_sTrilinearWrap), (_23217.xy + ((_592[_16208] * _11401) * 2.0)).xy);
	            float _16002 = _19373.x;
	            float _18770 = _19373.y;
	            float _14681 = _19373.z;
	            _11588 = _13155.xy - ((((_592[_16208] * (_17120 - (((_16002 + _18770) + _14681) * _Globals_.g_fPaintThickness))).xy * (saturate(_9410) * _17119)).xy * (1.0 - min(min(_16002, _14681 - min(_16002, _18770)), _18770 - _16002))) * 0.5);
	            _11797 = _16208 + 1;
	            _13155 = _11588;
	            _16208 = _11797;
	            continue;
	        }
	        float _6962 = dot(_13155.xy, _Globals_.g_vPatternTexRotationXform0.xy);
	        vec2 _8112 = vec2(_6962, dot(_13155.xy, _Globals_.g_vPatternTexRotationXform1.xy));
	        float _10826 = _6962 * _Globals_.g_fFlipFixup;
	        _8112.x = _10826;
	        vec2 _12501;
	        if (input_0.x > 0.0)
	        {
	            vec2 _21219 = _8112;
	            _21219.x = _10826 * (-1.0);
	            _12501 = _21219;
	        }
	        else
	        {
	            _12501 = _8112;
	        }
	        _23775 = _12501;
	    }
	    else
	    {
	        _23775 = vec2(0.0);
	    }
	    vec3 _24364 = mix(_17118, normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))), _19489);
	    vec2 _22606 = _24364.xy * mix(mix(mix(_Globals_.g_fDetailNormalContrast1, _Globals_.g_fDetailNormalContrast2, _13915), _Globals_.g_fDetailNormalContrast3, _21941), _Globals_.g_fDetailNormalContrast4, _24699);
	    vec3 _8673;
	    _8673.x = _22606.x;
	    _8673.y = _22606.y;
	    vec3 _10041 = normalize(vec3(((_17934.xy + _8673.xy) - vec2(-dot(_11392, _Globals_.g_vGrungeTexRotationXform0.xy), dot(_11392, _Globals_.g_vGrungeTexRotationXform1.xy)).xy) + _23775.xy, _17934.z));
	    float _19526 = mix(mix(_13137, mix(mix(mix(_Globals_.g_fDamageMetalness1, _Globals_.g_fDamageMetalness2, _13915), _Globals_.g_fDamageMetalness3, _21941), _Globals_.g_fDamageMetalness4, _24699), _19034), mix(mix(mix(_Globals_.g_fDamageEdgeMetalness1, _Globals_.g_fDamageEdgeMetalness2, _13915), _Globals_.g_fDamageEdgeMetalness3, _21941), _Globals_.g_fDamageEdgeMetalness4, _24699), _7827);
	    float _11543 = mix(mix(mix(mix(_Globals_.g_fDetailCloth1, _Globals_.g_fDetailCloth2, _13915), _Globals_.g_fDetailCloth3, _21941), _Globals_.g_fDetailCloth4, _24699), mix(mix(mix(_Globals_.g_fDamageCloth1, _Globals_.g_fDamageCloth2, _13915), _Globals_.g_fDamageCloth3, _21941), _Globals_.g_fDamageCloth4, _24699), max(_17292, _7827)) * (1.0 - _19526);
	    vec2 _22792 = mix(mix(vec2(1.0) * mix(min(1.0, _23554), (1.0 - _17907) + mix(mix(mix(_Globals_.g_fGrungeRoughnessBrightness1, _Globals_.g_fGrungeRoughnessBrightness2, _13915), _Globals_.g_fGrungeRoughnessBrightness3, _21941), _Globals_.g_fGrungeRoughnessBrightness4, _24699), _15624), vec2(saturate(((mix(mix(mix(_Globals_.g_fDamageRoughnessContrast1, _Globals_.g_fDamageRoughnessContrast2, _13915), _Globals_.g_fDamageRoughnessContrast3, _21941), _Globals_.g_fDamageRoughnessContrast4, _24699) * (((_17411 * _17411) * 0.85000002384185791015625) + (-0.3499999940395355224609375))) + 0.5) * mix(mix(mix(_Globals_.g_fDamageRoughnessBrightness1, _Globals_.g_fDamageRoughnessBrightness2, _13915), _Globals_.g_fDamageRoughnessBrightness3, _21941), _Globals_.g_fDamageRoughnessBrightness4, _24699))), vec2(_19034)).xy, vec2(mix(mix(mix(_Globals_.g_fDamageEdgeRoughness1, _Globals_.g_fDamageEdgeRoughness2, _13915), _Globals_.g_fDamageEdgeRoughness3, _21941), _Globals_.g_fDamageEdgeRoughness4, _24699)), vec2(_7827));
	    vec3 _7958 = normalize(max(vec3(0.0003000000142492353916168212890625), _17278.xyz));
	    vec3 _23898 = mix(_Globals_.g_vTextileAlbedoLevels.xyz, _Globals_.g_vMetallicTextileAlbedoLevels.xyz, vec3(_19526));
	    float _22205 = ((_20235 * pow(_24364.z, 0.20000000298023223876953125)) * (1.0 - (_16324 * 0.0500000007450580596923828125))) * mix(_17121, 1.0, _19034);
	    _10041.y = -_10041.y;
	    vec3 _23712 = normalize(_10041.xyz);
	    float _21931 = _22792.x;
	    vec4 _23727;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.g_nOutputMode == 0)
	    {
	        _23727 = vec4(mix(_17278.xyz, ((_7958.xyz * mix(min(_23898.x, dot(mix(_10951, _23869, vec3(_22174)).xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _23898.z, saturate(pow(max(_17278.x, max(_17278.y, _17278.z)), _23898.y)))) / vec3(max(_7958.x, max(_7958.y, _7958.z)))).xyz, vec3(_Globals_.g_fWearProgress)).xyz, 1.0);
	    }
	    else
	    {
	        vec4 _12504;
	        if (_Globals_.g_nOutputMode == 1)
	        {
	            float _8704 = _23712.y * (-1.0);
	            vec3 _8007 = _23712;
	            _8007.y = _8704;
	            vec3 _16929 = _8007.xyz / vec3((abs(_23712.x) + abs(_8704)) + abs(_23712.z));
	            float _10674 = _16929.x;
	            float _23725 = _16929.y;
	            vec2 _21979 = (vec2(_10674 + _23725, _10674 - _23725) * 0.5) + vec2(0.5);
	            vec3 _16637 = vec3(_21979.xy, _21931).xyz;
	            vec3 _10601 = _16637 * vec3(0.077399380505084991455078125);
	            vec3 _7679 = pow((_16637 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	            float _21358;
	            if (_21979.x <= 0.040449999272823333740234375)
	            {
	                _21358 = _10601.x;
	            }
	            else
	            {
	                _21358 = _7679.x;
	            }
	            float _23037;
	            if (_21979.y <= 0.040449999272823333740234375)
	            {
	                _23037 = _10601.y;
	            }
	            else
	            {
	                _23037 = _7679.y;
	            }
	            float _19478;
	            if (_21931 <= 0.040449999272823333740234375)
	            {
	                _19478 = _10601.z;
	            }
	            else
	            {
	                _19478 = _7679.z;
	            }
	            _12504 = vec4(vec3(_21358, _23037, _19478), 1.0);
	        }
	        else
	        {
	            vec4 _12503;
	            if (_Globals_.g_nOutputMode == 2)
	            {
	                vec3 _20866 = vec3(0.0, _19526, _11543).xyz;
	                vec3 _10600 = _20866 * vec3(0.077399380505084991455078125);
	                vec3 _7678 = pow((_20866 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	                float _23036;
	                if (_19526 <= 0.040449999272823333740234375)
	                {
	                    _23036 = _10600.y;
	                }
	                else
	                {
	                    _23036 = _7678.y;
	                }
	                float _19476;
	                if (_11543 <= 0.040449999272823333740234375)
	                {
	                    _19476 = _10600.z;
	                }
	                else
	                {
	                    _19476 = _7678.z;
	                }
	                _12503 = vec4(vec3(_10600.x, _23036, _19476), 1.0);
	            }
	            else
	            {
	                vec4 _12502;
	                if (_Globals_.g_nOutputMode == 3)
	                {
	                    vec3 _20865 = vec3(_22205).xyz;
	                    vec3 _10599 = _20865 * vec3(0.077399380505084991455078125);
	                    vec3 _9358 = pow((_20865 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	                    bool _17062 = _22205 <= 0.040449999272823333740234375;
	                    float _12888;
	                    if (_17062)
	                    {
	                        _12888 = _10599.x;
	                    }
	                    else
	                    {
	                        _12888 = _9358.x;
	                    }
	                    float _12889;
	                    if (_17062)
	                    {
	                        _12889 = _10599.y;
	                    }
	                    else
	                    {
	                        _12889 = _9358.y;
	                    }
	                    float _19475;
	                    if (_17062)
	                    {
	                        _19475 = _10599.z;
	                    }
	                    else
	                    {
	                        _19475 = _9358.z;
	                    }
	                    _12502 = vec4(vec3(_12888, _12889, _19475), 1.0);
	                }
	                else
	                {
	                    vec3 _16636 = vec3(_22792.xy, 0.0).xyz;
	                    vec3 _10598 = _16636 * vec3(0.077399380505084991455078125);
	                    vec3 _9357 = pow((_16636 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	                    float _23035;
	                    if (_21931 <= 0.040449999272823333740234375)
	                    {
	                        _23035 = _10598.x;
	                    }
	                    else
	                    {
	                        _23035 = _9357.x;
	                    }
	                    float _19302;
	                    if (_22792.y <= 0.040449999272823333740234375)
	                    {
	                        _19302 = _10598.y;
	                    }
	                    else
	                    {
	                        _19302 = _9357.y;
	                    }
	                    _12502 = vec4(vec3(_23035, _19302, _10598.z), 1.0);
	                }
	                _12503 = _12502;
	            }
	            _12504 = _12503;
	        }
	        _23727 = _12504;
	    }
	    vec4 _6805;
	    SPIRV_CROSS_BRANCH
	    if (_11543 < 0.0)
	    {
	        vec4 _18969 = _23727;
	        _18969.w = _Globals_.g_flSheenScale;
	        _6805 = _18969;
	    }
	    else
	    {
	        _6805 = _23727;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	IntAttribute(MaterialLayerCount, 4);
	StringAttribute(MaterialLayerRefType, csgo_textile_layer);
	
}
