// MHasKV3TransferPolymorphicClassname
class CBaseRendererSource2 : public CParticleFunctionRenderer
{
	// MPropertyStartGroup = "+Renderer Modifiers"
	// MPropertyFriendlyName = "radius scale"
	// MPropertySortPriority = 700
	CParticleCollectionRendererFloatInput m_flRadiusScale;
	// MPropertyFriendlyName = "alpha scale"
	// MPropertySortPriority = 700
	CParticleCollectionRendererFloatInput m_flAlphaScale;
	// MPropertyFriendlyName = "rotation roll scale"
	// MPropertySortPriority = 700
	CParticleCollectionRendererFloatInput m_flRollScale;
	// MPropertyFriendlyName = "per-particle alpha scale attribute"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySortPriority = 700
	ParticleAttributeIndex_t m_nAlpha2Field;
	// MPropertyFriendlyName = "color blend"
	// MPropertySortPriority = 700
	CParticleCollectionRendererVecInput m_vecColorScale;
	// MPropertyFriendlyName = "color blend type"
	// MPropertySortPriority = 700
	ParticleColorBlendType_t m_nColorBlendType;
	// MPropertyStartGroup = "+Material"
	// MPropertyFriendlyName = "Shader"
	// MPropertySortPriority = 600
	SpriteCardShaderType_t m_nShaderType;
	// MPropertyFriendlyName = "Custom Shader"
	// MPropertySuppressExpr = "m_nShaderType != SPRITECARD_SHADER_CUSTOM"
	// MPropertySortPriority = 600
	CUtlString m_strShaderOverride;
	// MPropertyFriendlyName = "X offset of center point"
	// MPropertySortPriority = 600
	CParticleCollectionRendererFloatInput m_flCenterXOffset;
	// MPropertyFriendlyName = "Y offset of center point"
	// MPropertySortPriority = 600
	CParticleCollectionRendererFloatInput m_flCenterYOffset;
	// MPropertyFriendlyName = "Bump Strength"
	// MPropertySortPriority = 600
	float32 m_flBumpStrength;
	// MPropertyFriendlyName = "Sheet Crop Behavior"
	// MPropertySortPriority = 600
	ParticleSequenceCropOverride_t m_nCropTextureOverride;
	// MPropertyFriendlyName = "Textures"
	// MParticleRequireDefaultArrayEntry
	// MPropertyAutoExpandSelf
	// MPropertySortPriority = 600
	CUtlLeanVector< TextureGroup_t > m_vecTexturesInput;
	// MPropertyStartGroup = "Animation"
	// MPropertyFriendlyName = "animation rate"
	// MPropertyAttributeRange = "0 5"
	// MPropertySortPriority = 500
	float32 m_flAnimationRate;
	// MPropertyFriendlyName = "animation type"
	// MPropertySortPriority = 500
	AnimationType_t m_nAnimationType;
	// MPropertyFriendlyName = "set animation value in FPS"
	// MPropertySortPriority = 500
	bool m_bAnimateInFPS;
	// MPropertyFriendlyName = "motion vector scale U"
	// MPropertySortPriority = 500
	CParticleCollectionRendererFloatInput m_flMotionVectorScaleU;
	// MPropertyFriendlyName = "motion vector scale V"
	// MPropertySortPriority = 500
	CParticleCollectionRendererFloatInput m_flMotionVectorScaleV;
	// MPropertyStartGroup = "Lighting and Shadows"
	// MPropertyFriendlyName = "self illum amount"
	// MPropertyAttributeRange = "0 2"
	// MPropertySortPriority = 400
	CParticleCollectionRendererFloatInput m_flSelfIllumAmount;
	// MPropertyFriendlyName = "diffuse lighting amount"
	// MPropertyAttributeRange = "0 1"
	// MPropertySortPriority = 400
	CParticleCollectionRendererFloatInput m_flDiffuseAmount;
	// MPropertyFriendlyName = "diffuse max contribution clamp"
	// MPropertyAttributeRange = "0 1"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != hlx"
	CParticleCollectionRendererFloatInput m_flDiffuseClamp;
	// MPropertyFriendlyName = "diffuse lighting origin Control Point"
	// MPropertySortPriority = 400
	int32 m_nLightingControlPoint;
	// MPropertyStartGroup = "+Color and alpha adjustments"
	// MPropertyFriendlyName = "output blend mode"
	// MPropertySortPriority = 300
	ParticleOutputBlendMode_t m_nOutputBlendMode;
	// MPropertyFriendlyName = "Gamma-correct vertex colors"
	// MPropertySortPriority = 300
	bool m_bGammaCorrectVertexColors;
	// MPropertyFriendlyName = "Saturate color pre alphablend"
	// MPropertySortPriority = 300
	// MPropertySuppressExpr = "mod != dota && mod != hlx"
	bool m_bSaturateColorPreAlphaBlend;
	// MPropertyFriendlyName = "add self amount over alphablend"
	// MPropertySortPriority = 300
	CParticleCollectionRendererFloatInput m_flAddSelfAmount;
	// MPropertyFriendlyName = "desaturation amount"
	// MPropertyAttributeRange = "0 1"
	// MPropertySortPriority = 300
	CParticleCollectionRendererFloatInput m_flDesaturation;
	// MPropertyFriendlyName = "overbright factor"
	// MPropertySortPriority = 300
	CParticleCollectionRendererFloatInput m_flOverbrightFactor;
	// MPropertyFriendlyName = "HSV Shift Control Point"
	// MPropertySortPriority = 300
	int32 m_nHSVShiftControlPoint;
	// MPropertyFriendlyName = "Apply fog to particle"
	// MPropertySortPriority = 300
	ParticleFogType_t m_nFogType;
	// MPropertyFriendlyName = "Fog Scale"
	// MPropertySortPriority = 300
	// MPropertySuppressExpr = "mod != hlx"
	CParticleCollectionRendererFloatInput m_flFogAmount;
	// MPropertyFriendlyName = "Apply fog of war to color"
	// MPropertySortPriority = 300
	// MPropertySuppressExpr = "mod != dota"
	bool m_bTintByFOW;
	// MPropertyFriendlyName = "Apply global light to color"
	// MPropertySortPriority = 300
	// MPropertySuppressExpr = "mod != dota"
	bool m_bTintByGlobalLight;
	// MPropertyStartGroup = "Color and alpha adjustments/Alpha Reference"
	// MPropertyFriendlyName = "alpha reference"
	// MPropertySortPriority = 300
	SpriteCardPerParticleScale_t m_nPerParticleAlphaReference;
	// MPropertyFriendlyName = "alpha reference window size"
	// MPropertySortPriority = 300
	SpriteCardPerParticleScale_t m_nPerParticleAlphaRefWindow;
	// MPropertyFriendlyName = "alpha reference type"
	// MPropertySortPriority = 300
	ParticleAlphaReferenceType_t m_nAlphaReferenceType;
	// MPropertyFriendlyName = "alpha reference softness"
	// MPropertyAttributeRange = "0 1"
	// MPropertySortPriority = 300
	CParticleCollectionRendererFloatInput m_flAlphaReferenceSoftness;
	// MPropertyFriendlyName = "source alpha value to map to alpha of zero"
	// MPropertyAttributeRange = "0 1"
	// MPropertySortPriority = 300
	CParticleCollectionRendererFloatInput m_flSourceAlphaValueToMapToZero;
	// MPropertyFriendlyName = "source alpha value to map to alpha of 1"
	// MPropertyAttributeRange = "0 1"
	// MPropertySortPriority = 300
	CParticleCollectionRendererFloatInput m_flSourceAlphaValueToMapToOne;
	// MPropertyStartGroup = "Refraction"
	// MPropertyFriendlyName = "refract background"
	// MPropertySortPriority = 200
	bool m_bRefract;
	// MPropertyFriendlyName = "refract draws opaque - alpha scales refraction"
	// MPropertySortPriority = 200
	// MPropertySuppressExpr = "!m_bRefract"
	bool m_bRefractSolid;
	// MPropertyFriendlyName = "refract in 2 passes - can refract particles behind, requires (MBOIT!)"
	// MPropertySortPriority = 200
	// MPropertySuppressExpr = "mod != hlx || !m_bRefract"
	bool m_bRefract2Passes;
	// MPropertyFriendlyName = "refract amount"
	// MPropertyAttributeRange = "-2 2"
	// MPropertySortPriority = 200
	// MPropertySuppressExpr = "!m_bRefract"
	CParticleCollectionRendererFloatInput m_flRefractAmount;
	// MPropertyFriendlyName = "refract blur radius"
	// MPropertySortPriority = 200
	// MPropertySuppressExpr = "!m_bRefract"
	int32 m_nRefractBlurRadius;
	// MPropertyFriendlyName = "refract blur type"
	// MPropertySortPriority = 200
	// MPropertySuppressExpr = "!m_bRefract"
	BlurFilterType_t m_nRefractBlurType;
	// MPropertyStartGroup = ""
	// MPropertyFriendlyName = "Only Render in effects bloom pass"
	// MPropertySortPriority = 1100
	bool m_bOnlyRenderInEffectsBloomPass;
	// MPropertyFriendlyName = "Only Render in effects water pass"
	// MPropertySortPriority = 1050
	// MPropertySuppressExpr = "mod != csgo && mod != hlx"
	bool m_bOnlyRenderInEffectsWaterPass;
	// MPropertyFriendlyName = "Use Mixed Resolution Rendering"
	// MPropertySortPriority = 1200
	bool m_bUseMixedResolutionRendering;
	// MPropertyFriendlyName = "Only Render in effects game overlay pass"
	// MPropertySortPriority = 1210
	// MPropertySuppressExpr = "mod != csgo"
	bool m_bOnlyRenderInEffecsGameOverlay;
	// MPropertyStartGroup = "Stencil"
	// MPropertyFriendlyName = "stencil test ID"
	// MPropertySortPriority = 0
	char[128] m_stencilTestID;
	// MPropertyFriendlyName = "only write where stencil is NOT stencil test ID"
	// MPropertySortPriority = 0
	bool m_bStencilTestExclude;
	// MPropertyFriendlyName = "stencil write ID"
	// MPropertySortPriority = 0
	char[128] m_stencilWriteID;
	// MPropertyFriendlyName = "write stencil on z-buffer test success"
	// MPropertySortPriority = 0
	bool m_bWriteStencilOnDepthPass;
	// MPropertyFriendlyName = "write stencil on z-buffer test failure"
	// MPropertySortPriority = 0
	bool m_bWriteStencilOnDepthFail;
	// MPropertyStartGroup = "Depth buffer control and effects"
	// MPropertyFriendlyName = "reverse z-buffer test"
	// MPropertySortPriority = 900
	bool m_bReverseZBuffering;
	// MPropertyFriendlyName = "disable z-buffer test"
	// MPropertySortPriority = 900
	bool m_bDisableZBuffering;
	// MPropertyFriendlyName = "Depth feathering mode"
	// MPropertySortPriority = 900
	ParticleDepthFeatheringMode_t m_nFeatheringMode;
	// MPropertyFriendlyName = "particle feathering closest distance to surface"
	// MPropertySortPriority = 900
	CParticleCollectionRendererFloatInput m_flFeatheringMinDist;
	// MPropertyFriendlyName = "particle feathering farthest distance to surface"
	// MPropertySortPriority = 900
	CParticleCollectionRendererFloatInput m_flFeatheringMaxDist;
	// MPropertyFriendlyName = "particle feathering alpha filter"
	// MPropertySortPriority = 900
	CParticleCollectionRendererFloatInput m_flFeatheringFilter;
	// MPropertyFriendlyName = "particle feathering depthmap layer filter"
	// MPropertySortPriority = 900
	// MPropertySuppressExpr = "mod != hlx"
	CParticleCollectionRendererFloatInput m_flFeatheringDepthMapFilter;
	// MPropertyFriendlyName = "depth comparison bias"
	// MPropertySortPriority = 900
	CParticleCollectionRendererFloatInput m_flDepthBias;
	// MPropertyFriendlyName = "Sort Method"
	// MPropertySortPriority = 900
	ParticleSortingChoiceList_t m_nSortMethod;
	// MPropertyStartGroup = "Animation"
	// MPropertyFriendlyName = "blend sequence animation frames"
	// MPropertySortPriority = 500
	bool m_bBlendFramesSeq0;
	// MPropertyFriendlyName = "use max-luminance blending for sequence"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!m_bBlendFramesSeq0"
	bool m_bMaxLuminanceBlendingSequence0;
};
