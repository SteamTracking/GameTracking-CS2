// MPropertyElementNameFn
class CompMatPropertyMutator_t
{
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Enabled"
	bool m_bEnabled; // = true
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Mutator Command"
	// MPropertyAttrStateCallback
	CompMatPropertyMutatorType_t m_nMutatorCommandType; // = "COMP_MAT_PROPERTY_MUTATOR_SET_VALUE"
	// MPropertyFriendlyName = "Container to Init With"
	// MPropertyAttrStateCallback
	CUtlString m_strInitWith_Container;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyProperty_InputContainerSrc;
	// MPropertyFriendlyName = "Input Container Property"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyProperty_InputContainerProperty;
	// MPropertyFriendlyName = "Target Property"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyProperty_TargetProperty;
	// MPropertyFriendlyName = "Seed Input Var"
	// MPropertyAttrStateCallback
	CUtlString m_strRandomRollInputVars_SeedInputVar;
	// MPropertyFriendlyName = "Input Vars"
	// MPropertyAttrStateCallback
	CUtlVector< CUtlString > m_vecRandomRollInputVars_InputVarsToRoll;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyMatchingKeys_InputContainerSrc;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyKeysWithSuffix_InputContainerSrc;
	// MPropertyFriendlyName = "Find Suffix"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyKeysWithSuffix_FindSuffix;
	// MPropertyFriendlyName = "Replace Suffix"
	// MPropertyAttrStateCallback
	CUtlString m_strCopyKeysWithSuffix_ReplaceSuffix;
	// MPropertyFriendlyName = "Value"
	// MPropertyAttrStateCallback
	CompositeMaterialInputLooseVariable_t m_nSetValue_Value;
	// MPropertyFriendlyName = "Target Texture Param"
	// MPropertyAttrStateCallback
	CUtlString m_strGenerateTexture_TargetParam;
	// MPropertyFriendlyName = "Initial Container"
	// MPropertyAttrStateCallback
	CUtlString m_strGenerateTexture_InitialContainer;
	// MPropertyFriendlyName = "Resolution"
	// MPropertyAttrStateCallback
	int32 m_nResolution; // = 256
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Scratch Target"
	// MPropertyAttrStateCallback
	bool m_bIsScratchTarget;
	// MPropertyFriendlyName = "Compression Format"
	// MPropertyAttrStateCallback
	CUtlString m_strCompressionFormat;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Splat Debug info on Texture"
	// MPropertyAttrStateCallback
	bool m_bSplatDebugInfo;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Capture in RenderDoc"
	// MPropertyAttrStateCallback
	bool m_bCaptureInRenderDoc;
	// MPropertyFriendlyName = "Texture Generation Instructions"
	// MPropertyAttrStateCallback
	CUtlVector< CompMatPropertyMutator_t > m_vecTexGenInstructions;
	// MPropertyFriendlyName = "Mutators"
	// MPropertyAttrStateCallback
	CUtlVector< CompMatPropertyMutator_t > m_vecConditionalMutators;
	// MPropertyFriendlyName = "Container to Pop"
	// MPropertyAttrStateCallback
	CUtlString m_strPopInputQueue_Container;
	// MPropertyFriendlyName = "Input Container"
	// MPropertyAttrStateCallback
	CUtlString m_strDrawText_InputContainerSrc;
	// MPropertyFriendlyName = "Input Container Property"
	// MPropertyAttrStateCallback
	CUtlString m_strDrawText_InputContainerProperty;
	// MPropertyFriendlyName = "Text Position"
	// MPropertyAttrStateCallback
	Vector2D m_vecDrawText_Position;
	// MPropertyFriendlyName = "Text Color"
	// MPropertyAttrStateCallback
	Color m_colDrawText_Color; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "Font"
	// MPropertyAttrStateCallback
	CUtlString m_strDrawText_Font; // = "Times New Roman"
	// MPropertyFriendlyName = "Conditions"
	// MPropertyAttrStateCallback
	CUtlVector< CompMatMutatorCondition_t > m_vecConditions;
};
