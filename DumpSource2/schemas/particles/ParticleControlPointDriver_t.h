class ParticleControlPointDriver_t
{
	ParticleParamID_t m_iControlPoint;
	ParticleAttachment_t m_iAttachType; // = "PATTACH_ABSORIGIN_FOLLOW"
	CUtlString m_attachmentName;
	Vector m_vecOffset;
	QAngle m_angOffset;
	CUtlString m_entityName;
};
