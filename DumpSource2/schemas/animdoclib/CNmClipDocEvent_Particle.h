// MHasKV3TransferPolymorphicClassname
class CNmClipDocEvent_Particle : public CNmClipDocEvent
{
	CNmEventRelevance_t m_relevance; // = "ClientAndServer"
	// MPropertyAutoRebuildOnChange
	CNmParticleEvent::Type_t m_type; // = "Create"
	CNmEventTargetEntity_t m_target; // = "Self"
	// MPropertyStartGroup = "+Particle"
	// MPropertyAttributeEditor = "AssetBrowse( vpcf, *requiredoubleclick )"
	CUtlString m_particleSystem;
	bool m_bDetachFromOwner;
	bool m_bStopImmediately;
	bool m_bPlayEndCap;
	// MPropertyStartGroup = "+Attachment"
	// MPropertyAttrStateCallback
	CUtlString m_attachmentPoint0;
	// MPropertyAttrStateCallback
	ParticleAttachment_t m_attachmentType0; // = "PATTACH_INVALID"
	// MPropertyAttrStateCallback
	CUtlString m_attachmentPoint1;
	// MPropertyAttrStateCallback
	ParticleAttachment_t m_attachmentType1; // = "PATTACH_INVALID"
	// MPropertyStartGroup = "+Config"
	// MPropertyAttrStateCallback
	CUtlString m_config;
	// MPropertyAttrStateCallback
	CUtlString m_effectForConfig;
	// MPropertyStartGroup = "+Metadata"
	CUtlString m_tags;
};
