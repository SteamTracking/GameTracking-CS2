// MPropertyFriendlyName = "Normalize Vector"
// MPropertyDescription = "Normalize the value of a 3d vector."
// MVDataClassGroup = "Compute"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_ComputeNormalizedVector3D : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Output Variable"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Vector3 )"
	CUtlString m_OutputVariableName;
	CSmartPropAttributeVector m_InputVector;
};
