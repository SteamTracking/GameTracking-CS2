// MPropertySuppressBaseClassField = "m_iSlot"
// MPropertySuppressBaseClassField = "m_iPosition"
// MHasKV3TransferPolymorphicClassname
class CCSWeaponBaseVData : public CBasePlayerWeaponVData
{
	CSWeaponType m_WeaponType; // = "WEAPONTYPE_UNKNOWN"
	CSWeaponCategory m_WeaponCategory; // = "WEAPONCATEGORY_OTHER"
	// MPropertyStartGroup = "Visuals"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCNmSkeleton > > m_szAnimSkeleton;
	Vector m_vecMuzzlePos0;
	Vector m_vecMuzzlePos1;
	// MPropertyDescription = "Effect to actually fire into the world from this weapon"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_szTracerParticle;
	// MPropertyStartGroup = "HUD Positions"
	// MPropertyFriendlyName = "HUD Bucket"
	// MPropertyDescription = "Which 'column' to display this weapon in the HUD"
	gear_slot_t m_GearSlot; // = "GEAR_SLOT_INVALID"
	int32 m_GearSlotPosition; // = -1
	// MPropertyFriendlyName = "HUD Bucket Position"
	// MPropertyDescription = "Default team (non Terrorist or Counter-Terrorist) 'row' to display this weapon in the HUD."
	loadout_slot_t m_DefaultLoadoutSlot; // = "LOADOUT_SLOT_INVALID"
	// MPropertyStartGroup = "In-Game Data"
	int32 m_nPrice;
	int32 m_nKillAward;
	int32 m_nPrimaryReserveAmmoMax;
	int32 m_nSecondaryReserveAmmoMax;
	bool m_bMeleeWeapon;
	bool m_bHasBurstMode;
	bool m_bIsRevolver;
	bool m_bCannotShootUnderwater;
	// MPropertyFriendlyName = "In-Code weapon name"
	CGlobalSymbol m_szName;
	CSWeaponSilencerType m_eSilencerType; // = "WEAPONSILENCER_NONE"
	bool m_bShowCrosshair; // = true
	bool m_bIsFullAuto;
	int32 m_nNumBullets;
	bool m_bReloadsSingleShells;
	// MPropertyStartGroup = "Firing Mode Data"
	CFiringModeFloat m_flCycleTime;
	float32 m_flCycleTimeWhenInBurstMode;
	float32 m_flTimeBetweenBurstShots;
	CFiringModeFloat m_flMaxSpeed;
	CFiringModeFloat m_flSpread;
	CFiringModeFloat m_flInaccuracyCrouch;
	CFiringModeFloat m_flInaccuracyStand;
	CFiringModeFloat m_flInaccuracyJump;
	CFiringModeFloat m_flInaccuracyLand;
	CFiringModeFloat m_flInaccuracyLadder;
	CFiringModeFloat m_flInaccuracyFire;
	CFiringModeFloat m_flInaccuracyMove;
	CFiringModeFloat m_flRecoilAngle;
	CFiringModeFloat m_flRecoilAngleVariance;
	CFiringModeFloat m_flRecoilMagnitude;
	CFiringModeFloat m_flRecoilMagnitudeVariance;
	CFiringModeInt m_nTracerFrequency;
	float32 m_flInaccuracyJumpInitial;
	float32 m_flInaccuracyJumpApex;
	float32 m_flInaccuracyReload;
	float32 m_flDeployDuration;
	float32 m_flDisallowAttackAfterReloadStartDuration;
	int32 m_nBurstShotCount; // = 2
	bool m_bAllowBurstHolster; // = true
	// MPropertyStartGroup = "Firing"
	int32 m_nRecoilSeed;
	int32 m_nSpreadSeed;
	float32 m_flAttackMovespeedFactor;
	float32 m_flInaccuracyPitchShift;
	float32 m_flInaccuracyAltSoundThreshold;
	CUtlString m_szUseRadioSubtitle;
	// MPropertyStartGroup = "Zooming"
	bool m_bUnzoomsAfterShot;
	bool m_bHideViewModelWhenZoomed;
	int32 m_nZoomLevels;
	int32 m_nZoomFOV1;
	int32 m_nZoomFOV2;
	float32 m_flZoomTime0;
	float32 m_flZoomTime1;
	float32 m_flZoomTime2;
	// MPropertyStartGroup = "Iron Sights"
	float32 m_flIronSightPullUpSpeed; // = 8
	float32 m_flIronSightPutDownSpeed; // = 4
	float32 m_flIronSightFOV; // = 80
	float32 m_flIronSightPivotForward; // = 10
	float32 m_flIronSightLooseness; // = 0.5
	// MPropertyStartGroup = "Damage"
	int32 m_nDamage;
	float32 m_flHeadshotMultiplier;
	float32 m_flArmorRatio;
	float32 m_flPenetration;
	float32 m_flRange;
	float32 m_flRangeModifier;
	float32 m_flFlinchVelocityModifierLarge;
	float32 m_flFlinchVelocityModifierSmall;
	// MPropertyStartGroup = "Recovery"
	float32 m_flRecoveryTimeCrouch;
	float32 m_flRecoveryTimeStand;
	float32 m_flRecoveryTimeCrouchFinal;
	float32 m_flRecoveryTimeStandFinal;
	int32 m_nRecoveryTransitionStartBullet;
	int32 m_nRecoveryTransitionEndBullet;
	// MPropertyStartGroup = "Grenade Data"
	float32 m_flThrowVelocity;
	Vector m_vSmokeColor; // = [ 1, 1, 1 ]
	CGlobalSymbol m_szAnimClass;
};
