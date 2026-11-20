// MHasKV3TransferPolymorphicClassname
class CPlayerInputAnimMotorUpdater : public CAnimMotorUpdaterBase
{
	CUtlVector< float32 > m_sampleTimes;
	float32 m_flSpringConstant;
	float32 m_flAnticipationDistance;
	CAnimParamHandle m_hAnticipationPosParam;
	CAnimParamHandle m_hAnticipationHeadingParam;
	bool m_bUseAcceleration;
};
