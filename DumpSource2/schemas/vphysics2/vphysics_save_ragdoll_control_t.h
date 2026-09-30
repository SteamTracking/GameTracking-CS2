class vphysics_save_ragdoll_control_t
{
	float32 m_flMinSpringFrequency;
	float32 m_flMaxSpringFrequency;
	float32 m_flMaxStretch;
	bool m_bSolidCollisionAtZeroWeight;
	bool m_bRequiresDynamicBodies;
	bool m_bIgnoreTeleport;
	Vector m_vLinearVelocityAccumulator;
	RotationVector m_vAngularVelocityAccumulator;
	Vector m_vForceAccumulator;
	int32 m_nBodyCount;
};
