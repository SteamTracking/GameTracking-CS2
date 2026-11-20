// MHasKV3TransferPolymorphicClassname
class C_OP_RenderDeferredLight : public CParticleFunctionRenderer
{
	// MPropertyStartGroup = "+Renderer Modifiers"
	// MPropertyFriendlyName = "radius scale"
	// MPropertySortPriority = 700
	float32 m_flRadiusScale; // = 1
	// MPropertyFriendlyName = "alpha scale"
	// MPropertySortPriority = 700
	float32 m_flAlphaScale; // = 1
	// MPropertyFriendlyName = "per-particle alpha scale attribute"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySortPriority = 700
	ParticleAttributeIndex_t m_nAlpha2Field; // = 16
	// MPropertyFriendlyName = "color blend"
	// MPropertySortPriority = 700
	CParticleCollectionVecInput m_vecColorScale; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "color blend type"
	// MPropertySortPriority = 700
	ParticleColorBlendType_t m_nColorBlendType; // = "PARTICLE_COLOR_BLEND_MULTIPLY"
	// MPropertyStartGroup = "+Projected Texture Light"
	// MPropertyFriendlyName = "use texture for light"
	bool m_bUseTexture;
	// MPropertyFriendlyName = "use alpha test window"
	// MPropertySuppressExpr = "!m_bUseTexture"
	bool m_bUseAlphaTestWindow;
	// MPropertyFriendlyName = "texture"
	// MPropertySuppressExpr = "!m_bUseTexture"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hTexture;
	// MPropertyFriendlyName = "alpha test point scale field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySuppressExpr = "!m_bUseTexture"
	ParticleAttributeIndex_t m_nAlphaTestPointField; // = 13
	// MPropertyFriendlyName = "alpha test range scale field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySuppressExpr = "!m_bUseTexture"
	ParticleAttributeIndex_t m_nAlphaTestRangeField; // = 23
	// MPropertyFriendlyName = "alpha test sharpness scale field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySuppressExpr = "!m_bUseTexture"
	ParticleAttributeIndex_t m_nAlphaTestSharpnessField; // = 18
	// MPropertyStartGroup = ""
	// MPropertyFriendlyName = "spotlight distance"
	float32 m_flLightDistance;
	// MPropertyFriendlyName = "light start falloff"
	float32 m_flStartFalloff; // = 0.25
	// MPropertyFriendlyName = "spotlight distance falloff"
	float32 m_flDistanceFalloff;
	// MPropertyFriendlyName = "spotlight FoV"
	float32 m_flSpotFoV; // = 60
	// MPropertyFriendlyName = "HSV Shift Control Point"
	int32 m_nHSVShiftControlPoint; // = -1
};
