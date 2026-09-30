class CNmFloatChannelData
{
	CStrongHandle< InfoForResourceTypeCNmSkeleton > m_skeleton;
	CGlobalSymbol m_setID;
	CUtlVector< CNmFloatChannelData::ChannelSettings_t > m_channelSettings;
	CUtlVector< uint16 > m_compressedData;
	CUtlVector< uint32 > m_compressedOffsets;
};
