class EMaterialVariable_t
{
	CUtlString m_Name;
	CUtlString m_ExportName;
	CUtlString m_UiName;
	CUtlString m_UiOptions;
	bool m_bEnabled;
	bool m_bHidden;
	CUtlString m_EnumLabel;
	int32 m_nLayerId; // = -1
	bool m_bLayerAllowOverride; // = true
	bool m_bLayerReference;
	CUtlString m_inheritedValue;
	CUtlString m_inheritedValueSource;
	CUtlString m_Group;
	CUtlString m_SubGroup;
	int32 m_nSortKeyGroup; // = -1
	int32 m_nSortKeySubGroup; // = -1
	int32 m_nSortKeyVariable; // = -1
	CUtlString m_error;
	CUtlString m_expression;
	CUtlString m_referencedExpressionPath;
	CUtlString m_referencedValuePath;
	int32 m_nElements; // = 1
	CUtlString m_value;
	CUtlString m_default;
	CUtlString m_min;
	CUtlString m_max;
	CUtlString m_step;
	CUtlString m_precision;
	bool m_bInitialTextureInput; // = true
	int32 m_nTextureAutoFillCount;
	CUtlString m_alternateInput;
	CUtlString m_defaultColor; // = "[0 0 0 0]"
	CUtlString m_defaultInput;
	CUtlString m_textureSuffix;
	CUtlString m_defaultSlider; // = "[0 0 0 0]"
	float32[2] m_fDefaultSlider;
};
