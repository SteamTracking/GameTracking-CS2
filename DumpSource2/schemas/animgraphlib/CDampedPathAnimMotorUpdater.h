// MHasKV3TransferPolymorphicClassname
class CDampedPathAnimMotorUpdater : public CPathAnimMotorUpdaterBase
{
	float32 m_flAnticipationTime; // = 1
	float32 m_flMinSpeedScale; // = 0.25
	CAnimParamHandle m_hAnticipationPosParam;
	CAnimParamHandle m_hAnticipationHeadingParam;
	float32 m_flSpringConstant; // = 10
	float32 m_flMinSpringTension; // = 1
	float32 m_flMaxSpringTension; // = 100
};
