// MPropertyFriendlyName = "VMix Audio Meter Node"
// MPropertyDescription = "This lets you meter an audio signal in vmixtool."
// MHasKV3TransferPolymorphicClassname
class CMixAudioMeter : public CMixPropertyBase
{
	float32 m_flLeftLevel;
	float32 m_flLeftPeak;
	float32 m_flRightLevel;
	float32 m_flRightPeak;
};
