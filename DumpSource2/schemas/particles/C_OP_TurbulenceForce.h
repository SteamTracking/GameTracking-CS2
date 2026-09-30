// MHasKV3TransferPolymorphicClassname
class C_OP_TurbulenceForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "noise scale 0"
	float32 m_flNoiseCoordScale0; // = 1
	// MPropertyFriendlyName = "noise scale 1"
	float32 m_flNoiseCoordScale1;
	// MPropertyFriendlyName = "noise scale 2"
	float32 m_flNoiseCoordScale2;
	// MPropertyFriendlyName = "noise scale 3"
	float32 m_flNoiseCoordScale3;
	// MPropertyFriendlyName = "noise amount 0"
	// MVectorIsCoordinate
	Vector m_vecNoiseAmount0; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "noise amount 1"
	// MVectorIsCoordinate
	Vector m_vecNoiseAmount1; // = [ 0.5, 0.5, 0.5 ]
	// MPropertyFriendlyName = "noise amount 2"
	// MVectorIsCoordinate
	Vector m_vecNoiseAmount2; // = [ 0.25, 0.25, 0.25 ]
	// MPropertyFriendlyName = "noise amount 3"
	// MVectorIsCoordinate
	Vector m_vecNoiseAmount3; // = [ 0.125, 0.125, 0.125 ]
};
