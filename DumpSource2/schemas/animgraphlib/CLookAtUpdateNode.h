// MHasKV3TransferPolymorphicClassname
class CLookAtUpdateNode : public CUnaryUpdateNode
{
	LookAtOpFixedSettings_t m_opFixedSettings; // = { "m_attachment": { "m_influenceIndices": [ 0, 0, 0 ], "m_influenceOffsets": [ [ 0, 0, 0 ], [ 0, 0, 0 ], [ 0, 0, 0 ] ], "m_influenceRotations": [ [ 0, 0, 0, 0 ], [ 0, 0, 0, 0 ], [ 0, 0, 0, 0 ] ], "m_influenceWeights": [ 0, 0, 0 ], "m_numInfluences": 0 }, "m_bMaintainUpDirection": false, "m_bRotateYawForward": true, "m_bTargetIsPosition": true, "m_bUseHysteresis": false, "m_bones": [  ], "m_damping": { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }, "m_flHysteresisInnerAngle": 1, "m_flHysteresisOuterAngle": 20, "m_flPitchLimit": 45, "m_flYawLimit": 45 }
	AnimVectorSource m_target; // = "MoveDirection"
	CAnimParamHandle m_paramIndex; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_weightParamIndex; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	bool m_bResetChild;
	bool m_bLockWhenWaning;
};
