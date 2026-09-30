// MHasKV3TransferPolymorphicClassname
class CNmGraphDocTargetSelectorNode : public CNmGraphDocVariationDataNode
{
	// MPropertyAutoExpandSelf
	// MPropertyResizable = 0
	CUtlVector< CUtlString > m_optionLabels; // = [ "Option", "Option" ]
	float32 m_flOrientationScoreWeight; // = 1
	float32 m_flPositionScoreWeight; // = 1
	bool m_bIsWorldSpaceTarget; // = true
	// MPropertyGroupName = "Advanced"
	// MPropertyDescription = "Should we ignore any invalid option and remove them from the selection. This is useful if different variations has different sets of options filled"
	bool m_bIgnoreInvalidOptions;
};
