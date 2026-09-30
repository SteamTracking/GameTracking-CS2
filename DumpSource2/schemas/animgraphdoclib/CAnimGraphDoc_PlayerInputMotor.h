// MPropertyFriendlyName = "Player Input Motor"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_PlayerInputMotor : public CAnimGraphDoc_Motor
{
	// MPropertyFriendlyName = "Sample Times"
	CUtlVector< float32 > m_sampleTimes;
	// MPropertyFriendlyName = "Use Acceleration"
	bool m_bUseAcceleration;
	// MPropertyFriendlyName = "Spring Constant"
	float32 m_flSpringConstant; // = 10
	// MPropertyFriendlyName = "Anticipation Distance"
	float32 m_flAnticipationDistance;
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
};
