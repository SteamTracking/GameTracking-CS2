class CSeqSynthAnimDesc
{
	CBufferString m_sName;
	CSeqSeqDescFlag m_flags;
	CSeqTransition m_transition;
	int16 m_nLocalBaseReference;
	int16 m_nLocalBoneMask;
	CUtlVector< CAnimActivity > m_activityArray;
};
