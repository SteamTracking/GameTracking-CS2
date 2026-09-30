class PerTickSettings_t
{
	CTransform m_startingLocalToWorld; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	CTransform m_prevLocalToWorld; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	CTransform m_finalLocalToWorld; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	CRootMotion m_rootMotion;
	int32 m_updateID; // = -1
	float32 m_flLastTimeStep;
	float32 m_flPrevAnimTime;
	float32 m_flNextAnimTime;
	bool m_bAwaken;
	bool m_bTeleported;
	bool m_bIsClient;
	bool m_bIsPredicted;
};
