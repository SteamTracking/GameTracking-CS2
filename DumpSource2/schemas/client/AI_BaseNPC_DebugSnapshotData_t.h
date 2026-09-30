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
	AI_BaseNPCAnimGraph_DebugSnapshotData_t animgraph; // = { "ag2_update_id": -1, "e_action_desired": "", "e_action_handshake_body_authority_current": "", "e_action_handshake_body_authority_desired": "", "e_action_handshake_restart": "", "e_movement_handshake_body_authority_current": "", "e_movement_handshake_body_authority_desired": "", "e_movement_handshake_restart": "", "e_movement_type_desired": "" }
	AI_Navigator_DebugSnapshotData_t navigator;
	AI_MotorServices_DebugSnapshotData_t motorServices;
	AI_FacingServices_DebugSnapshotData_t facingServices;
};
