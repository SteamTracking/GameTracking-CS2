// MPropertyFriendlyName = "Tag Condition"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_TagCondition : public CAnimGraphDoc_Condition
{
	// MPropertyFriendlyName = "Tag"
	// MPropertyAttributeChoiceName = "Tag"
	AnimTagID m_tagID;
	// MPropertyFriendlyName = "Value"
	bool m_comparisonValue; // = true
	// MPropertyFriendlyName = "Lastest Value"
	bool m_latestValue;
};
