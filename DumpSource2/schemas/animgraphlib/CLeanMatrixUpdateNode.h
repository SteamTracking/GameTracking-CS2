// MHasKV3TransferPolymorphicClassname
class CLeanMatrixUpdateNode : public CLeafUpdateNode
{
	int32[3][3] m_frameCorners;
	CPoseHandle[9] m_poses;
	CAnimInputDamping m_damping;
	AnimVectorSource m_blendSource; // = "MoveDirection"
	CAnimParamHandle m_paramIndex;
	Vector m_verticalAxis;
	Vector m_horizontalAxis;
	HSequence m_hSequence; // = -1
	float32 m_flMaxValue;
	int32 m_nSequenceMaxFrame;
};
