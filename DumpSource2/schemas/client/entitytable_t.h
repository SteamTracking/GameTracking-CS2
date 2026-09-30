class entitytable_t
{
	int32 id;
	CEntityIndex edictindex; // = -1
	CEntityIndex saveentityindex; // = -1
	bool bWasSaved;
	SaveRestoreTableFlags_t flags;
	CUtlSymbolLarge classname;
	CUtlSymbolLarge globalname;
	CUtlSymbolLarge entityname;
	Vector landmarkModelSpace;
	CEntityKeyValues* m_pPrecacheEntityKeys;
};
