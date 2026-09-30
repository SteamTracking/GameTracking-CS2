class CAudioSentence
{
	bool m_bShouldVoiceDuck;
	CUtlVector< CAudioPhonemeTag > m_RunTimePhonemes;
	CUtlVector< CAudioEmphasisSample > m_EmphasisSamples;
	CAudioMorphData m_morphData; // = { "m_flEaseIn": 0.2, "m_flEaseOut": 0.2, "m_nameHashCodes": [  ], "m_nameStrings": [  ], "m_samples": [  ], "m_times": [  ] }
};
