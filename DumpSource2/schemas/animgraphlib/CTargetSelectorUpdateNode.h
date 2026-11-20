// MHasKV3TransferPolymorphicClassname
class CTargetSelectorUpdateNode : public CAnimUpdateNodeBase
{
	TargetSelectorAngleMode_t m_eAngleMode; // = "eFacingHeading"
	CUtlVector< CAnimUpdateNodeRef > m_children;
	CAnimParamHandle m_hTargetPosition;
	CAnimParamHandle m_hTargetFacePositionParameter;
	CAnimParamHandle m_hMoveHeadingParameter;
	CAnimParamHandle m_hDesiredMoveHeadingParameter;
	bool m_bTargetPositionIsWorldSpace;
	bool m_bTargetFacePositionIsWorldSpace;
	bool m_bEnablePhaseMatching;
	float32 m_flPhaseMatchingMaxRootMotionSkip; // = 0.4
};
