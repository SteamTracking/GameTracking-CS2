// MHasKV3TransferPolymorphicClassname
class CBasePlayerVData : public CEntitySubclassVDataBase
{
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_VMDL"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_sModelName;
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_VMDL"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_sModelNameAg2Override;
	CSkillFloat m_flHeadDamageMultiplier; // = 3
	CSkillFloat m_flChestDamageMultiplier; // = 1
	CSkillFloat m_flStomachDamageMultiplier; // = 1
	CSkillFloat m_flArmDamageMultiplier; // = 1
	CSkillFloat m_flLegDamageMultiplier; // = 1
	// MPropertyGroupName = "Water"
	float32 m_flHoldBreathTime; // = 15
	// MPropertyGroupName = "Water"
	// MPropertyDescription = "Seconds between drowning ticks"
	float32 m_flDrowningDamageInterval; // = 1
	// MPropertyGroupName = "Water"
	// MPropertyDescription = "Amount of damage done on the first drowning tick (+1 each subsequent interval)"
	int32 m_nDrowningDamageInitial; // = 10
	// MPropertyGroupName = "Water"
	// MPropertyDescription = "Max damage done by a drowning tick"
	int32 m_nDrowningDamageMax; // = 10
	// MPropertyGroupName = "Water"
	int32 m_nWaterSpeed; // = 100
	// MPropertyGroupName = "Use"
	float32 m_flUseRange; // = 55
	// MPropertyGroupName = "Use"
	float32 m_flUseAngleTolerance; // = 45
	// MPropertyGroupName = "Crouch"
	// MPropertyDescription = "Time to move between crouch and stand"
	float32 m_flCrouchTime; // = 0.4
};
