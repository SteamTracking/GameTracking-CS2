class WorldBuilderParams_t
{
	float32 m_flMinDrawVolumeSize;
	bool m_bBuildBakedLighting;
	bool m_bAggregateInstanceStreams;
	BakedLightingInfo_t m_bakedLightingInfo; // = { "m_bBakedShadowsGamma20": false, "m_bCompressionEnabled": false, "m_bHasLightmaps": false, "m_bakedShadows": [  ], "m_lightMaps": [  ], "m_nChartPackIterations": 0, "m_nLPVEncoding": -1, "m_nLightmapEncoding": -1, "m_nLightmapGameVersionNumber": 0, "m_nLightmapVersionNumber": 0, "m_nVradQuality": 0, "m_vLightmapUvScale": [ 1, 1 ] }
	uint64 m_nCompileTimestamp;
	uint64 m_nCompileFingerprint;
};
