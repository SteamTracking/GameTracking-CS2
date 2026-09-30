// MPropertyFriendlyName = "VMix Dual Compressor Node"
// MPropertyDescription = "Compress the dynamic range of both ends of a signal."
// MHasKV3TransferPolymorphicClassname
class CMixDualCompressor : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyAutoExpandSelf
	VMixDualCompressorDesc_t m_desc; // = { "m_bPeakMode": false, "m_bandDesc": { "m_bEnable": true, "m_bSolo": false, "m_flAttackTimeMS": 50, "m_flRatioAbove": 4, "m_flRatioBelow": 12, "m_flReleaseTimeMS": 200, "m_fldbGainInput": 0, "m_fldbGainOutput": 0, "m_fldbThresholdAbove": -30, "m_fldbThresholdBelow": -40 }, "m_flRMSTimeMS": 300, "m_flWetMix": 1, "m_fldbKneeWidth": 0 }
};
