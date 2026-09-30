class CSteamAudioBakedReverbData
{
	int32 m_nBands; // = 3
	CSteamAudioSceneData m_scene;
	CSteamAudioProbeData m_probes;
	CSteamAudioProbeGrid m_grid;
	SteamAudioReverbSettings_t m_reverbSettings;
	SteamAudioReverbClusteringSettings_t m_reverbClusteringSettings;
	SteamAudioReverbCompressionSettings_t m_reverbCompressionSettings; // = { "m_bEnableCompression": false, "m_flQuality": 0.95 }
	CSteamAudioProbeData m_clusteredProbes;
	CUtlVector< int16 > m_vecClusterForProbe;
	CSteamAudioCompressedReverb m_compressedData;
	CSteamAudioCompressedReverb m_compressedClusteredData;
	CSteamAudioMovableBakedData< CSteamAudioBakedReverbData > m_movables;
};
