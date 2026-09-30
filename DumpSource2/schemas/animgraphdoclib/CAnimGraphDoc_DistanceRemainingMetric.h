// MPropertyFriendlyName = "Distance Remaining Metric"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_DistanceRemainingMetric : public CAnimGraphDoc_MotionMetric
{
	// MPropertyFriendlyName = "Maximum Tracked Distance"
	float32 m_flMaxDistance; // = 300
	// MPropertyFriendlyName = "Filter By Fixed Distance"
	// MPropertyAutoRebuildOnChange
	bool m_bFilterFixedMinDistance; // = true
	// MPropertyFriendlyName = "Min Distance"
	// MPropertyAttrStateCallback
	float32 m_flMinDistance;
	// MPropertyFriendlyName = "Filter By Goal Distance"
	// MPropertyAutoRebuildOnChange
	bool m_bFilterGoalDistance; // = true
	// MPropertyFriendlyName = "Goal Filter Start Distance"
	// MPropertyAttrStateCallback
	float32 m_flStartGoalFilterDistance; // = 150
	// MPropertyFriendlyName = "Filter By Goal Overshoot"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	bool m_bFilterGoalOvershoot;
	// MPropertyFriendlyName = "Max Goal Overshoot Scale"
	// MPropertyAttrStateCallback
	float32 m_flMaxGoalOvershootScale; // = 2
};
