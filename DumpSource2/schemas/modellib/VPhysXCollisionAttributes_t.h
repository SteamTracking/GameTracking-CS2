class VPhysXCollisionAttributes_t
{
	int32 m_nIncludeDetailLayerCount;
	uint32 m_CollisionGroup;
	CUtlVector< uint32 > m_InteractAs;
	CUtlVector< uint32 > m_InteractWith;
	CUtlVector< uint32 > m_InteractExclude;
	CUtlVector< uint32 > m_DetailLayers;
	CUtlString m_CollisionGroupString;
	CUtlVector< CUtlString > m_InteractAsStrings;
	CUtlVector< CUtlString > m_InteractWithStrings;
	CUtlVector< CUtlString > m_InteractExcludeStrings;
	CUtlVector< CUtlString > m_DetailLayerStrings;
};
