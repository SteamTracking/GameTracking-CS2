// MHasKV3TransferPolymorphicClassname
class CLookComponent : public CAnimGraphDoc_Component
{
	// MPropertyFriendlyName = "Network Look Target"
	bool m_bNetworkLookTarget; // = true
	// MPropertySuppressField
	AnimParamID m_lookHeadingID;
	// MPropertySuppressField
	AnimParamID m_lookHeadingNormalizedID;
	// MPropertySuppressField
	AnimParamID m_lookHeadingVelocityID;
	// MPropertySuppressField
	AnimParamID m_lookPitchID;
	// MPropertySuppressField
	AnimParamID m_lookDistanceID;
	// MPropertySuppressField
	AnimParamID m_lookDirectionID;
	// MPropertySuppressField
	AnimParamID m_lookTargetID;
	// MPropertySuppressField
	AnimParamID m_lookTargetWorldSpaceID;
};
