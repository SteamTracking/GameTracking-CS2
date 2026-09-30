class CDspPresetModifierList
{
	// MPropertyDescription = "Name of the DSP effect / subgraph used."
	// MPropertyFriendlyName = "DSP Effect Name"
	CUtlString m_dspName; // = "default"
	// MPropertyDescription = "Set of modifiers for individual mix groups"
	// MPropertyFriendlyName = "Mixgroup Modifiers"
	CUtlVector< CDSPMixgroupModifier > m_modifiers;
};
