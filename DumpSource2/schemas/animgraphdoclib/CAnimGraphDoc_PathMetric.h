// MPropertyFriendlyName = "Path Metric"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_PathMetric : public CAnimGraphDoc_MotionMetric
{
	// MPropertyFriendlyName = "Distance"
	float32 m_flDistance; // = 100
	// MPropertyFriendlyName = "Samples Times"
	CUtlVector< float32 > m_pathSamples;
	// MPropertyFriendlyName = "Extrapolate Movement"
	// MPropertyAutoRebuildOnChange
	bool m_bExtrapolateMovement; // = true
	// MPropertyFriendlyName = "Min Extrapolation Speed"
	// MPropertyAttrStateCallback
	float32 m_flMinExtrapolationSpeed; // = 2
};
