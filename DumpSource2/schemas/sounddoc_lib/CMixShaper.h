// MPropertyFriendlyName = "VMix Shaper Audio Node"
// MPropertyDescription = "Apply waveshaping distortion to an audio track."
// MHasKV3TransferPolymorphicClassname
class CMixShaper : public CMixPropertyBase
{
	// MPropertyAutoExpandSelf
	VMixShaperDesc_t m_desc; // = { "m_flWetMix": 1, "m_fldbDrive": 0, "m_fldbOutputGain": 0, "m_nOversampleFactor": 1, "m_nShape": 0 }
};
