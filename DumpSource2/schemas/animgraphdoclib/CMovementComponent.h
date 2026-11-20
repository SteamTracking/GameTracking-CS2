// MHasKV3TransferPolymorphicClassname
class CMovementComponent : public CAnimGraphDoc_Component
{
	// MPropertySuppressField
	CUtlVector< CSmartPtr< CAnimGraphDoc_Motor > > m_motors;
	// MPropertyFriendlyName = "Network Path"
	bool m_bNetworkPath; // = true
	// MPropertyGroupName = "+Facing"
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_facingDamping;
	// MPropertyGroupName = "+Facing"
	// MPropertyFriendlyName = "Network Facing"
	bool m_bNetworkFacing; // = true
	// MPropertySuppressField
	AnimParamID[34] m_paramIDs;
};
