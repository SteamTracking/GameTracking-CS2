class CNmBlendSpace2D
{
	// MPropertyAutoExpandSelf
	// MPropertyResizable = 0
	CUtlVector< CUtlString > m_pointNames;
	// MPropertyAutoExpandSelf
	// MPropertyResizable = 0
	CUtlVector< Vector2D > m_points;
	// MPropertySuppressField
	CUtlVector< uint8 > m_indices;
	// MPropertySuppressField
	CUtlVector< uint8 > m_hullIndices;
};
