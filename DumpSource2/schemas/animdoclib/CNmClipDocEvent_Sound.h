// MHasKV3TransferPolymorphicClassname
class CNmClipDocEvent_Sound : public CNmClipDocEvent
{
	CNmEventRelevance_t m_relevance; // = "ClientAndServer"
	// MPropertyAttrStateCallback
	bool m_bContinuePlayingSoundAtDurationEnd;
	// MPropertyAttrStateCallback
	float32 m_flDurationInterruptionThreshold; // = 0.9
	// MPropertyStartGroup = "+Sound"
	// MPropertyAttributeEditor = "SoundPicker()"
	CUtlString m_name;
	// MPropertyStartGroup = "+Position"
	CNmSoundEvent::Position_t m_position; // = "None"
	CUtlString m_attachmentName;
	// MPropertyStartGroup = "+Metadata"
	CUtlString m_tags;
};
