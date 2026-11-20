// MPropertyFriendlyName = "VMix Audio Convolution Node"
// MPropertyDescription = "Apply a vsnd as an impulse response (IR) to an audio signal via convolution."
// MHasKV3TransferPolymorphicClassname
class CMixConvolution : public CMixPropertyBase
{
	// MPropertyAutoExpandSelf
	VMixConvolutionDesc_t m_desc;
};
