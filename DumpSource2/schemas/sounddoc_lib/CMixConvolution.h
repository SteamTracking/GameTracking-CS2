// MPropertyFriendlyName = "VMix Audio Convolution Node"
// MPropertyDescription = "Apply a vsnd as an impulse response (IR) to an audio signal via convolution."
// MHasKV3TransferPolymorphicClassname
class CMixConvolution : public CMixPropertyBase
{
	// MPropertyAutoExpandSelf
	VMixConvolutionDesc_t m_desc; // = { "m_flHighCutoffFreq": 7500, "m_flLowCutoffFreq": 1500, "m_flPreDelayMS": 0, "m_flWetMix": 1, "m_fldbGain": -12, "m_fldbHigh": 0, "m_fldbLow": 0, "m_fldbMid": 0 }
};
