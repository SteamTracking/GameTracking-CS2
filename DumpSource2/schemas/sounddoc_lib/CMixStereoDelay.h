// MPropertyFriendlyName = "VMix Stereo Delay Audio Node"
// MPropertyDescription = "A simple delay with separate left & right delay times."
// MHasKV3TransferPolymorphicClassname
class CMixStereoDelay : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Left Channel Delay (in seconds)"
	// MPropertyAttributeRange = "0 100"
	float32 m_flDelayLeft;
	// MPropertyFriendlyName = "Right Channel Delay (in seconds)"
	// MPropertyAttributeRange = "0 100"
	float32 m_flDelayRight;
};
