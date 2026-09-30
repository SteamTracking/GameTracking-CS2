// MHasKV3TransferPolymorphicClassname
class CVMixModDelayProcessorDesc : public CVMixBaseProcessorDesc
{
	VMixModDelayDesc_t m_desc; // = { "m_bApplyAntialiasing": false, "m_bPhaseInvert": false, "m_feedbackFilter": { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_UNKNOWN" }, "m_flDelay": 0, "m_flFeedbackGain": 0, "m_flGlideTime": 0, "m_flModDepth": 0, "m_flModRate": 0, "m_flOutputGain": 0 }
	CVMixParameterFloat m_paramCutoffFrequency; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_paramDelay; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_paramModRate; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_paramModDepth; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
};
