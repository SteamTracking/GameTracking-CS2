// MPropertyFriendlyName = "Item"
// MPropertyElementNameFn
class CFootStepTriggerItem
{
	// MPropertyFriendlyName = "Foot"
	// MPropertyAttributeChoiceName = "Foot"
	CUtlString m_footName;
	// MPropertyFriendlyName = "Trigger Phase"
	StepPhase m_triggerPhase; // = "StepPhase_OnGround"
	// MPropertySuppressField
	CUtlVector< CGlobalSymbol > m_tagNames;
	// MPropertyFriendlyName = "Tags"
	// MPropertyAttributeChoiceName = "Tag"
	CUtlVector< AnimTagID > m_tagIDs;
};
