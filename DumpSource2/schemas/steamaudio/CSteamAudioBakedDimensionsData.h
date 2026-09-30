class CSteamAudioBakedDimensionsData
{
	SteamAudioCustomDataDimensionsSettings_t m_settings;
	CSteamAudioProbeData m_probes;
	CUtlVector< float32 > m_vecInOut;
	CUtlVector< float32 > m_vecSize;
	CUtlVector< CSteamAudioAmbisonicsField > m_vecOutsideField;
	CUtlVector< CSteamAudioAmbisonicsField > m_vecInsideSmallSizeField;
	CSteamAudioMovableBakedData< CSteamAudioBakedDimensionsData > m_movables;
};
