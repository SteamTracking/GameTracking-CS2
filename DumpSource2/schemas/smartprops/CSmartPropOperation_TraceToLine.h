// MPropertyFriendlyName = "Transform: Trace To Line"
// MPropertyDescription = "Perform a trace from a specified origin point to a the closest point on a line."
// MVDataClassGroup = "Transform"
// MVDataExperimentalNodeSet = "smartprops"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_TraceToLine : public CSmartPropOperation_Trace
{
	// MPropertyStartGroup = "+Line End Point A"
	// MPropertyDescription = "End point of the line to trace to."
	CSmartPropAttributeVector m_EndPointA;
	// MPropertyDescription = "Coordinate space the end point is specified in."
	CSmartPropAttributeCoordinateSpace m_EndPointSpaceA; // = "WORLD"
	// MPropertyStartGroup = "+Line End Point B"
	// MPropertyDescription = "End point of the line to trace to."
	CSmartPropAttributeVector m_EndPointB;
	// MPropertyDescription = "Coordinate space the end point is specified in."
	CSmartPropAttributeCoordinateSpace m_EndPointSpaceB; // = "WORLD"
	// MPropertyStartGroup = "+Trace Away"
	// MPropertyFriendlyName = "Trace away from line"
	// MPropertyDescription = "If enabled, instead of tracing from the origin to the line, trace away from the line for the specified distance starting at the origin."
	CSmartPropAttributeBool m_bTraceAway;
	// MPropertyReadonlyExpr = "m_bTraceAway == false"
	// MPropertyDescription = "Maximum length of the trace. Surfaces beyond this distance will not be hit."
	CSmartPropAttributeFloat m_flTraceLength; // = 1000
};
