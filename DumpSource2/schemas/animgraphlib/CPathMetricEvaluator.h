// MHasKV3TransferPolymorphicClassname
class CPathMetricEvaluator : public CMotionMetricEvaluator
{
	CUtlVector< float32 > m_pathTimeSamples;
	float32 m_flDistance;
	bool m_bExtrapolateMovement;
	float32 m_flMinExtrapolationSpeed;
};
