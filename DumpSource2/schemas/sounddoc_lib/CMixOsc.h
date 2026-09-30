// MPropertyFriendlyName = "VMix Oscillator Audio Node"
// MPropertyDescription = "Generates a tone as an audio track."
// MHasKV3TransferPolymorphicClassname
class CMixOsc : public CMixPropertyBase
{
	// MPropertyAutoExpandSelf
	VMixOscDesc_t m_desc; // = { "m_flPhase": 0, "m_freq": 440, "oscType": "LFO_SHAPE_SINE" }
};
