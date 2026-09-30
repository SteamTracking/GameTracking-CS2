class CSteamAudioBakedOcclusionData
{
	SteamAudioCustomDataOcclusionSettings_t m_settings;
	CSteamAudioProbeData m_probes;
	CUtlVector< float32 > m_vecPathingRatio;
	CUtlVector< float32 > m_vecPathingDeviation;
	CUtlVector< float32 > m_vecReflectionEnergy;
};
