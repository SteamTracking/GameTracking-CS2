// MPropertyFriendlyName = "Body Group Tag"
// MHasKV3TransferPolymorphicClassname
class CBodyGroupAnimTag : public CAnimTagBase
{
	// MPropertyFriendlyName = "Priority"
	int32 m_nPriority; // = 5
	// MPropertyFriendlyName = "Body Group Settings"
	CUtlVector< CBodyGroupSetting > m_bodyGroupSettings;
};
