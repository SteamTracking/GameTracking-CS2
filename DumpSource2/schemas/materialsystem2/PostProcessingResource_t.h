class PostProcessingResource_t
{
	bool m_bHasTonemapParams;
	PostProcessingTonemapParameters_t m_toneMapParams;
	bool m_bHasBloomParams;
	PostProcessingBloomParameters_t m_bloomParams;
	bool m_bHasVignetteParams;
	PostProcessingVignetteParameters_t m_vignetteParams;
	bool m_bHasLocalContrastParams;
	PostProcessingLocalContrastParameters_t m_localConstrastParams;
	int32 m_nColorCorrectionVolumeDim;
	CUtlBinaryBlock m_colorCorrectionVolumeData; // = "[BINARY BLOB]"
	bool m_bHasColorCorrection; // = true
	bool m_bHasFogScatteringParams;
	PostProcessingFogScatteringParameters_t m_fogScatteringParams;
	bool m_bHasLocalExposureParams;
	PostProcessingLocalExposureParameters_t m_localExposureParams;
};
