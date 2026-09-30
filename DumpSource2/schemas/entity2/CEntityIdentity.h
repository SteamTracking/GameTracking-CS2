class CEntityIdentity
{
	// MNotSaved
	int32 m_nameStringTableIndex;
	CUtlSymbolLarge m_name;
	// MNotSaved
	CUtlSymbolLarge m_designerName;
	// MNotSaved
	uint32 m_flags;
	// MNotSaved
	WorldGroupId_t m_worldGroupId;
	// MNotSaved
	uint32 m_fDataObjectTypes;
	// MNotSaved
	ChangeAccessorFieldPathIndex_t m_PathIndex;
	CEntityAttributeTable* m_pAttributes;
	// MNotSaved
	CEntityIdentity* m_pPrev;
	// MNotSaved
	CEntityIdentity* m_pNext;
	// MNotSaved
	CEntityIdentity* m_pPrevByClass;
	// MNotSaved
	CEntityIdentity* m_pNextByClass;
};
