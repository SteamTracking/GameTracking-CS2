// MPropertyFriendlyName = "Prop Physics"
// MPropertyDescription = "Places a prop physics entity."
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_PropPhysics : public CSmartPropElement_ModelEntity
{
	// MPropertyDescription = "Should this physics prop start in a sleeping (non-simulating) state such that it won't update until it is woken up by an external event."
	CSmartPropAttributeBool m_bStartAsleep;
};
