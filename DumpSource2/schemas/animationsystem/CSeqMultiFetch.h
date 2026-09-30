class CSeqMultiFetch
{
	CSeqMultiFetchFlag m_flags;
	CUtlVector< int16 > m_localReferenceArray;
	int32[2] m_nGroupSize;
	int32[2] m_nLocalPose;
	CUtlVector< float32 > m_poseKeyArray0;
	CUtlVector< float32 > m_poseKeyArray1;
	int32 m_nLocalCyclePoseParameter;
	bool m_bCalculatePoseParameters;
	bool m_bFixedBlendWeight;
	float32[2] m_flFixedBlendWeightVals;
};
