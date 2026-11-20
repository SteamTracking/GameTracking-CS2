// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_InitFloat : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "value"
	CPerParticleFloatInput m_InputValue;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nOutputField; // = 3
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "per-particle strength"
	CPerParticleFloatInput m_InputStrength; // = { "m_flLiteralValue": 1 }
};
