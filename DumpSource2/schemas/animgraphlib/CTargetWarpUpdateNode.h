// MHasKV3TransferPolymorphicClassname
class CTargetWarpUpdateNode : public CUnaryUpdateNode
{
	TargetWarpAngleMode_t m_eAngleMode; // = "eFacingHeading"
	CAnimParamHandle m_hTargetPositionParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hTargetUpVectorParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hTargetFacePositionParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hMoveHeadingParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hDesiredMoveHeadingParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	TargetWarpCorrectionMethod m_eCorrectionMethod; // = "ScaleMotion"
	TargetWarpTimingMethod m_eTargetWarpTimingMethod; // = "ReachDestinationOnRootMotionEnd"
	bool m_bTargetFacePositionIsWorldSpace;
	bool m_bTargetPositionIsWorldSpace;
	bool m_bOnlyWarpWhenTagIsFound;
	bool m_bWarpOrientationDuringTranslation;
	bool m_bWarpAroundCenter;
	float32 m_flMaxAngle; // = 180
};
