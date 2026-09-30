// MHasKV3TransferPolymorphicClassname
class CLeanMatrixUpdateNode : public CLeafUpdateNode
{
	int32[3][3] m_frameCorners;
	CPoseHandle[9] m_poses; // = [ { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 } ]
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	AnimVectorSource m_blendSource; // = "MoveDirection"
	CAnimParamHandle m_paramIndex; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	Vector m_verticalAxis;
	Vector m_horizontalAxis;
	HSequence m_hSequence; // = -1
	float32 m_flMaxValue;
	int32 m_nSequenceMaxFrame;
};
