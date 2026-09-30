// MHasKV3TransferPolymorphicClassname
class CVMixDelayProcessorDesc : public CVMixBaseProcessorDesc
{
	VMixDelayDesc_t m_desc; // = { "m_bEnableFilter": false, "m_feedbackFilter": { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_UNKNOWN" }, "m_flDelay": 0, "m_flDelayGain": 0, "m_flDirectGain": 0, "m_flFeedbackGain": 0, "m_flWidth": 0 }
	CVMixParameterFloat m_paramCutoffFrequency; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_paramDelay; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
};
