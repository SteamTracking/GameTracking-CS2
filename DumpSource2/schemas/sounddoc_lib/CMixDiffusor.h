// MPropertyFriendlyName = "VMix Diffusor Audio Node"
// MPropertyDescription = "Creates a dense field of delay/feedback/reflections.  This is basically a sequence of allpass filters and short delay lines.  Can be used to create part of a reverb effect."
// MHasKV3TransferPolymorphicClassname
class CMixDiffusor : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Size"
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flSize; // = 0.5
	// MPropertyFriendlyName = "Complexity"
	// MPropertyAttributeRange = "1.01 8.0"
	float32 m_flComplexity; // = 2
	// MPropertyFriendlyName = "Feedback (dB)"
	// MPropertyAttributeRange = "-24.0 -8.0"
	float32 m_flFeedback; // = -8
	// MPropertyFriendlyName = "Output (dB)"
	// MPropertyAttributeRange = "-24.0 -0.1"
	float32 m_flOutputGain;
};
