// MHasKV3TransferPolymorphicClassname
class CBoneConstraintPoseSpaceMorph : public CBoneConstraintBase
{
	CUtlString m_sBoneName;
	CUtlString m_sAttachmentName;
	CUtlVector< CUtlString > m_outputMorph;
	CUtlVector< CBoneConstraintPoseSpaceMorph::Input_t > m_inputList;
	bool m_bClamp;
};
