class PermModelData_t
{
	CUtlString m_name;
	PermModelInfo_t m_modelInfo;
	CUtlVector< PermModelExtPart_t > m_ExtParts;
	CUtlVector< CStrongHandle< InfoForResourceTypeCRenderMesh > > m_refMeshes;
	CUtlVector< uint64 > m_refMeshGroupMasks;
	CUtlVector< uint64 > m_refPhysGroupMasks;
	CUtlVector< uint8 > m_refLODGroupMasks;
	CUtlVector< float32 > m_lodGroupSwitchDistances;
	CUtlVector< CStrongHandle< InfoForResourceTypeCPhysAggregateData > > m_refPhysicsData;
	CUtlVector< CStrongHandle< InfoForResourceTypeCPhysAggregateData > > m_refPhysicsHitboxData;
	CUtlVector< CStrongHandle< InfoForResourceTypeCAnimationGroup > > m_refAnimGroups;
	CUtlVector< CStrongHandle< InfoForResourceTypeCSequenceGroupData > > m_refSequenceGroups;
	CUtlVector< CUtlString > m_meshGroups;
	CUtlVector< MaterialGroup_t > m_materialGroups;
	uint64 m_nDefaultMeshGroupMask;
	ModelSkeletonData_t m_modelSkeleton;
	CUtlVector< int16 > m_remappingTable;
	CUtlVector< uint16 > m_remappingTableStarts;
	CUtlVector< ModelBoneFlexDriver_t > m_boneFlexDrivers;
	CModelConfigList* m_pModelConfigList;
	CUtlVector< CUtlString > m_BodyGroupsHiddenInTools;
	CUtlVector< CStrongHandle< InfoForResourceTypeCModel > > m_refAnimIncludeModels;
	CUtlVector< PermModelDataAnimatedMaterialAttribute_t > m_AnimatedMaterialAttributes;
	CUtlVector< ModelAnimGraph2Ref_t > m_animGraph2Refs;
	CUtlVector< CStrongHandle< InfoForResourceTypeCNmSkeleton > > m_vecNmSkeletonRefs;
};
