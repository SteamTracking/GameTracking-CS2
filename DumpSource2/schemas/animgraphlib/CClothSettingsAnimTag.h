// MPropertyFriendlyName = "Cloth Settings Tag"
// MHasKV3TransferPolymorphicClassname
class CClothSettingsAnimTag : public CAnimTagBase
{
	// MPropertyFriendlyName = "Stiffness"
	// MPropertyAttributeRange = "0 1"
	float32 m_flStiffness; // = 1
	// MPropertyFriendlyName = "EaseIn"
	// MPropertyAttributeRange = "0 1"
	float32 m_flEaseIn;
	// MPropertyFriendlyName = "EaseOut"
	// MPropertyAttributeRange = "0 1"
	float32 m_flEaseOut;
	// MPropertyFriendlyName = "VertexSet"
	CUtlString m_nVertexSet;
};
