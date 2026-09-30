// MPropertyFriendlyName = "Follow Path"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FollowPathNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Blend Out Time"
	float32 m_flBlendOutTime; // = 0.3
	// MPropertyFriendlyName = "Block Non-Path Movement"
	bool m_bBlockNonPathMovement;
	// MPropertyFriendlyName = "Stop Feet at Goal"
	bool m_bStopFeetAtGoal; // = true
	// MPropertyFriendlyName = "Enable Speed Scaling"
	// MPropertyGroupName = "Speed Scaling"
	// MPropertyAutoRebuildOnChange
	bool m_bScaleSpeed;
	// MPropertyFriendlyName = "Scale"
	// MPropertyGroupName = "Speed Scaling"
	// MPropertyAttributeRange = "0 1"
	// MPropertyAttrStateCallback
	float32 m_flScale; // = 0.5
	// MPropertyFriendlyName = "Min Angle"
	// MPropertyGroupName = "Speed Scaling"
	// MPropertyAttributeRange = "0 180"
	// MPropertyAttrStateCallback
	float32 m_flMinAngle;
	// MPropertyFriendlyName = "Max Angle"
	// MPropertyGroupName = "Speed Scaling"
	// MPropertyAttributeRange = "0 180"
	// MPropertyAttrStateCallback
	float32 m_flMaxAngle; // = 180
	// MPropertyFriendlyName = "Blend Time"
	// MPropertyGroupName = "Speed Scaling"
	// MPropertyAttrStateCallback
	float32 m_flSpeedScaleBlending; // = 0.2
	// MPropertyFriendlyName = "Enable Turn to Face"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAutoRebuildOnChange
	bool m_bTurnToFace; // = true
	// MPropertyFriendlyName = "Target"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	AnimValueSource m_facingTarget; // = "MoveHeading"
	// MPropertySuppressField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttributeChoiceName = "FloatParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_param;
	// MPropertyFriendlyName = "Offset"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttributeRange = "-180 180"
	// MPropertyAttrStateCallback
	float32 m_flTurnToFaceOffset;
	// MPropertyFriendlyName = "Damping"
	// MPropertyGroupName = "Turn to Face"
	// MPropertyAttrStateCallback
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
