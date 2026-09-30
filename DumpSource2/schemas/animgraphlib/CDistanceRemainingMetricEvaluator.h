// MHasKV3TransferPolymorphicClassname
class CDistanceRemainingMetricEvaluator : public CMotionMetricEvaluator
{
	float32 m_flMaxDistance;
	float32 m_flMinDistance;
	float32 m_flStartGoalFilterDistance;
	float32 m_flMaxGoalOvershootScale;
	bool m_bFilterFixedMinDistance;
	bool m_bFilterGoalDistance;
	bool m_bFilterGoalOvershoot;
};
