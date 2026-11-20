// MHasKV3TransferPolymorphicClassname
class CVMixSteamAudioHybridReverbProcessorDesc : public CVMixBaseProcessorDesc
{
	CVMixParameterFloat m_paramReverbTimeLow;
	CVMixParameterFloat m_paramReverbTimeMid;
	CVMixParameterFloat m_paramReverbTimeHigh;
	CVMixParameterFloat m_paramBand;
	CVMixDataOffset m_paramReverbTime; // = { "category": "NULL_POINTER", "type": "VO_CHAR" }
};
