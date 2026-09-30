class PostProcessingBloomParameters_t
{
	BloomBlendMode_t m_blendMode; // = "BLOOM_BLEND_ADD"
	float32 m_flBloomStrength; // = 2
	float32 m_flScreenBloomStrength; // = 1
	float32 m_flBlurBloomStrength; // = 1
	float32 m_flBloomThreshold;
	float32 m_flBloomThresholdWidth; // = 1
	float32 m_flSkyboxBloomStrength; // = 1
	float32 m_flBloomStartValue; // = 1
	float32 m_flComputeBloomStrength; // = 0.03
	float32 m_flComputeBloomThreshold; // = 1
	float32 m_flComputeBloomRadius; // = 0.6
	float32 m_flComputeBloomEffectsScale; // = 1
	float32 m_flComputeBloomLensDirtStrength;
	float32 m_flComputeBloomLensDirtBlackLevel; // = 0.1
	float32[5] m_flBlurWeight; // = [ 0.2, 0.2, 0.2, 0.2, 0.2 ]
	Vector[5] m_vBlurTint; // = [ [ 1, 1, 1 ], [ 1, 1, 1 ], [ 1, 1, 1 ], [ 1, 1, 1 ], [ 1, 1, 1 ] ]
};
