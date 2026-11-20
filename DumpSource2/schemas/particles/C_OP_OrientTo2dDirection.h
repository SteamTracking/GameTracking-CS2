// MHasKV3TransferPolymorphicClassname
class C_OP_OrientTo2dDirection : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "direction input"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecInput; // = { "m_nType": "PVEC_TYPE_PARTICLE_VELOCITY" }
	// MPropertyFriendlyName = "rotation offset"
	float32 m_flRotOffset;
	// MPropertyFriendlyName = "spin strength"
	float32 m_flSpinStrength; // = 1
	// MPropertyFriendlyName = "rotation field"
	// MPropertyAttributeChoiceName = "particlefield_rotation"
	ParticleAttributeIndex_t m_nFieldOutput; // = 4
};
