// MPropertyFriendlyName = "Motion Clip Group"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_MotionItemGroup
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_MotionItem > > m_motions;
	// MPropertyFriendlyName = "Name"
	CUtlString m_name; // = "Unnamed Group"
	CAnimGraphDoc_ConditionContainer m_conditions; // = { "_class": "CAnimGraphDoc_ConditionContainer", "m_conditions": [  ] }
};
