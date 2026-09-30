class PostProcessingResource_t
{
	bool m_bHasTonemapParams;
	PostProcessingTonemapParameters_t m_toneMapParams;
	bool m_bHasBloomParams;
	PostProcessingBloomParameters_t m_bloomParams; // = { "m_blendMode": "BLOOM_BLEND_ADD", "m_flBloomStartValue": 1, "m_flBloomStrength": 2, "m_flBloomThreshold": 0, "m_flBloomThresholdWidth": 1, "m_flBlurBloomStrength": 1, "m_flBlurWeight": [ 0.2, 0.2, 0.2, 0.2, 0.2 ], "m_flComputeBloomEffectsScale": 1, "m_flComputeBloomLensDirtBlackLevel": 0.1, "m_flComputeBloomLensDirtStrength": 0, "m_flComputeBloomRadius": 0.6, "m_flComputeBloomStrength": 0.03, "m_flComputeBloomThreshold": 1, "m_flScreenBloomStrength": 1, "m_flSkyboxBloomStrength": 1, "m_vBlurTint": [ [ 1, 1, 1 ], [ 1, 1, 1 ], [ 1, 1, 1 ], [ 1, 1, 1 ], [ 1, 1, 1 ] ] }
	bool m_bHasVignetteParams;
	PostProcessingVignetteParameters_t m_vignetteParams; // = { "m_flFeather": 0.5, "m_flRadius": 0.5, "m_flRoundness": 1, "m_flVignetteStrength": 0, "m_vCenter": [ 0, 0 ], "m_vColorTint": [ 1, 1, 1 ] }
	bool m_bHasLocalContrastParams;
	PostProcessingLocalContrastParameters_t m_localConstrastParams;
	int32 m_nColorCorrectionVolumeDim;
	CUtlBinaryBlock m_colorCorrectionVolumeData; // = "[BINARY BLOB]"
	bool m_bHasColorCorrection; // = true
	bool m_bHasFogScatteringParams;
	PostProcessingFogScatteringParameters_t m_fogScatteringParams; // = { "m_fCubemapScale": 1, "m_fGradientScale": 1, "m_fRadius": 0.75, "m_fScale": 0, "m_fVolumetricScale": 1, "m_fWaterDensity": 0, "m_fWaterDepthBlurRadius": 0, "m_fWaterScale": 0 }
	bool m_bHasLocalExposureParams;
	PostProcessingLocalExposureParameters_t m_localExposureParams; // = { "m_fBoostLocalContrast": 0, "m_fHighlightOffsetEV": 0, "m_fShadowOffsetEV": 0, "m_fSigma": 0.5 }
};
