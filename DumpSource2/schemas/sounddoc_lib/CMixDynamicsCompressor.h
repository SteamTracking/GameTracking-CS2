// MPropertyFriendlyName = "VMix Compressor/Limiter Node"
// MPropertyDescription = "Compress the dynamic range of a signal when it is louder than some threshold."
// MHasKV3TransferPolymorphicClassname
class CMixDynamicsCompressor : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyAutoExpandSelf
	VMixDynamicsCompressorDesc_t m_desc; // = { "m_bAutoMakeupGain": false, "m_bPeakMode": false, "m_flAttackTimeMS": 100, "m_flCompressionRatio": 2, "m_flRMSTimeMS": 300, "m_flReleaseTimeMS": 400, "m_flSCHighPassFreq": 0, "m_flWetMix": 1, "m_fldbCompressionThreshold": -6, "m_fldbKneeWidth": 0, "m_fldbOutputGain": 0 }
	int32 m_nUIPage; // = 1
	bool m_bIsLimiter;
};
