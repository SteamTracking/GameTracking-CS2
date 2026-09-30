class DecalGroupOption_t
{
	CStrongHandleCopyable< InfoForResourceTypeIMaterial2 > m_hMaterial;
	CGlobalSymbol m_sSequenceName;
	float32 m_flProbability; // = 1
	bool m_bEnableAngleBetweenNormalAndGravityRange;
	// MPropertySuppressExpr = "m_bEnableAngleBetweenNormalAndGravityRange == 0"
	float32 m_flMinAngleBetweenNormalAndGravity;
	// MPropertySuppressExpr = "m_bEnableAngleBetweenNormalAndGravityRange == 0"
	float32 m_flMaxAngleBetweenNormalAndGravity; // = 180
};
