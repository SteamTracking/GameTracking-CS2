// MPropertyFriendlyName = "Loop XFade"
// MPropertyDescription = "Sample accurate looping with xfade capabilities."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerLoopXFade : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Vsnd Reference"
	CSoundContainerReference m_sound;
	float32 m_flLoopEnd;
	float32 m_flLoopStart;
	float32 m_flFadeOut;
	float32 m_flFadeIn;
	bool m_bPlayHead;
	bool m_bPlayTail;
	bool m_bEqualPow;
};
