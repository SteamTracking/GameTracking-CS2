// MPropertyFriendlyName = "Cycle Control"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_CycleControlNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Blend Source"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_valueSource; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_param;
	// MPropertyFriendlyName = "Lock When Waning"
	bool m_bLockWhenWaning;
};
