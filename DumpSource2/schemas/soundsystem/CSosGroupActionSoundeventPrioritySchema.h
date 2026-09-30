// MPropertyFriendlyName = "Soundevent Priority"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionSoundeventPrioritySchema : public CSosGroupActionSchema
{
	// MPropertyFriendlyName = "Priority Value, typically 0.0 to 1.0"
	CUtlString m_priorityValue; // = "priority_value"
	// MPropertyFriendlyName = "Priority-Based Volume Multiplier, 0.0 to 1.0"
	CUtlString m_priorityVolumeScalar; // = "priority_volume_scalar"
	// MPropertyFriendlyName = "Contribute to the priority system, but volume is unaffected by it (bool)"
	CUtlString m_priorityContributeButDontRead; // = "priority_contribute_dont_read"
	// MPropertyFriendlyName = "Don't contribute to the priority system, but volume is affected by it (bool)"
	CUtlString m_bPriorityReadButDontContribute; // = "priority_read_dont_contribute"
};
