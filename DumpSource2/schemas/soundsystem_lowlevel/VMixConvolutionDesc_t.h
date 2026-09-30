class VMixConvolutionDesc_t
{
	// MPropertyFriendlyName = "gain of wet signal (dB)"
	// MPropertyAttributeRange = "-36 3"
	float32 m_fldbGain; // = -12
	// MPropertyFriendlyName = "Pre-delay (ms)"
	float32 m_flPreDelayMS;
	// MPropertyFriendlyName = "Dry/Wet"
	float32 m_flWetMix; // = 1
	// MPropertyFriendlyName = "Low EQ gain (dB)"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbLow;
	// MPropertyFriendlyName = "Mid EQ gain (dB)"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbMid;
	// MPropertyFriendlyName = "High EQ gain (dB)"
	// MPropertyAttributeRange = "-24 24"
	float32 m_fldbHigh;
	// MPropertyFriendlyName = "Low Cutoff Freq (Hz)"
	float32 m_flLowCutoffFreq; // = 1500
	// MPropertyFriendlyName = "High Cutoff Freq (Hz)"
	float32 m_flHighCutoffFreq; // = 7500
};
