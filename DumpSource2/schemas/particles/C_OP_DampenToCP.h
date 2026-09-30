// MHasKV3TransferPolymorphicClassname
class C_OP_DampenToCP : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "falloff range"
	float32 m_flRange; // = 100
	// MPropertyFriendlyName = "dampen scale"
	float32 m_flScale; // = 1
};
