// MPropertyFriendlyName = "Jiggle Bone"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_JiggleBoneNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Jiggle Bones"
	// MPropertyAutoExpandSelf
	CUtlVector< CJiggleBoneItem > m_items;
};
