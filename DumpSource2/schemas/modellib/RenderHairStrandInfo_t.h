class RenderHairStrandInfo_t
{
	uint32[2] m_nGuideHairIndices_nSurfaceTriIndex;
	uint16[4] m_vGuideBary_vBaseBary;
	uint16[4] m_vRootOffset_flLengthScale;
	uint16[2] m_nPackedBaseUv;
	uint32 m_nPackedSurfaceNormalOs;
	uint32 m_nPackedSurfaceTangentOs;
	uint32 m_nDataOffset_Segments;
};
