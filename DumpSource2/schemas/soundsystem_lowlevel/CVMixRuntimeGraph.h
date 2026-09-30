class CVMixRuntimeGraph : public CVMixBaseGraphDescription
{
	// MKV3TransferName = "m_Submixes"
	CUtlLeanVector< CVMixSubmix > m_submixes;
	CUtlLeanVector< uint64 > m_impulseResponseValues;
	KeyValues3 m_inputDefaultValues;
	KeyValues3 m_sources;
	CUtlVector< VMixPointerFixupEntry_t > m_fixups;
};
