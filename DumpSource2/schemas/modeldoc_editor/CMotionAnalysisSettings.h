// MVDataRoot
class CMotionAnalysisSettings
{
	// MPropertyAttributeEditor = "TextBlock()"
	CUtlString m_Description;
	// MPropertyDescription = "Threshold for 'nearly stopped' linear velocity (inches/second)"
	// MPropertyAttributeRange = "0 100"
	float32 m_flLinearThresholdSlow; // = 60
	// MPropertyDescription = "Threshold for 'fully stopped' linear velocity (inches/second)"
	// MPropertyAttributeRange = "0 100"
	float32 m_flLinearThresholdStopped; // = 25
	// MPropertyDescription = "Threshold for 'nearly stopped' angular velocity (degrees/second)"
	// MPropertyAttributeRange = "0 180"
	float32 m_flAngularThresholdSlow; // = 90
	// MPropertyDescription = "Threshold for 'fully stopped' angular velocity (degrees/second)"
	// MPropertyAttributeRange = "0 180"
	float32 m_flAngularThresholdStopped; // = 15
	// MPropertyAutoExpandSelf
	CUtlStringMap< CMotionAnalysisSettings_Foot > m_Feet;
};
