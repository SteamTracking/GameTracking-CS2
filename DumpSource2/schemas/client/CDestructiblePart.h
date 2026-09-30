// MModelGameData
// MFgdHelper = "game_data_list{ key = 'CDestructiblePart' }"
class CDestructiblePart
{
	// MPropertySuppressField
	CGlobalSymbol m_DebugName;
	// MPropertyStartGroup = "+Hitgroup"
	// MPropertyDescription = "The hitgroup this is related to."
	HitGroup_t m_nHitGroup; // = "HITGROUP_GENERIC"
	// MPropertyDescription = "Do we disable the hitgroup and physics bodies tagged with said hitgroup when all damage levels are destroyed?"
	// MPropertyFriendlyName = "Disable Hit Group & Remove Tagged Physics Bodies When Destroyed"
	bool m_bDisableHitGroupWhenDestroyed; // = true
	// MPropertyDescription = "Other hitgroups to destroy when this one is fully destroyed.  Useful for chaining destructibles like blowing up the lower arm when the upper arm dies."
	CUtlVector< HitGroup_t > m_nOtherHitgroupsToDestroyWhenFullyDestructed;
	// MPropertyStartGroup = "+Gibbing"
	// MPropertyDescription = "Only allow this part to be destroyed when gibbing.  Useful for special case gibbing breakables like torsos."
	bool m_bOnlyDestroyWhenGibbing;
	// MPropertyStartGroup = "+Model Setup/+Body Group"
	// MPropertyDescription = "Body group to set when this damage level is broken."
	// MPropertyAttributeEditor = "ModelDocPicker( MODELDOC_PICK_TYPE_BODY_GROUP )"
	CGlobalSymbol m_sBodyGroupName;
	// MPropertyStartGroup = ""
	// MPropertyDescription = "The various damage levels for this hitgroup."
	// MPropertyFriendlyName = "Damage Levels"
	// MPropertyAutoExpandSelf
	CUtlVector< CDestructiblePart_DamageLevel > m_DamageLevels;
};
