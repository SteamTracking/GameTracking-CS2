// MHasKV3TransferPolymorphicClassname
class CNmParticleEvent : public CNmEvent
{
	CNmEventRelevance_t m_relevance; // = "ClientAndServer"
	CNmParticleEvent::Type_t m_type; // = "Create"
	CNmEventTargetEntity_t m_target; // = "Self"
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_hParticleSystem;
	CUtlString m_tags;
	bool m_bStopImmediately;
	bool m_bDetachFromOwner;
	bool m_bPlayEndCap;
	CUtlString m_attachmentPoint0;
	ParticleAttachment_t m_attachmentType0; // = "PATTACH_ABSORIGIN"
	CUtlString m_attachmentPoint1;
	ParticleAttachment_t m_attachmentType1; // = "PATTACH_ABSORIGIN"
	CUtlString m_config; // = "preview"
	CUtlString m_effectForConfig;
};
