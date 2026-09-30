// MPropertyFriendlyName = "Ground Root Motion Motor"
// MHasKV3TransferPolymorphicClassname
class AI_GroundRootMotionMotor_DebugSnapshotData_t : public DebugSnapshotBaseStructuredData_t
{
	CGlobalSymbol desired_movement_gait_set;
	CGlobalSymbol desired_movement_gait;
	CGlobalSymbol current_movement_gait_set;
	CGlobalSymbol current_movement_gait;
	CGlobalSymbol movement_setting_id;
	CGlobalSymbol gait_switch_blocked_reason;
	bool b_goal_completion_allowed; // = true
	CGlobalSymbol state;
	int32 n_state_active_tick_count;
	bool b_has_path;
	float32 f_remaining_ground_path_length; // = -1
	float32 f_current_speed; // = -1
	CGlobalSymbol move_type;
	float32 f_forward_strafing_angle_actual; // = -1
	float32 f_forward_strafing_angle_desired; // = -1
	float32 f_forward_strafing_angle_committed; // = -1
	float32 f_current_lean;
	float32 f_target_lean;
	CUtlVector< AI_GroundRootMotionMotor_DebugSnapshotData_t::Event_t > vec_events;
};
