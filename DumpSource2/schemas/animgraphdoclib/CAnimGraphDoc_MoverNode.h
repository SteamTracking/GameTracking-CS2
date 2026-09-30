// MPropertyFriendlyName = "Mover"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_MoverNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Generate Movement"
	// MPropertyGroupName = "Generate Movement"
	// MPropertyAutoRebuildOnChange
	bool m_bApplyMovement; // = true
	// MPropertySuppressField
	CUtlString m_moveVectorParamName;
	// MPropertyFriendlyName = "Movement Velocity Parameter"
	// MPropertyGroupName = "Generate Movement"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_moveVectorParam;
	// MPropertyFriendlyName = "Orient Movement"
	// MPropertyGroupName = "Orient Movement"
	// MPropertyAutoRebuildOnChange
	bool m_bOrientMovement;
	// MPropertySuppressField
	CUtlString m_moveHeadingParamName;
	// MPropertyFriendlyName = "Movement Heading Parameter"
	// MPropertyGroupName = "Orient Movement"
	// MPropertyAttributeChoiceName = "FloatParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_moveHeadingParam;
	// MPropertyFriendlyName = "Additive"
	bool m_bAdditive;
	// MPropertyFriendlyName = "Turn to Face"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAutoRebuildOnChange
	bool m_bTurnToFace;
	// MPropertyFriendlyName = "Face Direction"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_facingTarget; // = "Parameter"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Facing Parameter"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttributeChoiceName = "FloatParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_param;
	// MPropertyFriendlyName = "Turn Limit Only"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttrStateCallback
	// MPropertyAutoRebuildOnChange
	bool m_bLimitOnly;
	// MPropertyFriendlyName = "Turn to Face Offset"
	// MPropertyAttributeRange = "-180 180"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttrStateCallback
	float32 m_flTurnToFaceOffset;
	// MPropertyFriendlyName = "Turn to Face Limit"
	// MPropertyAttributeRange = "0 180"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttrStateCallback
	float32 m_flTurnToFaceLimit; // = 180
	// MPropertyFriendlyName = "Damping"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttrStateCallback
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
