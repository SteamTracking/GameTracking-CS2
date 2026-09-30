class CAnimDemoCaptureSettings
{
	// MPropertyFriendlyName = "Rotation Error Range"
	// MPropertyGroupName = "+Spline Settings"
	Vector2D m_vecErrorRangeSplineRotation; // = [ 0.1, 0.5 ]
	// MPropertyFriendlyName = "Translation Error Range"
	// MPropertyGroupName = "+Spline Settings"
	Vector2D m_vecErrorRangeSplineTranslation; // = [ 0.1, 0.5 ]
	// MPropertyFriendlyName = "Scale Error Range"
	// MPropertyGroupName = "+Spline Settings"
	Vector2D m_vecErrorRangeSplineScale; // = [ 0.1, 0.5 ]
	// MPropertyFriendlyName = "Max IK Rotation Error"
	// MPropertyGroupName = "+Spline Settings"
	float32 m_flIkRotation_MaxSplineError; // = 0.03
	// MPropertyFriendlyName = "Max IK Translation Error"
	// MPropertyGroupName = "+Spline Settings"
	float32 m_flIkTranslation_MaxSplineError; // = 0.3
	// MPropertyFriendlyName = "Rotation Error Range"
	// MPropertyGroupName = "+Quantization Settings"
	Vector2D m_vecErrorRangeQuantizationRotation; // = [ 0.1, 0.5 ]
	// MPropertyFriendlyName = "Translation Error Range"
	// MPropertyGroupName = "+Quantization Settings"
	Vector2D m_vecErrorRangeQuantizationTranslation; // = [ 0.1, 0.5 ]
	// MPropertyFriendlyName = "Scale Error Range"
	// MPropertyGroupName = "+Quantization Settings"
	Vector2D m_vecErrorRangeQuantizationScale; // = [ 0.1, 0.5 ]
	// MPropertyFriendlyName = "Max IK Rotation Error"
	// MPropertyGroupName = "+Quantization Settings"
	float32 m_flIkRotation_MaxQuantizationError; // = 0.01
	// MPropertyFriendlyName = "Max IK Translation Error"
	// MPropertyGroupName = "+Quantization Settings"
	float32 m_flIkTranslation_MaxQuantizationError; // = 0.1
	// MPropertyFriendlyName = "Base Sequence"
	// MPropertyGroupName = "+Base Pose"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_baseSequence;
	// MPropertyFriendlyName = "Base Sequence Frame"
	// MPropertyGroupName = "+Base Pose"
	int32 m_nBaseSequenceFrame;
	// MPropertyFriendlyName = "Bone Selection Mode"
	// MPropertyGroupName = "+Bones"
	// MPropertyAutoRebuildOnChange
	EDemoBoneSelectionMode m_boneSelectionMode; // = "CaptureSelectedBones"
	// MPropertyFriendlyName = "Bones"
	// MPropertyGroupName = "+Bones"
	// MPropertyAttrStateCallback
	CUtlVector< BoneDemoCaptureSettings_t > m_bones;
	// MPropertyFriendlyName = "IK Chains"
	CUtlVector< IKDemoCaptureSettings_t > m_ikChains;
};
