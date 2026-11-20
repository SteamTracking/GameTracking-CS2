// MHasKV3TransferPolymorphicClassname
class COrientationWarpUpdateNode : public CUnaryUpdateNode
{
	OrientationWarpMode_t m_eMode; // = "eInvalid"
	CAnimParamHandle m_hTargetParam;
	CAnimParamHandle m_hTargetPositionParam;
	CAnimParamHandle m_hFallbackTargetPositionParam;
	OrientationWarpTargetOffsetMode_t m_eTargetOffsetMode; // = "eLiteralValue"
	float32 m_flTargetOffset;
	CAnimParamHandle m_hTargetOffsetParam;
	CAnimInputDamping m_damping;
	OrientationWarpRootMotionSource_t m_eRootMotionSource; // = "eAnimationOrProcedural"
	float32 m_flMaxRootMotionScale; // = 10
	bool m_bEnablePreferredRotationDirection;
	AnimValueSource m_ePreferredRotationDirection; // = "FacingHeading"
	float32 m_flPreferredRotationThreshold; // = 190
};
