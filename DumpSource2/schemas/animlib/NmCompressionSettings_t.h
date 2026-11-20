class NmCompressionSettings_t
{
	NmCompressionSettings_t::QuantizationRange_t m_translationRangeX;
	NmCompressionSettings_t::QuantizationRange_t m_translationRangeY;
	NmCompressionSettings_t::QuantizationRange_t m_translationRangeZ;
	NmCompressionSettings_t::QuantizationRange_t m_scaleRange;
	int32 m_nTrackReadOffset;
	Quaternion m_constantRotation;
	bool m_bIsRotationStatic;
	bool m_bIsTranslationStatic;
	bool m_bIsScaleStatic;
};
