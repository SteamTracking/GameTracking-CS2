class CVSound
{
	CUtlLeanVector< CAudioSentence > m_Sentences;
	int32 m_nRate;
	CVSoundFormat_t m_nFormat; // = "PCM16"
	uint32 m_nChannels;
	int32 m_nLoopStart;
	uint32 m_nSampleCount;
	float32 m_flDuration;
	uint32 m_nStreamingSize;
	int32 m_nLoopEnd;
};
