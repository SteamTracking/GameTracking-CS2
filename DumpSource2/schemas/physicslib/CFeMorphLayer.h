class CFeMorphLayer
{
	CUtlString m_Name;
	uint32 m_nNameHash;
	CUtlVector< uint16 > m_Nodes;
	CUtlVector< Vector > m_InitPos;
	CUtlVector< float32 > m_Gravity;
	CUtlVector< float32 > m_GoalStrength;
	CUtlVector< float32 > m_GoalDamping;
};
