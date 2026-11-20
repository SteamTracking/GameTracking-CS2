// MPropertyFriendlyName = "Base NPC"
// MHasKV3TransferPolymorphicClassname
class AI_BaseNPC_DebugSnapshotData_t : public DebugSnapshotBaseStructuredData_t
{
	CGlobalSymbol npc_state;
	CHandle< C_BaseEntity > current_enemy;
	CUtlString s_current_schedule;
	CGlobalSymbol s_current_task;
	CUtlString s_prev_schedule;
	CUtlString s_npc_current_movement;
	CUtlString s_last_task_end_location;
	CUtlVector< CGlobalSymbol > conditions;
	CUtlVector< CGlobalSymbol > anim_events;
	AI_BaseNPCAnimGraph_DebugSnapshotData_t animgraph;
	AI_Navigator_DebugSnapshotData_t navigator;
	AI_MotorServices_DebugSnapshotData_t motorServices;
	AI_FacingServices_DebugSnapshotData_t facingServices;
};
