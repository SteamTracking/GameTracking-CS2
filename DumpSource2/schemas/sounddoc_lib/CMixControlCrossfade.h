// MPropertyFriendlyName = "VMix Crossfade Control Node"
// MPropertyDescription = "Generates two control signals from a single input that can be used to drive an equal power volume crossfade."
// MHasKV3TransferPolymorphicClassname
class CMixControlCrossfade : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Fade Start"
	float32 m_flFadeStart;
	// MPropertyFriendlyName = "Fade End"
	float32 m_flFadeEnd; // = 1
};
