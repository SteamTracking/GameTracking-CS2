// MPropertyFriendlyName = "VMix Vocoder Audio Node"
// MPropertyDescription = "Applies multi-band modulation to a carrier signal, based on the multi-band envelope of a modulator signal.  Modulation bands can be configured to a certain number of bands or range of frequencies."
// MHasKV3TransferPolymorphicClassname
class CMixVocoder : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Vocoder Band Count"
	int32 m_nBandCount; // = 6
	// MPropertyFriendlyName = "Bandwidth"
	// MPropertyAttributeRange = "0.1 3.0"
	float32 m_flBandwidth; // = 1
	// MPropertyFriendlyName = "dB gain for modulation signal"
	// MPropertyAttributeRange = "-12 12"
	float32 m_fldBModGain; // = 12
	// MPropertyFriendlyName = "Attack time (ms)"
	float32 m_flAttackTime; // = 50
	// MPropertyFriendlyName = "Release time (ms)"
	float32 m_flReleaseTime; // = 100
	// MPropertyFriendlyName = "Frequency Start"
	// MPropertyAttributeRange = "0 11025"
	float32 m_flFreqRangeStart; // = 100
	// MPropertyFriendlyName = "Frequency End"
	// MPropertyAttributeRange = "100 22050"
	float32 m_flFreqRangeEnd; // = 12000
	// MPropertyFriendlyName = "Gain of Unvoiced"
	// MPropertyAttributeRange = "-12 12"
	float32 m_fldBUnvoicedGain;
	int32 m_nDebugBand; // = -1
	bool m_bPeakMode;
};
