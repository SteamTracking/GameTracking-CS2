// MHasKV3TransferPolymorphicClassname
class C_OP_ReinitializeScalarEndCap : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "maximum"
	float32 m_flOutputMax; // = 1
};
