// MPropertyFriendlyName = "Speed Scale"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SpeedScaleNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_param;
};
