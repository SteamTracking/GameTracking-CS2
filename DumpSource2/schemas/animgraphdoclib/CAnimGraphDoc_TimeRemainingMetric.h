// MPropertyFriendlyName = "Time Remaining Metric"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_TimeRemainingMetric : public CAnimGraphDoc_MotionMetric
{
	// MPropertyFriendlyName = "Match Time Remaining"
	// MPropertyGroupName = ""
	// MPropertyAutoRebuildOnChange
	bool m_bMatchByTimeRemaining;
	// MPropertyFriendlyName = "Max Time Remaining"
	// MPropertyAttrStateCallback
	float32 m_flMaxTimeRemaining; // = 1
	// MPropertyFriendlyName = "Filter By Time Remaining"
	// MPropertyAutoRebuildOnChange
	bool m_bFilterByTimeRemaining; // = true
	// MPropertyFriendlyName = "Min Time Remaining"
	// MPropertyAttrStateCallback
	float32 m_flMinTimeRemaining; // = 0.3
};
