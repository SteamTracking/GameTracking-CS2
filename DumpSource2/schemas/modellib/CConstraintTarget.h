class CConstraintTarget
{
	Quaternion m_qOffset; // = [ 0, 0, 0, 1 ]
	Vector m_vOffset;
	uint32 m_nBoneHash;
	CUtlString m_sName;
	float32 m_flWeight;
	bool m_bIsAttachment;
};
