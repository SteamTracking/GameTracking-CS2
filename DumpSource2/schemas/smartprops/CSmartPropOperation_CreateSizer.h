// MPropertyFriendlyName = "Create Sizer"
// MPropertyDescription = "Create a sizer that will be displayed at the current location, allowing the user to manipulate the specified set of size values."
// MVDataClassGroup = "Manipulators"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_CreateSizer : public CSmartPropTransformOperation
{
	// MPropertyFriendlyName = "Name"
	// MPropertyDescription = "Name used to identify the sizer. Must be unique within the paraent element."
	CUtlString m_Name;
	// MPropertyFriendlyName = "Display Model"
	// MPropertyDescription = "If enabled a model will be displayed at the position of the sizer that can be used to select the sizer in Hammer."
	CSmartPropAttributeBool m_bDisplayModel;
	// MPropertyGroupName = "X-Axis Size"
	CSmartPropAttributeFloat m_flInitialMinX;
	// MPropertyGroupName = "X-Axis Size"
	CSmartPropAttributeFloat m_flInitialMaxX;
	// MPropertyGroupName = "X-Axis Size"
	CSmartPropAttributeFloat m_flConstraintMinX;
	// MPropertyGroupName = "X-Axis Size"
	CSmartPropAttributeFloat m_flConstraintMaxX;
	// MPropertyGroupName = "X-Axis Size"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableMinX;
	// MPropertyGroupName = "X-Axis Size"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableMaxX;
	// MPropertyGroupName = "Y-Axis Size"
	CSmartPropAttributeFloat m_flInitialMinY;
	// MPropertyGroupName = "Y-Axis Size"
	CSmartPropAttributeFloat m_flInitialMaxY;
	// MPropertyGroupName = "Y-Axis Size"
	CSmartPropAttributeFloat m_flConstraintMinY;
	// MPropertyGroupName = "Y-Axis Size"
	CSmartPropAttributeFloat m_flConstraintMaxY;
	// MPropertyGroupName = "Y-Axis Size"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableMinY;
	// MPropertyGroupName = "Y-Axis Size"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableMaxY;
	// MPropertyGroupName = "Z-Axis Size"
	CSmartPropAttributeFloat m_flInitialMinZ;
	// MPropertyGroupName = "Z-Axis Size"
	CSmartPropAttributeFloat m_flInitialMaxZ;
	// MPropertyGroupName = "Z-Axis Size"
	CSmartPropAttributeFloat m_flConstraintMinZ;
	// MPropertyGroupName = "Z-Axis Size"
	CSmartPropAttributeFloat m_flConstraintMaxZ;
	// MPropertyGroupName = "Z-Axis Size"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableMinZ;
	// MPropertyGroupName = "Z-Axis Size"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Variable:Float )"
	CUtlString m_OutputVariableMaxZ;
};
