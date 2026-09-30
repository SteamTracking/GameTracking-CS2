// MPropertyFriendlyName = "Node Blend Item"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_NodeBlend2DItem : public CAnimGraphDoc_Blend2DItem
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Name"
	CUtlString m_name; // = "<Unnamed Item>"
};
