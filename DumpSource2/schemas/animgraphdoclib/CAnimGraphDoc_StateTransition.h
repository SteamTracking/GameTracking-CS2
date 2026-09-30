// MPropertyFriendlyName = "Transition"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_StateTransition
{
	// MPropertySuppressField
	CAnimGraphDoc_ConditionContainer m_conditionList; // = { "_class": "CAnimGraphDoc_ConditionContainer", "m_conditions": [  ] }
	// MPropertySuppressField
	AnimStateID m_srcState;
	// MPropertySuppressField
	AnimStateID m_destState;
	// MPropertyFriendlyName = "Comment"
	// MPropertyAttributeEditor = "TextBlock()"
	// MPropertySortPriority = -100
	CUtlString m_sComment;
	// MPropertyFriendlyName = "Disable"
	bool m_bDisabled;
};
