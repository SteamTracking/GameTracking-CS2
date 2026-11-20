// MHasKV3TransferPolymorphicClassname
class C_INIT_QuantizeFloat : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "interval to snap to"
	CPerParticleFloatInput m_InputValue;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nOutputField; // = 3
};
