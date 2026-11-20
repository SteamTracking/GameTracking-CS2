// MHasKV3TransferPolymorphicClassname
class C_OP_PercentageBetweenTransformLerpCPs : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "percentage minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "percentage maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "strarting transform"
	CParticleTransformInput m_TransformStart;
	// MPropertyFriendlyName = "end transform"
	CParticleTransformInput m_TransformEnd;
	// MPropertyFriendlyName = "output starting control point number"
	int32 m_nOutputStartCP; // = 2
	// MPropertyFriendlyName = "output starting control point field 0-2 X/Y/Z"
	int32 m_nOutputStartField;
	// MPropertyFriendlyName = "output ending control point number"
	int32 m_nOutputEndCP; // = 2
	// MPropertyFriendlyName = "output ending control point field 0-2 X/Y/Z"
	int32 m_nOutputEndField;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "only active within input range"
	bool m_bActiveRange;
	// MPropertyFriendlyName = "treat distance between points as radius"
	bool m_bRadialCheck; // = true
};
