// MHasKV3TransferPolymorphicClassname
class C_INIT_SetRigidAttachment : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "attribute to read from"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldInput;
	// MPropertyFriendlyName = "attribute to cache to"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 2
	// MPropertyFriendlyName = "local space"
	bool m_bLocalSpace; // = true
};
