class CSeqS1SeqDesc
{
	CBufferString m_sName;
	CSeqSeqDescFlag m_flags;
	CSeqMultiFetch m_fetch;
	int32 m_nLocalWeightlist;
	CUtlVector< CSeqAutoLayer > m_autoLayerArray;
	CUtlVector< CSeqIKLock > m_IKLockArray;
	CSeqTransition m_transition;
	KeyValues3 m_SequenceKeys;
	// MKV3TransferName = "m_keyValueText"
	CBufferString m_LegacyKeyValueText;
	CUtlVector< CAnimActivity > m_activityArray;
	CUtlVector< CFootMotion > m_footMotion;
};
