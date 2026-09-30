// MPropertyFriendlyName = "Transform: Trace To Point"
// MPropertyDescription = "Perform a trace between the specified origin and a specified target point."
// MVDataClassGroup = "Transform"
// MVDataExperimentalNodeSet = "smartprops"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_TraceToPoint : public CSmartPropOperation_Trace
{
	// MPropertyStartGroup = "+Target Point"
	// MPropertyDescription = "The target point to trace to from the origin."
	CSmartPropAttributeVector m_TargetPoint;
	// MPropertyDescription = "Specifies the coordinate space the target point is specified in."
	CSmartPropAttributeCoordinateSpace m_TargetPointSpace; // = "WORLD"
	// MPropertyStartGroup = "+Trace Away"
	// MPropertyFriendlyName = "Trace away from point"
	// MPropertyDescription = "If enabled, instead of tracing from the origin to the target point, trace away from the target point for the specified distance starting at the origin."
	CSmartPropAttributeBool m_bTraceAway;
	// MPropertyReadonlyExpr = "m_bTraceAway == false"
	// MPropertyDescription = "Maximum length of the trace. Surfaces beyond this distance will not be hit."
	CSmartPropAttributeFloat m_flTraceLength; // = 1000
};
