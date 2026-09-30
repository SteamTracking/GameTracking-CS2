// MPropertyFriendlyName = "Animation State"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_State
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_StateTransition > > m_transitions;
	// MPropertySuppressField
	CUtlVector< CStateAction > m_actions;
	// MPropertyFriendlyName = "Name"
	// MPropertySortPriority = 100
	CUtlString m_name; // = "Unnamed"
	// MPropertyFriendlyName = "Comment"
	// MPropertyAttributeEditor = "TextBlock()"
	// MPropertySortPriority = -100
	CUtlString m_sComment;
	// MPropertySuppressField
	AnimStateID m_stateID;
	// MPropertySuppressField
	Vector2D m_position;
	// MPropertyFriendlyName = "Start State"
	bool m_bIsStartState;
	// MPropertyFriendlyName = "End State"
	bool m_bIsEndtState;
	// MPropertyFriendlyName = "Show Input To Graph"
	bool m_bIsInputToGraph; // = true
	// MPropertyFriendlyName = "Passthrough"
	bool m_bIsPassthrough;
	// MPropertyFriendlyName = "Passthrough Root Motion"
	bool m_bIsPassthroughRootMotion;
	// MPropertyFriendlyName = "Pre Evaluate Passthrough Transition Path"
	bool m_bPreEvaluatePassthroughTransitionPath;
};
