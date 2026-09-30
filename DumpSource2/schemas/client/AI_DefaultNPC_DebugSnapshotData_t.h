// MPropertyFriendlyName = "Default NPC"
// MHasKV3TransferPolymorphicClassname
class AI_DefaultNPC_DebugSnapshotData_t : public DebugSnapshotBaseStructuredData_t
{
	CGlobalSymbol s_npc_current_ability;
	CGlobalSymbol s_npc_current_held_ability;
	CGlobalSymbol s_npc_tactic_current;
	CGlobalSymbol s_npc_tactic_phase;
	CUtlVector< CGlobalSymbol > tactic_interrupt_conditions;
	AI_DefaultNPC_DebugSnapshotData_t::PathQuery_t path_query;
	CUtlVector< AI_DefaultNPC_DebugSnapshotData_t::PathQuery_t > path_queries_speculative;
};
