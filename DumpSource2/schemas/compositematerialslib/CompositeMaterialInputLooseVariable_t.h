// MPropertyElementNameFn
class CompositeMaterialInputLooseVariable_t
{
	// MPropertyFriendlyName = "Name"
	// MPropertyAttrStateCallback
	CUtlString m_strName;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Expose Externally"
	bool m_bExposeExternally;
	// MPropertyFriendlyName = "Exposed Friendly Name"
	// MPropertyAttrStateCallback
	CUtlString m_strExposedFriendlyName;
	// MPropertyFriendlyName = "Exposed Friendly Group"
	// MPropertyAttrStateCallback
	CUtlString m_strExposedFriendlyGroupName;
	// MPropertyFriendlyName = "Exposed Fixed Range"
	// MPropertyAttrStateCallback
	bool m_bExposedVariableIsFixedRange;
	// MPropertyFriendlyName = "Exposed SetVisible When True"
	// MPropertyAttrStateCallback
	CUtlString m_strExposedVisibleWhenTrue;
	// MPropertyFriendlyName = "Exposed SetHidden When True"
	// MPropertyAttrStateCallback
	CUtlString m_strExposedHiddenWhenTrue;
	// MPropertyFriendlyName = "Exposed Value List"
	// MPropertyAttrStateCallback
	CUtlString m_strExposedValueList;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Type"
	CompositeMaterialInputLooseVariableType_t m_nVariableType; // = "LOOSE_VARIABLE_TYPE_FLOAT1"
	// MPropertyFriendlyName = "Value"
	// MPropertyAttrStateCallback
	bool m_bValueBoolean;
	// MPropertyFriendlyName = "X Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0 255"
	int32 m_nValueIntX;
	// MPropertyFriendlyName = "Y Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0 255"
	int32 m_nValueIntY;
	// MPropertyFriendlyName = "Z Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0 255"
	int32 m_nValueIntZ;
	// MPropertyFriendlyName = "W Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0 255"
	int32 m_nValueIntW;
	// MPropertyFriendlyName = "Specify Min/Max"
	// MPropertyAttrStateCallback
	bool m_bHasFloatBounds;
	// MPropertyFriendlyName = "X Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flValueFloatX;
	// MPropertyFriendlyName = "X Min"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatX_Min;
	// MPropertyFriendlyName = "X Max"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatX_Max; // = 1
	// MPropertyFriendlyName = "Y Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flValueFloatY;
	// MPropertyFriendlyName = "Y Min"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatY_Min;
	// MPropertyFriendlyName = "Y Max"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatY_Max; // = 1
	// MPropertyFriendlyName = "Z Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flValueFloatZ;
	// MPropertyFriendlyName = "Z Min"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatZ_Min;
	// MPropertyFriendlyName = "Z Max"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatZ_Max; // = 1
	// MPropertyFriendlyName = "W Value"
	// MPropertyAttrStateCallback
	// MPropertyAttributeRange = "0.0 1.0"
	float32 m_flValueFloatW;
	// MPropertyFriendlyName = "W Min"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatW_Min;
	// MPropertyFriendlyName = "W Max"
	// MPropertyAttrStateCallback
	float32 m_flValueFloatW_Max; // = 1
	// MPropertyFriendlyName = "Value"
	// MPropertyAttrStateCallback
	Color m_cValueColor4;
	// MPropertyFriendlyName = "Value"
	// MPropertyAttrStateCallback
	CompositeMaterialVarSystemVar_t m_nValueSystemVar; // = "COMPMATSYSVAR_COMPOSITETIME"
	// MPropertyFriendlyName = "Material"
	// MPropertyAttrStateCallback
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIMaterial2 > > m_strResourceMaterial;
	// MPropertyFriendlyName = "Texture"
	// MPropertyAttributeEditor = "AssetBrowse( jpg, png, psd, tga )"
	// MPropertyAttrStateCallback
	CUtlString m_strTextureContentAssetPath;
	// MPropertyHideField
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCTextureBase > > m_strTextureRuntimeResourcePath;
	// MPropertyHideField
	CUtlString m_strTextureCompilationVtexTemplate;
	// MPropertyFriendlyName = "Texture Type"
	// MPropertyAttrStateCallback
	CompositeMaterialInputTextureType_t m_nTextureType; // = "INPUT_TEXTURE_TYPE_DEFAULT"
	// MPropertyFriendlyName = "String"
	// MPropertyAttrStateCallback
	CUtlString m_strString;
	// MPropertyFriendlyName = "Layout XML"
	// MPropertyAttrStateCallback
	CUtlString m_strPanoramaPanelPath;
	// MPropertyFriendlyName = "Render Resolution"
	// MPropertyAttrStateCallback
	int32 m_nPanoramaRenderRes; // = 512
};
