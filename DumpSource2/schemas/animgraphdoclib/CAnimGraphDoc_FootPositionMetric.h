// MPropertyFriendlyName = "Foot Position Metric"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FootPositionMetric : public CAnimGraphDoc_MotionMetric
{
	// MPropertyFriendlyName = "Foot"
	// MPropertyAttributeChoiceName = "Foot"
	// MPropertyAutoExpandSelf
	CUtlVector< CUtlString > m_feet;
	// MPropertyFriendlyName = "Ignore Slope"
	bool m_bIgnoreSlope; // = true
};
