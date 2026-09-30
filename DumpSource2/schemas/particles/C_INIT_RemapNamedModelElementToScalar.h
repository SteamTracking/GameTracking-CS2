// MHasKV3TransferPolymorphicClassname
class C_INIT_RemapNamedModelElementToScalar : public CParticleFunctionInitializer
{
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	// MPropertyFriendlyName = "names"
	CUtlVector< CUtlString > m_names;
	// MPropertyFriendlyName = "remap values for names"
	CUtlVector< float32 > m_values;
	// MPropertyFriendlyName = "input field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldInput;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod;
	// MPropertyFriendlyName = "model from renderer"
	bool m_bModelFromRenderer;
};
