// MHasKV3TransferPolymorphicClassname
class CVMixSteamAudioPathingProcessorDesc : public CVMixBaseProcessorDesc
{
	CVMixParameterFloat m_paramPositionX;
	CVMixParameterFloat m_paramPositionY;
	CVMixParameterFloat m_paramPositionZ;
	CVMixParameterFloat m_paramPathingMixLevel;
	CVMixParameterFloat m_paramBand;
	CVMixDataOffset m_paramArrayPathingEQ; // = { "category": "NULL_POINTER", "type": "VO_CHAR" }
	CVMixDataOffset m_paramArrayPathingCoefficients; // = { "category": "NULL_POINTER", "type": "VO_CHAR" }
};
