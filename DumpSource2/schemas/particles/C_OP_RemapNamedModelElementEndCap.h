// MHasKV3TransferPolymorphicClassname
class C_OP_RemapNamedModelElementEndCap : public CParticleFunctionOperator
{
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	// MPropertyFriendlyName = "input names"
	CUtlVector< CUtlString > m_inNames;
	// MPropertyFriendlyName = "output names"
	CUtlVector< CUtlString > m_outNames;
	// MPropertyFriendlyName = "fallback names when the input doesn't match"
	CUtlVector< CUtlString > m_fallbackNames;
	// MPropertyFriendlyName = "model from renderer"
	bool m_bModelFromRenderer;
	// MPropertyFriendlyName = "input field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldInput;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput;
};
