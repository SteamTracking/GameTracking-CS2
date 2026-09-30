// MHasKV3TransferPolymorphicClassname
class CEnvWindShared
{
	// MNotSaved
	GameTime_t m_flStartTime;
	// MNotSaved
	uint32 m_iWindSeed;
	uint16 m_iMinWind;
	uint16 m_iMaxWind;
	int32 m_windRadius;
	uint16 m_iMinGust;
	uint16 m_iMaxGust;
	float32 m_flMinGustDelay;
	float32 m_flMaxGustDelay;
	float32 m_flGustDuration;
	uint16 m_iGustDirChange;
	// MNotSaved
	uint16 m_iInitialWindDir;
	// MNotSaved
	float32 m_flInitialWindSpeed;
	// MNotSaved
	VectorWS m_location;
	CEntityIOOutput m_OnGustStart;
	CEntityIOOutput m_OnGustEnd;
	// MNotSaved
	CHandle< CBaseEntity > m_hEntOwner;
};
