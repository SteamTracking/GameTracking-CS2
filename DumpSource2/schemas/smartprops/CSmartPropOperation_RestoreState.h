// MPropertyFriendlyName = "Restore State"
// MPropertyDescription = "Replace the current state with a previously saved state."
// MVDataNodeTintColor = [188, 255, 255, 255]
// MVDataClassGroup = "State"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_RestoreState : public CSmartPropOperation
{
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( SavedState )"
	// MPropertyDescription = "Name of the previously saved state to restore"
	CSmartPropAttributeStateName m_StateName;
	// MPropertyDescription = "If true, the parent element will be discarded there is no state with the specified name. If false, and there is no state with the specified name then no changes are made."
	CSmartPropAttributeBool m_bDiscardIfUknown;
};
