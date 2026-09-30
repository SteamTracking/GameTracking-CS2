// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_Trace : public CSmartPropTransformOperation
{
	// MPropertyStartGroup = "+Origin"
	// MPropertyDescription = "Specifies the origin point for the start of the trace. To trace from the current position, set to < 0, 0, 0 > and set the coordinate space to Element Space"
	CSmartPropAttributeVector m_Origin;
	// MPropertyDescription = "Coordinate space the origin is specified in. Using Element space allows specifying a value relative to the current position. However, world space should generally be used when for variable values."
	CSmartPropAttributeCoordinateSpace m_OriginSpace;
	// MPropertyDescription = "Offset to apply to the specified origin along the trace direction to compute the starting point of the trace."
	CSmartPropAttributeFloat m_flOriginOffset;
	// MPropertyStartGroup = "+Result"
	// MPropertySortPriority = -1
	// MPropertyDescription = "How much should the surface normal up direction influence the final orientation. [ 0, 1 ] where 0 = don't modify the orientation, 1 = completely re-orient to match the surface."
	CSmartPropAttributeFloat m_flSurfaceUpInfluence;
	// MPropertySortPriority = -1
	// MPropertyFriendlyName = "If No Surface Hit"
	// MPropertyDescription = "Specifies the behavior when the trace does not hit a surface."
	CSmartPropAttributeTraceNoHit m_nNoHitResult;
	// MPropertyStartGroup = "Trace filtering"
	// MPropertySortPriority = -2
	// MPropertyDescription = "Do not trace against tool materials (attribute 'tools.toolsmaterial')."
	CSmartPropAttributeBool m_bIgnoreToolMaterials;
	// MPropertySortPriority = -2
	// MPropertyDescription = "Do not trace against sky materials (attribute 'mapbuilder.sky')."
	CSmartPropAttributeBool m_bIgnoreSky;
	// MPropertySortPriority = -2
	// MPropertyDescription = "Do not trace against no draw materials (material attribute 'mapbuilder.nodraw')."
	CSmartPropAttributeBool m_bIgnoreNoDraw;
	// MPropertySortPriority = -2
	// MPropertyDescription = "Do not trace against translucent materials (materials with 'alphatest' or 'translucent' attributes)."
	CSmartPropAttributeBool m_bIgnoreTranslucent;
	// MPropertySortPriority = -2
	// MPropertyDescription = "Do not trace against any models (only hit world geometry)."
	CSmartPropAttributeBool m_bIgnoreModels;
	// MPropertySortPriority = -2
	// MPropertyDescription = "Do not trace against dynamic entities which may move in game."
	CSmartPropAttributeBool m_bIgnoreEntities;
	// MPropertySortPriority = -2
	// MPropertyDescription = "Do not trace against cable geometry."
	CSmartPropAttributeBool m_bIgnoreCables;
};
