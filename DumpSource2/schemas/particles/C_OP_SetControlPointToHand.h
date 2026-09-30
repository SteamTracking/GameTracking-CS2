// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointToHand : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nCP1; // = 1
	// MPropertyFriendlyName = "hand"
	int32 m_nHand;
	// MPropertyFriendlyName = "control point offset"
	// MVectorIsCoordinate
	Vector m_vecCP1Pos;
	// MPropertyFriendlyName = "use hand orientation"
	bool m_bOrientToHand;
};
