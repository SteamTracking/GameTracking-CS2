// MPropertyFriendlyName = "Material Attribute Tag"
// MHasKV3TransferPolymorphicClassname
class CMaterialAttributeAnimTag : public CAnimTagBase
{
	// MPropertyFriendlyName = "Attribute Name"
	CUtlString m_AttributeName;
	// MPropertyFriendlyName = "Attribute Type"
	// MPropertyAutoRebuildOnChange
	MatterialAttributeTagType_t m_AttributeType; // = "MATERIAL_ATTRIBUTE_TAG_VALUE"
	// MPropertyFriendlyName = "Value"
	// MPropertyAttrStateCallback
	float32 m_flValue;
	// MPropertyFriendlyName = "Color"
	// MPropertyAttrStateCallback
	Color m_Color; // = [ 255, 255, 255 ]
};
