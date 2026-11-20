// MPropertyFriendlyName = "VMix Dual Compressor Node"
// MPropertyDescription = "Compress the dynamic range of both ends of a signal."
// MHasKV3TransferPolymorphicClassname
class CMixDualCompressor : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 m_nChannels; // = -1
	// MPropertyAutoExpandSelf
	VMixDualCompressorDesc_t m_desc; // = { "m_bandDesc": { "m_bEnable": true } }
};
