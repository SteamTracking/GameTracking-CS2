// MPropertyFriendlyName = "Cross Product"
// MPropertyDescription = "Compute a dot or cross product between two 3D vectors"
// MVDataClassGroup = "Compute"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ComputeCrossProduct3D : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Output Variable"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector3 )"
	CUtlString m_OutputVariableName;
	// MPropertyFriendlyName = "Vector A"
	CSmartPropAttributeVector m_InputVectorA;
	// MPropertyFriendlyName = "Vector B"
	CSmartPropAttributeVector m_InputVectorB;
};
