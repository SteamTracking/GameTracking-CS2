// MHasKV3TransferPolymorphicClassname
class COrientationWarpUpdateNode : public CUnaryUpdateNode
{
	OrientationWarpMode_t m_eMode; // = "eInvalid"
	CAnimParamHandle m_hTargetParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hTargetPositionParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hFallbackTargetPositionParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	OrientationWarpTargetOffsetMode_t m_eTargetOffsetMode; // = "eLiteralValue"
	float32 m_flTargetOffset;
	CAnimParamHandle m_hTargetOffsetParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	OrientationWarpRootMotionSource_t m_eRootMotionSource; // = "eAnimationOrProcedural"
	float32 m_flMaxRootMotionScale; // = 10
	bool m_bEnablePreferredRotationDirection;
	AnimValueSource m_ePreferredRotationDirection; // = "FacingHeading"
	float32 m_flPreferredRotationThreshold; // = 190
};
