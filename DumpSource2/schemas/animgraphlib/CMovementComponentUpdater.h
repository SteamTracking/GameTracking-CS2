// MHasKV3TransferPolymorphicClassname
class CMovementComponentUpdater : public CAnimComponentUpdater
{
	CUtlVector< CSmartPtr< CAnimMotorUpdaterBase > > m_motors;
	CAnimInputDamping m_facingDamping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	int32 m_nDefaultMotorIndex;
	float32 m_flDefaultRunSpeed;
	bool m_bMoveVarsDisabled;
	bool m_bNetworkPath; // = true
	bool m_bNetworkFacing; // = true
	CAnimParamHandle[34] m_paramHandles; // = [ { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }, { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" } ]
};
