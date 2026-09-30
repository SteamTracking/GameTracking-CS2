// MPropertyFriendlyName = "Orientation Warp"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_OrientationWarpNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Orient To"
	// MPropertyAutoRebuildOnChange
	OrientationWarpMode_t m_eMode; // = "eAngle"
	// MPropertyFriendlyName = "Angle Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_targetParamID;
	// MPropertyFriendlyName = "World Position"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_targetPositionParamID;
	// MPropertyFriendlyName = "Fallback World Position"
	// MPropertyAttributeChoiceName = "VectorParameter"
	// MPropertyAttrStateCallback
	AnimParamID m_fallbackTargetPositionParamID;
	// MPropertyFriendlyName = "Offset Mode"
	// MPropertyAutoRebuildOnChange
	OrientationWarpTargetOffsetMode_t m_eTargetOffsetMode; // = "eLiteralValue"
	// MPropertyFriendlyName = "Offset"
	// MPropertyAttrStateCallback
	float32 m_flTargetOffset;
	// MPropertyFriendlyName = "Offset Parameter"
	// MPropertyAttrStateCallback
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_targetOffsetParamID;
	// MPropertyFriendlyName = "Max Root Motion Scale"
	float32 m_flMaxRootMotionScale; // = 10
	// MPropertyFriendlyName = "Root Motion Source"
	OrientationWarpRootMotionSource_t m_eRootMotionSource; // = "eAnimationOrProcedural"
	// MPropertyFriendlyName = "Damping"
	// MPropertyAttrStateCallback
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	// MPropertyFriendlyName = "Enable Preferred Rotation Direction"
	// MPropertyAutoRebuildOnChange
	// MPropertyDescription = "Normally the orientation warp will take the shortest arc to align entity's forward vector with the target. With this option enabled it will rotate in the direction that includes passing through the preferred rotation direction parameter unless the resulting rotion is larger than the threshold specified."
	bool m_bEnablePreferredRotationDirection;
	// MPropertyFriendlyName = "Preferred Rotation Direction"
	// MPropertyAttrStateCallback
	// MPropertyDescription = "An angle relative to the entity's forward. ( Facing Heading, Look Heading ... )"
	AnimValueSource m_ePreferredRotationDirection; // = "FacingHeading"
	// MPropertyFriendlyName = "Preferred Rotation Threshold"
	// MPropertyAttrStateCallback
	// MPropertyDescription = "Orientation warp will never rotate angle larger than this even if it means not passing through the preferred rotation direction"
	float32 m_flPreferredRotationThreshold; // = 190
};
