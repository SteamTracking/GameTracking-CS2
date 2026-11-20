// MHasKV3TransferPolymorphicClassname
class C_OP_RenderProjected : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "project on characters"
	// MPropertySuppressExpr = "mod != dota"
	bool m_bProjectCharacter;
	// MPropertyFriendlyName = "project on world"
	// MPropertySuppressExpr = "mod != dota"
	bool m_bProjectWorld; // = true
	// MPropertyFriendlyName = "project on water"
	// MPropertySuppressExpr = "mod != dota"
	bool m_bProjectWater; // = true
	// MPropertyFriendlyName = "flip horizontal"
	bool m_bFlipHorizontal;
	// MPropertyFriendlyName = "enable projected depth controls"
	bool m_bEnableProjectedDepthControls;
	// MPropertyFriendlyName = "min projection depth"
	// MPropertySuppressExpr = "!m_bEnableProjectedDepthControls"
	float32 m_flMinProjectionDepth; // = -128
	// MPropertyFriendlyName = "max projection depth"
	// MPropertySuppressExpr = "!m_bEnableProjectedDepthControls"
	float32 m_flMaxProjectionDepth; // = 128
	// MPropertyFriendlyName = "materials"
	// MParticleRequireDefaultArrayEntry
	// MPropertyAutoExpandSelf
	CUtlVector< RenderProjectedMaterial_t > m_vecProjectedMaterials;
	// MPropertyFriendlyName = "material selection"
	CPerParticleFloatInput m_flMaterialSelection;
	// MPropertyFriendlyName = "sheet animation time scale"
	float32 m_flAnimationTimeScale; // = 1
	// MPropertyFriendlyName = "orient to normal"
	bool m_bOrientToNormal;
	// MPropertyFriendlyName = "material variables"
	// MPropertyAutoExpandSelf
	CUtlVector< MaterialVariable_t > m_MaterialVars;
	// MPropertyStartGroup = "+Renderer Modifiers"
	// MPropertyFriendlyName = "Radius Scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flRadiusScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "alpha scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flAlphaScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "rotation roll scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flRollScale; // = { "m_flLiteralValue": 1 }
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
};
