// MPropertyFriendlyName = "VMix Panner Audio Node"
// MPropertyDescription = "Adjust the stereo panning of an audio track."
// MHasKV3TransferPolymorphicClassname
class CMixPanner : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Type"
	VMixPannerType_t m_type; // = "PANNER_TYPE_EQUAL_POWER"
	// MPropertyFriendlyName = "Strength"
	// MPropertyAttributeRange = "0 1"
	float32 m_flStrength; // = 1
};
