class DestructiblePartDamageRequest_t
{
	HitGroup_t m_nHitGroup; // = "HITGROUP_INVALID"
	int32 m_nDamageLevel; // = -1
	uint16 m_nDesiredHealth;
	EDestructibleParts_DestroyParameterFlags m_nDestroyFlags; // = "GenerateBreakpieces|SetBodyGroupAndCollisionState|EnableFlinches"
	DamageTypes_t m_nDamageType; // = "DMG_BLAST"
	float32 m_flBreakDamage;
	float32 m_flBreakDamageRadius; // = 24
	CHandle< C_BaseEntity > m_hAttacker;
	VectorWS m_vWsBreakDamageOrigin;
	Vector m_vWsBreakDamageForce; // = [ 1, 0, 0 ]
};
