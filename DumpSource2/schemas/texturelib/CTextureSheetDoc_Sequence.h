class CTextureSheetDoc_Sequence
{
	// MPropertyAutoRebuildOnChange
	SequenceChannelMode_t m_ChannelMode; // = "RGBA"
	SequenceLoopMode_t m_LoopMode; // = "CLAMP"
	SequenceAlphaCropMode_t m_AlphaCropMode; // = "NONE"
	// MPropertySuppressExpr = "!__SheetFileHasDecalParams"
	CTextureSheetDoc_SequenceDecalParams m_DecalParams;
	// MPropertyAutoExpandSelf
	CUtlVector< CTextureSheetDoc_Frame > m_Frames;
};
