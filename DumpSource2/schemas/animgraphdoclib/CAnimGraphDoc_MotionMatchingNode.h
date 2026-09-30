// MPropertyFriendlyName = "Motion Matching"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_MotionMatchingNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_MotionItemGroup > > m_groups;
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_MotionMetric > > m_metrics;
	// MPropertySuppressField
	CBlendCurve m_blendCurve; // = { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }
	// MPropertySuppressField
	int32 m_nRandomSeed;
	// MPropertyFriendlyName = "Sample Rate"
	// MPropertyAttributeRange = "0.01 0.2"
	float32 m_flSampleRate; // = 0.1
	// MPropertyFriendlyName = "Search Every Update"
	// MPropertyGroupName = "Search Frequency"
	// MPropertyAutoRebuildOnChange
	bool m_bSearchEveryTick; // = true
	// MPropertyFriendlyName = "Search Interval"
	// MPropertyGroupName = "Search Frequency"
	// MPropertyAttrStateCallback
	float32 m_flSearchInterval; // = 0.1
	// MPropertyFriendlyName = "Search when motion ends"
	// MPropertyGroupName = "Search Frequency"
	// MPropertyAttrStateCallback
	bool m_bSearchWhenMotionEnds; // = true
	// MPropertyFriendlyName = "Search when goal changes"
	// MPropertyGroupName = "Search Frequency"
	// MPropertyAttrStateCallback
	bool m_bSearchWhenGoalChanges; // = true
	// MPropertyFriendlyName = "Blend Time"
	float32 m_flBlendTime; // = 0.3
	// MPropertyFriendlyName = "Selection Threshold"
	float32 m_flSelectionThreshold;
	// MPropertyFriendlyName = "Re-Selection Time Window"
	float32 m_flReselectionTimeWindow; // = 0.3
	// MPropertyFriendlyName = "Lock Selection When Waning"
	bool m_bLockSelectionWhenWaning;
	// MPropertyFriendlyName = "Enable Rotation Correction"
	bool m_bEnableRotationCorrection; // = true
	// MPropertyFriendlyName = "Enable Goal Assist"
	// MPropertyGroupName = "Goal Assist"
	// MPropertyAutoRebuildOnChange
	bool m_bGoalAssist; // = true
	// MPropertyFriendlyName = "Goal Assist Distance"
	// MPropertyGroupName = "Goal Assist"
	// MPropertyAttrStateCallback
	float32 m_flGoalAssistDistance; // = 40
	// MPropertyFriendlyName = "Goal Assist Tolerance"
	// MPropertyGroupName = "Goal Assist"
	// MPropertyAttrStateCallback
	float32 m_flGoalAssistTolerance; // = 2
	// MPropertyFriendlyName = "Enable Distance Scaling"
	// MPropertyGroupName = "Distance Scaling"
	// MPropertyAutoRebuildOnChange
	bool m_bEnableDistanceScaling; // = true
	// MPropertyFriendlyName = "Outer Stopping Radius"
	// MPropertyGroupName = "Distance Scaling"
	// MPropertyAttrStateCallback
	float32 m_flDistanceScale_OuterRadius; // = 120
	// MPropertyFriendlyName = "Inner Stopping Radius"
	// MPropertyGroupName = "Distance Scaling"
	// MPropertyAttrStateCallback
	float32 m_flDistanceScale_InnerRadius; // = 40
	// MPropertyFriendlyName = "Maximum Speed Scale"
	// MPropertyGroupName = "Distance Scaling"
	// MPropertyAttrStateCallback
	float32 m_flDistanceScale_MaxScale; // = 1.5
	// MPropertyFriendlyName = "Minimum Speed Scale"
	// MPropertyGroupName = "Distance Scaling"
	// MPropertyAttrStateCallback
	float32 m_flDistanceScale_MinScale; // = 0.5
	// MPropertyFriendlyName = "Damping"
	// MPropertyGroupName = "Distance Scaling"
	// MPropertyAttrStateCallback
	CAnimInputDamping m_distanceScale_Damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
