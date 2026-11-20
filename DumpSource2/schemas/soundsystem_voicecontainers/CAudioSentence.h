class CAudioSentence
{
	bool m_bShouldVoiceDuck;
	CUtlVector< CAudioPhonemeTag > m_RunTimePhonemes;
	CUtlVector< CAudioEmphasisSample > m_EmphasisSamples;
	CAudioMorphData m_morphData;
};
