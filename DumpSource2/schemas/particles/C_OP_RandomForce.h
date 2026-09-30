// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_RandomForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "min force"
	// MVectorIsCoordinate
	Vector m_MinForce;
	// MPropertyFriendlyName = "max force"
	// MVectorIsCoordinate
	Vector m_MaxForce;
};
