// MHasKV3TransferPolymorphicClassname
class CRemapValueComponent : public CAnimGraphDoc_Component
{
	// MPropertyFriendlyName = "Name"
	CUtlString m_name;
	// MPropertyFriendlyName = "Items"
	// MPropertyAutoExpandSelf
	CUtlVector< CRemapValueItem > m_items;
};
