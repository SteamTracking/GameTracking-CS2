// MPropertyFriendlyName = "Selector"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SelectorNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CUtlVector< CAnimGraphDoc_NodeConnection > m_children;
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_fallbackChild;
	// MPropertySuppressField
	CUtlVector< AnimTagID > m_tags;
	// MPropertyFriendlyName = "Selection Source"
	// MPropertyAutoRebuildOnChange
	SelectionSource_t m_selectionSource; // = "SelectionSource_Enum"
	// MPropertySuppressField
	CUtlString m_boolParamName;
	// MPropertyFriendlyName = "Bool Parameter"
	// MPropertyAttributeChoiceName = "BoolParameter"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimParamID m_boolParamID;
	// MPropertySuppressField
	CUtlString m_enumParamName;
	// MPropertyFriendlyName = "Enum Parameter"
	// MPropertyAttributeChoiceName = "EnumParameter"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimParamID m_enumParamID;
	// MPropertyFriendlyName = "Tag Parameter"
	// MPropertyAttributeChoiceName = "Tag"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimTagID m_tagID;
	// MPropertyFriendlyName = "Blend Duration"
	CFloatAnimValue m_blendDuration; // = { "_class": "CFloatAnimValue", "m_eSource": "Constant", "m_flConstValue": 0.2, "m_paramID": { "m_id": 0 }, "m_paramName": "" }
	// MPropertyFriendlyName = "Tag Behavior"
	SelectorTagBehavior_t m_tagBehavior; // = "SelectorTagBehavior_OffWhenFinished"
	// MPropertyFriendlyName = "Reset On Change"
	bool m_bResetOnChange; // = true
	// MPropertyFriendlyName = "Start new option at same cycle"
	bool m_bSyncCyclesOnChange;
	// MPropertyFriendlyName = "Lock Selection When Waning"
	bool m_bLockWhenWaning;
	// MPropertySuppressField
	CBlendCurve m_blendCurve; // = { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }
};
