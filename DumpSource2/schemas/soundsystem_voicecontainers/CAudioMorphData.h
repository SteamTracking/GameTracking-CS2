class CAudioMorphData
{
	CUtlVector< float32 > m_times;
	CUtlVector< uint32 > m_nameHashCodes;
	CUtlVector< CUtlString > m_nameStrings;
	CUtlVector< CUtlVector< float32 > > m_samples;
	float32 m_flEaseIn; // = 0.2
	float32 m_flEaseOut; // = 0.2
};
