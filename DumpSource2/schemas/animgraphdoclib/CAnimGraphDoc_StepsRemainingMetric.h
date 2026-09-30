// MPropertyFriendlyName = "Steps Remaining Metric"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_StepsRemainingMetric : public CAnimGraphDoc_MotionMetric
{
	// MPropertyFriendlyName = "Feet"
	// MPropertyAttributeChoiceName = "Foot"
	// MPropertyAutoExpandSelf
	CUtlVector< CUtlString > m_feet;
	// MPropertyFriendlyName = "Min Steps Remaining"
	float32 m_flMinStepsRemaining; // = 1
};
