class lerpdata_t
{
	CHandle< CBaseEntity > m_hEnt;
	MoveType_t m_MoveType; // = "MOVETYPE_NONE"
	GameTime_t m_flStartTime;
	VectorWS m_vecStartOrigin;
	Quaternion m_qStartRot; // = [ 0, 0, 0, 1 ]
	ParticleIndex_t m_nFXIndex; // = -1
};
