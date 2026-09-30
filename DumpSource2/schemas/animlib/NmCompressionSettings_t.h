class NmCompressionSettings_t
{
	NmCompressionSettings_t::QuantizationRange_t m_translationRangeX; // = { "m_flRangeLength": -1, "m_flRangeStart": 0 }
	NmCompressionSettings_t::QuantizationRange_t m_translationRangeY; // = { "m_flRangeLength": -1, "m_flRangeStart": 0 }
	NmCompressionSettings_t::QuantizationRange_t m_translationRangeZ; // = { "m_flRangeLength": -1, "m_flRangeStart": 0 }
	NmCompressionSettings_t::QuantizationRange_t m_scaleRange; // = { "m_flRangeLength": -1, "m_flRangeStart": 0 }
	int32 m_nTrackReadOffset;
	Quaternion m_constantRotation;
	bool m_bIsRotationStatic;
	bool m_bIsTranslationStatic;
	bool m_bIsScaleStatic;
};
