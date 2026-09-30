// MPropertyFriendlyName = "VMix Utility Audio Node"
// MPropertyDescription = "Adjust the stereo spread/pan/balance of a signal or convert it to mono or mid/side."
// MHasKV3TransferPolymorphicClassname
class CMixUtility : public CMixPropertyBase
{
	// MPropertyAutoExpandSelf
	VMixUtilityDesc_t m_desc; // = { "m_bBassMono": false, "m_flBassFreq": 120, "m_flInputPan": 0, "m_flOutputBalance": 0, "m_fldbOutputGain": 0, "m_nOp": "VMIX_CHAN_STEREO" }
};
