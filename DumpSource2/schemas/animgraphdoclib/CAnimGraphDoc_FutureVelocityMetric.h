// MPropertyFriendlyName = "Future Velocity Metric"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FutureVelocityMetric : public CAnimGraphDoc_MotionMetric
{
	// MPropertyFriendlyName = "Distance"
	float32 m_flDistance; // = 100
	// MPropertyFriendlyName = "Stopping Distance"
	float32 m_flStoppingDistance; // = 100
	// MPropertyFriendlyName = "Mode"
	// MPropertyAutoRebuildOnChange
	VelocityMetricMode m_eMode; // = "DirectionAndMagnitude"
	// MPropertyFriendlyName = "Auto-Calculate target speed"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	bool m_bAutoTargetSpeed; // = true
	// MPropertyFriendlyName = "Target Speed"
	// MPropertyAttrStateCallback
	float32 m_flManualTargetSpeed; // = 150
};
