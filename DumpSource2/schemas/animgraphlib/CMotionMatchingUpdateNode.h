// MHasKV3TransferPolymorphicClassname
class CMotionMatchingUpdateNode : public CLeafUpdateNode
{
	CMotionDataSet m_dataSet;
	CUtlVector< CSmartPtr< CMotionMetricEvaluator > > m_metrics;
	CUtlVector< float32 > m_weights;
	bool m_bSearchEveryTick;
	float32 m_flSearchInterval; // = 0.1
	bool m_bSearchWhenClipEnds; // = true
	bool m_bSearchWhenGoalChanges; // = true
	CBlendCurve m_blendCurve;
	float32 m_flSampleRate; // = 0.1
	float32 m_flBlendTime; // = 0.3
	bool m_bLockClipWhenWaning;
	float32 m_flSelectionThreshold;
	float32 m_flReselectionTimeWindow; // = 0.3
	bool m_bEnableRotationCorrection; // = true
	bool m_bGoalAssist;
	float32 m_flGoalAssistDistance;
	float32 m_flGoalAssistTolerance;
	CAnimInputDamping m_distanceScale_Damping;
	float32 m_flDistanceScale_OuterRadius;
	float32 m_flDistanceScale_InnerRadius;
	float32 m_flDistanceScale_MaxScale;
	float32 m_flDistanceScale_MinScale;
	bool m_bEnableDistanceScaling;
};
