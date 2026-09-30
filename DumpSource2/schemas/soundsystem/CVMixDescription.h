class CVMixDescription : public CVMixBaseGraphDescription
{
	// MKV3TransferName = "m_Submixes"
	CUtlLeanVector< CSubmix > m_submixList;
	CUtlLeanVector< std::unique_ptr< CVoiceContainerBase > > m_sources;
	CUtlLeanVector< uint64 > m_impulseResponseValues;
	uint32 m_nNameHashCode;
};
