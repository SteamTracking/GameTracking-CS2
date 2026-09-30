// MHasKV3TransferPolymorphicClassname
class C_OP_RemapTransformVisibilityToVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "CP visibility minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "CP visibility maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "output minimum"
	Vector m_vecOutputMin;
	// MPropertyFriendlyName = "output maximum"
	Vector m_vecOutputMax; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "visibility radius"
	float32 m_flRadius; // = 1
};
