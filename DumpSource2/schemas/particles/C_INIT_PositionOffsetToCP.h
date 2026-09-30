// MHasKV3TransferPolymorphicClassname
class C_INIT_PositionOffsetToCP : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "creation control point number"
	int32 m_nControlPointNumberStart;
	// MPropertyFriendlyName = "offset control point number"
	int32 m_nControlPointNumberEnd; // = 1
	// MPropertyFriendlyName = "offset in local space 0/1"
	bool m_bLocalCoords;
};
