// MHasKV3TransferPolymorphicClassname
class CTargetWarpUpdateNode : public CUnaryUpdateNode
{
	TargetWarpAngleMode_t m_eAngleMode; // = "eFacingHeading"
	CAnimParamHandle m_hTargetPositionParameter;
	CAnimParamHandle m_hTargetUpVectorParameter;
	CAnimParamHandle m_hTargetFacePositionParameter;
	CAnimParamHandle m_hMoveHeadingParameter;
	CAnimParamHandle m_hDesiredMoveHeadingParameter;
	TargetWarpCorrectionMethod m_eCorrectionMethod; // = "ScaleMotion"
	TargetWarpTimingMethod m_eTargetWarpTimingMethod; // = "ReachDestinationOnRootMotionEnd"
	bool m_bTargetFacePositionIsWorldSpace;
	bool m_bTargetPositionIsWorldSpace;
	bool m_bOnlyWarpWhenTagIsFound;
	bool m_bWarpOrientationDuringTranslation;
	bool m_bWarpAroundCenter;
	float32 m_flMaxAngle; // = 180
};
