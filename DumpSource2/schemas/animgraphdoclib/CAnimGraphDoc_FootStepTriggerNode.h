// MPropertyFriendlyName = "Foot Step Trigger"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FootStepTriggerNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Tolerance"
	float32 m_flTolerance; // = 1.5
	// MPropertyFriendlyName = "Feet"
	// MPropertyAutoExpandSelf
	CUtlVector< CFootStepTriggerItem > m_items;
};
