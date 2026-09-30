// MHasKV3TransferPolymorphicClassname
class C_INIT_RemapTransformOrientationToRotations : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "Transform input"
	CParticleTransformInput m_TransformInput; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "Offset pitch/yaw/roll"
	Vector m_vecRotation;
	// MPropertyFriendlyName = "Use quaternions internally"
	bool m_bUseQuat;
	// MPropertyFriendlyName = "Write normal instead of rotation"
	bool m_bWriteNormal;
};
