// MPropertyFriendlyName = "VMix Auto Filter Node"
// MPropertyDescription = "A continuously variable filter that can be driven by a built-in envelope follower and/or LFO.  Stereo channels can be processed differently by adjusting the phase parameter."
// MHasKV3TransferPolymorphicClassname
class CMixAutoFilter : public CMixPropertyBase
{
	// MPropertyAutoExpandSelf
	VMixAutoFilterDesc_t m_desc; // = { "m_filter": { "m_nFilterType": "FILTER_LOWPASS" } }
};
