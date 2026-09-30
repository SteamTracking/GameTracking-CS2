// MHasKV3TransferPolymorphicClassname
class C_OP_PercentageBetweenTransforms : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "percentage minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "percentage maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "strarting transform"
	CParticleTransformInput m_TransformStart; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "end transform"
	CParticleTransformInput m_TransformEnd; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "only active within input range"
	bool m_bActiveRange;
	// MPropertyFriendlyName = "treat distance between points as radius"
	bool m_bRadialCheck; // = true
};
