// MPropertyFriendlyName = "Transform: Trace In Direction"
// MPropertyDescription = "Perform a trace in a direction from a specified origin and stop when a surface is hit."
// MVDataClassGroup = "Transform"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_TraceInDirection : public CSmartPropOperation_Trace
{
	// MPropertyStartGroup = "+Trace Direction"
	CSmartPropAttributeVector m_vTraceDirection; // = [ 0, 0, -1 ]
	// MPropertyDescription = "Specifies the coordinate space the trace direction vector is specified in."
	CSmartPropAttributeCoordinateSpace m_DirectionSpace; // = "WORLD"
	// MPropertyDescription = "Maximum length of the trace. Surfaces beyond this distance will not be hit."
	CSmartPropAttributeFloat m_flTraceLength; // = 1000
};
