// MVDataRoot
class CSosSoundEventGroupSchema
{
	// MPropertyAttributeEditor = "Radio"
	SosGroupType_t m_nGroupType; // = "SOS_GROUPTYPE_DYNAMIC"
	// MPropertyStartGroup = "+Block Events"
	bool m_bBlocksEvents;
	// MPropertyReadonlyExpr = "!m_bBlocksEvents"
	int32 m_nBlockMaxCount;
	// MPropertyStartGroup = ""
	float32 m_flMemberLifespanTime; // = -1
	bool m_bInvertMatch;
	// MPropertyStartGroup = "+Event Name"
	// MPropertyAttributeEditor = "Radio"
	// MPropertyReadonlyExpr = "m_bMatchEventSubString"
	SosGroupFieldBehavior_t m_Behavior_EventName; // = "kIgnore"
	// MPropertyReadonlyExpr = "m_Behavior_EventName != kMatch || m_bMatchEventSubString"
	CUtlString m_matchSoundEventName;
	// MPropertyStartGroup = "+Event SubString"
	bool m_bMatchEventSubString;
	// MPropertyReadonlyExpr = "!m_bMatchEventSubString"
	CUtlString m_matchSoundEventSubString;
	// MPropertyStartGroup = "+Ent Index"
	// MPropertyAttributeEditor = "Radio"
	SosGroupFieldBehavior_t m_Behavior_EntIndex; // = "kIgnore"
	// MPropertyReadonlyExpr = "m_Behavior_EntIndex != kMatch"
	float32 m_flEntIndex; // = -1
	// MPropertyStartGroup = "+OpVar Float"
	// MPropertySuppressExpr = "m_nGroupType == SOS_GROUPTYPE_STATIC"
	// MPropertyAttributeEditor = "Radio"
	SosGroupFieldBehavior_t m_Behavior_Opvar; // = "kIgnore"
	// MPropertyReadonlyExpr = "m_Behavior_Opvar != kMatch"
	// MPropertySuppressExpr = "m_nGroupType == SOS_GROUPTYPE_STATIC"
	float32 m_flOpvar; // = -1
	// MPropertyStartGroup = "+OpVar String"
	// MPropertySuppressExpr = "m_nGroupType == SOS_GROUPTYPE_STATIC"
	// MPropertyAttributeEditor = "Radio"
	SosGroupFieldBehavior_t m_Behavior_String; // = "kIgnore"
	// MPropertyReadonlyExpr = "m_Behavior_String != kMatch"
	// MPropertySuppressExpr = "m_nGroupType == SOS_GROUPTYPE_STATIC"
	CUtlString m_opvarString;
	// MPropertyStartGroup = ""
	// MPropertyAutoExpandSelf
	CUtlVector< CSosGroupActionSchema* > m_vActions;
};
