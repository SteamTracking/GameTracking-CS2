// MPropertyFriendlyName = "VMix Short timeModulating Delay Audio Node"
// MPropertyDescription = "A short time delay with modulation for flange and chorus effects."
// MHasKV3TransferPolymorphicClassname
class CMixFlanger : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Delay Time (ms)"
	// MPropertyAttributeRange = "0.5 14"
	float32 m_flDelay; // = 8
	// MPropertyFriendlyName = "Feedback Gain (dB)"
	// MPropertyAttributeRange = "-40 -0.6"
	float32 m_flFeedback; // = -40
	// MPropertyFriendlyName = "Wet (linear)"
	// MPropertyAttributeRange = "0 1.0"
	float32 m_flFeedfoward; // = 0.5
	// MPropertyFriendlyName = "Modulation Rate (Hz)"
	// MPropertyAttributeRange = "0 4"
	float32 m_flModRate; // = 0.5
	// MPropertyFriendlyName = "Modulation Depth (linear)"
	// MPropertyAttributeRange = "0 1.0"
	float32 m_flModDepth; // = 0.5
	// MPropertyFriendlyName = "Invert Phase"
	bool m_bPhaseInvert;
	// MPropertyFriendlyName = "Modulation Param Glide (ms)"
	// MPropertyAttributeRange = "0 2000"
	float32 m_flGlideTime; // = 150
	// MPropertyFriendlyName = "Apply Antialiasing"
	bool m_bAntialiasing;
	// MPropertyFriendlyName = "Output Gain (dB)"
	// MPropertyAttributeRange = "-24 24"
	float32 m_flGain;
};
