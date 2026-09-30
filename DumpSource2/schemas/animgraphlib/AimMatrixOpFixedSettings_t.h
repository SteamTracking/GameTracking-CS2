class AimMatrixOpFixedSettings_t
{
	CAnimAttachment m_attachment;
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	CPoseHandle[10] m_poseCacheHandles; // = [ { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }, { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 } ]
	AimMatrixBlendMode m_eBlendMode; // = "AimMatrixBlendMode_None"
	float32 m_flMaxYawAngle; // = 45
	float32 m_flMaxPitchAngle; // = 45
	int32 m_nSequenceMaxFrame;
	int32 m_nBoneMaskIndex; // = -1
	bool m_bTargetIsPosition; // = true
	bool m_bUseBiasAndClamp;
	float32 m_flBiasAndClampYawOffset; // = 1
	float32 m_flBiasAndClampPitchOffset; // = 1
	CBlendCurve m_biasAndClampBlendCurve; // = { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }
};
