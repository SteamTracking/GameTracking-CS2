// MHasKV3TransferPolymorphicClassname
class CNmTargetOffsetNode::CDefinition : public CNmTargetValueNode::CDefinition
{
	int16 m_nInputValueNodeIdx; // = -1
	bool m_bIsBoneSpaceOffset; // = true
	Quaternion m_rotationOffset; // = [ 0, 0, 0, 1 ]
	Vector m_translationOffset;
};
