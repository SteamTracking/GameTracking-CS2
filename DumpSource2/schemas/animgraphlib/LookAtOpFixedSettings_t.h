class LookAtOpFixedSettings_t
{
	CAnimAttachment m_attachment;
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	CUtlVector< LookAtBone_t > m_bones;
	float32 m_flYawLimit; // = 45
	float32 m_flPitchLimit; // = 45
	float32 m_flHysteresisInnerAngle; // = 1
	float32 m_flHysteresisOuterAngle; // = 20
	bool m_bRotateYawForward; // = true
	bool m_bMaintainUpDirection;
	bool m_bTargetIsPosition; // = true
	bool m_bUseHysteresis;
};
