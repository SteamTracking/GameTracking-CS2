// MPropertyFriendlyName = "Stride Retargeting"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FootLockNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Feet"
	// MPropertyAutoExpandSelf
	CUtlVector< CFootLockItem > m_items;
	// MPropertyFriendlyName = "Hip Bone"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_hipBoneName;
	// MPropertyFriendlyName = "Blend Time"
	float32 m_flBlendTime; // = 0.2
	// MPropertyFriendlyName = "Apply Foot Rotation Limits"
	bool m_bApplyFootRotationLimits; // = true
	// MPropertyFriendlyName = "Reset Child"
	bool m_bResetChild; // = true
	// MPropertyFriendlyName = "IK Solver Type"
	// MPropertyGroupName = "IK"
	// MPropertyAutoRebuildOnChange
	IKSolverType m_ikSolverType; // = "IKSOLVER_TwoBone"
	// MPropertyFriendlyName = "Always use fallback hinge"
	// MPropertyGroupName = "IK"
	// MPropertyAttrStateCallback
	bool m_bAlwaysUseFallbackHinge; // = true
	// MPropertyFriendlyName = "Limit Leg Twist"
	// MPropertyGroupName = "IK"
	// MPropertyAttrStateCallback
	bool m_bApplyLegTwistLimits;
	// MPropertyFriendlyName = "Max Leg Twist Angle"
	// MPropertyGroupName = "IK"
	// MPropertyAttrStateCallback
	float32 m_flMaxLegTwist; // = 45
	// MPropertyFriendlyName = "Curve Foot Paths"
	// MPropertyGroupName = "Curve Paths"
	// MPropertyAttributeRange = "0 1"
	float32 m_flStrideCurveScale; // = 1
	// MPropertyFriendlyName = "Curve Paths Limit"
	// MPropertyGroupName = "Curve Paths"
	// MPropertyAttributeRange = "0 1"
	float32 m_flStrideCurveLimitScale; // = 0.25
	// MPropertyFriendlyName = "Enable Vertical Curved Paths"
	// MPropertyGroupName = "Curve Paths"
	bool m_bEnableVerticalCurvedPaths;
	// MPropertyFriendlyName = "Modulate Step Height"
	// MPropertyGroupName = "Step Height"
	// MPropertyAutoRebuildOnChange
	bool m_bModulateStepHeight; // = true
	// MPropertyFriendlyName = "Height Increase Scale"
	// MPropertyGroupName = "Step Height"
	// MPropertyAttrStateCallback
	float32 m_flStepHeightIncreaseScale;
	// MPropertyFriendlyName = "Height Decrease Scale"
	// MPropertyGroupName = "Step Height"
	// MPropertyAttrStateCallback
	float32 m_flStepHeightDecreaseScale; // = 1
	// MPropertyFriendlyName = "Enable Hip Shift"
	// MPropertyGroupName = "Hip Shift"
	bool m_bEnableHipShift;
	// MPropertyFriendlyName = "Hip Shift Scale"
	// MPropertyGroupName = "Hip Shift"
	// MPropertyAttributeRange = "0 1"
	float32 m_flHipShiftScale; // = 0.5
	// MPropertyFriendlyName = "Damping"
	// MPropertyGroupName = "Hip Shift"
	CAnimInputDamping m_hipShiftDamping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	// MPropertyFriendlyName = "Apply Tilt"
	// MPropertyGroupName = "Tilt"
	bool m_bApplyTilt;
	// MPropertyFriendlyName = "Tilt Plane Pitch Spring Strength"
	// MPropertyGroupName = "Tilt"
	float32 m_flTiltPlanePitchSpringStrength; // = 5
	// MPropertyFriendlyName = "Tilt Plane Roll Spring Strength"
	// MPropertyGroupName = "Tilt"
	float32 m_flTiltPlaneRollSpringStrength; // = 5
	// MPropertyFriendlyName = "Enable Lock Breaking"
	// MPropertyGroupName = "Lock Breaking"
	bool m_bEnableLockBreaking; // = true
	// MPropertyFriendlyName = "Tolerance"
	// MPropertyGroupName = "Lock Breaking"
	float32 m_flLockBreakTolerance; // = 0.2
	// MPropertyFriendlyName = "Blend Time"
	// MPropertyGroupName = "Lock Breaking"
	float32 m_flLockBreakBlendTime; // = 0.2
	// MPropertyFriendlyName = "Enable Stretching"
	// MPropertyGroupName = "Stretch"
	bool m_bEnableStretching;
	// MPropertyFriendlyName = "Max Stretch Amount"
	// MPropertyGroupName = "Stretch"
	float32 m_flMaxStretchAmount; // = 2
	// MPropertyFriendlyName = "Extension Scale"
	// MPropertyGroupName = "Stretch"
	// MPropertyAttributeRange = "0 1"
	float32 m_flStretchExtensionScale; // = 0.998
	// MPropertyFriendlyName = "Enable Ground Tracing"
	// MPropertyGroupName = "Ground IK"
	// MPropertyAutoRebuildOnChange
	bool m_bEnableGroundTracing;
	// MPropertyFriendlyName = "Angle Traces with Slope"
	// MPropertyGroupName = "Ground IK"
	// MPropertyAttributeRange = "0 1"
	// MPropertyAttrStateCallback
	float32 m_flTraceAngleBlend;
	// MPropertyFriendlyName = "Apply Hip Drop"
	// MPropertyGroupName = "Ground IK"
	// MPropertyAutoRebuildOnChange
	// MPropertyAttrStateCallback
	bool m_bApplyHipDrop;
	// MPropertyFriendlyName = "Max Foot Lift"
	// MPropertyGroupName = "Ground IK"
	// MPropertyAttrStateCallback
	float32 m_flMaxFootHeight; // = -12
	// MPropertyFriendlyName = "Leg Extension Scale"
	// MPropertyGroupName = "Ground IK"
	// MPropertyAttrStateCallback
	float32 m_flExtensionScale; // = 0.7
	// MPropertyFriendlyName = "Hip Damping"
	// MPropertyGroupName = "Ground IK"
	// MPropertyAttrStateCallback
	CAnimInputDamping m_hipDampingSettings; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	// MPropertyFriendlyName = "Enable Root Height Damping"
	// MPropertyGroupName = "Root Height Damping"
	// MPropertyAutoRebuildOnChange
	bool m_bEnableRootHeightDamping;
	// MPropertyFriendlyName = "Damping Settings"
	// MPropertyGroupName = "Root Height Damping"
	// MPropertyAttrStateCallback
	CAnimInputDamping m_rootHeightDamping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 12, "m_fSpeedScale": 12, "m_speedFunction": "Spring" }
	// MPropertyFriendlyName = "Max Offset"
	// MPropertyGroupName = "Root Height Damping"
	// MPropertyAttrStateCallback
	float32 m_flMaxRootHeightOffset; // = 100
	// MPropertyFriendlyName = "Min Offset"
	// MPropertyGroupName = "Root Height Damping"
	// MPropertyAttrStateCallback
	float32 m_flMinRootHeightOffset; // = -100
};
