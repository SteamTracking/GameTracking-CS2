// MHasKV3TransferPolymorphicClassname
class C_OP_MovementMoveAlongSkinnedCPSnapshot : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nSnapshotControlPointNumber; // = 1
	// MPropertyFriendlyName = "set normal"
	bool m_bSetNormal;
	// MPropertyFriendlyName = "set radius"
	bool m_bSetRadius;
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Snapshot Index T Value"
	CPerParticleFloatInput m_flTValue;
};
