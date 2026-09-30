// MPropertyFriendlyName = "Jump Helper"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_JumpHelperNode : public CAnimGraphDoc_SequenceNode
{
	// MPropertySuppressField
	CUtlString m_targetParamName;
	// MPropertyFriendlyName = "Target Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	AnimParamID m_targetParamID;
	// MPropertySuppressField
	float32 m_flJumpStartCycle;
	// MPropertySuppressField
	float32 m_flJumpDuration; // = 0.1
	// MPropertyFriendlyName = "Translate X"
	bool m_bTranslateX; // = true
	// MPropertyFriendlyName = "Translate Y"
	bool m_bTranslateY; // = true
	// MPropertyFriendlyName = "Translate Z"
	bool m_bTranslateZ; // = true
	// MPropertyFriendlyName = "Apply Speed Scale"
	bool m_bScaleSpeed; // = true
	// MPropertyFriendlyName = "Correction Method"
	JumpCorrectionMethod m_eCorrectionMethod; // = "ScaleMotion"
};
