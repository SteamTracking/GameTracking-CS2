// MHasKV3TransferPolymorphicClassname
class CNmGraphDocIDBasedSelectorNode : public CNmGraphDocFlowNode
{
	// MPropertyAutoExpandSelf
	// MPropertyResizable = 0
	CUtlVector< CUtlString > m_optionLabels; // = [ "Option", "Option" ]
	// MPropertyGroupName = "Advanced"
	// MPropertyDescription = "Should we ignore any invalid option and remove them from the selection. This is useful if different variations has different sets of options filled"
	bool m_bIgnoreInvalidOptions;
};
