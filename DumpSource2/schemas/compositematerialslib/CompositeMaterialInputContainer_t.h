// MPropertyElementNameFn
class CompositeMaterialInputContainer_t
{
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Enabled"
	bool m_bEnabled; // = true
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Input Container Source"
	// MPropertyAttrStateCallback
	CompositeMaterialInputContainerSourceType_t m_nCompositeMaterialInputContainerSourceType; // = "CONTAINER_SOURCE_TYPE_TARGET_MATERIAL"
	// MPropertyFriendlyName = "Specific Material"
	// MPropertyAttrStateCallback
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIMaterial2 > > m_strSpecificContainerMaterial;
	// MPropertyFriendlyName = "Attribute Name"
	// MPropertyAttrStateCallback
	CUtlString m_strAttrName;
	// MPropertyFriendlyName = "Alias"
	// MPropertyAttrStateCallback
	CUtlString m_strAlias;
	// MPropertyFriendlyName = "Variables"
	// MPropertyAttrStateCallback
	CUtlVector< CompositeMaterialInputLooseVariable_t > m_vecLooseVariables;
	// MPropertyFriendlyName = "Attribute Name"
	// MPropertyAttrStateCallback
	CUtlString m_strAttrNameForVar;
	// MPropertyFriendlyName = "Expose Externally"
	// MPropertyAttrStateCallback
	bool m_bExposeExternally;
};
