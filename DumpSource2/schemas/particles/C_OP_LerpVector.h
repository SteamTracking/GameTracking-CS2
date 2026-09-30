// MHasKV3TransferPolymorphicClassname
class C_OP_LerpVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "value to lerp to"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vecOutput;
	// MPropertyFriendlyName = "start time"
	float32 m_flStartTime;
	// MPropertyFriendlyName = "end time"
	float32 m_flEndTime; // = 1
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
