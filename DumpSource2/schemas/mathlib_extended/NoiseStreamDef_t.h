class NoiseStreamDef_t
{
	NoiseStreamType_t m_nType; // = "NOISE_STREAM_TYPE_PERLIN"
	NoiseStreamModifier_t m_nModifier; // = "NOISE_STREAM_MODIFIER_NONE"
	NoiseStreamTurbulence_t m_nTurbulence; // = "NOISE_STREAM_TURB_NONE"
	// MPropertyAttributeRange = "-10000 10000"
	float32 m_flOutputMin;
	// MPropertyAttributeRange = "-10000 10000"
	float32 m_flOutputMax; // = 1
	// MPropertyAttributeRange = "biased 0.001 100"
	float32 m_flScale; // = 0.1
	Vector m_vOffsetRate;
	// MPropertyAttributeRange = "-1000 1000"
	float32 m_flOffset;
	// MPropertyAttributeRange = "1 4"
	int32 m_nOctaves; // = 1
	// MPropertyAttributeRange = "0 10"
	float32 m_flTurbulenceScale; // = 1.25
	// MPropertyAttributeRange = "0 1"
	float32 m_flTurbulenceMix; // = 0.5
	CUtlVector< NoiseOscillatorDef_t > m_Oscillators;
};
