// MPropertyFriendlyName = "VMix Blend Audio Node"
// MPropertyDescription = "This node will do a pairwise blend through a set of audio signals.  It will blend through as many different signals as you connect.  A blend factor of 0.0 is 100% the first signal, and a blend factor of 1.0 is 100% the last signal."
// MHasKV3TransferPolymorphicClassname
class CMixBlendAudio : public CMixPropertyBase
{
	// MPropertyDescription = "Lock to inputs.  This makes each input "sticky" instead of smoothly varying between each source it will stick to one for some range of the parameter space."
	// MPropertyFriendlyName = "Lock to input (0-1)"
	float32 m_flLockAmount;
};
