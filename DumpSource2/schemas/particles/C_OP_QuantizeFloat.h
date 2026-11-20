// MHasKV3TransferPolymorphicClassname
class C_OP_QuantizeFloat : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "value"
	CPerParticleFloatInput m_InputValue;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nOutputField; // = 3
};
