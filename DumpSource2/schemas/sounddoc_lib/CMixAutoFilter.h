// MPropertyFriendlyName = "VMix Auto Filter Node"
// MPropertyDescription = "A continuously variable filter that can be driven by a built-in envelope follower and/or LFO.  Stereo channels can be processed differently by adjusting the phase parameter."
// MHasKV3TransferPolymorphicClassname
class CMixAutoFilter : public CMixPropertyBase
{
	// MPropertyAutoExpandSelf
	VMixAutoFilterDesc_t m_desc; // = { "m_filter": { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_LOWPASS" }, "m_flAttackTimeMS": 5, "m_flEnvelopeAmount": 0, "m_flLFOAmount": 0, "m_flLFORate": 0, "m_flPhase": 0, "m_flReleaseTimeMS": 200, "m_nLFOShape": "LFO_SHAPE_SINE" }
};
