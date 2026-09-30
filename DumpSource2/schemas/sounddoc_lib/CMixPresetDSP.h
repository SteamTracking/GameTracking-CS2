// MPropertyFriendlyName = "VMix Preset DSP Audio Node"
// MPropertyDescription = "Applies an effects preset from the source1 DSP system."
// MHasKV3TransferPolymorphicClassname
class CMixPresetDSP : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Effect Preset Name"
	// MPropertyAttributeChoiceName = "dsp_preset"
	CUtlString m_effectName; // = "core.null"
	// MPropertyFriendlyName = "Crossfade time (seconds)"
	float32 m_flXFade; // = 0.1
};
