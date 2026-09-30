// MHasKV3TransferPolymorphicClassname
class C_INIT_SequenceFromCP : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "kill unused"
	bool m_bKillUnused;
	// MPropertyFriendlyName = "offset propotional to radius"
	bool m_bRadiusScale;
	// MPropertyFriendlyName = "control point"
	int32 m_nCP; // = 1
	// MPropertyFriendlyName = "per particle spatial offset"
	// MVectorIsCoordinate
	Vector m_vecOffset;
};
