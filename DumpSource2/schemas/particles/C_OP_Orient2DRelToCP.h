// MHasKV3TransferPolymorphicClassname
class C_OP_Orient2DRelToCP : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "rotation offset"
	float32 m_flRotOffset;
	// MPropertyFriendlyName = "spin strength"
	float32 m_flSpinStrength; // = 1
	// MPropertyFriendlyName = "control point"
	int32 m_nCP;
	// MPropertyFriendlyName = "rotation field"
	// MPropertyAttributeChoiceName = "particlefield_rotation"
	ParticleAttributeIndex_t m_nFieldOutput; // = 4
};
