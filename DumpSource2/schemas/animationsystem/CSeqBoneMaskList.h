class CSeqBoneMaskList
{
	CBufferString m_sName;
	CUtlVector< int16 > m_nLocalBoneArray;
	CUtlVector< float32 > m_flBoneWeightArray;
	float32 m_flDefaultMorphCtrlWeight; // = 1
	CUtlVector< std::pair< CBufferString, float32 > > m_morphCtrlWeightArray;
};
