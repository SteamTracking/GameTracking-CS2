// MHasKV3TransferPolymorphicClassname
class CConcreteAnimParameter : public CAnimParameterBase
{
	// MPropertyFriendlyName = "Preview Button"
	AnimParamButton_t m_previewButton;
	// MPropertyFriendlyName = "Network"
	AnimParamNetworkSetting m_eNetworkSetting;
	// MPropertyFriendlyName = "Force Latest Value"
	bool m_bUseMostRecentValue;
	// MPropertyFriendlyName = "Auto Reset"
	bool m_bAutoReset;
	// MPropertyFriendlyName = "Game Writable"
	// MPropertyGroupName = "+Permissions"
	// MPropertyAttrStateCallback
	bool m_bGameWritable;
	// MPropertyFriendlyName = "Graph Writable"
	// MPropertyGroupName = "+Permissions"
	// MPropertyAttrStateCallback
	bool m_bGraphWritable;
};
