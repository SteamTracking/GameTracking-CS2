class FootFixedData_t
{
	VectorAligned m_vToeOffset;
	VectorAligned m_vHeelOffset;
	int32 m_nTargetBoneIndex; // = -1
	int32 m_nAnkleBoneIndex; // = -1
	int32 m_nIKAnchorBoneIndex; // = -1
	int32 m_ikChainIndex; // = -1
	float32 m_flMaxIKLength; // = -1
	int32 m_nFootIndex; // = -1
	int32 m_nTagIndex; // = -1
	float32 m_flMaxRotationLeft; // = 90
	float32 m_flMaxRotationRight; // = 90
};
