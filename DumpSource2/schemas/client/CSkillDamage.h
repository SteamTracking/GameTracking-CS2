class CSkillDamage
{
	// MPropertyDescription = "Damage Dealt (in the case of NPC vs NPC damage, medium skill times the NPC damage scalar is used)"
	CSkillFloat m_flDamage;
	// MPropertyDescription = "Damage Scalar for NPC vs NPC cases"
	float32 m_flNPCDamageScalarVsNPC; // = 1
	// MPropertyDescription = "If specified, the damage used to compute physics forces. Otherwise normal damage is used (and is not scaled by the NPC damage scalar."
	float32 m_flPhysicsForceDamage;
};
