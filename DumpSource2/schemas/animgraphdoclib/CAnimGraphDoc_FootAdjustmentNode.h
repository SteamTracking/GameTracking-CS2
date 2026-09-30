// MPropertyFriendlyName = "Foot Adjustment"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FootAdjustmentNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertySuppressField
	CUtlString m_facingTargetParam;
	// MPropertyFriendlyName = "Turn to Face"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_facingTarget;
	// MPropertyFriendlyName = "Reset Child"
	bool m_bResetChild; // = true
	// MPropertyFriendlyName = "Animation Driven"
	// MPropertyAutoRebuildOnChange
	bool m_bAnimationDriven;
	// MPropertyFriendlyName = "Base Anim Clips"
	// MPropertyGroupName = "Anim Driven Settings"
	// MPropertyAttributeChoiceName = "Sequence"
	// MPropertyAttrStateCallback
	CUtlString m_baseClipName;
	// MPropertyFriendlyName = "Clips"
	// MPropertyGroupName = "Anim Driven Settings"
	// MPropertyAttributeChoiceName = "Sequence"
	// MPropertyAttrStateCallback
	CUtlVector< CUtlString > m_clips;
	// MPropertyFriendlyName = "Turn Time Min"
	// MPropertyGroupName = "Procedural Settings"
	// MPropertyAttrStateCallback
	float32 m_flTurnTimeMin; // = 1.5
	// MPropertyFriendlyName = "Turn Time Max"
	// MPropertyGroupName = "Procedural Settings"
	// MPropertyAttrStateCallback
	float32 m_flTurnTimeMax; // = 3
	// MPropertyFriendlyName = "Step Height Max"
	// MPropertyGroupName = "Procedural Settings"
	// MPropertyAttrStateCallback
	float32 m_flStepHeightMax; // = 4
	// MPropertyFriendlyName = "Step Height Max Angle"
	// MPropertyGroupName = "Procedural Settings"
	// MPropertyAttrStateCallback
	float32 m_flStepHeightMaxAngle; // = 90
};
