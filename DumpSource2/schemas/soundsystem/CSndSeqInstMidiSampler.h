// MPropertyFriendlyName = "Midi Sampler"
// MHasKV3TransferPolymorphicClassname
class CSndSeqInstMidiSampler : public CSndSeqInstBaseSchema
{
	bool m_bIsSoundEvent;
	bool m_bStopPrevious; // = true
	uint8 m_nMinNote;
	uint8 m_nMaxNote;
	float32 m_flMinVelocityAtten;
	float32 m_flMaxVelocityAtten;
	float32 m_flAttack;
	float32 m_flRelease;
	bool m_bBeatEnvelopes; // = true
	uint8 m_nNextVoiceSlot;
	uint32 m_hSoundEventHash;
};
