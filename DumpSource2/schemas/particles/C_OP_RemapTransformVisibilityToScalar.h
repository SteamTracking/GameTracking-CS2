// MHasKV3TransferPolymorphicClassname
class C_OP_RemapTransformVisibilityToScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "CP visibility minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "CP visibility maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "visibility radius"
	float32 m_flRadius; // = 1
};
