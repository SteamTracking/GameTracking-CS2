// MHasKV3TransferPolymorphicClassname
class CVMixDynamicsCompressorProcessorDesc : public CVMixBaseProcessorDesc
{
	VMixDynamicsCompressorDesc_t m_desc; // = { "m_bAutoMakeupGain": false, "m_bPeakMode": false, "m_flAttackTimeMS": 100, "m_flCompressionRatio": 2, "m_flRMSTimeMS": 300, "m_flReleaseTimeMS": 400, "m_flSCHighPassFreq": 0, "m_flWetMix": 1, "m_fldbCompressionThreshold": -6, "m_fldbKneeWidth": 0, "m_fldbOutputGain": 0 }
	CVMixParameterFloat m_outParamLevel; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_outParamdBLevel; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_outParamReduction; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
};
