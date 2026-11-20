// MHasKV3TransferPolymorphicClassname
class C_OP_RenderMaterialProxy : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "Control Point for Model"
	int32 m_nMaterialControlPoint;
	// MPropertyFriendlyName = "proxy type"
	MaterialProxyType_t m_nProxyType; // = "MATERIAL_PROXY_STATUS_EFFECT"
	// MPropertyFriendlyName = "material variables"
	// MPropertyAutoExpandSelf
	CUtlVector< MaterialVariable_t > m_MaterialVars;
	// MPropertyFriendlyName = "material override"
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_hOverrideMaterial;
	// MPropertyFriendlyName = "material override enable"
	CParticleCollectionFloatInput m_flMaterialOverrideEnabled; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "model tint"
	CParticleCollectionVecInput m_vecColorScale; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "model alpha"
	CPerParticleFloatInput m_flAlpha; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "model tint blend type"
	ParticleColorBlendType_t m_nColorBlendType; // = "PARTICLE_COLOR_BLEND_MULTIPLY"
};
