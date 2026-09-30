// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_LerpEndCapVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "value to lerp to"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vecOutput;
	// MPropertyFriendlyName = "lerp time"
	float32 m_flLerpTime; // = 1
};
