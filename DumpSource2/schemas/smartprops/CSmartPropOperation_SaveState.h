// MPropertyFriendlyName = "Save State"
// MPropertyDescription = "Save the current state, allowing it to be restored at a later state."
// MVDataNodeTintColor = [188, 255, 255, 255]
// MVDataClassGroup = "State"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_SaveState : public CSmartPropOperation
{
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( SavedState )"
	// MPropertyDescription = "Name to assign to the saved state, the save state can be restored later using this name."
	CUtlString m_StateName;
};
