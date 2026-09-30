// MPropertyFriendlyName = "Damped Value"
class CDampedValueItem
{
	// MPropertyFriendlyName = "Value Type"
	// MPropertyAutoRebuildOnChange
	DampedValueType m_valueType; // = "FloatParameter"
	// MPropertySuppressField
	CUtlString m_floatParamNameIn;
	// MPropertySuppressField
	CUtlString m_floatParamNameOut;
	// MPropertySuppressField
	CUtlString m_vectorParamNameIn;
	// MPropertySuppressField
	CUtlString m_vectorParamNameOut;
	// MPropertyFriendlyName = "Parameter In"
	// MPropertyAttributeChoiceName = "FloatParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_floatParamIn;
	// MPropertyFriendlyName = "Parameter Out"
	// MPropertyAttributeChoiceName = "PrivateFloatParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_floatParamOut;
	// MPropertyFriendlyName = "Parameter In"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_vectorParamIn;
	// MPropertyFriendlyName = "Parameter Out"
	// MPropertyAttributeChoiceName = "PrivateVectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_vectorParamOut;
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
