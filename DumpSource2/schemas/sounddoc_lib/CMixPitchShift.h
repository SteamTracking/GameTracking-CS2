// MPropertyFriendlyName = "VMix Pitch Shift Audio Node"
// MPropertyDescription = "Adjust the pitch of an audio track.  This happens in real-time so the timing of the track is unaffected.  Generally the time domain processor will produce better results for small shifts downward.  For shifting upward it will alias where the frequency space shifter will apply anti-aliasing."
// MHasKV3TransferPolymorphicClassname
class CMixPitchShift : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Pitch Scale"
	// MPropertyAttributeRange = "0.2 4.0"
	float32 m_flPitchScale; // = 1
	// MPropertyFriendlyName = "Grain Size (ms)"
	// MPropertyAttributeRange = "1 100"
	float32 m_flGrainMs; // = 100
	// MPropertyFriendlyName = "Type 0=time domain, 1 = freq domain"
	// MPropertyAttributeRange = "0 1"
	int32 m_nProcType;
	// MPropertyFriendlyName = "Quality level 1..4"
	// MPropertyAttributeRange = "1 4"
	int32 m_nQuality; // = 1
};
