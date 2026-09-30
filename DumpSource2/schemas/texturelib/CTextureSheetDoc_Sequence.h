class CTextureSheetDoc_Sequence
{
	// MPropertyAutoRebuildOnChange
	SequenceChannelMode_t m_ChannelMode; // = "RGBA"
	SequenceLoopMode_t m_LoopMode; // = "CLAMP"
	SequenceAlphaCropMode_t m_AlphaCropMode; // = "NONE"
	// MPropertySuppressExpr = "!__SheetFileHasDecalParams"
	CTextureSheetDoc_SequenceDecalParams m_DecalParams; // = { "m_flAlignWithGravityFactor": 0, "m_flAnimationScale": 1, "m_flAnimationStartTime": 0, "m_flDepth": 4, "m_flFadeDuration": 3, "m_flScale": 1, "m_flScaleVariation": 0.25, "m_flStartFadeTime": 10, "m_nDecalRtEncoding": "kDecalInvalid" }
	// MPropertyAutoExpandSelf
	CUtlVector< CTextureSheetDoc_Frame > m_Frames;
};
