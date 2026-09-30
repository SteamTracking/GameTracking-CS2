// MHasKV3TransferPolymorphicClassname
class CTargetSelectorUpdateNode : public CAnimUpdateNodeBase
{
	TargetSelectorAngleMode_t m_eAngleMode; // = "eFacingHeading"
	CUtlVector< CAnimUpdateNodeRef > m_children;
	CAnimParamHandle m_hTargetPosition; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hTargetFacePositionParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hMoveHeadingParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hDesiredMoveHeadingParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	bool m_bTargetPositionIsWorldSpace;
	bool m_bTargetFacePositionIsWorldSpace;
	bool m_bEnablePhaseMatching;
	float32 m_flPhaseMatchingMaxRootMotionSkip; // = 0.4
};
