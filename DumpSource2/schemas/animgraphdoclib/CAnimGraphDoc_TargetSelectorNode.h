// MPropertyFriendlyName = "Target Selector"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_TargetSelectorNode : public CAnimGraphDoc_Node
{
	CUtlVector< CTargetSelectorChild > m_children;
	// MPropertyFriendlyName = "Linear Root Motion Mode"
	// MPropertyAutoRebuildOnChange
	TargetWarpLinearRootMotionMode m_eLinearRootMotionMode; // = "TargetWarpLinearRootMotionMode_Default"
	// MPropertyFriendlyName = "Angle Mode"
	TargetSelectorAngleMode_t m_eAngleMode; // = "eFacingHeading"
	// MPropertyFriendlyName = "Move Heading"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_moveHeadingParamID;
	// MPropertyFriendlyName = "Desired Move Heading"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_desiredMoveHeadingParamID;
	// MPropertyFriendlyName = "Target Position"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_targetPositionParamID;
	// MPropertyFriendlyName = "Target Position Is World Space"
	// MPropertyAttrStateCallback
	bool m_bTargetPositionIsWorldSpace;
	// MPropertyFriendlyName = "Target Face Position"
	// MPropertyAttributeChoiceName = "VectorParameter"
	AnimParamID m_targetFacePositionParamID;
	// MPropertyFriendlyName = "Target Face Position Is World Space"
	bool m_bTargetFacePositionIsWorldSpace;
	bool m_bEnablePhaseMatching;
	float32 m_flPhaseMatchingMaxRootMotionSkip; // = 0.4
};
