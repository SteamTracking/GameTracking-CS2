// MHasKV3TransferPolymorphicClassname
class C_OP_ControlPointToRadialScreenSpace : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "source Control Point in World"
	int32 m_nCPIn;
	// MPropertyFriendlyName = "Source Control Point offset"
	// MVectorIsCoordinate
	Vector m_vecCP1Pos;
	// MPropertyFriendlyName = "Set control point number"
	int32 m_nCPOut; // = 1
	// MPropertyFriendlyName = "Output field 0-2 X/Y/Z"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nCPOutField;
	// MPropertyFriendlyName = "Ss Pos and Dot OUT CP"
	int32 m_nCPSSPosOut; // = 4
};
