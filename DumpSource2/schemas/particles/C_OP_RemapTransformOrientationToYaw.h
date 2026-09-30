// MHasKV3TransferPolymorphicClassname
class C_OP_RemapTransformOrientationToYaw : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "rotation field"
	// MPropertyAttributeChoiceName = "particlefield_rotation"
	ParticleAttributeIndex_t m_nFieldOutput; // = 12
	// MPropertyFriendlyName = "rotation offset"
	float32 m_flRotOffset;
	// MPropertyFriendlyName = "spin strength"
	float32 m_flSpinStrength; // = 1
};
