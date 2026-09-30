class SkeletonAnimCapture_t::Frame_t
{
	float32 m_flTime;
	SkeletonAnimCapture_t::FrameStamp_t m_Stamp;
	CTransform m_Transform;
	bool m_bTeleport;
	CUtlVector< CTransform > m_CompositeBones;
	CUtlVector< CTransform > m_SimStateBones;
	CUtlVector< CTransform > m_FeModelAnims;
	CUtlVector< VectorAligned > m_FeModelPos;
	CUtlVector< float32 > m_FlexControllerWeights;
};
