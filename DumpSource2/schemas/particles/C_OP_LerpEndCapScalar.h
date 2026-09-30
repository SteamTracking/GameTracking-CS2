// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_LerpEndCapScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "value to lerp to"
	float32 m_flOutput; // = 1
	// MPropertyFriendlyName = "lerp time"
	float32 m_flLerpTime; // = 1
};
