class CDSPMixgroupModifier
{
	// MPropertyDescription = "Name of the mixgroup. TODO: needs to be autopopulated with mixgroups."
	// MPropertyFriendlyName = "Mixgroup Name"
	CUtlString m_mixgroup; // = "default"
	// MPropertyDescription = "The amount to multiply the volume of the non-spatialized reverb/dsp by when at the max reverb blend distance. 1.0 leaves the volume unchanged."
	// MPropertyFriendlyName = "Max reverb gain amount for listener DSP."
	float32 m_flModifier; // = 1
	// MPropertyDescription = "The amount to multiply the volume of the non-spatialized reverb/dsp by when at the min reverb blend distance. 1.0 leaves the volume unchanged."
	// MPropertyFriendlyName = "Min reverb gain amount amount for listener DSP."
	float32 m_flModifierMin;
	// MPropertyDescription = "If set to >= 0, we will use this mix modifier for source-specific DSP effects. Otherwise we will use the listener DSP value."
	// MPropertyFriendlyName = "Max reverb gain amount for source-specific DSP."
	float32 m_flSourceModifier; // = -1
	// MPropertyDescription = "If set to >= 0, we will use this mix modifier for source-specific DSP effects. Otherwise we will use the listener DSP value."
	// MPropertyFriendlyName = "Min reverb gain amount for source-specific DSP."
	float32 m_flSourceModifierMin; // = -1
	// MPropertyDescription = "When a source has source-specific DSP, this can be used as an additional mix stage for the listener reverb amount."
	// MPropertyFriendlyName = "Modification amount for listener DSP when source DSP is used."
	float32 m_flListenerReverbModifierWhenSourceReverbIsActive; // = 1
};
