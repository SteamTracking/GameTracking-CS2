// MHasKV3TransferPolymorphicClassname
class CPlayerInputAnimMotorUpdater : public CAnimMotorUpdaterBase
{
	CUtlVector< float32 > m_sampleTimes;
	float32 m_flSpringConstant;
	float32 m_flAnticipationDistance;
	CAnimParamHandle m_hAnticipationPosParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hAnticipationHeadingParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	bool m_bUseAcceleration;
};
