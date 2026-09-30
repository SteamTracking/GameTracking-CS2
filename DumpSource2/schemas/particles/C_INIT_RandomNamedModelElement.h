// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomNamedModelElement : public CParticleFunctionInitializer
{
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	// MPropertyFriendlyName = "names"
	CUtlVector< CUtlString > m_names;
	// MPropertyFriendlyName = "shuffle"
	bool m_bShuffle;
	// MPropertyFriendlyName = "linear"
	bool m_bLinear;
	// MPropertyFriendlyName = "model from renderer"
	bool m_bModelFromRenderer;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput;
};
