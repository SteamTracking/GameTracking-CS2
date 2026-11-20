// MPropertyFriendlyName = "VMix Compressor/Limiter Node"
// MPropertyDescription = "Compress the dynamic range of a signal when it is louder than some threshold."
// MHasKV3TransferPolymorphicClassname
class CMixDynamicsCompressor : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyAutoExpandSelf
	VMixDynamicsCompressorDesc_t m_desc;
	int32 m_nUIPage; // = 1
	bool m_bIsLimiter;
};
