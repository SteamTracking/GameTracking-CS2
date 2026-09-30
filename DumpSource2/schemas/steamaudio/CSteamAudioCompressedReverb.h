class CSteamAudioCompressedReverb
{
	int32 m_nChannels;
	int32 m_nBands;
	int32 m_nBins;
	int32 m_nProbes;
	CUtlVector< int32 > m_vecNumSingularValues;
	CUtlVector< float32 > m_vecDictionary;
	CUtlVector< float32 > m_vecCompressedData;
	IPLCompressedEnergyFields m_pCompressedData;
};
