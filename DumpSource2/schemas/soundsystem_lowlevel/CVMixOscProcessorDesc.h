// MHasKV3TransferPolymorphicClassname
class CVMixOscProcessorDesc : public CVMixBaseProcessorDesc
{
	VMixOscDesc_t m_desc; // = { "m_flPhase": 0, "m_freq": 440, "oscType": "LFO_SHAPE_SINE" }
	CVMixParameterFloat m_paramFrequency; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
	CVMixParameterFloat m_paramPhase; // = { "m_offset": { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" } }
};
