// MPropertyFriendlyName = "Layout Grid"
// MPropertyDescription = "Generates set of child instances arranged in a regular grid layout."
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_Layout2DGrid : public CSmartPropElement_Group
{
	// MPropertyDescription = "Overall grid dimension along X axis."
	// MPropertyAttributeRange = "biased 0 4096"
	CSmartPropAttributeFloat m_flWidth; // = 100
	// MPropertyDescription = "Overall grid dimension along Y axis."
	// MPropertyAttributeRange = "biased 0 4096"
	CSmartPropAttributeFloat m_flLength; // = 100
	// MPropertyDescription = "Layout length vertically (Along Z axis instead of Y)."
	CSmartPropAttributeBool m_bVerticalLength;
	// MPropertyDescription = "ARRAY: Grid is a specific number of grid divisions. FILL: The boundary is filled with as many as will fit at the specified cell spacing."
	CSmartPropAttributeGridPlacementMode m_GridArrangement; // = "SEGMENT"
	// MPropertyDescription = "Specifies the overall grid origin location. Corner origin grids default to quadrant I, but may be expressed in others using negative values for Width and/or Length."
	CSmartPropAttributeGridOriginMode m_GridOriginMode; // = "CENTER"
	// MPropertyDescription = "Grid segments along width axis."
	// MPropertyAttributeRange = "1 64"
	// MPropertySuppressExpr = "m_GridArrangement == FILL"
	CSmartPropAttributeInt m_nCountW; // = 5
	// MPropertyDescription = "Grid segments along Length axis."
	// MPropertyAttributeRange = "1 64"
	// MPropertySuppressExpr = "m_GridArrangement == FILL"
	CSmartPropAttributeInt m_nCountL; // = 5
	// MPropertyDescription = "Minimum Width of filled grid cells."
	// MPropertyAttributeRange = "biased 0 1024"
	// MPropertySuppressExpr = "m_GridArrangement == SEGMENT"
	CSmartPropAttributeFloat m_flSpacingWidth; // = 20
	// MPropertyDescription = "Minimum Length of filled grid cells."
	// MPropertyAttributeRange = "biased 0 1024"
	// MPropertySuppressExpr = "m_GridArrangement == SEGMENT"
	CSmartPropAttributeFloat m_flSpacingLength; // = 20
	// MPropertyDescription = "Shifts every other cell row and/or column."
	// MPropertySuppressExpr = "m_GridArrangement == FILL"
	CSmartPropAttributeBool m_bAlternateShift;
	// MPropertyDescription = "Vary cell shift in X."
	// MPropertyAttributeRange = "biased 0 1024"
	// MPropertySuppressExpr = "m_GridArrangement == FILL || m_bAlternateShift == false"
	CSmartPropAttributeFloat m_flAlternateShiftWidth; // = 0.5
	// MPropertyDescription = "Vary cell shift in Y."
	// MPropertyAttributeRange = "biased 0 1024"
	// MPropertySuppressExpr = "m_GridArrangement == FILL || m_bAlternateShift == false"
	CSmartPropAttributeFloat m_flAlternateShiftLength;
};
