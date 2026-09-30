// MPropertyFriendlyName = "Stance Override"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_StanceOverrideNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_stanceSourceConnection;
	// MPropertySuppressField
	CUtlString m_blendParamName;
	// MPropertyFriendlyName = "Blend Parameter (optional)"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_blendParamID;
	// MPropertyFriendlyName = "Stance Source"
	// MPropertyAutoRebuildOnChange
	StanceOverrideMode m_eMode; // = "Sequence"
	// MPropertyFriendlyName = "Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	// MPropertyAttrStateCallback
	CUtlString m_sequenceName;
	// MPropertyFriendlyName = "Frame"
	// MPropertyAttrStateCallback
	int32 m_nFrameIndex;
};
