// MPropertyFriendlyName = "Lean Matrix"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_LeanMatrixNode : public CAnimGraphDoc_Node
{
	// MPropertyFriendlyName = "Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_sequenceName;
	// MPropertyFriendlyName = "Max Value"
	float32 m_flMaxValue; // = 1
	// MPropertyFriendlyName = "Blend Source"
	AnimVectorSource m_blendSource; // = "MoveDirection"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	AnimParamID m_param;
	// MPropertyFriendlyName = "Vertical Axis"
	Vector m_verticalAxisDirection; // = [ 1, 0, 0 ]
	// MPropertyFriendlyName = "Horizontal Axis"
	Vector m_horizontalAxisDirection; // = [ 0, 1, 0 ]
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
