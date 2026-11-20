// MHasKV3TransferPolymorphicClassname
class C_OP_ScreenSpaceRotateTowardTarget : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "target position"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecTargetPosition;
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "screen edge alignment distance"
	CPerParticleFloatInput m_flScreenEdgeAlignmentDistance;
};
