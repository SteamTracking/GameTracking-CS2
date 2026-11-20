class World_t
{
	WorldBuilderParams_t m_builderParams;
	CUtlVector< NodeData_t > m_worldNodes;
	BakedLightingInfo_t m_worldLightingInfo;
	CUtlVector< CStrongHandleCopyable< InfoForResourceTypeCEntityLump > > m_entityLumps;
};
