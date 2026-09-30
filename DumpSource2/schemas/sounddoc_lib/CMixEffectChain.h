// MPropertyFriendlyName = "VMix Effect Chain Audio Node"
// MPropertyDescription = "Allows you to swap between sub-graphs with a short crossfade.  Can be used to swap out processing algorithms/configurations, or to dynamically enable/disable optional processing stages."
// MHasKV3TransferPolymorphicClassname
class CMixEffectChain : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Effect Preset Name"
	CUtlString m_effectName; // = "core.null"
	// MPropertyFriendlyName = "Crossfade time (seconds)"
	float32 m_flXFade; // = 0.1
};
