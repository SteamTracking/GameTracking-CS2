// MPropertyFriendlyName = "Dot Product"
// MPropertyDescription = "Compute a dot or cross product between two 3D vectors"
// MVDataClassGroup = "Compute"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ComputeDotProduct3D : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Output Variable"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableName;
	// MPropertyFriendlyName = "Vector A"
	CSmartPropAttributeVector m_InputVectorA;
	// MPropertyFriendlyName = "Vector B"
	CSmartPropAttributeVector m_InputVectorB;
};
