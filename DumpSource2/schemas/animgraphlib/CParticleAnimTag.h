// MPropertyFriendlyName = "Particle Tag"
// MHasKV3TransferPolymorphicClassname
class CParticleAnimTag : public CAnimTagBase
{
	// MPropertySuppressField
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_hParticleSystem;
	// MPropertyAttributeEditor = "AssetBrowse( vpcf )"
	// MPropertyFriendlyName = "Particle System"
	CUtlString m_particleSystemName;
	// MPropertyFriendlyName = "Configuration"
	CUtlString m_configName;
	// MPropertyFriendlyName = "Detach From Owner"
	bool m_bDetachFromOwner;
	// MPropertyFriendlyName = "Attempt to Aggregate"
	bool m_bAggregate;
	// MPropertyFriendlyName = "Stop on Tag End"
	// MPropertyGroupName = "Ending"
	bool m_bStopWhenTagEnds;
	// MPropertyFriendlyName = "Tag End Stop is Instant"
	// MPropertyGroupName = "Ending"
	bool m_bTagEndStopIsInstant;
	// MPropertyFriendlyName = "Attachment"
	// MPropertyGroupName = "Attachments"
	// MPropertyAttributeChoiceName = "Attachment"
	CUtlString m_attachmentName;
	// MPropertyFriendlyName = "Attachment Type"
	// MPropertyGroupName = "Attachments"
	ParticleAttachment_t m_attachmentType; // = "PATTACH_POINT_FOLLOW"
	// MPropertyFriendlyName = "Attachment (Control Point 1)"
	// MPropertyGroupName = "Attachments"
	// MPropertyAttributeChoiceName = "Attachment"
	CUtlString m_attachmentCP1Name;
	// MPropertyFriendlyName = "Attachment Type (Control Point 1)"
	// MPropertyGroupName = "Attachments"
	ParticleAttachment_t m_attachmentCP1Type; // = "PATTACH_INVALID"
};
