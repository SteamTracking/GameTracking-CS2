// MPropertyFriendlyName = "Create Locator"
// MPropertyDescription = "Create a locator with the current transform. The locator may optionally be configurable, so that its transform can be modified in Hammer."
// MVDataClassGroup = "Manipulators"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_CreateLocator : public CSmartPropTransformOperation
{
	// MPropertyFriendlyName = "Name"
	// MPropertyAttributeEditor = "SmartPropItemNameEditor( Locator )"
	// MPropertyDescription = "Name of the locator. This can be used to reference the locator in this element or its children. If the locator is configurable, the locator will be identified by this name in Hammer."
	CUtlString m_LocatorName;
	// MPropertyDescription = "Offset of the locator relative to the current transform. This allows the locator to be created at an offset location without applying that offset to the current transform."
	CSmartPropAttributeVector m_vOffset;
	// MPropertyDescription = "Scale to apply only to the locator model"
	CSmartPropAttributeFloat m_flDisplayScale; // = 1
	// MPropertyDescription = "Controls whether or not the locator can be edited in a smart prop configuration. If enabled an editable locator will appear when the smart prop is placed in Hammer. Any changes to that locator will modify the current transform."
	CSmartPropAttributeBool m_bConfigurable; // = true
	// MPropertyReadonlyExpr = "m_bConfigurable == false"
	// MPropertyGroupName = "Configuration"
	CSmartPropAttributeBool m_bAllowTranslation; // = true
	// MPropertyReadonlyExpr = "m_bConfigurable == false"
	// MPropertyGroupName = "Configuration"
	CSmartPropAttributeBool m_bAllowRotation; // = true
	// MPropertyReadonlyExpr = "m_bConfigurable == false"
	// MPropertyGroupName = "Configuration"
	// MPropertyDescription = "Controls whether or not the configuration of the locator can include scale. If enabled scale can be applied to the editable locator in Hammer. If disabled the scale will not be editable and the current scale will be used."
	CSmartPropAttributeBool m_bAllowScale;
};
