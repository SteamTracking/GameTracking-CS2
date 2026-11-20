// MHasKV3TransferPolymorphicClassname
class C_OP_LerpScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "value to lerp to"
	CPerParticleFloatInput m_flOutput; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "start time"
	float32 m_flStartTime;
	// MPropertyFriendlyName = "end time"
	float32 m_flEndTime; // = 1
};
