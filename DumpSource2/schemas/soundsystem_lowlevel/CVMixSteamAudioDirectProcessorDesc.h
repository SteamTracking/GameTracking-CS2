// MHasKV3TransferPolymorphicClassname
class CVMixSteamAudioDirectProcessorDesc : public CVMixBaseProcessorDesc
{
	CVMixParameterFloat m_paramPositionX;
	CVMixParameterFloat m_paramPositionY;
	CVMixParameterFloat m_paramPositionZ;
	CVMixParameterFloat m_paramRightX;
	CVMixParameterFloat m_paramRightY;
	CVMixParameterFloat m_paramRightZ;
	CVMixParameterFloat m_paramUpX;
	CVMixParameterFloat m_paramUpY;
	CVMixParameterFloat m_paramUpZ;
	CVMixParameterFloat m_paramAheadX;
	CVMixParameterFloat m_paramAheadY;
	CVMixParameterFloat m_paramAheadZ;
	CVMixParameterFloat m_paramApplyDistanceAttenuation;
	CVMixParameterFloat m_paramApplyAirAbsorption;
	CVMixParameterFloat m_paramApplyDirectivity;
	CVMixParameterFloat m_paramApplyOcclusion;
	CVMixParameterFloat m_paramApplyTransmission;
	CVMixParameterFloat m_paramDipoleWeight;
	CVMixParameterFloat m_paramDipolePower;
	CVMixParameterFloat m_paramOcclusion;
	CVMixParameterFloat m_paramTransmissionLow;
	CVMixParameterFloat m_paramTransmissionMid;
	CVMixParameterFloat m_paramTransmissionHigh;
	CVMixParameterFloat m_paramBand;
	CVMixDataOffset m_paramTransmission; // = { "category": "NULL_POINTER", "type": "VO_CHAR" }
};
