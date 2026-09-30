// MHasKV3TransferPolymorphicClassname
class CVMixDualCompressorProcessorDesc : public CVMixBaseProcessorDesc
{
	VMixDualCompressorDesc_t m_desc; // = { "m_bPeakMode": false, "m_bandDesc": { "m_bEnable": false, "m_bSolo": false, "m_flAttackTimeMS": 50, "m_flRatioAbove": 4, "m_flRatioBelow": 12, "m_flReleaseTimeMS": 200, "m_fldbGainInput": 0, "m_fldbGainOutput": 0, "m_fldbThresholdAbove": -30, "m_fldbThresholdBelow": -40 }, "m_flRMSTimeMS": 300, "m_flWetMix": 1, "m_fldbKneeWidth": 0 }
	CVMixParameterFloat m_outParamLevel; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_outParamdBLevel; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_outParamReduction; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
};
