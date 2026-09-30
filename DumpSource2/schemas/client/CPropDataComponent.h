// MHasKV3TransferPolymorphicClassname
class CPropDataComponent : public CEntityComponent
{
	float32 m_flDmgModBullet; // = 1
	float32 m_flDmgModClub; // = 1
	float32 m_flDmgModExplosive; // = 1
	float32 m_flDmgModFire; // = 1
	CUtlSymbolLarge m_iszPhysicsDamageTableName;
	CUtlSymbolLarge m_iszBasePropData;
	int32 m_nInteractions;
	bool m_bSpawnMotionDisabled;
	int32 m_nDisableTakePhysicsDamageSpawnFlag;
	int32 m_nMotionDisabledSpawnFlag;
};
