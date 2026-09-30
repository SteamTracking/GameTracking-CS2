class CPathParameters
{
	// MPropertyFriendlyName = "start control point number"
	int32 m_nStartControlPointNumber;
	// MPropertyFriendlyName = "mid control point number"
	int32 m_nMidControlPointNumber; // = -1
	// MPropertyFriendlyName = "end control point number"
	int32 m_nEndControlPointNumber;
	// MPropertyFriendlyName = "bulge control 0=random 1=orientation of start pnt 2=orientation of end point"
	// MPropertySuppressExpr = "m_nMidControlPointNumber != -1"
	int32 m_nBulgeControl;
	// MPropertyFriendlyName = "random bulge"
	// MPropertySuppressExpr = "m_nMidControlPointNumber != -1"
	float32 m_flBulge;
	// MPropertyFriendlyName = "mid point position"
	// MPropertySuppressExpr = "m_nMidControlPointNumber != -1"
	float32 m_flMidPoint; // = 0.5
	// MPropertyFriendlyName = "Offset from curve start point for path start"
	// MVectorIsCoordinate
	Vector m_vStartPointOffset;
	// MPropertyFriendlyName = "Offset from curve midpoint for curve center"
	// MVectorIsCoordinate
	Vector m_vMidPointOffset;
	// MPropertyFriendlyName = "Offset from control point for path end"
	// MVectorIsCoordinate
	Vector m_vEndOffset;
};
