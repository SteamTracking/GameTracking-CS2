// MPropertyFriendlyName = "Wind Generator Container"
// MPropertyDescription = "This is a synth meant to generate whoosh noises."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerShapedNoise : public CVoiceContainerGenerator
{
	bool m_bUseCurveForFrequency;
	// MPropertySuppressExpr = "m_bUseCurveForFrequency == 1"
	float32 m_flFrequency; // = 440
	// MPropertySuppressExpr = "m_bUseCurveForFrequency == 0"
	// MPropertyFriendlyName = "Frequency Sweep"
	CPiecewiseCurve m_frequencySweep;
	bool m_bUseCurveForResonance;
	// MPropertySuppressExpr = "m_bUseCurveForResonance == 1"
	float32 m_flResonance; // = 4
	// MPropertySuppressExpr = "m_bUseCurveForResonance == 0"
	// MPropertyFriendlyName = "Resonance Sweep"
	CPiecewiseCurve m_resonanceSweep;
	bool m_bUseCurveForAmplitude;
	// MPropertySuppressExpr = "m_bUseCurveForAmplitude == 1"
	float32 m_flGainInDecibels; // = 1
	// MPropertySuppressExpr = "m_bUseCurveForAmplitude == 0"
	// MPropertyFriendlyName = "Gain Sweep (in Decibels)"
	CPiecewiseCurve m_gainSweep;
};
