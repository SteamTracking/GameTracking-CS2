// MHasKV3TransferPolymorphicClassname
class C_INIT_NormalOffset : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "offset min"
	// MVectorIsCoordinate
	Vector m_OffsetMin;
	// MPropertyFriendlyName = "offset max"
	// MVectorIsCoordinate
	Vector m_OffsetMax;
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "offset in local space 0/1"
	bool m_bLocalCoords;
	// MPropertyFriendlyName = "normalize output 0/1"
	bool m_bNormalize;
};
