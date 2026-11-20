// MHasKV3TransferPolymorphicClassname
class C_OP_RemapGravityToVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "position input"
	CPerParticleVecInput m_vInput1;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nOutputField; // = 21
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "normalize result"
	bool m_bNormalizedOutput;
};
