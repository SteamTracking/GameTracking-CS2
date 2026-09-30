// MPropertyFriendlyName = "Mix Amp"
// MPropertyDescription = "Adjust the volume of an audio track."
// MHasKV3TransferPolymorphicClassname
class CMixAmp : public CMixPropertyBase
{
	// MPropertyDescription = "Default volume scale (0-1) if not automated by connecting the volume input."
	float32 m_flVolume; // = 1
};
