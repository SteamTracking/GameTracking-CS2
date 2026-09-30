// MPropertyFriendlyName = "VMix Control Curve Node"
// MPropertyDescription = "Remap a control variable through a curve that you define."
// MHasKV3TransferPolymorphicClassname
class CMixControlCurve : public CMixPropertyBase
{
	float32 m_flInputMin;
	float32 m_flInputMax; // = 1
	float32 m_flOutputMin;
	float32 m_flOutputMax; // = 1
	// MPropertySuppressField
	CPiecewiseCurve m_curve; // = { "m_spline": [ { "m_flSlopeIncoming": 1, "m_flSlopeOutgoing": 1, "x": 0, "y": 0 }, { "m_flSlopeIncoming": 1, "m_flSlopeOutgoing": 1, "x": 1, "y": 1 } ], "m_tangents": [ { "m_nIncomingTangent": "CURVE_TANGENT_SPLINE", "m_nOutgoingTangent": "CURVE_TANGENT_SPLINE" }, { "m_nIncomingTangent": "CURVE_TANGENT_SPLINE", "m_nOutgoingTangent": "CURVE_TANGENT_SPLINE" } ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }
};
