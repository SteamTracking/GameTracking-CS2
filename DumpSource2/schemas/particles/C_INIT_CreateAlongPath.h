// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateAlongPath : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "maximum distance"
	CPerParticleFloatInput m_fMaxDistance;
	// MPropertyFriendlyName = "position t value"
	CPerParticleFloatInput m_fT; // = { "m_nRandomMode": "PF_RANDOM_MODE_VARYING", "m_nType": "PF_TYPE_RANDOM_UNIFORM" }
	CPathParameters m_PathParams;
	// MPropertyFriendlyName = "randomly select sequential CP pairs between start and end points"
	bool m_bUseRandomCPs;
	// MPropertyFriendlyName = "Offset from control point for path end"
	// MVectorIsCoordinate
	Vector m_vEndOffset;
	// MPropertyFriendlyName = "save offset"
	bool m_bSaveOffset;
};
