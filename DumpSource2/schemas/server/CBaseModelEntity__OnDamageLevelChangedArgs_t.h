class CBaseModelEntity::OnDamageLevelChangedArgs_t
{
	HitGroup_t nHitGroup; // = "HITGROUP_GENERIC"
	int32 nDamageLevel;
	int32 nDamageLevelsRemaining;
	int32 nPrevDamageLevel;
};
