// MHasKV3TransferPolymorphicClassname
class CTwistConstraint : public CBaseConstraint
{
	bool m_bInverse;
	Quaternion m_qParentBindRotation; // = [ 0, 0, 0, 1 ]
	Quaternion m_qChildBindRotation; // = [ 0, 0, 0, 1 ]
};
