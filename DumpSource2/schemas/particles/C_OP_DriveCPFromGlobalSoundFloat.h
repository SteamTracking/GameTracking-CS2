// MHasKV3TransferPolymorphicClassname
class C_OP_DriveCPFromGlobalSoundFloat : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutputControlPoint;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nOutputField;
	// MPropertyFriendlyName = "input minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "input maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "sound stack name"
	CUtlString m_StackName;
	// MPropertyFriendlyName = "sound operator name"
	CUtlString m_OperatorName;
	// MPropertyFriendlyName = "sound field name"
	CUtlString m_FieldName;
};
