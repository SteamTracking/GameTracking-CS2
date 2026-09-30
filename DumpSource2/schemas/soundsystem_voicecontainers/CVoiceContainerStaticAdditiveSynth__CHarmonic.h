class CVoiceContainerStaticAdditiveSynth::CHarmonic
{
	// MPropertyFriendlyName = "Waveform"
	EWaveform m_nWaveform; // = "Sine"
	// MPropertyFriendlyName = "Note"
	EMidiNote m_nFundamental; // = "A"
	// MPropertyFriendlyName = "Octave"
	int32 m_nOctave; // = 4
	// MPropertyFriendlyName = "Cents To Detune ( -100:100 )"
	float32 m_flCents;
	// MPropertyFriendlyName = "Phase ( 0 - 1 )"
	float32 m_flPhase;
	// MPropertyFriendlyName = "Envelope (Relative to Tone Envelope)"
	CPiecewiseCurve m_curve;
	CVoiceContainerStaticAdditiveSynth::CGainScalePerInstance m_volumeScaling; // = { "m_flMaxVolume": 1, "m_flMinVolume": 1, "m_nInstancesAtMaxVolume": 1, "m_nInstancesAtMinVolume": 1 }
};
