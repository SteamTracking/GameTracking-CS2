class ParticleChildrenInfo_t
{
	// MPropertySuppressField
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_ChildRef;
	// MPropertyFriendlyName = "delay"
	float32 m_flDelay;
	// MPropertyFriendlyName = "end cap effect"
	bool m_bEndCap;
	// MPropertySuppressField
	bool m_bDisableChild;
	// MPropertyFriendlyName = "disable at detail levels below"
	ParticleDetailLevel_t m_nDetailLevel; // = "PARTICLEDETAIL_LOW"
};
