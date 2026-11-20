class LookAtOpFixedSettings_t
{
	CAnimAttachment m_attachment;
	CAnimInputDamping m_damping;
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
