// MHasKV3TransferPolymorphicClassname
class CAimMatrixUpdateNode : public CUnaryUpdateNode
{
	AimMatrixOpFixedSettings_t m_opFixedSettings; // = { "m_attachment": { "m_influenceIndices": [ 0, 0, 0 ], "m_influenceOffsets": [ [ 0, 0, 0 ], [ 0, 0, 0 ], [ 0, 0, 0 ] ], "m_influenceRotations": [ [ 0, 0, 0, 0 ], [ 0, 0, 0, 0 ], [ 0, 0, 0, 0 ] ], "m_influenceWeights": [ 0, 0, 0 ], "m_numInfluences": 0 }, "m_bTargetIsPosition": true, "m_bUseBiasAndClamp": false, "m_biasAndClampBlendCurve": { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }, "m_damping": { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }, "m_eBlendMode": "AimMatrixBlendMode_None", "m_flBiasAndClampPitchOffset": 1, "m_flBiasAndClampYawOffset": 1, "m_flMaxPitchAngle": 45, "m_flMaxYawAngle": 45, "m_nBoneMaskIndex": -1, "m_nSequenceMaxFrame": 0, "m_poseCacheHandles": [ { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 } ] }
	AnimVectorSource m_target; // = "MoveDirection"
	CAnimParamHandle m_paramIndex; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	HSequence m_hSequence; // = -1
	bool m_bResetChild;
	bool m_bLockWhenWaning;
};
