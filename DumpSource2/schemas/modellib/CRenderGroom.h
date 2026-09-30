class CRenderGroom
{
	CUtlVector< RenderHairStrandInfo_t > m_hairs;
	CUtlVector< uint32 > m_hairPositionOffsets;
	CStrongHandleCopyable< InfoForResourceTypeIMaterial2 > m_hSimParamsMat;
	CUtlVector< int32 > m_strandSegmentCountHist;
	int32 m_nMaxSegmentsPerHairStrand;
	int32 m_nGuideHairCount;
	int32 m_nHairCount;
	int32 m_nTotalVertexCount;
	int32 m_nTotalSegmentCount;
	int32 m_nGroomGroupID;
	int32 m_nAttachBoneIdx;
	int32 m_nAttachMeshIdx; // = -1
	int32 m_nAttachMeshDrawCallIdx; // = -1
	bool m_bEnableSimulation;
};
