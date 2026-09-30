class CMotionSearchNode
{
	CUtlVector< CMotionSearchNode* > m_children;
	CVectorQuantizer m_quantizer;
	CUtlVector< CUtlVector< SampleCode > > m_sampleCodes;
	CUtlVector< CUtlVector< int32 > > m_sampleIndices;
	CUtlVector< int32 > m_selectableSamples;
};
