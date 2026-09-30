// MHasKV3TransferPolymorphicClassname
class C_OP_RemapVelocityToVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "scale factor"
	float32 m_flScale; // = 1
	// MPropertyFriendlyName = "normalize"
	bool m_bNormalize;
};
