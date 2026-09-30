// MHasKV3TransferPolymorphicClassname
class CNmGraphDocument : public CNmAnimDocument
{
	CNmGraphDocFlowGraph* m_pRootGraph;
	CNmVariationHierarchy m_variationHierarchy;
	CUtlLeanVector< CNmGraphDocument::DebugParameterSet_t > m_debugParameterSets;
	CUtlLeanVector< CNmGraphDocument::DebugBoneFilterSet_t > m_debugBoneFilterSets;
	CUtlVector< V_uuid_t > m_dictionaryIDSetIDs;
};
