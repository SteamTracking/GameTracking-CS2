// MHasKV3TransferPolymorphicClassname
class CVMixFilterProcessorDesc : public CVMixBaseProcessorDesc
{
	VMixFilterDesc_t m_desc; // = { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_UNKNOWN" }
	CVMixParameterFloat m_paramCutoffFreq; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_paramQ; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
};
