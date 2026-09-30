// MPropertyFriendlyName = "Damped Path Motor"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_DampedPathMotor : public CAnimGraphDoc_PathMotorBase
{
	// MPropertyFriendlyName = "Anticipation Time"
	float32 m_flAnticipationTime; // = 1
	// MPropertyFriendlyName = "Minimum Speed Percentage"
	float32 m_flMinSpeedScale; // = 0.25
	// MPropertySuppressField
	CUtlString m_anticipationPosParamName;
	// MPropertyFriendlyName = "Anticipation Position Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	AnimParamID m_anticipationPosParam;
	// MPropertySuppressField
	CUtlString m_anticipationHeadingParamName;
	// MPropertyFriendlyName = "Anticipation Heading Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_anticipationHeadingParam;
	// MPropertyFriendlyName = "Spring Constant"
	// MPropertyGroupName = "+Stopping:Arrival Damping"
	float32 m_flSpringConstant; // = 10
	// MPropertyFriendlyName = "Min Tension"
	// MPropertyGroupName = "+Stopping:Arrival Damping"
	float32 m_flMinSpringTension; // = 1
	// MPropertyFriendlyName = "Max Tension"
	// MPropertyGroupName = "+Stopping:Arrival Damping"
	float32 m_flMaxSpringTension; // = 100
};
