class CGameScriptedMoveData
{
	Vector m_vAccumulatedRootMotion;
	QAngle m_angAccumulatedRootMotionRotation;
	VectorWS m_vSrc;
	QAngle m_angSrc;
	QAngle m_angCurrent;
	float32 m_flLockedSpeed; // = -1
	float32 m_flAngRate;
	float32 m_flDuration;
	GameTime_t m_flStartTime;
	bool m_bActive;
	bool m_bTeleportOnEnd;
	bool m_bIgnoreRotation;
	bool m_bSuccess; // = true
	ForcedCrouchState_t m_nForcedCrouchState; // = "FORCEDCROUCH_NONE"
	bool m_bIgnoreCollisions;
	Vector m_vDest;
	QAngle m_angDst;
	CHandle< CBaseEntity > m_hDestEntity;
};
