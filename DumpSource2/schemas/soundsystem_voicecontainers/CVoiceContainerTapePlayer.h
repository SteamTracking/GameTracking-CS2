// MPropertyFriendlyName = "Tape Player"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerTapePlayer : public CVoiceContainerAsyncGenerator
{
	bool m_bShouldWraparound;
	CStrongHandle< InfoForResourceTypeCVoiceContainerBase > m_sourceAudio;
	float32 m_flTapeSpeedAttackTime; // = 0.3
	float32 m_flTapeSpeedReleaseTime; // = 0.7
};
