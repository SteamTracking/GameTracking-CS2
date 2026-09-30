// MHasKV3TransferPolymorphicClassname
class CNmSoundEvent : public CNmEvent
{
	CNmEventRelevance_t m_relevance; // = "ClientAndServer"
	CUtlString m_name;
	CNmSoundEvent::Position_t m_position; // = "None"
	CUtlString m_attachmentName;
	CUtlString m_tags;
	bool m_bContinuePlayingSoundAtDurationEnd;
	float32 m_flDurationInterruptionThreshold; // = 0.9
};
