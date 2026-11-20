// MHasKV3TransferPolymorphicClassname
class CMovementComponentUpdater : public CAnimComponentUpdater
{
	CUtlVector< CSmartPtr< CAnimMotorUpdaterBase > > m_motors;
	CAnimInputDamping m_facingDamping;
	int32 m_nDefaultMotorIndex;
	float32 m_flDefaultRunSpeed;
	bool m_bMoveVarsDisabled;
	bool m_bNetworkPath; // = true
	bool m_bNetworkFacing; // = true
	CAnimParamHandle[34] m_paramHandles;
};
