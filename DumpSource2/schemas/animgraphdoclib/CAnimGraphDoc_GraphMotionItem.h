// MPropertyFriendlyName = "Motion Graph"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_GraphMotionItem : public CAnimGraphDoc_MotionItem
{
	// MPropertyFriendlyName = "Name"
	CUtlString m_name; // = "New Graph"
	// MPropertySuppressField
	CAnimGraphDoc_MotionNodeManager m_nodeManager;
};
