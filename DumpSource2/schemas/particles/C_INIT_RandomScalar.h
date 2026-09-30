// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomScalar : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "min"
	float32 m_flMin;
	// MPropertyFriendlyName = "max"
	float32 m_flMax;
	// MPropertyFriendlyName = "exponent"
	float32 m_flExponent; // = 1
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
};
