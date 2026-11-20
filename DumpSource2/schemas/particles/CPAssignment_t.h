class CPAssignment_t
{
	// MPropertyFriendlyName = "Control Point Number"
	int32 m_nCPNumber;
	// MPropertyFriendlyName = "CP Position"
	CPerParticleVecInput m_Pos; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 0 }
	// MPropertyFriendlyName = "CP Orientation Type"
	ParticleOrientationSetMode_t m_nOrientationMode; // = "PARTICLE_ORIENTATION_SET_NONE"
};
