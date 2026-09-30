// MHasKV3TransferPolymorphicClassname
class CBoneConstraintDotToMorph : public CBoneConstraintBase
{
	CUtlString m_sBoneName;
	CUtlString m_sTargetBoneName;
	CUtlString m_sMorphChannelName;
	float32[4] m_flRemap; // = [ 0, 180, 0, 1 ]
};
